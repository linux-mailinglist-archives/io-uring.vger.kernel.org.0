Return-Path: <io-uring+bounces-3436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C41991FC8
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 18:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85C051F21584
	for <lists+io-uring@lfdr.de>; Sun,  6 Oct 2024 16:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1503189510;
	Sun,  6 Oct 2024 16:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EOZPYrsJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93F5136E3F
	for <io-uring@vger.kernel.org>; Sun,  6 Oct 2024 16:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728233862; cv=none; b=LyR0B3nBmPZVG8UnUX0dB4/ovPx0Qk1huHGo+rZ9fB+Tu3lSXfZRTu2xixEB8KpGgdIgDyX5rNkFdAKrjmkkWmpQNTDyixKXgPUsfwQNUim+07BTbx/FdaUJygUEqzGIlQASdnXBeYlNr26Htfa8lrdMiFLhX81c/FtUnMSB4Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728233862; c=relaxed/simple;
	bh=qRHF9+MzDoENGKggI8R3wGG9hXH6cLq+EmJ+pEMbOKg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=tJJTK4rQdnWFWSc/MMMLSJcm9fdMguvvFfFxgrMb4/AydZ8Aqs1lxdTJUPP97wdnkgn9jg3S+RC7YAnabUAq8VCOxPEB63HhrhNA46jFiM1G/5aiTb7PgLu5jUE6LUOcbxciZSVNrpr32UaoJyZzxAUKzNieOK70n6t0izLRe7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EOZPYrsJ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20bc2970df5so27288745ad.3
        for <io-uring@vger.kernel.org>; Sun, 06 Oct 2024 09:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728233857; x=1728838657; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7RjuV/zLweuHiyiIGHapmtMjG9nb8VCEWStPB58kFk=;
        b=EOZPYrsJCz5TFWRdY15v+GMs6ZC6Ha5RYwRZ8NyjNg837hFBptvUUTOeN9c1ihPaeB
         84frQcZeE8yAYSXQozqk8YCq8S2q4Ggsmbb3G0tJ27iYXcSHa+Jth1prSzNsxaCxAvGq
         dfCRULcwjIDIlRPqHWPXXn7OEHdZnwdjVHBDKeWet0UoOuHdv2jusc16YcsR2+qv6sq/
         WhI8hd5iqqyzR2JV8tYx9dRFJ6GoGG9Q698vfX0Otd2XgiSEFTy81fQ/+4XQL50Homsv
         lLKG9OXULnQ+ZM3Zzzs+9DGdHXFFs9xS7qX8EXJfhWV+SUyDEx9fy3kR2y9GIK4dZevh
         4Taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728233857; x=1728838657;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=c7RjuV/zLweuHiyiIGHapmtMjG9nb8VCEWStPB58kFk=;
        b=OOfJXGBsl64Scr8dgSLYYG+m+3G/DjasjnZR1X9w3VorWaaNPRA3Bw7ENwTRJ44EdF
         eAOJfGMS6ZsMUOXWOqepf6nHDY0vjc4FwXunSxNvv9G7SvnQh7UK6WXrpnOY/9IRs/nD
         cvVIAxcSWEBL4edGlBpn/eiJgSdFi+D9Ii2vv1JS/yOO2X5vcoGXIp/aNupAUfB8tf5V
         itOCUndAbnPpNTpjy6RRxf+EAizbsetMS3FdzDV0uMGpgUkwdspvdF7X82nZSLvFXpBw
         4MR9pXxdD7eDJx942sgfx+oc4nwTfYIVO6BPE2a1JMo9GSCxoiZdcFAUa/fiaD88miru
         ThiQ==
X-Gm-Message-State: AOJu0Yz6XdDUwou+hMvWhOuWXrL7eFoyPhYR9qc8MDv2XJFvqNpXI5qx
	m2F7WRXw3JNmgx93IdIADMADn3nSgSlAn2I5fRGNZet3rQ5ZcbROnNwXnzDEVDzQta6k7UR3GlT
	8JcM=
X-Google-Smtp-Source: AGHT+IGaMubuO8nTNmUzBkNdt8IYLKACqzevHibho1TbFWnc9DaUiinVqYJl/3n4SZEP5HADeZGLVA==
X-Received: by 2002:a17:903:986:b0:205:8bad:171c with SMTP id d9443c01a7336-20bfde57e5bmr140204565ad.12.1728233856882;
        Sun, 06 Oct 2024 09:57:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139391e5sm27008875ad.133.2024.10.06.09.57.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Oct 2024 09:57:35 -0700 (PDT)
Message-ID: <ce905994-79d2-4783-9f49-9277238a9b30@kernel.dk>
Date: Sun, 6 Oct 2024 10:57:35 -0600
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
Subject: [PATCH] io_uring/rw: allow non-blocking attempts for !FMODE_NOWAIT if
 pollable
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The checking for whether or not io_uring can do a non-blocking read or
write attempt is gated on FMODE_NOWAIT. However, if the file is
pollable, it's feasible to just check if it's currently in a state in
which it can sanely receive or send _some_ data.

This avoids unnecessary io-wq punts, and repeated worthless retries
before doing that punt, by assuming that some data can get delivered
or received if poll tells us that is true.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Sits on top of the read mshot fix sent out yesterday.

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 93ad92605884..328c9771346e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -31,9 +31,19 @@ struct io_rw {
 	rwf_t				flags;
 };
 
-static inline bool io_file_supports_nowait(struct io_kiocb *req)
+static bool io_file_supports_nowait(struct io_kiocb *req, __poll_t mask)
 {
-	return req->flags & REQ_F_SUPPORT_NOWAIT;
+	/* If FMODE_NOWAIT is set for a file, we're golden */
+	if (req->flags & REQ_F_SUPPORT_NOWAIT)
+		return true;
+	/* No FMODE_NOWAIT, if we can poll, check the status */
+	if (io_file_can_poll(req)) {
+		struct poll_table_struct pt = { ._key = mask };
+
+		return vfs_poll(req->file, &pt) & mask;
+	}
+	/* No FMODE_NOWAIT support, and file isn't pollable. Tough luck. */
+	return false;
 }
 
 #ifdef CONFIG_COMPAT
@@ -796,8 +806,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	 * supports async. Otherwise it's impossible to use O_NONBLOCK files
 	 * reliably. If not, or it IOCB_NOWAIT is set, don't retry.
 	 */
-	if ((kiocb->ki_flags & IOCB_NOWAIT) ||
-	    ((file->f_flags & O_NONBLOCK) && !io_file_supports_nowait(req)))
+	if (kiocb->ki_flags & IOCB_NOWAIT || file->f_flags & O_NONBLOCK)
 		req->flags |= REQ_F_NOWAIT;
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
@@ -838,7 +847,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req)))
+		if (unlikely(!io_file_supports_nowait(req, EPOLLIN)))
 			return -EAGAIN;
 		kiocb->ki_flags |= IOCB_NOWAIT;
 	} else {
@@ -951,13 +960,6 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __io_read(req, issue_flags);
 
-	/*
-	 * If the file doesn't support proper NOWAIT, then disable multishot
-	 * and stay in single shot mode.
-	 */
-	if (!io_file_supports_nowait(req))
-		req->flags &= ~REQ_F_APOLL_MULTISHOT;
-
 	/*
 	 * If we get -EAGAIN, recycle our buffer and just let normal poll
 	 * handling arm it.
@@ -984,9 +986,6 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * jump to the termination path. This request is then done.
 		 */
 		cflags = io_put_kbuf(req, ret, issue_flags);
-		if (!(req->flags & REQ_F_APOLL_MULTISHOT))
-			goto done;
-
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1007,7 +1006,6 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 	 * Either an error, or we've hit overflow posting the CQE. For any
 	 * multishot request, hitting overflow will terminate it.
 	 */
-done:
 	io_req_set_res(req, ret, cflags);
 	io_req_rw_cleanup(req, issue_flags);
 	if (issue_flags & IO_URING_F_MULTISHOT)
@@ -1031,7 +1029,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req)))
+		if (unlikely(!io_file_supports_nowait(req, EPOLLOUT)))
 			goto ret_eagain;
 
 		/* Check if we can support NOWAIT. */

-- 
Jens Axboe


