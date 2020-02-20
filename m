Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BDA16685C
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgBTUcB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:32:01 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40291 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUcB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:32:01 -0500
Received: by mail-pf1-f193.google.com with SMTP id b185so2477993pfb.7
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QddnNkr1vVqYuRjEL48Qvo04QhlAAJbX4SH4qus9k+M=;
        b=eK9SGTQY4kCTp3PSLGP3e+J5cf8mLUBp8Wn+gTXkzsV8D/qin5C6tyfDbRY0kcQZKm
         OJpdkaSjhRn3eVtuIg2ax5laq6mmKGwSjr+IudW8tm8DcwS/88jQ3hHgs+XnxwrNZrKE
         zz9fX370IYaactEJG0leWlt9BdwpAepEehywjw07oGNjKDUQo6wonXTbG9BeDQAXhvba
         tm9+7RrVb6YEi8HiqR7uZoetz2Y6EpV+eus//Sjy/C1yqVKhDEhPiP/eRh69YVGjzmrt
         EUBcET4nN5vrWSLYjpRQj5wGxR2iKmNKFKBgo2oNiEzJXlEHRPAvJDXnTksKfiOlEyj7
         Q4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QddnNkr1vVqYuRjEL48Qvo04QhlAAJbX4SH4qus9k+M=;
        b=hV7p1NacNZ4RhfPO33Q4WFlD/Q5HHdYWwVuhyJfgMrGOpHw0D+S/18VIra6jGS1oOg
         wRke1iHGhLbp8rfZDCry7o2zJQt5h8KHHb9O/hpmZPOL+V2h3Kqo3Pd7w40av2/cVKcd
         zq0bWdsDLkC0QZB2FBOnktUepy3NDLy1yt557sJdX2iL4HQovvT79rKNav/Nl9YLYFzW
         mc5voz8lHXGW6reVpCiKhixiTM3ymPtGgruYYDMVbqENFoJMgFxTkjABXMmMKm0qHLWu
         rkVwoxosZPkXbFzrhiMPy0PH4b8J8tEXJfHwKKGRefIXSCnh0Tfhq6M0SKIlW1g+41gs
         P5pw==
X-Gm-Message-State: APjAAAUZ5JHep2eNB8mUJkcZXbOtsF5bsPuOYUs80PoI1FIOuy9TMvob
        /boG3SECh0xsL26G90j6ohds3sFF3Wk=
X-Google-Smtp-Source: APXvYqykLnELTNRIZlvzr6FDetfpAzyuMc/DRNd8Ahg3kDkPEB9blrqS9lqVNGTOO5oswsYl2+V2Kg==
X-Received: by 2002:a62:7a8a:: with SMTP id v132mr35243864pfc.111.1582230719746;
        Thu, 20 Feb 2020 12:31:59 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:31:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] task_work_run: don't take ->pi_lock unconditionally
Date:   Thu, 20 Feb 2020 13:31:46 -0700
Message-Id: <20200220203151.18709-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
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

