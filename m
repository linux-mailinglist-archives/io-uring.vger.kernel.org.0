Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290831A0D17
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 13:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgDGLy3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 07:54:29 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20306 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726562AbgDGLy3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 07:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586260468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=et3zCqB0E1hcw15aKztJyuVcB59NERyG2SoCCOuTaRg=;
        b=Szv5ioe5Y6ZMfGElxTZnJCy87XUVGItVaYbOmTKjWzAzfjROmiPJIx/UutONe4nBENEKLZ
        WBbC+J58O/IFtTd3QIV5QpbsT6pJ/MzekVWiXQ2lNyv4IDeCVyhEVHiLk2sMTUfyaftaff
        MDM1BwB9AFNa3BHNRQiEacwPXhTgG+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-C0Ps29etOIKitNIMv1KjHw-1; Tue, 07 Apr 2020 07:54:27 -0400
X-MC-Unique: C0Ps29etOIKitNIMv1KjHw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0082413F7;
        Tue,  7 Apr 2020 11:54:26 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.196.88])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9D7E69D37A;
        Tue,  7 Apr 2020 11:54:24 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue,  7 Apr 2020 13:54:25 +0200 (CEST)
Date:   Tue, 7 Apr 2020 13:54:23 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited
 is queued
Message-ID: <20200407115423.GC4506@redhat.com>
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk>
 <20200407113927.GB4506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407113927.GB4506@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/07, Oleg Nesterov wrote:
>
> On 04/06, Jens Axboe wrote:
> >
> > +extern struct callback_head task_work_exited;
> > +
> >  static inline void
> >  init_task_work(struct callback_head *twork, task_work_func_t func)
> >  {
> > @@ -19,7 +21,7 @@ void __task_work_run(void);
> >
> >  static inline bool task_work_pending(void)
> >  {
> > -	return current->task_works;
> > +	return current->task_works && current->task_works != &task_work_exited;
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Well, this penalizes all the current users, they can't hit work_exited.
>
> IIUC, this is needed for the next change which adds task_work_run() into
> io_ring_ctx_wait_and_kill(), right?
>
> could you explain how the exiting can call io_ring_ctx_wait_and_kill()
> after it passed exit_task_work() ?

Note also that currently we assume that task_work_run() must not be called
by the exiting process (except exit_task_work). If io_ring adds the precedent
we need change the PF_EXITING logic in task_work_run().

Oleg.

