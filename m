Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD893344A9E
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 17:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhCVQIA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 12:08:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231962AbhCVQGI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 12:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616429167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ec8d/wZGIiP5v9f9Rnr6sraA6fQi+3nyuv/NY+0KgeM=;
        b=Biz9zr9OsbJ7FoWBUT3AljVwAxzxLdjX/x3sd5OFjgqAq5po6SyYDGDTFdsAnOZpPe2P7Z
        F6LH/k2lAQerXW345XhWeli2fEq3vTE8H0w6BkwbOra2N8A77zDoScABckqhRGDEKbedHZ
        jDupwT50IxUKLuzX28U+69zAUKfJ2OA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-34MmzV0GPoGuqJ60GrcW8w-1; Mon, 22 Mar 2021 12:06:04 -0400
X-MC-Unique: 34MmzV0GPoGuqJ60GrcW8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90854107B7C3;
        Mon, 22 Mar 2021 16:06:02 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.194.114])
        by smtp.corp.redhat.com (Postfix) with SMTP id EE89819C78;
        Mon, 22 Mar 2021 16:06:00 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Mon, 22 Mar 2021 17:06:02 +0100 (CET)
Date:   Mon, 22 Mar 2021 17:05:59 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 0/2] PF_IO_WORKER signal tweaks
Message-ID: <20210322160558.GA20390@redhat.com>
References: <20210320153832.1033687-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320153832.1033687-1-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/20, Jens Axboe wrote:
>
> Hi,
>
> Been trying to ensure that we do the right thing wrt signals and
> PF_IO_WORKER threads

OMG. Am I understand correctly? create_io_thread() can create a sub-
thread of userspace process which acts as a kernel thread?

Looks like this is the recent feature I wasn't aware... Can't really
comment right now, just some random and possibly wrong notes.

> 1) Just don't allow signals to them in general. We do mask everything
>    as blocked, outside of SIGKILL, so things like wants_signal() will
>    never return true for them.

This only means that signal_wake_up() won't be called. But the signal
will be queued if sent via tkill/etc, I don't think this is what we want?

A PF_IO_WORKER thread should ignore the signals. But it seems that the
PF_IO_WORKER check in sig_task_ignored() makes no sense and can't help.
I don't think PF_IO_WORKER && SIG_KTHREAD_KERNEL is possible.

Not to mention that sig_ignored() won't even call sig_task_ignored(),
it will return false exactly because the signal is blocked.

Confused.

Plus the the setting of tsk->blocked in create_io_thread() looks racy,
signal_pending() can be already true. And in fact it can't really help,
calculate_sigpending() can set TIF_SIGPENDING after wake_up_new_task()
anyway.

And why does create_io_thread() use lower_32_bits() ? This looks very
confusing. This

	.exit_signal    = (lower_32_bits(flags) & CSIGNAL);

too. Firstly, the rhs is always zero, secondly it is ignored because
of CLONE_THREAD.


ptrace_attach() checks PF_IO_WORKER too. Yes, but 'gdb -p' will try
to attach to every thread /proc/pid/tasks, so it will probably just
hang?

Oleg.

