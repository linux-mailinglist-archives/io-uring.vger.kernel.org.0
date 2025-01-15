Return-Path: <io-uring+bounces-5889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5468BA1299C
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 18:18:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 589DA1889E88
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421B01581F0;
	Wed, 15 Jan 2025 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mk75LH7N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4983870812
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736961513; cv=none; b=EhQRGn81v6ZW3J7RYlqBlksmoqGKmhjlbGaAeDT1iQS1xk+l64/GMZBqsrU1ofATDyBNwyGRGgEtEDxHVaTts0tCOtS+m34m4fb4Em6RTMn6lTi/WJNVoP3sPNcy+aJJ4afEqugfyjPLsEzxCXsWW/R+fwnvXdjZ/UBdNGG2kqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736961513; c=relaxed/simple;
	bh=z+i+q/xr+ItIQFZztURksJ0C80JmwepjQLRv6l5cPYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8Ew8dVqxbI7/V5H2DP9/jepqaqKkol88ZmzDohE5VVSAMNP15NJ8KB4FU9MqGhoviSzpcdJValdWMPctP26U3p6YdHACiIln1ai8gmlRb/umRnM08T9V60Nns0d5oQne0exY5tj4H/alMv9dI9FoBP2OcpE0507kZUfdTuEUt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mk75LH7N; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-844e12f702dso231999139f.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 09:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736961510; x=1737566310; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A7fitZJGmD+mPGUu2xEhFWr5I1LOSHiMsZaKE8zrxJA=;
        b=Mk75LH7Nl/MJAIwwlpQEC5LhdUh/efGjYAFbvUfSOGTDotv9JrbLE9jilrTTtXcpwx
         y2dHyGm/9UkoNzqlRglRbV/xtCSc/cxcSVX8yKLO+I1mSwOnJQt0XftbqVziqiAZZaMm
         umAkgVBf4LyjRXDY8hInrhASvM4qyVFQy4DFG4+RQgOpVXZt6SDgm07r64St5+kMbkCj
         lODad8hqSVn3EIDzdJYvdmOsq8vJnR1i/40DxKj0rDT7O+KOwNNPlfumsWs7yRNcmG9X
         BVE7HrLVy+PHPospcwTjqRoIZAuUmDLoON3eOkZY+RlbpGhEk+9EQRVaI1HnHcRQAZJW
         6f8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736961510; x=1737566310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7fitZJGmD+mPGUu2xEhFWr5I1LOSHiMsZaKE8zrxJA=;
        b=c8SwQZJD3bQKMomc8YBXQd9kbb/BM/Uluz5phXwrl/IGbExilklSr6fGUdkhPP/56R
         GYQ2mcU+vJQFvNG0psYwtYg2KzZMUCiKXZo7TVjRkw1oZF3m3wYEbzZivWuHBImxLs/o
         A8xLzVR2CD5ebgV+LlFeBEKLRtjWS0u/Kh8Z8PrGBV0LpYhClsJFA/aiHDkYvlbzLW8J
         Iy/q6AG17vz9HlUzlyDVVb1Cctkx6ZdWAlWLfbotpPjq9sAgjIEJhUBVqDBw963hOJlm
         x37LRaR7GODBr/hCyhVn+cr+hqUKE9b2wrvn3r1TNGWoX1nPptunkcntGNy+diD9j+bY
         nh8w==
X-Gm-Message-State: AOJu0Yx1WKIPvCw36LFtdGit0TsbhTtlvXbYWIF7YQwaEDR2UzbSBzsp
	9YQKeLh1YgYxW8+YF82bISxOAqiSQEZ2IsarUv8uLeoEmhIEyfLBqKy2Iei/eOo=
X-Gm-Gg: ASbGncvKS6Ws+iHqL1A5GDAOdAygc1gvmkyYy4zwop3FtgejVxSnvBrR9gOW24VJ3JL
	7HgEUTEGSToQIbbgex4a0zKQeSA2zOocDeJZUt7ApKx8kA8wQ61fl2m5Y9hsHzgdLRMfDHZ6qYc
	FFg3O7P+cfB4/JgqpowyN9fWYXWYDlFQDcmal/ra+Z2HWdR4C/qfh24c7Crt+H/lYXYAQOJqBlN
	s4kuJAu4edKueVAnohB3OYJcdn+nSEvWU6c0dvQt8JkRfGcRL2M
X-Google-Smtp-Source: AGHT+IG7vzhKsdQ9lRSPCghxHXxf2rkRgM3S3yhVqS/XRs/kI8Oo9IzDktqSgUMqc+zmVCQHr/snuQ==
X-Received: by 2002:a05:6602:4805:b0:841:9516:4e2e with SMTP id ca18e2360f4ac-84ce01e91bcmr2692961639f.11.1736961510331;
        Wed, 15 Jan 2025 09:18:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84d4fb1b633sm410274839f.14.2025.01.15.09.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 09:18:29 -0800 (PST)
Message-ID: <2439336d-b6ae-4d08-a1e8-2372fc6df383@kernel.dk>
Date: Wed, 15 Jan 2025 10:18:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: Simplify buffer cloning by locking both
 rings
To: Jann Horn <jannh@google.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250115-uring-clone-refactor-v1-1-b2d951577201@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250115-uring-clone-refactor-v1-1-b2d951577201@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 9:25 AM, Jann Horn wrote:
> The locking in the buffer cloning code is somewhat complex because it goes
> back and forth between locking the source ring and the destination ring.
> 
> Make it easier to reason about by locking both rings at the same time.
> To avoid ABBA deadlocks, lock the rings in ascending kernel address order,
> just like in lock_two_nondirectories().
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> Just an idea for how I think io_clone_buffers() could be changed so it
> becomes slightly easier to reason about.
> I left the out_unlock jump label with its current name for now, though
> I guess that should probably be adjusted.

Looks pretty clean to me, and does make it easier to reason about. Only
thing that stuck out to me was:

> @@ -1067,7 +1060,18 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>  	file = io_uring_register_get_file(buf.src_fd, registered_src);
>  	if (IS_ERR(file))
>  		return PTR_ERR(file);
> -	ret = io_clone_buffers(ctx, file->private_data, &buf);
> +	src_ctx = file->private_data;
> +	if (src_ctx == ctx) {
> +		ret = -ELOOP;
> +		goto out_put;
> +	}

which is a change, as previously it would've been legal to do something ala:

struct io_uring ring;
struct iovec vecs[2];

vecs[0] = real_buffer;
vecs[1] = sparse_buffer;

io_uring_register_buffers(&ring, vecs, 2);

io_uring_clone_buffers_offset(&ring, &ring, 1, 0, 1, IORING_REGISTER_DST_REPLACE);

and clone vecs[0] into slot 1. With the patch, that'll return -ELOOP instead.

Maybe something like the below incremental, to just make the unlock +
double lock depending on whether they are different or not? And also
cleaning up the label naming at the same time.


diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4b030382ad03..a1c7c8db5545 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -938,6 +938,9 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	int i, ret, off, nr;
 	unsigned int nbufs;
 
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert_held(&src_ctx->uring_lock);
+
 	/*
 	 * Accounting state is shared between the two rings; that only works if
 	 * both rings are accounted towards the same counters.
@@ -979,17 +982,17 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	ret = -ENXIO;
 	nbufs = src_ctx->buf_table.nr;
 	if (!nbufs)
-		goto out_unlock;
+		goto out_free;
 	ret = -EINVAL;
 	if (!arg->nr)
 		arg->nr = nbufs;
 	else if (arg->nr > nbufs)
-		goto out_unlock;
+		goto out_free;
 	ret = -EOVERFLOW;
 	if (check_add_overflow(arg->nr, arg->src_off, &off))
-		goto out_unlock;
+		goto out_free;
 	if (off > nbufs)
-		goto out_unlock;
+		goto out_free;
 
 	off = arg->dst_off;
 	i = arg->src_off;
@@ -1004,7 +1007,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				ret = -ENOMEM;
-				goto out_unlock;
+				goto out_free;
 			}
 
 			refcount_inc(&src_node->buf->refs);
@@ -1027,11 +1030,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	 * copied to a ring that does not have buffers yet (checked at function
 	 * entry).
 	 */
-	WARN_ON(ctx->buf_table.nr);
+	WARN_ON_ONCE(ctx->buf_table.nr);
 	ctx->buf_table = data;
 	return 0;
 
-out_unlock:
+out_free:
 	io_rsrc_data_free(ctx, &data);
 	return ret;
 }
@@ -1064,18 +1067,18 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	file = io_uring_register_get_file(buf.src_fd, registered_src);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
+
 	src_ctx = file->private_data;
-	if (src_ctx == ctx) {
-		ret = -ELOOP;
-		goto out_put;
+	if (src_ctx != ctx) {
+		mutex_unlock(&ctx->uring_lock);
+		lock_two_rings(ctx, src_ctx);
 	}
 
-	mutex_unlock(&ctx->uring_lock);
-	lock_two_rings(ctx, src_ctx);
 	ret = io_clone_buffers(ctx, src_ctx, &buf);
-	mutex_unlock(&src_ctx->uring_lock);
 
-out_put:
+	if (src_ctx != ctx)
+		mutex_unlock(&src_ctx->uring_lock);
+
 	if (!registered_src)
 		fput(file);
 	return ret;

-- 
Jens Axboe

