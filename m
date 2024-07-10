Return-Path: <io-uring+bounces-2489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E210C92D7DB
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 19:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FD631C21227
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 17:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16ED219596F;
	Wed, 10 Jul 2024 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jnAKIHEV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF72195809;
	Wed, 10 Jul 2024 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720634304; cv=none; b=i8vyJ/bIIauNMg03sg6d2sh18ufB5AEVByh3onh9tzSn9yBlX8NWyYgDkJWJEqoRFo8c1uBhPYALwKNMQQnnHCUaFyB4uIbpSRwO4SJOsJ59gciytqNVFiIt5HVGCPWN1PiIfK4nYrOMwxDSY5duuEvRYbiH/VpDBTF0asGH80w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720634304; c=relaxed/simple;
	bh=uR/8YlxhqaKAswz4F9VN6aSFlcZgMuqwADdfEet8/50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=an0hVn9pXa/zZSrfH1tlmXdxRFBRLVJJQN3mTfvKHtLTdw6OqnVVxi2799GyOCBiOg6aGk7KMFNcwogsTic4ypq67K3laHEL/69Uou1R6Ap8PpL0fYJM0ZlzkQtZ+MRxlxCmtySEefynDXtlfr5+WxlwXjYyZqoW8Fb1CbIWMYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jnAKIHEV; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-58e76294858so2048634a12.0;
        Wed, 10 Jul 2024 10:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720634300; x=1721239100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lQebGvd3v2Vk456auWzwW2DlU/gLzT5ZxuqUNIibD/o=;
        b=jnAKIHEV1r3oVcj7uqPQM9IioaHFACtLisEX7MIbZYnExRaxSuKr4uB3n3jvHrmgZz
         0QVCaKGvKenPdDTUlGx6AhxyUjvNNGYNuOG1jywUKocepffVlAdMJG9yH+6my6S8ha4p
         c5vKGmIlHVRjdbUm1f+L5doh0Ih0ynHI4z6yecWASThEcMvG+5JYCRhJE+Op/55rENcQ
         GktgO8w2/ER2uZeR3iuXBdP8omGTenvnGcjG3jy/bjrqUqJrRF6NXKODzRFrXrtvO8hz
         uHwgSz9Ch3iRgw4/IOlxBFKdvq1fdjBNqr8RWD6UsCQeqxaZ71C/uQ6DNuCKCW5668vx
         8LHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720634300; x=1721239100;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQebGvd3v2Vk456auWzwW2DlU/gLzT5ZxuqUNIibD/o=;
        b=bssgV2I5OyvaAp9L//adkfVFKPsvDmD974POwpj4CRoyXlH/FItT27LqkS76HXmNo7
         bXIxYLfV+69UXOEWIVlQoAyGd9HcPTug5V9Ch6HITVI4rb+WSIcnK3+I5hiYL9pLRbNZ
         Lklr8E1U/+8b0zh3T2sTDItJaqCvR4J3equ2p2opNgAhAQF4T71FyjOqQSC/rIRk5/kC
         ilwmSJtps+ns1JLxppayTZ0Vnu9Cmx3XjTHwCC5zwznUfjmK7xm+4FtW3vt08z2CoW+u
         8rmEepXlcho4RKTe3CU4Umb7cpYzUUGRwADYODNencgpTe4icJAOoYA/Z6pS/awXw3pg
         RIEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXki1aXkohETMteHsVMJHHqXq3iDPX2nQsjmR8Rz+8nJps0RT/iLVh/sSDxDwqpnghuU2F7ChM0co/lnwLI88M28O+530PFHD6Sgg4
X-Gm-Message-State: AOJu0YwD+B9guKsAdvAgdIfC5ufThhvOxaS+Dl6DY1Rf1hrHUb64uosv
	U2x0yj0NjBaa5Y0jxgzXhTyPQuslh1Z/dnQR8tlesj/Jpyipgn7AcpcY4Q==
X-Google-Smtp-Source: AGHT+IFggS962GZGdsy9bSN80oC7k7rwyXMc2PLasapemI/DoRm/Tm/UQBL4AQUwwhAjp2Uo8+wBvw==
X-Received: by 2002:a50:aa9b:0:b0:585:412f:ff8f with SMTP id 4fb4d7f45d1cf-5980c60c691mr271301a12.4.1720634300472;
        Wed, 10 Jul 2024 10:58:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-594bbe2ce4bsm2459679a12.25.2024.07.10.10.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 10:58:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH v3 0/2] fix task_work interation with freezing
Date: Wed, 10 Jul 2024 18:58:16 +0100
Message-ID: <cover.1720634146.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's reported [1] that a task_work queued at a wrong time can prevent
freezing and make the tasks to spin in get_signal() taking 100%
of CPU. Patch 1 is a preparation. Patch 2 addresses the issue.

[1] https://github.com/systemd/systemd/issues/33626

v3: Slightly adjust commit messages
v2: Move task_work_run() into do_freezer_trap()
    Correct the Fixes tag is 2/2

Pavel Begunkov (2):
  io_uring/io-wq: limit retrying worker initialisation
  kernel: rerun task_work while freezing in get_signal()

 io_uring/io-wq.c | 10 +++++++---
 kernel/signal.c  |  8 ++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.44.0


