Return-Path: <io-uring+bounces-9119-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA03B2E4E5
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04BBA1CC23F6
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED60F274650;
	Wed, 20 Aug 2025 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2MVd9OHn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F60279DC6
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714378; cv=none; b=cXE79deSAmN9vqIBPVmIk1NZF/JepSyVfS8U4xcfMWyu4BIl/X5FSFgrSiWNjmK/PjxnYhJ3S+8x8U/fnd/SkQbcAG/c1rEqeahZ1/oStDgasQZSIYzE71mV/82qGD4pQw3nD4Qu7xq+E4iQdGNsmowMuLMLtgLCE/8/3IGRc1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714378; c=relaxed/simple;
	bh=S6DcIqWlcUl1A0OdL42aT8oAKdckzbsx+E+bOYdmcx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQC6fqrUv6H5VnBSnIYQ9PuA+H3mN7ZJU0Rp0fYfc0JpdbdncdpTWTpbp9Ckdb7YxvijdE2brk6yO/B7mBT7oo3mbVI+OC5bN1BFDoUbLmKtIenOdgUFub4nr4AnR4GbsGnuivyR0h97bp2p4VHhc/I1R0Q1l5q2RxxVEKL7SWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2MVd9OHn; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-88432cbe172so2016139f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714375; x=1756319175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n2W2fnVsnpiuWOl7/e8A4URG3c/jCh8owwHlDS84U4c=;
        b=2MVd9OHnVNL1tFOEK+fn1U+v3EWaSbZJ2tBnLwLItkSNUlNUaGx1eOpbEZzJCkJG4O
         gW7F0RipjvhU9JHPlnkPOnyO5MpC+0EKc6yFIMwBdsZsU6K70EMSeRMTI6tyXoOGSjGZ
         /P7asU0TjJ1vAm2Dkbww9YgzcMbuRUFINVOwGACA/q7l2GyFTh7ZjMHT9pO5reId4DKP
         Y/MzYvULUFMui92oIg7YY8Uto1d5giosuTwOaH6qnGO2hhLB5GcQn9vw6R8UFB1J6liO
         //GQhmsBONLnQX7mKfOf6l1chwrFwXSvIeAcSW9sENg43/0D93rQqIaX6HI8/Wp0Vq2I
         Cwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714375; x=1756319175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2W2fnVsnpiuWOl7/e8A4URG3c/jCh8owwHlDS84U4c=;
        b=sLt9kcDjGBntk6moy7QTX0+Dg3Gd/Ou6WjICscmA+6xHTbSGCvFwKqJp0+ySsrVQTJ
         fmunKJVO4beGr2zc8W9OkC6nfswHXb72qKN9PUGhUspUE2tLujqDK5kCII40nMyi9dNN
         FrQ06jqIUjQd8uev2iaVaJO6ANNoh3QhY1k1c4wD2Fd2ySpXR3YMyFQpEXca7cyg6H1q
         q6xI8L0Wx/jqkOchGP/+y3SaKD3/3Tvsg4VBptW+dwjE+m0DeVqYPuxVG5RrPJfoQZz+
         Cy1fH3Ypcga9FYTKhMIChqceuNuqr0fLhs3hKNOKISz2+XBaqFsB+Ikhi9OZLukX5PS5
         Y1Jw==
X-Gm-Message-State: AOJu0YxJd+uAnKv7V3kTZ8jRrrX6DNYT7hMTwRTE+LgBj60Hqg5V8g7L
	Pt2Z0T4EdM2SwtKxlcV31c3qBeA7qPgF/jKVm/VyH834OwSd6/TXeb3Yq8lnBXD7qhHrvoEau35
	YRey4
X-Gm-Gg: ASbGncsshQMTaakUljSmAlhxAnsxdRpXH6iPAniMNtzr3njtvFXEOte0kBjJ+OJ2EzE
	du44563ypNZRtYy2cYT1HkG6RsHgXP/jbfjU1I6NHTplqnJcWIa1NG10KLhgrVt8YRuhfSux8Hi
	BK4ktOhC6cI6nRIaGl2OKtiepkjcVPkQoGW6b0ckk9QiNe4zUrrqlSgknByqe80eIXVyNNzNRtI
	n4fEYoPYa4Nczsdk3LrX/17kkH5nPNoLMDFQOT1P2JaOxU4+9D7XQyTyRdmReBGgNCB49rz8ZOR
	sp9faqSILxSWQBHq+DdmwU8aC+35EgiFvYZmCw4icnzqVnhqXsWfpL9CP46rYSkBBIqnkH+J7j9
	VBWQIfvUaCDlkN/20
X-Google-Smtp-Source: AGHT+IHHP9jrBuyraI+McUixI+Q8WyGBzb8uvrXLtZ3GzNV0PFgi9cHYht/M7TJ656fysDSxz5HPUA==
X-Received: by 2002:a05:6602:6423:b0:86d:d6:5687 with SMTP id ca18e2360f4ac-884718b7eccmr909314139f.6.1755714375339;
        Wed, 20 Aug 2025 11:26:15 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring/kbuf: use struct io_br_sel for multiple buffers picking
Date: Wed, 20 Aug 2025 12:22:52 -0600
Message-ID: <20250820182601.442933-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The networking side uses bundles, which is picking multiple buffers at
the same time. Pass in struct io_br_sel to those helpers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c |  5 +++--
 io_uring/kbuf.h |  5 +++--
 io_uring/net.c  | 38 +++++++++++++++++++-------------------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 61d9a8d439ba..21c12c437ab9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -299,7 +299,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 }
 
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
-		      unsigned int issue_flags)
+		      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
@@ -331,7 +331,8 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 	return ret;
 }
 
-int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
+int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
+		    struct io_br_sel *sel)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 8f97b033bd73..86542ae759f4 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -80,8 +80,9 @@ struct io_br_sel {
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
-		      unsigned int issue_flags);
-int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
+		      struct io_br_sel *sel, unsigned int issue_flags);
+int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
+		    struct io_br_sel *sel);
 void io_destroy_buffers(struct io_ring_ctx *ctx);
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
diff --git a/io_uring/net.c b/io_uring/net.c
index 8efa207f8125..d777a04ff201 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -587,17 +587,16 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
-				 struct io_async_msghdr *kmsg)
+				 struct io_br_sel *sel, struct io_async_msghdr *kmsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-
-	int ret;
 	struct buf_sel_arg arg = {
 		.iovs = &kmsg->fast_iov,
 		.max_len = min_not_zero(sr->len, INT_MAX),
 		.nr_iovs = 1,
 		.buf_group = sr->buf_group,
 	};
+	int ret;
 
 	if (kmsg->vec.iovec) {
 		arg.nr_iovs = kmsg->vec.nr;
@@ -610,7 +609,7 @@ static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
 	else
 		arg.mode |= KBUF_MODE_EXPAND;
 
-	ret = io_buffers_select(req, &arg, issue_flags);
+	ret = io_buffers_select(req, &arg, sel, issue_flags);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -639,6 +638,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -658,7 +658,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_bundle:
 	if (io_do_buffer_select(req)) {
-		ret = io_send_select_buffer(req, issue_flags, kmsg);
+		ret = io_send_select_buffer(req, issue_flags, &sel, kmsg);
 		if (ret)
 			return ret;
 	}
@@ -1017,6 +1017,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1037,7 +1038,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		struct io_br_sel sel;
 		size_t len = sr->len;
 
 		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
@@ -1101,7 +1101,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg,
-			      size_t *len, unsigned int issue_flags)
+			      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
@@ -1126,15 +1126,15 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			arg.mode |= KBUF_MODE_FREE;
 		}
 
-		if (*len)
-			arg.max_len = *len;
+		if (sel->val)
+			arg.max_len = sel->val;
 		else if (kmsg->msg.msg_inq > 1)
-			arg.max_len = min_not_zero(*len, (size_t) kmsg->msg.msg_inq);
+			arg.max_len = min_not_zero(sel->val, (size_t) kmsg->msg.msg_inq);
 
 		/* if mshot limited, ensure we don't go over */
 		if (sr->flags & IORING_RECV_MSHOT_LIM)
 			arg.max_len = min_not_zero(arg.max_len, sr->mshot_total_len);
-		ret = io_buffers_peek(req, &arg);
+		ret = io_buffers_peek(req, &arg, sel);
 		if (unlikely(ret < 0))
 			return ret;
 
@@ -1155,14 +1155,13 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
 	} else {
-		struct io_br_sel sel;
+		size_t len = sel->val;
 
-		*len = sr->len;
-		sel = io_buffer_select(req, len, sr->buf_group, issue_flags);
-		if (!sel.addr)
+		*sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
+		if (!sel->addr)
 			return -ENOBUFS;
-		sr->buf = sel.addr;
-		sr->len = *len;
+		sr->buf = sel->addr;
+		sr->len = len;
 map_ubuf:
 		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
 				  &kmsg->msg.msg_iter);
@@ -1177,11 +1176,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
-	size_t len = sr->len;
 	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
@@ -1198,7 +1197,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
+		sel.val = sr->len;
+		ret = io_recv_buf_select(req, kmsg, &sel, issue_flags);
 		if (unlikely(ret < 0)) {
 			kmsg->msg.msg_inq = -1;
 			goto out_free;
-- 
2.50.1


