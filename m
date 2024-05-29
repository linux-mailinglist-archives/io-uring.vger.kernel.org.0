Return-Path: <io-uring+bounces-1991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 666F48D3B65
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 17:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 229C7287CB4
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 15:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2543E15B115;
	Wed, 29 May 2024 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fic/ciW4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCE3181CF7
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 15:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716997860; cv=none; b=Et9QknsuUA8hoR4iU7y+ep7DVaYoXOEKJiDZtkbbOe8jZ4NzVgYw0TcziUOZHjAjd8ho0mDC7D/y5CDYEoA6h9P8zhA/J4ZYvQkm/VSgBMRW90w91M2Kak+z2jWzM5y61LrbN8LxBPEaz0/UWZoln0uSAZ0AK9esNz+/Qx1Ll34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716997860; c=relaxed/simple;
	bh=6I8hGr1GdaT7H6Ss2KjRPS9L30c+a1ApqfeAVMnWDkk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=a/5Tksl23bGuhhd55AxrFz0ut9Ur3PZC8pkGf9rY6Nj0PqBgJCjd5BbfYlEGlTdSe0bDb5kf14gR6bSQOC1hOVF34vmDZhieBlIr1xTOOHZjAPe/IIJeCaIcjapUBQgxSabCRydG74dVbHK7+RwbytQOtIkO4lg+Q3J3ORm0u/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fic/ciW4; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6f91cb79ad7so222179b3a.3
        for <io-uring@vger.kernel.org>; Wed, 29 May 2024 08:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716997855; x=1717602655; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ay9BPdH65QvBUia8ledkpLI3BLuDnh78jKFCVuVk+s=;
        b=Fic/ciW4xc8XznCCQhZaNF06g5rI0hwhIB8E7oFcxBulYIzRUuWco3Kf6zxVeKUsTH
         391rrkCgLTXerZHxjNv92DVrGAJV0fAMvEN4uRQoWql+iXayCcaA5HhUtPZq7QxeddrF
         uXblY9OvfoNAccSiuX+4cVcyR0m1qCOU8QP4bVt6gJ9qS/4OtkyVcv9h8OmYaNy2v+VU
         FK3C33YWNKaLHDGxxLkjMvYBMUG92kZdpf6xLWgVnmt5YOcT9Dox//JNFsNP4/o0yQ4H
         /2afxwnLamH9VE3Wzit8oebnase6G2fgWQ8MnXdtEsU2VLKXxaYvmKKYM06U3wqYZ+rf
         rq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716997855; x=1717602655;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7ay9BPdH65QvBUia8ledkpLI3BLuDnh78jKFCVuVk+s=;
        b=utKO6GMZ2FAG3NYY3yyb12hgoDGNgGe6LW0lVOTGtJBI2HPATYT4rHaR4bHjhhz0Hb
         JcCZBqicsnSyRXtkzLmIImN3DPUlT/EwL5lQy74mbE77PJtf5os02udKGVOcJeBoTdgA
         EcKSOItRAvrNOjk76iuRiBsEuSP8S8zUNTt7poKeNvK3HFtut5K6cuOsc1r+sRRUtEzJ
         l7LnUcNRFonX/QGajlIDfnLKIXgh+5S6Xvygk3jFntTLCm+0OToUcIa3fFhRvAESau9O
         ih4m33ZgEv4orSFkWJ70BZCgVT+Xazxfz1AC0SHAH6hSJAIhF+IuSn+n34pQb1ZmiFls
         aphg==
X-Gm-Message-State: AOJu0YxND7dgFaERnP+blxWEb7tUSDGdm7nfdnIcTS61z81AVrCV6mUq
	ekSEt0hJBUlyIAYZDYRcLmsHmCi14BHRDbITt3Pa7DYBS8LaLkQ3+J20GFo8vKXwa785eB455wk
	U
X-Google-Smtp-Source: AGHT+IFfGFLFSWECamvVel6hLIGaiGXyJGgsdlcdchrviAUzXtfOlr1bCVDXGmn+8rzsf5qldn/odg==
X-Received: by 2002:a05:6a21:33a7:b0:1af:dbc6:6fe7 with SMTP id adf61e73a8af0-1b212eac1e4mr20355271637.5.1716997854766;
        Wed, 29 May 2024 08:50:54 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c9709dfsm100852375ad.165.2024.05.29.08.50.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 08:50:53 -0700 (PDT)
Message-ID: <f7baaf3b-6125-4471-b24e-a026bba24b79@kernel.dk>
Date: Wed, 29 May 2024 09:50:52 -0600
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
Subject: [PATCH] io_uring: don't attempt to mmap larger than what the user
 asks for
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If IORING_FEAT_SINGLE_MMAP is ignored, as can happen if an application
uses an ancient liburing or does setup manually, then 3 mmap's are
required to map the ring into userspace. The kernel will still have
collapsed the mappings, however userspace may ask for mapping them
individually. If so, then we should not use the full number of ring
pages, as it may exceed the partial mapping. Doing so will yield an
-EFAULT from vm_insert_pages(), as we pass in more pages than what the
application asked for.

Cap the number of pages to match what the application asked for, for
the particular mapping operation.

Link: https://github.com/axboe/liburing/issues/1157
Fixes: 3ab1db3c6039 ("io_uring: get rid of remap_pfn_range() for mapping rings/sqes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 4785d6af5fee..a0f32a255fd1 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -244,6 +244,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned int npages;
 	void *ptr;
 
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
@@ -253,8 +254,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
-		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages,
-						ctx->n_ring_pages);
+		npages = min(ctx->n_ring_pages, (sz + PAGE_SIZE - 1) >> PAGE_SHIFT);
+		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages, npages);
 	case IORING_OFF_SQES:
 		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
 						ctx->n_sqe_pages);
-- 
Jens Axboe


