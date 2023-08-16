Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A82477ED12
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 00:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbjHPW2k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 18:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346915AbjHPW2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 18:28:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB48272B
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 15:28:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b89b0c73d7so10269235ad.1
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 15:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692224909; x=1692829709;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I6DoL1FR589LmYpx5awXGTxH/dn3Joi4BsWt0GZkdL0=;
        b=BTZ0T5pdvBGF4gXK4qzltjfvHDHHZJ1jrvXRaMjjmPoe1azVTpMP7R7Cxx7YCDUtYa
         iqLGuo/IKYHRcSsMaxCvuwKkJHpk8h+Ks0tR+TRuT+fJ7Ko8TYw15z36f8ZPkMGpnSqv
         7eRYFCwUTtvbT0O0OphI4ugaHAcrPJqaykMlyFd/jGDh0k7Lg1r56jM1w8EzPRXzKHwC
         D0fw30gS3yoPq578KoWBGA0ZGTXmMEudY+Ij73CdEXkyxEgHmBm64t6+7avLQ7D1d5oe
         65xJ/dfs+cCFCx2qbMulydKeHyLb/4UlhhfUKa8lBReayapochpck9aJ/yQua5Sokq3B
         75RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692224909; x=1692829709;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6DoL1FR589LmYpx5awXGTxH/dn3Joi4BsWt0GZkdL0=;
        b=Ow9Oys++h7nLRG/UgupUIvJseGqLzzN8CO0zJioyzWdsLfivCZUMzhhBcGyyQCRu4j
         ZxV9VNMtEDkqLv+ZawUTUYCH9pJv3UmN8VV+uIcyr2fClJXz9pWJXLbTOZzDgtvgLlBM
         Hru8D+CQhwhAKCUsOtWLNIsqzxI3KZLhYymwi1L8iUJdojn7oT3Xcp+WkLIfQsNrgXFP
         FBp5gUZshOW/PLL8FBNEtiL94WxI0NHbNbcK5RVfYZ+5o/QKYE3MDStCqgIEWJWuoCe8
         yMLVLANGavgDoboK1hLkPfwkTA6tEFarzawQumb3wGaJCTay5+RJTgSq8na5ROi0cMJG
         yjtA==
X-Gm-Message-State: AOJu0YxWS+yUiliRn+unpsH5SabwfUXu9VY+DBOLff8ySXMs9QXJhPR4
        9KtTq2d0bx72fpwqAJFUuj6/UQ==
X-Google-Smtp-Source: AGHT+IHhBiGLtYdaRPXzs5eJ8Lr8N59jrHisIfxQDsvPglpO4DVvTxIUWle+piHsCiDwIkP4txUMrA==
X-Received: by 2002:a17:902:e5cc:b0:1b8:a469:53d8 with SMTP id u12-20020a170902e5cc00b001b8a46953d8mr3759451plf.0.1692224908678;
        Wed, 16 Aug 2023 15:28:28 -0700 (PDT)
Received: from ?IPV6:2600:380:4b6d:b7a2:213a:1ca6:4fb5:441a? ([2600:380:4b6d:b7a2:213a:1ca6:4fb5:441a])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902e88e00b001bbdf33b878sm13577254plg.272.2023.08.16.15.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 15:28:27 -0700 (PDT)
Message-ID: <d67e7236-a9e4-421c-b5bf-a4b25748cac2@kernel.dk>
Date:   Wed, 16 Aug 2023 16:28:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
 <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 3:46 PM, Qu Wenruo wrote:
> 
> 
> On 2023/8/16 22:33, Jens Axboe wrote:
>> On 8/16/23 12:52 AM, Qu Wenruo wrote:
>>> Hi,
>>>
>>> Recently I'm digging into a very rare failure during btrfs/06[234567],
>>> where btrfs scrub detects unrepairable data corruption.
>>>
>>> After days of digging, I have a much smaller reproducer:
>>>
>>> ```
>>> fail()
>>> {
>>>          echo "!!! FAILED !!!"
>>>          exit 1
>>> }
>>>
>>> workload()
>>> {
>>>          mkfs.btrfs -f -m single -d single --csum sha256 $dev1
>>>          mount $dev1 $mnt
>>>      # There are around 10 more combinations with different
>>>          # seed and -p/-n parameters, but this is the smallest one
>>>      # I found so far.
>>>      $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt
>>>      umount $mnt
>>>      btrfs check --check-data-csum $dev1 || fail
>>> }
>>> runtime=1024
>>> for (( i = 0; i < $runtime; i++ )); do
>>>          echo "=== $i / $runtime ==="
>>>          workload
>>> done
>>> ```
>>
>> Tried to reproduce this, both on a vm and on a real host, and no luck so
>> far. I've got a few followup questions as your report is missing some
>> important info:
> 
> You may want to try much higher -p/-n numbers.
> 
> For verification purpose, I normally go with -p 10 -n 10000, which has a
> much higher chance to hit, but definitely too noisy for debug.
> 
> I just tried a run with "$fsstress -p 10 -n 10000 -w -d $mnt" as the
> workload, it failed at 21/1024.

OK I'll try that.

>> 1) What kernel are you running?
> 
> David's misc-next branch, aka, lastest upstream tags plus some btrfs
> patches for the next merge window.
> 
> Although I have some internal reports showing this problem quite some
> time ago.

That's what I was getting at, if it was new or not.

>> 2) What's the .config you are using?
> 
> Pretty common config, no heavy debug options (KASAN etc).

Please just send the .config, I'd rather not have to guess. Things like
preempt etc may make a difference in reproducing this.

>>> At least here, with a VM with 6 cores (host has 8C/16T), fast enough
>>> storage (PCIE4.0 NVME, with unsafe cache mode), it has the chance around
>>> 1/100 to hit the error.
>>
>> What does "unsafe cche mode" mean?
> 
> Libvirt cache option "unsafe"
> 
> Which is mostly ignoring flush/fua commands and fully rely on host fs
> (in my case it's file backed) cache.

Gotcha

>> Is that write back caching enabled?
>> Write back caching with volatile write cache? For your device, can you
>> do:
>>
>> $ grep . /sys/block/$dev/queue/*
>>
>>> Checking the fsstress verbose log against the failed file, it turns out
>>> to be an io_uring write.
>>
>> Any more details on what the write looks like?
> 
> For the involved file, it shows the following operations for the minimal
> reproducible seed/-p/-n combination:
> 
> ```
> 0/24: link d0/f2 d0/f3 0
> 0/29: fallocate(INSERT_RANGE) d0/f3 [276 2 0 0 176 481971]t 884736 585728 95
> 0/30: uring_write d0/f3[276 2 0 0 176 481971] [1400622, 56456(res=56456)] 0
> 0/31: writev d0/f3[276 2 0 0 296 1457078] [709121,8,964] 0
> 0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[276 2 308134 1763236 320
> 1457078] return 25, fallback to stat()
> 0/34: dwrite d0/f3[276 2 308134 1763236 320 1457078] [589824,16384] 0
> 0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[276 2 308134 1763236 496
> 1457078] return 25, fallback to stat()
> 0/38: dwrite d0/f3[276 2 308134 1763236 496 1457078] [2084864,36864] 0
> 0/40: fallocate(ZERO_RANGE) d0/f3 [276 2 308134 1763236 688 2809139]t
> 3512660 81075 0
> 0/43: splice d0/f5[289 1 0 0 1872 2678784] [552619,59420] -> d0/f3[276 2
> 308134 1763236 856 3593735] [5603798,59420] 0
> 0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [276 1 308134 1763236 976
> 5663218]t 1361821 480392 0
> 0/49: clonerange d0/f3[276 1 308134 1763236 856 5663218] [2461696,53248]
> -> d0/f5[289 1 0 0 1872 2678784] [942080,53248]
> ```

And just to be sure, this is not mixing dio and buffered, right?

>>> However I didn't see any io_uring related callback inside btrfs code,
>>> any advice on the io_uring part would be appreciated.
>>
>> io_uring doesn't do anything special here, it uses the normal page cache
>> read/write parts for buffered IO. But you may get extra parallellism
>> with io_uring here. For example, with the buffered write that this most
>> likely is, libaio would be exactly the same as a pwrite(2) on the file.
>> If this would've blocked, io_uring would offload this to a helper
>> thread. Depending on the workload, you could have multiple of those in
>> progress at the same time.
> 
> My biggest concern is, would io_uring modify the page when it's still
> under writeback?

No, of course not. Like I mentioned, io_uring doesn't do anything that
the normal read/write path isn't already doing - it's using the same
->read_iter() and ->write_iter() that everything else is, there's no
page cache code in io_uring.

> In that case, it's going to cause csum mismatch as btrfs relies on the
> page under writeback to be unchanged.

Sure, I'm aware of the stable page requirements.

See my followup email as well on a patch to test as well.

-- 
Jens Axboe

