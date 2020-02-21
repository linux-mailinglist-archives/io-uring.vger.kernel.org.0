Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C0216897E
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgBUVqQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:16 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40997 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgBUVqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:16 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so1418951plr.8
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QddnNkr1vVqYuRjEL48Qvo04QhlAAJbX4SH4qus9k+M=;
        b=zMqDaFG9DMN4/FWZ8ReynWrSmTX2b7C87y9X5g4m6ZlxX91QFrrR5+2O/tzLSdyOgO
         8bbkcosQjF5cfhw8jZDwXSq7REDP8GCcm27xwUs1tfzUIOdNHXDLyDah6w/B2GtlVz0m
         lqw9e0EPhFtsA0twr+pbuj4hIAYkPLV0lXI/zDo2TqjDuLfeKsfYNkYDg5CAI2hzOZ9Y
         gGwKiel8ShVZVonjWtEh1LekgIVjQzfgD/ty0WKL/nBLCK2nZcLU2+OWgnRrEIVgbD5A
         HuPpm9oiCiW0+pf5/gd7tpPNWhWPTZDO3Z7aOLY7J9SHkyx/9Fhxr3GDu4s+bcmIV2qj
         3AOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QddnNkr1vVqYuRjEL48Qvo04QhlAAJbX4SH4qus9k+M=;
        b=bpIxQhdaEsEFkWDkKG+co6lrVbdu9ieK7+LkdP/G6B2dE+XEcoZJ/HIdpGleA/dN2X
         szzlXfBbqxS1RUvYR00XMzAEUXDLeSQWMFCiWLl7WIScfVOCihEyJIDl/pblMXFfacqs
         MMA1kiFVGvD15riiVoJd6P2H7omfb/Y7TQaShwQ7yn5G3IA2b0lDM8mFRnt8WjY4ctgc
         q+EilXeLoUiWFGgHbL3qbIRUK3OvAxAgf+/dr2dXn1lZmqkSwWXVfF+ygFI28uGBVwfp
         +E7qOjSjrc6vu9nrQCudGDBQ+IUjYmeqbi46jfCqpFypmMIV43OiUR16Soc+/bVk+W4y
         TpOA==
X-Gm-Message-State: APjAAAWMwn5UgqMZjDa7lcuFCVj01TQrB29WjPOEwWnLlr5uH2LfogGv
        9HVXAHBSTSKjvUSv4AllDeGZgSstfqY=
X-Google-Smtp-Source: APXvYqxUYbTUXJqAZRA9MtLqkbOf2gLCMOWE9Yvh3sLNJuZd3zTtTWMEzCdHJCK6EWs1N7IVVcM8CA==
X-Received: by 2002:a17:90b:f06:: with SMTP id br6mr5289697pjb.125.1582321573663;
        Fri, 21 Feb 2020 13:46:13 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/7] task_work_run: don't take ->pi_lock unconditionally
Date:   Fri, 21 Feb 2020 14:46:02 -0700
Message-Id: <20200221214606.12533-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221214606.12533-1-axboe@kernel.dk>
References: <20200221214606.12533-1-axboe@kernel.dk>
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

