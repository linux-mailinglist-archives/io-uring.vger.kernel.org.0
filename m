Return-Path: <io-uring+bounces-7320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B817A76BCA
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 18:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5C3B16779C
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 16:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AD78214814;
	Mon, 31 Mar 2025 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HLX1+awZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60310214810
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 16:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437816; cv=none; b=H0PWXibph3YojYqSX6f9HNJBUmt/GuO6Qb4cTqFwWFv+LNYv/EvEX+3IiWGiG8vje9BEyCFzkAhYuvV4e4my/sCgx5+WoBBZXqhrT2nzo2SHiMkh9BiJoNnGoXt2l0zr2JK2PvlkK94tIPjA5btK+IPQ+CAOjZ5JnRsp2KmQdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437816; c=relaxed/simple;
	bh=iWu6G12TMDk6ixXMMOHmKcb1KGEfsCKL39YS9qfiG20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNrFsZZKahGcc7k4CvYRrhILFFYUmGg39PnWDma33Ew91wTxif3fatkG/06KPULfL63xmPsXO0iCLAfpysJvf0UEObSUuWTUdeD2kBky9lJHwhXzTgyJO6gKrfG9Ipn42kULAKbUvP+tlPdUvIdz7sz16SrpvxPOs7dLhvT7gGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HLX1+awZ; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e61d91a087so7453485a12.0
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743437812; x=1744042612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8VzSjTv6n04JBtMQPBNn2sCwxS2HiThjnlvXZAy05E=;
        b=HLX1+awZzrNDixoOjRK84bzi/21OqXkBCDFRz24bEkD3fNXeaunyYR3B/RRLfORXd0
         i7iWux2NCvIHUbyU62i/yZ4hmpQbjArd+B66B0e36W/ugR55ejRpKWPFxrs60W0O7WA0
         PyXrXXtyQOa9rbZSf/0VP7eBa1EcAiTcauLy2V+3F/WsjATLQcjBPl7PPl2OJtNzqQG7
         4/o6PSjf7ztRANryBY3gDsCTrKj6bvaIJEFHOUo+XQJrHHLbaSTY6rmNRBsBqKJQW+Q5
         ELOF9zQBo7iQvpA3Bcpfq49vowwzPtvKU8YRjObGv2dwO3A/DNWysvixUihikM+JDLLF
         cdNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743437812; x=1744042612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P8VzSjTv6n04JBtMQPBNn2sCwxS2HiThjnlvXZAy05E=;
        b=evMk1+qzXFPJVlOcPLqRp0zo3gSBX54B6wpphpuQT4mhFtLClf3/VNuEzIZ6d3nPFj
         zV6/Kuo8iJbKQSdtDRdoIyhUzAOxmnxhcs5zj8vMLMzSeSXnn6JySmHHPYgF3mrkJW/7
         a/hDkyPkBjjRZNIYazq9u+aercxxvuU+ugfu2B1tA8Jv8MI8+gq6a2ravIPXzbTtJU5z
         9Sy+DixbSsHUA4i9ZMQFJ51w2BU16QHRbPxVpTF2IJFedPIUnzWpwvB4QZR68hERdbqo
         5okL5FS/DSFh36muWV27zjpbatEXMWdlBZ8An/Of+V92Vyx5ll78d3pvQMNBvmsSQvx7
         H4fA==
X-Gm-Message-State: AOJu0YzSBN1QJHe8+asEPj8WGAcGy9/+S/rqCZ8LkPRUfqICma0ILB6R
	U2b/Cdm1mz9HEv+hppwkWH/z86R4CTeuTD4n7R5SxyNEiusOz7V7SwZ7UA==
X-Gm-Gg: ASbGnctsP38i8EQo7qRPrr9oI5iV/k3ZnpyCAAdWjBIABJvl3iuaqMfmTPxkkD5G0i8
	Jdz25rB5t+PFV2ruTyJY39p35qBUH50cLAk88hOnay5OwoasxEHP/TEFNvmBjmP8CBwyW+yyOgY
	50eidU6eDKs5t45nkporVxDFRDRQI982AUkGk+iMo//9Kq5zYO7/zaEIwD06LA1bUvvwbxcjl6i
	DkH7c7NuBW4oy+OPwkXmbtFuJOUgivyvjKIfpv5tlObf3U62GBWE7iFD41SddASbDWhgFh2DdJJ
	7A4fNvYR291/xJl+DffiSx/2D2CLaSTsinRw8Qs=
X-Google-Smtp-Source: AGHT+IH689gkWXIfSEcXeeaaAxxp8UK5n2c3FVbUkgY3zKKyLJ2SZkp2XlBz3eW549rAYmSoCqRrUw==
X-Received: by 2002:a05:6402:1e8e:b0:5e5:c5f5:f78 with SMTP id 4fb4d7f45d1cf-5edfda04becmr9216500a12.26.1743437812091;
        Mon, 31 Mar 2025 09:16:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:f457])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16d2dd0sm5861458a12.21.2025.03.31.09.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:16:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/5] io_uring: don't store bgid in req->buf_index
Date: Mon, 31 Mar 2025 17:18:02 +0100
Message-ID: <3ea9fa08113ecb4d9224b943e7806e80a324bdf9.1743437358.git.asml.silence@gmail.com>
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

Pass buffer group id into the rest of helpers via struct buf_sel_arg
and remove all reassignments of req->buf_index back to bgid. Now, it
only stores buffer indexes, and the group is provided by callers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +--
 io_uring/kbuf.c                | 11 ++++-------
 io_uring/kbuf.h                |  1 +
 io_uring/net.c                 |  3 ++-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index b44d201520d8..3b467879bca8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -653,8 +653,7 @@ struct io_kiocb {
 	u8				iopoll_completed;
 	/*
 	 * Can be either a fixed buffer index, or used with provided buffers.
-	 * For the latter, before issue it points to the buffer group ID,
-	 * and after selection it points to the buffer ID itself.
+	 * For the latter, it points to the selected buffer ID.
 	 */
 	u16				buf_index;
 
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index eb9a48b936bd..8f8ec7cc7814 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -85,7 +85,6 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 {
 	if (WARN_ON_ONCE(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return;
-	req->buf_index = req->kbuf->bgid;
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	kfree(req->kbuf);
 	req->kbuf = NULL;
@@ -103,7 +102,6 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	bl = io_buffer_get_list(ctx, buf->bgid);
 	list_add(&buf->list, &bl->buf_list);
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
-	req->buf_index = buf->bgid;
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return true;
@@ -306,7 +304,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 	int ret = -ENOENT;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	bl = io_buffer_get_list(ctx, req->buf_index);
+	bl = io_buffer_get_list(ctx, arg->buf_group);
 	if (unlikely(!bl))
 		goto out_unlock;
 
@@ -339,7 +337,7 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	bl = io_buffer_get_list(ctx, req->buf_index);
+	bl = io_buffer_get_list(ctx, arg->buf_group);
 	if (unlikely(!bl))
 		return -ENOENT;
 
@@ -359,10 +357,9 @@ static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
 	struct io_buffer_list *bl = req->buf_list;
 	bool ret = true;
 
-	if (bl) {
+	if (bl)
 		ret = io_kbuf_commit(req, bl, len, nr);
-		req->buf_index = bl->bgid;
-	}
+
 	req->flags &= ~REQ_F_BUFFER_RING;
 	return ret;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 09129115f3ef..c576a15fbfd4 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -55,6 +55,7 @@ struct buf_sel_arg {
 	size_t max_len;
 	unsigned short nr_iovs;
 	unsigned short mode;
+	unsigned buf_group;
 };
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
diff --git a/io_uring/net.c b/io_uring/net.c
index 6b7d3b64a441..7852f0d8e2b6 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -190,7 +190,6 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 	sr->done_io = 0;
 	sr->retry = false;
 	sr->len = 0; /* get from the provided buffer */
-	req->buf_index = sr->buf_group;
 }
 
 static int io_net_import_vec(struct io_kiocb *req, struct io_async_msghdr *iomsg,
@@ -569,6 +568,7 @@ static int io_send_select_buffer(struct io_kiocb *req, unsigned int issue_flags,
 		.iovs = &kmsg->fast_iov,
 		.max_len = min_not_zero(sr->len, INT_MAX),
 		.nr_iovs = 1,
+		.buf_group = sr->buf_group,
 	};
 
 	if (kmsg->vec.iovec) {
@@ -1057,6 +1057,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			.iovs = &kmsg->fast_iov,
 			.nr_iovs = 1,
 			.mode = KBUF_MODE_EXPAND,
+			.buf_group = sr->buf_group,
 		};
 
 		if (kmsg->vec.iovec) {
-- 
2.48.1


