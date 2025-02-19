Return-Path: <io-uring+bounces-6562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B9A8A3C565
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 17:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B789E3AB744
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 16:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F201E1C09;
	Wed, 19 Feb 2025 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTdyfULK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67116EEA6;
	Wed, 19 Feb 2025 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739983649; cv=none; b=pSZ3c/Yj0o0IMG6z4Lcpz71YKkpxCIvC+oQbZ9z3oABEtfED1cHF5Yb5VvM527nGWc47hvjXiE1YLJpDXqIXcoLj9MTtdCsuDszv/hXcTEpBNUMuDhPmm2dp5/XRXjPtHvSDmk4ZoPDq/T2K8TB1RN8pj+YCE0sWFp9aWlCRcqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739983649; c=relaxed/simple;
	bh=OdWFyV/XBMIWzFscGblO4TlUIiRVZuJPbHO6mR0BCdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rBIqzLtHLpGtPJJJkuuXP0b1LP4Ke+wO6puz5YTYXPkS5ykX0RUkZK+pgZ4rQpmjwFvCC8rlmzfMaSOwDV8YzOYsDikILHQTd/V0CKuZUVR5dpnLp+l3eQF6um10WNtlTAGOEV6gaICiyJghS6knaWYsj25NetOFn+67p0CJDbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTdyfULK; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-abbc38adeb1so5459266b.1;
        Wed, 19 Feb 2025 08:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739983646; x=1740588446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ng0iJW0SIjXWssoB2sNiKRx0I5xP3Pz6iaixMoGcdBo=;
        b=KTdyfULKMxYtWrcoGuCI+nD/SLccHdKmy061L12JkDKLoo0uAJKHJ1v3YFVY1XMakj
         0LW8sZPa0lmFe1UHoGXyo5/BLa+03VrEQt9jT9tMat59xW1zDMkWtu0AgwNbZUrwIM+J
         0mxi9zsUIoH3+KMOcRqcIS19fci2C/fMS8SDGKZ+IiAOVGAeFxDhiZiuwposmKeQjdCi
         XvtAcGbVgdkeInzfRpewr3DaUCOHI7SkrGdtDV8XfQIb4sivs3p0rDwAvzCXWCUa9q8r
         uxFWBdgpqIFIC8LUuZweGEAcNyCoFug9Ll2nxvtC91DECEnVO+H29kvLS1eUwlxwHZj7
         kr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739983646; x=1740588446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ng0iJW0SIjXWssoB2sNiKRx0I5xP3Pz6iaixMoGcdBo=;
        b=q4afDsg8gYL8eQVrBQyOSgOtRZ3m8WlWXsTqBp7GKadleITQhruzLKyYBBD72qmqnb
         y9X8kCab9tF2aulg24tsW/PTEVZ5AgmSjamMBqvdhuu+97fPIX/wKMwflFnjamZlwpxX
         EQUMdqfyIQsxnR3kDHdtADDwstfAX3Wla3SYrkTlR6fWZ/EE/q/js8gljX3FMUoM1gCN
         3sn/6By1oEnIZ62f1+LrByQck2aGcsD4mQ+PyAwgPtsbRkQ7gQXDr+XLnpRXFJSy0Ldo
         b8fIBra3CUBV2iUXyoNTqliV+VexM0SkjtaoS+OxxdbDbWHMuNS89SKlyC2wr5FXfG7X
         /7Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUG9n5x9gRJAEV7XykZnNizA8ZrIdBGlfWjy529tkLWLi11lyheXQYkqS0ys4mMFXUROt12Y9bwKubfj74=@vger.kernel.org, AJvYcCUex3QpG1CKVB5od2rYoC5sb9yreWilt5YI9E5AezUgxU3CWODYEkN2GdtBfjyXDD/q/E1rAwscWw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZFtHqjSAjeEYUFb8PfiPh/Wa8/CJoqcK0srKufxIffaq4pz/+
	e6dNUFbAf4SsFwfxgBg9O3IrQVG+NDic02eJgOx8r3KfTQXyzwkW
X-Gm-Gg: ASbGncuP+nlXFmxmbgJxXBkozj013PodxUeAB/L32gEQ04J5OaTpHKblEKcuc2igVbo
	qi5KoSU6trzxNUIrj5Qjf6wcGpeshamWSVG98kmpiX79AoSW+rl71LsuPXIR4SXM/zYjeDGhG4Z
	q0yfgdi/6EOIPv3z41KkwPCvLVEKjwoXvKdh+dfm0Mha0ONrBFfI+ecUXxk5IDnITWOs16TWNl8
	8YXCdpuIyNKBgtskdiiYKEKWvAy1GyPb6ojsviGMx/JV7zMhZEU9ZgyZIjNtOdsPahqp+uCof0F
	m726rvVo/v7R4xmQ79PxTE4FNduPSWqJ959btwSBtn3881Vx
X-Google-Smtp-Source: AGHT+IG8+zatMWnMr7JFIOwacFG2NrjFsMcz+AIurTaP6/4bY5CanFZ0pi4JSs73eWPZdfFGJc0mTQ==
X-Received: by 2002:a17:906:1bb2:b0:ab3:9923:ef4e with SMTP id a640c23a62f3a-abbccea67aamr414411266b.22.1739983645361;
        Wed, 19 Feb 2025 08:47:25 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:cfff])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbda707e3dsm150118666b.106.2025.02.19.08.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 08:47:24 -0800 (PST)
Message-ID: <c4a0cdb8-ac99-4a7a-9791-d2c833e45533@gmail.com>
Date: Wed, 19 Feb 2025 16:48:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-2-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250218224229.837848-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 22:42, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Similar to the fixed file path, requests may depend on a previous one
> to set up an index, so we need to allow linking them. The prep callback
> happens too soon for linked commands, so the lookup needs to be deferred
> to the issue path. Change the prep callbacks to just set the buf_index
> and let generic io_uring code handle the fixed buffer node setup, just
> like it already does for fixed files.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>

It wasn't great before, and it'd be harder to follow if we shove it
into the issue path like that. Add additional overhead in the common
path and that it's not super flexible, like the notification problem
and what we need out of it for other features.

We're better to remove the lookup vs import split like below.
Here is a branch, let's do it on top.

https://github.com/isilence/linux.git regbuf-import


diff --git a/io_uring/net.c b/io_uring/net.c
index ce0a39972cce..322cf023233a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1360,24 +1360,10 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
  	int ret;
  
  	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_rsrc_node *node;
-
-		ret = -EFAULT;
-		io_ring_submit_lock(ctx, issue_flags);
-		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-		if (node) {
-			io_req_assign_buf_node(sr->notif, node);
-			ret = 0;
-		}
-		io_ring_submit_unlock(ctx, issue_flags);
-
-		if (unlikely(ret))
-			return ret;
-
-		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter,
-					node->buf, (u64)(uintptr_t)sr->buf,
-					sr->len);
+		sr->notif->buf_index = req->buf_index;
+		ret = io_import_reg_buf(sr->notif, &kmsg->msg.msg_iter,
+					(u64)(uintptr_t)sr->buf, sr->len,
+					ITER_SOURCE, issue_flags);
  		if (unlikely(ret))
  			return ret;
  		kmsg->msg.sg_from_iter = io_sg_from_iter;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index af39b69eb4fd..a4557ed14bea 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -860,9 +860,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
  	return ret;
  }
  
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+static int io_import_fixed_imu(int ddir, struct iov_iter *iter,
+				struct io_mapped_ubuf *imu,
+				u64 buf_addr, size_t len)
  {
  	u64 buf_end;
  	size_t offset;
@@ -919,6 +919,35 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
  	return 0;
  }
  
+static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
+						    unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+
+	if (req->buf_node)
+		return req->buf_node;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+	if (node)
+		io_req_assign_buf_node(req, node);
+	io_ring_submit_unlock(ctx, issue_flags);
+	return node;
+}
+
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+			u64 buf_addr, size_t len, int ddir,
+			unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+
+	node = io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+	return io_import_fixed_imu(ddir, iter, node->buf, buf_addr, len);
+}
+
  /* Lock two rings at once. The rings must be different! */
  static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
  {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a6d883c62b22..ce199eb0ac9f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,9 +50,9 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node);
  void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data);
  int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
  
-int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len);
+int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+			u64 buf_addr, size_t len, int ddir,
+			unsigned issue_flags);
  
  int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 16f12f94943f..31a1f15f5f01 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -354,8 +354,6 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
  			    int ddir)
  {
  	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_rsrc_node *node;
  	struct io_async_rw *io;
  	int ret;
  
@@ -363,13 +361,8 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
  	if (unlikely(ret))
  		return ret;
  
-	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
-	if (!node)
-		return -EFAULT;
-	io_req_assign_buf_node(req, node);
-
  	io = req->async_data;
-	ret = io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw->len);
+	ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir, 0);
  	iov_iter_save_state(&io->iter, &io->iter_state);
  	return ret;
  }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index cf5e9822e49a..80046e755211 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -199,21 +199,9 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
  	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
  		return -EINVAL;
  
-	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_rsrc_node *node;
-		u16 index = READ_ONCE(sqe->buf_index);
-
-		node = io_rsrc_node_lookup(&ctx->buf_table, index);
-		if (unlikely(!node))
-			return -EFAULT;
-		/*
-		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
-		 * being called. This prevents destruction of the mapped buffer
-		 * we'll need at actual import time.
-		 */
-		io_req_assign_buf_node(req, node);
-	}
+	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+		req->buf_index = READ_ONCE(sqe->buf_index);
+
  	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
  
  	return io_uring_cmd_prep_setup(req, sqe);
@@ -261,13 +249,8 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
  			      unsigned int issue_flags)
  {
  	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-	struct io_rsrc_node *node = req->buf_node;
-
-	/* Must have had rsrc_node assigned at prep time */
-	if (node)
-		return io_import_fixed(rw, iter, node->buf, ubuf, len);
  
-	return -EFAULT;
+	return io_import_reg_buf(req, iter, ubuf, len, rw, issue_flags);
  }
  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
  


-- 
Pavel Begunkov


