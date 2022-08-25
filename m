Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C762B5A0DAE
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 12:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbiHYKPN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 06:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239952AbiHYKPK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 06:15:10 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050319FED
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 03:15:02 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u15so29891079ejt.6
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 03:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=RJgPjT3mp3PF+G79ZsUeiLchnVzSl5vdX/OczrPX7MY=;
        b=YKvnxh+9L2PoTyzVcxxNnCYiIWn6KgdMWZ1GVZCsHwDvoz+skrZIm9MElFOuFVRr58
         J2rjah8fEVa1HYS/2F3IBQ/mFqz0ON2/r43iaBb8WH8Rsix+Z8gJ0far3SD8Q3Ri0eLH
         9j3nHrsIiUFT3aD06UFgy5dHNUzm7Htl7224hZ0JD4I/gVdsRi6HvCTRKwYC9Y9rtlxi
         Uc6lGFfYHoymYdqYnrfY4A/N+U4Too+XBfGgr+tQ6ykAoZlkrJuO0IiDCvz2xTfxDSH4
         CSGpsJKFMIvMHz6YtV1c5eDAE5Ek+1420nzWm4tuGJul/guGdnU+9xZ9oWc6XVKhSijx
         pdkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RJgPjT3mp3PF+G79ZsUeiLchnVzSl5vdX/OczrPX7MY=;
        b=Y7nyKe5aKliYc4iDnYDSHSyy4aCfux/f8mqYA6JFEtRKzt9q239L11BjhmSjuT+RuW
         gJz9WXkzMV+GNkzonYejOULSYjH/ZqPW7f4Z/s0MaywfiS0yz94reuSBzNcvtXB5HIos
         j+Z3qSaRrYW68EbF2xOJyVinSHyJROgqaQO0jVUkyPEse4gtzpGx2buBlu7Lp+BzMiO+
         wpJ/MQLsp/rldOHVhRRiOQsHXz0AYkU1gjvh6hWlEPwvlEy5/nu2mo9EyNUW+uAx4A9t
         ME0cKhifwy2+gJOe1BRl3JdrpRB7S4+j96TwUnHBhVB7q/TROOUHLBC6rohZkekfqEQI
         oVCQ==
X-Gm-Message-State: ACgBeo3O+yrkPO3eJNv06f0WxeBYGGLMpMOShW9DDr86QF3Ko8TCn/8p
        U8GGdA1MDvvetbYZgoVr9Rt/7KZpmvQ96g==
X-Google-Smtp-Source: AA6agR73kharXRlLiGW+SRtlivaGzj1aH7l2+HXvo+PDkbywpXcC3PH/sHgOD0DYZYxexEz7nHN2Ew==
X-Received: by 2002:a17:906:ee8e:b0:730:3646:d178 with SMTP id wt14-20020a170906ee8e00b007303646d178mr2015385ejb.426.1661422499918;
        Thu, 25 Aug 2022 03:14:59 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:6d47])
        by smtp.gmail.com with ESMTPSA id s21-20020a17090699d500b0073dc8d0eabesm1076537ejn.15.2022.08.25.03.14.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 03:14:59 -0700 (PDT)
Message-ID: <e77d4686-6a2d-fabf-0e25-b10bd9262984@gmail.com>
Date:   Thu, 25 Aug 2022 11:13:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] io_uring/net: fix uninitialised addr
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <52763f964626ec61f78c66d4d757331d62311a5b.1661421007.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <52763f964626ec61f78c66d4d757331d62311a5b.1661421007.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/22 11:11, Pavel Begunkov wrote:
> Don't forget to initialise and set addr in io_sendzc(), so if it goes
> async we can copy it.

Jens, can you amend it into the last commit?
("io_uring/net: save address for sendzc async execution")


> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/net.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 4eaeb805e720..0af8a02df580 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -975,7 +975,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
>   
>   int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>   {
> -	struct sockaddr_storage __address, *addr;
> +	struct sockaddr_storage __address, *addr = NULL;
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
>   	struct io_notif_slot *notif_slot;
> @@ -1012,12 +1012,13 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>   		if (req_has_async_data(req)) {
>   			struct io_async_msghdr *io = req->async_data;
>   
> -			msg.msg_name = &io->addr;
> +			msg.msg_name = addr = &io->addr;
>   		} else {
>   			ret = move_addr_to_kernel(zc->addr, zc->addr_len, &__address);
>   			if (unlikely(ret < 0))
>   				return ret;
>   			msg.msg_name = (struct sockaddr *)&__address;
> +			addr = &__address;
>   		}
>   		msg.msg_namelen = zc->addr_len;
>   	}

-- 
Pavel Begunkov
