Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8495AD894
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiIERsO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 13:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiIERsN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 13:48:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E7740BC4
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 10:48:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so3525680pjm.1
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 10:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=Ow2KNdRTOrPhrYVfdlVlusHZXawEuXDKjQ+IEvL7oxw=;
        b=Udb2+ETF1BcydHsFPGnYZH93hYTm9WWBICq+cqwWRy3ZQQHuFbTVbeVpBN32DTekmp
         4J+v0mWkDr3bAjsSHl6hTQvrK1/AD7C4NCp+k8RTCpiOpPEeUdEWdrrMJSZr03ZleHFs
         ImaVBL8nsbCvnj05r0bhTbzruUooYjIxN9+ceSTKe26JXGyju3hTTlAh4kx6Rrl9popT
         puSfLQpxTC8x5sxdhbIY5U/qZLmpbn9ZIxZ5IA+e2mqhZfIcQXfBnPdAcmVgJTcQRno6
         j9FB9wC/0JSGJc7pmbGB21MWJi3ZCXdfImwuv85WQO0ENDfriYE/Mh9Z/pIqwu/zD279
         Jw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=Ow2KNdRTOrPhrYVfdlVlusHZXawEuXDKjQ+IEvL7oxw=;
        b=mIuQSmoQKReuhTXYMdPt+Z8fc/4JXLBV7F+ZihZQ2O5bR5RKxlg84L6UoM1EX4f468
         HtA1BznKvCn+z3ZxTb8BhzEaeZZO+G4H/q/51hzCO6U5Mjvaw9n/BWvE5n6inoUBvjcK
         7wFqJyjB7ZJJCOdx2l6RbJ7sxHPHrNu9vdKngrFwI2oVed3+Qyhw98V3D7souxyBrJt7
         uzDvxqHro7AonljWIE2eKTMxj+7GOXoe/wvgiZOYNFG35MOn9Tz6iNon8mjzVz1qh5n9
         fMU0doMbqiEDm6jIDr0tL2DLOpph4oZUb/r4z7UmW/SGkK1H4hqCDcbKlwyn6FXXRShu
         fORQ==
X-Gm-Message-State: ACgBeo0na/2FBu974EfFpBed95Dubf7LGT8/gH0H7a9osv93/ves7+3u
        6edNVGRSIPjtAluETteNsR8oFw==
X-Google-Smtp-Source: AA6agR57ilOT356oTj0abpdeRoDV+2sTmiIUsCKOQ4LMJodPvJfYFpqAuqGUh7IVXy2mzZ/RHlws+Q==
X-Received: by 2002:a17:902:c945:b0:16e:d24d:1b27 with SMTP id i5-20020a170902c94500b0016ed24d1b27mr51405033pla.51.1662400090792;
        Mon, 05 Sep 2022 10:48:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902d58c00b0017336c3a585sm4515475plh.233.2022.09.05.10.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 10:48:09 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------L6uuue113VwcrRB0OcjyhhEy"
Message-ID: <bbbcd281-58e3-1341-8d35-06e016b8438b@kernel.dk>
Date:   Mon, 5 Sep 2022 11:48:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH for-next v3 0/4] fixed-buffer for uring-cmd/passthrough
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     hch@lst.de, kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
References: <CGME20220902152701epcas5p1d4aca8eebc90fb96ac7ed5a8270816cf@epcas5p1.samsung.com>
 <20220902151657.10766-1-joshi.k@samsung.com>
 <f1e8a7fa-a1f8-c60a-c365-b2164421f98d@kernel.dk>
 <2b4a935c-a6b1-6e42-ceca-35a8f09d8f46@kernel.dk>
 <20220902184608.GA6902@test-zns>
 <48856ca4-5158-154e-a1f5-124aadc9780f@kernel.dk>
 <c62c977d-9e81-c84c-e17c-e057295c071e@kernel.dk>
 <75c6c9ea-a5b4-1ef5-7ff1-10735fac743e@kernel.dk>
 <20220904170124.GC10536@test-zns>
 <7c0fced8-11b0-fcd9-ac47-662af979b207@kernel.dk>
 <20220905055209.GA26487@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220905055209.GA26487@test-zns>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------L6uuue113VwcrRB0OcjyhhEy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/22 11:52 PM, Kanchan Joshi wrote:
> On Sun, Sep 04, 2022 at 02:17:33PM -0600, Jens Axboe wrote:
>> On 9/4/22 11:01 AM, Kanchan Joshi wrote:
>>> On Sat, Sep 03, 2022 at 11:00:43AM -0600, Jens Axboe wrote:
>>>> On 9/2/22 3:25 PM, Jens Axboe wrote:
>>>>> On 9/2/22 1:32 PM, Jens Axboe wrote:
>>>>>> On 9/2/22 12:46 PM, Kanchan Joshi wrote:
>>>>>>> On Fri, Sep 02, 2022 at 10:32:16AM -0600, Jens Axboe wrote:
>>>>>>>> On 9/2/22 10:06 AM, Jens Axboe wrote:
>>>>>>>>> On 9/2/22 9:16 AM, Kanchan Joshi wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> Currently uring-cmd lacks the ability to leverage the pre-registered
>>>>>>>>>> buffers. This series adds the support in uring-cmd, and plumbs
>>>>>>>>>> nvme passthrough to work with it.
>>>>>>>>>>
>>>>>>>>>> Using registered-buffers showed peak-perf hike from 1.85M to 2.17M IOPS
>>>>>>>>>> in my setup.
>>>>>>>>>>
>>>>>>>>>> Without fixedbufs
>>>>>>>>>> *****************
>>>>>>>>>> # taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
>>>>>>>>>> submitter=0, tid=5256, file=/dev/ng0n1, node=-1
>>>>>>>>>> polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
>>>>>>>>>> Engine=io_uring, sq_ring=128, cq_ring=128
>>>>>>>>>> IOPS=1.85M, BW=904MiB/s, IOS/call=32/31
>>>>>>>>>> IOPS=1.85M, BW=903MiB/s, IOS/call=32/32
>>>>>>>>>> IOPS=1.85M, BW=902MiB/s, IOS/call=32/32
>>>>>>>>>> ^CExiting on signal
>>>>>>>>>> Maximum IOPS=1.85M
>>>>>>>>>
>>>>>>>>> With the poll support queued up, I ran this one as well. tldr is:
>>>>>>>>>
>>>>>>>>> bdev (non pt)??? 122M IOPS
>>>>>>>>> irq driven??? 51-52M IOPS
>>>>>>>>> polled??????? 71M IOPS
>>>>>>>>> polled+fixed??? 78M IOPS
>>>>
>>>> Followup on this, since t/io_uring didn't correctly detect NUMA nodes
>>>> for passthrough.
>>>>
>>>> With the current tree and the patchset I just sent for iopoll and the
>>>> caching fix that's in the block tree, here's the final score:
>>>>
>>>> polled+fixed passthrough??? 105M IOPS
>>>>
>>>> which is getting pretty close to the bdev polled fixed path as well.
>>>> I think that is starting to look pretty good!
>>> Great! In my setup (single disk/numa-node), current kernel shows-
>>>
>>> Block MIOPS
>>> ***********
>>> command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -P1 -n1 /dev/nvme0n1
>>> plain: 1.52
>>> plain+fb: 1.77
>>> plain+poll: 2.23
>>> plain+fb+poll: 2.61
>>>
>>> Passthru MIOPS
>>> **************
>>> command:t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -P1 -u1 -n1 /dev/ng0n1
>>> plain: 1.78
>>> plain+fb: 2.08
>>> plain+poll: 2.21
>>> plain+fb+poll: 2.69
>>
>> Interesting, here's what I have:
>>
>> Block MIOPS
>> ============
>> plain: 2.90
>> plain+fb: 3.0
>> plain+poll: 4.04
>> plain+fb+poll: 5.09   
>>
>> Passthru MIPS
>> =============
>> plain: 2.37
>> plain+fb: 2.84
>> plain+poll: 3.65
>> plain+fb+poll: 4.93
>>
>> This is a gen2 optane
> same. Do you see same 'FW rev' as below?
> 
> # nvme list
> Node????????????????? SN?????????????????? Model??????????????????????????????????? Namespace Usage????????????????????? Format?????????? FW Rev
> --------------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
> /dev/nvme0n1????????? PHAL11730018400AGN?? INTEL SSDPF21Q400GB????????????????????? 1???????? 400.09? GB / 400.09? GB??? 512?? B +? 0 B?? L0310200
> 
> 
>> , it maxes out at right around 5.1M IOPS. Note that
>> I have disabled iostats and merges generally in my runs:
>>
>> echo 0 > /sys/block/nvme0n1/queue/iostats
>> echo 2 > /sys/block/nvme0n1/queue/nomerges
>>
>> which will impact block more than passthru obviously, particularly
>> the nomerges. iostats should have a similar impact on both of them (but
>> I haven't tested either of those without those disabled).
> 
> bit improvment after disabling, but for all entries.
> 
> block
> =====
> plain: 1.6
> plain+FB: 1.91
> plain+poll: 2.36
> plain+FB+poll: 2.85
> 
> passthru
> ========
> plain: 1.9
> plain+FB: 2.2
> plain+poll: 2.4
> plain+FB+poll: 2.9
> 
> Maybe there is something about my kernel-config that prevents from
> reaching to expected peak (i.e. 5.1M). Will check more.

Here's the config I use for this kind of testing, in case it's useful.

-- 
Jens Axboe
--------------L6uuue113VwcrRB0OcjyhhEy
Content-Type: application/gzip; name="dell-config.gz"
Content-Disposition: attachment; filename="dell-config.gz"
Content-Transfer-Encoding: base64

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
B7Ave3HaHAIA

--------------L6uuue113VwcrRB0OcjyhhEy--
