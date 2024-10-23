Return-Path: <io-uring+bounces-3940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9EF9ACBC8
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 15:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9967F1C20DCD
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 13:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6593C19EEBF;
	Wed, 23 Oct 2024 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q54DFDzq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB6F154439
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729691972; cv=none; b=MbFfF7c/HkQlOO0sz03V+rvSlep5IEUe//PsSKNJqGVyJi4KdlGg/cmwarME8PgREFvoKCC6GxM0KX5HLZOX53fYGSy+BqmWTi+cJfc04r6/Gi6nCd68/lW5eVcTC27pvhgpnhcUBIfgHlTrgRDEwjEghLG2yMSwfzEurlghLqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729691972; c=relaxed/simple;
	bh=Gd1i7aCNQCO6sAMe6+WqmYNkXh3YkYbp6UtALMjoBpk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=IjxnsiQWj/AC6AkiuYU1NiHe6qlg0EcJGuhvbQrmsPiDeT3Nmvu8Q5Hgk7qHbRpwQr4sKFBZjWtvi1Nld4dtxBoiucC9KqiQBJTHKZlrbDyRzccEkq2qTprZ62eUDJ9SNyRztggMDg6xbSLczVGAkaDDJQCmR8z9Gm4zr4l6968=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q54DFDzq; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ab3413493so233679539f.2
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 06:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729691969; x=1730296769; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJ1m3XwUsBVlyunNZh2R1psUOvsRMMiGrcy06FNj2a8=;
        b=q54DFDzq8sYNh6PR+xZeYZDXR+egnXiPMW9zCi+0KDJpfAVYsP5JRJ0gnHg8F++3AD
         d40BQHj5wu3WweLteiJzsvD9VHLLzDDI0URnfwKgCMcqhCrm+gXZ5zMp9G2NbDF2a1/X
         oI5T94jRLWPUIq40IVYxwD3aQHRqmtSHvIpjjCQUbcVUQURMBchR9+6BafEg/DMEKfEi
         dm8zd3SyCPIcRgUWdAw4WXB7VOwYNitLgNQglKPFVYwoItOUJ3L/3/R2EIGbxQka6BiH
         3XlEFcjRDo1+OA/anTgrA7QMKGvhQZxwSoIeeSJqpUSkiZWT0j0sgWliB35vZgiSf68K
         en/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729691969; x=1730296769;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LJ1m3XwUsBVlyunNZh2R1psUOvsRMMiGrcy06FNj2a8=;
        b=huOnoJh+m0dmJwfebSXRXyREhmLjgN18WYJmGFd9Lj6DdJeTtsV3XWh3afbuaoerYv
         ySYTkl9axGEA7I759YOABdw3kCbrnTmQSnFHoqAoeFPdjfdwhriA9e0NEvLtbPUEBpmy
         2wupvbQDUBcNuOTy0MRZuwuYAUW8UrSPIz7arCoDh+8HEtOc6GuXIUun1maRMIycdqzC
         C78gDgB1BngpRA4G5HPyXnnl77zP34WMs9loIlj5F/Xqyud1w8FFEEud9/xW5nZZNFjV
         hL796j9hkAK+gweANv7TKZeIwUDjHEGZtFe9Inf3jsFA4z8GdXH9M48bwMWRqwra+Nsm
         qf1w==
X-Gm-Message-State: AOJu0Yzem9gsBHFSfMDJpGmAKKRdS2juyafpGTatlll6nm6u1zB/pPFV
	hPu4OvlM2OCSfEvY4nJ77j4weG7z39sEi+/lEEtCevW+cCxN7msZHNyaxCD7RAB0Csgj8hmin8N
	3
X-Google-Smtp-Source: AGHT+IH9fT2HtI4K8RSgZsCMZZL1GxTchq6zx0eBVMkaa4vNVFMNVmIYiABTfk3KWDSNsVbWjs9PYw==
X-Received: by 2002:a05:6602:140a:b0:835:4278:f130 with SMTP id ca18e2360f4ac-83af63f54c2mr313115639f.13.1729691968701;
        Wed, 23 Oct 2024 06:59:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a630522sm1980374173.136.2024.10.23.06.59.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2024 06:59:28 -0700 (PDT)
Message-ID: <9670c026-848c-433f-a473-452194aa8cb2@kernel.dk>
Date: Wed, 23 Oct 2024 07:59:27 -0600
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
Subject: [PATCH] io_uring: remove 'issue_flags' argument for
 io_req_set_rsrc_node()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

All callers already hold the ring lock and hence are passing '0',
remove the argument and the conditional locking that it controlled.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Took a second look at this, and it does indeed fall out nicely
if done prior to the (buggy) net conversion. Fixed that one up too,
fwiw.

diff --git a/io_uring/net.c b/io_uring/net.c
index 18507658a921..fb1f2c37f7d1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1261,7 +1261,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EFAULT;
 		idx = array_index_nospec(idx, ctx->nr_user_bufs);
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
-		io_req_set_rsrc_node(notif, ctx, 0);
+		io_req_set_rsrc_node(notif, ctx);
 	}
 
 	if (req->opcode == IORING_OP_SEND_ZC) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8ed588036210..c50d4be4aa6d 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -107,14 +107,10 @@ static inline void __io_req_set_rsrc_node(struct io_kiocb *req,
 }
 
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
-					struct io_ring_ctx *ctx,
-					unsigned int issue_flags)
+					struct io_ring_ctx *ctx)
 {
-	if (!req->rsrc_node) {
-		io_ring_submit_lock(ctx, issue_flags);
+	if (!req->rsrc_node)
 		__io_req_set_rsrc_node(req, ctx);
-		io_ring_submit_unlock(ctx, issue_flags);
-	}
 }
 
 static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c633365aa37d..4bc0d762627d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -343,7 +343,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return -EFAULT;
 	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
 	imu = ctx->user_bufs[index];
-	io_req_set_rsrc_node(req, ctx, 0);
+	io_req_set_rsrc_node(req, ctx);
 
 	io = req->async_data;
 	ret = io_import_fixed(ddir, &io->iter, imu, rw->addr, rw->len);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 58d0b817d6ea..6994f60d7ec7 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -220,7 +220,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		 * being called. This prevents destruction of the mapped buffer
 		 * we'll need at actual import time.
 		 */
-		io_req_set_rsrc_node(req, ctx, 0);
+		io_req_set_rsrc_node(req, ctx);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
-- 
Jens Axboe


