Return-Path: <io-uring+bounces-2823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54208955E98
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 20:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE9541F21421
	for <lists+io-uring@lfdr.de>; Sun, 18 Aug 2024 18:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479DB149C51;
	Sun, 18 Aug 2024 18:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+4tLn0A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8EE38DE4
	for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724007329; cv=none; b=fzMjMyuZUFQ5BLetQai93bB78/rBBKK8TKL0Q4TBttpvnI2tarfakaPcaXkjDPMdvbAOrbZgKol3BO0XEa37Hff3ku7XtDr6kSB2LhxNmlThlLiP6wwai4ujz2g8jJVzyv/FTrvzjAuBmylgDPSoC8y2x9ojVGtbeIIy4Tu9+Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724007329; c=relaxed/simple;
	bh=RUD2nFqVVIbdbkzlJ3Vpp4xldA4IafChdHKI/bgFT+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m/e4d28Y5jYsyLmrFmSDTkdOZYF5S8Fl/erhV+qcBFKkdUvazc4BaP+OdxElrzXA0GLvcQL7Wy9EAOElkapnu17uyYeu6hpxH1UotD4EB8yW1N5TxZcCvczZ1YvvTdtyBZyanf+TiIWylLp1D05NhlP6aJjpFqr8Dj4F4VJGKNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+4tLn0A; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5b3fff87e6bso4429197a12.0
        for <io-uring@vger.kernel.org>; Sun, 18 Aug 2024 11:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724007326; x=1724612126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VAdEwA1ryEEve3wS65AHmzjAA5AtDQxraVUf1q5ccO0=;
        b=U+4tLn0ApTZXtC38iaknlDABvGdgJr3AA9dyQiXFzu1/CNhNXUeOjP9JSTZKKuDEoS
         JodQ6ReR2OesvHNSiwZDo41LqfIfSkVA7BJRYxzUGi0hfyqjBNJsdMVCT76N3Ip1KtXX
         ZEs5Cw2MxtygIIsv22GpaNmp/8KUhmZp6gmgxvm6ZOJxagA12qT9c3ap8YZpxB5YcAVb
         stXjNkbALILLgUGNcfuAvYqUN/hjD4E5YnBCIMrhAS20UgKl1/4i1fZQUtEwGamGNGS1
         l7yooBp2tX+Xwc9SJSyevnmMrhnlE7XK3gq5csH08WH+gTlAnHc9Zbwm+s2oDB5EtbOc
         BtHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724007326; x=1724612126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VAdEwA1ryEEve3wS65AHmzjAA5AtDQxraVUf1q5ccO0=;
        b=OpUykNvGR67F4yvdub8uFqrVbTsmvXem1xDsJ0HLim+ynGnl+PekoqifThcrAx0GcW
         vXnlVnmG55XQlXk9p/G1ZASymQvIATLfNby617TWXy+qNRtnvAx0q3QSe+LAaBg1k2Vr
         XQn4gW1sHa87m+7BLJho8VjYVmKSrHkaNLxA3bpWqPGBSGpvK9USc6D2E767MgQAHhyN
         SpEsjVnhGeLupySKAoAkpmBcBRTpnM18tkkNC6uUbHiCWd8OaeXq72PVJ3xqOxYjEJjJ
         Bu6jYZA2+gsC29kAsOqIyhZacsalzkIswvwtgCvzeXCKUv08HTY3xlmgMGL8jn4WnwA/
         tl1A==
X-Gm-Message-State: AOJu0YzaJNyTvpZk1tRKb6IUoXZS8lGQWsvd+C23eHqf2qYV4XJYJ41P
	u6guBS4GKVmSuRvKTL6SsFANNGl3ZfYoViVQAMviK5XpjGJ6GrXIgAUFVg==
X-Google-Smtp-Source: AGHT+IGLRmsKH8rc7wcKMqHIgo0elViqmFDnlm1InvzUBjpWY6c5dHfb+OwsEpz9w/R7JxfD5iQOUA==
X-Received: by 2002:a05:6402:520c:b0:5be:fadc:8707 with SMTP id 4fb4d7f45d1cf-5befadc893emr884048a12.7.1724007325267;
        Sun, 18 Aug 2024 11:55:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.74])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bebbbe274asm4867959a12.8.2024.08.18.11.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2024 11:55:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 0/4] Tests for absolute timeouts and clockids
Date: Sun, 18 Aug 2024 19:55:40 +0100
Message-ID: <cover.1724007045.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add definitions, tests and documentation for IORING_ENTER_ABS_TIMER
and IORING_REGISTER_CLOCK.

It also adds helpers for registering clocks but not for absolute
timeouts. Currently, liburing does't provide a way to pass custom
enter flags.

Pavel Begunkov (4):
  Sync kernel headers
  src/register: add clock id registration helper
  test: test clockids and abs timeouts
  man: document clock id and IORING_ENTER_ABS_TIMER

 man/io_uring_enter.2            |  12 ++
 man/io_uring_register.2         |  20 +++
 src/include/liburing.h          |   3 +
 src/include/liburing/io_uring.h |  67 +++++---
 src/liburing-ffi.map            |   2 +
 src/liburing.map                |   2 +
 src/register.c                  |   6 +
 test/Makefile                   |   1 +
 test/wait-timeout.c             | 283 ++++++++++++++++++++++++++++++++
 9 files changed, 369 insertions(+), 27 deletions(-)
 create mode 100644 test/wait-timeout.c

-- 
2.45.2


