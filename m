Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AD875FBB0
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 18:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjGXQRH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 12:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjGXQRG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 12:17:06 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F6C1720;
        Mon, 24 Jul 2023 09:17:01 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 176243200909;
        Mon, 24 Jul 2023 12:16:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 24 Jul 2023 12:16:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1690215416; x=1690301816; bh=jA
        a53m+yef1y0q3fnEY7Tlatp2qWnCNykfUIa4TjtYU=; b=s8tpWFn+sP0jIzBHfK
        14fQ3vOeQRYqSnrGzDFh8scRvljrUWtZBR4kJWAoKMYX1VyDsRJBl/I1YgryFb2a
        wvl16L9sdEO5mpAp4DAWowAt3UyhO/WaiDQLURX1FT/OoHhwawzRsCMFNxlPxMo6
        rwA8NFmhNx0EHjsDs+8ShvuU9+32N9QCvoTeGSRhhWW3LWNEEofohUdnfSzd5rJY
        KEhGRmP+eq2KHew4/WfbuZ0aa5UVqgl5yJ0BNy7ILAdwJiOtU5+zoJccVTAKXwUL
        VKsMOdqKIxJUrZhfQwx2mY0x4/jfCtmtWi9JuzCBgMuM1xDl9wPYkFozuzd/Tzzb
        +a7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1690215416; x=1690301816; bh=jAa53m+yef1y0
        q3fnEY7Tlatp2qWnCNykfUIa4TjtYU=; b=pEH+B77xt9XurUN03vY5PWEl5badM
        z/XnDTCDgKc+58SJLRLHM3/8k03lj8ozbdbhx5AxPsb4eYikZ57XHCvPg7yt6Zz5
        Mz/jxuOKeq/LvABDreZfzDAj1iMhidj2cyxADRvJlOmgBZRFa0Dn5t5YUhD1zX8y
        z1tDIaMARu61Z18R36X7gTkLOjjfIuSlIKNcN7nPMK90slYjwuhGmzZNuBKJ73Hc
        3XYzsgCVVzwppg7TS630aZaoElZwmfgSicSMi+Pe5hMhvNJr9APtiKUCMNc1BF7Q
        dhn3wW5jUeSof7n7zyzMJaY7Ud9syaK728IMi0dXD4e2/1bokTfGpiA/w==
X-ME-Sender: <xms:-KO-ZJ38yZjdTW8uu4qxEX4qxfPJOKJLMvDb5CVSxftIQcq2C-_7cQ>
    <xme:-KO-ZAG5p9WHyOAoPoPatBndfnlpPiwhXRuh6akSCP-J5GRMdhPbU9-d6fD82K2nF
    NAqh0rnO2mxDvWJXw>
X-ME-Received: <xmr:-KO-ZJ4D7Qo0ERomh_i5nCI0vu61_fQdw8zAVbjiKfY7n3skGVptlCdvsm5UYIf9uWz1Ycz19QdfqH-0xzsbxe-gG9F4pHnAxN_bFy7JtWMk0i3nEwnyKDOsVq6j>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrheekgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:-KO-ZG3qtTb8Qgkv3bPKK97PQtVLJbwJbjXQDq6ACIBRcGXOP7cnbg>
    <xmx:-KO-ZMGC0pou62KhTaDe5PPM5Pm9ztc4hkvD-7gLAlQCNHmTbApYng>
    <xmx:-KO-ZH-u7XW6eqwF4rs27TLevKBLc3KgQc7p_fciED79KC_YFbJ7DA>
    <xmx:-KO-ZH2F5bXW4aAztEFP4BhSBE-sBm_nMxL-Zft19C_scyY6ZbT4pQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jul 2023 12:16:56 -0400 (EDT)
Date:   Mon, 24 Jul 2023 09:16:54 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Phil Elwell <phil@raspberrypi.com>, asml.silence@gmail.com,
        david@fromorbit.com, hch@lst.de, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] io_uring: Use io_schedule* in cqring wait
Message-ID: <20230724161654.cjh7pd63uas5grmz@awork3.anarazel.de>
References: <CAMEGJJ2RxopfNQ7GNLhr7X9=bHXKo+G5OOe0LUq=+UgLXsv1Xg@mail.gmail.com>
 <3d97ae14-dd8d-7f82-395a-ccc17c6156be@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d97ae14-dd8d-7f82-395a-ccc17c6156be@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-07-24 09:48:58 -0600, Jens Axboe wrote:
> On 7/24/23 9:35?AM, Phil Elwell wrote:
> > Hi Andres,
> > 
> > With this commit applied to the 6.1 and later kernels (others not
> > tested) the iowait time ("wa" field in top) in an ARM64 build running
> > on a 4 core CPU (a Raspberry Pi 4 B) increases to 25%, as if one core
> > is permanently blocked on I/O. The change can be observed after
> > installing mariadb-server (no configuration or use is required). After
> > reverting just this commit, "wa" drops to zero again.
> 
> There are a few other threads on this...
> 
> > I can believe that this change hasn't negatively affected performance,
> > but the result is misleading. I also think it's pushing the boundaries
> > of what a back-port to stable should do.

FWIW, I think this partially just mpstat reporting something quite bogus. It
makes no sense to say that a cpu is 100% busy waiting for IO, when the one
process is doing IO is just waiting.


> +static bool current_pending_io(void)
> +{
> +	struct io_uring_task *tctx = current->io_uring;
> +
> +	if (!tctx)
> +		return false;
> +	return percpu_counter_read_positive(&tctx->inflight);
> +}
> +
>  /* when returns >0, the caller should retry */
>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  					  struct io_wait_queue *iowq)
>  {
> -	int token, ret;
> +	int io_wait, ret;
>  
>  	if (unlikely(READ_ONCE(ctx->check_cq)))
>  		return 1;
> @@ -2511,17 +2520,19 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  		return 0;
>  
>  	/*
> -	 * Use io_schedule_prepare/finish, so cpufreq can take into account
> -	 * that the task is waiting for IO - turns out to be important for low
> -	 * QD IO.
> +	 * Mark us as being in io_wait if we have pending requests, so cpufreq
> +	 * can take into account that the task is waiting for IO - turns out
> +	 * to be important for low QD IO.
>  	 */
> -	token = io_schedule_prepare();
> +	io_wait = current->in_iowait;

I don't know the kernel "rules" around this, but ->in_iowait is only modified
in kernel/sched, so it seemed a tad "unfriendly" to scribble on it here...


Building a kernel to test with the patch applied, will reboot into it once the
call I am on has finished. Unfortunately the performance difference didn't
reproduce nicely in VM...

Greetings,

Andres Freund
