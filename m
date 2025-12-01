Return-Path: <io-uring+bounces-10877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A2BAAC992EA
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 22:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D82794E283F
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 21:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA2827AC57;
	Mon,  1 Dec 2025 21:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O2Hb4hPb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9FA79CF
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 21:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764624701; cv=none; b=LSrCR7Y7lcjqezeKW3losVw5Lo42loAHCURNXRMEuxEkHfRoOAlwq3/MqcVS3f7o6wHqBbXePBXFFgMQWs5pygopezUw3WKpgtKHolmfplRqfg/oVdPEEKrJAXRmhkYtP+Gie0ljwE/MM7Kb5aFO9BUESVKydInz7vFR0p0BCe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764624701; c=relaxed/simple;
	bh=XL2CB5sDiuTZ+OJZk+H9Xwof5J1Jcr14SFfLDHpMJKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HKPJpLCTyOK5v7V2ihALHBbhZoTzRmbYop14/yYjzcIw5PYpVB9sbbalnXu77ndOLY4EydqgBIlEWQqKqt+YAKsYzCmyH2v77hpvf4MmZdtpBmll+8eE7G1AM3o0Sda3dUp7643hOz3oBrmyOM3ICRaCnCzf1qISKlUwgX4yw8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O2Hb4hPb; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-3ec47e4c20eso2433056fac.1
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 13:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764624697; x=1765229497; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SNzFkX2JS6Qfs/iZwnjpRyB2He/h824sD+O3Ez2CnIc=;
        b=O2Hb4hPbVjBbS44Ylteafg6rWWBO3meDyHp9rhnFAhJTSkX3ZAuITeWBzp/6z8y8Bq
         PEDWJ27gbjORM1lzLk7z18jkT9lDSuD6sNXJLxnywTC5No3fMXuGCH10cwghO3RIcuug
         lnxXpXW/e0wAKgl62GHtk6FH+LfDSLDzad/pZCuWZxRvJPiXcktuxu9LOVBFoXote7VU
         ddmI8qvrtvYS/XXxS2BiOy8pAFaMazC9M0fV5qEQ4hUZFcOdbHBSZhNlmLe5VeSFX0SQ
         foLAOHP32Sb/CAIv4fujvmNjb3qp+VFayyCWX5pKS3cItTg6ZrqLI2gylAqP1CPxdPtM
         ai0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624697; x=1765229497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SNzFkX2JS6Qfs/iZwnjpRyB2He/h824sD+O3Ez2CnIc=;
        b=NbAycCOltRoyugmzutxq/Cn23Bt4+wxtElzBXzhngrvPAZrMjz3HK4k//aBlURknzt
         iE0zZcQX4s9HIsQdGbE32D1En9dCXW89iOPAXKfVAfMaRt6pUcx7wulNFUMbDAMoDpYW
         EyD1sPEOVce+DsMH+Ti/gUYLtvnjt+O9c8QjM62z1LTpNN4SGaFC1JcvDN0IczC6EmaJ
         u0D9CHiJFUbnVWeB+vSa0TvIXxQJKt/qMFPYctc5gyn95odihW0bOFqsfA33GUt28Oeu
         GMzZQ9gZU4pJIyYAMX8O+vdncLqVSGuhWujMG0Oadi988Lw6bDJmx3hKZiWtxORht/GE
         Km5g==
X-Forwarded-Encrypted: i=1; AJvYcCUuGo+d0onzrhyJIkasb2nqFOwWPCb2iaUt8f3aV7w39lN9J2lRDBt0aEaTDd2zRfLIo17vquFlAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx7ZqkAw4WxlqWs6LAGRidDENSWYhxwfLWtcFNO9tIvuV6FjUL
	+TG93QkhVczrQ6UoscZvcERKP1lcc2UmDifxdld8HMCAmSSMMCvkDLOu0SlSUNPVWkk=
X-Gm-Gg: ASbGnctYxL4h+rnCtzDAtnbYCs1TbLiljiq2wNRG8I1k+uQYJ99j8Lrs1znaPhRnq+A
	nRXXZ0GbwYeRuVLqWWytgZ34Na7yGy1j9XfcmnyNXNNDI+SLqAz8act8BCjmsvor7kf4AQqLVIm
	usxuaMca35muD9i6AkDy0nrAplB85SNY+dHjjuPIz/2lqaWQNwJgrJ0B4T682mZwmAsoy2AMqHX
	JkcotAUffUCFFvDQz30c3wiyiDV5MngXgYVuT9V8hiSAFGzpMbja92Dt4DCzfpUhy9PKhccr8hG
	M23UBhIN00dg03d3w/bKEM+9wPqzuQmTAu225NShmmRdqh8psPAKcBXjGXL2dcZ6S3PAlOCD1gr
	JwPnS9AT9waM3RqMsREUipii74oJ7V6gbff+E5BjETT0AqDjwu6XlfmKl9DOBeMUyltaCB1gZ/f
	vJd96nAA==
X-Google-Smtp-Source: AGHT+IEmDsMI/DJCy7XHHMD1CgyVZQfVJ2d/2ww6SRt7GJRjSNWeRH540pBRJjo2YHm5xHO+vzhY2Q==
X-Received: by 2002:a05:6808:c3ed:b0:44d:a44f:1e87 with SMTP id 5614622812f47-45112b3e815mr16516905b6e.40.1764624697010;
        Mon, 01 Dec 2025 13:31:37 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4531708f448sm4306358b6e.12.2025.12.01.13.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 13:31:36 -0800 (PST)
Message-ID: <f2fe83bd-79bd-40ea-a156-6a20ff24997f@kernel.dk>
Date: Mon, 1 Dec 2025 14:31:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
To: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Let's try this again, seemed like a testing failure last time...

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master 

diff --git a/io_uring/poll.c b/io_uring/poll.c
index b9681d0f9f13..0d5bb90d4743 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -936,12 +936,17 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 		ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
 		/* successfully updated, don't complete poll request */
-		if (!ret2 || ret2 == -EIOCBQUEUED)
+		if (ret2 == IOU_ISSUE_SKIP_COMPLETE)
 			goto out;
+		/* request completed as part of the update, complete it */
+		else if (ret2 == IOU_COMPLETE)
+			goto complete;
 	}
 
-	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
+complete:
+	if (preq->cqe.res < 0)
+		req_set_fail(preq);
 	preq->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(preq);
 out:

-- 
Jens Axboe


