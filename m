Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987F477421B
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 19:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjHHRdr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 13:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjHHRcs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 13:32:48 -0400
Received: from mail.hugovil.com (mail.hugovil.com [162.243.120.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0FFF9A0;
        Tue,  8 Aug 2023 09:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hugovil.com
        ; s=x; h=Subject:Content-Transfer-Encoding:Mime-Version:Message-Id:Cc:To:From
        :Date:subject:date:message-id:reply-to;
        bh=oVjNdEpzZx0zgptzt6k7F+8X6mMIVOg3jSHvHicMgSs=; b=Lfi5oGJt92TrKiMkSKnj86OinS
        +2NhXXYIWmzJSO0UeZ3PNgNuIpJ5+9NRa7eG0PCO/lJdQfwxUt2xx/vRhWH14aJR7Zi3DsVcGlYSg
        4Re5W0tus87tNrarUoWozS2cyEX5CieZtJZ5HI5r4xZ229FkXIVmiG58p2T40oTpV57Q=;
Received: from modemcable061.19-161-184.mc.videotron.ca ([184.161.19.61]:35240 helo=pettiford)
        by mail.hugovil.com with esmtpa (Exim 4.92)
        (envelope-from <hugo@hugovil.com>)
        id 1qTPKm-0007qt-G1; Tue, 08 Aug 2023 12:13:25 -0400
Date:   Tue, 8 Aug 2023 12:13:23 -0400
From:   Hugo Villeneuve <hugo@hugovil.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org
Message-Id: <20230808121323.bc144c719eba5979e161aac6@hugovil.com>
In-Reply-To: <20230808134049.1407498-2-leitao@debian.org>
References: <20230808134049.1407498-1-leitao@debian.org>
        <20230808134049.1407498-2-leitao@debian.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 184.161.19.61
X-SA-Exim-Mail-From: hugo@hugovil.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: [PATCH v2 1/8] net: expose sock_use_custom_sol_socket
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.hugovil.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue,  8 Aug 2023 06:40:41 -0700
Breno Leitao <leitao@debian.org> wrote:

> Exposing function sock_use_custom_sol_socket(), so it could be used by
> io_uring subsystem.
> 
> This function will be used in the function io_uring_cmd_setsockopt() in
> the coming patch, so, let's move it to the socket.h header file.

Hi,
this description doesn't seem to match the code change below...

Hugo Villeneuve.


> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/net.h | 5 +++++
>  net/socket.c        | 5 -----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 41c608c1b02c..14a956e4530e 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -355,4 +355,9 @@ u32 kernel_sock_ip_overhead(struct sock *sk);
>  #define MODULE_ALIAS_NET_PF_PROTO_NAME(pf, proto, name) \
>  	MODULE_ALIAS("net-pf-" __stringify(pf) "-proto-" __stringify(proto) \
>  		     name)
> +
> +static inline bool sock_use_custom_sol_socket(const struct socket *sock)
> +{
> +	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
> +}
>  #endif	/* _LINUX_NET_H */
> diff --git a/net/socket.c b/net/socket.c
> index 1dc23f5298ba..8df54352af83 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2216,11 +2216,6 @@ SYSCALL_DEFINE4(recv, int, fd, void __user *, ubuf, size_t, size,
>  	return __sys_recvfrom(fd, ubuf, size, flags, NULL, NULL);
>  }
>  
> -static bool sock_use_custom_sol_socket(const struct socket *sock)
> -{
> -	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
> -}
> -
>  /*
>   *	Set a socket option. Because we don't know the option lengths we have
>   *	to pass the user mode parameter for the protocols to sort out.
> -- 
> 2.34.1
> 
