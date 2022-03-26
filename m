Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69354E843F
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 21:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiCZU6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Mar 2022 16:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiCZU6t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Mar 2022 16:58:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EECBB62
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 13:57:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso11808292pjb.5
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=O2vsSs9b35Pg+c53FldzhjQKaG5NPugkMU3AjWFqsa4=;
        b=vQamxu036dqCfqfr2SAK+Bu7+6NnR8euTIE5U8jGd7333W9yZeg1r4NO9EnuAncWfQ
         vlmImEJVCGTPRU2oJ/2b26TP9iOSECRkzGh+wpYdPwEbR/bFVcd95ReyPoSv9syDFJJn
         7DytMJMjUQ3OxwPVxJwqnVL86usivTGkKrHWLTEuqwudyFcnmtL4v3jxtNRVplq8tYo1
         YxSbfg0xaYBZVetTa/KVFBGL6HMClcIRWm74mDtUXtzA7lZXUiV+y2Azh05Ryd9mJSHq
         pqVZQg98jmRFn3znrSOkCw5eY8sXYRQ0vd80eNsNTa9zawYymxMybisGpxRrmiZdcbe8
         zt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O2vsSs9b35Pg+c53FldzhjQKaG5NPugkMU3AjWFqsa4=;
        b=LPw2Le3GsIZMEfY2u8rfdpej74NqHm7nZiKOrHYhI1ulb2bfursmeGoIF+1RNv7/WD
         rEB+0pYybfeNam2co9SsYI15wgfX6n0cVJ0GxMQo/r0rJQkQWqxt+b8F4SfrWNHllS/J
         e/aDyKyDv6Dlj9M/I+InPeElQauNwHOkgTBobcmPeK0MPajWRm+b06Cjl193IXs7Kt2N
         wCJzauR6f5nKFz/rOZsHRHTd8yaZEkAubZa9Ak/lUwl9MlOzxrW3m3eJKO29k71j4Njr
         5k5ZaCRIacj2QbzXVCKVZm9DIezQdHF4g83VvzoC3Vo7CQNSW10co48HjeWPY+tL+3Rd
         xtlQ==
X-Gm-Message-State: AOAM532WGPzHyI542HCKch4HtLrZLzH6j8fsGov59aZpNYS9Xa6x/UVW
        AJCWeBtohfemQsUtpESbORteCYQLbS5SPULW
X-Google-Smtp-Source: ABdhPJwQyXNIfe5yULqH0s4UQ9/koqpkAb7sB4mNxDJik7niJmXmkuXFjP1fmvX6zB0ZM69BgQrR9w==
X-Received: by 2002:a17:902:b941:b0:14d:af72:3f23 with SMTP id h1-20020a170902b94100b0014daf723f23mr19169433pls.6.1648328232665;
        Sat, 26 Mar 2022 13:57:12 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004e03b051040sm11858981pfj.112.2022.03.26.13.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 13:57:12 -0700 (PDT)
Message-ID: <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
Date:   Sat, 26 Mar 2022 14:57:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
 <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
 <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/22 2:06 PM, Jakub Kicinski wrote:
> On Sat, 26 Mar 2022 13:47:24 -0600 Jens Axboe wrote:
>> On 3/26/22 1:28 PM, Jakub Kicinski wrote:
>>> On Fri, 18 Mar 2022 15:59:16 -0600 Jens Axboe wrote:  
>>>> - Support for NAPI on sockets (Olivier)  
>>>
>>> Were we CCed on these patches? I don't remember seeing them, 
>>> and looks like looks like it's inventing it's own constants
>>> instead of using the config APIs we have.  
>>
>> Don't know if it was ever posted on the netdev list
> 
> Hm, maybe I don't understand how things are supposed to work. 
> I'm surprised you're unfazed.

I'm surprised you're this surprised, to be honest. It's not like someone
has been sneaking in core networking bits behind your back.

>> but the patches have been discussed for 6-9 months on the io_uring
>> list.
> 
> You may need explain to me how that's relevant :) 
> The point is the networking maintainers have not seen it.

Sorry, should've expanded on that. It's been discussed on that list for
a while, and since it was just an io_uring feature, I guess nobody
considered that it would've been great to have netdev take a look at it.
For me personally, not because I think networking need to sign off on
it, but because if it is missing using some tunables that are relevant
for NAPI outside of io_uring, we of course need to be consistent there.

>> Which constants are you referring to? Only odd one I see is
>> NAPI_TIMEOUT, other ones are using the sysctl bits. If we're
>> missing something here, do speak up and we'll make sure it's
>> consistent with the regular NAPI.
> 
> SO_BUSY_POLL_BUDGET, 8 is quite low for many practical uses.

OK. I've just started doing some network tuning, but haven't gotten
around to specifically targeting NAPI just yet. Will do so soon.

> I'd also like to have a conversation about continuing to use
> the socket as a proxy for NAPI_ID, NAPI_ID is exposed to user
> space now. io_uring being a new interface I wonder if it's not 
> better to let the user specify the request parameters directly.

Definitely open to something that makes more sense, given we don't have
to shoehorn things through the regular API for NAPI with io_uring.

-- 
Jens Axboe

