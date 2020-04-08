Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9521A28C5
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 20:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgDHSk4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 14:40:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53425 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728280AbgDHSk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 14:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586371254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3XXGEPaN2jmaUz/XVCnamEsRloXus9CKAfl94A3Wa6U=;
        b=ObplXyrHfjtZ+fRofgmgLMz+4T2Lr3kwXYT2N2CC7SutZzpaGgMfuCncOrGB/y3iSNANkC
        LWjlnT0vQaj1SlEh/jQiBABetuxgLj+K8qirNWlurNP7BJskbbXJ2til03kICYHfxDrYit
        u+z/acXPrYoKB3rJFm/55aP4MFKjJp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-u6n-ULtnOLqNx2R473IAsw-1; Wed, 08 Apr 2020 14:40:53 -0400
X-MC-Unique: u6n-ULtnOLqNx2R473IAsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9B3CDB21;
        Wed,  8 Apr 2020 18:40:51 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.143])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8B5425D9CA;
        Wed,  8 Apr 2020 18:40:50 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Wed,  8 Apr 2020 20:40:51 +0200 (CEST)
Date:   Wed, 8 Apr 2020 20:40:49 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/4] io_uring: flush task work before waiting for ring
 exit
Message-ID: <20200408184049.GA25918@redhat.com>
References: <20200407160258.933-1-axboe@kernel.dk>
 <20200407160258.933-5-axboe@kernel.dk>
 <20200407162405.GA9655@redhat.com>
 <20200407163816.GB9655@redhat.com>
 <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b70317a-d12a-6c29-1d7f-1394527f9676@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens, I am sorry. I tried to understand your explanations but I can't :/
Just in case, I know nothing about io_uring.

However, I strongly believe that

	- the "task_work_exited" check in 4/4 can't help, the kernel
	  will crash anyway if a task-work callback runs with
	  current->task_works == &task_work_exited.

	- this check is not needed with the patch I sent.
	  UNLESS io_ring_ctx_wait_and_kill() can be called by the exiting
	  task AFTER it passes exit_task_work(), but I don't see how this
	  is possible.

Lets forget this problem, lets assume that task_work_run() is always safe.

I still can not understand why io_ring_ctx_wait_and_kill() needs to call
task_work_run().

On 04/07, Jens Axboe wrote:
>
> io_uring exit removes the pending poll requests, but what if (for non
> exit invocation), we get poll requests completing before they are torn
> down. Now we have task_work queued up that won't get run,
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

this must not be possible. If task_work is queued it will run, or we
have another bug.

> because we
> are are in the task_work handler for the __fput().

this doesn't matter...

> For this case, we
> need to run the task work.

This is what I fail to understand :/

Oleg.

