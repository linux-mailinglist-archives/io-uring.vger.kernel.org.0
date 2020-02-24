Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB2916ADC1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgBXRjq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:39:46 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:38548 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbgBXRjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:39:43 -0500
Received: by mail-il1-f196.google.com with SMTP id f5so8438986ilq.5
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QddnNkr1vVqYuRjEL48Qvo04QhlAAJbX4SH4qus9k+M=;
        b=tD1/XMiC/wgvzR4Mjh2D03gnsQr8CVic8OZAv6WRvpWsyKDreUdUjUa5V8O0Rpf3wM
         mHqgLaataIcTdDTBTgbZgN6+yWdTYK8MUyBpxgZhOPkr9+ltIBb6ZNMlZKPPx/LgZzli
         tFrfuMzMcgXP5O14xmfH5G2Avb6hEG6+gcF7iJ3tS1ldtBR2TWJ1Hy56emLRF85imDiy
         pkOfVDmia7BkSw+y95VcByk9lamIEDIqDjk64kdzDclR+tfh36LuItuiezanWYgzNY6l
         1Pve7y6AUKyz1FcTrYKiD2Ekn7aWjVIPvI6TWXYFw1K9iHqy4SplEfSVz2e+pImKXgdq
         Ybsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QddnNkr1vVqYuRjEL48Qvo04QhlAAJbX4SH4qus9k+M=;
        b=fIENM6S1vYWvOiCHPzm21xO+m4dw4uOh3uSQY45wqND/MdbE5PDBrc5uo0vDJIZ7Ab
         p0WDKl0KpVooRvodIONWvruKecq48I95zyd7FuG/QxGbvVt0SpNjlTU0qHUm5VgbuCjP
         zC2Tjkd9O4bkGC2yGceE/PeEnDIimr3Eg/qTtyrG7Ji4sAWdsynSg5a87If/GoYwmBC8
         UYIF9yzTHlqYZE8ASojsiEYSVxygAOyyUBg9e4Fida94BQxHYXtKHkVCwxE8DpcRUvvC
         8lM6ovBdpQ2/FC0y0mPyA7sc5eSaAB9++lQsqF0jQibef9048as56/8mWbkheMgH0Lr5
         Vavg==
X-Gm-Message-State: APjAAAXwh5gr5yjJX4Tp/YFkC2m7T5p2B4J7KiggOxzk5eHwcnZSo5Kh
        Ls6ZE+iWj4F0YxmZXPMskQhLzUhtr1A=
X-Google-Smtp-Source: APXvYqy4n3jBlmCPUcmj+TF7dewRQD16zN9eVgkJLzPZc5gIF9ZAkN79FzfBtWixlTjoik3UZIUW6Q==
X-Received: by 2002:a92:5d8d:: with SMTP id e13mr58002727ilg.285.1582565981767;
        Mon, 24 Feb 2020 09:39:41 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p79sm4541982ill.66.2020.02.24.09.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:39:41 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] task_work_run: don't take ->pi_lock unconditionally
Date:   Mon, 24 Feb 2020 10:39:33 -0700
Message-Id: <20200224173937.16481-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224173937.16481-1-axboe@kernel.dk>
References: <20200224173937.16481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

As Peter pointed out, task_work() can avoid ->pi_lock and cmpxchg()
if task->task_works == NULL && !PF_EXITING.

And in fact the only reason why task_work_run() needs ->pi_lock is
the possible race with task_work_cancel(), we can optimize this code
and make the locking more clear.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/task_work.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0fef395662a6..825f28259a19 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -97,16 +97,26 @@ void task_work_run(void)
 		 * work->func() can do task_work_add(), do not set
 		 * work_exited unless the list is empty.
 		 */
-		raw_spin_lock_irq(&task->pi_lock);
 		do {
+			head = NULL;
 			work = READ_ONCE(task->task_works);
-			head = !work && (task->flags & PF_EXITING) ?
-				&work_exited : NULL;
+			if (!work) {
+				if (task->flags & PF_EXITING)
+					head = &work_exited;
+				else
+					break;
+			}
 		} while (cmpxchg(&task->task_works, work, head) != work);
-		raw_spin_unlock_irq(&task->pi_lock);
 
 		if (!work)
 			break;
+		/*
+		 * Synchronize with task_work_cancel(). It can not remove
+		 * the first entry == work, cmpxchg(task_works) must fail.
+		 * But it can remove another entry from the ->next list.
+		 */
+		raw_spin_lock_irq(&task->pi_lock);
+		raw_spin_unlock_irq(&task->pi_lock);
 
 		do {
 			next = work->next;
-- 
2.25.1

