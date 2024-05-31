Return-Path: <io-uring+bounces-2033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E50868D6487
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 16:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D902CB21FA2
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 14:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5ACC1CAB7;
	Fri, 31 May 2024 14:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ETRuQvzY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971731B812
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717165796; cv=none; b=sTgeRmUMR/19nKFtLIPrHewuGC3Ii9x01Ic/kHe29rMFI+HpVvVgOSJFO7gVhcKT4RiEE6j9TQV49u9R5jqlVAL8W8EaN316genwdoTk0Zx/4bLmsjo2rfAbQRrLmXj4wDq/uwrpiTW5fsqKyANAyBfiSGADUlhjsdEeI+hiyAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717165796; c=relaxed/simple;
	bh=/XB2ANRpWpPqzviDRm7sfkmQ3coSVfSB0BPLj0vVgSk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=fXgCloC+ee2KJnICDP02m/7pVz/gbg3XbgfBax+BeqJAcxDBZlZVsu4laF/OFwa9Jn9YSvzKofabqg1ziJJW41mCr0nMcclMYtit+hvIhD/kUiEkZUeNDuBFNZbEC8ytJgrtrj6FVSHk7sBGMxpmI/9sTqvaiHfgT5j6LuiiIR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ETRuQvzY; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6f8d3e7729aso34973a34.3
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 07:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717165792; x=1717770592; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZ4C3W0XI2JnSUack5Vkx9/BXhja4JTMM+Ai27g8Jx4=;
        b=ETRuQvzYuiMcpM1LlelxqmDIEkXxd4znc63GS7b3GyrTfznFl58yAAUJ5x5nSqxy51
         YbJstwLQMHnaUmwNlftxXtPEqf9rqKlM3SSjIqU3Hlo5NhQMRfZWw1EF7TtMp0Skw6Dg
         sfqcFl+OSaC3ltGhQkZOUKQbli391RVDUKMDxjk0alHnDxgy/nObYv56B6sP+9hSCEA6
         GzmMdIMZbHY1vVB7M/h+0mGnn3JL1gl1rylsoPumc9LCCmx9JzBFk2iyBZ8ip/Z3bIrU
         foNvClmTtMdAJ9mvzY9takECFlGm8zrjB6gYc31+V7Kdwxg1lSo7NWhF3ZlT3IRqOzvF
         IXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717165792; x=1717770592;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fZ4C3W0XI2JnSUack5Vkx9/BXhja4JTMM+Ai27g8Jx4=;
        b=nDMYE8S35sUP3s2RtKMNViweHQC5uqTpCVNPEucYu2bWia/MwqxAzRyDTDVta8JiTH
         tgYqaGyc5beARyVD/g6+2D1O3jyQbjbeVmZPOZM7cGdSyie5rawqXQxF8Uxe6Z4NR9Ee
         DFZB1U9ZEPySPT17RyOIeFBe7gTv/QaeFvvaejXRb2vo3CNIMqoAj00igB5pap8eolw7
         6KdGF/JweNfAEKDAxfm36fZOmyzwW6/3D/aUX36/+LAvtcD1Ih09sANZ9/q3sHjF6tqM
         XC1vdqlZhcn9ncGb8vZt18luV8Q0G1CWEyT1hVMO4GyfXcGV3BvsfRlNt5dqAuHnRG8B
         PUNA==
X-Gm-Message-State: AOJu0YwogIFEdjEjZJ+LOv6CP7bc2ifyAlInDoiMn7dnUb69FxXy2SuJ
	XpRUJhZf7zocqhPek9LjeLF1e6yX+ljjQ7PFG6bn5tuZJeeJFtJZqNckPb9the1xSTrwso30S60
	q
X-Google-Smtp-Source: AGHT+IHb4JQx3gS51kXuxoLaxZTue53W27P2n2ifYUWtIA5HWTBEKPOVyTehk5V2ygN4EcuRNC5tng==
X-Received: by 2002:a9d:7e97:0:b0:6f1:20c0:9389 with SMTP id 46e09a7af769-6f911fc46b4mr2222804a34.3.1717165792198;
        Fri, 31 May 2024 07:29:52 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f91054f6c5sm347197a34.38.2024.05.31.07.29.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 07:29:51 -0700 (PDT)
Message-ID: <d59d3b10-823d-460b-bad5-fae40b43e14f@kernel.dk>
Date: Fri, 31 May 2024 08:29:50 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.10-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A couple of minor fixes for issues introduced in the 6.10 merge window:

- Ensure that all read/write ops have an appropriate cleanup handler set
  (Breno)

- Regression for applications still doing multiple mmaps even if
  FEAT_SINGLE_MMAP is set (me)

- Move kmsg inquiry setting above any potential failure point, avoiding
  a spurious NONEMPTY flag setting on early error (me)

Please pull!


The following changes since commit 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0:

  Linux 6.10-rc1 (2024-05-26 15:20:12 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.10-20240530

for you to fetch changes up to 18414a4a2eabb0281d12d374c92874327e0e3fe3:

  io_uring/net: assign kmsg inq/flags before buffer selection (2024-05-30 14:04:37 -0600)

----------------------------------------------------------------
io_uring-6.10-20240530

----------------------------------------------------------------
Breno Leitao (1):
      io_uring/rw: Free iovec before cleaning async data

Jens Axboe (2):
      io_uring: don't attempt to mmap larger than what the user asks for
      io_uring/net: assign kmsg inq/flags before buffer selection

 io_uring/memmap.c | 5 +++--
 io_uring/net.c    | 6 +++---
 io_uring/opdef.c  | 5 +++++
 3 files changed, 11 insertions(+), 5 deletions(-)

-- 
Jens Axboe


