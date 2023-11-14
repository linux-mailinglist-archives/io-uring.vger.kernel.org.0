Return-Path: <io-uring+bounces-86-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DAC7EB560
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 18:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F820B20B26
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 17:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBC72AF06;
	Tue, 14 Nov 2023 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VKgatYTz"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FBF3C699
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 17:09:19 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554FEF1
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 09:09:18 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-41ce4ebecdfso4078561cf.0
        for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 09:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699981757; x=1700586557; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YglvWxz27p1BSy3u4rA8gElmz6LdvutRajt/ssNqJk4=;
        b=VKgatYTzMt+CkEVUDIyXVvrJB1YM1l30F4m/XA/cPxjj3xkkSo79lIqdIc0c7uTc4a
         Aj+E7D23av0mwYdtsR4m7pG7tcH+eGuo3VBaYT50t+zEftoDhbm8VKY6jTasFiX7u0RL
         oUxed2+V5w0vjk/rt2gyBHqo3BvDS3IazpPOxLQBdajTPyK/5aIYwR/58F2IripMwH8D
         g/tQTG20HFjqFGU+mANwDb9H6vmlAMYjgIxTxtNHVDtYhhwDYaDQsc8lg5hHBOWB7wlO
         TID8X19esNxLAtz8WYX0dXg69XptfB6nBlgsqWpcAeLrx1OSbUZtnSRrv3OnyTPGHPKN
         o46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699981757; x=1700586557;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YglvWxz27p1BSy3u4rA8gElmz6LdvutRajt/ssNqJk4=;
        b=Wtoj3xKOdvlOtYqaBHgCJf3YYSYX92Sa+wM08sPkM1NsLCRtTKckqni7S/ObvtZ41i
         g6JcQEkuFh7kSG9d5N6LitpJJg0UROGPVZTAnOZvW5O+3gneC+WTpEH2xJHLBS73tupr
         2uTn0Bgyrzi86GaSqLmOACdzU20fOaqklOSq7fccLC7QhZfrujqyRg7mxkvok1o7IVN2
         UW0urApMDiNZYdKvYTFzjHSOWJl2QUoFL43nxmWpWO5AjLrmL+FvG0uez6yTktaV6UQN
         YYRc9rqPLOSn8cdWoBHfKV6XPG+hj/qW+2YudAPCqLpbwxswjNNGj3RFW+ClZ4EJuAHT
         tkwQ==
X-Gm-Message-State: AOJu0Yzhze+IaHNOsW80Cb4vPIPXgKHNCI4ozcgKzVgVoqmCE/UT+mLB
	+y4NFj4YUFGN/FF7wh++TBtWOC1dIf1i/gBoTgadrg==
X-Google-Smtp-Source: AGHT+IHEQv4iYIwXllqckMiFKWScF/FuolBfwGbsylacnL+oKPr2z4VFHo7DbASpjbvwljWxXGEWqg==
X-Received: by 2002:a05:622a:8008:b0:41e:a62b:3d28 with SMTP id jr8-20020a05622a800800b0041ea62b3d28mr2704642qtb.4.1699981756928;
        Tue, 14 Nov 2023 09:09:16 -0800 (PST)
Received: from [172.25.84.204] ([12.186.190.2])
        by smtp.gmail.com with ESMTPSA id l24-20020ac84598000000b004198f248e8dsm2851848qtn.76.2023.11.14.09.09.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 09:09:16 -0800 (PST)
Message-ID: <202966f7-3e79-4913-a7db-6b2fc230dda7@kernel.dk>
Date: Tue, 14 Nov 2023 10:09:15 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous commit added a trylock for getting the SQPOLL thread info via
fdinfo, but this introduced a regression where we often fail to get it if
the thread is busy. For that case, we end up not printing the current CPU
and PID info.

Rather than rely on this lock, just print the pid we already stored in
the io_sq_data struct, and ensure we update the current CPU every time we
are going to sleep. The latter won't potentially be 100% accurate, but
that wasn't the case before either as the task can get migrated at any
time unless it has been pinned at creation time.

We retain keeping the io_sq_data dereference inside the ctx->uring_lock,
as it has always been, as destruction of the thread and data happen below
that. We could make this RCU safe, but there's little point in doing that.

With this, we always print the last valid information we had, rather than
have spurious outputs with missing information.

Fixes: 7644b1a1c9a7 ("io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: actually remember to use the cached values... also update ->sq_cpu
    when we initially set it up, if it's not pinned to a given CPU.

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f04a43044d91..976e9500f651 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -145,13 +145,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
 		struct io_sq_data *sq = ctx->sq_data;
 
-		if (mutex_trylock(&sq->lock)) {
-			if (sq->thread) {
-				sq_pid = task_pid_nr(sq->thread);
-				sq_cpu = task_cpu(sq->thread);
-			}
-			mutex_unlock(&sq->lock);
-		}
+		sq_pid = sq->task_pid;
+		sq_cpu = sq->sq_cpu;
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..ecb00322a4e5 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -229,10 +229,12 @@ static int io_sq_thread(void *data)
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
-	if (sqd->sq_cpu != -1)
+	if (sqd->sq_cpu != -1) {
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
+	} else {
 		set_cpus_allowed_ptr(current, cpu_online_mask);
+		sqd->sq_cpu = task_cpu(current);
+	}
 
 	mutex_lock(&sqd->lock);
 	while (1) {
@@ -291,6 +293,7 @@ static int io_sq_thread(void *data)
 			}
 
 			if (needs_sched) {
+				sqd->sq_cpu = task_cpu(current);
 				mutex_unlock(&sqd->lock);
 				schedule();
 				mutex_lock(&sqd->lock);
-- 
Jens Axboe


