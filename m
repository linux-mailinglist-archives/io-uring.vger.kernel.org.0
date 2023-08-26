Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0383F789359
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 04:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjHZC0T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 22:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjHZC0T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 22:26:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085A8269E
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 19:26:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A9E2612D8
        for <io-uring@vger.kernel.org>; Sat, 26 Aug 2023 02:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AF4C433C8;
        Sat, 26 Aug 2023 02:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693016776;
        bh=tb20K/4uQ1wpyp8vqPjWEtxSp89wfutQlgnXZ70OTqU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JMoZBhX6+7RNs3roWGQkEkAULKiHhYNKvkq0qOXW2GsSe6AnqhvHGTiiuUM5O6bIp
         dwCAip0CDlwA1+qW1yjbT2eXFo9w8LMjvCdesBSpv3gKzQhgeTwiCNCOxIoaXRoz0H
         NLykAv6C2EzSONhq1a6NKNkj3zZltOsS9SVO7NFlWEjykFgYJBaVXSIXDF7hTYxx9D
         Z2K+rwm+Hu9y1MSLUwBkLKCkUr1phI1NMQ2yPWLagEhjhNxEcGLaU3+S+IcVcSdOyJ
         HZ3RmTFFqVpl6aH3ToCw791aLn9xeTz/KTfVGVSyYEm+rmVN0DFWBueAcSjQuYmHdA
         g/pk4U8096oHQ==
Message-ID: <d307c2a5-3d30-3e86-c376-e1c5faf19683@kernel.org>
Date:   Fri, 25 Aug 2023 20:26:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 04/11] io_uring: setup ZC for an RX queue when registering
 an ifq
Content-Language: en-US
To:     David Wei <dw@davidwei.uk>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230826011954.1801099-1-dw@davidwei.uk>
 <20230826011954.1801099-5-dw@davidwei.uk>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230826011954.1801099-5-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/23 6:19 PM, David Wei wrote:
> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
> index 6c57c9b06e05..8cc66731af5b 100644
> --- a/io_uring/zc_rx.c
> +++ b/io_uring/zc_rx.c
> @@ -10,6 +11,35 @@
>  #include "kbuf.h"
>  #include "zc_rx.h"
>  
> +typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
> +
> +static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
> +			   u16 queue_id)
> +{
> +	struct netdev_bpf cmd;
> +	bpf_op_t ndo_bpf;
> +
> +	ndo_bpf = dev->netdev_ops->ndo_bpf;

This is not bpf related, so it seems wrong to be overloading this ndo.


> +	if (!ndo_bpf)
> +		return -EINVAL;
> +
> +	cmd.command = XDP_SETUP_ZC_RX;
> +	cmd.zc_rx.ifq = ifq;
> +	cmd.zc_rx.queue_id = queue_id;
> +
> +	return ndo_bpf(dev, &cmd);
> +}
> +
> +static int io_open_zc_rxq(struct io_zc_rx_ifq *ifq)
> +{
> +	return __io_queue_mgmt(ifq->dev, ifq, ifq->if_rxq_id);
> +}
> +
> +static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
> +{
> +	return __io_queue_mgmt(ifq->dev, NULL, ifq->if_rxq_id);
> +}
> +
>  static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
>  {
>  	struct io_zc_rx_ifq *ifq;
> @@ -19,12 +49,17 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
>  		return NULL;
>  
>  	ifq->ctx = ctx;
> +	ifq->if_rxq_id = -1;
>  
>  	return ifq;
>  }
>  
>  static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
>  {
> +	if (ifq->if_rxq_id != -1)
> +		io_close_zc_rxq(ifq);
> +	if (ifq->dev)
> +		dev_put(ifq->dev);
>  	io_free_rbuf_ring(ifq);
>  	kfree(ifq);
>  }
> @@ -41,17 +76,22 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
>  		return -EFAULT;
>  	if (ctx->ifq)
>  		return -EBUSY;
> +	if (reg.if_rxq_id == -1)
> +		return -EINVAL;
>  
>  	ifq = io_zc_rx_ifq_alloc(ctx);
>  	if (!ifq)
>  		return -ENOMEM;
>  
> -	/* TODO: initialise network interface */
> -
>  	ret = io_allocate_rbuf_ring(ifq, &reg);
>  	if (ret)
>  		goto err;
>  
> +	ret = -ENODEV;
> +	ifq->dev = dev_get_by_index(&init_net, reg.if_idx);

What's the plan for other namespaces? Ideally the device bind comes from
a socket and that gives you the namespace.

> +	if (!ifq->dev)
> +		goto err;
> +
>  	/* TODO: map zc region and initialise zc pool */
>  
>  	ifq->rq_entries = reg.rq_entries;


