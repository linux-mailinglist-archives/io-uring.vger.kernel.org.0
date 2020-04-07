Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1227F1A11A8
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 18:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgDGQiY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 12:38:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45406 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726883AbgDGQiY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 12:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586277503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYT6gMeXGMvW4EOKHt3GqBDCT+TCWiqWAwUIDekFCD8=;
        b=bncDPGWkd96NGqG+In3H9HpcYJ/iMg4m5+QrPLdIMUsAA8BLUtNnTdRrhznhPEpIZhHyve
        I8ZrUI4SHTcdMieRGKgd800sKzX+74zRo0Uefhour239va6IjH6xQ4vI7nZXWmxjxTUi/Z
        s2SoQRGznq+4Jhx3cxSr3McvTf/f2R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-ltb98TbPN7aZOrplWXjKHA-1; Tue, 07 Apr 2020 12:38:21 -0400
X-MC-Unique: ltb98TbPN7aZOrplWXjKHA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0033A18FE877;
        Tue,  7 Apr 2020 16:38:20 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.40])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9CDEE5E030;
        Tue,  7 Apr 2020 16:38:18 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  7 Apr 2020 18:38:19 +0200 (CEST)
Date:   Tue, 7 Apr 2020 18:38:17 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
Message-ID: <20200407163816.GB9655@redhat.com>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk>
 <20200407162405.GA9655@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407162405.GA9655@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/07, Oleg Nesterov wrote:
>
> On 04/07, Jens Axboe wrote:
> >
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -7293,10 +7293,15 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
> >  		io_wq_cancel_all(ctx->io_wq);
> >
> >  	io_iopoll_reap_events(ctx);
> > +	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
> > +
> > +	if (current->task_works != &task_work_exited)
> > +		task_work_run();
>
> this is still wrong, please see the email I sent a minute ago.

Let me try to explain in case it was not clear. Lets forget about io_uring.

	void bad_work_func(struct callback_head *cb)
	{
		task_work_run();
	}

	...

	init_task_work(&my_work, bad_work_func);

	task_work_add(task, &my_work);

If the "task" above is exiting the kernel will crash; because the 2nd
task_work_run() called by bad_work_func() will install work_exited, then
we return to task_work_run() which was called by exit_task_work(), it will
notice ->task_works != NULL, restart the main loop, and execute
work_exited->fn == NULL.

Again, if we want to allow task_work_run() in do_exit() paths we need
something like below. But still do not understand why do we need this :/

Oleg.


diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index bd9a6a91c097..c9f36d233c39 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -15,11 +15,16 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 
 int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
-void task_work_run(void);
+void __task_work_run(void);
+
+static inline void task_work_run(void)
+{
+	__task_work_run(false);
+}
 
 static inline void exit_task_work(struct task_struct *task)
 {
-	task_work_run();
+	__task_work_run(true);
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 825f28259a19..7b26203a583e 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -87,7 +87,7 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
  * it exits. In the latter case task_work_add() can no longer add the
  * new work after task_work_run() returns.
  */
-void task_work_run(void)
+void __task_work_run(bool is_exit)
 {
 	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
@@ -101,7 +101,7 @@ void task_work_run(void)
 			head = NULL;
 			work = READ_ONCE(task->task_works);
 			if (!work) {
-				if (task->flags & PF_EXITING)
+				if (is_exit)
 					head = &work_exited;
 				else
 					break;

