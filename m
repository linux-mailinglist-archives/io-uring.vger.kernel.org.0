Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505231FC11F
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 23:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFPVsZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 17:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPVsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 17:48:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE4EC061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 14:48:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h5so199406wrc.7
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zHs1Z5hE6qFcUpjkWxzC2BHUTs7UjIvj+m9/uLdkDPE=;
        b=BahNy/JXp9jAIi+IEtYp64ackAqsNeUASIloxhcU0WEkJOksPHbX31M38nYTwjA5Rr
         dTv9JIbC/Z4O+xpLhVPyZSHvVmM5ubCiBxAiv7J0OZAl0knNZncCu/3hQ6/82+UQHz7f
         V2CHxUu5FtrZA/pzr1apT5Bn5jkWqtB7L/ZA/wZ07CgjyYFMHy5zGsx8tl3qtuQr9L7D
         rYxutTgfDXdzQqPIDS10c4MnRS3c0KChZl1mcDWhc232acOie8IPNWDu++ZIEg5VhHZj
         0pGlLGvXGOTKjq/o2xG3gmLU4OuSshYCAe59Od1cPe0EgiFskYpklqF15Gevcku7arlJ
         zdZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zHs1Z5hE6qFcUpjkWxzC2BHUTs7UjIvj+m9/uLdkDPE=;
        b=qJ9ju+m1zYO5uskPXmeGX62WslGZv//qzujt5ooQdXJcz3AS2hzckDiHTTvfxhVn+W
         jIIUYfbPWiJMXOWbOMDnHBiiLmssHkdw4WgaLWGXjsrBvoD8fvC0yPuvFr5P3etqZX91
         Cc/9K7/8J2bNihS2OrW2MXOVOcAmJmtDm6/MZ5rSEeNzg/6u6tEiv8BWqTqSFDDyIbuM
         mH6xDeVQPn8Oj5oC7hbpyprvb4RUz1YaZXh91vRIi8GkKZgwq2a/u7nsZTN77DxAeMkm
         zL42GrKjGCYSvI7/aGXsL8ETiXWU05RstJ543yIO1FFGadYZs8nMCvZaIwAdUt1Op1CY
         LsrQ==
X-Gm-Message-State: AOAM532Xzqdcy572z9A49Rv+0TbVJr6qrcA1uN9L1FMZX5G0WXMY2gVf
        ogXR7IEUmbfSVvPLlBUMx1OQXXGr
X-Google-Smtp-Source: ABdhPJxEiKIxseY2KpHt1bcxR26Fj4yy6I0IUtHdQIgGqR7Hb2LOIKLU2XEgyCyX3yHP8+5YryRKEQ==
X-Received: by 2002:adf:97cb:: with SMTP id t11mr5053544wrb.314.1592344103143;
        Tue, 16 Jun 2020 14:48:23 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id p16sm33570288wru.27.2020.06.16.14.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 14:48:22 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591929018-73954-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1591929018-73954-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <9e251ae9-ffe1-d9ea-feb5-cb9e641aeefb@kernel.dk>
 <f6d3c7bb-1a10-10ed-9ab3-3d7b3b78b808@kernel.dk>
 <ec18b7b6-a931-409b-6113-334974442036@linux.alibaba.com>
 <b98ae1ed-c2b5-cfba-9a58-2fa64ffd067a@kernel.dk>
 <7a311161-839c-3927-951d-3ce2bc7aa5d4@linux.alibaba.com>
 <967819fd-84c5-9329-60b6-899a2708849e@kernel.dk>
 <659bda5d-2da0-b092-9a66-1c4c4d89501a@kernel.dk>
 <5fc59f0b-7437-ac2c-a142-8cd7a532960c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 1/2] io_uring: change the poll events to be 32-bits
Message-ID: <d0d05303-e31c-7113-9805-df5602ecd86d@gmail.com>
Date:   Wed, 17 Jun 2020 00:46:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5fc59f0b-7437-ac2c-a142-8cd7a532960c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/06/2020 22:21, Jens Axboe wrote:
> 
> Nah this won't work, as the BE layout will be different. So how about
> this, just add a 16-bit poll_events_hi instead. App/liburing will set
> upper bits there. Something like the below, then just needs the
> exclusive wait change on top.
> 
> Only downside I can see is that newer applications on older kernels will
> set EPOLLEXCLUSIVE but the kernel will ignore it. That's not a huge
> concern for this particular bit, but could be a concern if there are
> others that prove useful.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index de1175206807..a9d74330ad6b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4809,6 +4809,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>  	events = READ_ONCE(sqe->poll_events);
>  	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
>  
> +	if (READ_ONCE(sqe->poll_events_hi) & EPOLLEXCLUSIVE)

poll_events_hi is 16 bit, EPOLLEXCLUSIVE is (1 << 28). It's always false.
Do you look for something like below?


union {
	...
	__u32		fsync_flags;
	__u16		poll_events;  /* compatibility */
	__u32		poll32_events; /* word-reversed for BE */
};

u32 evs = READ_ONCE(poll32_events);
if (BIG_ENDIAN)
	evs = swahw32(evs); // swap 16-bit halves

// use as always, e.g. if (evs & EPOLLEXCLUSIVE) { ... }

> +		poll->events |= EPOLLEXCLUSIVE;
> +
>  	io_get_req_task(req);
>  	return 0;
>  }
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 92c22699a5a7..e6856d8e068f 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -31,7 +31,10 @@ struct io_uring_sqe {
>  	union {
>  		__kernel_rwf_t	rw_flags;
>  		__u32		fsync_flags;
> -		__u16		poll_events;
> +		struct {
> +			__u16	poll_events;
> +			__u16	poll_events_hi;
> +		};
>  		__u32		sync_range_flags;
>  		__u32		msg_flags;
>  		__u32		timeout_flags;
> 

-- 
Pavel Begunkov
