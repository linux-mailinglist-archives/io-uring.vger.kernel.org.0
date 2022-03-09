Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEAD4D3DAD
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 00:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiCIXpG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 18:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiCIXpF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 18:45:05 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2ACC7D5E
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 15:44:05 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so470580pjb.3
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 15:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xZ5pk/v6FvmYcF2QqtDQr6YQCEUmF5T9mslVfxhX4lw=;
        b=1WIbvfAR2a/++7W/4IMTjpVpx4LGXGDFNJUsWx/AtHefzuwYB7Ii+WwpGuhQMBboCJ
         EBhHmMctx6uCu8JLmONtixIVpWY2QicyiWWkOZrHN4HZwVLR9jox+7AGmkJ7bpRDpKgh
         JR0lFjc/cdsAShHmi86Ci3WzC1BGJk1B0pLDJpIbBKPRpJFqlEIBPTA/ooSsYOeaDaqu
         hYnUT+Z7BfiKRquUJ2eETcX3ohj3ZVj/C91brxaCgPkd3dUcw9KdGRN4Q2s8amsMbNsN
         dxugJoK64vYc8ORt3+Wu/HobFYWIVNp2f4syKjy9A8b9B9MscelgKPHi/z90MyGjrSgn
         5mSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xZ5pk/v6FvmYcF2QqtDQr6YQCEUmF5T9mslVfxhX4lw=;
        b=ZAB8LIQgr1+Rd4+ktxJgNwr6cMrJ7K3nCrG8vS7wIwLlzZH01sIkEZRIsuTX6IpD8y
         EfmK0eOtcC79COr9DKuxC3DqUXz69NALSqD5w5/3GjjSgcDNZr17Bx/QEXR+BD4ltCJY
         MUzc06wPZzevZziPOjp9Nn56tOjYhLCe7WmUl0L37b+g3QTDV79kVjXL3Acz0BejtQps
         byCE+nOuD5rEjHXr0VD/wpkTbpJsadpeOkfNnRbyTl2NN8zNTVmds/9WRYAW76HKKvmm
         92YxLzw3LBudwjR/DNhtPYLDWIKsBj1h5PbTNJltBGloHLu1O+yB5kmjLJUi7Z/GsUAP
         QxaA==
X-Gm-Message-State: AOAM533Ub22qKiuLhOncGF3ztMqLqz/zHH3UtDE3pJIuAWipuIl2touX
        T+ph0wghnZKEO4DyJ0Fn9VnILg==
X-Google-Smtp-Source: ABdhPJyNpn/jtIzIqkD+JWHBSxj97tNEmql3hwlNlKuZ1KJAAdvaWBVvrzNmqXb6CG5q7048gKxcTQ==
X-Received: by 2002:a17:90b:3910:b0:1bf:2972:ccea with SMTP id ob16-20020a17090b391000b001bf2972cceamr12778860pjb.221.1646869445175;
        Wed, 09 Mar 2022 15:44:05 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a133-20020a621a8b000000b004f6a79008ddsm4370365pfa.45.2022.03.09.15.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 15:44:04 -0800 (PST)
Message-ID: <cde6d338-880b-57c7-d9e5-86d117647e8d@kernel.dk>
Date:   Wed, 9 Mar 2022 16:44:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 0/2] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646777484.git.olivier@trillion01.com>
 <612546a3-5630-f1d4-f455-ef2bf564c83e@kernel.dk>
 <b0b2c07eb3b7acad02159e0db145a5b4e825b026.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b0b2c07eb3b7acad02159e0db145a5b4e825b026.camel@trillion01.com>
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

On 3/8/22 10:47 PM, Olivier Langlois wrote:
> On Tue, 2022-03-08 at 17:54 -0700, Jens Axboe wrote:
>> On 3/8/22 3:17 PM, Olivier Langlois wrote:
>>> The sqpoll thread can be used for performing the napi busy poll in
>>> a
>>> similar way that it does io polling for file systems supporting
>>> direct
>>> access bypassing the page cache.
>>>
>>> The other way that io_uring can be used for napi busy poll is by
>>> calling io_uring_enter() to get events.
>>>
>>> If the user specify a timeout value, it is distributed between
>>> polling
>>> and sleeping by using the systemwide setting
>>> /proc/sys/net/core/busy_poll.
>>
>> I think we should get this queued up, but it doesn't apply to
>> for-5.18/io_uring at all. I can fix it up, but just curious what you
>> tested against?
>>
> Hi Jens,
> 
> I did wrote the patch from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> My testing systems are based on 5.16. I have backported the patch and
> compiled 5.16.12 with the patch for my testing.
> 
> sorry if I didn't use the right repo...

Generally, since the patch is for 5.18, you'd want to base it on my
for-5.18/io_uring branch as then it would apply on top of what is
already pending. But I'll see if I can shoe horn it, unfortunately we'll
hit a merge error but it'll be minor.

-- 
Jens Axboe

