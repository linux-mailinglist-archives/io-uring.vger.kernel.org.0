Return-Path: <io-uring+bounces-2963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D0B962CBC
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 17:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B69791C21DF0
	for <lists+io-uring@lfdr.de>; Wed, 28 Aug 2024 15:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E783C15B12F;
	Wed, 28 Aug 2024 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZpioeGGA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBD083A18
	for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 15:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724859980; cv=none; b=szVDx7wh9drkEbWCg9H+o0Yk3NhgmenC2b53Svu/KTZM4uq3t87qJ88YYiDDJxn0YaFURN+a31/rKJg+gZzyoejmefT/3N+Gg+Ws3N9J9mStNJBRadQrkGhQnSJV2LAhyE6kuGTliLmLiVn/3WIJwmgJIMRTlLTDgznxmgidloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724859980; c=relaxed/simple;
	bh=c3kWt2JnvYEZcsYhdePGzMlcu4+ycTX0/V4D4Vq3I6M=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=guhEfHv2mtE1tr3qSUSaWyHjA0CrfuDzTiZaTJA/s3c5ZygVmFpoCftD+7Ru//b8/vQ5OrfIylF2IlVnM+zTiDdNelAfHTgqBJnScjUaNP3OTBCvAXR6/AFQQsjXmcrWaSMLnBTWU5hDDhO6FE0RhKRQG0hJooS5rVJJzJrNjqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZpioeGGA; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-82784c8bca5so218701039f.0
        for <io-uring@vger.kernel.org>; Wed, 28 Aug 2024 08:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724859976; x=1725464776; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFPQ3A3CA9dg2JwBA2KnSdZRy7rJHdQN+nmim/WYFBI=;
        b=ZpioeGGA5QdDbYZC2/q7sk2NcGBVxdCcRcuzHllqhPzYmHs+a56u4bkWFFKKytvJ98
         GKjAdlsTA/Qm91Bu4u416UQYfdHE76bJ8ckee/yUCjRnQMDSSBLJWU1jufYjDMGTGvra
         yT1L5/j+C4HWDLIEhTWUUqQUTzi9LFd19iY6V9JPpj3iazPxlDzdWg6+lr0EoKigR3sG
         QAJbXLk2nof0KfnBcZHCI5RwHJlhFLO0UlcqhJRvFeOsLeFdx7z4CWssHUjYO1Y/4LrK
         VqadHHSq4QZmPFeUu0ylpm06gOQ9ci1Uv7l+I6b0vSKSVDBor8r5wjo9Y98QKgOZdXCu
         xeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724859976; x=1725464776;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cFPQ3A3CA9dg2JwBA2KnSdZRy7rJHdQN+nmim/WYFBI=;
        b=XIaZAgKK93UEkKgMrz09EU+1VNsyPW0lFZXJmPJpM3JiIpiaytLvqCG8MFJ0wsyE2B
         K0iuMnzjT6/75MadtTsNzEbNtshvPZqBMFpsMDq76FL7RRr8+tfo8LjhI0Qa6NUtmM2l
         igkDcZ7fj8M74kUwRzK8h0Hk3UHOJI5HfAeLehTnr1GC4xJjtRVwUJYlohOCIgkwp7Ft
         4E7La16qpUhzNXI2zuiJ34rcmTK98GYgKqNZm7oWHOmSmLURMsO8r1++P3bYiF9XrPUX
         A24CW2T8LJ/9rF1ESLDjkLzVo+T8GpE2lLaWrkwk1gcfN5eRWcakySyJxxtsENNgbFy0
         fMXQ==
X-Gm-Message-State: AOJu0YxqP4+Q+nkLP2627wsve2jJI6hwCNuTpuP2cfRzNoQghoeSMGxj
	c5sOqIOJfN+sf2GgSfscPxe7/+pc8jUp5O/vIZKBPHhrOsQbMEipmR0O6OvDO2BhclRcXDfhNWA
	p
X-Google-Smtp-Source: AGHT+IEJIGh9AIO8xs64VCgCcpkTuxEyHWct1ROybQtG1wFPFSt58bPIGsWOWlf2B6j9wwqLTx7WSg==
X-Received: by 2002:a05:6602:3fcb:b0:805:afed:cea1 with SMTP id ca18e2360f4ac-82787376a19mr1905416539f.14.1724859975862;
        Wed, 28 Aug 2024 08:46:15 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82a0ffdda7fsm2849939f.12.2024.08.28.08.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 08:46:15 -0700 (PDT)
Message-ID: <b1fa09cd-ca5a-41ff-bc64-bec43f483a48@kernel.dk>
Date: Wed, 28 Aug 2024 09:46:14 -0600
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
Subject: [PATCH] io_uring/rsrc: ensure compat iovecs are copied correctly
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For buffer registration (or updates), a userspace iovec is copied in
and updated. If the application is within a compat syscall, then the
iovec type is compat_iovec rather than iovec. However, the type used
in __io_sqe_buffers_update() and io_sqe_buffers_register() is always
struct iovec, and hence the source is incremented by the size of a
non-compat iovec in the loop. This misses every other iovec in the
source, and will run into garbage half way through the copies and
return -EFAULT to the application.

Maintain the source address separately and assign to our user vec
pointer, so that copies always happen from the right source address.

Fixes: f4eaf8eda89e ("io_uring/rsrc: Drop io_copy_iov in favor of iovec API")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a860516bf448..b38d0ef41ef1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -394,10 +394,11 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				   struct io_uring_rsrc_update2 *up,
 				   unsigned int nr_args)
 {
-	struct iovec __user *uvec = u64_to_user_ptr(up->data);
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
 	struct page *last_hpage = NULL;
+	struct iovec __user *uvec;
+	u64 user_data = up->data;
 	__u32 done;
 	int i, err;
 
@@ -410,7 +411,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		struct io_mapped_ubuf *imu;
 		u64 tag = 0;
 
-		iov = iovec_from_user(&uvec[done], 1, 1, &fast_iov, ctx->compat);
+		uvec = u64_to_user_ptr(user_data);
+		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
 		if (IS_ERR(iov)) {
 			err = PTR_ERR(iov);
 			break;
@@ -443,6 +445,10 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 		ctx->user_bufs[i] = imu;
 		*io_get_tag_slot(ctx->buf_data, i) = tag;
+		if (ctx->compat)
+			user_data += sizeof(struct compat_iovec);
+		else
+			user_data += sizeof(struct iovec);
 	}
 	return done ? done : err;
 }
@@ -949,7 +955,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct page *last_hpage = NULL;
 	struct io_rsrc_data *data;
 	struct iovec fast_iov, *iov = &fast_iov;
-	const struct iovec __user *uvec = (struct iovec * __user) arg;
+	const struct iovec __user *uvec;
 	int i, ret;
 
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
@@ -972,7 +978,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
 		if (arg) {
-			iov = iovec_from_user(&uvec[i], 1, 1, &fast_iov, ctx->compat);
+			uvec = (struct iovec * __user) arg;
+			iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
 			if (IS_ERR(iov)) {
 				ret = PTR_ERR(iov);
 				break;
@@ -980,6 +987,10 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			ret = io_buffer_validate(iov);
 			if (ret)
 				break;
+			if (ctx->compat)
+				arg += sizeof(struct compat_iovec);
+			else
+				arg += sizeof(struct iovec);
 		}
 
 		if (!iov->iov_base && *io_get_tag_slot(data, i)) {

-- 
Jens Axboe


