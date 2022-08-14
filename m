Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BC3591F46
	for <lists+io-uring@lfdr.de>; Sun, 14 Aug 2022 11:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiHNJb1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Aug 2022 05:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiHNJb0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Aug 2022 05:31:26 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1ADCE0
        for <io-uring@vger.kernel.org>; Sun, 14 Aug 2022 02:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=nbWqST+XP2a7+u9AWI2dutjI764cPEu2zgT1SGkvhZE=; b=MkYS7sMf2V5IFRuwIYZ42DFHzs
        neaCwRGY84hG7aYxEhzWO/+0P0zuME8+C/WMa5Nu0nScuGTPZkfn32LtMu1e6njgWOUOsGnX4MNJH
        bvVIZdMF2VX7QDQqKjLvpQyvW1KO0xBFuPbTWLFB3VI7Bm09RHPnarl9hBU0cFB6MfuSRHw5+iikK
        I4i2A0fvPRlWyeOOaYnJ7rjRkiIPcJizw54C8kILKm1PBQ9bp8Ka81c68gHR4JWMQTfeK/gagsyQN
        bSwxB5AYJKa5xzvcDoWawWLmFJyfg46c+F+txJCTnf3eSp1SuDmJFgVhGcY+rStWpVAI6ZxMllD+4
        nI5OEqFNjNz1TeYTOvJmJ6GqC7gONIcb/x4gfC9mZWekjUBPC9YDJXL926B50nkGiOJlxgBeVB4Vp
        57Q8uZsYU7V4lgCsyzXSVfXS3QVzLfRoRgU66uZdoIU19HmPy0MeRUXRy38tqCy/87gg50KjRptzi
        Zkqs4EcuVCtRCweu39jyJs6T;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oN9xq-0005oS-Jn; Sun, 14 Aug 2022 09:31:22 +0000
Message-ID: <064b4920-5441-1ae2-b492-cb75f7796d8d@samba.org>
Date:   Sun, 14 Aug 2022 11:31:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/1] io_uring/net: send retry for zerocopy
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

> io_uring handles short sends/recvs for stream sockets when MSG_WAITALL
> is set, however new zerocopy send is inconsistent in this regard, which
> might be confusing. Handle short sends.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/net.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 32fc3da04e41..f9f080b3cc1e 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -70,6 +70,7 @@ struct io_sendzc {
>   	unsigned			flags;
>   	unsigned			addr_len;
>   	void __user			*addr;
> +	size_t				done_io;
>   };
>   
>   #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
> @@ -878,6 +879,7 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   
>   	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>   	zc->addr_len = READ_ONCE(sqe->addr_len);
> +	zc->done_io = 0;
>   
>   #ifdef CONFIG_COMPAT
>   	if (req->ctx->compat)
> @@ -1012,11 +1014,23 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>   	if (unlikely(ret < min_ret)) {
>   		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>   			return -EAGAIN;
> -		return ret == -ERESTARTSYS ? -EINTR : ret;
> +		if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
> +			zc->len -= ret;
> +			zc->buf += ret;
> +			zc->done_io += ret;
> +			req->flags |= REQ_F_PARTIAL_IO;

Don't we need a prep_async function and/or something like
io_setup_async_msg() here to handle address?

metze

