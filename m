Return-Path: <io-uring+bounces-6816-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A366A46A94
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 20:04:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27CCD7A7C9E
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:03:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC992248B4;
	Wed, 26 Feb 2025 19:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Rn8rZTgo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33481221DA6
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596649; cv=none; b=ZUqBW4eGFTwtQqf8BcwRn6s//NQgjqfXTOollgMNSj7PYP9nQsSwkbsFJocXqOP4d46kuUDmL1wgNP/F54w9mcX5p6VJnUUb8nnGlOx/sdWMV4d6gX3GuZhyl7kmWydCAhGsVIKqU7hjb3cY+oTFfGB57fbwG8V2wqMuNqzzo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596649; c=relaxed/simple;
	bh=SZM25R8h6MyQ0XZV18tqDb9d9snCFa1SEAZAE0HUMrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GTGXcodwQZbt6tdEhWjmqqXS9T/CkbsfnuqHYfcUDHt8/e1YUJqdC7a4CsjLyKkoPbYNVQTRBySCXOAcqREaSzDEROG48MwXF+5goQD7z2sGKJ5/f59NjeYiv/0HZCJRrZ6komDporUT5MeDZDHuEre1BftvZfqNzxbzoITG8uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Rn8rZTgo; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so728135ab.2
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 11:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740596646; x=1741201446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rB4Eah3vxU92S35BcxthA4vQ5D4JS2TWUNxGQ43tWiY=;
        b=Rn8rZTgoJz7b47v5DJpzNFODzuCdlYwg9XvrWm8ia2PalIPtLB7KnZ1uOprl7IxP7x
         khLKzicxKORjxOIQkpQvrAbitVAIO4ROYT+F54O8HOgv8GOG2oLNuSyaRfG1cBGnpUcl
         HsjYeV3E015A/MJNk7kmsTRi5vRHxpaG4w9wHsHRq/qPvlrX3QkdcNW798P5G5NvGx7s
         nKlbBnVxco/UEi/xtUlr1G7mq+2CST5TnOf6R9y8fqWgKWyFZCQZQFIfOA44vA6dhrRC
         MBhqdw1ZC7geSGRk5f7vKErtGAwP09Rsg6AMjXj5pdfrXWKbDMh7wWCFBS6LjoWGmdVj
         w5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740596646; x=1741201446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rB4Eah3vxU92S35BcxthA4vQ5D4JS2TWUNxGQ43tWiY=;
        b=VVVoaaRhaQlpBq8HecUVGGp374sqIpzkrDu2KRRTrkt2ZPTuIYnyStAY9Y2O32VP31
         oZmP0vhbrnxVgukVAH+Ip8tS+AYQKa1Wm1+MNY8v2JEPovS2dhPxfYKB8235+RXYQzoj
         xT3nytvZyoF2QaXlnJm1uD6RxYB11XxS2O7iJj1WO2kgUKIBBKY8Ity3tUtPfrZMx9wB
         NEZ0ZcKBW4vBmy/C3HCpF90TmBKPLm5vZn6gRI2juGrZ5CxvCr9GVVUMsZh/juWVGuKh
         J1vwooBgQPEnUaOtQeRK45BCWPtAjnd3OCl2SrfrfLxKOr7Z9ciKH1r5UtnQr19rXNsS
         NKDw==
X-Forwarded-Encrypted: i=1; AJvYcCVycw9AViYzKFdgT0E43Pfg1/YAO9uRaekqbP/TpYNrCDWKaqnAS9Cjvl/Hb4UYwJtJmoTPaP15tw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6NmaDmuISPRhbwMZJ8QAeF7jihgMHtE0fx1MGdiLpkbnRv138
	7Qk7P3lkvP9PpkXZps6rOIxmPfVQY5tI5pya4rVGgcYvqHDK7oSwLMCwTxvRe2E=
X-Gm-Gg: ASbGncvaNCbb2E5z+PmnFLiSItTjEXwklCyXyMTEDZQT13nc+foaYrtOplpjW6Pwuxc
	LmkAcPWOAVivnnmPa3eo5HeRIqScPCneI2mYf2f/fCGgkK3/4NCJ2OCEGnf5rF9/45taRjX7AX2
	AcZmM7PKBCuVP2qCEG+xgEmoAWi7iC6MJTAPn+s1KtI8jnsq59qkQCfkp39wkhrwK6Ex9s5Pp5Y
	qmaHP8lPn36AJJIgMapxunXXZk6Cus1DEkVB3hCaKgLhrBhA2pDOTplFghVQ4XG+rU1KWHj/rok
	YvCVZVtgL3a+LDGcccGsLw==
X-Google-Smtp-Source: AGHT+IFGdm4gUg27Qjv/O1KCfXKyBBjOxuXWvgOi1stUm7jgCxRPXQd2w1RcykLJRLfUsqV6LYlAUQ==
X-Received: by 2002:a05:6e02:3f10:b0:3d3:d8af:6f with SMTP id e9e14a558f8ab-3d3d8af0135mr23418085ab.8.1740596646247;
        Wed, 26 Feb 2025 11:04:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3d93fa494sm2117805ab.35.2025.02.26.11.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 11:04:05 -0800 (PST)
Message-ID: <8b65adec-8888-40ae-b6c8-358fa836bcc6@kernel.dk>
Date: Wed, 26 Feb 2025 12:04:04 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 1/6] io_uring/rw: move fixed buffer import to issue path
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com,
 asml.silence@gmail.com, linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20250226182102.2631321-1-kbusch@meta.com>
 <20250226182102.2631321-2-kbusch@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250226182102.2631321-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/25 11:20 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Registered buffers may depend on a linked command, which makes the prep
> path too early to import. Move to the issue path when the node is
> actually needed like all the other users of fixed buffers.

Conceptually I think this patch is fine, but it does bother me with
random bool arguments. We could fold in something like the (totally
tested) below diff to get rid of that. What do you think?

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 728d695d2552..a8a46a32f20d 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -248,8 +248,8 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct io_rw *rw, int ddir,
 	return ret;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      int ddir, bool do_import)
+static int __io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+			int ddir)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned ioprio;
@@ -285,14 +285,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	rw->len = READ_ONCE(sqe->len);
 	rw->flags = READ_ONCE(sqe->rw_flags);
 
-	if (do_import && !io_do_buffer_select(req)) {
-		struct io_async_rw *io = req->async_data;
-
-		ret = io_import_rw_buffer(ddir, req, io, 0);
-		if (unlikely(ret))
-			return ret;
-	}
-
 	attr_type_mask = READ_ONCE(sqe->attr_type_mask);
 	if (attr_type_mask) {
 		u64 attr_ptr;
@@ -307,27 +299,52 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return ret;
 }
 
+static int io_rw_do_import(struct io_kiocb *req, int ddir)
+{
+	if (!io_do_buffer_select(req)) {
+		struct io_async_rw *io = req->async_data;
+		int ret;
+
+		ret = io_import_rw_buffer(ddir, req, io, 0);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return 0;
+}
+
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
+		      int ddir)
+{
+	int ret;
+
+	ret = __io_prep_rw(req, sqe, ddir);
+	if (unlikely(ret))
+		return ret;
+
+	return io_rw_do_import(req, ITER_DEST);
+}
+
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_DEST, true);
+	return io_prep_rw(req, sqe, ITER_DEST);
 }
 
 int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_SOURCE, true);
+	return io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
 static int io_prep_rwv(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		       int ddir)
 {
-	const bool do_import = !(req->flags & REQ_F_BUFFER_SELECT);
 	int ret;
 
-	ret = io_prep_rw(req, sqe, ddir, do_import);
+	ret = io_prep_rw(req, sqe, ddir);
 	if (unlikely(ret))
 		return ret;
-	if (do_import)
-		return 0;
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return io_rw_do_import(req, ddir);
 
 	/*
 	 * Have to do this validation here, as this is in io_read() rw->len
@@ -364,12 +381,12 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_DEST, false);
+	return io_prep_rw(req, sqe, ITER_DEST);
 }
 
 int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	return io_prep_rw(req, sqe, ITER_SOURCE, false);
+	return io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
 /*
@@ -385,7 +402,7 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 
-	ret = io_prep_rw(req, sqe, ITER_DEST, false);
+	ret = io_prep_rw(req, sqe, ITER_DEST);
 	if (unlikely(ret))
 		return ret;
 

-- 
Jens Axboe

