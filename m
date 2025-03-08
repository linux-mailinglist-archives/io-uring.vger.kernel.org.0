Return-Path: <io-uring+bounces-7034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB93A57C44
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 18:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F87F7A6CDA
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 17:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B3F1AC882;
	Sat,  8 Mar 2025 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImF9er5d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5C71537A7
	for <io-uring@vger.kernel.org>; Sat,  8 Mar 2025 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741454329; cv=none; b=OjZoVzb9tg1ezFJbA1vj5NIWrLdpy1Mn4I4Hvn77iV/dqlNSp2LMgwYl2e/ipRrYf6e3A7gsh8jRMnHy72DoDe6zSWfvjBK5ob01alld3iEhlPgKGGMYm9Pute+PUUkMlw0UpGQMY+2KO0L5ARujvnvBlus6SgMZ7ppu//i0x2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741454329; c=relaxed/simple;
	bh=6i80ovfyORr/yhpKrJOs36/bZR5GrUw7XKI3ji4sT7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWGDuFkI0IbsRUw8ghu7cNobdd8AqNy9nGDwJMwHJzGp3Sk4hikQ9zpIrSN+y13zqwhant4Iyiye2f8oyyUbA+eo1bj9ey24xE+oc9pD+ONHpnLCaMeYL+Eiz21dxy4JWveevrwUMXSnpLVLlpu/RSDnow3QQzRkUhbjOm/ST1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImF9er5d; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3913d129c1aso319485f8f.0
        for <io-uring@vger.kernel.org>; Sat, 08 Mar 2025 09:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741454325; x=1742059125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LtqE12gnw7EN2lb/Iz3kGSiNacNbNCkQGVrgI9+v/qo=;
        b=ImF9er5d2te8nxOx2ysYJOfVMeMYTpRy5HXc8Wrx0ppTsrKCLxvrSvBBjn10GkkoWc
         5+40oTopE7GeqrJ/oDz7Z06fiB7N5xXuADKlri+uHesMIPqiutclUuJjCnOnDgAFQWQ3
         YtikcnW9P/ct5a2qImG6cQBZD4VNREd4K8OHHjZjDIU3C7b9fmPOtUhFa/2B28yM45ZU
         Rio6BKBxGEU6MVyBYA9oYWUOTCxmuDU9tl9iSJvEglZhRpFAb2TYRJ18y4eLfJxRelqf
         1pAjvIXs7kNi4sDhGcEzLU2osa+1D1tdAhM/J9wmNAxZYSmL3LzeIxX46EKGkeofJotN
         4xhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741454325; x=1742059125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LtqE12gnw7EN2lb/Iz3kGSiNacNbNCkQGVrgI9+v/qo=;
        b=GQr6XLbSdDS1T+ocf/UY7QGjV/tMbrYGTBIJPpAcm4o5VrQoOLjiYmEBb42QbQlH8P
         znRV+mbIdOYm93Lkw8y7xu1YoaYIHgPn3zrdXKS3uzV3tlgcFDc+73OFE1b8MiA78Fos
         SZWJjSd3cPquEyoHtnIls+zesuvYRLmPdcIqBknnKrWiV28vjvLMqqfnhxjTo6dKxwHJ
         i1juBAvnWcR/AERW1Roy8Z/b3yhR/JieUn0mOZ2XDYbr0/pYeDQhazigEYNOc1WLarb2
         VdX8BDrd2clD++dDgREZOx3BQbdS0m1DzDpu/p8z3K59ljfDApB1IfdHwSjpd+mEKcsR
         nodA==
X-Gm-Message-State: AOJu0Yw6rbjVLYnK0TY6wGzn7ZiCTcVGjKvbAkqkd0XrXG+XFz24vwPF
	GrQxOOXYwm5MgXbGGwWW4VqXoFUSXVAjRQGUBGOldhkp6pPfCTG2HQyPGQ==
X-Gm-Gg: ASbGnctX2nWXRISDVGGB1ejfBnpl191lOrwY6U6KKT0FBj7d5QVgrEL0qDx83JmsSkV
	ewJHvBXawNjqZ5VcUS5vyV6Cxi9yIZ720j8fGgUnIaSIFTLqp5gJJKc34Glujh7+qG26cWf3tvQ
	3jKsUFSU4VstKjkxcSdumnXbqoSVITnuL+NcFlvbK7+0rI1OHMzq13C3wSfrJfPyUIR6a9SKx16
	I7txxwOERIg64WI82sqYqtvjIWiO8l2anEiuz/WdVqPShZo/e3Ayn78/VcqzhGMPKv8t1XOAHvv
	l8DBCVF9+cPDKX0Mbyq2+4knCJjAYkYhf/V+jOvrWLR7nyEayIsquCCvog==
X-Google-Smtp-Source: AGHT+IEUpmQxacOa9j1ObadDbtMeuX8nBeeQCI7UfrPW4UX+7/RqYJN1T97JzxCcEnpb3Si6WsY+PQ==
X-Received: by 2002:a5d:6d8a:0:b0:38d:d166:d44 with SMTP id ffacd0b85a97d-3913af38f92mr2562472f8f.23.1741454324903;
        Sat, 08 Mar 2025 09:18:44 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c015c2csm9196679f8f.49.2025.03.08.09.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 09:18:42 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: return -EAGAIN to continue multishot
Date: Sat,  8 Mar 2025 17:19:32 +0000
Message-ID: <da117b79ce72ecc3ab488c744e29fae9ba54e23b.1741453534.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741453534.git.asml.silence@gmail.com>
References: <cover.1741453534.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multishot errors can be mapped 1:1 to normal errors, but there are not
identical. It leads to a peculiar situation where all multishot requests
has to check in what context they're run and return different codes.

Unify them starting with EAGAIN / IOU_ISSUE_SKIP_COMPLETE(EIOCBQUEUED)
pair, which mean that core io_uring still owns the request and it should
be retried. In case of multishot it's naturally just continues to poll,
otherwise it might poll, use iowq or do any other kind of allowed
blocking. Introduce IOU_RETRY aliased to -EAGAIN for that.

Apart from obvious upsides, multishot can now also check for misuse of
IOU_ISSUE_SKIP_COMPLETE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  4 +---
 io_uring/io_uring.h |  8 ++++++++
 io_uring/net.c      | 47 ++++++++++++++-------------------------------
 io_uring/poll.c     |  3 ++-
 io_uring/rw.c       | 11 ++++-------
 5 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fa342be39158..6499d8e4d3d0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1791,10 +1791,8 @@ int io_poll_issue(struct io_kiocb *req, io_tw_token_t tw)
 
 	ret = __io_issue_sqe(req, issue_flags, &io_issue_defs[req->opcode]);
 
+	WARN_ON_ONCE(ret == IOU_ISSUE_SKIP_COMPLETE);
 	WARN_ON_ONCE(ret == IOU_OK);
-
-	if (ret == IOU_ISSUE_SKIP_COMPLETE)
-		ret = 0;
 	return ret;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index daf0e3b740ee..3409740f6417 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -22,6 +22,14 @@ enum {
 	IOU_OK			= 0,
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 
+	/*
+	 * The request has more work to do and should be retried. io_uring will
+	 * attempt to wait on the file for eligible opcodes, but otherwise
+	 * it'll be handed to iowq for blocking execution. It works for normal
+	 * requests as well as for the multi shot mode.
+	 */
+	IOU_RETRY		= -EAGAIN,
+
 	/*
 	 * Requeue the task_work to restart operations on this request. The
 	 * actual value isn't important, should just be not an otherwise
diff --git a/io_uring/net.c b/io_uring/net.c
index 34a28689ec99..d9befb6fb8a7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -898,8 +898,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	 */
 	if ((req->flags & REQ_F_APOLL_MULTISHOT) && !mshot_finished &&
 	    io_req_post_cqe(req, *ret, cflags | IORING_CQE_F_MORE)) {
-		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
-
+		*ret = IOU_RETRY;
 		io_mshot_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
@@ -907,12 +906,9 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 				return false;
 			/* mshot retries exceeded, force a requeue */
 			sr->nr_multishot_loops = 0;
-			mshot_retry_ret = IOU_REQUEUE;
+			if (issue_flags & IO_URING_F_MULTISHOT)
+				*ret = IOU_REQUEUE;
 		}
-		if (issue_flags & IO_URING_F_MULTISHOT)
-			*ret = mshot_retry_ret;
-		else
-			*ret = -EAGAIN;
 		return true;
 	}
 
@@ -1070,16 +1066,15 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if (issue_flags & IO_URING_F_MULTISHOT) {
+			if (issue_flags & IO_URING_F_MULTISHOT)
 				io_kbuf_recycle(req, issue_flags);
-				return IOU_ISSUE_SKIP_COMPLETE;
-			}
-			return -EAGAIN;
+
+			return IOU_RETRY;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return IOU_RETRY;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1207,12 +1202,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_recvmsg(sock, &kmsg->msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if (issue_flags & IO_URING_F_MULTISHOT) {
+			if (issue_flags & IO_URING_F_MULTISHOT)
 				io_kbuf_recycle(req, issue_flags);
-				return IOU_ISSUE_SKIP_COMPLETE;
-			}
 
-			return -EAGAIN;
+			return IOU_RETRY;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
@@ -1312,10 +1305,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 			return IOU_STOP_MULTISHOT;
 		return IOU_OK;
 	}
-
-	if (issue_flags & IO_URING_F_MULTISHOT)
-		return IOU_ISSUE_SKIP_COMPLETE;
-	return -EAGAIN;
+	return IOU_RETRY;
 }
 
 void io_send_zc_cleanup(struct io_kiocb *req)
@@ -1692,16 +1682,9 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
 		if (ret == -EAGAIN && force_nonblock &&
-		    !(accept->iou_flags & IORING_ACCEPT_DONTWAIT)) {
-			/*
-			 * if it's multishot and polled, we don't need to
-			 * return EAGAIN to arm the poll infra since it
-			 * has already been done
-			 */
-			if (issue_flags & IO_URING_F_MULTISHOT)
-				return IOU_ISSUE_SKIP_COMPLETE;
-			return ret;
-		}
+		    !(accept->iou_flags & IORING_ACCEPT_DONTWAIT))
+			return IOU_RETRY;
+
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	} else if (!fixed) {
@@ -1720,9 +1703,7 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	    io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || arg.is_empty == -1)
 			goto retry;
-		if (issue_flags & IO_URING_F_MULTISHOT)
-			return IOU_ISSUE_SKIP_COMPLETE;
-		return -EAGAIN;
+		return IOU_RETRY;
 	}
 
 	io_req_set_res(req, ret, cflags);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 176854882ba6..52e3c3e923f4 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -289,11 +289,12 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
 			}
 		} else {
 			int ret = io_poll_issue(req, tw);
+
 			if (ret == IOU_STOP_MULTISHOT)
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			else if (ret == IOU_REQUEUE)
 				return IOU_POLL_REQUEUE;
-			if (ret < 0)
+			if (ret != IOU_RETRY && ret < 0)
 				return ret;
 		}
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index bf35599d1078..9a9c636defad 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1068,9 +1068,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		if (io_kbuf_recycle(req, issue_flags))
 			rw->len = 0;
-		if (issue_flags & IO_URING_F_MULTISHOT)
-			return IOU_ISSUE_SKIP_COMPLETE;
-		return -EAGAIN;
+		return IOU_RETRY;
 	} else if (ret <= 0) {
 		io_kbuf_recycle(req, issue_flags);
 		if (ret < 0)
@@ -1088,16 +1086,15 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
-			if (issue_flags & IO_URING_F_MULTISHOT) {
+			if (issue_flags & IO_URING_F_MULTISHOT)
 				/*
 				 * Force retry, as we might have more data to
 				 * be read and otherwise it won't get retried
 				 * until (if ever) another poll is triggered.
 				 */
 				io_poll_multishot_retry(req);
-				return IOU_ISSUE_SKIP_COMPLETE;
-			}
-			return -EAGAIN;
+
+			return IOU_RETRY;
 		}
 	}
 
-- 
2.48.1


