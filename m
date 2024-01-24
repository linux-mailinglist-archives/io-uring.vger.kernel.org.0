Return-Path: <io-uring+bounces-478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DD183A429
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 09:33:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 076191C2189F
	for <lists+io-uring@lfdr.de>; Wed, 24 Jan 2024 08:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F03F171D8;
	Wed, 24 Jan 2024 08:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MAXFUI0e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45F88C1C;
	Wed, 24 Jan 2024 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706085200; cv=none; b=bTawd7vZPr8wp8yvju82LzpvQOGPs77KDaXYb7X+dF7jtNuGBoI28coTaEKMzPyPl80u2Mr2eUAy3EJZfxXv4yVWLcESdjWFr2uHsfTDQsrLTw90gkSTtqjUSqOl1RvrUK8Od9pvXWw217mRfg3H8ulhNc+N2+JjEdKczJdMp2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706085200; c=relaxed/simple;
	bh=7RcA+wpBojN9P3jXK1BGmVym3oj7yCYu3G77e8mtEqE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IPKKZJcJkmUEcuoxF4lvzi6PptAteFWl2+432b2cQJzEmSK09vEKHN6OYrHELKZtYi4hNmepqczldsWxLpGbwbX3XtJAuEbdhVU9UzQjE23ylbuPk5ZrqMcOImsjuuUSTS0wa40Z/tgLwl5nqjlMlwejAwoowdU2Mqav3GcDrCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MAXFUI0e; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40ea5653f6bso50489335e9.3;
        Wed, 24 Jan 2024 00:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706085196; x=1706689996; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vvyjo+Vy7Kiu1/HrFUuG+G2GbaCsCbrc6C12lfTVfo0=;
        b=MAXFUI0ebke9V7sr4DaKnY7hGozZmZDJRaEORqfr+NIXIg4dYT5Bf/B5rUGSLva4kF
         WJZ3ooItSxi31giqJ//l1yMjvXtNp/X/+fbFIoLzrtqAhwovymASB6nzNMQO6M6rY0z5
         oyh1iZpZJ9zcuPU1SzJi2L1Iu30S9RiWtFJBCIiW8tcFbMIdQH+PU3a5kotu7DgTo4P9
         IfCc93y2l+LeBaE52KEK9KOOKP84eh1s7KO/ZIeN/e2MPRgiuY+St8pr5KAI6rJx0aJU
         b3jCw1JFw6wo7V+4r/6HoIkdhI+ZPGlR368n667aHEEVMfRsRlDdDy4Ljh8Nn7LJDE1m
         I6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706085196; x=1706689996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vvyjo+Vy7Kiu1/HrFUuG+G2GbaCsCbrc6C12lfTVfo0=;
        b=g0CaFcKevihWiTp5KKgmmTJHxy2/blZFUXAmbzKuoxFm8X1FsyRFRP8+bBnwy3AjVm
         dQmMDTCNpsuJa+M3ch3Py+PukA1U2AtIoTsnXcXW0C/wssB/e6L6eS65ZdKBnlzPUnmw
         ru9t0rLFd0YMbWq8FgDSVnJM7//aN31EB1uf4C/qeHIKG5TC+MtGZ17gbfZgk4XMF7zq
         WfkWFyaWxB7crNlwWYG0MaD94NzZj7bEjMBe911fl4CPmdsTEUzRQL5GBdVGDol3ESPS
         VUreKbCr0y75W0pz3uSI9z/XeOeWayn4eRiGoamO09OOGIQUGVL/1QJU1Nhh/GJtgWvh
         gJag==
X-Gm-Message-State: AOJu0YzTpJw/qe646n4NkC1BFn93Crw/mPnVoJccxZ6gF37URe7AxWxo
	hkmXwypmU5ylzEKGh1i0MTQtx6EzmJLmV35231XMr/2B2ELv8+j/uY2AFFB/8TFCHA==
X-Google-Smtp-Source: AGHT+IHL5mfgBpw5CCsuC8iqyNUSAN0JpPjt6sBCGOSq4LYw7tT+/6A3UvZx/r4uFxpEg+zjj6kTFQ==
X-Received: by 2002:a05:600c:4092:b0:40e:8eb3:b1fd with SMTP id k18-20020a05600c409200b0040e8eb3b1fdmr857186wmh.58.1706085196267;
        Wed, 24 Jan 2024 00:33:16 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c469000b0040e39cbf2a4sm49324365wmo.42.2024.01.24.00.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 00:33:15 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: 
Cc: io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH v5 0/2] io_uring: add support for ftruncate
Date: Wed, 24 Jan 2024 10:32:59 +0200
Message-Id: <20240124083301.8661-1-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds support for doing truncate through io_uring, eliminating
the need for applications to roll their own thread pool or offload
mechanism to be able to do non-blocking truncates.

Tony Solomonik (2):
  Add ftruncate_file that truncates a struct file
  io_uring: add support for ftruncate

 fs/internal.h                 |  1 +
 fs/open.c                     | 53 ++++++++++++++++++-----------------
 include/uapi/linux/io_uring.h |  1 +
 io_uring/Makefile             |  2 +-
 io_uring/opdef.c              | 10 +++++++
 io_uring/truncate.c           | 48 +++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  4 +++
 7 files changed, 93 insertions(+), 26 deletions(-)
 create mode 100644 io_uring/truncate.c
 create mode 100644 io_uring/truncate.h


base-commit: d3fa86b1a7b4cdc4367acacea16b72e0a200b3d7
-- 
2.34.1


