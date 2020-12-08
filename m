Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E084B2D2EA0
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 16:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgLHPvj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 10:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730048AbgLHPvi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 10:51:38 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3FAC061749
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 07:50:58 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id i9so17371599ioo.2
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 07:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qvM7VaQOJMIgrDXRaJiMwzUNtVEGM98Cplm0mV8PJ+o=;
        b=mb7mTrD+u196f1zL1WQTA452gEBzJfKE8I6lchPxVqpUmWxd74MgUUDh6xJwUWLDQk
         L4dKbpJbGyxtluOaAlx5bFIdXq1puJLS7WReZz8WMYGAeXuLcfAkmAWK31CER+zs7erJ
         ELkCXanIm8WXaoVtIHUjQSPGfATpYi/VFX3eyIrMM0GmGXbSiCFRKe8fmerkGWM0dk8X
         MR+MnbQ2upaEAWQ8OyJD4XGv3etT6l6Xhefwr00ecdzBJ1PcR9zrgQw081/d9kghnl8u
         SGaNRuFIbDH3RqYof4WayLgRpaGK+kPe+next9FdM8qmLNs20O3x0jnVxS68LigWSYI7
         l+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qvM7VaQOJMIgrDXRaJiMwzUNtVEGM98Cplm0mV8PJ+o=;
        b=gOVwRDec0UdyZTUjTAji8wcw/RIim9C48tVIOXetnIG1HbhCgNvDTR39pJnV6bw20E
         i0YiA3Svxhgdh/Jp9ssgEE7ckSJv9sDnnwyGDSLcTXsVq7qlrRHjQPdY/bRj5OJn+v57
         ZBRbXT+4lBe7cKjZepvTm1j6IlkP2m3NVLHOSGUbCbGv0jayoF9TMwHceMuHUTYjYwCi
         HRSEuUJZugqc9rd9hVe9paj9rp0ROBgu4FmhgR9G74AJYBoVL51U0xh+wRA93CqNMpGD
         yhGDEu2GY5tbHBhMExF9kW6WCJso/LOeOMuShxYfBn9DymwlgWLPpzqOWQo6LT5QhhIy
         07Wg==
X-Gm-Message-State: AOAM530DHbTNOqehbofHCohgutUEKH0UIa1w1ze9xjG9rBQfMXeu7u1o
        22UcjgnReL5qRNB6pjsOyotX1Q==
X-Google-Smtp-Source: ABdhPJxew2H6oPImcx1UTFqAlaOtXnq/TVGpa4KV6v/19nXkgo6WmAWea0voBxMMS6Z1a48AfR5mOQ==
X-Received: by 2002:a6b:f112:: with SMTP id e18mr25313535iog.195.1607442657838;
        Tue, 08 Dec 2020 07:50:57 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n1sm9820485ilm.72.2020.12.08.07.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 07:50:57 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix file leak on creating io ctx
To:     Hillf Danton <hdanton@sina.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+71c4697e27c99fddcf17@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20201207081558.2361-1-hdanton@sina.com>
 <20201208102851.2585-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <439d735f-3cbb-a84e-4c43-0a6841f76615@kernel.dk>
Date:   Tue, 8 Dec 2020 08:50:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208102851.2585-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/20 3:28 AM, Hillf Danton wrote:
> On Mon, 7 Dec 2020 09:42:21 -0700 Jens Axboe wrote:
>> On 12/7/20 1:15 AM, Hillf Danton wrote:
>>> @@ -9207,12 +9208,14 @@ err_fd:
>>>  #if defined(CONFIG_UNIX)
>>>  	ctx->ring_sock->file = file;
>>>  #endif
>>> -	if (unlikely(io_uring_add_task_file(ctx, file))) {
>>> -		file = ERR_PTR(-ENOMEM);
>>> -		goto err_fd;
>>> +	ret = io_uring_add_task_file(ctx, file);
>>> +	if (ret) {
>>> +		fput(file);
>>> +		put_unused_fd(fd);
>>> +		goto err;
>>>  	}
>>>  	fd_install(ret, file);
>>> -	return ret;
>>> +	return 0;
>>
>> You're installing the return value from io_uring_add_task_file() in the
>> fd table, and then returning '0' for the fd...
> 
> I canot find phrases to describe the stupid mistake in my patch.
> Thank you so much for pointing it out.

This one is still utterly broken, and (again) cannot have been even
tested in the most basic way. So let's focus on not how things are
phrased, but proper patch etiquette:

- Always (ALWAYS) test your patches. There's no excuse for not doing
  so, and you are blacklisting yourself and ruining your reputation
  by sending garbage that doesn't even pass basic functionality.

- If something isn't tested at all, make it VERY clear that this is
  the case. Generally that's done by putting RFC in there and also
  stating that this is just for discussion, it's not a patch that
  is proposed for inclusion.

- Slow down! I see you sent a patch 10 min after this one, with no
  extra notice in there why that was the case. It's clearly because
  you figured out that this hasty send was bad.

I'd really like to get this in for 5.10, but I'd almost feel better
just redoing the patch myself to ensure it doesn't have other silly
errors in there. Don't put yourself in that position.


> @@ -9207,12 +9208,14 @@ err_fd:
>  #if defined(CONFIG_UNIX)
>  	ctx->ring_sock->file = file;
>  #endif
> -	if (unlikely(io_uring_add_task_file(ctx, file))) {
> -		file = ERR_PTR(-ENOMEM);
> -		goto err_fd;
> +	ret = io_uring_add_task_file(ctx, file);
> +	if (ret) {
> +		fput(file);
> +		put_unused_fd(fd);
> +		goto err;
>  	}
> -	fd_install(ret, file);
> -	return ret;
> +	fd_install(fd, file);
> +	return 0;

You're still returning '0' for the fd. 


-- 
Jens Axboe

