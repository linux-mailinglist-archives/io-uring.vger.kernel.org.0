Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487D2165BAC
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 11:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBTKhg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 05:37:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55592 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgBTKhg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 05:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wTU5l9FvaA2rRfBZg5Cv1qrtrncw1gjr41DJZ8a0ehs=; b=cW0vjpFh5KhHj4GcOsfAMPLZtI
        PPF2znrUvqek0EerLMwl3kva1X/c+EfmuCOnhciWLM4SOWT3mHRSvz2obQQnzb+HedsfXrdTMYVSO
        jBA3usm2fqTlB0zQlopm6SbjQoVhPXgvpWmPbflb22C9v4N3RLODfbLty+r7V/Nsc4mcJ3gPhnCSt
        K2ErnrU1NYL4P7WnROyXd03R2WkrSPKH9D2V9ddRm91EBm/ffkNWDQEvEWyWPfn6syQ9INL8p8/Gn
        syLFB+/Lj6blPxk6Y9lg2wKXZds8YY/kixj8lXVAdih9BRxe4X6cnWxbL/CQ8I9dHPqRMCGGNnzrm
        21wLu5Mg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4jCz-0002XD-Bo; Thu, 20 Feb 2020 10:37:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7FF0C30008D;
        Thu, 20 Feb 2020 11:35:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2DAE02B47417C; Thu, 20 Feb 2020 11:37:27 +0100 (CET)
Date:   Thu, 20 Feb 2020 11:37:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Will Deacon <will@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/atomic: Add try_cmpxchg() fallbacks
Message-ID: <20200220103727.GW18400@hirez.programming.kicks-ass.net>
References: <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218142700.GB14946@hirez.programming.kicks-ass.net>
 <20200220103044.GA13608@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220103044.GA13608@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 10:30:45AM +0000, Will Deacon wrote:
> On Tue, Feb 18, 2020 at 03:27:00PM +0100, Peter Zijlstra wrote:
> > On Tue, Feb 18, 2020 at 02:13:10PM +0100, Peter Zijlstra wrote:
> > > (with the caveat that try_cmpxchg() doesn't seem available on !x86 -- I
> > > should go fix that)
> > 
> > Completely untested (lemme go do that shortly), but something like so I
> > suppose.
> > 
> > ---
> > Subject: asm-generic/atomic: Add try_cmpxchg() fallbacks
> > 
> > Only x86 provides try_cmpxchg() outside of the atomic_t interfaces,
> > provide generic fallbacks to create this interface from the widely
> > available cmpxchg() function.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> > diff --git a/include/linux/atomic-fallback.h b/include/linux/atomic-fallback.h
> > index 656b5489b673..243f61d6c35f 100644
> > --- a/include/linux/atomic-fallback.h
> > +++ b/include/linux/atomic-fallback.h
> > @@ -77,6 +77,50 @@
> >  
> >  #endif /* cmpxchg64_relaxed */
> >  
> > +#ifndef try_cmpxchg
> > +#define try_cmpxchg(_ptr, _oldp, _new) \
> > +({ \
> > +	typeof(*ptr) ___r, ___o = *(_oldp); \
> 
> Probably worth pointing out that this will have the nasty behaviour
> for volatile pointers that we're tackling for READ_ONCE. Obviously no
> need to hold this up, but just mentioning it here in the hope that one
> of us remembers to fix it later on.

Right :/

> > diff --git a/scripts/atomic/gen-atomic-fallback.sh b/scripts/atomic/gen-atomic-fallback.sh
> > index b6c6f5d306a7..3c9be8d550e0 100755
> > --- a/scripts/atomic/gen-atomic-fallback.sh
> > +++ b/scripts/atomic/gen-atomic-fallback.sh
> > @@ -140,6 +140,32 @@ cat <<EOF
> >  EOF
> >  }
> >  
> > +gen_try_cmpxchg_fallback()
> > +{
> > +	local order="$1"; shift;
> > +
> > +cat <<EOF
> > +#ifndef try_cmpxchg${order}
> > +#define try_cmpxchg${order}(_ptr, _oldp, _new) \\
> > +({ \\
> > +	typeof(*ptr) ___r, ___o = *(_oldp); \\
> > +	___r = cmpxchg${order}((_ptr), ___o, (_new)); \\
> > +	if (unlikely(___r != ___o)) \\
> > +		*(_old) = ___r; \\
> 
> This doesn't compile because _old isn't declared. Probably best to avoid
> evaluating _oldp twice though.

Compiler had already spotted that, I'll make it something like:

	typeof(*ptr) *___op = (_oldp), ___o = *___op;

	...

		*___op = ___r;

Which avoids the double eval.
