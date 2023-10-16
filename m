Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19FC67CA091
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 09:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjJPH0z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 03:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjJPH0x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 03:26:53 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED77E1
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 00:26:52 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qsHzz-0002wL-97; Mon, 16 Oct 2023 09:26:47 +0200
Received: from [2a0a:edc0:2:b01:1d::c0] (helo=ptx.whiteo.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1qsHzy-0021tg-LG; Mon, 16 Oct 2023 09:26:46 +0200
Received: from sha by ptx.whiteo.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1qsHzy-00EhVy-GZ; Mon, 16 Oct 2023 09:26:46 +0200
Date:   Mon, 16 Oct 2023 09:26:46 +0200
From:   Sascha Hauer <sha@pengutronix.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Problem with io_uring splice and KTLS
Message-ID: <20231016072646.GV3359458@pengutronix.de>
References: <20231010141932.GD3114228@pengutronix.de>
 <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
 <20231012133407.GA3359458@pengutronix.de>
 <f39ef992-4789-4c30-92ef-e3114a31d5c7@kernel.dk>
 <20231013054716.GG3359458@pengutronix.de>
 <a9dd11d9-b5b8-456d-b8b6-12257e2924ab@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9dd11d9-b5b8-456d-b8b6-12257e2924ab@kernel.dk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: io-uring@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 13, 2023 at 07:45:55AM -0600, Jens Axboe wrote:
> On 10/12/23 11:47 PM, Sascha Hauer wrote:
> > On Thu, Oct 12, 2023 at 07:45:07PM -0600, Jens Axboe wrote:
> >> On 10/12/23 7:34 AM, Sascha Hauer wrote:
> >>> In case you don't have encryption hardware you can create an
> >>> asynchronous encryption module using cryptd. Compile a kernel with
> >>> CONFIG_CRYPTO_USER_API_AEAD and CONFIG_CRYPTO_CRYPTD and start the
> >>> webserver with the '-c' option. /proc/crypto should then contain an
> >>> entry with:
> >>>
> >>>  name         : gcm(aes)
> >>>  driver       : cryptd(gcm_base(ctr(aes-generic),ghash-generic))
> >>>  module       : kernel
> >>>  priority     : 150
> >>
> >> I did a bit of prep work to ensure I had everything working for when
> >> there's time to dive into it, but starting it with -c doesn't register
> >> this entry. Turns out the bind() in there returns -1/ENOENT.
> > 
> > Yes, that happens here as well, that's why I don't check for the error
> > in the bind call. Nevertheless it has the desired effect that the new
> > algorithm is registered and used from there on. BTW you only need to
> > start the webserver once with -c. If you start it repeatedly with -c a
> > new gcm(aes) instance is registered each time.
> 
> Gotcha - I wasn't able to trigger the condition, which is why I thought
> perhaps I was missing something.
> 
> Can you try the below patch and see if that makes a difference? I'm not
> quite sure why it would since you said it triggers with DEFER_TASKRUN as
> well, and for that kind of notification, you should never hit the paths
> you have detailed in the debug patch.

I can confirm that this patch makes it work for me. I tested with both
software cryptd and also with my original CAAM encryption workload.
IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN is not needed.
Both my simple webserver and the original C++ Webserver from our
customer are now working without problems.

Do you think there is a chance getting this change upstream? I'm a bit
afraid the code originally uses signal_pending() instead of
task_sigpending() for a good reason.

Sascha

> 
> diff --git a/net/core/stream.c b/net/core/stream.c
> index f5c4e47df165..a9a196587254 100644
> --- a/net/core/stream.c
> +++ b/net/core/stream.c
> @@ -67,7 +67,7 @@ int sk_stream_wait_connect(struct sock *sk, long *timeo_p)
>  			return -EPIPE;
>  		if (!*timeo_p)
>  			return -EAGAIN;
> -		if (signal_pending(tsk))
> +		if (task_sigpending(tsk))
>  			return sock_intr_errno(*timeo_p);
>  
>  		add_wait_queue(sk_sleep(sk), &wait);
> @@ -103,7 +103,7 @@ void sk_stream_wait_close(struct sock *sk, long timeout)
>  		do {
>  			if (sk_wait_event(sk, &timeout, !sk_stream_closing(sk), &wait))
>  				break;
> -		} while (!signal_pending(current) && timeout);
> +		} while (!task_sigpending(current) && timeout);
>  
>  		remove_wait_queue(sk_sleep(sk), &wait);
>  	}
> @@ -134,7 +134,7 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>  			goto do_error;
>  		if (!*timeo_p)
>  			goto do_eagain;
> -		if (signal_pending(current))
> +		if (task_sigpending(current))
>  			goto do_interrupted;
>  		sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
>  		if (sk_stream_memory_free(sk) && !vm_wait)
> 
> -- 
> Jens Axboe
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
