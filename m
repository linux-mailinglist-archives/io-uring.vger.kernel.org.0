Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530852874A1
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 14:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgJHM6m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 08:58:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27778 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729722AbgJHM6m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 08:58:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602161921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E/evyHUMI3fb2U+XwW2aLhJew6d+OCSc2FxwNfQU9Ew=;
        b=gsdm6G5IKhu4OWOIOEb3+Z00WguVw6Tm9UHJO8FVO352mtinXXw1ftgSqBp/ZUr9DLS6v0
        JD3AhGW6P0lIONP6ejOpJpAGkyHMpNDZxAwnJqQKeNkXrhHzvCye+M/VlWlyKnPd1Y4NH/
        EvqLAqPm0759nkEeuqqpHPGwDCRoj1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-A4_CbhkhMPqT2czSDz7rHQ-1; Thu, 08 Oct 2020 08:58:36 -0400
X-MC-Unique: A4_CbhkhMPqT2czSDz7rHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5FFA10BBEC2;
        Thu,  8 Oct 2020 12:58:34 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.132])
        by smtp.corp.redhat.com (Postfix) with SMTP id 54ABC6EF4A;
        Thu,  8 Oct 2020 12:58:33 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  8 Oct 2020 14:58:34 +0200 (CEST)
Date:   Thu, 8 Oct 2020 14:58:32 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 2/6] kernel: add task_sigpending() helper
Message-ID: <20201008125831.GE9995@redhat.com>
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201005150438.6628-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005150438.6628-3-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/05, Jens Axboe wrote:
>
>  static inline int signal_pending_state(long state, struct task_struct *p)
>  {
>  	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
>  		return 0;
> -	if (!signal_pending(p))
> +	if (!task_sigpending(p))
>  		return 0;

This looks obviously wrong. Say, schedule() in TASK_INTERRUPTIBLE should
not block if TIF_NOTIFY_SIGNAL is set.

With this change set_notify_signal() will not force the task to return
from wait_event_interruptible, mutex_lock_interruptible, etc.

>  	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
> @@ -389,7 +394,7 @@ static inline bool fault_signal_pending(vm_fault_t fault_flags,
>  {
>  	return unlikely((fault_flags & VM_FAULT_RETRY) &&
>  			(fatal_signal_pending(current) ||
> -			 (user_mode(regs) && signal_pending(current))));
> +			 (user_mode(regs) && task_sigpending(current))));

This looks unnecessary,

> @@ -773,7 +773,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
>  		data += sizeof(siginfo_t);
>  		i++;
>  
> -		if (signal_pending(current))
> +		if (task_sigpending(current))

This too.

IMO, this patch should do s/signal_pending/task_sigpending/ only if it is
strictly needed for correctness.

Oleg.

