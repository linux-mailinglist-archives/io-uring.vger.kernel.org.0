Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A518781DF7
	for <lists+io-uring@lfdr.de>; Sun, 20 Aug 2023 15:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjHTN3J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Aug 2023 09:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjHTN3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Aug 2023 09:29:06 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C813ABA
        for <io-uring@vger.kernel.org>; Sun, 20 Aug 2023 06:26:10 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-68824a0e747so633679b3a.1
        for <io-uring@vger.kernel.org>; Sun, 20 Aug 2023 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692537970; x=1693142770;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Y8H8y5zFNFDYQYSeQ2r9O8Y7olHEar6aRapmNwjHX4=;
        b=3+fLC/xb3ymXp4pJtWL1TGA5x64zOFY7dT/Im4SQW0vb2B4UlUQZC6wuq4hbg7+zhC
         MdJlcnC+NITSyybv9vSBs5xlzLOkL3dfGbG+Qdsuto6gRpvPbij+pJny8GhVE22AM+ow
         JSAP7AZ47ubxKGpkV1f0oQP5ElKxtwJ4uPrfhvTSF1/+srFI/aHhWYkXqJWdQmL5cZm/
         T7pXZR0DS9TzoEVHEQ9rfGHh6hkPlIGxlBnfQ0yDPHSNmouJhMfygbGC+XbP1/heLYjn
         OoTmCKm1xgmon/Na1F2QFFWceKTfgbJlsLARTag6e4VvaSCii7UGX5rL8ajNAZr6LpI6
         S/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692537970; x=1693142770;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Y8H8y5zFNFDYQYSeQ2r9O8Y7olHEar6aRapmNwjHX4=;
        b=D5QOwLq+sBzG9cqQEa+3H8lvRDhvW6P+/v6uolinDBWbiZof9Hjqv5a4acDh9jX2mQ
         K/CLnRUbXml5Oi/iyggkICeW3C4Ia5G0J21DbYWXLDV5uq3b5EhnKNx6dWAMpHskGpOJ
         Xpwep20wLUTCivt/BLJ1MC4HapGfmYxMf+GoJasDvnN9m4ZrN+/Iw4RpkKRDtEpmqgy9
         Rt+kQc4t/OnVPHHgO+LjK3ufvvvP+jIfjRERaqCTSjAl1G/+OWWOuD/O2luxtQc3+2jQ
         EeqUlxigpt1uwYKGALXJUSjXRmGroLhQHoKghkxqxorZ2eYDpw8HHH445yXB9CxBCAGq
         AwpQ==
X-Gm-Message-State: AOJu0Yz/eagIzk+47R5QONjG9BwUHVzpgdytm7juENawV5b2yOMikoMY
        48OmMmavNuSmtbMz6QjL6q7XmzZdd20TUgOBSiQ=
X-Google-Smtp-Source: AGHT+IFYANbJXEAwsdkLcCfyugouz96atU5SY9hkEKPqcllo/B2WHR/ZFCPaJLRkHj9jvR4wjCdwVA==
X-Received: by 2002:a17:903:32c1:b0:1bf:349f:b85c with SMTP id i1-20020a17090332c100b001bf349fb85cmr5197380plr.1.1692537970242;
        Sun, 20 Aug 2023 06:26:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u18-20020a17090341d200b001b9d95945afsm5117148ple.155.2023.08.20.06.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Aug 2023 06:26:09 -0700 (PDT)
Message-ID: <8efc73c1-3fdc-4fc3-9906-0129ff386f20@kernel.dk>
Date:   Sun, 20 Aug 2023 07:26:08 -0600
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
 <d67e7236-a9e4-421c-b5bf-a4b25748cac2@kernel.dk>
 <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
 <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
 <e7bcab0b-d894-40e8-b65c-caa846149608@gmx.com>
 <ee0b1a74-67e3-4b71-bccf-8ecc5fa3819a@kernel.dk>
 <34e2030c-5247-4c1f-bd18-a0008a660746@gmx.com>
 <b60cf9c7-b26d-4871-a3c9-08e030b68df4@kernel.dk>
 <1726ad73-fabb-4c93-8e8c-6d2aab9a0bb0@gmx.com>
 <7526b413-6052-4c2d-9e5b-7d0e4abee1b7@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7526b413-6052-4c2d-9e5b-7d0e4abee1b7@gmx.com>
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

On 8/19/23 6:22 PM, Qu Wenruo wrote:
> 
> 
> On 2023/8/20 07:59, Qu Wenruo wrote:
>> Hi Jens
>>
>> I tried more on my side to debug the situation, and found a very weird
>> write behavior:
>>
>>      Some unexpected direct IO happened, without corresponding
>>      fsstress workload.
>>
>> The workload is:
>>
>>      $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt -v > /tmp/fsstress
>>
>> Which I can reliably reproduce the problem locally, around 1/50
>> possibility.
>> In my particular case, it results data corruption at root 5 inode 283
>> offset 8192.
>>
>> Then I added some trace points for the following functions:
>>
>> - btrfs_do_write_iter()
>>    Two trace points, one before btrfs_direct_write(), and one
>>    before btrfs_buffered_write(), outputting the aligned and unaligned
>>    write range, root/inode number, type of the write (buffered or
>>    direct).
>>
>> - btrfs_finish_one_ordered()
>>    This is where btrfs inserts its ordered extent into the subvolume
>>    tree.
>>    This happens when a range of pages finishes its writeback.
>>
>> Then here comes the fsstress log for inode 283 (no btrfs root number):
>>
>> 0/22: clonerange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>> [307200,0]
>> 0/23: copyrange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>> [1058819,0]
>> 0/25: write d0/f2[283 2 0 0 0 0] [393644,88327] 0
>> 0/29: fallocate(INSERT_RANGE) d0/f3 [283 2 0 0 176 481971]t 884736
>> 585728 95
>> 0/30: uring_write d0/f3[283 2 0 0 176 481971] [1400622, 56456(res=56456)] 0
>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[283 2 308134 1763236 320
>> 1457078] return 25, fallback to stat()
>> 0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 320
>> 1457078] return 25, fallback to stat()
>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
>> 0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 496
>> 1457078] return 25, fallback to stat()
>> 0/38: dwrite d0/f3[283 2 308134 1763236 496 1457078] [2084864,36864] 0
>> 0/39: write d0/d4/f6[283 2 308134 1763236 496 2121728] [2749000,60139] 0
>> 0/40: fallocate(ZERO_RANGE) d0/f3 [283 2 308134 1763236 688 2809139]t
>> 3512660 81075 0
>> 0/43: splice d0/f5[293 1 0 0 1872 2678784] [552619,59420] -> d0/f3[283 2
>> 308134 1763236 856 3593735] [5603798,59420] 0
>> 0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [283 1 308134 1763236 976
>> 5663218]t 1361821 480392 0
>> 0/49: clonerange d0/f3[283 1 308134 1763236 856 5663218] [2461696,53248]
>> -> d0/f5[293 1 0 0 1872 2678784] [942080,53248]
>>
>> Note one thing, there is no direct/buffered write into inode 283 offset
>> 8192.
>>
>> But from the trace events for root 5 inode 283:
>>
>>   btrfs_do_write_iter: r/i=5/283 buffered fileoff=393216(393644)
>> len=90112(88327)
>>   btrfs_do_write_iter: r/i=5/283 buffered fileoff=1396736(1400622)
>> len=61440(56456)
>>   btrfs_do_write_iter: r/i=5/283 buffered fileoff=708608(709121)
>> len=12288(7712)
>>
>>   btrfs_do_write_iter: r/i=5/283 direct fileoff=8192(8192)
>> len=73728(73728) <<<<<
>>
>>   btrfs_do_write_iter: r/i=5/283 direct fileoff=589824(589824)
>> len=16384(16384)
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=8192 len=73728
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=589824 len=16384
>>   btrfs_do_write_iter: r/i=5/283 direct fileoff=2084864(2084864)
>> len=36864(36864)
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=2084864 len=36864
>>   btrfs_do_write_iter: r/i=5/283 buffered fileoff=2748416(2749000)
>> len=61440(60139)
>>   btrfs_do_write_iter: r/i=5/283 buffered fileoff=5603328(5603798)
>> len=61440(59420)
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=393216 len=90112
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=708608 len=12288
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=1396736 len=61440
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=3592192 len=4096
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=2748416 len=61440
>>   btrfs_finish_one_ordered: r/i=5/283 fileoff=5603328 len=61440
>>
>> Note that phantom direct IO call, which is in the corrupted range.
>>
>> If paired with fsstress, that phantom write happens between the two
>> operations:
>>
>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
> 
> Just to be more accurate, there is a 0/33 operation, which is:
> 
> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[285 2 308134 1763236 320
> 1457078] return 25, fallback to stat()
> 0/33: awrite - io_getevents failed -4
> 
> The failed one doesn't have inode number thus it didn't get caught by grep.
> 
> Return value -4 means -INTR, not sure who sent the interruption.
> But if this interruption happens before the IO finished, we can call
> free() on the buffer, and if we're unlucky enough, the freed memory can
> be re-allocated for some other usage, thus modifying the pages before
> the writeback finished.
> 
> I think this is the direct cause of the data corruption, page
> modification before direct IO finished.
> 
> But unfortunately I still didn't get why the interruption can happen,
> nor how can we handle such interruption?
> (I guess just retry?)

It's because you are mixing aio/io_uring, and the default settings for
io_uring is to use signal based notifications for queueing task_work.
This then causes a spurious -EINTR, which stops your io_getevents()
wait. Looks like this is a bug in fsstress, it should just retry the
wait if this happens. You can also configure the ring to not use signal
based notifications, but that bug needs fixing regardless.

-- 
Jens Axboe

