Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F2A165B8A
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 11:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgBTKav (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 05:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgBTKau (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 20 Feb 2020 05:30:50 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03EB24672;
        Thu, 20 Feb 2020 10:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582194650;
        bh=uWiTS8YgHPdo3MANnuhWHXoq+v/QRNnUmDA8sfhf8Bk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RbCX7TQv3skc2aoG9+L6JIaQJnX2npmUZ93js6YaP63bVUSIDSySPmRrCugANIO42
         qVsWcpQ8PWkjcLRzJAQp3NoUEnVEYDYLmzdY2G+7m/ipJJqJb26g4N04KVDR0h2rgS
         RtaaVKotVzuJB0D2J344nJa3ZP3ZiZw1HGdYZ3gg=
Date:   Thu, 20 Feb 2020 10:30:45 +0000
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
Message-ID: <20200220103044.GA13608@willie-the-truck>
References: <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218142700.GB14946@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218142700.GB14946@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 18, 2020 at 03:27:00PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 18, 2020 at 02:13:10PM +0100, Peter Zijlstra wrote:
> > (with the caveat that try_cmpxchg() doesn't seem available on !x86 -- I
> > should go fix that)
> 
> Completely untested (lemme go do that shortly), but something like so I
> suppose.
> 
> ---
> Subject: asm-generic/atomic: Add try_cmpxchg() fallbacks
> 
> Only x86 provides try_cmpxchg() outside of the atomic_t interfaces,
> provide generic fallbacks to create this interface from the widely
> available cmpxchg() function.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
> diff --git a/include/linux/atomic-fallback.h b/include/linux/atomic-fallback.h
> index 656b5489b673..243f61d6c35f 100644
> --- a/include/linux/atomic-fallback.h
> +++ b/include/linux/atomic-fallback.h
> @@ -77,6 +77,50 @@
>  
>  #endif /* cmpxchg64_relaxed */
>  
> +#ifndef try_cmpxchg
> +#define try_cmpxchg(_ptr, _oldp, _new) \
> +({ \
> +	typeof(*ptr) ___r, ___o = *(_oldp); \

Probably worth pointing out that this will have the nasty behaviour
for volatile pointers that we're tackling for READ_ONCE. Obviously no
need to hold this up, but just mentioning it here in the hope that one
of us remembers to fix it later on.

> diff --git a/scripts/atomic/gen-atomic-fallback.sh b/scripts/atomic/gen-atomic-fallback.sh
> index b6c6f5d306a7..3c9be8d550e0 100755
> --- a/scripts/atomic/gen-atomic-fallback.sh
> +++ b/scripts/atomic/gen-atomic-fallback.sh
> @@ -140,6 +140,32 @@ cat <<EOF
>  EOF
>  }
>  
> +gen_try_cmpxchg_fallback()
> +{
> +	local order="$1"; shift;
> +
> +cat <<EOF
> +#ifndef try_cmpxchg${order}
> +#define try_cmpxchg${order}(_ptr, _oldp, _new) \\
> +({ \\
> +	typeof(*ptr) ___r, ___o = *(_oldp); \\
> +	___r = cmpxchg${order}((_ptr), ___o, (_new)); \\
> +	if (unlikely(___r != ___o)) \\
> +		*(_old) = ___r; \\

This doesn't compile because _old isn't declared. Probably best to avoid
evaluating _oldp twice though.

Will
