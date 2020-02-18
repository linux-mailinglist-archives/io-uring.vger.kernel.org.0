Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5139B1629D1
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBRPu0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 10:50:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726399AbgBRPu0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 10:50:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582041025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bZ3IC5jCHDU4qtDgLH9wB8emAAfZApU1NcKXs0Pg7PQ=;
        b=KYola16cyUlDrZ/geDNvILBrMyEhUEXtNzm6G1c9f6YFE1olQ556lyDK24DYyHkxKB4Hww
        OtoFK6J5nD+LK2/4zD0NGeJH2TskwefKLzj7uOL/8D6CuzvLLFb31/5UBrt9paEs1yoHmc
        vyoMSItbRhBvWAHr1PvxIT5Lp6Gjo5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-GbSHHSbqNzaBlysYcKVI6g-1; Tue, 18 Feb 2020 10:50:21 -0500
X-MC-Unique: GbSHHSbqNzaBlysYcKVI6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7893F1005F86;
        Tue, 18 Feb 2020 15:50:20 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 13F6890F65;
        Tue, 18 Feb 2020 15:50:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 18 Feb 2020 16:50:20 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:50:18 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200218155017.GD3466@redhat.com>
References: <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218150756.GC14914@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As Peter pointed out, task_work() can avoid ->pi_lock and cmpxchg()
if task->task_works == NULL && !PF_EXITING.

And in fact the only reason why task_work_run() needs ->pi_lock is
the possible race with task_work_cancel(), we can optimize this code
and make the locking more clear.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/task_work.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0fef395..825f282 100644
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
2.5.0


