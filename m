Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702C528F52E
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389258AbgJOOrZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 10:47:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389384AbgJOOrV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 10:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602773240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fzjpDAV5F3Ar6lYBMyYyeWD2zEgRpW1GmqDCDHO9pf0=;
        b=TCrc40N7RXFM23vA4Tb7GV1tV75OEB2bRuBnR1pyggSdi/c/zeEhAptJZ09vAUSrlWFBRd
        eSXbUcK1QhviyPLw+yKeyE83y/guQoMhv0IFFefcFvfCcc6UGNCqGu+e6C7AmVfqRXHNKj
        CP/TNrV++SgLYScrj+0COWutmDDK/+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-4lWrHLouM0WfDg-0bt7_VQ-1; Thu, 15 Oct 2020 10:47:18 -0400
X-MC-Unique: 4lWrHLouM0WfDg-0bt7_VQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2673086ABDB;
        Thu, 15 Oct 2020 14:47:17 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 77FB475125;
        Thu, 15 Oct 2020 14:47:15 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 16:47:16 +0200 (CEST)
Date:   Thu, 15 Oct 2020 16:47:14 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201015144713.GJ24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk>
 <20201015143151.GB24156@redhat.com>
 <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
 <20201015143728.GE24156@redhat.com>
 <788b31b7-6acc-cc85-5e91-d0c2538341b7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <788b31b7-6acc-cc85-5e91-d0c2538341b7@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Jens Axboe wrote:
>
> On 10/15/20 8:37 AM, Oleg Nesterov wrote:
> > On 10/15, Jens Axboe wrote:
> >>
> >> On 10/15/20 8:31 AM, Oleg Nesterov wrote:
> >>> On 10/15, Jens Axboe wrote:
> >>>>
> >>>>  static inline int signal_pending(struct task_struct *p)
> >>>>  {
> >>>> +#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
> >>>> +	/*
> >>>> +	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
> >>>> +	 * behavior in terms of ensuring that we break out of wait loops
> >>>> +	 * so that notify signal callbacks can be processed.
> >>>> +	 */
> >>>> +	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
> >>>> +		return 1;
> >>>> +#endif
> >>>>  	return task_sigpending(p);
> >>>>  }
> >>>
> >>> I don't understand why does this version requires CONFIG_GENERIC_ENTRY.
> >>>
> >>> Afaics, it is very easy to change all the non-x86 arches to support
> >>> TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
> >>> kernel/entry/common.c ?
> >>
> >> I think that Thomas wants to gate TIF_NOTIFY_SIGNAL on conversion to
> >> the generic entry code?
> > 
> > Then I think TIF_NOTIFY_SIGNAL will be never fully supported ;)
> 
> That is indeed a worry. From a functionality point of view, with the
> major archs supporting it, I'm not too worried about that side. But it
> does mean that we'll be stuck with the ifdeffery forever, which isn't
> great.

plus we can't kill the ugly JOBCTL_TASK_WORK.

Oleg.

