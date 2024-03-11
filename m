Return-Path: <io-uring+bounces-890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96648788F6
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 20:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16B221C20AAE
	for <lists+io-uring@lfdr.de>; Mon, 11 Mar 2024 19:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128701E884;
	Mon, 11 Mar 2024 19:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GEUK/Z3/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF1654FA9
	for <io-uring@vger.kernel.org>; Mon, 11 Mar 2024 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710185556; cv=none; b=cvCpe5HJQyITDHK6rhNZxgexgPVI83NNTXsMSlA2EUd5t6lLY3pBKJrEY4Y+Nfz87m5JFyQbPnb9c46XmcQcJU+6Qhc2ODcAPNaf6dYu1Q04HyEhck7qFgY6U1NfTV/RplHcjK/XmMOGGaWIunnkFGPBOq0aPUT6Sma5cBVXe/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710185556; c=relaxed/simple;
	bh=QSfCjHtyKKZyMCZTpkTB36KbJ0T2uRPP2oVG7CMNka0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=LoDFJICT59DMeo4+WxZqYQa1mhHgHMoA7NeFjOS771FXySVn7Az96NPyXJ1hH6qagRjuy0U2XNgVSLnzdzvxgU2l5qJiWOrHCATfGD2Cgauwz8lTVsAJGCAW5gkumUmj1pOZklLkFWkDZiAFyCc9s0wpzqXWkBcVWz4JWr41mWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GEUK/Z3/; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3663903844bso3353185ab.1
        for <io-uring@vger.kernel.org>; Mon, 11 Mar 2024 12:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710185549; x=1710790349; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IXBUVBKHD0SaepaCHuxx8wZGKhlUjhGsnYarMzQ2B40=;
        b=GEUK/Z3/eTWh4OwS5km8B//wVCgX3YG7bcziDFwxZyASaXlySbR5asiQ7NzodlkiiD
         llk6lBMu3vkiDXy+7RaWhzEDHjxg+6q42hoKiKldPw/uiRJUBCUc4dL0eTo1rN3aUR4F
         PfvvnMvkcst4zruhawrgEHJgJYQXmRt738vjB1ZJQ8ZCd0W1aRxtRcIt36xpQnFLSNvk
         wa/ZDG5f+T84lI5f5yQIXGNa+tvzBXQu5e8UcNTT8CPlhVqNZijrUUcoAg2Tlr5tcaI3
         IppsAnh7Pg/T0R+ffnsNPyQ9Txk2riGyad3e3qUOE8B2BIFO2fkwfs7tUZFmho22lnVi
         9L7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710185549; x=1710790349;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IXBUVBKHD0SaepaCHuxx8wZGKhlUjhGsnYarMzQ2B40=;
        b=NtwHZ8Mnvm7F3d3z6HIwSW4No1ELrmgsyEdt1YX6PB6rdA+39GIGSXr64yBNBxVb1D
         zwYOioihyzi/LoeIpjROC9X8Q+E8YsTaXv+YaXgN6GD+59GIRlLWVNswsp8F48+V0YTP
         Tkuxby4aorXbx67YnBjsiMaoAQ96FqlrgixMCFkcswfIFqrrPXQH23jpaH6pk3sxir/m
         idrT64fP1MWJ+c8kQdg0f7z3P4hnjVc+JNHSPI8QFbKQoOApH9c5i4iZUKIVPCmq6t6T
         hM0OxPtqeLZR+t7FxbpxARBGGdmUBJ0bgHYjJRr2qQnrChlISlDVWIjA5O35oRPI0GYQ
         g97Q==
X-Gm-Message-State: AOJu0Yz7YElZdXGgZ9FbOnXRYoX7G/WPlcQrsVQMEGI/wPvx9N8PiIlA
	DqSrDS/+qy32SNmU3Xbo17+k4ss9p3V4JvaTRUosVfm5Y5dX6lkC4kZ0Wlkd5928FzuHItjTbGx
	x
X-Google-Smtp-Source: AGHT+IFrMBsIHL1OxoKNts5k8s9ZM9+bN6OEbqe3NbB+wnIBPyk+QNLRNXBSGYEkSHnEC7qywEhVzg==
X-Received: by 2002:a05:6602:2746:b0:7c8:789b:b3d8 with SMTP id b6-20020a056602274600b007c8789bb3d8mr56787ioe.0.1710185549242;
        Mon, 11 Mar 2024 12:32:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x26-20020a02971a000000b00476ee0fcb03sm601424jai.48.2024.03.11.12.32.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 12:32:28 -0700 (PDT)
Message-ID: <dc29bef1-da58-420e-b88d-912f0f1047a6@kernel.dk>
Date: Mon, 11 Mar 2024 13:32:27 -0600
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
Subject: [PATCH] io_uring: don't save/restore iowait state
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This kind of state is per-syscall, and since we're doing the waiting off
entering the io_uring_enter(2) syscall, there's no way that iowait can
already be set for this case. Simplify it by setting it if we need to,
and always clearing it to 0 when done.

Fixes: 7b72d661f1f2 ("io_uring: gate iowait schedule on having pending requests")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Just a cleanup.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf348c33f485..49a124daa359 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2539,7 +2539,7 @@ static bool current_pending_io(void)
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq)
 {
-	int io_wait, ret;
+	int ret;
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2557,7 +2557,6 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	io_wait = current->in_iowait;
 	if (current_pending_io())
 		current->in_iowait = 1;
 	ret = 0;
@@ -2565,7 +2564,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		schedule();
 	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
 		ret = -ETIME;
-	current->in_iowait = io_wait;
+	current->in_iowait = 0;
 	return ret;
 }
 
-- 
Jens Axboe


