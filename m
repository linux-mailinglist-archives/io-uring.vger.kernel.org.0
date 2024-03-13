Return-Path: <io-uring+bounces-932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4261487B36D
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0755B286DC3
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD2B524BE;
	Wed, 13 Mar 2024 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OUnk9uhD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832112570
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710365192; cv=none; b=gjJOQ5Ct9Q35mNfZ7Xptwq8twUwujPFB7CgS9XBv3sr76Uu6hJsNmPA+vSi2mitQUD1H4JbDA0+1JXBkN0M5zR1oU1KZunsptMUJw0wJPBdzkPdx4acNkBGBgJlQ/8skjzkfLQw64xWhZtJF/dqybuQPwFAPc6VYbJsRz2zHHNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710365192; c=relaxed/simple;
	bh=810JcES+rWCPaWWythR1VOVbsMFhwgVGWka8VVOYs68=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=g0krHV5Ml0S987YTb0kXtLTc93nlZp4DJSeEtdA3pUDor3Q9n//gcimsO14jYRqzYThX76G1HYCQxZPTDaTbp+SFEeOaMdnHXKPmyey2wZBeAzSkq6I9ETaGJfzNRaBa7+gpnSAd793lefb4a2l//Cr4s///AA87JTrnVHHQ+VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OUnk9uhD; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3663a681015so558575ab.0
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 14:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710365188; x=1710969988; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDof9K/NtIl/f4ki5kVp3er0qB02Gkg+kKiLeC/MEUY=;
        b=OUnk9uhD8pZbPMucR1siXQAtLyogJJ5QlmgwPGXajNyBKg0F3hczGIeregJG7Ddh37
         amVGx8w+mZDC+bHcyvRmy/it0rqelPRW2/oTHme64P3UMqOyO+HqWDrm2lbDBK2t2Awx
         tfClqgP123RzCTE5SX5AOUaxIYeP/3sA+Ly15KxjQLI8zCQsLq61J4TL+LD8BXi2a2a/
         qlOYMJkmL1BpkeXz5kpa1mvPpFbw/8WtYu8fp8+pdZzxfq/8XsKit1eIMEgadH38xaUn
         NXTF95/q0LmKBNy3a9rA4nWXyKlr5hLVofJ4wM6WoWy2cUghOw8ygL6jSlpWAdvD4f43
         sWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710365188; x=1710969988;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gDof9K/NtIl/f4ki5kVp3er0qB02Gkg+kKiLeC/MEUY=;
        b=FFrLJma9VJpbvd+ZP69PTnV3sQ88VIjA6uWQ4OaCIPpc/a0mwozokzHAgtMcOl3I/g
         3BsBN7IGUpx7OorRTa+ONm8Ykwobgy0hjBi79y+zjL/E/JWUYPlxn8NZISgnlficFTL0
         jGWH43Z6fkjOT4RnEO8zP3gCqn1nEhNC/VkkPYXmxI2cvV1W81ByH2bXcCRkAVXiE/Fl
         IDxlnYTqiefV1B4OvclpCAwfQirif43OGdsEEpuwP6HPYOLFP+rhXZNxlcjQkakMv1CK
         vgcFL4aodXyoaoEG5R5/fNe1Irmvk/wrfdfJTknBxWuBgefRUzYZs+lvnYISnG6gF905
         xisw==
X-Gm-Message-State: AOJu0YyKgBbA+hjtq2VAjzcGi4FYl6Qe9xOKoCxOJ3dZpqbvKiXSbp8H
	00pTlNpWZirzjIwiyyhFbaHEGaQ5wTm2BSyYTKML0ea/V6fT8qoUw1hc5hiGWIhKt1ZeORU/K6r
	Y
X-Google-Smtp-Source: AGHT+IGuUX82y5LpYBaWosEKMjmoEvwcgNJqmEjGPbG7Y8My15nPvJaSh13s+YVqE1x0bSheTDI5Xw==
X-Received: by 2002:a05:6e02:214c:b0:365:2bd4:2f74 with SMTP id d12-20020a056e02214c00b003652bd42f74mr14715869ilv.0.1710365188269;
        Wed, 13 Mar 2024 14:26:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w6-20020a92c886000000b00366280c2484sm46814ilo.67.2024.03.13.14.26.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 14:26:27 -0700 (PDT)
Message-ID: <14abef4b-c217-4ec1-93d6-9c0950e972b9@kernel.dk>
Date: Wed, 13 Mar 2024 15:26:26 -0600
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
Subject: [PATCH] io_uring/poll: fix upper bits poll updating
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If IORING_POLL_UPDATE_EVENTS is used to updated the mask of a pending
poll request, then we mask off the bottom 16 bits and mask in the new
ones. But this prevents updating higher entry bits, which wasn't the
intent.

Rather than play masking games, simply overwrite the existing poll
entry mask with the new one.

Cc: stable@vger.kernel.org
Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")
Link: https://github.com/axboe/liburing/issues/1099
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 5f779139cae1..721f42a14c3e 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -1030,8 +1030,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 		if (poll_update->update_events) {
 			struct io_poll *poll = io_kiocb_to_cmd(preq, struct io_poll);
 
-			poll->events &= ~0xffff;
-			poll->events |= poll_update->events & 0xffff;
+			poll->events = poll_update->events;
 			poll->events |= IO_POLL_UNMASK;
 		}
 		if (poll_update->update_user_data)
-- 
Jens Axboe


