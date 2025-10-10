Return-Path: <io-uring+bounces-9961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 501FEBCD446
	for <lists+io-uring@lfdr.de>; Fri, 10 Oct 2025 15:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C18E1884371
	for <lists+io-uring@lfdr.de>; Fri, 10 Oct 2025 13:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159B3284893;
	Fri, 10 Oct 2025 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yqlub7aI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD53D2EF664
	for <io-uring@vger.kernel.org>; Fri, 10 Oct 2025 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102842; cv=none; b=IVq7cOW1aeaT6GBr+AeiHJ9avPu/h4UdH2wZf6skA/Wy4WrrvtB7uPl18jbflCtRplX0DVKNileZn/DAHeq3j1jQ1WDQBcS+Mbpi9FuFsSdM3lVHNi2oVSbxMstxwSsVsVkKSAeqZSWB337Jkuze6Ctt0ykWK3P/xe6P8bl9pmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102842; c=relaxed/simple;
	bh=zz3/e0rL4LdTM/akzzt4SMgo3OrobjvU28ZNv/DGLoE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=SITdPUGqKEX8odmLXMeb1GJG/mjCc7roGf/GBYPSZbQaU8wuezzVOCHyb0OjmuEYt3ku+a2pss7t+9reoVzgT91g0Q2Ozp42g++qIt1hAWoXFaDwys6SOv1e9NUuDKml+5+yhrt1dZrSBLXCwiVovu/TSfjwKPHd2Fy9g3vRNPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yqlub7aI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27d2c35c459so14853875ad.0
        for <io-uring@vger.kernel.org>; Fri, 10 Oct 2025 06:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760102838; x=1760707638; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BizSRfBEzi9huhrVBzZSDyK18zlK8l0+tNo5Q+nYJFU=;
        b=Yqlub7aIWIfZWIzRViKhkw8JiMfHO60nGduyrHnrDg3aByk38PZ5ukVQOZX9eFDeA2
         5Km4xKPqQHwQiAPOwLcdey66dds+r2h2iGakZ2FCTVdwlnJIKOnp0m6OG3LG8RQsZ/9Y
         4EjtWf17FyRqRD6uhI3KOksnm9TWzaF3If31klJyjpI0UhCxkEF1ahoW0g/r8pwQCtQn
         MaR2fWMCfAoCuQ1AXYg2HXsQt44+dDnobAJFwoUPN57aJdXEMSKiiL6dFLtkugqJcito
         Q0BmepsiRmJECm7JDYUj4QLvB3ziEkG+nPL2jyGCB0UYXQLhBAynVfIVLaHYfNmXGyEs
         kmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760102838; x=1760707638;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BizSRfBEzi9huhrVBzZSDyK18zlK8l0+tNo5Q+nYJFU=;
        b=YNiEO9fsBIZJsfRuMO6Hd/SYMpWUTZsvsKji+nCxrBsj3oUL3iD47L6qySzqcbIkwY
         II6lOSBEocejj+mX/acVW/zlKJ1S2hJG7LHEWQjA9DPJuyduWwytMQaTfjVSGLi06GFe
         OHoslneDAfdM5HO2F6OHQ0oPcfokrCj+3w67nWAPlVWNMCLu+MqA341p98JqJs3LeL8X
         lLzSZVE+bGV8LW+rKgq5aVzJtg3X3Z1/TmvBjBaM9cKxm65szVBFvEGdbmXDk9CHSqs2
         hTe/kmMLxcsAB71sOIdTZWhC6pGPP69ptFR0I+KJ7gjyJuCrex7elk/KdhIbzzNMWely
         ojcw==
X-Gm-Message-State: AOJu0Yz3h3uf7toPKXlw3CvQvlh0r5FC+MIEtF8p8AZLzQC78zm8yH+9
	gy0ggWkovWm8nhS9g5PSl4HBDP1Ub4nC9YNOm5Rp3ryoh3HIizxh8bfii8+utq7tX3gW6sVdXVO
	ikYOHPP0=
X-Gm-Gg: ASbGncsGpb65fU6NTsrf3C38M22izJJZAUynktBJ5VMdBNxUklwn0HMLRCUGHiArcLw
	L1Jri6RzSyZn4aJIEsEJ61VOc6S01xaJix1HFCGd5cYH+HaeCcuBi7+EUgQGYJRyQIrpw3sEa4X
	ulHDtxDJlbHT9/GR6ZI5j1G55GxiDDXaI+GCsS7ufzxDQ4Cn1HSTavp+ZtWMRRy0rlxCzl1srKU
	Gs47d2DUjs/wq+Y3NYyVd7Lj2EwsOIp8HYQRKeigGDMZ0LtOzfGE4qy5yzbgYyDRJPZ2hd8Th8b
	k2jK6A1agIWISmZnKEfuhs0UCUWc4ykyAAPvv42l029THcUb1hcQdSdWT+Y8n6MpDdzcjwZeA/g
	KoVN72f7bku1JpHX3NquJlFQHtKzj1I/lgsp2qNHC3K6qrxnqcg==
X-Google-Smtp-Source: AGHT+IGJkT3+/zh/juLZkBp8pRIWJXqT2r+yohy95DI9Kz9vvDPeyIHqMGltSF91mMk2upiwbFzpFA==
X-Received: by 2002:a17:903:3d0e:b0:25c:46cd:1dc1 with SMTP id d9443c01a7336-2902734491dmr152263385ad.33.1760102837768;
        Fri, 10 Oct 2025 06:27:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f894c8sm57481765ad.122.2025.10.10.06.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 06:27:17 -0700 (PDT)
Message-ID: <503fa8c8-e123-4a08-9c01-7c60232798f4@kernel.dk>
Date: Fri, 10 Oct 2025 07:27:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.18-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A small collection of little fixes that should go into the 6.18-rc1
kernel release. This pull request contains:

- Fixup indentation in the UAPI header

- Two fixes for zcrx. One fixes receiving too much in some cases, and
  the other deals with not correctly incrementing the source in the
  fallback copy loop.

- Fix for a race in the IORING_OP_WAITID command, where there was a
  small window where the request would be left on the wait_queue_head
  list even though it was being canceled/completed.

- Update liburing git URL in the kernel tree.

Please pull!


The following changes since commit e406d57be7bd2a4e73ea512c1ae36a40a44e499e:

  Merge tag 'mm-nonmm-stable-2025-10-02-15-29' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2025-10-02 18:44:54 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251009

for you to fetch changes up to e9a9dcb4ccb32446165800a9d83058e95c4833d2:

  io_uring/zcrx: increment fallback loop src offset (2025-10-08 07:26:14 -0600)

----------------------------------------------------------------
io_uring-6.18-20251009

----------------------------------------------------------------
Haiyue Wang (1):
      io_uring: use tab indentation for IORING_SEND_VECTORIZED comment

Jens Axboe (2):
      io_uring: update liburing git URL
      io_uring/waitid: always prune wait queue entry in io_waitid_wait()

Pavel Begunkov (2):
      io_uring/zcrx: fix overshooting recv limit
      io_uring/zcrx: increment fallback loop src offset

 include/uapi/linux/io_uring.h | 2 +-
 io_uring/io_uring.c           | 2 +-
 io_uring/waitid.c             | 3 ++-
 io_uring/zcrx.c               | 5 +++++
 4 files changed, 9 insertions(+), 3 deletions(-)

-- 
Jens Axboe


