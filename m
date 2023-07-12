Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9510775012F
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 10:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjGLITg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 04:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjGLISr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 04:18:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1812A19BE;
        Wed, 12 Jul 2023 01:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SCvwCeH2I3Y0qRtsPHSSrmWueAiQGa5bqIbj/wmoBZM=; b=FJwb+Nrmaedmkh0AxrHiFOKojT
        /iEsU4sjvmvDBk6IbfinRSB9qB7LbHXjVEjINT0w8x4Z681hK/0FUHH35C4B3psTW5eXcniHuPf/b
        Cv2fQs7P7V6CsniWGfYRX/0wx8VmcXwJ0k+TdynYMUl0bKQ2gbJJU1eU3wlNmjwMjb+vp1p09LVrK
        B5qSIf5PKAFTgJoS9DYLQ8mTE3rqZHEAPJwQvflVulOAfahaVwj0lCrPItmgG/Zvw0ZJ3lU3A43Fs
        d/ANqUvWS0f8HwFMIgcO5sLIaGGoviaGfWUvOrGu/YyA7RUHb1/FMiklS/4ew6uqjwBtj8KIBYChE
        rYFKDTxA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJV1F-00GUFh-Oa; Wed, 12 Jul 2023 08:16:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5B96D3002CE;
        Wed, 12 Jul 2023 10:16:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 39176243A2F82; Wed, 12 Jul 2023 10:16:17 +0200 (CEST)
Date:   Wed, 12 Jul 2023 10:16:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 1/7] futex: abstract out futex_op_to_flags() helper
Message-ID: <20230712081617.GB3100107@hirez.programming.kicks-ass.net>
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712004705.316157-2-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 06:46:59PM -0600, Jens Axboe wrote:
> Rather than needing to duplicate this for the io_uring hook of futexes,
> abstract out a helper.
> 
> No functional changes intended in this patch.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/futex/futex.h    | 15 +++++++++++++++
>  kernel/futex/syscalls.c | 11 ++---------
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
> index b5379c0e6d6d..d2949fca37d1 100644
> --- a/kernel/futex/futex.h
> +++ b/kernel/futex/futex.h
> @@ -291,4 +291,19 @@ extern int futex_unlock_pi(u32 __user *uaddr, unsigned int flags);
>  
>  extern int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int trylock);
>  
> +static inline bool futex_op_to_flags(int op, int cmd, unsigned int *flags)
> +{
	*flags = 0;

> +	if (!(op & FUTEX_PRIVATE_FLAG))
> +		*flags |= FLAGS_SHARED;
> +
> +	if (op & FUTEX_CLOCK_REALTIME) {
> +		*flags |= FLAGS_CLOCKRT;
> +		if (cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI &&
> +		    cmd != FUTEX_LOCK_PI2)
> +			return false;
> +	}
> +
> +	return true;
> +}


> diff --git a/kernel/futex/syscalls.c b/kernel/futex/syscalls.c
> index a8074079b09e..75ca8c41cc94 100644
> --- a/kernel/futex/syscalls.c
> +++ b/kernel/futex/syscalls.c
> @@ -88,15 +88,8 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
>  	int cmd = op & FUTEX_CMD_MASK;
>  	unsigned int flags = 0;

and skip the initializer here.

>  
> -	if (!(op & FUTEX_PRIVATE_FLAG))
> -		flags |= FLAGS_SHARED;
> -
> -	if (op & FUTEX_CLOCK_REALTIME) {
> -		flags |= FLAGS_CLOCKRT;
> -		if (cmd != FUTEX_WAIT_BITSET && cmd != FUTEX_WAIT_REQUEUE_PI &&
> -		    cmd != FUTEX_LOCK_PI2)
> -			return -ENOSYS;
> -	}
> +	if (!futex_op_to_flags(op, cmd, &flags))
> +		return -ENOSYS;
>  

then the helper is more self sufficient and doesn't rely on the caller
to initialize the flags word.
