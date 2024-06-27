Return-Path: <io-uring+bounces-2373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0D1691AE97
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 19:55:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BC1028829E
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 17:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AF6719A2AE;
	Thu, 27 Jun 2024 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="w0FpYOTK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4449513F441
	for <io-uring@vger.kernel.org>; Thu, 27 Jun 2024 17:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719510910; cv=none; b=SDiROdBAuxiRDUbxS1tAASnRrWVoMrQ7owmjxeefldA5ZCl28CyLX1pY4XI2ii2HjJGwSEoawsahhjK2uKfMkFFQ1ltTBXu8n1L93IGfQWHXg9JJScyH96occ+zz4nt8KcWlPKNH/Vm9o8zeFW8X9qAr5yu+hcid3pdFhMVJU0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719510910; c=relaxed/simple;
	bh=WHY0MxsyQV4Xp1eO8obNgqRGbJm/hzkKf/SDR7cbGlA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ft8OcTyqzYd1PzAqPyZ4Y1jc0cvcmjFn+TegtkSmew6QlxNwkVIGXotWK9oP/5P4Vxhvy9B5bF0lxlzY46phNejy0sODjABWTLvEJ3QRMByw29ICnpUxl5/v+4M4Icub20bDG2IZ8xOFuUVPLx0YdbD4xnrp76XeONvxeW4QJZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=w0FpYOTK; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7068fe9f98aso423150b3a.0
        for <io-uring@vger.kernel.org>; Thu, 27 Jun 2024 10:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719510905; x=1720115705; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2idekrcYzbsyQ5XiMhXjEnbkhepnqKjsXX+azUz51E=;
        b=w0FpYOTK7Cru3d6yJRJteot0x8JsBHBJg8L1X1hi3qB7QuRnWPC+pQrN3k+5EqE+BS
         SKSg6CxkA9vzHslVazMLJ6ezuWGcmHPFT2NQerB9PBvUq3CXdXVkOHyELnoiFuRO9ckz
         Q5lQtp5Vkw/RXAcQ6s9JDTB649HgxQ0K3SwQZpStxypCFFQLPwxqqc5W06Cg9UC29bea
         fNWk/LRiQDGVcjyQBe9LiUf2knw7azns2qP7fZGBMWLO35jiQeb12qD+XcZt+//Nase1
         geudX/wDoi7fVqlvVSDs14V0JIslK6mWpZKckzuha0J4hkMCvEwEY/+slnMMeNfjQPJq
         BQ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719510905; x=1720115705;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i2idekrcYzbsyQ5XiMhXjEnbkhepnqKjsXX+azUz51E=;
        b=pQKjURQb4jJqkdrRjzjCkhbsfC20/yIFN6dDRJL36zD840F6Z4xqSV3VTskmTZtE0v
         67IK1UcIn+w+oTzxUpIGmyjnOM3INdvE3lw/QP4Gc7RH99owP7z3Zm852BUEDVl6/0PY
         9M7ZU7ZfEQFXNqmWMfbd5dvoM2whjG0GWe/zWDHKrEGPZ9gqwNCySpHspY4L1J2ImjLh
         T5Uc1CVt8EIScs3cm/APS7qNjIbl+ps+foyGrNonNstYZO6Jd7mtHGB/hLn3MpjOzQAH
         WhhT3Wa3QKbjDru4m5IvIJM1oRAeOW337uH+PJmGrD5p2d+KnLIcRgGiXPkLalf0zXTf
         Az+g==
X-Gm-Message-State: AOJu0YxvZz0eZTmHsY+2xEaJUMS58413p777MML+eJ2rDqKagZ4oqVcc
	A7cTTqymXFjxOucRXaRyv5X15NStDyljrg8WaZcE/Xo5kZm4V7qHC224BLjKAqL+vhjJhb1bB52
	k4Sk=
X-Google-Smtp-Source: AGHT+IHb0cLmea8e/IJ1/SKOAm1586oxWYC826gGoBMmdWvmKbVlWKp5a7zsIrwuv6eGRe+KE+v0ow==
X-Received: by 2002:a05:6a20:9188:b0:1be:4c5a:eef4 with SMTP id adf61e73a8af0-1be4c5af607mr6486843637.3.1719510905442;
        Thu, 27 Jun 2024 10:55:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c91d3bc99fsm61284a91.41.2024.06.27.10.55.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 10:55:04 -0700 (PDT)
Message-ID: <2f83d5f9-29a8-4d61-a14c-3ada09cf2d2a@kernel.dk>
Date: Thu, 27 Jun 2024 11:55:03 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.10-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Removal of a struct member that's unused since the 6.10 merge window,
and a fix for a regression in SQPOLL wakeups, bringing it back to how it
worked before the SQPOLL local task_work.

Please pull!


The following changes since commit a23800f08a60787dfbf2b87b2e6ed411cb629859:

  io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed (2024-06-20 06:51:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240627

for you to fetch changes up to dbcabac138fdfc730ba458ed2199ff1f29a271fc:

  io_uring: signal SQPOLL task_work with TWA_SIGNAL_NO_IPI (2024-06-24 19:46:15 -0600)

----------------------------------------------------------------
io_uring-6.10-20240627

----------------------------------------------------------------
Jens Axboe (2):
      io_uring: remove dead struct io_submit_state member
      io_uring: signal SQPOLL task_work with TWA_SIGNAL_NO_IPI

 include/linux/io_uring_types.h | 1 -
 io_uring/io_uring.c            | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
Jens Axboe


