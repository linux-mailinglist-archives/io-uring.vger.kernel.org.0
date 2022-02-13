Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9C94B3CEB
	for <lists+io-uring@lfdr.de>; Sun, 13 Feb 2022 19:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiBMSrQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Feb 2022 13:47:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiBMSrQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Feb 2022 13:47:16 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B762957B2E
        for <io-uring@vger.kernel.org>; Sun, 13 Feb 2022 10:47:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id k60-20020a17090a4cc200b001b932781f3eso8064274pjh.0
        for <io-uring@vger.kernel.org>; Sun, 13 Feb 2022 10:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3GEOuunAFMNL8AEo9HmJmpUR8mPIVsqE+res+8El0fM=;
        b=4eca7VVZRmJiSjYv6Ns8a04QLOqTrrFxixfV0Wma7lDHfH4tWKhvqC/a/N2b48M4EP
         j5oUGLqaYjPv5CeVu1ZCHMXwfVg9XLOAHfwFKWFOJizYogRNmBZ/OxyJ2AKSEY3Q1K9X
         b4YLuClN814csuNWnWIRlCNmQWmjHnsioCVcS2o0HFp8xwTKSiXiMmrgCgbTQMNj7/sH
         qQBJ7YLlpuFDiEf3y3VaPi3YfrvptFaOIioVKyUnDBgn8hcDXwW5zjAKd+dofNGoaXU+
         lL1oSyRTGVQw+T3nUDezo235FlnSF3UonFRTnoYEKYGfSJPSedZPCOFXQW85ZXyZb6RI
         xD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3GEOuunAFMNL8AEo9HmJmpUR8mPIVsqE+res+8El0fM=;
        b=SR+FMYxWFx/7TWDVvSkfWM7fI7d9z/R08/laFVxnYcmkxYbQqRkCxVp2qGrZEJbVuV
         UczoJYTiYCU1YvgfmwXLqZbTOqEaJv6u0jkmq6Hyopu6L1VJP3rrisdfo8YsJoQSNttv
         aXX/fZ8/JH3GQoIf9gHQPl+upd1FPemOL7n7QqkQ9SUDkivpGdY2DsQxTMRxxTl5c2h0
         aNw/6IAkatoVLIjUx3XNfsXPwEWUO9CTByey/lgs/FyCD10+KDGcxjJKPC1e0o/inT5G
         VOTLLRciQclgnrEFsraaTnmBAhj8FDsdBPIG5ZzVwlq89LZ+5apPaBwro+e9x3jiyg7F
         Wp7g==
X-Gm-Message-State: AOAM530xGskTB8X7Y5e3CmUI+8E6XaOdO2OJjwywSQgIGvxPYdOtaGq7
        Zr38TQpuczsuMLvdxggss/cm6lgydra1CA==
X-Google-Smtp-Source: ABdhPJw41GEQLbkUoQcCujUWwOgDewFUK9yOZM6n+rSyKHUDZGImQsNHLewkusnvvrxGZuzh9+Jkhg==
X-Received: by 2002:a17:90a:4b0f:: with SMTP id g15mr10870349pjh.115.1644778028857;
        Sun, 13 Feb 2022 10:47:08 -0800 (PST)
Received: from [192.168.1.116] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l4sm34619237pfu.90.2022.02.13.10.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Feb 2022 10:47:08 -0800 (PST)
Subject: Re: napi_busy_poll
To:     Olivier Langlois <olivier@trillion01.com>,
        Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
 <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
 <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
 <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0e170619-cbcc-a7e9-e571-589783a70b70@kernel.dk>
Date:   Sun, 13 Feb 2022 11:47:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/22 12:51 PM, Olivier Langlois wrote:
> On Wed, 2022-02-09 at 11:34 +0800, Hao Xu wrote:
>> 在 2022/2/9 上午1:05, Jens Axboe 写道:
>>> On 2/8/22 7:58 AM, Olivier Langlois wrote:
>>>> Hi,
>>>>
>>>> I was wondering if integrating the NAPI busy poll for socket fds
>>>> into
>>>> io_uring like how select/poll/epoll are doing has ever been
>>>> considered?
>>>>
>>>> It seems to me that it could be an awesome feature when used
>>>> along with
>>>> a io_qpoll thread and something not too difficult to add...
>>>
>>> Should be totally doable and it's been brought up before, just
>>> needs
>>> someone to actually do it... Would love to see it.
>>>
>> We've done some investigation before, would like to have a try.
>>
> Hao,
> 
> Let me know if I can help you with coding or testing. I have done very
> preliminary investigation too. It doesn't seem like it would be very
> hard to implement but I get confused with small details.
> 
> For instance, the epoll implementation, unless there is something that
> I don't understand, appears to have a serious limitation. It seems
> like it would not work correctly if there are sockets associated to
> more than 1 NAPI device in the fd set. As far as I am concerned, that
> limitation would be ok since in my setup I only use 1 device but if it
> was necessary to be better than the epoll implementation, I am not
> sure at all how this could be addressed. I do not have enough kernel
> dev experience to find easy solutions to those type of issues...
> 
> Worse case scenario, I guess that I could give it a shot creating a
> good enough implementation for my needs and show it to the list to get
> feedback...

That is, in fact, usually the best way to get feedback on a change! I
believe there's even a law named for it, though local to Linux I
attribute it to akpm. Hence I'd encourage you to do that, best and
fastest way to make progress on the solution.

-- 
Jens Axboe

