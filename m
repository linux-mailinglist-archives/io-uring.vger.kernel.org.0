Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A692174037
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 20:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgB1TZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 14:25:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55858 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1TZN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 14:25:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LAuKY6zqbM2TrqBYj4tQFqdY+UjOOGrviBZCdWYyHrg=; b=kKKZ3Kj+69g5QiXKJNxTBp8Xus
        VkCs13rz6gSUY3NgNh14cyDGErr78cbfO1sHIlg/xz5branZO1PdtywjB+X980+A28yy1ETRGbYzq
        nLA1k9GhzyyVMox6zRN9H0+1JV2qxElxMExTtLKQfu1EY8Duw2OQnvFDYuV1Vsl81INb+WAEdRvXG
        VsE3Ob086zvMGBJsUK7vT8X2DBJlMVHhVyjLZtq8CNY6CtGJ2Z3qzEXvj6uOlb0PAyBHCaeCjj++0
        qpAUhSm6Q4LSGU50h+QX4WRBbcts5AXhq/2BY1Na8OLJYllBX8F5sqLJI9jaBg6yG6g3kBqqESpyL
        NtNTfBlw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j7lFy-0003cL-VI; Fri, 28 Feb 2020 19:25:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DE3D3300478;
        Fri, 28 Feb 2020 20:23:08 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 13550209E76B5; Fri, 28 Feb 2020 20:25:05 +0100 (CET)
Date:   Fri, 28 Feb 2020 20:25:05 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200228192505.GO18400@hirez.programming.kicks-ass.net>
References: <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
 <20200220172201.GC27143@redhat.com>
 <20200220174932.GB18400@hirez.programming.kicks-ass.net>
 <20200221145256.GA16646@redhat.com>
 <77349a8d-ecbf-088d-3a48-321f68f1774f@kernel.dk>
 <de55c2ac-bc94-14d8-68b1-b2a9c0cb7428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de55c2ac-bc94-14d8-68b1-b2a9c0cb7428@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 28, 2020 at 12:17:58PM -0700, Jens Axboe wrote:
> > 
> > Peter/Oleg, as you've probably noticed, I'm still hauling Oleg's
> > original patch around. Is the above going to turn into a separate patch
> > on top?  If so, feel free to shove it my way as well for some extra
> > testing.
> 
> Peter/Oleg, gentle ping on this query. I'd like to queue up the task poll
> rework on the io_uring side, but I still have this one at the start of
> the series:

the generic try_cmpxchg crud I posted earlier is 'wrong' and the sane
version I cooked up depends on a whole bunch of patches that are in
limbo because of kcsan (I need to get that resolved one way or the
other).

So if you don't mind, I'll shelf this for a while until I got all that
sorted.

