Return-Path: <io-uring+bounces-9142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E51BB2EB18
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20C461CC278A
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:09:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3572D8798;
	Thu, 21 Aug 2025 02:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qm1XAEcw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1852D8DCA
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742123; cv=none; b=qfDbf0yVrP0GkLIzlLvK2ia6aPTxO9VoqfFGiCCKYfoWIUauXXrqWuWc+D3sMo0Gb0gZen00/NG2pLT+mFGwmmAMy+T0haVIOh2dgpgdoBxt0AexBzl3MOb78mbCnQIlYtkFYbHQCJkr4Fjv1hBYWzLOfCeRFKR0YQybjkjh+qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742123; c=relaxed/simple;
	bh=4wqll17eCDEqlLJ2umwS9/LtojYSYPGerqVn0T7gudw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uT6WSStybec5je1JnmtiVMmZMLBNKaO+DNrg8OGn4KJ7EzENWEEqxK89JN7nMUvN1IxCqx4BaBiVN2c6kHdM2AHKyd5nwGlYMSeGY2eFRqEhGPIi4U1kT1zAhV+/CvxeBBhy5RAUzP34xYDBeTblWPtBqt5o68SLOfbpqJex2Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qm1XAEcw; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-323266b1d1aso396386a91.0
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742121; x=1756346921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6LMm2NEx+xhFakGK6W5HhwL7M6ZZE+Rn08bqF/2f0ac=;
        b=qm1XAEcweoMKP7kTICjrndI+J9G3OVGWuVSSW0GWCsx0WTAZjVUWKkqmnXOEBwVPM5
         eJJwO8k3AS0kJW216YaBtmqFdYhJ4lJgbREt9JRl6dph82PlzupX+d6RyfQwiVWX+ECq
         t35Bh+WmOiSyhlAuYRQPsRw/upoku4oWElFKwMfmkCwiXnqdq9D+OIGsMu7UC9Bm1zt0
         jzNyQX/ud2B6JDgSG3LTliI6SNy9byZsvAs3zfHMFWsV6yw69bnKtAJOJjpwU4mVVeso
         v1sC1iC+V+/fBH0Ji5hiGkwJeJByrktn4m3s1lnUVIcfV4o/1vM6kD9eCSD+2SmQiXPl
         oBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742121; x=1756346921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6LMm2NEx+xhFakGK6W5HhwL7M6ZZE+Rn08bqF/2f0ac=;
        b=UddbggLNiyS5+duPu61VvS3/tO7Ox5GD4IojPr8Nwaaa2IIf6WLoirZG8idmnPz4cu
         /idTzNJ5jTPjAWzm7zvUWJcHovJHp1/cPYFR7Mb9e+0zkhFMHqHFtdH3nRE+oTpvvyp9
         LAKcfpQeEwWb7XIYt0uuSglVS+l3uFXS0E+lg6ecLLPzg/t5TWD8eFXH5qlv1uNmNjw8
         sm2FPKtgzuP7uq2sc1EPKiTA+eqdm/IXd1yZ66PKw9PJZs8Gxa9BXBLt8gBh0fj6cC+X
         ZDZdCFEkHKFIT/dW/tk1+2WysN6Mbu9+NsuUHG9/v2t9XA1ElDtucbLNguG8raLhv9/D
         e70g==
X-Gm-Message-State: AOJu0Yx6XVOXsxBG0cLYR+MCHR725zX3f20TDpr9OKUHVRNrz+ist4xI
	ULB4qKl7XC9VDdmPQKQVbg9hE57eMqr8bKnvBFKNOGgySprsLEs1RKNPy0MkQyHdOpKUgKIj6jc
	CNF3O
X-Gm-Gg: ASbGnctkRjj9FZxdUNU0miuqj8y7ptMlRxDZUGwvuL/yrTxBC73gf1oKjpJMHg/n0XB
	8Z5nLyuu2y0uh9OX5n5ps1JCIcKTZUb/sgL5u7NMzW5tdH5LXmgI2wt8EjzK5H25MKDq4sEM0fR
	EBVozzHOGeoqLMxQfrwI2oM4HmRyD9Kf0LVUTak9pVObdbK6MdsqHsRRuT9ZrvWEADrSzH4flF/
	iQt6eT3RidlNUmJmAAarD/HaFhHCeicz8g5g6kHVoj6rWqnhFyttOWrXc714evh+pPJE4DUMdNh
	lhEze9SR9DPJqwFemuXNSHZ1L6NzJQHzjxAlF8i0awJwskW8T/A9IAdixSYpscjGQBaJnC3Zt5w
	FSJmYS0KMKxlMPl7/yoI4swRSh30O
X-Google-Smtp-Source: AGHT+IEIUqq4wA+Gr2va6kFY7OFiph/p/0doB/lsuI2/3hMnsxG4a/7afuVcgQSfwQFEPQNqsksmfA==
X-Received: by 2002:a17:90b:2b48:b0:31f:36da:3f85 with SMTP id 98e67ed59e1d1-324ed12d2a5mr1380586a91.17.1755742120600;
        Wed, 20 Aug 2025 19:08:40 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/12] io_uring/kbuf: use struct io_br_sel for multiple buffers picking
Date: Wed, 20 Aug 2025 20:03:36 -0600
Message-ID: <20250821020750.598432-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
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
index e14a43b125c3..b1723c2620da 100644
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
index 12dcc21f2259..8cff6a8244c0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -586,17 +586,16 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -609,7 +608,7 @@ static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
 	else
 		arg.mode |= KBUF_MODE_EXPAND;
 
-	ret = io_buffers_select(req, &arg, issue_flags);
+	ret = io_buffers_select(req, &arg, sel, issue_flags);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -638,6 +637,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -657,7 +657,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_bundle:
 	if (io_do_buffer_select(req)) {
-		ret = io_send_select_buffer(req, issue_flags, kmsg);
+		ret = io_send_select_buffer(req, issue_flags, &sel, kmsg);
 		if (ret)
 			return ret;
 	}
@@ -1015,6 +1015,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	struct io_br_sel sel = { };
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1035,7 +1036,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 retry_multishot:
 	if (io_do_buffer_select(req)) {
-		struct io_br_sel sel;
 		size_t len = sr->len;
 
 		sel = io_buffer_select(req, &len, sr->buf_group, issue_flags);
@@ -1099,7 +1099,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg,
-			      size_t *len, unsigned int issue_flags)
+			      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	int ret;
@@ -1124,15 +1124,15 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
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
 
@@ -1153,14 +1153,13 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
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
@@ -1175,11 +1174,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1196,7 +1195,8 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
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


