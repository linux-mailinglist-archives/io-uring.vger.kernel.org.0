Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7746B7502FD
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 11:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjGLJZX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 05:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjGLJZT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 05:25:19 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5C81722;
        Wed, 12 Jul 2023 02:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NmLMGaJ0xD9NFSfYbMPFqAxqBeFJleZiby5UzzC1nu4=; b=cFMEGB59XB1ge8OAEHdEv6i6DS
        TdQQUzGerI5UMAOWTq+wdlEi08H/MwTDVI3zcXyXBTspx9hNpU0ZxMVFJAMC5oG7Q5BdOHdu5CC7S
        Qo87L8zIw60nw6ZmJTbBaz9FH6PN5iOLjr5tYOMVZApWiF1Vx25mq52vHO92cMuMAxHWEVdGjFTxC
        suF5huH/nNdyUaWgtNLSQPoCgiKq1Q23xIWgAFpO9zveWps94cAy+QfJY/BPr7Vj70SjLDOQPz1jj
        8Fmu15q1bw0WdE8zBYKWxqRL4MXchaXppPjbie/U9hJS3UNefFmwPcAnzjZXkTjJz2LgQrYDLQ54+
        QZSHnv0Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJW5z-003bc6-0q;
        Wed, 12 Jul 2023 09:25:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A7695300222;
        Wed, 12 Jul 2023 11:25:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8F77724408329; Wed, 12 Jul 2023 11:25:14 +0200 (CEST)
Date:   Wed, 12 Jul 2023 11:25:14 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 5/7] futex: make futex_parse_waitv() available as a helper
Message-ID: <20230712092514.GE3100107@hirez.programming.kicks-ass.net>
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712004705.316157-6-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 06:47:03PM -0600, Jens Axboe wrote:

> Since we now provide a way to pass in a wake handler and data, ensure we
> use __futex_queue() to avoid having futex_queue() overwrite our wait
> data.

> diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
> index 3471af87cb7d..dfd02ca5ecfa 100644
> --- a/kernel/futex/waitwake.c
> +++ b/kernel/futex/waitwake.c
> @@ -446,7 +446,8 @@ static int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *wo
>  			 * next futex. Queue each futex at this moment so hb can
>  			 * be unlocked.
>  			 */
> -			futex_queue(q, hb);
> +			__futex_queue(q, hb);
> +			spin_unlock(&hb->lock);
>  			continue;
>  		}

I'm not following; I even applied all your patches up to this point, but
futex_queue() still reads:

static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
	__releases(&hb->lock)
{
	__futex_queue(q, hb);
	spin_unlock(&hb->lock);
}

How would it be different and overwrite anything ?!?
