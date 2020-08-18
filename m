Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F70F248DB4
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgHRSKg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Aug 2020 14:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRSKf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Aug 2020 14:10:35 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB1AC061389
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 11:10:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k18so10348096pfp.7
        for <io-uring@vger.kernel.org>; Tue, 18 Aug 2020 11:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R1Gm1QPwYdMeWBQ6bVfaXgYbwUIYl5I+C4SAuHvxI34=;
        b=kA8ALUQHDWbnCEbBjePUNzDJTnoU7u7rAa/3Xl0spof+1vSZiHel/9hw4lGu1AwAt9
         3voIcPZRAfzPbgsAk45y3Z5MdKLrbOj3mZYwfVlQ2OlxgvVh8X91XnEVYaayaR4f/Df2
         Wg1qLzI4sQ7lF3oSczcWdt+pIVnFrf7Qqg8V6Cj6A0Ok1uapTpRRLbi+zCxXllhhHGbY
         kNqihp1m0ctawSSdeg/yXSM8QxaWDH1q8mqzLIRM/DcQ8Kv5CTo/gxIMdKTau+LJVG0+
         JBic1ZEnU8ThZ+GfTQopLcDxU+gGnSnrBzT/03qQOPCe8W4V1Zr7xnKc15qwdtVehtBX
         Ajtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R1Gm1QPwYdMeWBQ6bVfaXgYbwUIYl5I+C4SAuHvxI34=;
        b=MCvDAJhjWM0reIFAbMtPlxfNIfyj/ui2dk9AVYJxU3OpzeHUXnW4x7d721YeyROO75
         YCt3p5f1tJbvvQ3Nk24vxPfSWe6WdWNYeCmYSdKMXTHnarMjVAReGyxwsnnHgxa0v6cj
         mSmghIF19jclC+7AUXR9q2qZwgvyXA1mtdz9NxwvpPGDs8X4Jkf5c0C/qM0S8xYGZvcR
         4jR/rw6dU0ikOLZM09ELAGXv8qaSmkxAnD3HkkJUmhO3QipRcSkjCAQ4w/bw5Y/ZuVVD
         IZf/KLCsVUf9t7x62poQ551+x8XI1EM7/X1x5plHWalc/IKvghj/zEuIhb/5knWb4dQR
         cY/Q==
X-Gm-Message-State: AOAM532moFo6cB0UcHPK/09U5vZDI/28E23c/HHvqkttF3OWucMhNHBl
        jtIayVzBP0vVduaND+pqCSmupA==
X-Google-Smtp-Source: ABdhPJx2BTN8sDsC7+GX81QKp9ue6mNVwVPVk1yKH15OpNsGuO99iEx13qO4OQH3260xH6tixwMc4A==
X-Received: by 2002:a63:584c:: with SMTP id i12mr11504910pgm.313.1597774233310;
        Tue, 18 Aug 2020 11:10:33 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:9214:36a5:5cec:a06d? ([2605:e000:100e:8c61:9214:36a5:5cec:a06d])
        by smtp.gmail.com with ESMTPSA id q13sm550526pjj.36.2020.08.18.11.10.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 11:10:32 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
 <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
 <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
 <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
 <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
 <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
 <aadb4728-abc5-b070-cd3b-02f480f27d61@kernel.dk>
 <x49sgclf0w8.fsf@segfault.boston.devel.redhat.com>
 <8cc4bc11-eb56-63e1-bb5c-702b75068462@kernel.dk>
 <x49blj7x2hh.fsf@segfault.boston.devel.redhat.com>
 <56f5cc5c-e915-60be-4e25-4a22ec734612@kernel.dk>
 <x497dtvx1yl.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <87897e7a-6ee9-9f24-fabe-c12bf51983cb@kernel.dk>
Date:   Tue, 18 Aug 2020 11:10:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x497dtvx1yl.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/20 11:07 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>>> We must be hitting different problems, then.  I just tested your
>>> 5.7-stable branch (running the test suite from an xfs file system on an
>>> nvme partition with polling enabled), and the read-write test fails:
>>>
>>> Running test read-write:
>>> Non-vectored IO not supported, skipping
>>> cqe res -22, wanted 2048
>>> test_buf_select_short vec failed
>>> Test read-write failed with ret 1
>>>
>>> That's with this head: a451911d530075352fbc7ef9bb2df68145a747ad
>>
>> Not sure what this is, haven't seen that here and my regular liburing
>> runs include both xfs-on-nvme(with poll queues) as one of the test
>> points. Seems to me like there's two oddities in the above:
>>
>> 1) Saying that Non-vectored isn't supported, that is not true on 5.7.
>>    This is due to an -EINVAL return.
>> 2) The test_buf_select_short_vec failure
>>
>> I'll see if I can reproduce this. Anything special otherwise enabled?
>> Scheduler on the nvme device? nr_requests? XFS options?
> 
> No changes from defaults.
> 
> /dev/nvme0n1p1 on /mnt/test type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> 
> # xfs_info /dev/nvme0n1p1
> meta-data=/dev/nvme0n1p1         isize=512    agcount=4, agsize=22893222 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=91572885, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=44713, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> # cat /sys/block/nvme0n1/queue/scheduler 
> [none] mq-deadline kyber bfq 
> 
> # cat /sys/block/nvme0n1/queue/nr_requests 
> 1023
> 
> # cat /sys/module/nvme/parameters/poll_queues 
> 8
> 
> I'll see if I can figure out what's going on.

Thanks, I'll be a bit busy the next 24h, but let me know how it goes and I'll
dig into this too when I can.

-- 
Jens Axboe

