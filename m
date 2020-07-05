Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E49214FD2
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2020 23:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgGEVMy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Jul 2020 17:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgGEVMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Jul 2020 17:12:54 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1C2C08C5DF
        for <io-uring@vger.kernel.org>; Sun,  5 Jul 2020 14:12:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u18so827678pfk.10
        for <io-uring@vger.kernel.org>; Sun, 05 Jul 2020 14:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mm/FeRk+VterD5eerr9+vft2Gtim5uQSQoEoEmvX1M0=;
        b=Cw7UBemUqtAHuKz2287un9lydfsBrUi6DpmddxDJfUDffEPqvtoucQ5Uv11Goy6E/8
         uE9aXvqYkJaiJ0aN7shpym6uTB+GJC2OHH/EY0gcuGFUrr7hZrAKcgOIribrvB/YJS7R
         sX0GoDH3ixm2lmBcUpwmIHb34CkkpfkbW8zj1MhixGT+Jeza70/02R4qRrsUQyeuv+hr
         jqqHoYTzyDkJOzT9ma8gV5npnIMNVtbFNwYojPNRMkev5ZVzJYuhVp98pA3g2VpllmGq
         wnJklGWnuVm24dPoL0Rpg3BRN1InlprLFDRt26I6wkI5fb+oSpfUKzYoAqvGga3KfJPC
         YYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mm/FeRk+VterD5eerr9+vft2Gtim5uQSQoEoEmvX1M0=;
        b=GQNECsxAZ34MdmsegAwgJ/W2TRvszAI1uYdTIzqr8iVD0kx6pgOV3LtOfAgfk9v59I
         cLNausseu1wlCx2A10/QEJMkzozOrHSVUuYUwVI90URAvjITHnPU8Lgu3XXosrlJkX1L
         X+LeMtmZHCe20AQPhKPmm+d1EPlTwNTmowyHsgYgl5FCSUp1pEnmLppRN+BncdJZqVr4
         8wVKQz+velxoCz1j6LLz/uEwNXeNmhkdY8/HA5Waljb5vLCX9eu/mj9Kke9kYSEED87P
         9O0gbCSGkp6TcPbeH7sEBQLK9H64VoOJkXR1U2V2iH8yalV9bNEvgxn6srVTe5TtHn/u
         xO6A==
X-Gm-Message-State: AOAM533oy840AnMjbrjNYAwJ/91ZGxRCAbNhXX+0lPF1xdELXM9JLtYG
        u1WUoqmDDdKdh6H1yzOGHMzs0A==
X-Google-Smtp-Source: ABdhPJxhh4nVV1VgMx4IsEJzu3l007ZbKTvj0qiykpk9JWyZxVQNrx8b0pkMPt7BCzasm0bgo9J7iA==
X-Received: by 2002:a65:584e:: with SMTP id s14mr36628575pgr.151.1593983573593;
        Sun, 05 Jul 2020 14:12:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h100sm16913840pjb.46.2020.07.05.14.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 14:12:52 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, hch@infradead.org, Damien.LeMoal@wdc.com,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        mb@lightnvm.io, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1593974870-18919-1-git-send-email-joshi.k@samsung.com>
 <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200705210947.GW25523@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <239ee322-9c38-c838-a5b2-216787ad2197@kernel.dk>
Date:   Sun, 5 Jul 2020 15:12:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200705210947.GW25523@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/5/20 3:09 PM, Matthew Wilcox wrote:
> On Sun, Jul 05, 2020 at 03:00:47PM -0600, Jens Axboe wrote:
>> On 7/5/20 12:47 PM, Kanchan Joshi wrote:
>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>
>>> For zone-append, block-layer will return zone-relative offset via ret2
>>> of ki_complete interface. Make changes to collect it, and send to
>>> user-space using cqe->flags.
>>>
>>> Signed-off-by: Selvakumar S <selvakuma.s1@samsung.com>
>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>> ---
>>>  fs/io_uring.c | 21 +++++++++++++++++++--
>>>  1 file changed, 19 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 155f3d8..cbde4df 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -402,6 +402,8 @@ struct io_rw {
>>>  	struct kiocb			kiocb;
>>>  	u64				addr;
>>>  	u64				len;
>>> +	/* zone-relative offset for append, in sectors */
>>> +	u32			append_offset;
>>>  };
>>
>> I don't like this very much at all. As it stands, the first cacheline
>> of io_kiocb is set aside for request-private data. io_rw is already
>> exactly 64 bytes, which means that you're now growing io_rw beyond
>> a cacheline and increasing the size of io_kiocb as a whole.
>>
>> Maybe you can reuse io_rw->len for this, as that is only used on the
>> submission side of things.
> 
> I'm surprised you aren't more upset by the abuse of cqe->flags for the
> address.

Yeah, it's not great either, but we have less leeway there in terms of
how much space is available to pass back extra data.

> What do you think to my idea of interpreting the user_data as being a
> pointer to somewhere to store the address?  Obviously other things
> can be stored after the address in the user_data.

I don't like that at all, as all other commands just pass user_data
through. This means the application would have to treat this very
differently, and potentially not have a way to store any data for
locating the original command on the user side.

> Or we could have a separate flag to indicate that is how to interpret
> the user_data.

I'd be vehemently against changing user_data in any shape or form.
It's to be passed through from sqe to cqe, that's how the command flow
works. It's never kernel generated, and it's also used as a key for
command lookup.

-- 
Jens Axboe

