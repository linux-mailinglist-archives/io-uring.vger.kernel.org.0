Return-Path: <io-uring+bounces-8090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32DB7AC151D
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 21:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBE34166DEC
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 19:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D7CD1A9B4C;
	Thu, 22 May 2025 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gjb0sEgA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FE41A00FA
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747943800; cv=none; b=onvfoEVFVpGwJ3qLlqFBnLdPJ9L7Nq/Wl21J9ez5miLOjBM/66meB9aWKG9iKuL+z9WgLNY8lEXCImi3ZFJ5RcZ1hqyOGLpWsIMY2ZwTPnHdNugFdbwsVA0u301KiDBestMKcKO79D4gM1aHVLFaGJ/6porinD65zmfOB5Oc1YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747943800; c=relaxed/simple;
	bh=OL82yRYqPyT+mhT+h58eARASoBTZ96xg377qwgOz4zk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ct2QW4l1EgEXUzCH07L4kJufHZipxkh4jZ0XGKx8UyF1225iXgSUijjE7Ql2SRRVOokQcGQWbn0JJcOkyWcdngWBqc0+UgCBSi86F3S6PeCSR9aQSkpD59wW9YfGFt8kHudkF5MM9BX23mVC3qBRss9khNuvDqm1Clj29f8UPJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gjb0sEgA; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86135ad7b4cso435170839f.1
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 12:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747943796; x=1748548596; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCywTkrS6i06Ivn2S90n+/6Ji2USHlMVWfO/cNFB5HQ=;
        b=gjb0sEgAwnRjEYAO4vKBzCe3M1mxnGIVkKTeeXRYFluhU7b3xQoiHD77csmd51Tsmq
         7OJh5OYM16J2VcihTzq+Bj5s4371S7324ApERcLfAOMtqByaqx4oU94vRnH8cRMN5VKz
         S8iFo2Ct1z03ZS8wouVHNhOI1QRDKeH8oYGxMem7ZRPBPB3s3gpYXStc2hQrUFwBpRdj
         swc9bProqi9Z2Ll1qCer/6i3DRIggjKObSBCaH6InegFAHVZ1+DijSpBGBaZ1+thsXzt
         2G9dx9SU7DbzcXvLWyspQMSAaRgCYoYkTiXWvQDNx0Ce1tS1w8fKd+/M8agQ07gpjwC/
         C7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747943796; x=1748548596;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tCywTkrS6i06Ivn2S90n+/6Ji2USHlMVWfO/cNFB5HQ=;
        b=VujpZgbe9hm407b5sLZ6fzm5cKgUvIwiVyoPjzKuOUeOr59o+ofB38CTGI3dH/BR3l
         SllR6ZW9/rXP5frb4f9ugkPIHlLfqsMYy1+v5ejaQ5a3R9IhzZwL8SvcP0XVmw4wi8Ii
         WjvMKcqGVxoVAhbGq5EuMx8XMcZJHcRmM2a2yxXLX1CgTIjvqeeVImg10BwbDbOkGqL4
         7NxP1yTUhT4dkmX8oscsIqifnH2Fbom3SX38mbUKVHE9wOzJsSijnFSg77vtU5nMJ4n0
         NuIsUnRoGKhYdD1Uqdj8Q6IZwS0MNxKgC765CbQBgPTfuGALLzHNDNYavZp1rw84EndR
         EHyg==
X-Gm-Message-State: AOJu0YyX125kZEyWkCRERIu7U30OLI0OfU4bPFxoQ+9GJKHde4C65T1l
	eFCxcRQHzdbJblvyz1TfwJ9g19fF3b4M1iJMiraJlo9Kx0T7CYq67StCGJrta6EqygwYtSn+SKV
	OmNvQ
X-Gm-Gg: ASbGncuCDxlOzzj0Ajs+oabkN6llQ4t2zbycjZMvBpo2AgEk4cVE84/7V+834vEjxA8
	NndGUj/EyTlaeRKM9EYVCjSuZT1ZnQzjXEK75br8gZ7FFuno4gbbhW3aC8+MnsRydcdzhGjfvZ9
	WIL4a7Kp4NwGhQ8VWIjTo9WEdwPt+7BK4isMMuy+WoXoXusj+XWJ4d4Wr2ejPWCBVaUKyS8I/bR
	gUI4Zx9y2Cie8Z32OYpS2amHXgcS0K7eRhP4Xn3gP3Yx/XXCBe5UXPj81RDawXUxa/kBYVU7H0x
	rMrVNauk8MQowI0FhOYPzBD/3evHXpIGXPN/djitm1UJbPc=
X-Google-Smtp-Source: AGHT+IEQw99bqgkZJkaQx//4AaVoRz/D3moAnAQzCvt2+Z8NS7fiFGLHa7oMezJOkbJRrc8xuO6HcQ==
X-Received: by 2002:a05:6602:751c:b0:85b:3f8e:f186 with SMTP id ca18e2360f4ac-86a231afb14mr3805579439f.6.1747943796413;
        Thu, 22 May 2025 12:56:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1abbsm3378621173.44.2025.05.22.12.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 12:56:35 -0700 (PDT)
Message-ID: <a23908b7-210d-4037-8f86-48ceaae03453@kernel.dk>
Date: Thu, 22 May 2025 13:56:34 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.15-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes for io_uring that should go into the final 6.15 kernel
release:

- Kill a duplicate function definition, which can cause linking issues
  in certain .config configurations. Introduced in this cycle.

- Fix for a potential overflow CQE reordering issue if a re-schedule is
  done during posting. Heading to stable.

- Fix for an issue with recv bundles, where certain conditions can lead
  to gaps in the buffers, where a contiguous buffer range was expected.
  Heading to stable.

Please pull!


The following changes since commit d871198ee431d90f5308d53998c1ba1d5db5619a:

  io_uring/fdinfo: grab ctx->uring_lock around io_uring_show_fdinfo() (2025-05-14 07:15:28 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.15-20250522

for you to fetch changes up to 3a08988123c868dbfdd054541b1090fb891fa49e:

  io_uring/net: only retry recv bundle for a full transfer (2025-05-21 19:24:18 -0600)

----------------------------------------------------------------
io_uring-6.15-20250522

----------------------------------------------------------------
Caleb Sander Mateos (1):
      io_uring/cmd: axe duplicate io_uring_cmd_import_fixed_vec() declaration

Jens Axboe (1):
      io_uring/net: only retry recv bundle for a full transfer

Pavel Begunkov (1):
      io_uring: fix overflow resched cqe reordering

 io_uring/io_uring.c  |  1 +
 io_uring/net.c       | 14 ++++++++++----
 io_uring/uring_cmd.h |  6 ------
 3 files changed, 11 insertions(+), 10 deletions(-)

-- 
Jens Axboe


