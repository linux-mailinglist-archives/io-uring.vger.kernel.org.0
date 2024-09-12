Return-Path: <io-uring+bounces-3177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE21976EE5
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD8171C212F3
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1841B985E;
	Thu, 12 Sep 2024 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N8GVX2ne"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0BF1B373C
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159225; cv=none; b=Zr82io8YQF0xLzIWRxb4gX5bVo99W7lAlb4EUTxcNy6HIDf1ob+ypFvjrShwIYwua9hvK3G9OmrwL/ak0AHPEJIWan9UJvzn9uMfCvJcoh6UHZr6mZ/dS4s6vOzC8GIVu5OCDF1ad/UDnxxdlCOi0IOx6wKP8Z5Cl96dUPXM2M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159225; c=relaxed/simple;
	bh=HVJqKUuRa/RAfa0j5OQCERctZfjV2ylV93Ny68zknpQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HvC/Xj60tFa28QErbNBk0uA4liAHK6peTaDhxS8wBZdllSu/+wGs/NgnrdLjPH1UgogPxPtK/X9xmsHxbvvMRi3KtC5ESW5BlSIMbt122qg2wRhQzZQKkSJ0GPwM/vHcK8un+ouKjCGH6xNEIwwzL7a4FXtaSgh5+cxYYlddpQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N8GVX2ne; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-39f526fd19bso225805ab.1
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726159222; x=1726764022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=exLw1yxE+lsrNz+hwdHtp188n6sgWfGl6C2zSWk0328=;
        b=N8GVX2nefF/cYyF283OfaBfH8tQUMet4BQTfdV88Mt0muWFLjtwy2uFBlqfzwelkCR
         IhTIdyJJInBxtFn9FQpGPAE6aVQjmJk1vd1zyw4xYngN/UkuEJ/KjbphyoWsH3egZDAZ
         0uvUkSOIP3EakolA5w5rBz0OBVhsKjTtcn9v//hVNC1JiyR1vzmqd3rSCrKA9SWEwFn7
         OXvlQiT48msq4mTf+L91Hfxyfgd2Vu1GIQML/6GPWnEt2NczCgV0BVCmFRE4BciZXv1T
         IhPA6j57APaI2B+K3uIcU/ua/e8t45wwcRurkYW4ake4n4TXYntDMKJsRZQIGnnmkL5+
         nz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159222; x=1726764022;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exLw1yxE+lsrNz+hwdHtp188n6sgWfGl6C2zSWk0328=;
        b=IdUCritTol5IIhqdJPoyYM95kPH/RpV7aUXuJkaVk2v1W6yT0XduAiZ9Bbu/ks69ww
         UHKOxGqrRljKNnpXFzGFCrQ5b1gOJnTi6UF3rfVUmjFoOB/imFA/FcOzZupM5T6PVVG8
         6USLPi59W1qlReDjLf8HAQYA3hpEc4cH+q0GRg0VLj35IhND914mkhTrihK1liSdmZm+
         CQ99UltqJDX+veEK3ofu69MWgZ1RGZZXIoJafaHIhYjIOGrgprnmFGFWxDbUMQ0mlM5c
         3SDM+TFMeulEmUw3F2/fDXZu2JdFAoC+6Ne7SFlicmVC+qcHTF0udm8fcXltl2r1wIPW
         E+tA==
X-Gm-Message-State: AOJu0Yw8Gkcwa43W0FJxj6N7wF8j+tuAKxFcUF2KkQ9ioh5iJuyzFh3G
	OVBvpS/orAlYbwXbyVgNaG9FkHrfVXPUoWE+j7ksWXh90y4NV2BHuc2P/lIS9aegMWvU9pCzqFi
	b
X-Google-Smtp-Source: AGHT+IHq33x7KG84pqDBSzOAmX3eOtBSw911ZBsMZLvn3fTjG1k4fXTerchhZW3vHH5sVdUPpgcFLQ==
X-Received: by 2002:a05:6e02:1d12:b0:3a0:463d:ce1e with SMTP id e9e14a558f8ab-3a0848f8009mr24358645ab.12.1726159222326;
        Thu, 12 Sep 2024 09:40:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a05901625esm32564985ab.85.2024.09.12.09.40.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:40:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v3 0/4] Provide more efficient buffer registration
Date: Thu, 12 Sep 2024 10:38:19 -0600
Message-ID: <20240912164019.634560-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Pretty much what the subject line says, it's about 25k to 40k times
faster to provide a way to duplicate an existing rings buffer
registration than it is manually map/pin/register the buffers again
with a new ring.

Patch 1 is just a prep patch, patch 2 adds refs to struct
io_mapped_ubuf, patch 3 abstracts out a helper, and patch 4 finally adds
the register opcode to allow a ring to duplicate the registered mappings
from one ring to another.

This came about from discussing overhead from the varnish cache
project for cases with more dynamic ring/thread creation.

Also see the buf-copy liburing branch for support and test code:

https://git.kernel.dk/cgit/liburing/log/?h=buf-copy

 include/uapi/linux/io_uring.h | 13 +++++
 io_uring/register.c           | 60 ++++++++++++++--------
 io_uring/register.h           |  1 +
 io_uring/rsrc.c               | 96 ++++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h               |  2 +
 5 files changed, 150 insertions(+), 22 deletions(-)

Since v2:
- Ensure that it works for registered rings (both src/dst)
- Little cleanups

-- 
Jens Axboe


