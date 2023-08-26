Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A32789355
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 04:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjHZCV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 22:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjHZCVG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 22:21:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2922682
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 19:21:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31D3E622C8
        for <io-uring@vger.kernel.org>; Sat, 26 Aug 2023 02:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337C2C433C7;
        Sat, 26 Aug 2023 02:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693016463;
        bh=oKfVMpYnpbBGn3qOXCYjJDyruyKisnmPmmEdkrL9WDM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UK2lnJ8gdD3aTCVdcNnR876+1T8pf7lh73wEcgo7ZSaWjs8vK76BPXjfBsukgZV/o
         M79ZONgrXvlerFDraw6iMf1Yqi4YZHuYG7lQzqZI1ijQeXqCNjYEbCz+mEw5D+ufPr
         cwebRob1g0UV58vGvDxNHez8Uj7d4pIqlhG0dWI3bwILqafOFEd6hGtFEHOVnvoOE+
         wE1w/+k9NADciQEdvCZvP/5R9gKbuaNmkUGwEyxbQhEKjyjnT5/Hw25rwpYBhFvAKO
         A8auuqfKbKfDRZECY6NsWxNKscDoCf2DyiLpLjQ87Ha7IpHTG5vA6F6TxD/qxBLn2C
         rDJZxNgSL2bZw==
Message-ID: <ac2d595a-c803-b512-84c9-a5ab35615637@kernel.org>
Date:   Fri, 25 Aug 2023 20:21:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 03/11] netdev: add XDP_SETUP_ZC_RX command
Content-Language: en-US
To:     David Wei <dw@davidwei.uk>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230826011954.1801099-1-dw@davidwei.uk>
 <20230826011954.1801099-4-dw@davidwei.uk>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230826011954.1801099-4-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/23 6:19 PM, David Wei wrote:
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 08fbd4622ccf..a20a5c847916 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1000,6 +1000,7 @@ enum bpf_netdev_command {
>  	BPF_OFFLOAD_MAP_ALLOC,
>  	BPF_OFFLOAD_MAP_FREE,
>  	XDP_SETUP_XSK_POOL,
> +	XDP_SETUP_ZC_RX,

Why XDP in the name? Packets go from nic to driver to stack to io_uring,
no? That is not XDP.


>  };
>  
>  struct bpf_prog_offload_ops;
> @@ -1038,6 +1039,11 @@ struct netdev_bpf {
>  			struct xsk_buff_pool *pool;
>  			u16 queue_id;
>  		} xsk;
> +		/* XDP_SETUP_ZC_RX */
> +		struct {
> +			struct io_zc_rx_ifq *ifq;
> +			u16 queue_id;
> +		} zc_rx;
>  	};
>  };
>  

