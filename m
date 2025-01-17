Return-Path: <io-uring+bounces-5947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B79A146EC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 01:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BACD169334
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAC717E;
	Fri, 17 Jan 2025 00:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FPtzjQnm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BE5647
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 00:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737072412; cv=none; b=WZx3h6/zA8va+38CzTIcNy/UfNT6vVgBQHC/xaKH+KGLObtB66i+iyl/C340TjI/LKQPHmLGpxn3/yjez5g3psaPWH6Rv3koFh0zEYacTstWivEs6wMA80GvBw5uYZNbBGTgSvvmBCKyjitzEeXvId+wZQ1lTqJLJCDaNGWtPDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737072412; c=relaxed/simple;
	bh=bA1jhnb/KQscNhg0S0E6HUdaCOp4Ip4M/yoAeS7OJfc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=qhcDFrN2pZq62a7yFyz77kpzphAAV1S8altcjnQMczE7MamiazWmXX1Np1X1OPNPsZ+tJoPAZCEeE0ar3y+TAUdM0KHvW1GvXTwVyhUKPOSGZ7F3YOM1ruCmJEelKTngZKQpFTI6OcFevjYZKL7ILgD1SSDnS3ElWvbvYJ2RYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FPtzjQnm; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3ce34c6872aso13498085ab.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 16:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737072409; x=1737677209; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LJqyha/CZK1JadKu8JvqqCr2Ew9i16jXaYtdPVlscY=;
        b=FPtzjQnmnB+/rq8fq0uCF8zTNdvbcB5s/6BPb05HOK2vPTtyWrjcs9yeywO67zHmgv
         /gnwy4y8BKqUGp9Pu2KwEmgMdLXVpzs5XEk6nIEhCtpL/IdYwu3Ss6dbtvnL2wX0CarG
         iJMZrvJRnO5bwF5SSqXXXuvsXyqvR5jYX8mpdb85EaTzh6bwHOVixq4P6VzLB3Gxf8y+
         HFlyFZ65WdBr8EAT+zba92dpT4fwYQIdXS9WULlXlasvknSYNVXU0Af8kDfvWpbQKR6f
         gn1DsA3UMobj0iX+WMS3UoBSIkoty2Td9/0Jr5kupaWSQTBKIxc9Jn4l0U4eGl093nmq
         DdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737072409; x=1737677209;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9LJqyha/CZK1JadKu8JvqqCr2Ew9i16jXaYtdPVlscY=;
        b=utTdt61FMZ0Kd+icFQOA+BgIotph4G/D5kIySK6kNSeQPaFWT0Ixg6ODQdObPUbvp8
         K0AMb7Oz+6SIi59hp5fXY333RC/M2f86xhev1g1EvvRJHEGPY1W/cTQrUGVq7IMaYC1M
         b69kKNPcp706Xgz10MMLQY07iqUKaS/YNObxDwiAi9CqQhubengCDh+xXfsYcOyFNfFz
         UfzumRFUW3NWEZgrEQTIHfNYUCbvyP3+A/qUlW+om3zbIq88A3jMdTfC4HZzL0PFhalM
         r4nMLLTvTvO2WnUCpHhgm3Dfl4D2meHX5oxjn1sHqUa3Y1rqip8OXV3IscM6hvW8ljNG
         OH9w==
X-Gm-Message-State: AOJu0Ywy40VMWUxhYRdhrh/tl+a8U2j7+wXL6W65BS1cb0Q3x/K8GMOf
	kJGFtcP9QYXUj5gjm7cCkcZVTWHkdcz07w7qJdRsXrRy0ow2+m0ArWK829IkTSg=
X-Gm-Gg: ASbGncsH1Hcn2mnECjf7jJjDeH0nGJ6o5Xmje7bXiIatnc4zuiGlntJBRUtXr3GDoS9
	y9SPkpHdLM/5HnRhuKS0OY99nAJ7I+MO47EK3EAdTj82ocTp59QfdGoIoRy4sSJHri/lolnZb+W
	sSUp2bP01w8niSh/XCzCEKSX3HLKVmnccQHJ7o5ojzvMKnfKFMo9i7CUUQV4DpyngNZBBKe13d+
	H6/oIwh7OAXzQFqcVbtV7bMrv1h0009ybRGJ+ZZ+zgpvSNWJM6bZQ==
X-Google-Smtp-Source: AGHT+IFHYrNB0xuYUsg845k5sfXswZCncPTNMLfzhPSsAJt+k85sTsVh+9SqWe2Fps3cbSWynVj0pQ==
X-Received: by 2002:a05:6e02:3a11:b0:3ce:6b10:17fc with SMTP id e9e14a558f8ab-3cf743ca060mr5947425ab.4.1737072409043;
        Thu, 16 Jan 2025 16:06:49 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3cf71b682cbsm2723695ab.67.2025.01.16.16.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 16:06:48 -0800 (PST)
Message-ID: <4194f9f4-07fc-431b-9af1-5888c07193ba@kernel.dk>
Date: Thu, 16 Jan 2025 17:06:47 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.13-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

One fix for the error handling in buffer cloning, and one fix for the
ring resizing. Two minor followups for the latter as well. Both of these
issues only affect 6.13, so not marked for stable.

Please pull!


The following changes since commit bd2703b42decebdcddf76e277ba76b4c4a142d73:

  io_uring: don't touch sqd->thread off tw add (2025-01-10 14:00:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20250116

for you to fetch changes up to 6f7a644eb7db10f9993039bab7740f7982d4edf4:

  io_uring/register: cache old SQ/CQ head reading for copies (2025-01-15 08:39:15 -0700)

----------------------------------------------------------------
io_uring-6.13-20250116

----------------------------------------------------------------
Jens Axboe (4):
      io_uring/rsrc: fixup io_clone_buffers() error handling
      io_uring/register: use stable SQ/CQ ring data during resize
      io_uring/register: document io_register_resize_rings() shared mem usage
      io_uring/register: cache old SQ/CQ head reading for copies

 io_uring/register.c | 52 +++++++++++++++++++++++++++++++---------------------
 io_uring/rsrc.c     | 10 +---------
 2 files changed, 32 insertions(+), 30 deletions(-)

-- 
Jens Axboe


