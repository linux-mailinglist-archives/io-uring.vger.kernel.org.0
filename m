Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5184C9564
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 21:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiCAUHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 15:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233110AbiCAUHf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 15:07:35 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189C770CD9;
        Tue,  1 Mar 2022 12:06:51 -0800 (PST)
Received: from [45.44.224.220] (port=57048 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nP8ll-0006KV-JG; Tue, 01 Mar 2022 15:06:49 -0500
Message-ID: <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 01 Mar 2022 15:06:48 -0500
In-Reply-To: <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
References: <cover.1646142288.git.olivier@trillion01.com>
         <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
         <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2022-03-02 at 02:31 +0800, Hao Xu wrote:
> 
> > +       ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
> > +       if (!ne)
> > +               goto out;
> 
> IMHO, we need to handle -ENOMEM here, I cut off the error handling
> when
> 
> I did the quick coding. Sorry for misleading.

If you are correct, I would be shocked about this.

I did return in my 'Linux Device Drivers' book and nowhere it is
mentionned that the kmalloc() can return something else than a pointer

No mention at all about the return value

in man page:
https://www.kernel.org/doc/htmldocs/kernel-api/API-kmalloc.html
API doc:

https://www.kernel.org/doc/html/latest/core-api/mm-api.html?highlight=kmalloc#c.kmalloc

header file:
https://elixir.bootlin.com/linux/latest/source/include/linux/slab.h#L522

I did browse into the kmalloc code. There is a lot of paths to cover
but from preliminary reading, it pretty much seems that kmalloc only
returns a valid pointer or NULL...

/**
 * kmem_cache_alloc - Allocate an object
 * @cachep: The cache to allocate from.
 * @flags: See kmalloc().
 *
 * Allocate an object from this cache.  The flags are only relevant
 * if the cache has no available objects.
 *
 * Return: pointer to the new object or %NULL in case of error
 */
 
 /**
 * __do_kmalloc - allocate memory
 * @size: how many bytes of memory are required.
 * @flags: the type of memory to allocate (see kmalloc).
 * @caller: function caller for debug tracking of the caller
 *
 * Return: pointer to the allocated memory or %NULL in case of error
 */

I'll need someone else to confirm about possible kmalloc() return
values with perhaps an example

I am a bit skeptic that something special needs to be done here...

Or perhaps you are suggesting that io_add_napi() returns an error code
when allocation fails.

as done here:
https://elixir.bootlin.com/linux/latest/source/arch/alpha/kernel/core_marvel.c#L867

If that is what you suggest, what would this info do for the caller?

IMHO, it wouldn't help in any way...
> 
> > 
> > @@ -7519,7 +7633,11 @@ static int __io_sq_thread(struct io_ring_ctx
> > *ctx, bool cap_entries)
> >                     !(ctx->flags & IORING_SETUP_R_DISABLED))
> >                         ret = io_submit_sqes(ctx, to_submit);
> >                 mutex_unlock(&ctx->uring_lock);
> > -
> > +#ifdef CONFIG_NET_RX_BUSY_POLL
> > +               if (!list_empty(&ctx->napi_list) &&
> > +                   io_napi_busy_loop(&ctx->napi_list))
> 
> I'm afraid we may need lock for sqpoll too, since io_add_napi() could
> be 
> in iowq context.
> 
> I'll take a look at the lock stuff of this patch tomorrow, too late
> now 
> in my timezone.

Ok, please do. I'm not a big user of io workers. I may have omitted to
consider this possibility.

If that is the case, I think that this would be very easy to fix by
locking the spinlock while __io_sq_thread() is using napi_list.
> 
> How about:
> 
> if (list is singular) {
> 
>      do something;
> 
>      return;
> 
> }
> 
> while (!io_busy_loop_end() && io_napi_busy_loop())
> 
>      ;
> 

is there a concern with the current code?
What would be the benefit of your suggestion over current code?

To me, it seems that if io_blocking_napi_busy_loop() is called, a
reasonable expectation would be that some busy looping is done or else
you could return the function without doing anything which would, IMHO,
be misleading.

By definition, napi_busy_loop() is not blocking and if you desire the
device to be in busy poll mode, you need to do it once in a while or
else, after a certain time, the device will return back to its
interrupt mode.

IOW, io_blocking_napi_busy_loop() follows the same logic used by
napi_busy_loop() that does not call loop_end() before having perform 1
loop iteration.

> Btw, start_time seems not used in singular branch.

I know. This is why it is conditionally initialized.

Greetings,

