Return-Path: <io-uring+bounces-6255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45D64A27BDD
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:48:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3F52163B82
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C051218EB0;
	Tue,  4 Feb 2025 19:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r+9bmMqR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7720E217703
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698503; cv=none; b=QYnjrZp3nJ8fP+y42MIrOYRjxzjFwwJAst9P1UkE/rMkdo4OduWgBg4UmXuguFmhnomSfHnI28NcePPH2OH0DgtkcLZcb4BgebmykU/hvmRVi+0M854mLbhshkrWqTRJuiMLeICO3l44Vp7FIw173y7XgO/4Tzb0R8YIh8fcuvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698503; c=relaxed/simple;
	bh=HCmSTkxKH/HdcO7Uglkp2F2gW3Sb8auKNqzvPdoBqxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx6GLkNWOmf7Jr6jov4gYxCDxDs5ncuIOgV+lgiBuZFp5tUvILXMQhTPGrHCp+bEY4AAjLfiphUrmMxOY0a74ZLDFik8+WOqhyT90oxPJu7Lf6KS5rdBkNlk7SlH8fr2Z9OVAZ3021sDoskHjBQhuipHd9YvbePSIe3CjHBstQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r+9bmMqR; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so399313139f.0
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698500; x=1739303300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+1svFbJCvXV9Zr5117Ph4lZhgiz5rV+2RtGExbCLLw=;
        b=r+9bmMqREeRvjz0JKPd01cJZECmzs/jCDM43H0wXvZ+1HdOKH5yjdtPrp986avfsIX
         21lBytDhIBQNX3bBMqegzYYLPcPq96YhEJTeXiprlUbYpV2gbjWBI1Ln3mctPafy4mMI
         nI0DTF+AMH2QBFu8ULUoKE8uwLvsU4Jkr6ogvxCG6gEyJ9mbSojYWjVg/2vfkuwm4w6L
         8UTIMkW/ppU5DVlxKku615GQEq3s5L03CtHu4DuRDuGxFmx5JZ5mCkABxteLe0+SXGg+
         /6pLlOfGm5tYc4k/NdkyB7X/lZQ9ERAHMaEbj8aRb7jJKqOO3c7a8qar1s5jATmYnpHf
         kreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698500; x=1739303300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z+1svFbJCvXV9Zr5117Ph4lZhgiz5rV+2RtGExbCLLw=;
        b=Hb68F6NX8TaP2jocNEFrQ4uHA2AuBaDENLDq1etPsVi4MKIkiarxBY3CgvPdFb4dGp
         +PFj5s0zr3MY3r+JATDTfhMD9/GUvqCnkFbsHhgrHf07sW8uTlb74uMWdqqA1uA8ljy0
         SmCANlkk0fX1Ho6PB4+hx22XEbnwbKhbQK//lVXDoOlvvxC5uUCLGZuny9i5OkO+l77P
         lEIyen4nrGjKlkVIGgkirx3qMOLR0GdrArPMTde0UglPCkVFJWD5nVsFsnfTfjU+0tGG
         gXrbECVn4/CK86ZSSon9jfh8u2ou59S8nUVx+xJscHdZ7b28wMwoAJw9dhdSrFYN0qu4
         YOvA==
X-Gm-Message-State: AOJu0Yzu/EYec+apm78IvnblmrRELQh0UJWJ+9hZ6juVvwg2dYyUMFef
	pOyf0W3OE+TYTVofvofb/g173qnzoqEB9zH30jqEEFebxILOxk1f+yw6XO+mSrXzSbcKH1ujLzT
	B
X-Gm-Gg: ASbGnctlvnkEugNN2trGtPrh8K7xkxM0VsCNlrE0WHucQn5D3tnG1a16WvChycL+WOi
	AUkxG2afeeIz3VpYG9lcYogSy1UTlO6QfLi+fQv+IRsT+jEHRcbw+Z689H28e/hPkjU7ZS7RHuV
	eh7Yg0L5BRFLPiv2OM1SGz9shlTHnTdbY+ZSo8fvnrmR2FQKpd452qZ12gibncT1ypfwoJzzq/o
	xO1sMAdvqMZ2nmRcFsplGcksqIaSR/EJ1MAxjrr4r4KqBV/1hTelZnILrMP+W5dQE7xbJAz5cAT
	xGiHR1GCGrWY6pBOvLo=
X-Google-Smtp-Source: AGHT+IGyhMhWzZeNFelBaJa5XqWbciXoqrb56RQyl9GgEyL9hOLIOlPxlzAjAP9SCizEF/4ij6wYeg==
X-Received: by 2002:a05:6602:7210:b0:84f:2929:5ee0 with SMTP id ca18e2360f4ac-854ea50f874mr24700439f.10.1738698500067;
        Tue, 04 Feb 2025 11:48:20 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:19 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/11] eventpoll: add helper to remove wait entry from wait queue head
Date: Tue,  4 Feb 2025 12:46:36 -0700
Message-ID: <20250204194814.393112-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
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


