Return-Path: <io-uring+bounces-2573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4851E93B476
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 18:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BC581C2352F
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 16:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B154715B0F9;
	Wed, 24 Jul 2024 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jyYXISrx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3172C14B978
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 16:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837092; cv=none; b=JMjtMr0eOvoC5QTW5r+tM1RJUe6c7Vg+3RNk8O0mFcH/jgi73rnNs5GtmPcxCqHSnmj2z6YFVT34c5uYDD4BTmHdXRdDUv7Bo9rc+otyn+mfzO3Sx6mJ1gFAqYDxV/0z3dCWqBbYtjbZZZL9D24c8JdRTb2HxE9c3d7teWIBgG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837092; c=relaxed/simple;
	bh=ikr5gBDonD2HiJyXw8Ll+c9f+0oV8ZZiCajLfU8r9Nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IUczhvl1vfylLuPPKHTd/Xvj0MNiPWqF0Hfq1wwTEG83oLCTVARG6G3Beb1SzAUWsO/0pb1ZK7RObNGyLxaeVsRvbVgu5L3giMxSotkgy890uzzl1efwo8by3H04ZoERIfI6acnwMePOIKrZ52X/lfzOGkvZ+T0b0BwFJNQqTRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jyYXISrx; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-25075f3f472so1365015fac.2
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 09:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721837090; x=1722441890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=73tMw1OHE7WOpgExgYC8KyJEfylv1G/UmprndBPGk5A=;
        b=jyYXISrxwa2vUMpBoRErfN6E/q685nrZbbiKJ+nyHSdzBhGKMY5MkbEZQHnx1vbAVP
         MTIRIu9qm0XSbyqIOwSOJlLyUVL06YJSWKKK1bgkp7Lrs5n6Q1kVTayRhUAiyIwKiqxJ
         ekRjh16KB5+J08+hKaHNItUBrzYCH8ZVvQcSLoPr2etrCn5+uvZzy2JYOJUeBnKhI3uP
         LE6VTVzuclybkQ9qF9xzSU5GAwA+uRu9tdjFxWjj2RUYbRW7HRqzD4VBT1R6iev9YB5F
         kh1lsqaJxwrBUmf2c6OkNaLQVVggl3FmlRLuNoQcUHomcFrsOgLRrDd/3UYAM9ExhtrH
         K0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721837090; x=1722441890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73tMw1OHE7WOpgExgYC8KyJEfylv1G/UmprndBPGk5A=;
        b=JTXP6y7oms+AoXHTmg2M66VPSgg7Im+FY9RjXCxeDKC+vL5uINAIUmnqkq1AkzW9up
         aYlwYydUnGR3Nk33iU3r1yZsmqsFH8XaE9dW2iHtJaE1Mg0ExD+CI9Do31Hj8b7CxL4H
         Nn9TjuUnMapRmVniDIyKdh4t9HkuLIluMFu+tPMSKzuomq0xe0F32ygmVFyuoR2zW9KX
         hJTNhEO0qlZcsFfG2BnY+v+zVwjlr+cCcdTFrrIuX+5uFonaVZTT1umV8bUGSa8SigH1
         AT9e4204WICkuKpzTlHuIZU8PNgGVfNE5KhjxZ5QPofWfZvTZmA6JmyLBE0NnAQuIX2s
         q6FA==
X-Forwarded-Encrypted: i=1; AJvYcCUgiGV6Qa6zSoBOJUnwU4PE7RoTXWwXEOc5Oa4aKHMWpF9mq7Js+vN83E2D+M7+YfDJ32XXH9DVlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvjfhBWBlv++poYcIMdhNiVVPp8Xax3vuJ0OqlPrM/zu4aL89S
	sO6i97IqxPPfJgWDrgPFcwRhjkeBo7Nrff07IfcnHYepI2Ywis8VjlQOV+A7PAY=
X-Google-Smtp-Source: AGHT+IE9gRK4HqlMFJboJ1JjeeShuFTXZe9GG2HtHQujHg3wQqWC/zNQbJAHHcwTFZ2c/kgv/Feyig==
X-Received: by 2002:a05:6871:5d4:b0:260:ccfd:b26f with SMTP id 586e51a60fabf-261215b53a1mr7829383fac.6.1721837090055;
        Wed, 24 Jul 2024 09:04:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2610c771ca0sm2637301fac.20.2024.07.24.09.04.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 09:04:49 -0700 (PDT)
Message-ID: <90188833-f819-432b-a865-bbba14166e46@kernel.dk>
Date: Wed, 24 Jul 2024 10:04:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KMSAN: uninit-value in
 io_req_task_work_add_remote
To: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000fd3d8d061dfc0e4a@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000fd3d8d061dfc0e4a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 4:51 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    933069701c1b Merge tag '6.11-rc-smb3-server-fixes' of git:..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=16e38d5e980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c062b3d00b275b52
> dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149e5245980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1388c55e980000


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2626424f5d73..1aaab21e1574 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1137,9 +1137,10 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
-	 * they can even be queued lazily, fall back to non-lazy.
+	 * We don't know how many requests are in the link and whether they can
+	 * even be queued lazily, fall back to non-lazy.
 	 */
+	req->nr_tw = 0;
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 

-- 
Jens Axboe


