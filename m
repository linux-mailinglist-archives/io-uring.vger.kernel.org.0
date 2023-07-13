Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D952C7529C7
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 19:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjGMRZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 13:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjGMRZE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 13:25:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A0A2699;
        Thu, 13 Jul 2023 10:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ByUquXOuf40X+7XWU0h0cF//mL7fowc8eGUx94vWek=; b=RzHbo+teo1SquhEn7OkWITeyEw
        T8SK42HYtN26E04VY80dWnfEnSYtbll4lY//f9gAqaeRlYRW2Fbuhfefo1VIaiWHWW4Z1Of7IlsjW
        ueUsILYst7p7GIH6Tvu3XBh90DJweX0NJ9foOuj8Zbf1yBCcTPXwyEnJO2NeIGfgXtYU1Y7kNDJsW
        0xpuECeu7qKXL3icFV+4Q+omiwSJHs2RZ028z840ICnA7YfNWcBdA5lch8PUpLPZ7jq1f+MOw8COK
        Eie2i7jRpB6t9YdXAir7EJd7Q3/23Pf7Y6Pes/ShTr9fZ6VSvs1HW+wXrr9jPJ2Tf5usDZPkXLOFc
        7j6Gc7dg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qK03l-000KQC-7B; Thu, 13 Jul 2023 17:24:57 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 733CE3002CE;
        Thu, 13 Jul 2023 19:24:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3D7E52439FF32; Thu, 13 Jul 2023 19:24:55 +0200 (CEST)
Date:   Thu, 13 Jul 2023 19:24:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Message-ID: <20230713172455.GA3191007@hirez.programming.kicks-ass.net>
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-5-axboe@kernel.dk>
 <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 13, 2023 at 01:15:13PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 12, 2023 at 10:20:13AM -0600, Jens Axboe wrote:
> 
> > +int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> > +{
> > +	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
> > +
> > +	if (unlikely(sqe->addr2 || sqe->buf_index || sqe->addr3))
> > +		return -EINVAL;
> > +
> > +	iof->futex_op = READ_ONCE(sqe->fd);
> > +	iof->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> > +	iof->futex_val = READ_ONCE(sqe->len);
> > +	iof->futex_mask = READ_ONCE(sqe->file_index);
> > +	iof->futex_flags = READ_ONCE(sqe->futex_flags);
> > +	if (iof->futex_flags & FUTEX_CMD_MASK)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> 
> I'm a little confused on the purpose of iof->futex_op, it doesn't appear
> to be used. Instead iof->futex_flags is used as the ~FUTEX_CMD_MASK part
> of ops.
> 
> The latter actually makes sense since you encode the actual op in the
> IOURING_OP_ space.

Futex is slowly getting back to me; I'm thinking these io_uring
interfaces should perhaps use the futex2 flags instead of the futex_op
encoded muck.

I'll try and send out a few patches tomorrow to clarify things a little
-- the futex2 work seems to have stalled somewhere halfway :/
