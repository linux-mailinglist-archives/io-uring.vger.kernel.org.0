Return-Path: <io-uring+bounces-6225-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE39A26013
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 17:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11B243A2642
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:31:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8347920B20D;
	Mon,  3 Feb 2025 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AxU0maFE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B653920AF98
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600286; cv=none; b=VDdAzGCHxB6kTHlkCEZNqUKuqgf2J2alwE2ZyZP7jAEJ0x+wMP6gaGM8mxXZyq+FZAxx76zYjyNjfNERkBvm6hFQ1TfgbOQFDCpTegIrwpw5/tz8zYLXNbIQAzoSzNnXoyhmwjVx2DmVjpUcwkjrptFw/v5D3jqJwIBaSSkVX5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600286; c=relaxed/simple;
	bh=HCmSTkxKH/HdcO7Uglkp2F2gW3Sb8auKNqzvPdoBqxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3KQbl8kXW1SyVthGRjTBtzQXGC8hJQMELthEpz9xwfxbeWqp/1hkYiwjINfNCyaBqVxyMy7BcFvT4ySa8Br3MqunHO+xAX1WGoBGm9Z1NntrTFdxPoKLZ/ULENBrq+0rf3WDVq37RaGZsn4mwn3c4Y0Y1GroC0ty2sdDH53/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AxU0maFE; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844ce6d0716so322440439f.1
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 08:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600283; x=1739205083; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+1svFbJCvXV9Zr5117Ph4lZhgiz5rV+2RtGExbCLLw=;
        b=AxU0maFEL3t1q4p6/lMeAJCdV8HTmJyy8G4YxU7WhQ4TGs3ORt4ICLaXexYUFRl3Bf
         L2taCK7BhuMo7V0Vjs2Tgpf0NMocTdKQOENhe/U0I7xctCinju03lI5AxFCGdhmbIUkt
         9ttJqeRW1Qst5Hqsfw3FRyFd2ETQTEpov3TNd1QPD97BFlhZ3CPKVJ+8n2L7Kmtzo5NT
         RgDRZGKMI6IuNtkXO0lZ+jCtJESDYrIPKGmVfUJP6PT7Zz4ai1Sot5kNFB4DapjyIhmw
         2vHxXxmEFda9j0+RxUA7yJvA/Q3gRnqg028zVZC7DHknzXKYPUiUmH5NEfN29HsaS7bT
         0HNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600283; x=1739205083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+1svFbJCvXV9Zr5117Ph4lZhgiz5rV+2RtGExbCLLw=;
        b=d22VtpY5Q9XHecWCnDoKupbWC37LCQQT0OjM+M1WplMkrHCoUllF7dVwa9rqyjAJtp
         wejCjjzG5mGQ5rVdHnaOUqBpztiRLvyKU8zR7F4/SD+OOwc0r7/iMYflGFbwLXYhuHDz
         Zdrv5lB0SCml3Q23mHbPVt8sep1rjCjC5u9TkMTnXeOw6szjXP+65X+Jk68Udt1UmdwO
         D6JgUUyRspwgZ9EQpIeBUbo7TjLeGBqgXnnT3RfdLOqsxjlFy1RNOn5KQHTHawud+jKJ
         O1GwntBX5XgsTrSuZ2lo/NKvsKICSjyk/ZH6NBh2lWS4GhzrITmRJw3FhlM7VnQuBS/p
         eUMQ==
X-Gm-Message-State: AOJu0YxJPHTeJrM+zUk/j1wJoYc23qroU22XgRgq5ZesaFiSwwg8qczI
	AXoJ6uca9AqZRO262nNeSU8I+r+5KDcEZjTft8vpxIqPcKWp0/Dg2ab14CIsLrd5CUSXJCV3EKV
	yALA=
X-Gm-Gg: ASbGncvfBmlGKnsN/D1pftL5gbX8zqiYmBMMzUGN7qu4GAxlW3jQw9XvKNc0O8QtGk9
	AEsCK9+3MiFaGTk+HY6ROG+5Ge+al9xjAltYhdoAXis870Fs0BWchaT9Ri1lvLQGl6qQH0mKUMW
	RrJ4zhXPbu/eiZZGL8S24crablqFeaN+fRCWVSjZb2FNQSAJC5pbFI7qa5F35ETPROvMj24qeOL
	jLlmtiiMlZ1vhJDosIvITpozSwuIJXDD4AXMJ1Ek/YMGYYUNMZasngsN2Fb/P91JAbygy7o+PLJ
	c3kUAY8zx1pJ7Z1JaOc=
X-Google-Smtp-Source: AGHT+IEPqq+G0h4VYNXvxcyNE35GywbajeWSs01Mm7MyH0q/0gNnCdTL/T/DNkoK0+JZYY8PlpjbgQ==
X-Received: by 2002:a05:6602:2c8c:b0:852:5e4:7d9e with SMTP id ca18e2360f4ac-85427de4d4dmr2047201539f.1.1738600283057;
        Mon, 03 Feb 2025 08:31:23 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a16123c6sm243748139f.24.2025.02.03.08.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:31:22 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/9] eventpoll: add helper to remove wait entry from wait queue head
Date: Mon,  3 Feb 2025 09:23:40 -0700
Message-ID: <20250203163114.124077-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250203163114.124077-1-axboe@kernel.dk>
References: <20250203163114.124077-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__epoll_wait_remove() is the core helper, it kills a given
wait_queue_entry from the eventpoll wait_queue_head. Use it internally,
and provide an overall helper, epoll_wait_remove(), which takes a struct
file and provides the same functionality.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c            | 58 +++++++++++++++++++++++++--------------
 include/linux/eventpoll.h |  3 ++
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 73b639caed3d..01edbee5c766 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1980,6 +1980,42 @@ static int ep_autoremove_wake_function(struct wait_queue_entry *wq_entry,
 	return ret;
 }
 
+static int __epoll_wait_remove(struct eventpoll *ep,
+			       struct wait_queue_entry *wait, int timed_out)
+{
+	int eavail;
+
+	/*
+	 * We were woken up, thus go and try to harvest some events. If timed
+	 * out and still on the wait queue, recheck eavail carefully under
+	 * lock, below.
+	 */
+	eavail = 1;
+
+	if (!list_empty_careful(&wait->entry)) {
+		write_lock_irq(&ep->lock);
+		/*
+		 * If the thread timed out and is not on the wait queue, it
+		 * means that the thread was woken up after its timeout expired
+		 * before it could reacquire the lock. Thus, when wait.entry is
+		 * empty, it needs to harvest events.
+		 */
+		if (timed_out)
+			eavail = list_empty(&wait->entry);
+		__remove_wait_queue(&ep->wq, wait);
+		write_unlock_irq(&ep->lock);
+	}
+
+	return eavail;
+}
+
+int epoll_wait_remove(struct file *file, struct wait_queue_entry *wait)
+{
+	if (is_file_epoll(file))
+		return __epoll_wait_remove(file->private_data, wait, false);
+	return -EINVAL;
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -2100,27 +2136,7 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 							      HRTIMER_MODE_ABS);
 		__set_current_state(TASK_RUNNING);
 
-		/*
-		 * We were woken up, thus go and try to harvest some events.
-		 * If timed out and still on the wait queue, recheck eavail
-		 * carefully under lock, below.
-		 */
-		eavail = 1;
-
-		if (!list_empty_careful(&wait.entry)) {
-			write_lock_irq(&ep->lock);
-			/*
-			 * If the thread timed out and is not on the wait queue,
-			 * it means that the thread was woken up after its
-			 * timeout expired before it could reacquire the lock.
-			 * Thus, when wait.entry is empty, it needs to harvest
-			 * events.
-			 */
-			if (timed_out)
-				eavail = list_empty(&wait.entry);
-			__remove_wait_queue(&ep->wq, &wait);
-			write_unlock_irq(&ep->lock);
-		}
+		eavail = __epoll_wait_remove(ep, &wait, timed_out);
 	}
 }
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index f37fea931c44..1301fc74aca0 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -29,6 +29,9 @@ void eventpoll_release_file(struct file *file);
 int epoll_wait(struct file *file, struct epoll_event __user *events,
 	       int maxevents, struct timespec64 *to);
 
+/* Remove wait entry */
+int epoll_wait_remove(struct file *file, struct wait_queue_entry *wait);
+
 /*
  * This is called from inside fs/file_table.c:__fput() to unlink files
  * from the eventpoll interface. We need to have this facility to cleanup
-- 
2.47.2


