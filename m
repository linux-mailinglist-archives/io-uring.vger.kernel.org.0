Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DE91628B2
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 15:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgBROkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 09:40:49 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:45186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgBROkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 09:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=saNejNnyTb3I2aNu5CjUwfQSUXCmbXes/gAxR4QEVZE=; b=bXCyNDzvmPS2RSKmOsr2jW0FLA
        8ThMeVyVNu1QI1vBCuWJahsCj+ysQiiV20/QpbcOfYTts1ih9uVI6y56+rWPNPTiNV27zsVyBU7kG
        knZ6GdvNpyJwi1N7W0nWeBeafJPGFINqKB5Cjl9q2uM0dqkx3E/FIJZ4Jh24f1MU6HF3t4J8xcNsx
        2xyp/xb1GuCMxmTO60gEOUpnj9FFFEw8+cs4AH30g0H5izFonHGSmZ/BbBdEM2+IdIQJspL/OO3IY
        UYDuHkfljUFV6MYKeNeEcfEWgI5IcFReetPJBCSRp9diPnpJWvkwDn6oQ8R57ku7BSzr8tfw/2zoY
        6PEiar/A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j443F-0001Z7-TL; Tue, 18 Feb 2020 14:40:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DF9F63077C4;
        Tue, 18 Feb 2020 15:38:45 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BD3A12032661F; Tue, 18 Feb 2020 15:40:37 +0100 (CET)
Date:   Tue, 18 Feb 2020 15:40:37 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] asm-generic/atomic: Add try_cmpxchg() fallbacks
Message-ID: <20200218144037.GC14946@hirez.programming.kicks-ass.net>
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
               *(_ptr)
> +	___r = cmpxchg${order}((_ptr), ___o, (_new)); \\
> +	if (unlikely(___r != ___o)) \\
> +		*(_old) = ___r; \\
		*(_oldp)
> +	likely(___r == ___o); \\
> +})
> +#endif /* try_cmpxchg${order} */

And it actually builds, as tested on an ARM build.
