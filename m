Return-Path: <io-uring+bounces-6228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3FFA26010
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 17:31:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 234D71887ED0
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2269D20B210;
	Mon,  3 Feb 2025 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f6v5Hc7O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827872B9BB
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738600290; cv=none; b=eODcLTIsUo7pCnw5J3Ju3nNyHlDBB3iBaR8cmQNRqofXm+xo9Yd1ew9C+9jVrUhr1Y+cnLxIV5cVy5ncyg8ZqqFqEtFuye4XrI2LKsJX6UYh7T3JiId+MND4Q6UnF1Rwcj2727FM25LZV1kiSySH+UlXaGQjUAswJvAiiTFX4wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738600290; c=relaxed/simple;
	bh=ayD177cZGh9bhC4WV7iQTen+4xZyD0WE3g92TyrwJnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gusA1txyPbtE9daZoIWf/KEQ1gcpWVZBPe3Ms/6oGIy+PO+qByBDLbwyh6lkwH5NBNUSufuI6rFbq3bEeSNRROza9AfLRIdjvgdwpDpYA7lcPVNxNgKLbhOUWXp19s1pJMSbWSLHxGsTPkXF/8AIpo8t7xsrJjBjrbpF3Ng6bl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f6v5Hc7O; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-844ee43460aso279553339f.1
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 08:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738600287; x=1739205087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mCWW/DHnmpnY+C0n2fbNEGbgNNkUYylpMG8Oip3AQsg=;
        b=f6v5Hc7O/DXa4nmyM4n9ODsNvkNmUs/Z5Z0a1h6WjIHB/SpnDvF2x6BgHefgbwPHz5
         7BPeKgaY89G6mrhzkF9Y+8O+qIL4Ud3HbblcnQWJ41SiG4DJJ3XxvuSxFm9+rcDBluqp
         iuZbCqidgWbM5/Srrya4xNe8gFOTK9e1k6CRlIyLrz4OSGOGupvAG7KIaLWSf4OTtaaf
         tdDN2t+OWo3jMjcYQWaT+H8Byvzp+2nUA0Lp1Q92jNsqBxhDO9TH5umgOCgvTJCsDNly
         biwBQoP931WR8/1+CIosOADUOANCE+ddm61Qsb0Z23jePnuBW5tB/B2GISErvk+D3+Jq
         X3vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738600287; x=1739205087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mCWW/DHnmpnY+C0n2fbNEGbgNNkUYylpMG8Oip3AQsg=;
        b=tyKKEr4oOTfXc6sINnMwm+RzrPyKibkHlxhBzx2cSQiTOb6nyBZ5gdc2NkLK65GC0z
         tFulaAfs6E6VWvOljflgOl4uqf8ZGdilpM1HH9voAKfNYmI9EGMrwWHngbIlouWjVdvm
         i/os4a3DicVfJHmjbf0v0XkP2susmZUvWQSWFxtiGOFB1RwgCgRkZykx7preaLUjZv3J
         UUF7AfUtfcD0k24qkwxWygP7DuCJQOELL6QYfECzLCfzmHmylemWDYYpxpEMmmK9zPQs
         ZaOjoZ2QCDr216JdV6NB/TssnnnGCl9AQF9VdUhXQeVFf3ACuz0TeYJSucq5jeMzAFWs
         fOiQ==
X-Gm-Message-State: AOJu0YxsHkenT2hy7Ru6daEn/p9mRqvnATz7+7OqHl/67o9Z8T33mvkm
	RbvmTyP3Fm1z+7WlOyyF1Et9XzPWa/28ZlRG4lDh8axRs1zYhfifcF5SL0BEAIbBjnYY8kBlj2E
	xNkY=
X-Gm-Gg: ASbGncs0ahG2F23atJAS/68pMc3SWkyQ02MgPEu35PqjcoWZt3jtEJS0C8lTIIUJn9x
	tbYaOycn9fNvsJjV8mWhtog5amikyNumgg/xa8vlp1984oO/18R3Z1dyVoRnTZPMOhJWXbZ40Ru
	dbwiWhkoXAQV/C3e0VVmG5cLUwH3Pf7d7JvOy0WVJPIcBZnpujfCjBnhOnEna4BObMplvtC91m8
	rat2zAXyQl7KIIBXb1UsqCu/W/1CV6GwSCQzkUwVJDAm/BAGUjSQDNVTMqUt9uQq9Z/WSGV2HEH
	PztFydBCCWmXP0VYX7w=
X-Google-Smtp-Source: AGHT+IFody0BekAT6IYbYLW3U7jHo0YoJOdClv9dRYiYiWYEAJytUXMyrnGF6J0B0Z1zwildYJdr0Q==
X-Received: by 2002:a05:6602:4806:b0:84f:44de:9c99 with SMTP id ca18e2360f4ac-85427e00ab5mr2210157139f.5.1738600287116;
        Mon, 03 Feb 2025 08:31:27 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-854a16123c6sm243748139f.24.2025.02.03.08.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 08:31:26 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] eventpoll: add ep_poll_queue() loop
Date: Mon,  3 Feb 2025 09:23:43 -0700
Message-ID: <20250203163114.124077-6-axboe@kernel.dk>
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

If a wait_queue_entry is passed in to epoll_wait(), then utilize this
new helper for reaping events and/or adding to the epoll waitqueue
rather than calling the potentially sleeping ep_poll(). It works like
ep_poll(), except it doesn't block - it either returns the events that
are already available, or it adds the specified entry to the struct
eventpoll waitqueue to get a callback when events are triggered. It
returns -EIOCBQUEUED for that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/eventpoll.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ecaa5591f4be..a8be0c7110e4 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2032,6 +2032,39 @@ static int ep_try_send_events(struct eventpoll *ep,
 	return res;
 }
 
+static int ep_poll_queue(struct eventpoll *ep,
+			 struct epoll_event __user *events, int maxevents,
+			 struct wait_queue_entry *wait)
+{
+	int res, eavail;
+
+	/* See ep_poll() for commentary */
+	eavail = ep_events_available(ep);
+	while (1) {
+		if (eavail) {
+			res = ep_try_send_events(ep, events, maxevents);
+			if (res)
+				return res;
+		}
+
+		eavail = ep_busy_loop(ep, true);
+		if (eavail)
+			continue;
+
+		if (!list_empty_careful(&wait->entry))
+			return -EIOCBQUEUED;
+
+		write_lock_irq(&ep->lock);
+		eavail = ep_events_available(ep);
+		if (!eavail)
+			__add_wait_queue_exclusive(&ep->wq, wait);
+		write_unlock_irq(&ep->lock);
+
+		if (!eavail)
+			return -EIOCBQUEUED;
+	}
+}
+
 /**
  * ep_poll - Retrieves ready events, and delivers them to the caller-supplied
  *           event buffer.
@@ -2497,7 +2530,9 @@ int epoll_wait(struct file *file, struct epoll_event __user *events,
 	ep = file->private_data;
 
 	/* Time to fish for events ... */
-	return ep_poll(ep, events, maxevents, to);
+	if (!wait)
+		return ep_poll(ep, events, maxevents, to);
+	return ep_poll_queue(ep, events, maxevents, wait);
 }
 
 /*
-- 
2.47.2


