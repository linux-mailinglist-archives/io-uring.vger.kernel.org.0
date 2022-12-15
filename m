Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562EB64E12A
	for <lists+io-uring@lfdr.de>; Thu, 15 Dec 2022 19:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLOSob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Dec 2022 13:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLOSoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Dec 2022 13:44:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0247920BEC;
        Thu, 15 Dec 2022 10:44:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B11FBB81C28;
        Thu, 15 Dec 2022 18:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710AAC433D2;
        Thu, 15 Dec 2022 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671129867;
        bh=PnGl+bW8AYBQKwWK/SykVLlRut0cflxesBcJigjZOQE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=jR5IHPQ7DHHYXnd4kdSh3qSKE/IZv9ag4j4CcObwNN7skM5KEK6+ChX9sQtmUkhnn
         xiUqB4IcSzzXEXzB02ZjPc9nfh0X2Lfamox686ncz7b/NpL3jqio2S8fmVS4lzKJoy
         S8js1dxofvYCJE3X3V0Xelfk5Q7DOTMIMOArG8elB0XB21jdrV1ycQ2YfqJ701aLoB
         BMSMfow4/+GtNe0MQMDAHkm2v7zS6icIM9MJ84AG7mY4p4GGbxVN1j9a1zkzaoHlQd
         r73wJqWtS8n9LP10P/qeULl8sIRfzRPM67M/cZqZHY4o2DO/9ytzXvoDuOLQJ0Ib35
         KiDp4n/0b+xww==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 193365C09D0; Thu, 15 Dec 2022 10:44:27 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:44:27 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Dylan Yudaken <dylany@meta.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH] io_uring: use call_rcu_hurry if signaling an eventfd
Message-ID: <20221215184427.GI4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221215184138.795576-1-dylany@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215184138.795576-1-dylany@meta.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 15, 2022 at 10:41:38AM -0800, Dylan Yudaken wrote:
> io_uring uses call_rcu in the case it needs to signal an eventfd as a
> result of an eventfd signal, since recursing eventfd signals are not
> allowed. This should be calling the new call_rcu_hurry API to not delay
> the signal.
> 
> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> 
> Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
> Cc: Paul E. McKenney <paulmck@kernel.org>

Looks good!

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  io_uring/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index b521186efa5c..2cb8c665bab1 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -538,7 +538,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
>  	} else {
>  		atomic_inc(&ev_fd->refs);
>  		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
> -			call_rcu(&ev_fd->rcu, io_eventfd_ops);
> +			call_rcu_hurry(&ev_fd->rcu, io_eventfd_ops);
>  		else
>  			atomic_dec(&ev_fd->refs);
>  	}
> 
> base-commit: 041fae9c105ae342a4245cf1e0dc56a23fbb9d3c
> -- 
> 2.30.2
> 
