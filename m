Return-Path: <io-uring+bounces-10728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D80BC7B17F
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 18:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE18E3A2C95
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 17:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851D82EBDEB;
	Fri, 21 Nov 2025 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ET+jIubN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB722749D2
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763746606; cv=none; b=cA5NjRVHTm1zSM/IiosWn6VLDpM/fNqvAsWfwA8l9Ic2xanOtwOYNds0lTdHcRUnU2EWDkZnnaDFJ+6cn2xiARGF97f2hOesqKAYKqZCqH6bN0l2Vanw10jy8ac4RVgFvxMJsCScmCoq9be34A3crO9i0XkYEErEYpHzrq98tgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763746606; c=relaxed/simple;
	bh=vG/qYK0We2iNJ7dC0bIH3FoOBVxHERxNT0fBlQeJx/g=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=p/Y2N5nSBejV7Aq2O/phuxEOaKjMrAbpgJRaB7NvBFRnKxsK3IKkaYBpJkYQ1Rxrhv7uXA+P00FajiN79a/IhyQ7AHsFsOg0diRxgmg8peqCKOY/Q3B/3MI1wJYPPvaaHjoVLQHHBUV3plXdVJ0hrtxGIL7W1LhiD0x2wuMvqtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ET+jIubN; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-43479d86958so11857985ab.0
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 09:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763746602; x=1764351402; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tuo5hxJQ4FIv2wp9SBByqVyaonIDvfrDekdhV0fk2Jc=;
        b=ET+jIubNQR0Kp22M6s3rKProQ5eB8b1+WqwZoJwczXNdhj4XsRUqddGiZIOhgmwXV0
         V9rbpAYeHo6PlejmPhMsTCgSshg1oecl2M32k95tl+hVUe1jeyFdhLTSDE/HlSz++/1G
         jjunLiHce68NxwO426685/O6kbhhpyxFeod//0kwVb+hf0xGcjGyLEQCqGltMgIH37GZ
         1/7JIAlcQL0W0x/lK0h2NYVngCuumIdpNi2bLQgqDkVAaL+ZEUfWvDTG8X2XHXetP+oH
         K5ouCnLoHw4y9FY4LjdX3Z1nwacJSG07l0Gdgz0kT7uIRMGRGUk56g4jGw1Yr5TPlMsQ
         z+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763746602; x=1764351402;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tuo5hxJQ4FIv2wp9SBByqVyaonIDvfrDekdhV0fk2Jc=;
        b=JKu2qL5kOgaqqFVemh+ueQDxcBlcknwtUjF97MRHTfPw2IzLq2cLrdD6RdBU5s5v4P
         GSeWQ0NkhiuPhNuAeJW+MakzeUdcIuKu6KnyQj2eaYVMSU1AjglaTe6NSBB6yb9+ufYt
         Y/256H7udXGoqsPFvclqkMZKoKme9ZIUctMskCiCRSGPiSJM0mtUojLuGVNvfBy+wWy+
         +sOISX02U4W1JQar8MlTKJC2yd92qFsPeqKbUkyip4EVpIeln3bKBnVTVmXMAcXWdoXB
         ckxOT2e/AGJjcsBByEq6JKLhpATuM6TOUWaUye/9WLLc3Pynk8ADUrXL8lFtEPU0og2B
         6RXw==
X-Gm-Message-State: AOJu0Yw62UdWVXD/Vk58suIW3cxKCqCODNsik+9KwhG0X+XRXseTDbNJ
	eqv2xLisFx769QJ1HAYXiHCkvC1Te1nRNjN1yWkPaeL76sUkShfA32Lv8GNwlHMGBVSfAhy7KvN
	7byBg
X-Gm-Gg: ASbGncsuaTNhio0mmy7zraszCxc7Aif3e/ORCpDbC0s58tSaaPsPEV1lB25PmtuwBFm
	ximjfic9WYNnS+jNdi1KntQ1jZrNW04kaS7YB/Uv5i4HeoLUxDX2qiJdoqpT9F02SkjH8v7kKfH
	4OKy0m0rOB3pvC5smwg1hU5FDN6/xc76f48AOTGOtxwZbY1NvRu8uNBrrPLyZtMUxloXXuPrwrV
	LR/4vhFcKESX4ikeUF9hNYwPxFnRgGKHXgIGQGSnB234YerB4tHVVcK74JB4FqdE4XcdMtQW11B
	8D2QoVeu0G5yVJ+JK46t/w/UwgCTG/jZbEX6Vw/JMLbsRZIMRnDpLoiqtfxHSWBlaHnU22oghRJ
	3FfofVZ1kw9EThvm0RtrUcr+Ann68WN0uiuiEtNGgSnmnk4teTKV1eQWclT2r7HpBnYUgW+g6e5
	B386Ir1b02X9ot42go
X-Google-Smtp-Source: AGHT+IFnXEqkamoq38gHgOE0MtOTe46XwSWPeqwGmvWc1N1GDgjV7P5z9rp50xZdeGTaVEiTTPRyNA==
X-Received: by 2002:a05:6e02:1a01:b0:434:70bd:8b52 with SMTP id e9e14a558f8ab-435b8c03974mr29541285ab.7.1763746602449;
        Fri, 21 Nov 2025 09:36:42 -0800 (PST)
Received: from [192.168.1.96] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a905e805sm24370045ab.11.2025.11.21.09.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 09:36:41 -0800 (PST)
Message-ID: <55fa81a1-45d4-47fa-a452-bc9891d5101f@kernel.dk>
Date: Fri, 21 Nov 2025 10:36:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 6.18-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Just a single fix for a mixup of arguments for the skb_queue_splice()
call, in the io_uring timestamp retrieval code. Please pull!


The following changes since commit 2d0e88f3fd1dcb37072d499c36162baf5b009d41:

  io_uring/rsrc: don't use blk_rq_nr_phys_segments() as number of bvecs (2025-11-12 08:25:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251120

for you to fetch changes up to 46447367a52965e9d35f112f5b26fc8ff8ec443d:

  io_uring/cmd_net: fix wrong argument types for skb_queue_splice() (2025-11-20 11:40:15 -0700)

----------------------------------------------------------------
io_uring-6.18-20251120

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/cmd_net: fix wrong argument types for skb_queue_splice()

 io_uring/cmd_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jens Axboe


