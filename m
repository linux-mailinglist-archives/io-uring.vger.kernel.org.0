Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCE570A335
	for <lists+io-uring@lfdr.de>; Sat, 20 May 2023 01:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjESXML (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 19:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjESXMK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 19:12:10 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418CF12B;
        Fri, 19 May 2023 16:12:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F2F7B3200947;
        Fri, 19 May 2023 19:12:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 19 May 2023 19:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1684537922; x=1684624322; bh=YZ
        LCSCf9nmog+DmduXswErfeUg+OgoHMCyoM+PMhCZ0=; b=bkLwL4bYsFwzHiKfx+
        ayFRWRZ7LP5ItCfw4U9/kdLeuffdISrLHeF98Rhinv2madoEq6w1g3GcyWQ2zvCg
        TqoauZufdta1lUTeizo+UDG2GC2W0ue7c6LZn08S2UPeTK0cKOGFoxRY1g9e28vR
        Rb5072bAlXLN0XWg9iwmdiDuz5b2r+cjFEIu0fCqyBW0zUPhUlyjoCKSHGJFWlQm
        eGJvboJnvd/Uxd5t0HbN8GGQ8IwPLAILr+wwpmxZryYMdQnhz8kj3jQ43/J7lbhx
        9/82nK5cYqcgT/Q5ct0jCzUzaTLpDPD2K20c56fBFq2NG3U1HKIFExjmVSqIWO8z
        JEiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1684537922; x=1684624322; bh=YZLCSCf9nmog+
        DmduXswErfeUg+OgoHMCyoM+PMhCZ0=; b=CmNxj6q89DgZ9TohaWJmq+rs0v/Cf
        6IYJUAQdlzzDb6JK8LEJcNxSAAivT4aIh+CurWinVoLJlU5u70oIhXVgMPMlOuz9
        bSGb+aAbM/3Z6W6LcxQmXLTaSnYzmpxaJtl4DYjeuNzpIXV7CWDYNeshRuYe/qiz
        yH45hyL+5a2LZA4mtVZ1iNfRb0AaiQZg4u1pvv/E1BihVsRFzQwgzDKVY9T37vLl
        dPpV5PKXYBbwTfq4G5u/lax/ULeRi3NypW8rFCxQGEdBJOjqlA6buXxdB6BMQULd
        kAdZ70jOO4KSCiuYg0y/Sgfg7A/gAe0qjWPIUnMBQCS0ET2umcjiY/a3Q==
X-ME-Sender: <xms:QgJoZKKkjWuyhuv5qntZlBpkjxdawfe7A6ax_QXtwihVQA1134wr2A>
    <xme:QgJoZCLBhparMPvHEUYU8BB_z07RK5s9aXvWrAeDo0Q61MAJmfjW4wsl8anQQCKbI
    gAhupgF7ocMbcPipsI>
X-ME-Received: <xmr:QgJoZKsfnafINdl15T3km_VXoAOYgNNH_AGI_jYZA-cbNmWOVglL6gm2U01mgwQDK1PUTvnb2qp3C0xRoztgxxMoX0MnDyAsuNlNckgCo6or>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeiiedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:QgJoZPaJ4UiKOeyITAkkQh1eA1AG6f5bXwzwWyg1DkoM5ikS7KaQxA>
    <xmx:QgJoZBaGBmmeebvVLR4lf8qJZQ9AJxLZqEyNu7_k-95KjorVoGoSvA>
    <xmx:QgJoZLB3bcX8NPFipyB6RHXzpLed6TIcbvIIdhjlP1ZQa0KXLWeMHw>
    <xmx:QgJoZEy5qip5sjjTIFKFhrXMEwwTwybPDCT_pyVE5SEB8PmGV6ATHQ>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 May 2023 19:12:01 -0400 (EDT)
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-5-shr@devkernel.io>
 <4b05488a-6a12-2f23-f490-79dcc2bc5d59@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
        olivier@trillion01.com
Subject: Re: [PATCH v13 4/7] io-uring: add napi busy poll support
Date:   Fri, 19 May 2023 16:11:30 -0700
In-reply-to: <4b05488a-6a12-2f23-f490-79dcc2bc5d59@kernel.dk>
Message-ID: <qvqwr0rbx6f5.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 5/18/23 3:17?PM, Stefan Roesch wrote:
>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index c90e47dc1e29..0284849793bb 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -15,6 +15,7 @@
>>
>>  #include "io_uring.h"
>>  #include "refs.h"
>> +#include "napi.h"
>>  #include "opdef.h"
>>  #include "kbuf.h"
>>  #include "poll.h"
>> @@ -631,6 +632,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>>  		__io_poll_execute(req, mask);
>>  		return 0;
>>  	}
>> +	io_napi_add(req);
>>
>>  	if (ipt->owning) {
>>  		/*
>
> One thing that bothers me a bit here is that we then do:
>
> static inline void io_napi_add(struct io_kiocb *req)
> {
> 	struct io_ring_ctx *ctx = req->ctx;
>
> 	if (!READ_ONCE(ctx->napi_busy_poll_to))
> 		return;
>
> 	__io_napi_add(ctx, req->file);
> }
>
> which will do __io_napi_add() for any file type, even though we really
> just want sockets here. I initially thought we could add a fast flag for
> the type (like we do for IS_REG), but I think we can just do this
> incremental and call it good enough.
>
> Unfortunately sock_from_file() is also a function call... But not a huge
> problem.
>
>
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index 5790b2daf1d0..8ec016899539 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -33,18 +33,13 @@ static struct io_napi_entry *io_napi_hash_find(struct hlist_head *hash_list,
>  	return NULL;
>  }
>
> -void __io_napi_add(struct io_ring_ctx *ctx, struct file *file)
> +void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock)
>  {
>  	struct hlist_head *hash_list;
>  	unsigned int napi_id;
> -	struct socket *sock;
>  	struct sock *sk;
>  	struct io_napi_entry *e;
>
> -	sock = sock_from_file(file);
> -	if (!sock)
> -		return;
> -
>  	sk = sock->sk;
>  	if (!sk)
>  		return;
> diff --git a/io_uring/napi.h b/io_uring/napi.h
> index 69c1970cbecc..08cee8f4c9d1 100644
> --- a/io_uring/napi.h
> +++ b/io_uring/napi.h
> @@ -15,7 +15,7 @@ void io_napi_free(struct io_ring_ctx *ctx);
>  int io_register_napi(struct io_ring_ctx *ctx, void __user *arg);
>  int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg);
>
> -void __io_napi_add(struct io_ring_ctx *ctx, struct file *file);
> +void __io_napi_add(struct io_ring_ctx *ctx, struct socket *sock);
>
>  void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
>  		struct io_wait_queue *iowq, struct timespec64 *ts);
> @@ -53,46 +53,51 @@ static inline void io_napi_busy_loop(struct io_ring_ctx *ctx,
>  static inline void io_napi_add(struct io_kiocb *req)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
> +	struct socket *sock;
>
>  	if (!READ_ONCE(ctx->napi_busy_poll_to))
>  		return;
>
> -	__io_napi_add(ctx, req->file);
> +	sock = sock_from_file(req->file);
> +	if (sock)
> +		__io_napi_add(ctx, sock);
>  }

I'll add the above changes to the next version.
