Return-Path: <io-uring+bounces-2457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37D9E9298DB
	for <lists+io-uring@lfdr.de>; Sun,  7 Jul 2024 18:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E161D1F223C3
	for <lists+io-uring@lfdr.de>; Sun,  7 Jul 2024 16:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BAB7EDC;
	Sun,  7 Jul 2024 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6rnungG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B965A45BE7;
	Sun,  7 Jul 2024 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720369935; cv=none; b=EtdtRGLJ2UEjPbbHs02poWqrDsatwK77Aszdxtkj7dbpwEXSKqJprG7/KqESLVxxMXyjGnMzC8KbL9VZ0+IGT9g64gFc2o5VHVj9mhwnjiIyiAj2Y31ZejKMqU4nbMvuTm2rpd3L3tcFtVY2s1PlodO26Hx4vL5HNlb0IYwZVO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720369935; c=relaxed/simple;
	bh=iGpE5U5Tlpaw5uTZKYNRfWXK6kMLgTN1qBfiQRbLzGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bujbFLSO/NUFH89zYtuC7sG9MscNCRzCnQgl3DMItcrmdW+/gQpg9HalUdXx01B3AOepOsi1jWw8lOnINpJryebrfn74kiFe96wipKMFPOAoJrDisZluXmVl6w5snNQ/wubj9qER5S68G8q/1Oc/FF7vENh0yZb68KwiCxQCHWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6rnungG; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52e9fe05354so4557668e87.1;
        Sun, 07 Jul 2024 09:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720369932; x=1720974732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YV3u710GY3e7lyl90PF3A1pw0/T5hESpY3+kLAxxYOY=;
        b=l6rnungGlYi/XvflBfGzfJRBR1gBmirVa2gPPLiMyi5BsJ2vQDgV26a9kyIYclLFWJ
         147AF/xgc+7Cqwre5pt5nqlxRAF5DV40hjMA7mPrjyzohMg2Buvr6OtDFP3X+TAfU5Pm
         UsGrK0CxKdrtTydDvscu/8+gtEZyCgoGNPBfGXWipyxBtCSSzkIYdoHaoPsmL+nZECSy
         R4D/5AS0t2utIGrPiK91PS3j2qjtfNFby72d8ayTxg1fEsUpKLHbjKDDLFH4Skl/3l11
         x9Vhj3I6xNhfDyCrY3q10QEqlOBCz/3w4u5yRUm/2vc+WJBQuHgOPd8W8PF8b31W80MZ
         Fu+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720369932; x=1720974732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YV3u710GY3e7lyl90PF3A1pw0/T5hESpY3+kLAxxYOY=;
        b=L3wmwYbUJ5jddC2rB5bphdsUWHjgYlR7wOv2xpIzncGfzJmnTuJelCwCwvZE5W7MyI
         EMHGj3M8xAho/utleKjlEpHyKQggToZEmktM+cTlR7UGxhYOL0ojnTWEIlLjdLXjb7Jj
         J/rqIkYk3xvcutAw6VJv078xRWqUTdbT7Q6kELzu8vy0IS2jR/c/80NCPdMxbd4+tLV8
         ttWpuzxxlXKbiSQlWU7P0yfc2Pw/MeInWnHPMo9CfNmgKsjHzbIzfVydCt50ac1hsMqM
         MWBFi76jrDENJEulZrvEhsyU8JEJnBCUnDjYmOlc0Ym2GMz95fUb5be1fBp8VSmUwrXU
         Ciww==
X-Forwarded-Encrypted: i=1; AJvYcCW05V70j9P8MvAISQzF1Hd7HcxPXri9lsNBUlVfOaENxDPO3uABQqTEpLnuCCWQJ7gRewFuV/s+5k4BfBNLPmsXRvvSPm7Kde0ZU/BF
X-Gm-Message-State: AOJu0YxHG/b+ngtD8ZkwrAb8nXwCR7Qh/7XxkkvEOApmrfdoqZBAo8FX
	/4wyCQAskOMsGOoxK2UBNGv0RK7uCxSQYkdMB+LfSkNKkv0Dfi5V6gj63A==
X-Google-Smtp-Source: AGHT+IHHttRaz4G+7Y0TScCW9snTeVMedhNadl0e6Y9ONiRVt/LVUiGN4CIBg3/NA/pyHn/LOhmdTA==
X-Received: by 2002:a05:6512:2822:b0:52e:9951:7881 with SMTP id 2adb3069b0e04-52ea06b0d1amr7787563e87.52.1720369931307;
        Sun, 07 Jul 2024 09:32:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4264a1e8014sm134335215e9.21.2024.07.07.09.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 09:32:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fix task_work interation with freezing
Date: Sun,  7 Jul 2024 17:32:09 +0100
Message-ID: <cover.1720368770.git.asml.silence@gmail.com>
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

Pavel Begunkov (2):
  io_uring/io-wq: limit retrying worker initialisation
  signal: rerun task_work while freezing

 io_uring/io-wq.c | 10 +++++++---
 kernel/signal.c  |  4 ++++
 2 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.44.0


