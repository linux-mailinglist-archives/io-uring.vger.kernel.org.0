Return-Path: <io-uring+bounces-11831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BAFAD3BDBB
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 03:56:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9E4CB3435A3
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 02:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836A71ACED5;
	Tue, 20 Jan 2026 02:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yrO8Bb9P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B79500978
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 02:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768877811; cv=none; b=o8Z4rw64Js4zb1VUWGHTlKEgsRkX2iYmhxC2uaS/OEIH/h5axjCEg7MEmtetCa9uRcyhHj+2nhirwjjWHo7+xbBMn/aOVG+d64091O000qrQGFHil0F4uPfldqC5VDRXitMeVo8X0359i6qb8k+rNzJ4a7FeGDQ1dG4pbFeJVNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768877811; c=relaxed/simple;
	bh=OebYXL57Jq6e7An1dG38reFRxetciaLr3BPTh9q7eF4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=OG97vHRPQHGx1krlx5wy1TVXVD1NDf8RtTifuWvr/dvikPwAIlvUZfc/N8mSVk4qLtv7+gv5o+O/YyQeXH+GgBR7ZaqLMG7PWpfEamN3Ub9BH/yWSDDkiJTWQl6JNwXG34OcWSERSpHbPtE8mKKJ6+6PUig3uErNiC10A0zgTXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yrO8Bb9P; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4040996405eso3161454fac.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 18:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768877807; x=1769482607; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRARAdDu9DdjRluOz79l91bHMxOrX0XsfGE39MBjtkE=;
        b=yrO8Bb9PieatizJo4e+x4b7w03bSCmUpXzB0C6R3XWwMBBTSyeMDyHPCZPbfIvrImN
         FoRPD2XWOSNRlqmn26FxX60o1sMXhkLdEhYNWWpEokFDwk/3XAd4tqGuCzEB9AQFbbMz
         6+2BmrZo1BGOnnoFbWAqCRi/fr9G2Zfblk54m08a7qz4IkuQSWIpeZuyAS9GrbCChVnv
         xLtTMHXNvYy49JRvTk+9st4+Pj2dnCS1XdYdy7pLSF0AmB3ZYruMhsNH05fOM/CKgGqS
         tozgTSBa8wRQQl5282C1e9B586mnKRFsftKzYKQqHsL5/ZrbKJjplVAahdR2uSC3exl4
         tyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768877807; x=1769482607;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GRARAdDu9DdjRluOz79l91bHMxOrX0XsfGE39MBjtkE=;
        b=esrQHdY14iybgUMbpAmRHtD3MJik8jJXqMOideKDxyJQ4OGYZi4Jmgwi57XniiiGeP
         Vw+hi+oykO5RdknEjXbReA2BP8BS2ZcdskFyBQYXd5TVXsqWEZfcu8dWuprFBNjtkjPk
         cDkLSOSUhj7rQMh/D1VfDaQez8TXvOerBz7TnzE2chYGiG07anxfwNV93Wza26ddHKAV
         KN/S0PgwA1P0m3fP0L429B64dLBG07r5CNGTtQkq0bzVGr8EoPK40DP3oJm0KlZNNj4I
         OpXkL3rklLfw/EffAkxSDyL2N7u9S3/VuFs2gzyNFWWbbouieR0dnua8IPpeOKxOr5uS
         7HJQ==
X-Gm-Message-State: AOJu0YxuSAf32mmgj6s+0maExTRTc9k3D9zDHpYyXL3x5PTGoXheQT1R
	jBeR1esIO+fe5PytGjwR+5npaN5gvM8CEQl65n6B9+PQyiVd4dr8QqoY+iQpKBTvlGAyB3MCmxw
	nO4yF
X-Gm-Gg: AZuq6aJ7EIya7R4WLCmqlE6qTJ93vAXqg7puwLGlMQfe+NwJDsmZc9T0LUCpVXXwLNc
	7zS28t+IJRIIN+wis842VdJVC9m4cMInKG4G4831EerLP4diehhOf/K3cdSCHOvwQr2Q0HBFGjr
	ELCGOKv2uGmdV5mrVGNHp6dHK9/9sa+CDcmOZ7M756nqj/vgchwdMJyMr7/PxIbwQKIizEel7aC
	aDpKRmfWvWXvMiJUrCOgUFX4mGhPycAPOjgF3Kf5HtkPYjZIhPHaaSM9kvSgJXJ3M8/EQAXbZEn
	u4ILKYPs4hek/ZAQroC4trSEzZg+sJ8XZH5xNAGPwn0197r9Xg6WXoork+fseOX25gqWPVI92IM
	750yZ3KHwQ63opjC0iJPSOmGD8IV3+NGX0PgQ1OrZBlb67rOr8XL7dvadsucmWH5SxwxHAs8td2
	wai2msWxN5p/+h+ME+MmplDPA7CuNs0wswym+EcHoAGBny5vfLCAfbSc7szItdGkFqgkP4XQ==
X-Received: by 2002:a05:6870:a104:b0:404:43c1:28b5 with SMTP id 586e51a60fabf-40846aae344mr206817fac.14.1768877807488;
        Mon, 19 Jan 2026 18:56:47 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd150dasm8268481fac.14.2026.01.19.18.56.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jan 2026 18:56:46 -0800 (PST)
Message-ID: <7efcfd5a-d00d-4dea-b69a-0be272057946@kernel.dk>
Date: Mon, 19 Jan 2026 19:56:45 -0700
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
Subject: [PATCH] io_uring/waitid: fix KCSAN warning on io_waitid->head
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Storing of the iw->head entry inside the wait_queue callback, or when
removing a waitid item, really should use proper load/store
acquire/release semantics, and KCSAN correctly warns of that. Ensure
that they do so.

Reported-by: syzbot+eb441775f4f948a0902f@syzkaller.appspotmail.com
Fixes: a48c0cbf28c0 ("io_uring/waitid: have io_waitid_complete() remove wait queue entry")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Introduced in 6.19, queued in io_uring-6.19.

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 2d4cbd47c67c..d25d60aed6af 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -114,11 +114,11 @@ static void io_waitid_remove_wq(struct io_kiocb *req)
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 	struct wait_queue_head *head;
 
-	head = READ_ONCE(iw->head);
+	head = smp_load_acquire(&iw->head);
 	if (head) {
 		struct io_waitid_async *iwa = req->async_data;
 
-		iw->head = NULL;
+		smp_store_release(&iw->head, NULL);
 		spin_lock_irq(&head->lock);
 		list_del_init(&iwa->wo.child_wait.entry);
 		spin_unlock_irq(&head->lock);
@@ -246,7 +246,7 @@ static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
 		return 0;
 
 	list_del_init(&wait->entry);
-	iw->head = NULL;
+	smp_store_release(&iw->head, NULL);
 
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)

-- 
Jens Axboe


