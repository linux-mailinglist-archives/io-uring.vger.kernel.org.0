Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F89750236
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 10:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbjGLI74 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 04:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjGLI7f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 04:59:35 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86D01FDF;
        Wed, 12 Jul 2023 01:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6vVyz3HWFOPsWCjVkQvhpKJWaNzacQU8pD7mOz5k2+4=; b=Ix8+Mtvk0Y/Rcjft+c4zuN08oD
        rMDNW7fFrce8cT8UDecBcnL/s1llRd2rN3LPwnmv6jKmpHWv8iyIyIga/5tzOK2ztg0kgmBt3H4Gp
        nWa7djDciJESbMPsigXIr3/OBlp8BCsrIovsMpbrLVNX4KWEuEpi/6XLCnvb5eF/wJghFHgq0G6Wo
        6GH2I+anrpdCoxpnzkVumxX7z3+g4fpvi9ttrbQibRcX6w5ZEMWXxDKlLqgr8tKgwWtUb1ZJr1AMk
        GczvN3hJ0BiIkFzFXZ5a57WZSdpkXBJ8UgMQYCQHn1gOAGD8D4I6I0Nx9yEg0Hb61RhtYPwqCxdIb
        K8vcxY0A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJVfg-003bI1-2C;
        Wed, 12 Jul 2023 08:58:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CC12230114F;
        Wed, 12 Jul 2023 10:58:03 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B1979243AF2B7; Wed, 12 Jul 2023 10:58:03 +0200 (CEST)
Date:   Wed, 12 Jul 2023 10:58:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 2/7] futex: factor out the futex wake handling
Message-ID: <20230712085803.GD3100107@hirez.programming.kicks-ass.net>
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712004705.316157-3-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 06:47:00PM -0600, Jens Axboe wrote:
> In preparation for having another waker that isn't futex_wake_mark(),
> add a wake handler in futex_q. No extra data is associated with the
> handler outside of struct futex_q itself. futex_wake_mark() is defined as
> the standard wakeup helper, now set through futex_q_init like other
> defaults.

Urgh... so if I understand things right, you're going to replace this
with a custom wake function that does *NOT* put the task on the wake_q.

The wake_q will thus be empty and the task does not get woken up. I'm
presuming someone gets a notification instead somewhere somehow.

I might've been nice to mention some of this somewhere ...

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  kernel/futex/futex.h    | 4 ++++
>  kernel/futex/requeue.c  | 3 ++-
>  kernel/futex/waitwake.c | 6 +++---
>  3 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
> index d2949fca37d1..8eaf1a5ce967 100644
> --- a/kernel/futex/futex.h
> +++ b/kernel/futex/futex.h
> @@ -69,6 +69,9 @@ struct futex_pi_state {
>  	union futex_key key;
>  } __randomize_layout;
>  
> +struct futex_q;
> +typedef void (futex_wake_fn)(struct wake_q_head *wake_q, struct futex_q *q);
> +
>  /**
>   * struct futex_q - The hashed futex queue entry, one per waiting task
>   * @list:		priority-sorted list of tasks waiting on this futex
> @@ -98,6 +101,7 @@ struct futex_q {
>  
>  	struct task_struct *task;
>  	spinlock_t *lock_ptr;
> +	futex_wake_fn *wake;
>  	union futex_key key;
>  	struct futex_pi_state *pi_state;
>  	struct rt_mutex_waiter *rt_waiter;
