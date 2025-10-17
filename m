Return-Path: <io-uring+bounces-10046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CCD31BE80EC
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 12:26:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CB9DD4E9915
	for <lists+io-uring@lfdr.de>; Fri, 17 Oct 2025 10:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712C530FC3B;
	Fri, 17 Oct 2025 10:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZDRFfg19"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023B331197A
	for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 10:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760696782; cv=none; b=nPzHh+1wL3hckg2Svh+1ADEn1m05NjuIVSjQhLly2WZUu8940Mx5oP07kHbJb5nPDt6Ia/jwclspXiJ5uRZv5eF3ILwCHSoo3kLyUkEkNX8AO9JHEW60R/L+e7z8PilD+v0g1FezvtdCrOQOkfN5LgHsa/hXDBDczPszb2gBJWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760696782; c=relaxed/simple;
	bh=Kkpr9OCNUFWM1u4Cu8G6LpuxOUvaYfp9gzIkneFAki8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=gBvmH0burjwOyDpTjIcON+2IgPDXZspD0mmr0eDK8yqzTuagoaijaJimEy7ECR6mKfmYeqc7Ja3+Ja9FaYv2Rh82A0gNiFNDQOTrcMTfKvUMRpqTvwbM8MSqU9JeF47QRmUXbrofrHthL8dKlm3MEkDz2omkzks7w446BidmcRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZDRFfg19; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-88f8e855b4eso148298985a.3
        for <io-uring@vger.kernel.org>; Fri, 17 Oct 2025 03:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760696777; x=1761301577; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKVS2Y3wgsk2m1lFJ+IjzuWRU1vCeS8lyZ7zQ4jUAqY=;
        b=ZDRFfg19sBkFJd+CKKCAzeSlhHJFhWv3pmqwu7LM9UTA+UuwYNJruEAg5JIjjZEWsa
         YZ20vggzOicZt7VyKjo/LBbZEIOswHGq7U6XFoWHp/1FWx0TmflzTh883E9CLCXWqT3W
         bfN2B9zUrh5vXW2/yO3D2KiTGi0ekMvdYXNNds6/t/krbKGjM1r9zVDpttSkVJcofgOm
         HD98bojiQ+tm89hwjRt5d5kuEFYEj/G0ebC/KsMe8yC0hAljO2Liw+2mVMZ27hJ1zEoI
         /VH+bTSKzOo6VLyAtxVyV7mZVrqvrpoVw03mm/qXYkwf44L8mv4/S8g833NgpsjM28D3
         9FAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760696777; x=1761301577;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SKVS2Y3wgsk2m1lFJ+IjzuWRU1vCeS8lyZ7zQ4jUAqY=;
        b=wRP3pFXtL1l5eWS2nENCuc7jy5tzodw8aKh9nYjaWAdLxPukx+sUufhzKEyVM4ZhDI
         og6x5BhiVSwkHW11PmG8OJmoT0PZTywMXBRkH0xBcebDsKLMkoOc4IIKFmj6PGogVwN+
         jLSaCTcJ2DgAVkx+Zq9o8dQEPNJbtz7+Nt4cRpacTQe0puILIbmGfkn5pV9HgDxjI4cM
         Jvgbr7qNqfULXKRw5Cx52hlJpMm1svq4njWnajFV9jhAjSsSRkM0eJZ+55z8V8Gn1xRs
         C0ZUN6mr96B1OG62M3bw/difxozmBE7MHSRxFCAnFIzx4H5B/I6Zsqn2N2wRtDz4Gner
         40Yw==
X-Gm-Message-State: AOJu0Yyp0PGbD5wM8MCX3q0FtIKDxQ+I6IKZL2y0M0iZFAP4pfuxRM0X
	V7RK7dBeXNIrYIG6yNgKlWvO+klhX8u7GKzIiK7PJ+CYr0+jsHH2NWDN1AYFY1aY4krIUt48rAH
	B3/HadT4=
X-Gm-Gg: ASbGncsBxGxv3ResTqQLZdcJMNm7pXrh9hTfq7qGO2caZ08XHdV7pzPqRMeuj3MXqkQ
	/fuqY1NHEg3R1sMrYSQWmcCoVBjdD4W5pkl2a6BGX/luFSPa/eSkjgQ7BfrYQooP0c+RiyWQl+V
	qUNT45/zgVJAclQ8TQTEMTDWpagLAWXqCNGOgRiFeExgP0rPHa97Dwx6DnYOBELxAd5O1/QuPGx
	VFdueci1J9q0Fvijgs78Oq2lQePFQdTV5yfpk0yA6na6yRgiAj1DISsAjWbgNKMHOEH7Xya7gob
	z7houG9X1TsxtGsx+pkykSJITVxY93ZC5BXiAIs8xJLSB0b0SLG3Rt3CkPMePy0bi4M8u9yaCvs
	cM68QGbAvoRyNzrpaZPwmhAmC1o5zXRarTJDns7I3ZsOQO4oLSlSg07DkajoET8aCGeMP4MDIze
	zCl7wYp4peMrcoUbNRtgBGaFDuDxS+sOtPWAHIk7bboKEUn2+90A==
X-Google-Smtp-Source: AGHT+IEd/rI+fXXXZBSMF2NpwJojV7uXQ3yDWS0OWVUHOlEUCDOcm7XXmreAiwtoqcdwcJxZxuUOpg==
X-Received: by 2002:a05:620a:838b:b0:890:c8a0:7c8b with SMTP id af79cd13be357-890c8a07e04mr191391585a.26.1760696777398;
        Fri, 17 Oct 2025 03:26:17 -0700 (PDT)
Received: from [192.168.158.66] (syn-024-169-078-030.biz.spectrum.com. [24.169.78.30])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-88f3803b394sm410524985a.40.2025.10.17.03.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 03:26:15 -0700 (PDT)
Message-ID: <24ba2aad-762e-4fa1-bbf8-2956999a65c5@kernel.dk>
Date: Fri, 17 Oct 2025 04:26:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.18-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A small set of fixes for io_uring that should go into this release. This
pull request contains:

- Revert of a change that went into an older kernel, and which has been
  reported to cause a regression for some write workloads on LVM while a
  snapshop is being created.

- Fix a regression from this merge window, where some compilers (and/or
  certain .config options) would cause an earlier evaluations of a
  dereference which would then cause a NULL pointer dereference. I was
  only able to reproduce this with OPTIMIZE_FOR_SIZE=y, but David
  Howells hit it with just KASAN enabled. Depending on how things
  inlined, this makes sense.

- Fix for a missing lock around a mem region unregistration.

- Fix for ring resizing with the same placement after resize.

Please pull!


The following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.18-20251016

for you to fetch changes up to 18d6b1743eafeb3fb1e0ea5a2b7fd0a773d525a8:

  io_uring/rw: check for NULL io_br_sel when putting a buffer (2025-10-15 13:38:53 -0600)

----------------------------------------------------------------
io_uring-6.18-20251016

----------------------------------------------------------------
Jens Axboe (2):
      Revert "io_uring/rw: drop -EOPNOTSUPP check in __io_complete_rw_common()"
      io_uring/rw: check for NULL io_br_sel when putting a buffer

Pavel Begunkov (2):
      io_uring: protect mem region deregistration
      io_uring: fix unexpected placement on same size resizing

 io_uring/register.c | 8 +-------
 io_uring/rw.c       | 8 ++++++--
 2 files changed, 7 insertions(+), 9 deletions(-)

-- 
Jens Axboe


