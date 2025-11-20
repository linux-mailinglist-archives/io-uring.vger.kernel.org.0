Return-Path: <io-uring+bounces-10704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EE734C76319
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 21:24:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 06D254E1CAF
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 20:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDC041C63;
	Thu, 20 Nov 2025 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vpgHedWq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33314272E6D
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 20:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763670264; cv=none; b=LjK/OWYTcA7THv1WV3hK/uIcqG/FXQ8VQV0bG0m7K9ieSy/7bdgwVBnnHGP1dJCHhiB/1RHkTVlopJJbROc8kgRvDWN7uVOQj/VAWK1vH2HSr9N+vSiur2i6werFdZwI7WV/cUiaS8htN1Ea6tHLzOccd5WcqbTyqx2DzoPVt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763670264; c=relaxed/simple;
	bh=hWnhQd65Fkhjy/cyw/Jgcm8E9o/Xhpgm8kiBcXDFQ5E=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=It2QipG/FG+q6ajbyS9//0eTCj6qTTdcJjXjfoDbRbSdSKu0FPL15fxdB2Hrk04h9mHm5Mw3nVAdSI2ppxfZAJ5GPZAoZ6La4RkCqyaSCPTbJS/9B87cCaTAOVBnRdsNYtVbwUSqwPq/4Qmh46tAOVbJdu9XK/8IEzJ3W9UCqcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vpgHedWq; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-948733e7810so52357039f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 12:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763670256; x=1764275056; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEZkF8ip6lH0j5KseH7h2l8XIkv/9hdw7WQ/882yat0=;
        b=vpgHedWq4145aoFZJxfb3KCAjjnDbuz3pdjZpXMOQNBpb0xb2rhgFObbxWnvKIoI+Q
         Mb/TbiaG6MaJiHLnKz1+EvSD94KEwcGo2yLqHKqhiquboBfAaEcOQARx9uywo25w1oOx
         nx4UuxsWAgEl5nV3/3wyUHtWtNl337M1aVeqn4CP3h1N1GWHGYj1S1Xwa36L08IZJWIj
         QK7gMWdUo9CwQC9+uQDPfUuMgl6tDZoa6M78FH+PMyGoE2KWh1JgrSU/ZN1WEEvjztv+
         79QGd90cdH1ZHCp+Hold+2TGUGwOPA0MeAkfbWbJGaH+jZ249vlYi1JiyWRPQoL7WaWZ
         3PRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763670256; x=1764275056;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pEZkF8ip6lH0j5KseH7h2l8XIkv/9hdw7WQ/882yat0=;
        b=NSnR2xKC7KbE5YDQXWrrSlKzJbOTVbNkSxA0qvngddnlJPTgL2FBFTHXsuhWHMQLsB
         58h7Kx6cdpUDauyGK793a4Qo3J+PJ3hZpwLGuNUBw5EAImX+pY5Iaxgn17I6leHsMQAP
         uguu06EGNjw8TGYDoaAdPODlPTaCO8La6mcZPHqKNK6vCzpnOAxIRrsZ2ufyZrgHFAbL
         4UWQkW6HbMx+Oufr1ha29BWZ50yPcu/0SRXhPkQu7qvm4S7pz3CV4hdc392Vtx2Xnfmb
         kG+u1gqEnd0vpnNU7ZmhJ5oy4qaM6ukmd8YQuJ/J9h8exVzHHyLgOdllXgtL56idigI+
         iWrg==
X-Gm-Message-State: AOJu0YzfLfZIZ9JXOWmTLIq5DXa9CdJR3h7TjLxy3GJS+qvgpNYCbRjd
	EeYBDTvcNlGcrevEv7JhD951DFlDmKiN9DeGKF2jvH8uB8m0sEj0AyZAnEYRxU/Rnl3uRYl96yc
	mlD+z
X-Gm-Gg: ASbGncu/uPjyXEJSArKfNeKjR1G5WTEAQ6ZOEVS+mK8PORyLUWNQ2tVM3R/FlZ7qc10
	V/WROMz/td7Ra9G5hMNv99Yhz4ogLQOhbCxzJzSq7rOzM7PqDxclIu/dnhM6dWKCsgbl0aD5kgQ
	1A8h+rme0WyCYxBxWX/f4IAwGP5TuCZkYdhjrXCLu9iyxuKJjoiDmrRIuFXijWaJY3oqYxv7vyN
	OGagH7piKcD5wDx9SmFDdL1Rm/GnlHDCyCV6RMIw0skIQvUXgtCi/Ye4rvrarF7TCpAdRQMZUwP
	OGuxHmE5MqV2L5Rh2I/IHUfgXNq1J0SI/5b9yY+gKP4vKOmZZU+xnJUJSmfmFdYsjlP/oyQfs0l
	7grDPQoB/+a0o7HH+0NQGWscUWfJ+/mrvrcgHB/xXEU0HrYS6vMuDiOhU/usatOFank7pLS3X+j
	+K6FOc0aQpX1gxv0qB
X-Google-Smtp-Source: AGHT+IHvNBWG7ZOKSQ47vCrgMO7GkY8OyuNjJM5T4c64JrkhZw8DmIZE8mFpGukGbwy2ZfM3xXgcJA==
X-Received: by 2002:a05:6638:e8c:b0:579:7cf9:417d with SMTP id 8926c6da1cb9f-5b962c67389mr714315173.6.1763670256175;
        Thu, 20 Nov 2025 12:24:16 -0800 (PST)
Received: from [192.168.1.96] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-9493850caf7sm125067739f.0.2025.11.20.12.24.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 12:24:15 -0800 (PST)
Message-ID: <2b6dacfa-5e44-49da-b81f-51710e2584cf@kernel.dk>
Date: Thu, 20 Nov 2025 13:24:14 -0700
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
Subject: [PATCH] io_uring/cmd_net: fix wrong argument types for
 skb_queue_splice()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

If timestamp retriving needs to be retried and the local list of
SKB's already has entries, then it's spliced back into the socket
queue. However, the arguments for the splice helper are transposed,
causing exactly the wrong direction of splicing into the on-stack
list. Fix that up.

Cc: stable@vger.kernel.org
Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-462435176@google.com>
Fixes: 9e4ed359b8ef ("io_uring/netcmd: add tx timestamping cmd support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 27a09aa4c9d0..3b75931bd569 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -127,7 +127,7 @@ static int io_uring_cmd_timestamp(struct socket *sock,
 
 	if (!unlikely(skb_queue_empty(&list))) {
 		scoped_guard(spinlock_irqsave, &q->lock)
-			skb_queue_splice(q, &list);
+			skb_queue_splice(&list, q);
 	}
 	return -EAGAIN;
 }

-- 
Jens Axboe


