Return-Path: <io-uring+bounces-2662-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C9C94A9E0
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 16:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6D491F2BF0E
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 14:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1862C6AFAE;
	Wed,  7 Aug 2024 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QdwxxcZG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4638138DF9
	for <io-uring@vger.kernel.org>; Wed,  7 Aug 2024 14:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040263; cv=none; b=rg4NnbC+Z3Umlr8It0xwGi29gvt+UbVlt/OmFc8GPohp3/XZ5U2KzgTVqTzhXx3dI4n51ML6msb5DhBNyfVkI7rZ/PeBoNXLEGYkYmytiPx2rNmtOFIhm1yjBDBCrHfcyB6I+G4aoiO8DRosUSQn5MFWz584Hu0k4K5jmi4MhmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040263; c=relaxed/simple;
	bh=L+ASVNcXMmW7DReVg1SCZFquv/0qifldcQic8a/cGo8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KWtURl9fdvLBIIssoZ2KC/QAN7c8WlqBAzWlyOf1oKCzkA3kiGeXRovCPCHcZUn4fHSeE/V9Bmpy/jaP5I9PZDozpCvFPc1P1mAxxcgu54qw0HD1nPKkQC5K4yhF6PMEGH5p4RCYa+7DTZLRPlfuo2ThbjmEosr/VJ36ilotBoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QdwxxcZG; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-530ad969360so2314086e87.0
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 07:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723040259; x=1723645059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xEYbgD5WjP4cAlk0A9xmIt1HnUBiqnTMSfu4o8fqQNQ=;
        b=QdwxxcZGvJlDBj1sIY+JIdkmuYbcfriW2NXfqJQLn0YS2obfwh61DQiOUOfsFmyioR
         oMvlutj233ISHp+o15kiAIVZTr6gWwaMwc2vZCdbt6aPNJ/WSksZqlJ3C7cDOqDekzAm
         yqA/o48r2H264IbberaK4R5i2zoDHv7GZMnxWfvg4Xb3EmGBqrl/sP7MjJj0lqBxD/wa
         gVVF/RXAsmsG/kcLBXJAjIMSL6x/48Ywb1twDTqClqVM16/s5DXieoyLeCpMhwtyjgr7
         fr69SP2TnuNUobLf/2cDMPzaywg9cgK7Pj5ifju6waWQi2MXbjCWsv4adMq6zjbALKxI
         2otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040259; x=1723645059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xEYbgD5WjP4cAlk0A9xmIt1HnUBiqnTMSfu4o8fqQNQ=;
        b=NWIOj8q1lU+jShVEaFX1HhO27J+Soy2Vvn5F7loisD4yd8hn+kP8u0Io4IUpa6m8Wu
         /yAQp+uNOnVroak1mbU0iF9myCVgcO2tvqspSJPkcKDWXnHDeNE+w0ByJ6GLDz/yu74S
         TQHINcsl8JlD3IOIRV362JbKGL/a+sMdwI081KraS6FYL/x58Yvma0VKyE4xMiclwIaP
         B7vW8/zzOL1WdC2sVK9kJYGktzTlxFRYRcSziKkDvvid/InAE5C9QmcKgABvQUv1Igyx
         PmLakOZzWTY3d5SpyXzbLMmgCFBlSNjW6u47XmAwP6KLajnviZxYKWjNCg9KlYaTOGqE
         8ltQ==
X-Gm-Message-State: AOJu0Yxs4MyUMvx5VxBeTT2KTWIrujZHpwEbqu3F+0ArvLU7E0fRBOWj
	JPnbX51WFuMxBOxwqr6I26E6xoI1rhqO0oqSWLEGoN9H9T97bVsffz3o6A==
X-Google-Smtp-Source: AGHT+IFPae/pckyuMm22ZYlOZFOLMD/s/RgmpvPPgFV8H0wPqfqsq6XepMEU6Km2FaXJG8tKNmXoxA==
X-Received: by 2002:a05:6512:1308:b0:52e:9b92:4990 with SMTP id 2adb3069b0e04-530bb3a2891mr13674589e87.32.1723040258662;
        Wed, 07 Aug 2024 07:17:38 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83bf3a37bsm7176928a12.88.2024.08.07.07.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 07:17:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
Date: Wed,  7 Aug 2024 15:18:10 +0100
Message-ID: <cover.1723039801.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
for completions, which makes the kernel to interpret the passed timespec
not as a relative time to wait but rather an absolute timeout.

Patch 4 adds a way to set a clock id to use for CQ waiting.

Tests: https://github.com/isilence/liburing.git abs-timeout

v2: Add clock id registration
    Adjustment using iowq->timeout in Patch 2

Pavel Begunkov (4):
  io_uring/napi: refactor __io_napi_busy_loop()
  io_uring/napi: postpone napi timeout adjustment
  io_uring: add absolute mode wait timeouts
  io_uring: user registered clockid for wait timeouts

 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  8 ++++++++
 io_uring/io_uring.c            | 22 ++++++++++++---------
 io_uring/io_uring.h            |  8 ++++++++
 io_uring/napi.c                | 35 +++++++++++-----------------------
 io_uring/napi.h                | 16 ----------------
 io_uring/register.c            | 31 ++++++++++++++++++++++++++++++
 7 files changed, 74 insertions(+), 49 deletions(-)

-- 
2.45.2


