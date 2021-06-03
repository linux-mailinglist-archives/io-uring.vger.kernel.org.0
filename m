Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D10439A9D7
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 20:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhFCSPj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 14:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCSPj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 14:15:39 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEC3C06174A
        for <io-uring@vger.kernel.org>; Thu,  3 Jun 2021 11:13:54 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id k16so7275988ios.10
        for <io-uring@vger.kernel.org>; Thu, 03 Jun 2021 11:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LrMYcjq05VyJxkL18sDV7DXDJoHHmPTPpPGO0QVG5ws=;
        b=sleU7SFV30zMQkS002evJmEErV/7Q8rP5+rKIXSi5P5X1GVAv9dkWqnFKKC7c38xTs
         fU+msYzfQ4THH5kjw70SVcaiqj0GykE9UDNFUxsR+Oc2yA2zjpjV8HCeQ/oBTKg41n0t
         pCr8PwDjnAZZ3eHScEhe2KKCK6Ujmbx+1RcPzN2N8UzF7/uqbaXMzpDyiuH7X8ueg6dl
         1iNSh1vGLo8pk68HX3Nu4xmJAhWlfLoChXUW46C/ld/0RBSCEx3sB6cNUX4wyFEOE27V
         xx/HFophmhK4/LPmdcV/WZfErMG+LtGGi2PbZGTC0AXWLQc5FsypAilyTGQSWEoykFSH
         Vr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LrMYcjq05VyJxkL18sDV7DXDJoHHmPTPpPGO0QVG5ws=;
        b=nD4q4sUH6QxLnzJETF7PA1mmKQHE6HUB6hzemwyJqPNHrUx9M3TytHeYIJuhBHfOVS
         VUCr6DZUXrtiJz1ekkTv9K59U+SRGtMXEQI+dNDpFshNxo5wlq9m53fmbInvI3rq39LE
         m/GHJCi3q4lKECGOJMHMFApCM6tkDpn67Q013vouzzbni6hocp0093MFHg4+pWF3IFbe
         iziHclKmVoKYsqG2e/o4UAJQVwk3f8tvmoUVQZYpbJxSGIiYqauXkuCdG/ZmQMxwXfCG
         puWL/joHvObkkblpqakTW86F03TGFTsMAgt7PrM4ZOfJLPAiBx3Ik3RZKq4S2kVkUkeq
         a1eQ==
X-Gm-Message-State: AOAM530FXZYonqeYTTp2HBvwDqh2lO52po4aI3BgJCenWYWPITHpr474
        tdEdpcrZRMBe7Hbt0IS6oaBKqMtEMTUmPuzd
X-Google-Smtp-Source: ABdhPJwMkO/dtY0/zseCyhwuB5uDMbGLutwMXu9Ca6DDUw+Rk/lHEdxnbjdJcFoLwQfJ+wckLJfkLg==
X-Received: by 2002:a05:6638:1482:: with SMTP id j2mr260876jak.63.1622744033395;
        Thu, 03 Jun 2021 11:13:53 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z2sm1901101ioe.26.2021.06.03.11.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 11:13:52 -0700 (PDT)
Subject: Re: Memory uninitialized after "io_uring: keep table of pointers to
 ubufs"
To:     Andres Freund <andres@anarazel.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210529003350.m3bqhb3rnug7yby7@alap3.anarazel.de>
 <d2c5b250-5a0f-5de5-061f-38257216389d@gmail.com>
 <20210603180612.uchkn5qqa3j7rpgd@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89f8e80f-839b-34bc-612b-d0176050bc7d@kernel.dk>
Date:   Thu, 3 Jun 2021 12:13:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210603180612.uchkn5qqa3j7rpgd@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 12:06 PM, Andres Freund wrote:
> Hi,
> 
> On 2021-05-29 12:03:12 +0100, Pavel Begunkov wrote:
>> On 5/29/21 1:33 AM, Andres Freund wrote:
>>> Hi,
>>>
>>> I started to see buffer registration randomly failing with ENOMEM on
>>> 5.13. Registering buffer or two often succeeds, but more than that
>>> rarely. Running the same program as root succeeds - but the user has a high
>>> rlimit.
>>>
>>> The issue is that io_sqe_buffer_register() doesn't initialize
>>> imu. io_buffer_account_pin() does imu->acct_pages++, before calling
>>> io_account_mem(ctx, imu->acct_pages);
>>>
>>> Which means that a random amount of memory is being accounted for. On the first
>>> few allocations this sometimes fails to fail because the memory is zero, but
>>> after a bit of reuse...
>>
>> Makes sense, thanks for digging in. I've just sent a patch, would
>> be great if you can test it or send your own.
> 
> Sorry for the slow response, I'm off this week. I did just get around to
> test and unsurprisingly: The patch does fix the issue.

OK good, thanks for confirming, I did ship it out earlier today so
should be in the next -rc.

-- 
Jens Axboe

