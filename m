Return-Path: <io-uring+bounces-10874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D35B6C99229
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 22:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92B423A1C49
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 21:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BC4D2045AD;
	Mon,  1 Dec 2025 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E4pL5OYo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02367E110
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764623179; cv=none; b=F8sIGvMsR25yN5HzomtdCrnjLjQ+vY2GDyFzLB38j9hhaY0+vx0G2/kXGuAI/WN5tYKyt5HBwn0F/5Qz9+I1yHkXs9rRFmY/Q1M3nK5S6H0YewbhLqtBnMLeQ359czjo80klgT2pGzPTAZ7zzB1bxPVNgPg65pZ05yqAjEDaHqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764623179; c=relaxed/simple;
	bh=b6VTTy5g4PFC+6Z92IML1QpId46vDfaiGHdcUyz0Xlc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=S7oh9NqfoIrWVxkcEHQLqUq0O8ztSbKQ0ZlnZnoMlhJe+Z7a7NQApZVY5XjqqSbpcUr1+GHavIDjvo75wJRJHyRVYmot+DzYaeN6DlSAy2c/7ME7DzhXnNCvDF4P71+a34FeWHEbYEeYllxh2D4U4BGBoDtsYzTLcS3e8VufUFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E4pL5OYo; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c6d3676455so1403090a34.2
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 13:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764623174; x=1765227974; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbsbkzacxZp5zpLkb4zogXomfYuQldzc70GS6tLzP7o=;
        b=E4pL5OYodoSns67S0uPMsREW2naxFdkYVxOswejXU2xzbyRvJcShvkGo0z/ALQgs3y
         JO50D8kU9/WJyEEZG6RRFny7OQAHF1GY1hjUIMX8jwWYDogm9JUsHYs7vC2qJbLEliXf
         t/WNclbXMPa4zfTcVt7uZjDmda0ZhYOPKUT5OivEVsamiAPdN82BvMO86svQq8/Hl1ki
         4byCRwpHuVzSuOn4VD4OIzlkOt+tcwoIR3I09dwtUS9AlsQmDOW2ltZ8Vr46o+ErY0JH
         LLsI5jrMnMGn1I0VUIZRjqECivvO/Bv3L0YQVvGucW6D2Mp14yMaibBT95w5N+3c06Xf
         kNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764623174; x=1765227974;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dbsbkzacxZp5zpLkb4zogXomfYuQldzc70GS6tLzP7o=;
        b=Knmn9TMZX3jIAbu8wib315vO2T6ugMsBk/r8j/us48U8X8xIHvpdFkY6tlHaXmQzXU
         58A2nCqX+0IzWKLi6/yu2EZrkRfc6p72bK7sNeOevDqbiL39OABDHKTGXE7NlQ7570iU
         c8X3/ElGxO1PKb33JvBY+mUGpgd01FLanxOC8Ky54gInLqWnnDGTQhapIOBZtmICo3NO
         GebjHax5nuFCfn1s0f8P3uVa1In0ItdVpIFJNIp2SVDh5+o3NSDb5qIrvCLUNTIE7w3c
         XbE357zD8Kqvcl5mvPikKTJ46fgxncPGTns4IqS47HBoZYw+HV0xuHRYND0KbOW8FSE/
         l4MQ==
X-Gm-Message-State: AOJu0Yz+KxpSnDk/TB2e3zkl7mp7Max71lfBwbFWrtwSoK0scAZ3MsPf
	qkp2HDGX/9FH/Nttu/FDBfxgANWVYZEyzjwbtDhSaH7NsRsQDrYhjLdI67EoiFM5bij9Qit+9bX
	suHNnFbE=
X-Gm-Gg: ASbGnctC3RJU9TAjWQElnbMAcgc5ZZgeVoI9OgKF7SzlvfAWKPEPsheAunEzYqAasCw
	K2+T3zZ9+Lzdlw5LKH/NoWhL+F+wIR4EJodLn49AirvKkotJNrryxAu8IF37FQP0IMNEt0cDz7o
	i9dX02Uf1epJ2b5jbLbqRzaC1s4xQetmEsEvw3FJQOXYVMBm4zkuS6Ysvp7cSaqlDaysCeeDljZ
	E1PBawCr5fOzs8fazRM5bzx3e/mfqfmkQlL7GTMYMrZRH2KdKwoIPUAOioyUTLGh5fTmMqoDqpT
	Imr/MsEMAN5TObVfASFa34Pc78VKJAxCvIqkp+bVcQ6yemUkJL6YUET4vKlpXTMUsh/VnrMf6cf
	QCBOfnvjc6ZDuHaOTVMTS9HclkA+2qZ04AYEvr4EaU3S4FMZKeE6laZq/6LsdsIb7Uk2yLc5pKn
	AeiVapvw==
X-Google-Smtp-Source: AGHT+IG+vp9Vu2rI4VQeEz2Lrb6ZbC2i1o5KquLZDaj5f6lWxmhTUJY8MfBcxr0GWhoCc0MnM2PSSg==
X-Received: by 2002:a05:6830:3491:b0:7ae:56f2:c2c5 with SMTP id 46e09a7af769-7c79908f7d5mr15137020a34.28.1764623173975;
        Mon, 01 Dec 2025 13:06:13 -0800 (PST)
Received: from [192.168.1.99] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90f5fedbbsm5262147a34.10.2025.12.01.13.06.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 13:06:13 -0800 (PST)
Message-ID: <586014ce-acd0-455b-bbaf-ba85183bbf25@kernel.dk>
Date: Mon, 1 Dec 2025 14:06:12 -0700
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
Subject: [PATCH] io_uring/poll: correctly handle io_poll_add() return value on
 update
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

When the core of io_uring was updated to handle completions
consistently and with fixed return codes, the POLL_REMOVE opcode
with updates got slightly broken. If a POLL_ADD is pending and
then POLL_REMOVE is used to update the events of that request, if that
update causes the POLL_ADD to now trigger, then that completion is lost
and a CQE is never posted.

Additionally, ensure that if an update does cause an existing POLL_ADD
to complete, that the completion value isn't always overwritten with
-ECANCELED. For that case, whatever io_poll_add() set the value to
should just be retained.

Cc: stable@vger.kernel.org
Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

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


