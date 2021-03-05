Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1232F25F
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 19:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCESVc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 13:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCESV2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 13:21:28 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E41C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 10:21:28 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id s1so2821626ilh.12
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 10:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OEh/sWcetf4+lkEDVwLPAVNhW+72rKN70d51beTZb3Q=;
        b=yk2EpWw/jTc5NfKFj8PzaotMNefoDlziRutMdRyUkrooGjDsjiEx2wA10qJ3mG2wZ0
         sYXDZYHohoWbxptDtHO7fdNV79jA1I9Qk0bw2UZ9+Pm8ukDlRkHMOLTlWuMPfBZXERi3
         fKxWi9KggJGtL7x7RzAq/oNNIETyCk144Jpq53hVxTq6gO3lTmPepeeoCgPDOKpfHJhs
         +isGdor+45t3n9kIIpuX5nlzKutHCajB/c0WkmLrlqeKAd+J1FVvwcFx3L8slb1//Gtl
         yYoO4wAGowXP68w1gvzS3ZzwfcCynS8aQ1hln2bSyZy22xeUe/UECetV04L3CRNP4lI4
         LvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OEh/sWcetf4+lkEDVwLPAVNhW+72rKN70d51beTZb3Q=;
        b=Q+gFgqClTsvupwl7klgjcdj8cri2yPA9nAGB6Ab4ZCN2Ly12mJ//iXvgX0QlweMuXN
         0pRGLy+hftr5/K3bmAxdd+eLdfQH8tvNpy2rZvjSCUm7HgsxCTD/qz8s+8UWWOd7aASv
         kN/288mWhJcePBV05LZ/iGOKVuq/1ipt/ojaGK1hH/b8ECrK75xig9nQT5MSEp59HNrj
         f7TYDFues+IdhfabODeZWicQO56gGBpsVffz8ykKcdBt5uBI8lDOIMOWZ3lX8M/REkjH
         PMayZCGd5ubrdAw3TjuE26OobCbTxJO4rOwX+pslOp6MBr555FCwIuT7An5N9fgIH6y8
         IO2w==
X-Gm-Message-State: AOAM533oaXgy9DPwEs8u4yZUh+z6feVFNkmnVMLjFFmuI+ZfE/ma71Ix
        h+/ZLxAfzCE7eiSomuK5IFkuog==
X-Google-Smtp-Source: ABdhPJy7QwpL95S/HOl2DljHxhZENGECbkHbofdfBkOTTuXvGfnc2qKDYfIIf0kBZ1v5ayol17f6Og==
X-Received: by 2002:a05:6e02:12c2:: with SMTP id i2mr9419720ilm.34.1614968487685;
        Fri, 05 Mar 2021 10:21:27 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w2sm1602885ioa.46.2021.03.05.10.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 10:21:27 -0800 (PST)
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
To:     Mikulas Patocka <mpatocka@redhat.com>,
        JeffleXu <jefflexu@linux.alibaba.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
References: <20210302190555.201228400@debian-a64.vm>
 <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
 <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
 <f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
 <alpine.LRH.2.02.2103040507040.7400@file01.intranet.prod.int.rdu2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7ff9599c-d729-87b2-4fc0-e2413b2d8718@kernel.dk>
Date:   Fri, 5 Mar 2021 11:21:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103040507040.7400@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 3:09 AM, Mikulas Patocka wrote:
> 
> 
> On Thu, 4 Mar 2021, JeffleXu wrote:
> 
>>> __split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
>>> When we processed all the bios, we poll for the last cookie here:
>>>
>>>         if (ci.poll_cookie != BLK_QC_T_NONE) {
>>>                 while (atomic_read(&ci.io->io_count) > 1 &&
>>>                        blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>>         }
>>
>> So what will happen if one bio submitted to dm device crosses the device
>> boundary among several target devices (e.g., dm-stripe)? Please refer
>> the following call graph.
>>
>> ```
>> submit_bio
>>   __submit_bio_noacct
>>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
>> call __split_and_process_non_flush() once, submitting the *first* split bio
>>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
>> call __split_and_process_non_flush() once, submitting the *second* split bio
>>     ...
>> ```
>>
>>
>> So the loop is in __submit_bio_noacct(), rather than
>> __split_and_process_bio(). Your design will send the first split bio,
>> and then poll on this split bio, then send the next split bio, polling
>> on this, go on and on...
> 
> No. It will send all the bios and poll for the last one.

I took a quick look, and this seems very broken. You must not poll off
the submission path, polling should be invoked by the higher layer when
someone wants to reap events. IOW, dm should not be calling blk_poll()
by itself, only off mq_ops->poll(). Your patch seems to do it off
submission once you submit the last bio in that batch, effectively
implementing sync polling for that series. That's not right.

-- 
Jens Axboe

