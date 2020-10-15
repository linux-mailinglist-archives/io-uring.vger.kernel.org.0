Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD7028F4DD
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgJOOhl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:37:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbgJOOhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:37:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602772658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2NnXe8US68w47B/n+ATBEKZVToG6tvC8YC7ZXJhiqk=;
        b=PsKLfG47VgYEWXC1yhP3Ar1YHnbRUb7FSUslsUSzI8g53LGJ2FWDB32F1bfTWafc/tj1dc
        XJsQcyPDG/Re62nIJaAtMXWWjv+NnDy1NVpduc7zhsldTq1WaFfkzr1vo9JhA8acCI7Ywc
        a8bWryJ34CDGh7hQGEmH02m8DXN0sP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-oxlDBIKSPu6YCv0aY2NbxA-1; Thu, 15 Oct 2020 10:37:33 -0400
X-MC-Unique: oxlDBIKSPu6YCv0aY2NbxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D8DD3F10;
        Thu, 15 Oct 2020 14:37:32 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id F1C8076673;
        Thu, 15 Oct 2020 14:37:30 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:37:32 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:37:29 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201015143728.GE24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk>
 <20201015143151.GB24156@redhat.com>
 <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> On 10/15/20 8:31 AM, Oleg Nesterov wrote:
> > On 10/15, Jens Axboe wrote:
> >>
> >>  static inline int signal_pending(struct task_struct *p)
> >>  {
> >> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
> >> +	/*
> >> +	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
> >> +	 * behavior in terms of ensuring that we break out of wait loops
> >> +	 * so that notify signal callbacks can be processed.
> >> +	 */
> >> +	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
> >> +		return 1;
> >> +#endif
> >>  	return task_sigpending(p);
> >>  }
> > 
> > I don't understand why does this version requires CONFIG_GENERIC_ENTRY.
> > 
> > Afaics, it is very easy to change all the non-x86 arches to support
> > TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
> > kernel/entry/common.c ?
> 
> I think that Thomas wants to gate TIF_NOTIFY_SIGNAL on conversion to
> the generic entry code?

Then I think TIF_NOTIFY_SIGNAL will be never fully supported ;)

Oleg.

