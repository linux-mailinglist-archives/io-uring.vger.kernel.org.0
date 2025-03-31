Return-Path: <io-uring+bounces-7319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD589A76BC5
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:17:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 193833A3852
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A062214815;
	Mon, 31 Mar 2025 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fc0ZGnlk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA27136347
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437814; cv=none; b=IzIgQfbyJwIXnAHBEQVIEB/WyNiJW+5TDoYa2EZvmtbhPHocuOOZvTFForRRez36slTeYyfSMKMPYfI8L9iUFap3tL5t4o8i1E83cjq15J+iO6yczxE9OWUT199pe0BlK7qGJc6/xwEZn1XC1nRpf4OijP+tjUkDpL5M9u1JN1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437814; c=relaxed/simple;
	bh=npLUQU55b0EZbI0o2Um44S6Cbhksqqe7Wl2p10DJaMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSYqugGxTeIMDjAtm6R7wl2kfyItt7rhJNrVTHeag0F25+/8ajuG5Jij+Vorl6UWMWaK+NQSJdIjZF+LOSiBL0Kp8d0ez91/jsEctsLlsqM2yMWPSSKwB0wfv4l6xpmOa0Xpo5sMoDraStT5jc+bB2RFlaG2PhQMOYxHOJcaQ4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fc0ZGnlk; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5e5deb6482cso10155053a12.1
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743437810; x=1744042610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E+oCPSqEX4ZH52fmLnwS4QA4UVTjB8r+bCxG5vmnWVk=;
        b=Fc0ZGnlksF1kid8SHtvwGYJQFbS4YT6oZTYq+LW5MfCOEZxCNMAwtcDWfc40RqfVlG
         svFKAeLfFmdK6BTihBcp7qluVWOkpt4iO/Kdb/xXjjB1rtWNU2FOJp8oAk8XXqCH38+G
         8bdVfunezo8ev16mGqV8QUFKM0R1n8d71XtxnM/yM4QLlmiNSp6eckpZy+LIUslQnggq
         T/G+leWdFB8LWG1Xz073N0vg/b/SQWv7he5opXMm34ROAz/azVnyP+beFdcqqJLsqW+t
         87SOPUtdxOmTQhrz4zYCk3Z7Xcsjiuk8xqExvwvDdMx4OlYbWV93SdIePKVxYVZsicc7
         g+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437810; x=1744042610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E+oCPSqEX4ZH52fmLnwS4QA4UVTjB8r+bCxG5vmnWVk=;
        b=xNUg30Ju3KGnmJ2NKeWiUph479eDIms3FcpG8mMs5tCoNtshPl2sQNFthCkO2VMN/N
         cwmPrqlG/B0Ec6zL0QcGMJVZfwsvoIZPd78MNV3B8JBd6zqWbhRFeVrhpHRiGQ6jkJXn
         BtLb59nVfliFdHxjZoyI5fqNDXSg6xjnvcK7SmjVR51FbZBeqsmULyES87UeW3V6ib4t
         KVaZDHsl9LFoi6/ukPE0rMScBC7qYFGLgHf74uqUs7fRNPXXhskYE6fx2ZDusAQGBGq/
         nlNT4EWxWGIl6nSLe7LNb3fuZnvml/KYjzW7ULnFTT2RcmfMPXjWjmX5YGulPXLiHL72
         fQRQ==
X-Gm-Message-State: AOJu0YwbAel1Tr6Lypkq3Uap9jxO2ZNA4W8y2np+Qw8OXxmwnfD8XHrX
	exLF4WYKPCVgjKTMSMCw/JCt/fNipSIsE7Y0BUT9eVafxLtmO/7pEOyozg==
X-Gm-Gg: ASbGnctxhp6b+yuRUBVTq7D/8BdH3KP6q/gxBFegpgFHX3AzegM0Cc9GcCjVjEHVSOB
	It1EbW468y0AdLgGg9viqwKjOUYlyvAI+8HDs/R71/YegHucau1egqDHfCyg0+cu2HH2qKpG7em
	Hkt6+tZ6MngQiuNkSUlG//f/DeZ6Mz6Ad/UuLi5r1RlPGf/pcOBt+RdRUOtDE5XEraIFE06t63Q
	/xj1WBwWxrpJbACkqU7z0UE7fqjnRRbNascnN77aE5ezrl23zwx8O05bYuE0JPupI4I0l/sja25
	+dAqI41b0q5D1CE8S5dGo90vyZsY
X-Google-Smtp-Source: AGHT+IF647mTHYaFbvvihEu3kggpxo3yu3Tt51LE6pn6JU2faM+ABNH1A2WpoXRCNP+eEQ0xSxpEWQ==
X-Received: by 2002:a05:6402:26c2:b0:5e5:334e:86d9 with SMTP id 4fb4d7f45d1cf-5edc4652614mr10025754a12.13.1743437810039;
        Mon, 31 Mar 2025 09:16:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f457])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d2dd0sm5861458a12.21.2025.03.31.09.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:16:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/5] io_uring/kbuf: pass bgid to io_buffer_select()
Date: Mon, 31 Mar 2025 17:18:01 +0100
Message-ID: <a210d6427cc3f4f42271a6853274cd5a50e56820.1743437358.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743437358.git.asml.silence@gmail.com>
References: <cover.1743437358.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current situation with buffer group id juggling is not ideal.
req->buf_index first stores the bgid, then it's overwritten by a buffer
id, and then it can get restored back no recycling / etc. It's not so
easy to control, and it's not handled consistently across request types
with receive requests saving and restoring the bgid it by hand.

It's a prep patch that adds a buffer group id argument to
io_buffer_select(). The caller will be responsible for stashing a copy
somewhere and passing it into the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c | 4 ++--
 io_uring/kbuf.h | 2 +-
 io_uring/net.c  | 9 ++++-----
 io_uring/rw.c   | 5 ++++-
 io_uring/rw.h   | 2 ++
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3478be6d02ab..eb9a48b936bd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -186,7 +186,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 }
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned int issue_flags)
+			      unsigned buf_group, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
@@ -194,7 +194,7 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
-	bl = io_buffer_get_list(ctx, req->buf_index);
+	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
 		if (bl->flags & IOBL_BUF_RING)
 			ret = io_ring_buffer_select(req, len, bl, issue_flags);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 2ec0b983ce24..09129115f3ef 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -58,7 +58,7 @@ struct buf_sel_arg {
 };
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-			      unsigned int issue_flags);
+			      unsigned buf_group, unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		      unsigned int issue_flags);
 int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
diff --git a/io_uring/net.c b/io_uring/net.c
index bddf41cdd2b3..6b7d3b64a441 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -407,13 +407,12 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+	if (req->flags & REQ_F_BUFFER_SELECT)
+		sr->buf_group = req->buf_index;
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		if (req->opcode == IORING_OP_SENDMSG)
 			return -EINVAL;
-		if (!(req->flags & REQ_F_BUFFER_SELECT))
-			return -EINVAL;
 		sr->msg_flags |= MSG_WAITALL;
-		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 		req->flags |= REQ_F_MULTISHOT;
 	}
@@ -980,7 +979,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		void __user *buf;
 		size_t len = sr->len;
 
-		buf = io_buffer_select(req, &len, issue_flags);
+		buf = io_buffer_select(req, &len, sr->buf_group, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
 
@@ -1090,7 +1089,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		void __user *buf;
 
 		*len = sr->len;
-		buf = io_buffer_select(req, len, issue_flags);
+		buf = io_buffer_select(req, len, sr->buf_group, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
 		sr->buf = buf;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 246b22225919..bdf7df19fab2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -119,7 +119,7 @@ static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
 		return io_import_vec(ddir, req, io, buf, sqe_len);
 
 	if (io_do_buffer_select(req)) {
-		buf = io_buffer_select(req, &sqe_len, issue_flags);
+		buf = io_buffer_select(req, &sqe_len, io->buf_group, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
 		rw->addr = (unsigned long) buf;
@@ -253,16 +253,19 @@ static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			int ddir)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_async_rw *io;
 	unsigned ioprio;
 	u64 attr_type_mask;
 	int ret;
 
 	if (io_rw_alloc_async(req))
 		return -ENOMEM;
+	io = req->async_data;
 
 	rw->kiocb.ki_pos = READ_ONCE(sqe->off);
 	/* used for fixed read/write too - just read unconditionally */
 	req->buf_index = READ_ONCE(sqe->buf_index);
+	io->buf_group = req->buf_index;
 
 	ioprio = READ_ONCE(sqe->ioprio);
 	if (ioprio) {
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 81d6d9a8cf69..129a53fe5482 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -16,6 +16,8 @@ struct io_async_rw {
 		struct iov_iter			iter;
 		struct iov_iter_state		iter_state;
 		struct iovec			fast_iov;
+		unsigned			buf_group;
+
 		/*
 		 * wpq is for buffered io, while meta fields are used with
 		 * direct io
-- 
2.48.1


