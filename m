Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA9A28F5CE
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 17:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbgJOP1P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 11:27:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389226AbgJOP1P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 11:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602775634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TG2AUrfxhLY/L3sbUtf1bcZcGZTtMmaOPuFCfyv4d/g=;
        b=Cf0JTtnjRX/JUNdJ3m/MXzpk7AXLnnq8FTTBxci+s6YcP8EmS9lHrl8sW65cgEYISjrVn7
        DIUFFDCCHEHibx265KsiSJvY0Sf+gyQmknZWF986Uv1nKGohu/4eNsSOsr7tkXvFnOFPOU
        5RorA3i+mwLnbYx70w+BIiU+vGrSpdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-OmhcBhRnMLCAHN0wX7eWAg-1; Thu, 15 Oct 2020 11:27:12 -0400
X-MC-Unique: OmhcBhRnMLCAHN0wX7eWAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E74451084D85;
        Thu, 15 Oct 2020 15:27:10 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.193.8])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7D43C6EF54;
        Thu, 15 Oct 2020 15:27:09 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 15 Oct 2020 17:27:10 +0200 (CEST)
Date:   Thu, 15 Oct 2020 17:27:08 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Message-ID: <20201015152707.GL24156@redhat.com>
References: <20201015131701.511523-1-axboe@kernel.dk>
 <20201015131701.511523-4-axboe@kernel.dk>
 <20201015143151.GB24156@redhat.com>
 <5d231aa1-b8c7-ae4e-90bb-211f82b57547@kernel.dk>
 <20201015143728.GE24156@redhat.com>
 <87r1pzv8hy.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1pzv8hy.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/15, Thomas Gleixner wrote:
>
> On Thu, Oct 15 2020 at 16:37, Oleg Nesterov wrote:
> > On 10/15, Jens Axboe wrote:
> >> On 10/15/20 8:31 AM, Oleg Nesterov wrote:
> >> > I don't understand why does this version requires CONFIG_GENERIC_ENTRY.
> >> >
> >> > Afaics, it is very easy to change all the non-x86 arches to support
> >> > TIF_NOTIFY_SIGNAL, but it is not trivial to change them all to use
> >> > kernel/entry/common.c ?
> >>
> >> I think that Thomas wants to gate TIF_NOTIFY_SIGNAL on conversion to
> >> the generic entry code?
> >
> > Then I think TIF_NOTIFY_SIGNAL will be never fully supported ;)
>
> Yeah, we proliferate crap on that basis forever. _ALL_ architectures
> have the very same entry/exit ordering problems (or subsets and
> different ones) which we fixed on x86.
>
> So no, we don't want to have 24 different variants of the same thing
> again. That's what common code is for.
>
> Not doing that is making the life of everyone working on core
> infrastructure pointlessly harder. Architecture people still have enough
> ways to screw everyone up.

Sure, it would be nice to change them all to use kernel/entry/common.c.

Until then (until never), how can we kill JOBCTL_TASK_WORK ?

How can we remove freezing/klp_patch_pending from recalc_sigpending() ?

Oleg.

