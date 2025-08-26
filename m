Return-Path: <io-uring+bounces-9295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D76B36836
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 16:14:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 308931C27774
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 14:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39DBC133;
	Tue, 26 Aug 2025 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FbkG+3XR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807312FDC44
	for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217087; cv=none; b=FVLowWcogpH5mPR1wF8rzt2i4wuDiqsNwG/XPuk+X5Hk1ynPV4fe2x0owc1CfAQP/1Og8rcK00rfRnG8BjDT+uW9A8ytuD3Xwkz64P8xM397cHBQU1XFhxm/AMQ6ZxT07lbmTefoJDkxjRxgEucM7lmLnkuqpnsaB1QVAepRU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217087; c=relaxed/simple;
	bh=pyEwNELnYAidz73HJkBjrJIbW8U/K7jLND6twk9yfZY=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Qb5iS+xd9K4awhgWHmPJErdck44btiEcjQCsSmVosQKmJmoVR9jFcXD4BgRvzn0b6q9MnF3e0TNksW5w0f684a1wcU9Ll7WIrNRJN0K6QT5FYACEdKNi3+XeYKKeddCffm7NnXg8PtNLkJN59MLm4EYa1gXq/yAN//1dO4ijhM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FbkG+3XR; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-88432dc61d8so540035539f.1
        for <io-uring@vger.kernel.org>; Tue, 26 Aug 2025 07:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1756217082; x=1756821882; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rp2bn07QTOVxTX3RsFkkLbdzQj4Hito0ALjHHtebDFM=;
        b=FbkG+3XRjeP44WptTxlKI0Rgmp9M20pnT+RMIQsyzGH7NY4GGl0k7NnC9QPAc2xioI
         gc0Q6qZnJ8WWpkgbswiiiXrZEtxj2mU3H5eKthyLngr3GkQ5mKzO4PJgEMr5gLJK+7BH
         senb9Juj4/UbKb262Se4h3PvmuZd9CC7bf9LMoUZMa2e/OhacCn3aAgE6bKvvPU5vUPb
         Oaf6KWgmWtEnQu6ckPdre5vdxjf/JEl3rLPrVNj3jse8zXEZys4j+NDon0p2VegMwwW+
         tpYGtiLLe6IC8tdQF21YXsyIrOVRJtqaKSI5TomBGgQMnDjqDIJ/vqvvN+H7uwZkmQ52
         eJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756217082; x=1756821882;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Rp2bn07QTOVxTX3RsFkkLbdzQj4Hito0ALjHHtebDFM=;
        b=BeGzzydreUaxffyhVm1uVlgRwTkcXuRxtNiuTs8x5dI3FYaibC9vRphAWlYLyJv66B
         GfeslwyRWo8c4KH31hjeLXnz4L2UmEr5n08XYgCPzmBdGMFqzmtnRKgoSugr1fZiuct7
         /dOooq5t+SWdWZMgT7qgqOZcV939pc4tknKhWEVF+oihF8IYBKI2he7jSS2JSN3z/AY9
         M8Ek5DJ8HiT3aomqdTWA4aKIlXsIyO5p1Nb7KU/9ujcHmhKnsrQgHrxKkwBSJ20CFv0A
         7WqMVtLBCXC1NWSkZGsSTWx7QOTmp20Ap/ZMJJA2KkAqKSVRCnQhw8/8T+85WjcbV1xr
         PdEQ==
X-Gm-Message-State: AOJu0YxhlgfqCP/cxgCF/XX51LUKLNFZlUppoedY2im+cqXfS0hPRX5V
	jTxApSEQVV6vsgaJc7CFsXNCWjC9zGdCqvJCMKa2FDZeyb+05w0XrbCQnoy1P6hG0w2JWpyWuUU
	lW9UT
X-Gm-Gg: ASbGncsl5s2wEk+uUuTLTNYbBk6/KBwL1PHUKNTSsONtreuY0k1Zq1Z/6mZzj+eTRUc
	YMiltnJs8uw6doRryRzFrlvuYUvodilqJWtueW/ZC5T6wWdaLU/3dkTmb+DaprjZgZ7grLPWsgr
	gDlSSpCmVy8Y70i/RqKTRHLbhpql9LC/HQMVhYUcKrfeX5M6dJgt/xxCJFn+m1iImWn8oNAbAWG
	Uyh3iI8ZeOlQ3KXNdlF74gQgpA7tpp+rH2X/IT+CeDQQMYP373HCrvrrlWGdePRhbIXe6WGdlya
	WCnzSUic8CmLHGvRyqkHYfLQVcf4stJF8SQ1PB9PC2ah5WJYEbusLegl4mVmdLKWa11Ho7FWhbS
	RzaGT7hLHwgGvG1yIGP18mysCUyPoU28obRPZk35x
X-Google-Smtp-Source: AGHT+IGutigudI/9C56pCDSlJP+tqrcd8qIchv9dFSgOjtEPSFYf3LF5IvSGjhIPWoLdtbwIyVIVlA==
X-Received: by 2002:a05:6e02:2192:b0:3eb:cca5:55a5 with SMTP id e9e14a558f8ab-3ebcca5a064mr132881925ab.19.1756217081248;
        Tue, 26 Aug 2025 07:04:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ea4e45c272sm67858945ab.26.2025.08.26.07.04.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 07:04:40 -0700 (PDT)
Message-ID: <c93fcc03-ff41-4fe5-bea1-5fe3837eef73@kernel.dk>
Date: Tue, 26 Aug 2025 08:04:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: add async data clear/free helpers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Futex recently had an issue where it mishandled how ->async_data and
REQ_F_ASYNC_DATA is handled. To avoid future issues like that, add a set
of helpers that either clear or clear-and-free the async data assigned
to a struct io_kiocb.

Convert existing manual handling of that to use the helpers. No intended
functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 9113a44984f3..64f3bd51c84c 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -43,7 +43,6 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
 
 static void __io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
-	req->async_data = NULL;
 	hlist_del_init(&req->hash_node);
 	io_req_task_complete(req, tw);
 }
@@ -54,6 +53,7 @@ static void io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
 
 	io_tw_lock(ctx, tw);
 	io_cache_free(&ctx->futex_cache, req->async_data);
+	io_req_async_data_clear(req, 0);
 	__io_futex_complete(req, tw);
 }
 
@@ -72,8 +72,7 @@ static void io_futexv_complete(struct io_kiocb *req, io_tw_token_t tw)
 			io_req_set_res(req, res, 0);
 	}
 
-	kfree(req->async_data);
-	req->flags &= ~REQ_F_ASYNC_DATA;
+	io_req_async_data_free(req);
 	__io_futex_complete(req, tw);
 }
 
@@ -232,9 +231,7 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 		io_ring_submit_unlock(ctx, issue_flags);
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
-		kfree(futexv);
-		req->async_data = NULL;
-		req->flags &= ~REQ_F_ASYNC_DATA;
+		io_req_async_data_free(req);
 		return IOU_COMPLETE;
 	}
 
@@ -310,9 +307,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	req->async_data = NULL;
-	req->flags &= ~REQ_F_ASYNC_DATA;
-	kfree(ifd);
+	io_req_async_data_free(req);
 	return IOU_COMPLETE;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2e4f7223a767..86613b8224bd 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -281,6 +281,19 @@ static inline bool req_has_async_data(struct io_kiocb *req)
 	return req->flags & REQ_F_ASYNC_DATA;
 }
 
+static inline void io_req_async_data_clear(struct io_kiocb *req,
+					   io_req_flags_t extra_flags)
+{
+	req->flags &= ~(REQ_F_ASYNC_DATA|extra_flags);
+	req->async_data = NULL;
+}
+
+static inline void io_req_async_data_free(struct io_kiocb *req)
+{
+	kfree(req->async_data);
+	io_req_async_data_clear(req, 0);
+}
+
 static inline void io_put_file(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_FIXED_FILE) && req->file)
diff --git a/io_uring/net.c b/io_uring/net.c
index b00cd2f59091..d2ca49ceb79d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -178,10 +178,8 @@ static void io_netmsg_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	if (hdr->vec.nr > IO_VEC_CACHE_SOFT_CAP)
 		io_vec_free(&hdr->vec);
 
-	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr)) {
-		req->async_data = NULL;
-		req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
-	}
+	if (io_alloc_cache_put(&req->ctx->netmsg_cache, hdr))
+		io_req_async_data_clear(req, REQ_F_NEED_CLEANUP);
 }
 
 static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 906e869d330a..dcde5bb7421a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -154,10 +154,8 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 	if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
 		io_vec_free(&rw->vec);
 
-	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
-		req->async_data = NULL;
-		req->flags &= ~REQ_F_ASYNC_DATA;
-	}
+	if (io_alloc_cache_put(&req->ctx->rw_cache, rw))
+		io_req_async_data_clear(req, 0);
 }
 
 static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ff1d029633b8..09f2a47a0020 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -37,8 +37,7 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (io_alloc_cache_put(&req->ctx->cmd_cache, ac)) {
 		ioucmd->sqe = NULL;
-		req->async_data = NULL;
-		req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
+		io_req_async_data_clear(req, 0);
 	}
 }
 
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index e07a94694397..26c118f3918d 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -37,9 +37,7 @@ static void io_waitid_free(struct io_kiocb *req)
 	struct io_waitid_async *iwa = req->async_data;
 
 	put_pid(iwa->wo.wo_pid);
-	kfree(req->async_data);
-	req->async_data = NULL;
-	req->flags &= ~REQ_F_ASYNC_DATA;
+	io_req_async_data_free(req);
 }
 
 static bool io_waitid_compat_copy_si(struct io_waitid *iw, int signo)

-- 
Jens Axboe


