Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45459708D4D
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 03:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjESB0x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 May 2023 21:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjESB0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 May 2023 21:26:52 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9E2E4C
        for <io-uring@vger.kernel.org>; Thu, 18 May 2023 18:26:49 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d132c6014so374841b3a.0
        for <io-uring@vger.kernel.org>; Thu, 18 May 2023 18:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684459609; x=1687051609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5r4KJaITrVh9Py15yenHZ9ZMZWiLMvtjNeFsJn/U8g=;
        b=Rw7oKCsTW/hkhZQ2Kqzru1mkVFk5p2kgOzPyPPk8P3gqxHqsHyXkmi8Rj3WGAxDX0r
         WT1qQpNdYjCCyrV8wW6QcSVKU5V/TNLg6Ug5/OoPlFn1tonZmOlfdKoG29Pv+wxtY6F8
         tWr219rWdeib/rE4jiqRAbsBOlNlDo3dMEe/kBfsA/oYXMbEuTXPaA8DOQJtTB8ihUyH
         eyNaVLhZ4wNQj/keLFrZvakEvjqupzgvOcb0UDCQ8nfZ1Xh/Wdc670BJs8QPch9E0A0a
         jh/txVUREnFwdnhPFTLIG/xKwFg0MdGvM2dz7weaz1vlfD7IMGEEqnZtS2HPOQWKZ4K2
         RQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684459609; x=1687051609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5r4KJaITrVh9Py15yenHZ9ZMZWiLMvtjNeFsJn/U8g=;
        b=Eu3BtDU5pXHCwUObjdRnVWbKCThvu0wSrGCnR9qLkWssUWzGUgRnQelH2axqYc7yMg
         EeZ0Mj5aEFDFlXd4zsPTDqoEH1Pt6UNR3lTVpMFY8u1vY1YxDr9jYVHDt3byuFpPrSM4
         uRvWYAXgei+r3ize6q+MvAwwBVlzSkK8XshzlKb1sILD4/AT4SlGza35rQKeOFIxfZ/v
         vX9s5kxieT5/dMClXAAleW9u/kZKvb5kjIL1SjbXMDGiMITe8HUgCK23tyDRB4ux6Ccb
         8pxfXaOVeid/UKBxJn9A1fJYZhDbfXvxNqpfJppBw1Hu8WAtyBfgOToZ8mGWBicRRnfE
         PRzQ==
X-Gm-Message-State: AC+VfDzha/e4vnNJVHxF5tKIFe7teJ1iRggjjEb5ms1HQ4t4VdZMdOsd
        DO1OV70I56TQLKEKcpM6f/ORTw==
X-Google-Smtp-Source: ACHHUZ5K7fFYDhVlTN1E7dU7D3KJF0SQo/iKyU3E6hJ9Frs5BMeGsGbj9Qqfbv3UiJOWYEXohx7ALw==
X-Received: by 2002:a17:902:c944:b0:1ac:6b92:a775 with SMTP id i4-20020a170902c94400b001ac6b92a775mr1016124pla.6.1684459609118;
        Thu, 18 May 2023 18:26:49 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c9-20020a170903234900b001acaf7e26bbsm2109407plh.53.2023.05.18.18.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 18:26:48 -0700 (PDT)
Message-ID: <4b05488a-6a12-2f23-f490-79dcc2bc5d59@kernel.dk>
Date:   Thu, 18 May 2023 19:26:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v13 4/7] io-uring: add napi busy poll support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
        olivier@trillion01.com
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-5-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230518211751.3492982-5-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/23 3:17?PM, Stefan Roesch wrote:
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index c90e47dc1e29..0284849793bb 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -15,6 +15,7 @@
>  
>  #include "io_uring.h"
>  #include "refs.h"
> +#include "napi.h"
>  #include "opdef.h"
>  #include "kbuf.h"
>  #include "poll.h"
> @@ -631,6 +632,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>  		__io_poll_execute(req, mask);
>  		return 0;
>  	}
> +	io_napi_add(req);
>  
>  	if (ipt->owning) {
>  		/*

One thing that bothers me a bit here is that we then do:

static inline void io_napi_add(struct io_kiocb *req)
{
	struct io_ring_ctx *ctx = req->ctx;

	if (!READ_ONCE(ctx->napi_busy_poll_to))
		return;

	__io_napi_add(ctx, req->file);
}

which will do __io_napi_add() for any file type, even though we really
just want sockets here. I initially thought we could add a fast flag for
the type (like we do for IS_REG), but I think we can just do this
incremental and call it good enough.

Unfortunately sock_from_file() is also a function call... But not a huge
problem.


diff --git a/io_uring/napi.c b/io_uring/napi.c
index 5790b2daf1d0..8ec016899539 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -33,18 +33,13 @@ static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
 	return NULL;
 }
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
+void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
 {
 	struct hlist_head *hash_list;
 	unsigned int napi_id;
-	struct socket *sock;
 	struct sock *sk;
 	struct io_napi_entry *e;
 
-	sock = sock_from_file(file);
-	if (!sock)
-		return;
-
 	sk = sock->sk;
 	if (!sk)
 		return;
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 69c1970cbecc..08cee8f4c9d1 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -15,7 +15,7 @@ void io_napi_free(struct io_ring_ctx *ctx);
 int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
+void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
 
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, struct timespec64 *ts);
@@ -53,46 +53,51 @@ static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
 static inline void io_napi_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct socket *sock;
 
 	if (!READ_ONCE(ctx->napi_busy_poll_to))
 		return;
 
-	__io_napi_add(ctx, req->file);
+	sock = sock_from_file(req->file);
+	if (sock)
+		__io_napi_add(ctx, sock);
 }
 

-- 
Jens Axboe

