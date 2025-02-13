Return-Path: <io-uring+bounces-6408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA420A34792
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8500416F159
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 15:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4EF19D092;
	Thu, 13 Feb 2025 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jf0zeghU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0D618DF6E
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 15:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460617; cv=none; b=EArYe4fvAlxSw8M4kjZdWCSzDKndL4yqJuktZZLicb26aNmimWVh0clMfjLhPM9qKfr0FZ27GCM5bQWuLVEv+sksp7jAWw/HvWMUSb5OJkCWGQu3mvZFOKCHb+JEhCOhzGaoiUhj/AGAJKCJIcp3U6pE7L8jIO21xAmZqhtBHzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460617; c=relaxed/simple;
	bh=zY7Eq93waFJS2XIqC1mypuHNKI7vSO/zoqvM3Y4gR7I=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Z2ReGgszkLStLkQ71swJgw9NFwtPf/cljeAJ/2YOvs1EQhRTh3AT61CNvZp8qNewHlK1Z62ALqT6AWig0nymkxaZpHLrpBpKa70ve1ceFw+O8FAvtS5KPorV4nmmMhMTj57I+8sOaZHn4U8FaO0OtR/y779EqygW+7+po704MSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jf0zeghU; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d04fc1ea14so7994855ab.2
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 07:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739460614; x=1740065414; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg1Hwu+PdWOLCn0jKNH+ouZgFIMt0/37E6LhxtinNHk=;
        b=jf0zeghUlWTssOYqzZlIqocAACiQapV/PJ0nmExawXeXK5JLwDFxk2za0T+O9yk81+
         RI2iX1kBbWP0UetdSRwWTc7o9biJZU+F/1Dl7okoWjsNrDMGdBHvx0yd4r5a+FwxPnwX
         8tvKzxSltYGe+Z+Imr88vTpNxHgqKzgjXaXsXgOMFqfMQtGwlVqS5P2Rcurjxd4XsO2E
         syy79HSsVGJE6W7lxGW32KoFwpAWAsZwa+VknaB9zytNhQA50l5yGo0rGpkkAlHxTr/E
         9P7MzQwrjJ6rHTOGknJNHtKmqAEobqzOa0jr+AMAk09tjM+VI2ttRA3Kn/1qwLp74wr1
         N+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739460614; x=1740065414;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Sg1Hwu+PdWOLCn0jKNH+ouZgFIMt0/37E6LhxtinNHk=;
        b=T5R8fntcOuj8/HW7/1kmGMAvrgubTbxscDufiHYjbhIQ6xnnSMdMRKvi+r2Ig0dg9i
         rORBy1StgWY6p4+WiUOkeLmmLiE09QGmJPpHfbbQaBhPvH6/2Xr1GDDNTwP9xBOrXeKO
         Y7V4QgDLgler8LucTXRio5O+4wLFss77M66zMvUd98hnsZTAFsNG1X28xzifU+4uMrPn
         dDy7xwZ3b9HKhWuQhWLMp3vk6m0WIN+KpbUnItEeIVOhGCY/vxV1NWXWMF1tphbO5q0N
         5nnJRlLG/7mpUm+Mwl0bFUfu41Oy+kS0WMnD/Xhw1mksehYa7gBWBEQif8og4KQ7toha
         0rFA==
X-Gm-Message-State: AOJu0Yz6Jwyut1QG+hBjewny4My3xRtq7mGuvqTS/LX1BU6wJjEA+8hX
	KW0et4HTBH1KOV2cWjGiJR0GMo9mirlyXUp65iNNDr8p8m/JQHk5HqSilcv/CGDqkmbB2ClyFH0
	m
X-Gm-Gg: ASbGncsFsSgAYrVQ8IS6KNKhoXR+g74fxDa6OE/tVNJxYnR2d7aHpFhe50VKtwmKLTI
	T/eVuaxl1PNhRkTv86KLJUrOfluuFzNleeN6mN/SHe3ygV+6qb3oXZ9G5puSpC1RjLtJFX1Odn7
	RWfrETBaW9xB9IagfxukEFFoFEEBjs9Pgq6pUqYUxhzsVswuYtr16llAgSxgZ6YEMdESP69nkem
	xAOaunKqFuPu6Y+bwdOghBo5DjrazeoQUv4YKvQkn2HW+2P6NKgOoQYFmsaMQI4ep2nfKlZxuMs
	hgc37hO9iwk=
X-Google-Smtp-Source: AGHT+IEJd9YPpkZtntZFqCjhLQ9VjQODVGz94Xw7diFYLzjk6PMHAlOJbjX154aDT84rDtNzoqoKyQ==
X-Received: by 2002:a05:6e02:1aad:b0:3ce:69ca:ef99 with SMTP id e9e14a558f8ab-3d17d092128mr62265165ab.6.1739460613768;
        Thu, 13 Feb 2025 07:30:13 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18f9c5a01sm2872585ab.26.2025.02.13.07.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 07:30:13 -0800 (PST)
Message-ID: <9698ab08-3f36-42f1-b412-e2190d2e5b6b@kernel.dk>
Date: Thu, 13 Feb 2025 08:30:12 -0700
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
Subject: [PATCH] io_uring/uring_cmd: unconditionally copy SQEs at prep time
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
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Let's just do the unconditional copy for now. I kept it on top of the
other patches deliberately, as they tell a story of how we got there.
This will 100% cover all cases, obviously, and then we can focus on
future work on avoiding the copy when unnecessary without having any
rush on that front.

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8af7780407b7..b78d050aaa3f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -186,9 +186,14 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	cache->op_data = NULL;
 
 	ioucmd->sqe = sqe;
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
+	io_uring_cmd_cache_sqes(req);
 	return 0;
 }
 
@@ -251,16 +256,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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


