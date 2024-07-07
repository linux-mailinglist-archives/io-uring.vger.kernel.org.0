Return-Path: <io-uring+bounces-2459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 687139298DF
	for <lists+io-uring@lfdr.de>; Sun,  7 Jul 2024 18:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 862D61C20B63
	for <lists+io-uring@lfdr.de>; Sun,  7 Jul 2024 16:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ACAE46435;
	Sun,  7 Jul 2024 16:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7LxEEfN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F5F3FBA5;
	Sun,  7 Jul 2024 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720369938; cv=none; b=A+37wrnVHhtnE0zn6u714btswTOQPmZ61mL+WIxmNuFDjGyieXPwOb9GKjzJvzBvDFfc+un25DDWqe4s729NfVkQikruA7O/h01SVwaBWGKJC/g3rlhBvu4jmkvD5NvrF6g0gmX4YUcML9UxWLajgg5QxSo0e5VfrZFAwyKJR48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720369938; c=relaxed/simple;
	bh=GryIG9DNPkXL6dOI+O9Y9ATXRgOy1NZX/xATLMxFoNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2E22vx11F76I/MnhETGvMQDdlY2P6D/bGz9dv2JQbBpuu3giLD+7CvgkCiU+SRub4Xz3aJX06CsegHamdDn2qON/VyIf09l5k1YOm7S6lsWkYILzFQaSkQt4BKjOnzB7RrQYNDUvVsQBW5ZF9JLDATO9au74zGw6RHOqC1on7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7LxEEfN; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ee88c4443eso34176081fa.3;
        Sun, 07 Jul 2024 09:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720369934; x=1720974734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1yNnFas/7Lr5aBFTus2w2lifc8IqGeG07znJipdmls=;
        b=N7LxEEfNrk/N0bPuBhsWhUbs9YeP/cgWjoNK9zGbSKwDyCZJJgVFH5NtdnFXIFtmJs
         rhxC15ZD4jJOvhWmX18t+sMM0zH+hCWLIvi+HnhqFAZCVVhofigK8vjWxcU70qJ3S/F6
         R4u7hDGbU30buz4sQqlXwFq7z8HZcZtpovPCBJnGyJ87rd/fCiN4vw9EWjqaGDM+ANu4
         aQw6DdzvGnqq4SWIUQVlkjtKvJ1WG5xDT+FCn25/MPeMCtJuIq7mwTv8AUFpJmVmnYHp
         vbXM0fe/wLu1usNR8ZcpqIhGgNlWL+Jbqj7XPRSRqhmNBzRw6FHQDwVDal3qKi6v7Uu9
         V08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720369934; x=1720974734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N1yNnFas/7Lr5aBFTus2w2lifc8IqGeG07znJipdmls=;
        b=TkSqP6V/15tWnKvj2ZfC5uZ2c4egc8KUotZyi0x6zn2OqLKU+cYLU2H9pwpWcSS16m
         EJ8nZimDAZfbpy9PUNEbdjMd6sGvn9sueTeDwDl6tA4gcJdVf8HXqP9Xz2QGBJAteMyb
         hYU3LqAXDjgEatrJJcTzqtqXNI+kAUEhUZqUXQ0dBXDrzb827C1cLPvDyxk6tI24hU5W
         3LnwdZXifpHYC3dURAYlni/ri9e/Eda5AucS0CPOygNTN6GzAfGRiPnSyuRhqLDnclB8
         U3OitFVYUqgB+aHEdTS2h/mKFVCnwiQTiak1Mhm4YkjUsV3ZiD0mKlSX6R4+xBWtR/Yd
         tgNw==
X-Forwarded-Encrypted: i=1; AJvYcCVbpVnKMLA82B9ATP6bYhzXvnqZ+6U9OhBCqTmav/N8MwlB9kok1+yyVKli3uo89C0HAqv8vYtjBQQz5BkChVlu0IymYR9TmbvjcDbo
X-Gm-Message-State: AOJu0YwBeXxI0jeJhDWveJPjzE/nwnnYFngHo5VaH2Z+XAP/NbN6z8/F
	iz4LQEuNMPVV+fyVf552D5h8JWWQJYJ24tT+1BC+bvfWiD/dRN9FtcujQA==
X-Google-Smtp-Source: AGHT+IGUQsjUK3JrjtflPS3usXPAkNfTEb/V/K3P6Ihn7Pt0WENpi/LQwrkKk9C0MjQrvW9McsbAeQ==
X-Received: by 2002:a2e:9006:0:b0:2e9:768a:12b0 with SMTP id 38308e7fff4ca-2ee8ee13b14mr66713581fa.50.1720369934126;
        Sun, 07 Jul 2024 09:32:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4264a1e8014sm134335215e9.21.2024.07.07.09.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 09:32:13 -0700 (PDT)
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
	Julian Orth <ju.orth@gmail.com>
Subject: [PATCH 2/2] kernel: rerun task_work while freezing in get_signal()
Date: Sun,  7 Jul 2024 17:32:11 +0100
Message-ID: <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1720368770.git.asml.silence@gmail.com>
References: <cover.1720368770.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring can asynchronously add a task_work while the task is getting
freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
do_freezer_trap(), and since the get_signal()'s relock loop doesn't
retry task_work, the task will spin there not being able to sleep
until the freezing is cancelled / the task is killed / etc.

Cc: stable@vger.kernel.org
Link: https://github.com/systemd/systemd/issues/33626
Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")
Reported-by: Julian Orth <ju.orth@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 1f9dd41c04be..790d60fcfff0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2694,6 +2694,10 @@ bool get_signal(struct ksignal *ksig)
 	try_to_freeze();
 
 relock:
+	clear_notify_signal();
+	if (unlikely(task_work_pending(current)))
+		task_work_run();
+
 	spin_lock_irq(&sighand->siglock);
 
 	/*
-- 
2.44.0


