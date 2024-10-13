Return-Path: <io-uring+bounces-3636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F69A99BBC8
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 22:45:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12131C20A26
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DED5147C9B;
	Sun, 13 Oct 2024 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KSENfL1H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318213D52C
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728852323; cv=none; b=QG2hwbJuBSNAfS4JyJnxriFIHsugPyxd2IMBYjBDbo/k+KBB3aRVuBsd+pgzHT95eG57xpWeaycNLfuuv0HVAeXkjKlmjR/aqTjlPhBiq6x5nWUEd6FwmvMlkCTUOut4kyBr767/BWH4e9HMCnu3ZcvwDuJoe0HMNGSTsWEizFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728852323; c=relaxed/simple;
	bh=K25lfMr4cBhEWa9Ofs5nYetGow72BpGUmEnP7UFKSlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G7rqVh1OwT0wh1aKSC4jZKJcP3IHijNHBNVlqDQVMFoBvl6+NZfozcHBqidZeN4jxsobFHXFAq3XyskKCJz0SYkAgl7NP6lv8AVluRhuMbirDei+PaDcpv6RX1FgRLZwSnr933wDKghL5F4rYKX230sJng7M6r7Y/Mvj/y4ewjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KSENfL1H; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a994ecf79e7so584566166b.0
        for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 13:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728852319; x=1729457119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lf+uJ26BIQB8MNX/Ax7IvvR4MJQsYw+b3w6A7QjOYRI=;
        b=KSENfL1HJfyYRBsL8Q0bmIpHcsEC9/EVaPf5I2+0TPCUzkOamOo9h8ymmAguWD80+a
         Idrqt0bbgOKy2kGMV2mrd08to5yWXZEAB1bZ5oKPEqGPVmlZZhmLtH50UFHxGGNWnOgq
         +002jVx+q3D4I0O2dm9Zt4BCUCH62vBMmb9P5rhiMfonysr5m91aC5a0CA2S5EKuMUFQ
         6hbrIEJ8/gElHBW1gqrBjdm8l36TZxtL74fgBjdPGoXu7dg7t3lm09FyKNqy7paqe87r
         +zIo6XImAZ93CrZ9qW9z6yD9ZrriWYcsYV4DyY5eUc3SmVG+kVIymBkjHSSVsFA2yuOR
         RJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728852319; x=1729457119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lf+uJ26BIQB8MNX/Ax7IvvR4MJQsYw+b3w6A7QjOYRI=;
        b=aNDkgmnm3AVhqjppV6prbQz83Lp5aBfJadaydQHPVT8Qx7dWbTJt6j4k7MMCEdeN1p
         3vXfg4PiiMIVUL27hRLfj/eTmGGgqh0uKakp4B6nexuLS80Kb8bE1XDkYctYjRJ26mUy
         x5o4Ld5ZxzzP9hGxb91XmijegVkoUCLF00ssJN4mZT8h7qef0/pGGI7NCu7nSMT9fv4d
         UJMYdhIejaR0kNrDkpaDitYQI48Eq1O4+JctGV1m0fSpZwHUlVLfOhZ9+cpJH3b7lPQU
         pmpcm+45h3pYoDj0IstBiOefiq6DayjVjw3EOKJJGGIVFtutaJ++y7VFo2c3huPfK5JY
         betA==
X-Gm-Message-State: AOJu0YzNGzh9So396oTOD24Gqg6ZugWIeX5L5xn7pMaS0z8ErjxngrAg
	sfnDgwLRh9h834JCQ1U9ObB7lDqoigvXNbYLJEEkYvZiSDGNJqs+Q/OWng==
X-Google-Smtp-Source: AGHT+IERS5UlE89KybAF7h/8CgALwxBrfzuHibnMmjZc9jiQXIz5HBdYRkn7P3urCmIlVovjD/7sug==
X-Received: by 2002:a17:906:f5a8:b0:a99:f67c:2314 with SMTP id a640c23a62f3a-a99f67c23dfmr449892366b.35.1728852319310;
        Sun, 13 Oct 2024 13:45:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99f86b689dsm186078166b.181.2024.10.13.13.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 13:45:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 0/3] support for discard block commands
Date: Sun, 13 Oct 2024 21:45:43 +0100
Message-ID: <cover.1728851862.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helpers for the block layer discard commands, as well as
some tests and man pages.

Pavel Begunkov (3):
  Add io_uring_prep_cmd_discard
  test: add discard cmd tests
  man/io_uring_prep_cmd_discard.3: add discard man pages

 configure                       |  32 +++
 man/io_uring_prep_cmd_discard.3 |  60 +++++
 src/include/liburing.h          |  10 +
 test/Makefile                   |   1 +
 test/cmd-discard.c              | 402 ++++++++++++++++++++++++++++++++
 5 files changed, 505 insertions(+)
 create mode 100644 man/io_uring_prep_cmd_discard.3
 create mode 100644 test/cmd-discard.c

-- 
2.46.0


