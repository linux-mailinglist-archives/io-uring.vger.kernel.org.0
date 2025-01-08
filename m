Return-Path: <io-uring+bounces-5777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08EF8A06999
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 00:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3673A0372
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58185204C1A;
	Wed,  8 Jan 2025 23:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q5vfWnzl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81801F4E50
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 23:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736379747; cv=none; b=qsMP9gIPFofipZx5YilI0LqxBVgdBr8s/wC495YV6C2NpQTDjCYglfj4hwGbuBGV08RjX27zljrGhowrePTpJuniBCFAxn9FWW8p5eoqvkVmXyTzehY8z2clVj0m5I0zlnGJ1G+1y3BmPJlTrXdpCmDDOZKLrB5bIh5zp8uc//g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736379747; c=relaxed/simple;
	bh=dZudADfEQjJTs/W8yErYVsAecqHwfx0e/3Co0MxkzQw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ogW7g7GsV7c2goU7bQdz596U0/O0LwGhCgScxo7jSWB4kbQ/aVlRRyQ8czVipHxqWx3cI8ruhkghtC7JbVqziQ0USIx5KmCLTx1UhSSob+I/I4YZ1CgHEPxyl7sGcV2dP9+vUEMYuKZ+H6aksLspSBYKvQeCU06muU0Up8KP+UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q5vfWnzl; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-844eac51429so23827239f.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 15:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736379742; x=1736984542; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6dsH+hqTwSox40TkoHxGi48KSoycEC/2fY45I+fn3c=;
        b=q5vfWnzlHZocwyahT/SyNxrHrAeTqnik3QFs2ftWxqw0/EJuJNffEh7QW/5058REHW
         UUsm8bO5C3qkR1BQaU+IGWNmThqiV7lMzRXTipVtPxOA3NJAFT6s1TloqbAid88+wa1R
         DRo43J8iJkI9Q4gE0OgDA6mxl7YQWiSuDm4SVR1ZLOw70iLDR6VbxlZjEbv51SNok3m3
         b1yBBuq0vXX759tWTfptUbaVRsb54MjW4Fao5+oBOZIq+JVIpOZOu2wlEnsFfTozOBxA
         4H1DTXiJi9BSeJHX9qZYuiuUwyeQpW6yv4IYZwKIXHSGd2zBKF96SBWa9eNyfU/vOwy+
         0/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736379742; x=1736984542;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=z6dsH+hqTwSox40TkoHxGi48KSoycEC/2fY45I+fn3c=;
        b=ewGFdFJSuGoI7YgLlrpbFgZ42IbngR3P7Sb9hY4v0wnlgnbGI+crFJcALnSr1gXa9x
         T5GusMsle+0vqOSrmK6LMBGvuIr6CNVyAu6sPKu6J1y95oW7QLutvzisvssuIu9XoZAP
         7orRbWOt7I4L/pwR7tqnQMvCy/AxDs/cbgHcRfyhlLToZzJz1UOqbML58ifdbTf9ijCC
         Fh00LQxFfBozTqF4T9mDo00AnnmCM0lld2BOLu5/ktryjjTm0AP80InTSu0cn7xPBj2I
         iKoCBiBcRDoisq2EqW1in2tMHCVIipm1hLPsL/Ad5qPX/SqRHa73hL5/wOatMRs91ggB
         QiNQ==
X-Gm-Message-State: AOJu0YzS6NppVpL/uDg35/cSsGPGdPVPVLDe64pjuJgRBx+MpbzsvwHf
	nyy8iUJ37X/KfYkhOdJ1eAWKhjnlrj1ADal8MbDSWnYtpOOHwFJ46/eDGAXwJul79x7R7z3TZao
	z
X-Gm-Gg: ASbGncthUNC/FCPS5+MXs46IlnxDWfv4+CsuZngMxfp6Wm6Fve6JId5C8clrmNSTa4T
	S8kkZy2c06GopT0vbk2oya3opCkBI88sfdVKtx1ukHv2lFmM6KHsB9I8VC/iQzOOJiIHyoJDJzy
	Vp/NCblhUIzUC6cOCaNPCqmojWXTDMEOLzIN/1G+fsFCLGHERaxXIsTN2kCeNAmExdJuTlfIT6G
	dCX33QaE7C88P9+xVEHei9HcIx2IrcD4cKDbFEQ/qjZld3flkWbpA==
X-Google-Smtp-Source: AGHT+IHqK+1M7Ro/O5k+3X4oIwJga+XPqmiDTH7zHAXK920AuQ6ow79nZRs52F+YKVjKt1UhqbaTvg==
X-Received: by 2002:a05:6602:4087:b0:83a:f447:f0b9 with SMTP id ca18e2360f4ac-84ce00a3a5amr415260339f.9.1736379742416;
        Wed, 08 Jan 2025 15:42:22 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b7488e0sm21575173.133.2025.01.08.15.42.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 15:42:21 -0800 (PST)
Message-ID: <7812ebd4-674f-4ad7-8c13-401684e8099b@kernel.dk>
Date: Wed, 8 Jan 2025 16:42:20 -0700
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
Subject: [PATCH] io_uring/eventfd: ensure io_eventfd_signal() defers another
 RCU period
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_eventfd_do_signal() is invoked from an RCU callback, but when
dropping the reference to the io_ev_fd, it calls io_eventfd_free()
directly if the refcount drops to zero. This isn't correct, as any
potential freeing of the io_ev_fd should be deferred another RCU grace
period.

Just call io_eventfd_put() rather than open-code the dec-and-test and
free, which will correctly defer it another RCU grace period.

Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
Reported-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index fab936d31ba8..100d5da94cb9 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -33,20 +33,18 @@ static void io_eventfd_free(struct rcu_head *rcu)
 	kfree(ev_fd);
 }
 
-static void io_eventfd_do_signal(struct rcu_head *rcu)
+static void io_eventfd_put(struct io_ev_fd *ev_fd)
 {
-	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
-
-	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
-
 	if (refcount_dec_and_test(&ev_fd->refs))
-		io_eventfd_free(rcu);
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
-static void io_eventfd_put(struct io_ev_fd *ev_fd)
+static void io_eventfd_do_signal(struct rcu_head *rcu)
 {
-	if (refcount_dec_and_test(&ev_fd->refs))
-		call_rcu(&ev_fd->rcu, io_eventfd_free);
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
+	io_eventfd_put(ev_fd);
 }
 
 static void io_eventfd_release(struct io_ev_fd *ev_fd, bool put_ref)

-- 
Jens Axboe


