Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1AE11A8C0
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2019 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfLKKUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Dec 2019 05:20:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbfLKKUS (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 11 Dec 2019 05:20:18 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13D242073D;
        Wed, 11 Dec 2019 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576059618;
        bh=O+3eMpqI5CO1UXPbGnfhx85O+OAQ9gV4iGlHQuOSc1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mZ7aVL3XlBYy1i0d7UzLhPkV8xhNm3b5UdW6zxuceKpYFnBvaMjDJbGu6aX0DfPUv
         Cb3BMtB4gvOxp3V8UYcLYzvurFEoGOc+1a0KC5NksAcpZE5MFCu/s44KTXHCtlhhIy
         jr0YazMhteigBQ2i7jdwm29bcjm1h2wzaza1BFDA=
Date:   Wed, 11 Dec 2019 10:20:13 +0000
From:   Will Deacon <will@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
        io-uring <io-uring@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
Message-ID: <20191211102012.GA4123@willie-the-truck>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
 <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
 <201912101445.CF208B717@keescook>
 <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6ff9af3-5e72-329c-4aed-cbe6d9373235@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 10, 2019 at 03:55:05PM -0700, Jens Axboe wrote:
> On 12/10/19 3:46 PM, Kees Cook wrote:
> > On Tue, Dec 10, 2019 at 03:21:04PM -0700, Jens Axboe wrote:
> >> On 12/10/19 3:04 PM, Jann Horn wrote:
> >>> [context preserved for additional CCs]
> >>>
> >>> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> Recently had a regression that turned out to be because
> >>>> CONFIG_REFCOUNT_FULL was set.
> >>>
> >>> I assume "regression" here refers to a performance regression? Do you
> >>> have more concrete numbers on this? Is one of the refcounting calls
> >>> particularly problematic compared to the others?
> >>
> >> Yes, a performance regression. io_uring is using io-wq now, which does
> >> an extra get/put on the work item to make it safe against async cancel.
> >> That get/put translates into a refcount_inc and refcount_dec per work
> >> item, and meant that we went from 0.5% refcount CPU in the test case to
> >> 1.5%. That's a pretty substantial increase.
> >>
> >>> I really don't like it when raw atomic_t is used for refcounting
> >>> purposes - not only because that gets rid of the overflow checks, but
> >>> also because it is less clear semantically.
> >>
> >> Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
> >> could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
> >> that's what I should do. But I'd prefer to just drop the refcount on the
> >> io_uring side and keep it on for other potential useful cases.
> > 
> > There is no CONFIG_REFCOUNT_FULL any more. Will Deacon's version came
> > out as nearly identical to the x86 asm version. Can you share the
> > workload where you saw this? We really don't want to regression refcount
> > protections, especially in the face of new APIs.
> > 
> > Will, do you have a moment to dig into this?
> 
> Ah, hopefully it'll work out ok, then. The patch came from testing the
> full backport on 5.2.
> 
> Do you have a link to the "nearly identical"? I can backport that
> patch and try on 5.2.

You could try my refcount/full branch, which is what ended up getting merged
during the merge window:

https://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git/log/?h=refcount/full

Will
