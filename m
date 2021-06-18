Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30013ACE11
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 16:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234804AbhFRO6K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 10:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbhFRO6K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 10:58:10 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F41C06175F
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 07:56:00 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w127so10829749oig.12
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 07:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JLF02LgQK8wiSw1wo+3dCwHHQeIAoXtWaSMsg8jus4M=;
        b=0T8U2hE3laago06p8eqY1PBTXXpPU90AWIP9uTyNLgxlce08gZ6OUYfVhSC+7ai75H
         JxULDmu6wT5mkkzetizEnwxbtWE2O/5cQXskjcqPXW7HyfeggFPn0UXaNtJUnKXtoT+E
         OrwWX3ydHEvY5A1H+pYLC4bvyNFq3cL8+fTxdJ4DH2oI0aQenMAM0XD6BrtOmwP6zrPB
         aNw5NnGhMrUqOyBJxcpONK1R0p6+11Hb9Ov+BDZuNVur4Wvx5bQMEc5vjLLLJ+C022D0
         YXXjEl2uaus0jBs8THda/7+hpjz5fNfVoQQ1n/juhVyjn55FLtYyNn2OdclYppLVaVGw
         eTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JLF02LgQK8wiSw1wo+3dCwHHQeIAoXtWaSMsg8jus4M=;
        b=ZVD1n4nR1RAHrAsZQeIcnj+aNoVokMR8tX2XTEpPMmb6bzG3Siy2XIhzk+IkwfJE7T
         rvaHbibmMVAAweI4Vumqhtijjf8HQFGNEbyo/sPhmpFHnnWuXCyE2g41tGitnpu5nn3s
         o+Vu9RSjksmPj5koS7ucWb9TGrvaoeH8NBUtogkvDi5DpjmZ0HMv2f0CtQq4gMiviqvR
         YY58MVY6wB8/ZpCjhCzkxEczImmmx3iYFUZCUoXhJYbMnC+vLayLteyITYHvooMav0Ax
         VYwydgw5JRNl4SaPd91kZIcMa4ILQCZgNLw38CmU8zVu93Lh8rzji5foBsFJhF2fCAxa
         34yg==
X-Gm-Message-State: AOAM532/SOSATtRnlSPd/IfYHaJdXpH9/tJnahp3wbnbZLXNZKZ0V35j
        l+m8HDw7EHXSjDCxvzvAHJmmCUnQoZ1g5w==
X-Google-Smtp-Source: ABdhPJzzOHCKW5+hrZcdc08fWO9pKFUGFzMiEe5W/qliE+SY1zJsRusKi41H5oJF+YPkMM5UA41iyg==
X-Received: by 2002:aca:a983:: with SMTP id s125mr15370432oie.13.1624028159838;
        Fri, 18 Jun 2021 07:55:59 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id w2sm429092oon.18.2021.06.18.07.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 07:55:59 -0700 (PDT)
Subject: Re: [Bug] fio hang when running multiple job io_uring/hipri over nvme
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <CAFj5m9+ckHjfMVW_O20NBAPvnauPdABa8edPy--dSEf=XdhYRA@mail.gmail.com>
 <6691cf72-3a26-a1bb-228d-ddec8391620f@kernel.dk>
 <1b56a4f7-ce56-ee32-67d5-0fcd5dc6c0cb@kernel.dk> <YMvPL/WhRsFfMIfi@T590>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9596bf6f-cf34-c074-136e-5496d1a7b2fc@kernel.dk>
Date:   Fri, 18 Jun 2021 08:56:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YMvPL/WhRsFfMIfi@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/21 4:39 PM, Ming Lei wrote:
> On Thu, Jun 17, 2021 at 10:56:53AM -0600, Jens Axboe wrote:
>> On 6/17/21 10:48 AM, Jens Axboe wrote:
>>> On 6/17/21 5:17 AM, Ming Lei wrote:
>>>> Hello,
>>>>
>>>> fio hangs when running the test[1], and doesn't observe this issue
>>>> when running a
>>>> such single job test.
>>>>
>>>> v5.12 is good, both v5.13-rc3 and the latest v5.13-rc6 are bad.
>>>>
>>>>
>>>> [1] fio test script and log
>>>> + fio --bs=4k --ioengine=io_uring --fixedbufs --registerfiles --hipri
>>>> --iodepth=64 --iodepth_batch_submit=16
>>>> --iodepth_batch_complete_min=16 --filename=/dev/nvme0n1 --direct=1
>>>> --runtime=20 --numjobs=4 --rw=randread
>>>> --name=test --group_reporting
>>>>
>>>> test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>>> 4096B-4096B, ioengine=io_uring, iodepth=64
>>>> ...
>>>> fio-3.25
>>>> Starting 4 processes
>>>> fio: filehash.c:64: __lookup_file_hash: Assertion `f->fd != -1' failed.
>>>> fio: pid=1122, got signal=6
>>>> ^Cbs: 3 (f=0): [f(1),r(1),K(1),r(1)][63.6%][eta 00m:20s]
>>>
>>> Funky, would it be possible to bisect this? I'll see if I can reproduce.
>>
>> Actually, this looks like a fio bug, that assert is a bit too trigger
>> happy. Current -git should work, please test and see if things work.
>> I believe it's just kernel timing that causes this, not a kernel issue.
> 
> Yeah, current -git does work, thanks the fix!

Thanks for checking!

-- 
Jens Axboe

