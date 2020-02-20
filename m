Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 841BF165BB8
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 11:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBTKjk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 05:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:41396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgBTKjk (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 20 Feb 2020 05:39:40 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A6A024654;
        Thu, 20 Feb 2020 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582195179;
        bh=pmMeD3J462Ed0GYqNb2rQ5J4xvML9edU/W6pE3Ujv+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r2TguAywdipbP4Jz7R2+hYm5KCmvFxe6y2myDGF6Ly85bnkYnJ2RBOu/JShHg40H6
         Y7+nGQtLziSEWGYsNsfwRKeIGf7MBpN1PbeOiZH5NOIQWRZbe3dcABDtO38TyWpri4
         jun2dHMx/RapBMJqjfnwRk7B14rA3jg0AoEn5cco=
Date:   Thu, 20 Feb 2020 10:39:35 +0000
From:   Will Deacon <will@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/atomic: Add try_cmpxchg() fallbacks
Message-ID: <20200220103934.GA14459@willie-the-truck>
References: <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218142700.GB14946@hirez.programming.kicks-ass.net>
 <20200220103044.GA13608@willie-the-truck>
 <20200220103727.GW18400@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220103727.GW18400@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 11:37:27AM +0100, Peter Zijlstra wrote:
> On Thu, Feb 20, 2020 at 10:30:45AM +0000, Will Deacon wrote:
> > On Tue, Feb 18, 2020 at 03:27:00PM +0100, Peter Zijlstra wrote:
> > > diff --git a/scripts/atomic/gen-atomic-fallback.sh b/scripts/atomic/gen-atomic-fallback.sh
> > > index b6c6f5d306a7..3c9be8d550e0 100755
> > > --- a/scripts/atomic/gen-atomic-fallback.sh
> > > +++ b/scripts/atomic/gen-atomic-fallback.sh
> > > @@ -140,6 +140,32 @@ cat <<EOF
> > >  EOF
> > >  }
> > >  
> > > +gen_try_cmpxchg_fallback()
> > > +{
> > > +	local order="$1"; shift;
> > > +
> > > +cat <<EOF
> > > +#ifndef try_cmpxchg${order}
> > > +#define try_cmpxchg${order}(_ptr, _oldp, _new) \\
> > > +({ \\
> > > +	typeof(*ptr) ___r, ___o = *(_oldp); \\
> > > +	___r = cmpxchg${order}((_ptr), ___o, (_new)); \\
> > > +	if (unlikely(___r != ___o)) \\
> > > +		*(_old) = ___r; \\
> > 
> > This doesn't compile because _old isn't declared. Probably best to avoid
> > evaluating _oldp twice though.
> 
> Compiler had already spotted that, I'll make it something like:
> 
> 	typeof(*ptr) *___op = (_oldp), ___o = *___op;
> 
> 	...
> 
> 		*___op = ___r;
> 
> Which avoids the double eval.

Cool, you can stick my Ack on the patch with that change.

Will
