Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FA42803EB
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 18:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbgJAQ13 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 12:27:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732046AbgJAQ13 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 12:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601569648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WpyfW6uB/uLX11MkTOm4JRQtX6e9GzHMT50ADwTIIHk=;
        b=NYWL3ujdIOROWaip1KgAdRCMNP29E3ylff2ddZF3o7PGcbp9PRS/YRyFfsLb+80TTcz/t0
        Li/AexIcUWPP6EsmY7gb1cDRModpuEwz99qUK4QBzgdMaYfvigjoFXrnmxkzCOXUOf88V3
        uU/CS3Y5pRbEBG82+vAUWUfmYO7REV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-m49T-GglN5m-W8mAaGTrZA-1; Thu, 01 Oct 2020 12:27:24 -0400
X-MC-Unique: m49T-GglN5m-W8mAaGTrZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 320951DE0E;
        Thu,  1 Oct 2020 16:27:23 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.152])
        by smtp.corp.redhat.com (Postfix) with SMTP id B56BD60BF1;
        Thu,  1 Oct 2020 16:27:21 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  1 Oct 2020 18:27:22 +0200 (CEST)
Date:   Thu, 1 Oct 2020 18:27:20 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC v2] kernel: decouple TASK_WORK TWA_SIGNAL handling
 from signals
Message-ID: <20201001162719.GD13633@redhat.com>
References: <3ce9e205-aad0-c9ce-86a7-b281f1c0237a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ce9e205-aad0-c9ce-86a7-b281f1c0237a@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens,

I'll read this version tomorrow, but:

On 10/01, Jens Axboe wrote:
>
>  static inline int signal_pending(struct task_struct *p)
>  {
> -	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
> +#ifdef TIF_TASKWORK
> +	/*
> +	 * TIF_TASKWORK isn't really a signal, but it requires the same
> +	 * behavior of restarting the system call to force a kernel/user
> +	 * transition.
> +	 */
> +	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING) ||
> +			test_tsk_thread_flag(p, TIF_TASKWORK));
> +#else
> +	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING));
> +#endif

This change alone is already very wrong.

signal_pending(task) == T means that this task will do get_signal() as
soon as it can, and this basically means you can't "divorce" SIGPENDING
and TASKWORK.

Simple example. Suppose we have a single-threaded task T.

Someone does task_work_add(T, TWA_SIGNAL). This makes signal_pending()==T
and this is what we need.

Now suppose that another task sends a signal to T before T calls
task_work_run() and clears TIF_TASKWORK. In this case SIGPENDING won't
be set because signal_pending() is already set (see wants_signal), and
this means that T won't notice this signal.

Oleg.

