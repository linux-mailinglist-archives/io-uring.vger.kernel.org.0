Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D4042D654
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 11:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhJNJpy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 05:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhJNJpx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 05:45:53 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E107FC061570
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 02:43:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v17so17448040wrv.9
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 02:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eW27m3MqP6yFxMB0bgEEBaaiptqUmmjqtx6/tBQjLSI=;
        b=PAogHHDvStNLC98Q0g5HUD5vpmErDXjld4i40QQiZxDeGVj2r1bXXRxfjqcWTNZXgq
         HUT8iatN/aWsJFTnAbtmWsFEcuMvVkmxMj35jiJ5vlAjsaPAK3dERd8qmBQG4TJ3K7VW
         H/t7+tf/H7Bv8RZmX7eYH4wMxPHhjjU+GqjKm9fNQRaUMFJkbjIZkWQLhLuijOQF0IJK
         +lDOic96tkqIJ9NX7VxKWAmqDMDCx+caA5V4E1kvoYxdx2/ydJVObosoRJGfwmDWOCWf
         SbijE1VsRy1SUMRJ2vdOxe3hAlrpctnqSbvzfcJGoULL1WoFMs18bd4sJiin9n6M4j5f
         Ow4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eW27m3MqP6yFxMB0bgEEBaaiptqUmmjqtx6/tBQjLSI=;
        b=Yd69iYh9OGydCdm4L2uFQcHkNca/Z2XTA8beDJoFpTWtUi2IwzOoHoVwDmO5+mAsFQ
         OFHzNRJxGcwiYGXAHVmwhMpyCx4E5gufg5qnL2frX8FpAl2qAUosPnT+pM4AF4eMgaMD
         CkLBZNrXlMjWn21rw+eSTfjlHckaqku3rSxEbu8xcEusaWsE+3sFdsR8XTUnwgzRELRJ
         o4oE/YKtQBNLlNelMICmtrBcnHohPIDIeVmoxTzRGR+AV29MSgoOKPNY3AvUZEs+BFny
         2SQMIZVk3wBCfIVtB3p0fAkLT6jnqNoRCMKC5VdX1mLsl0teoXxlMqlUhitKQtff9RZc
         73AQ==
X-Gm-Message-State: AOAM531u0s6wEgA6GZWHrQhmUzvXo7QBmS18rTd/urmiWoPCWTuQZ1fj
        ufLWEdB6dDktoudUGH2Rrcs=
X-Google-Smtp-Source: ABdhPJxLRWKVJVWrJj6jaGcHh3bprf+fcYy2MIRzU+fwraPT2MDELPciSIW1dvC4cznYy9RLwd5mZg==
X-Received: by 2002:a05:6000:18cf:: with SMTP id w15mr5271979wrq.314.1634204627299;
        Thu, 14 Oct 2021 02:43:47 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id f186sm7336587wma.46.2021.10.14.02.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 02:43:46 -0700 (PDT)
Message-ID: <bd7431f2-106c-ab75-fafd-7f36df4e2c8f@gmail.com>
Date:   Thu, 14 Oct 2021 10:43:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [RFC 1/1] io_uring: improve register file feature's usability
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
 <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
 <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
 <b08c5add-96cd-9b1a-0ac5-32a62cace9a4@linux.alibaba.com>
 <4211b3d1-42a8-4528-2c72-7fddf3bddcf6@gmail.com>
 <98943ac6-772c-fd18-8d47-fbd16de10894@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <98943ac6-772c-fd18-8d47-fbd16de10894@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/21 04:32, Xiaoguang Wang wrote:
> hi,
>> On 10/12/21 14:11, Xiaoguang Wang wrote:
>>>> On 10/12/21 09:48, Xiaoguang Wang wrote:
>>>>> The idea behind register file feature is good and straightforward, but
>>>>> there is a very big issue that it's hard to use for user apps. User apps
>>>>> need to bind slot info to file descriptor. For example, user app wants
>>>>> to register a file, then it first needs to find a free slot in register
>>>>> file infrastructure, that means user app needs to maintain slot info in
>>>>> userspace, which is a obvious burden for userspace developers.
>>>>
>>>> Slot allocation is specifically entirely given away to the userspace,
>>>> the userspace has more info and can use it more efficiently, e.g.
>>>> if there is only a small managed set of registered files they can
>>>> always have O(1) slot "lookup", and a couple of more use cases.
>>>
>>> Can you explain more what is slot "lookup", thanks. For me, it seems that
>>
>> I referred to nothing particular, just a way userspace finds a new index,
>> can be round robin or "index==fd".
>>
>>> use fd as slot is the simplest and most efficient way, user does not need to> mange slot info at all in userspace.
>>
>> As mentioned, it should be slightly more efficient to have a small table,
>> cache misses. Also, it's allocated with kvcalloc() so if it can't be
>> allocate physically contig memory it will set up virtual memory.
>>
>> So, if the userspace has some other way of indexing files, small tables
>> are preferred. For instance if it operates with 1-2 files, or stores files
>> in an array and the index in the array may serve the purpose, or any other
>> way. Also, additional memory for those who care.
> 
> Yeah, I agree with you that for small tables, current implementation seems good,
> 
> If user app just registers a small number of files, it may handle it well, but imagine
> 
> how netty, nginx or other network apps which will open thousands of socket files,
> 
> manage these socket files' slot info will be a obvious burden to developer, these
> 
> apps may need to develop a private component to record used or free slot. Especially
> 
> in a high concurrency scenario, frequent sockes opened or closed, this private component
> 
> may need locks to protect, that means this private component will introduce overhead too.
> 
> For a fd, vfs layer has already ensure its unique.
> 
>>
>>>> If userspace wants to mimic a fdtable into io_uring's registered table,
>>>> it's possible to do as is and without extra fdtable tracking
>>>>
>>>> fd = open();
>>>> io_uring_update_slot(off=fd, fd=fd);
>>>
>>> No, currently it's hard to do above work, unless we register a big number of files initially.
>>
>> If they intend to use a big number of files that's the way to go. They
>> can unregister/register if needed, usual grow factor=2  should make
>> it workable.
> 
> I'm not sure un-register/register are appropriate，say a app registers 1000 files, then
> 
> it needs to un-register 1000 files firstly, there are doubts whether can do this un-registration
> 
> work, if some of these files are used by other threads, which submit sqes with FIXED_FILE
> 
> flags continually, so the first un-registration work needs to synchronize with threads which
> 
> are submitting requests. And later app needs to prepare a new files array, saving current 1000
> 
> files and new files info to this new array, for me, it can works, but not efficient and somewhat
> 
> hard to use :)

Sounds reasonable. What I oppose is wiring it solely based on fd. On the
other hand, it sounds what you need is a "grow table" feature.

We can also think about adding new format, instead of array of fds, add
passing an array of pairs {offset, fd}.

-- 
Pavel Begunkov
