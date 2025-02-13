Return-Path: <io-uring+bounces-6415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0CDA34A73
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE9C617768D
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0223624BC17;
	Thu, 13 Feb 2025 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Gs5jwE42"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C52148855
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739464261; cv=none; b=PWpsQ7/OBTUl5nN0ARff2tzUfdVDRPdzsuJsVup6QvWEIE0TsMCF7kfaKrcsVxZfMU23SikC7B6RTJO01tDqwxjV1wkMD852kqwG/owZOWIn8xNaHYsFQVFHUB16vgo8xTJifDf9rx5CdAYAS911FYt4nblrSExgLF994/l1M0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739464261; c=relaxed/simple;
	bh=zzQ6662ldkmswOQ1k6zoe8UsKZdVSF14gi07jdSlCI4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=blHVgq9JvoWs6AjJqOLSMSHz57Wefmh4VxjJa064p11Am9qlcwQ2txVfwBePXp9Dhqr1WC+JNf0esPZhhFE6pEF14Prs1f0twMp0iwNWo/BdhXdJtVUJvQHueu4QRBsF69XW1Duthap/rycKP2VPz87F/Li6r8AgjmPlkbR82e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Gs5jwE42; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cf8e017abcso2830495ab.1
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 08:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739464258; x=1740069058; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBbTGBsdiScJJzW4A2QQ28/L1v4+62/cVpBNuetwoNM=;
        b=Gs5jwE42URxUdYhnkq1m7q+C4lFvuJxw9ftDfNXgXbxwJ90z5TKceaizoPDfmDBOtA
         sED1M2DilBJWzTiONsZ8swP2/RGH1LYp/FeYNwNAt2wwXW4Nn1F2W+W7V0H+PzmRLHav
         OFj+lqx7+AcYfRXhy6pU+dsnlYrim+7W7RKv1suazPXgIkkdh9YhUjr5vGC1CI8KCqBY
         WKW8F0/bSZEYedajRyhK+dYTUgX7x/oudqQ9GBP3Lxin7ktEATkXX8SlDshYRc3Rel3a
         yW+1jbYFQDuz4IPpsHyhI2Oix8aBDvvQ76AYOptmmGRMb4J+/rrSSoaknxl8jJ2f26oM
         TVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739464258; x=1740069058;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LBbTGBsdiScJJzW4A2QQ28/L1v4+62/cVpBNuetwoNM=;
        b=EviKklOURVn7pnBpJ16ZM5VSArX7mSW6udF2yk8UZC0OkcS/iO38Eoo4X6HqUaC1vT
         I2n0lPBhcWC7mA/km3yMWN7iUtVsuBWEoCuQlIpO5yf9lDZrBc9lGL/8NfeQ6flomlkx
         ioKNoY6ADqFQ+OqixxO3I/F0IUcuU5WyuhU1eABkPF3dPflXzWVgpmz6tKdehvX/pwfT
         o0sLBriToOf/kbZMwKfYNLLAiRMsrBcQeIxc+PF4GZ/CeR4rOvhHfndVKtUzc7zGXxVE
         CCAFwr4AvIyRetLG52dtonBuChgmi5nArh+4zDh5+16y4Gp5LO3CO5rxHaKvuKKxScO+
         ejdg==
X-Gm-Message-State: AOJu0Yz5gmPUqiQO4p+NAH9lIsdljadvW5mS/ipOdi/6Z9RMfe3+B6Ns
	vr5Ulf81Duu9St1m3yRnVJtA29bDCKJqCnb950DPylkl8PALPLFUlHskxN0n+sq/bybqXSftaH0
	P
X-Gm-Gg: ASbGncvYQrBonInem0/0HWzTN3C+Tla/8NQuZ3BTkDn77/yr1XVYcdVjWOhbc81SU4z
	TL5vjt873txoXLmFqlLS4HdUyJ1o1qqmaA7JKaeZhx0J40mXsvbp9l9ky9+DWlTF0oAfz2aP1HB
	U3ccUMVTetTbg3KELjeWyE3J9oyxrBkrfZzD9p3bYpgPnjM2Xn8aG7DDIx22lBFCfYZHU6gLKT4
	a2ColLTsdkLwAAixshvTGLjCgEk3pfdr8pB7jxd1P9iN4u9dsAjrNVvHX6V21bndA9KM6FBK5BF
	tog3rVv3qrs=
X-Google-Smtp-Source: AGHT+IEcbN1cv2DK6VHRs58EduX1kpJk9Fr8czXKTiiZdBUJyKmg+SPekqeCYhjOvikn2lNBgTrE1A==
X-Received: by 2002:a05:6e02:3706:b0:3d0:4ba1:adf1 with SMTP id e9e14a558f8ab-3d18c325a6fmr36625755ab.22.1739464257910;
        Thu, 13 Feb 2025 08:30:57 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed2817169asm394882173.40.2025.02.13.08.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 08:30:57 -0800 (PST)
Message-ID: <4e4dcdf3-f060-4118-911d-5b492cef8f8f@kernel.dk>
Date: Thu, 13 Feb 2025 09:30:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/uring_cmd: unconditionally copy SQEs at prep time
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This isn't generally necessary, but conditions have been observed where
SQE data is accessed from the original SQE after prep has been done and
outside of the initial issue. Opcode prep handlers must ensure that any
SQE related data is stable beyond the prep phase, but uring_cmd is a bit
special in how it handles the SQE which makes it susceptible to reading
stale data. If the application has reused the SQE before the original
completes, then that can lead to data corruption.

Down the line we can relax this again once uring_cmd has been sanitized
a bit, and avoid unnecessarily copying the SQE.

Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2:
- Pass in SQE for copy, and drop helper for copy

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8af7780407b7..e6701b7aa147 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -165,15 +165,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-static void io_uring_cmd_cache_sqes(struct io_kiocb *req)
-{
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	struct io_uring_cmd_data *cache = req->async_data;
-
-	memcpy(cache->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = cache->sqes;
-}
-
 static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
@@ -185,10 +176,15 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 		return -ENOMEM;
 	cache->op_data = NULL;
 
-	ioucmd->sqe = sqe;
-	/* defer memcpy until we need it */
-	if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
-		io_uring_cmd_cache_sqes(req);
+	/*
+	 * Unconditionally cache the SQE for now - this is only needed for
+	 * requests that go async, but prep handlers must ensure that any
+	 * sqe data is stable beyond prep. Since uring_cmd is special in
+	 * that it doesn't read in per-op data, play it safe and ensure that
+	 * any SQE data is stable beyond prep. This can later get relaxed.
+	 */
+	memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
+	ioucmd->sqe = cache->sqes;
 	return 0;
 }
 
@@ -251,16 +247,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ret == -EAGAIN) {
-		struct io_uring_cmd_data *cache = req->async_data;
-
-		if (ioucmd->sqe != cache->sqes)
-			io_uring_cmd_cache_sqes(req);
-		return -EAGAIN;
-	} else if (ret == -EIOCBQUEUED) {
-		return -EIOCBQUEUED;
-	}
-
+	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
+		return ret;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);

-- 
Jens Axboe


