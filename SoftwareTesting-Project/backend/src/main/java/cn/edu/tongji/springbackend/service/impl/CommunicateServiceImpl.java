package cn.edu.tongji.springbackend.service.impl;

import cn.edu.tongji.springbackend.dto.AddCommentRequest;
import cn.edu.tongji.springbackend.dto.CommentInfo;
import cn.edu.tongji.springbackend.dto.ReplyCommentRequest;
import cn.edu.tongji.springbackend.exceptions.CommentException;
import cn.edu.tongji.springbackend.mapper.CommentMapper;
import cn.edu.tongji.springbackend.model.Comment;
import cn.edu.tongji.springbackend.service.CommunicateService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class CommunicateServiceImpl implements CommunicateService {
    @Resource
    private CommentMapper commentMapper;

    private void getCommentRecursive(List<CommentInfo> list, final Map<Integer, List<Comment>> commentMap, final int fatherId) {
        List<Comment> comments = commentMap.get(fatherId);
        if (comments == null)
            return;

        for (Comment comment : comments) {
            List<CommentInfo> children = new ArrayList<>();
            getCommentRecursive(children, commentMap, comment.getCmtId());  //获取孩子集合

            list.add(new CommentInfo(
                    comment.getCmtId(),
                    comment.getCmtContent(),
                    comment.getCmtTime(),
                    comment.getUserId(),
                    children
            ));
        }
    }

    @Override
    public List<CommentInfo> getCommentByActId(int actId) {
        Map<Integer, List<Comment>> commentMap = new HashMap<>();  //父评论id到子评论的映射
        List<CommentInfo> ret = new ArrayList<>();

        for (Comment comment : commentMapper.getByActId(actId)) {
            List<Comment> value = commentMap.get(comment.getCmtFather());

            if (value == null) {
                value = new ArrayList<>();
                value.add(comment);
                commentMap.put(comment.getCmtFather(), value);
            }
            else {
                value.add(comment);
            }
        }

        getCommentRecursive(ret, commentMap, 0);
        return ret;
    }

    @Override
    public CommentInfo getDetailedCommentByCmtId(int cmtId) {
        Queue<Integer> openList = new LinkedList<>();
        Comment root = commentMapper.getByCmtId(cmtId);

        if (root == null) {
            throw new CommentException("root comment not found");
        }

        CommentInfo ret = new CommentInfo(
                root.getCmtId(),
                root.getCmtContent(),
                root.getCmtTime(),
                root.getUserId(),
                new ArrayList<>()
        ), pointer = ret;
        openList.add(cmtId);

        while (!openList.isEmpty()) {
            final int current = openList.poll();
            List<Integer> children = commentMapper.getChildIdsByCmtId(current);

            if (current == root.getCmtId() && children.isEmpty()) {
                throw new CommentException("no children comments");
            }

            for (Integer child : children) {
                Comment childComment = commentMapper.getByCmtId(child);
                CommentInfo childInfo = new CommentInfo(
                        childComment.getCmtId(),
                        childComment.getCmtContent(),
                        childComment.getCmtTime(),
                        childComment.getUserId(),
                        new ArrayList<>()
                );
                pointer.getChildren().add(childInfo);
                openList.add(childComment.getCmtId());
            }

            for (CommentInfo child : pointer.getChildren()) {
                if (Objects.equals(child.getCmtId(), openList.peek())) {
                    pointer = child;
                    break;
                }
            }
        }

        return ret;
    }

    @Override
    public String getCommentByCmtId(int cmtId) {
        return commentMapper.getByCmtId(cmtId).getCmtContent();
    }

    @Override
    public void addComment(AddCommentRequest addCommentRequest) {
        if (addCommentRequest.getCmtContent() == null
                || Objects.equals(addCommentRequest.getCmtContent(), "")) {
            throw new CommentException("comment content is empty");
        }

        else if (addCommentRequest.getCmtContent().length() > 1024) {
            throw new CommentException("comment length exceeded");
        }

        commentMapper.add(Comment.builder()
                .cmtFather(0)
                .cmtContent(addCommentRequest.getCmtContent())
                .cmtTime(addCommentRequest.getCmtTime())
                .actId(addCommentRequest.getActId())
                .userId(addCommentRequest.getUserId())
                .build()
        );
    }

    @Override
    public void replyComment(ReplyCommentRequest replyCommentRequest) {
        Comment father = commentMapper.getByCmtId(replyCommentRequest.getCmtFather());

        if (father == null) {
            throw new CommentException("replying nonexistent comment");
        }

        else if (!Objects.equals(father.getActId(), replyCommentRequest.getActId())) {
            throw new CommentException("activity id not consistent with father");
        }

        else if (replyCommentRequest.getCmtContent() == null
                || Objects.equals(replyCommentRequest.getCmtContent(), "")) {
            throw new CommentException("comment content is empty");
        }

        else if (replyCommentRequest.getCmtContent().length() > 1024) {
            throw new CommentException("comment length exceeded");
        }

        commentMapper.add(Comment.builder()
                .cmtFather(replyCommentRequest.getCmtFather())
                .cmtContent(replyCommentRequest.getCmtContent())
                .cmtTime(replyCommentRequest.getCmtTime())
                .actId(replyCommentRequest.getActId())
                .userId(replyCommentRequest.getUserId())
                .build()
        );
    }

    @Override
    public void deleteComment(int cmtId) {
        if (commentMapper.getByCmtId(cmtId) == null) {
            throw new CommentException("deleting nonexistent comment");
        }

        Queue<Integer> openList = new LinkedList<>();
        openList.add(cmtId);

        while (!openList.isEmpty()) {
            final int current = openList.poll();
            openList.addAll(commentMapper.getChildIdsByCmtId(current));
            commentMapper.delete(current);
        }
    }
}
