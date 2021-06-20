Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8C3AE0CF
	for <lists+io-uring@lfdr.de>; Mon, 21 Jun 2021 00:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhFTWGs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 18:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhFTWGs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 18:06:48 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6B9C061574;
        Sun, 20 Jun 2021 15:04:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j10so2379768wms.1;
        Sun, 20 Jun 2021 15:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IzSrXtewhYOqMs5Tmqsg/YnrWWFNYZxCwJglCPlyEcQ=;
        b=VFUwAg2m/asIbeklfVIQjvhqGwRsKVtAWRcvaMd48Q8aBx4RiATc7r4Qjm8r2y8y6z
         6xLgEmZ++QkW8BSGzVeIK8TnIoYk2qEZU0+lCbfGwHga9ddWe++EGqgVbbDYMZT26yvX
         oJegg5nOjmxjggxynRe22HVPL6JleYXLRnSlDc3Be44AnXWrYBfmcjJITq9N6ZPdSilR
         xQm7he7pB0VNpHaUJ0436v8EtwKGfcjndfkTL95LNEygI5h86Qcmmk1Sh1OlMZqItg/+
         IsRXVr4BaGONNZ71lrRfVR6JbYvvR+XxA90OWvgPCD80ERr87GicuqXhpTZP/JMHi7g1
         +egg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IzSrXtewhYOqMs5Tmqsg/YnrWWFNYZxCwJglCPlyEcQ=;
        b=sXbbimrVhiZc218lW/tnR4h2dQNTt3E/XElezcTJk2sydIfIZcDf7kRItCZwPSezK2
         8uLYjFu9Js4YQVCo2kTc3KlhIluCSwt4SoucxixKKPOfEoMQTPIQjftmnfyd2KcHqd+o
         Ci9tzHra68C0gzGPhldnrns6dsh8e3/kJyLnjkghWyq2aYSUkivj5FEtvg5SCeZ4WS+M
         Ta+MSnimQuH7qn9DVZ17ThoNwBRsvKj1KEFJIINmPpVghKItQSpQl/R4ESjXIi3EfoLE
         GoGSOryZw/n71xs0c5XOtRCls+xeJ+R3Ih2Tm/b7ylJ11YABG3blTFvDaOkJYvTikoWN
         LdLw==
X-Gm-Message-State: AOAM533rPkFK/F6nI1zftC+NP3lj3YA4np/TZ4H6XpQy8Foa4jO0VI6o
        stJ5McHlMh9N4oXGtKZvivAee2r5hM36Zg==
X-Google-Smtp-Source: ABdhPJwY8lehgQ0mgPB34QAthz5fprB4rEyyoDzUlsrKbDQGlrNwF01QasukEuX2SoznxHjRCFL3WQ==
X-Received: by 2002:a1c:98c9:: with SMTP id a192mr23861458wme.66.1624226669856;
        Sun, 20 Jun 2021 15:04:29 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id j18sm15639711wrw.30.2021.06.20.15.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 15:04:29 -0700 (PDT)
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
 <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
 <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
 <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
 <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
 <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
 <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
 <7d9a481b-ae8c-873e-5c61-ab0a57243905@gmail.com>
 <f511d34b1a1ae5f76c9c4ba1ab87bbf15046a588.camel@trillion01.com>
 <bc6d5e7b-fc63-827f-078b-b3423da0e5f7@gmail.com>
 <be356f5f0e951a3b5a76b9369ed7715393e12a15.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <0c71b2fb-0068-888c-7112-e352633636f9@gmail.com>
Date:   Sun, 20 Jun 2021 23:04:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <be356f5f0e951a3b5a76b9369ed7715393e12a15.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 10:31 PM, Olivier Langlois wrote:
> On Sun, 2021-06-20 at 21:55 +0100, Pavel Begunkov wrote:
[...]
>>> creating a new worker is for sure not free but I would remove that
>>> cause from the suspect list as in my scenario, it was a one-shot
>>> event.
>>
>> Not sure what you mean, but speculating, io-wq may have not
>> optimal policy for recycling worker threads leading to
>> recreating/removing more than needed. Depends on bugs, use
>> cases and so on.
> 
> Since that I absolutely don't use the async workers feature I was
> obsessed about the fact that I was seeing a io worker created. This is
> root of why I ended up writing the patch.
> 
> My understanding of how io worker life scope are managed, it is that
> one remains present once created.

There was one(?) worker as such, and others should be able
to eventually die off if there is nothing to do. Something
may have changed after recent changes, I should update myself
on that

> In my scenario, once that single persistent io worker thread is
> created, no others are ever created. So this is a one shot cost. I was

Good to know, that's for confirming.


> prepared to eliminate the first measurement to be as fair as possible
> and not pollute the async performance result with a one time only
> thread creation cost but to my surprise... The thread creation cost was
> not visible in the first measurement time...
> 
> From that, maybe this is an erroneous shortcut, I do not feel that
> thread creation is the bottleneck.
>>
>>> First measurement was even not significantly higher than all the
>>> other
>>> measurements.
>>
>> You get a huge max for io-wq case. Obviously nothing can be
>> said just because of max. We'd need latency distribution
>> and probably longer runs, but I'm still curious where it's
>> coming from. Just keeping an eye in general
> 
> Maybe it is scheduling...
> 
> I'll keep this mystery in the back of my mind in case that I would end
> up with a way to find out where the time is spend...

-- 
Pavel Begunkov
