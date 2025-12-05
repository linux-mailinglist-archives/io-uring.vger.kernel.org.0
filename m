Return-Path: <io-uring+bounces-10983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E61CA893A
	for <lists+io-uring@lfdr.de>; Fri, 05 Dec 2025 18:26:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CE7D23057B0A
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 17:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEB235A92A;
	Fri,  5 Dec 2025 17:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="thWmIQR8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F555359FA9
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 17:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764955450; cv=none; b=JpmChH7WmFZgG5f8n95pvfe//Fufi4D9fgR5vh46nAEXNiAYiz/ieUCd4b++t5lBeCLPKpeV9WbyPqEwTcLGPlQXaZkydH2QD0U3D6rvfxl9YdiuPMZHmg5e9jhQMgYBn6zjGch+yzBJUIyIAsaIXE3ltUjgMoMsBi0OtC/SKno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764955450; c=relaxed/simple;
	bh=Tm9QbInjvri2KqcjjPu6WSy6P+w0rSicxxnUfNjL0nw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=cd0Wv29ApBn8iGSegrxYWEHsvhhq3LVb4Y9vc6kNVfrdtezSxx1YSz6c80DkprtjQoxcmajuuzklJ1uX04UKG2mTaEFdQys0k24SUsfuKkpbAJZ/o/9IhAiEwIM4fsEmgSQ+RDBL8Xq8r5u1rKA9UXLaYMAnm2/GZZ5YwMnDBIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=thWmIQR8; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-45392215f74so287846b6e.3
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 09:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764955445; x=1765560245; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPtx0108RwpDJInCRjkqkR0VQdTPYRl3DZbPJmJNGOo=;
        b=thWmIQR8nB4U61EeXaX1KXKaZCIcfi5P1B1r9hB7qgO9F/RkHEWbMNw66PGxb/4N85
         ZTwVugpFk5W5vgXq77YsvajQaiww3CDn6QJwlY8nRJbA9E3fUGdtCXYpRwieCtq2Ae3T
         L4Zi5t3HxXz2YnBtK7OCkXsuxdjN4sgHRPFdqUhBVGlaOTzJEN9B3cmmj+1gwFApwQaV
         ztYET+0Zsnq3BUAZ0NygC4KZm8E6Ydkf4FzsZf1cDcwrIt6qIMxVmhdfnJY/b0dtzTMa
         UHu8ChScStHwZWyLTKTisDABNdFN/SFN3Sg0WQi7kBbHIR0QDIR3FgsVInX9aM4UI4U0
         FJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764955445; x=1765560245;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UPtx0108RwpDJInCRjkqkR0VQdTPYRl3DZbPJmJNGOo=;
        b=pQV7bW2GkddcqjSdsiwtnZCap6kEqp9nQIYxNeaXoDcr/+xmfbrG0klW5S8em03Teo
         L/lIbJ8lEGO0c8FxuUAvfGw9b8zpF5uP/GPqlBFGX+lEPo5tIrYOl038mX4lbs1ak4eR
         sqmrJqx0TYSViiPrNQjlgR6G2k5b2orl5eIhFY7dB9a76QlQ/uZFWvvikZK2M10K2ZeK
         zESAjvBaF4q0tyT4I9Zvw/u0TA+rmDGPCdOTRgotgW7ZAOasYdrdBOurFoHxzy4ipCkn
         yt7Gf1fS71lTOGx9CgZOVukzhAOCyhQTZmcUl7oNz5QvlfL1Hfc6s/j9afptrWtvrP9q
         T3gQ==
X-Gm-Message-State: AOJu0YzM5ll8/EJ5qAEhGBe9h2RFLvwCDV7aqaO9GCDY1E5VfFofQ543
	PDddbajPVyIJnk946qNJO8GfLQzzwg+Xuoh82AAtGA/SP6xfwGVvYMUZJZ8AyosAnzYl57NMpwv
	ugrjKz+E=
X-Gm-Gg: ASbGncsL9dI66mNqGl+ckuZRc7Jbo2xa3hnMAB9+/9hnraGfTZV0TSTc/i/jVUxRTyl
	LwBmX33diD5KzDLzqFVOo+oBUoIHZpMSQVgtB1zkaLt8t1dHt/GQDp0hJJsU9IqAWt/IcSNojAn
	+uKj/DjhJMPG7pWrB3Ite7cAhS4whprlI0uLGp3MiJk79RMJd386QQ3d+MI8Ltx3db0xDaMdy4G
	j26I3vzD5HqNwfBZgIVFoWFld2FUQ8fw0JGtOTY+up20Bj2MuZROW+193NA12TyfyS/pOKkYZHl
	Q4mry4ezLQxhVuNZ5drqW0pdOB+9fO81Kyq+/fe5GKna1TW6ZzHJP5YSq9KlEzC8bF8TQgBSDuC
	B9fxRsMQEcbk05mKP8tN81/+X0DmbA9reTheTn7ECl/Uxmp17w+DAsRYupxj4uEgk+TQXTypH14
	4Z6ObchpQ=
X-Google-Smtp-Source: AGHT+IFQbew5YOE8VoOsAJpA7GqbxVQSzhmarv9Z/sePVPLoG93OErxYz4o0MyPgBBGWd4Tsd+z/Yg==
X-Received: by 2002:a05:6808:1185:b0:43f:cc0d:f043 with SMTP id 5614622812f47-4536e3fccb3mr5562652b6e.20.1764955445419;
        Fri, 05 Dec 2025 09:24:05 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45380160c55sm2453212b6e.20.2025.12.05.09.24.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 09:24:04 -0800 (PST)
Message-ID: <17134899-a9e7-47d9-a2ff-ce9c105b3b51@kernel.dk>
Date: Fri, 5 Dec 2025 10:24:04 -0700
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
Subject: [PATCH] io_uring/poll: unify poll waitqueue entry and list removal
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

For some cases, the order in which the waitq entry list and head
writing happens is important, for others it doesn't really matter.
But it's somewhat confusing to have them spread out over the file.

Abstract out the nicely documented code in io_pollfree_wake() and
move it into a helper, and use that helper consistently rather than
having other call sites manually do the same thing. While at it,
correct a comment function name as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 3f1d716dcfab..aac4b3b881fb 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -138,14 +138,32 @@ static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
 }
 
+static void io_poll_remove_waitq(struct io_poll *poll)
+{
+	/*
+	 * If the waitqueue is being freed early but someone is already holds
+	 * ownership over it, we have to tear down the request as best we can.
+	 * That means immediately removing the request from its waitqueue and
+	 * preventing all further accesses to the waitqueue via the request.
+	 */
+	list_del_init(&poll->wait.entry);
+
+	/*
+	 * Careful: this *must* be the last step, since as soon as req->head is
+	 * NULL'ed out, the request can be completed and freed, since
+	 * io_poll_remove_entry() will no longer need to take the waitqueue
+	 * lock.
+	 */
+	smp_store_release(&poll->head, NULL);
+}
+
 static inline void io_poll_remove_entry(struct io_poll *poll)
 {
 	struct wait_queue_head *head = smp_load_acquire(&poll->head);
 
 	if (head) {
 		spin_lock_irq(&head->lock);
-		list_del_init(&poll->wait.entry);
-		poll->head = NULL;
+		io_poll_remove_waitq(poll);
 		spin_unlock_irq(&head->lock);
 	}
 }
@@ -368,23 +386,7 @@ static __cold int io_pollfree_wake(struct io_kiocb *req, struct io_poll *poll)
 	io_poll_mark_cancelled(req);
 	/* we have to kick tw in case it's not already */
 	io_poll_execute(req, 0);
-
-	/*
-	 * If the waitqueue is being freed early but someone is already
-	 * holds ownership over it, we have to tear down the request as
-	 * best we can. That means immediately removing the request from
-	 * its waitqueue and preventing all further accesses to the
-	 * waitqueue via the request.
-	 */
-	list_del_init(&poll->wait.entry);
-
-	/*
-	 * Careful: this *must* be the last step, since as soon
-	 * as req->head is NULL'ed out, the request can be
-	 * completed and freed, since aio_poll_complete_work()
-	 * will no longer need to take the waitqueue lock.
-	 */
-	smp_store_release(&poll->head, NULL);
+	io_poll_remove_waitq(poll);
 	return 1;
 }
 
@@ -413,8 +415,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
 		/* optional, saves extra locking for removal in tw handler */
 		if (mask && poll->events & EPOLLONESHOT) {
-			list_del_init(&poll->wait.entry);
-			poll->head = NULL;
+			io_poll_remove_waitq(poll);
 			if (wqe_is_double(wait))
 				req->flags &= ~REQ_F_DOUBLE_POLL;
 			else

-- 
Jens Axboe


