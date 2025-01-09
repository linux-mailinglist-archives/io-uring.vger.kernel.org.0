Return-Path: <io-uring+bounces-5782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE29A079B5
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 15:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E499B3A6C25
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 14:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601C5201039;
	Thu,  9 Jan 2025 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yFrkv1Mg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F8C18C34B
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434229; cv=none; b=oXAM7KAFPavFtKjZ+ZGniEEyJSjzQlXkLtINisBPFKPbJWa36NuX9ByiiURTdhA0aTzXVssK2G4N9Um9iYg+VNOyINowLywmIJImWf5VtzZw9c5DFgAPIee6F9Xf32Y/VsHO7anqu0Me3g3XW8Gb9MUEALBQ5gzZbwwC9+w3B5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434229; c=relaxed/simple;
	bh=DrPvN56Wyg6vnPS8551ACMRYT9mf4Qg9u3VX06ncenU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lEU/kTh9/iBs+yqddUL8Vb4AwQJB1sRUGIHUR+T4kqdm6jwcv0KmzUGUcfRE/IVDnKYvAvcj/+Oshxd7JzJB9yat4BMIuiwG50fud+KzxOkbozRPePqyiot/NikE1/+T9AEo9KYHK4AIetv5nqucIYM409rxPFnrYXUyJhTcHxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yFrkv1Mg; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-84cdacbc373so26414939f.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2025 06:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736434224; x=1737039024; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZyXkMoTznYUQdm5k9gaaASOXCPl+FLI0snPFW7qlkVU=;
        b=yFrkv1MggAQ7yJ6ZhPx3BbQ66blxgy7x33RGncRNoz7qZ1lxULcm71SpWJjB9pXfl9
         msNtIwubVA3RNjTfdSAuPbRlSYELzXyyM3U/jNpBPkIF+sQxgqoOG+4B5GWKhrwRg/7r
         0r8c++wrXsoG1j+sT9slsIBA2guk0TzkNBWUOPHGL6qMhitHpiCZx7VS5oAzhrj6hZQf
         3C4s2WdPG5UfKGlboQQ9VFGmJPsA1JVRmdhtE7JSsXDH0sQ58JFEODI22B7Ql6Th0w7x
         FUPr8j0D4q9Ef6wPOXCtBH6gLoCJ2Pr/QpPvhMrwPcgOAlWAqLDoAph/Eh3oUh/gVeki
         ruVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736434224; x=1737039024;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZyXkMoTznYUQdm5k9gaaASOXCPl+FLI0snPFW7qlkVU=;
        b=txOPAQrAGjaQdg/fXR4WKV0HNjewxy9+CX2LVgH6ERK84TGFuS6TF/WxqAFrl+7gsn
         klgN/tHJyFBUsv8Y8BdKEOObZuikRJv8F2qm3AHZLl3QADw6f2iLEbmEosmRye1JLYj4
         fwdfJmIaf17aAGoy8MSedArHQ1pidGD7CsnKao/jc51jigVcyN0th1SZbl+WhTKtKIF4
         O4ZtG+eIoz8ehVtidFe4Th+65HZThLPoyL4x1hh68VM0IeZ7DVCBr0aeHmvkdnrpCbxH
         BboFVcSnjjTkv/Xc7oAWAcUxYBnQW5rdXScmH6BO2HpkVY7bbWVzthy0nNBe07Vyh2Rr
         bOZQ==
X-Gm-Message-State: AOJu0YzFRaAbHGYEffigVLCrcBfJJQBwfoftx4VsPEt3lYlS6fQsWB0j
	CSbxTo8No339aD14STCY+A592SKWOSk8d8foQCm+OCGVPJ9zgkwRoNEu729GuzHPZyixGTGRX+v
	k
X-Gm-Gg: ASbGnctMvQG953k72YH1bmnnQcyW13mF8S+p4DeJcbZdNOs9sphuMC52HbJW3iwGiNU
	D6fYmO8rltPY51wUwEoBTzZCAW5iAjt6DS9XV/TSyF19T6NLxWax/aVx3r2DX41tUfauvhSJ8z6
	oj51G3EF1j0glzBWQUw35nzXACCKHxLvzowEiBLNnofY/M/sYMI71v+46d2IAv075mtQ1QjXkd2
	X2KK9cazkf8HOsm+3XuRLyx23O0Q4w22mlEdb1qKoT5Z1sFoARZKA==
X-Google-Smtp-Source: AGHT+IEEF1PDlK6l1n9ZsglzbB/Hw3U6nYwAdGM6h2Tm31xC2pi28vp1drbuzEtP0h6tb6kzdLl7Xg==
X-Received: by 2002:a05:6e02:1a01:b0:3a7:7a68:44e2 with SMTP id e9e14a558f8ab-3ce3a8bb67bmr56513775ab.15.1736434224238;
        Thu, 09 Jan 2025 06:50:24 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b717815sm340771173.91.2025.01.09.06.50.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 06:50:23 -0800 (PST)
Message-ID: <c024cde0-4992-4840-b1fc-5f2982e37115@kernel.dk>
Date: Thu, 9 Jan 2025 07:50:22 -0700
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
Subject: [PATCH for-next] io_uring/eventfd: replace out-of-line signaling with
 a workqueue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Rather than (ab)use RCU for this kind of thing, add a work queue item
and use that for the unlikely case of a notification being done inside
another notification. This cleans up the code and better adheres to
expected usage of RCU, and it means that the odd ->ops serializing
can be removed as queue_work() will handle that for us.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 100d5da94cb9..8ecf3c106f89 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -17,12 +17,8 @@ struct io_ev_fd {
 	/* protected by ->completion_lock */
 	unsigned		last_cq_tail;
 	refcount_t		refs;
-	atomic_t		ops;
 	struct rcu_head		rcu;
-};
-
-enum {
-	IO_EVENTFD_OP_SIGNAL_BIT,
+	struct work_struct	work;
 };
 
 static void io_eventfd_free(struct rcu_head *rcu)
@@ -39,9 +35,9 @@ static void io_eventfd_put(struct io_ev_fd *ev_fd)
 		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
-static void io_eventfd_do_signal(struct rcu_head *rcu)
+static void io_eventfd_do_signal(struct work_struct *work)
 {
-	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+	struct io_ev_fd *ev_fd = container_of(work, struct io_ev_fd, work);
 
 	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	io_eventfd_put(ev_fd);
@@ -63,11 +59,7 @@ static bool __io_eventfd_signal(struct io_ev_fd *ev_fd)
 		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 		return true;
 	}
-	if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
-		call_rcu_hurry(&ev_fd->rcu, io_eventfd_do_signal);
-		return false;
-	}
-	return true;
+	return !queue_work(system_unbound_wq, &ev_fd->work);
 }
 
 /*
@@ -184,7 +176,7 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	ev_fd->eventfd_async = eventfd_async;
 	ctx->has_evfd = true;
 	refcount_set(&ev_fd->refs, 1);
-	atomic_set(&ev_fd->ops, 0);
+	INIT_WORK(&ev_fd->work, io_eventfd_do_signal);
 	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	return 0;
 }

-- 
Jens Axboe


