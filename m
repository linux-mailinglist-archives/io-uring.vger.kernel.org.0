Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7945675E17A
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjGWKuj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 06:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjGWKui (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 06:50:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE8AE64;
        Sun, 23 Jul 2023 03:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D1F460BFF;
        Sun, 23 Jul 2023 10:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750E7C433CA;
        Sun, 23 Jul 2023 10:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1690109433;
        bh=rpf1pzEGimfS+pD7lRpXpbhbCeda9Jos1hrb2yJB+3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AgDxLM3+DwaT9S0gw6BQrgBgnyNIKBC/96qyekEg37ek2YIII/yUKhNVehnNayAkw
         iGkanKS4hAJRD7NHnXSxf+6P18dlJy+xDjbVhEXKYmA0PwiYnVN7cyhMZCNHyq8Vq0
         dqkXmgTF2tqJarZJLppEQJTJbkRkWgakaUSI4Wis=
Date:   Sun, 23 Jul 2023 12:50:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Message-ID: <2023072310-superman-frosted-7321@gregkh>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716195007.731909670@linuxfoundation.org>
 <12251678.O9o76ZdvQC@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12251678.O9o76ZdvQC@natalenko.name>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 23, 2023 at 11:39:42AM +0200, Oleksandr Natalenko wrote:
> Hello.
> 
> On neděle 16. července 2023 21:50:53 CEST Greg Kroah-Hartman wrote:
> > From: Andres Freund <andres@anarazel.de>
> > 
> > commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.
> > 
> > I observed poor performance of io_uring compared to synchronous IO. That
> > turns out to be caused by deeper CPU idle states entered with io_uring,
> > due to io_uring using plain schedule(), whereas synchronous IO uses
> > io_schedule().
> > 
> > The losses due to this are substantial. On my cascade lake workstation,
> > t/io_uring from the fio repository e.g. yields regressions between 20%
> > and 40% with the following command:
> > ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/write.0.0
> > 
> > This is repeatable with different filesystems, using raw block devices
> > and using different block devices.
> > 
> > Use io_schedule_prepare() / io_schedule_finish() in
> > io_cqring_wait_schedule() to address the difference.
> > 
> > After that using io_uring is on par or surpassing synchronous IO (using
> > registered files etc makes it reliably win, but arguably is a less fair
> > comparison).
> > 
> > There are other calls to schedule() in io_uring/, but none immediately
> > jump out to be similarly situated, so I did not touch them. Similarly,
> > it's possible that mutex_lock_io() should be used, but it's not clear if
> > there are cases where that matters.
> > 
> > Cc: stable@vger.kernel.org # 5.10+
> > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > Cc: io-uring@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Andres Freund <andres@anarazel.de>
> > Link: https://lore.kernel.org/r/20230707162007.194068-1-andres@anarazel.de
> > [axboe: minor style fixup]
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  io_uring/io_uring.c |   15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -2575,6 +2575,8 @@ int io_run_task_work_sig(struct io_ring_
> >  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> >  					  struct io_wait_queue *iowq)
> >  {
> > +	int token, ret;
> > +
> >  	if (unlikely(READ_ONCE(ctx->check_cq)))
> >  		return 1;
> >  	if (unlikely(!llist_empty(&ctx->work_llist)))
> > @@ -2585,11 +2587,20 @@ static inline int io_cqring_wait_schedul
> >  		return -EINTR;
> >  	if (unlikely(io_should_wake(iowq)))
> >  		return 0;
> > +
> > +	/*
> > +	 * Use io_schedule_prepare/finish, so cpufreq can take into account
> > +	 * that the task is waiting for IO - turns out to be important for low
> > +	 * QD IO.
> > +	 */
> > +	token = io_schedule_prepare();
> > +	ret = 0;
> >  	if (iowq->timeout == KTIME_MAX)
> >  		schedule();
> >  	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
> > -		return -ETIME;
> > -	return 0;
> > +		ret = -ETIME;
> > +	io_schedule_finish(token);
> > +	return ret;
> >  }
> >  
> >  /*
> 
> Reportedly, this caused a regression as reported in [1] [2] [3]. Not only v6.4.4 is affected, v6.1.39 is affected too.
> 
> Reverting this commit fixes the issue.
> 
> Please check.

Is this also an issue in 6.5-rc2?

thanks,

greg k-h
