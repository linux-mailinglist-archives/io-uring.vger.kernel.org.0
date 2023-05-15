Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FED703882
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 19:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbjEORcy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 13:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244346AbjEORci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 13:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E086582
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 10:29:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7107762D16
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 17:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9613BC4339C;
        Mon, 15 May 2023 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171797;
        bh=HND/fi/LqnYdV2Zi8PU1A7sFl5ZI6OJIRED2DbA++Ck=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=XiRplXtyYExfvilBR2iLNVYsspJo/KXDLuQSOk4j4nuogvDxo1OY4kRrQWW2rqQS/
         9Fuo8DH6r5LLGKFdb6ok23FhAveft33S1H9dUan0MgPIx250D28Ytqk46RReBiW+t6
         GQ16W4t8W530TUBsOv2IADOpHVW31tL5LqhxXRGaEPsVKX4j1qv8Cwrit1yXuSGgys
         m6bmq3NyuRcO94ozmN9iag8QwlYjYA4HsNdhQiA6pRBhjnSmpacX12QueagbabFvpn
         Lnt1WpdRZHvY5vSnU1f88LcvOOzTvIM6jQ9jUwTLBndvQP0tBOW/DERKNkOEjH8bdH
         dhNDgYTs4pIrg==
Message-ID: <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
Date:   Mon, 15 May 2023 11:29:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf
 refcounting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 40f591f7fce1..3d18e295bb2f 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1231,7 +1231,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  	if ((flags & MSG_ZEROCOPY) && size) {
>  		if (msg->msg_ubuf) {
>  			uarg = msg->msg_ubuf;
> -			net_zcopy_get(uarg);
>  			zc = sk->sk_route_caps & NETIF_F_SG;
>  		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>  			skb = tcp_write_queue_tail(sk);
> @@ -1458,7 +1457,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  		tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
>  	}
>  out_nopush:
> -	net_zcopy_put(uarg);
> +	/* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
> +	if (uarg && !msg->msg_ubuf)
> +		net_zcopy_put(uarg);
>  	return copied + copied_syn;
>  
>  do_error:
> @@ -1467,7 +1468,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>  	if (copied + copied_syn)
>  		goto out;
>  out_err:
> -	net_zcopy_put_abort(uarg, true);
> +	/* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
> +	if (uarg && !msg->msg_ubuf)
> +		net_zcopy_put_abort(uarg, true);
>  	err = sk_stream_error(sk, flags, err);
>  	/* make sure we wake any epoll edge trigger waiter */
>  	if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {

Both net_zcopy_put_abort and net_zcopy_put have an `if (uarg)` check.
