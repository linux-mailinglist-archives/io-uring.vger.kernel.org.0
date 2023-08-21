Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723E6782CCC
	for <lists+io-uring@lfdr.de>; Mon, 21 Aug 2023 16:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjHUO5T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Aug 2023 10:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjHUO5T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Aug 2023 10:57:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50F9E7
        for <io-uring@vger.kernel.org>; Mon, 21 Aug 2023 07:57:16 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1befe39630bso6009625ad.0
        for <io-uring@vger.kernel.org>; Mon, 21 Aug 2023 07:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692629836; x=1693234636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ehHNOZweoowUc0DzmY0b8uIlslVryQh97hJthvB9WI4=;
        b=kh8DvyaqdPdKMNP7bquEg4p4K7+/rIz7lRPgqqSUFWx21lRuEd8HULSBarBhqcThmE
         V7ALxZV4kb5J/AvZ1yVkbdCEdDth52wDKxq9PzPZnAHep3yqXLYgxV5Vxg3tCa/M0ajS
         xBe1PsPgiZx3FR7rhoxKAxq+xDM/X9sCLcPDcF8eHf8OrIQnfUey5QVWG4yWM4Du+m3n
         C6AvNS6KBrJvpLuninHwipI7lCZf8maYAp7AQlpMJb+BQSoVCONfzsF3T7ADk7CGK+E5
         nC45Rkazlhx5Vt7zeTUC9VhLoQ0EY0keIPLGmTOdve4b5oCOeJuiUEC5eJWH5x0XpGeT
         P4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692629836; x=1693234636;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehHNOZweoowUc0DzmY0b8uIlslVryQh97hJthvB9WI4=;
        b=PTpx0AY2oyh/UB6HLAFUz8XAggXG0nbeLcv7RoUMM77Wh3/10X9WT38szd6+qjKqGh
         L4dL+gcXPamGc7vViM+q/My1PuNasyRCkeiY7xgyacspMfoM7a0a/lk6N2HC1BwYpDiN
         HV2SgW7xzHXVT/eRj3O4xFCDd9NlwLskO+F7VkCteP194LHsHBtboepT6eHJVTUhzUGk
         i6lOWOw3FRwBPhtRsRTX2EnM6TAfyOzzOt0XUbO1G6SqR8V/fK27AyGd0KfzPXXXOgY4
         fgWUzqwwl+U5XapODk2A0j5rOuSDqC8epun6jPrRCPs8PVvsUhHhyIsAInRm/k8R7da9
         uKvg==
X-Gm-Message-State: AOJu0Yz5abuXKQLMgv++TgVouaw/1I5fWBX+ZCwf8YIrujRRMtx07Sg5
        2tRMoksn4aCURdFHcsKllSaB0g==
X-Google-Smtp-Source: AGHT+IGlbCUHwn4Yq3jcV40EeMxWf4KsGEq3FGzxfztkb4smLgDelTbKNvvGcIJHWtE0koBrgvQLPg==
X-Received: by 2002:a17:902:ec90:b0:1b8:95fc:cfe with SMTP id x16-20020a170902ec9000b001b895fc0cfemr8461836plg.3.1692629836267;
        Mon, 21 Aug 2023 07:57:16 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902740300b001bdc50316c3sm1168109pll.232.2023.08.21.07.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 07:57:15 -0700 (PDT)
Message-ID: <267b968a-e1a8-4b6d-9e78-97e295121cce@kernel.dk>
Date:   Mon, 21 Aug 2023 08:57:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
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
 <8efc73c1-3fdc-4fc3-9906-0129ff386f20@kernel.dk>
 <22e28af8-b11b-4d0f-954b-8f5504f8d9e4@kernel.dk>
 <71feba44-9b2c-48cd-9fe3-9f057145588f@gmx.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <71feba44-9b2c-48cd-9fe3-9f057145588f@gmx.com>
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

On 8/20/23 6:38 PM, Qu Wenruo wrote:
> 
> 
> On 2023/8/20 22:11, Jens Axboe wrote:
>> On 8/20/23 7:26 AM, Jens Axboe wrote:
>>> On 8/19/23 6:22 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2023/8/20 07:59, Qu Wenruo wrote:
>>>>> Hi Jens
>>>>>
>>>>> I tried more on my side to debug the situation, and found a very weird
>>>>> write behavior:
>>>>>
>>>>>       Some unexpected direct IO happened, without corresponding
>>>>>       fsstress workload.
>>>>>
>>>>> The workload is:
>>>>>
>>>>>       $fsstress -p 7 -n 50 -s 1691396493 -w -d $mnt -v > /tmp/fsstress
>>>>>
>>>>> Which I can reliably reproduce the problem locally, around 1/50
>>>>> possibility.
>>>>> In my particular case, it results data corruption at root 5 inode 283
>>>>> offset 8192.
>>>>>
>>>>> Then I added some trace points for the following functions:
>>>>>
>>>>> - btrfs_do_write_iter()
>>>>>     Two trace points, one before btrfs_direct_write(), and one
>>>>>     before btrfs_buffered_write(), outputting the aligned and unaligned
>>>>>     write range, root/inode number, type of the write (buffered or
>>>>>     direct).
>>>>>
>>>>> - btrfs_finish_one_ordered()
>>>>>     This is where btrfs inserts its ordered extent into the subvolume
>>>>>     tree.
>>>>>     This happens when a range of pages finishes its writeback.
>>>>>
>>>>> Then here comes the fsstress log for inode 283 (no btrfs root number):
>>>>>
>>>>> 0/22: clonerange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>>>>> [307200,0]
>>>>> 0/23: copyrange d0/f2[283 1 0 0 0 0] [0,0] -> d0/f2[283 1 0 0 0 0]
>>>>> [1058819,0]
>>>>> 0/25: write d0/f2[283 2 0 0 0 0] [393644,88327] 0
>>>>> 0/29: fallocate(INSERT_RANGE) d0/f3 [283 2 0 0 176 481971]t 884736
>>>>> 585728 95
>>>>> 0/30: uring_write d0/f3[283 2 0 0 176 481971] [1400622, 56456(res=56456)] 0
>>>>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>>>>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[283 2 308134 1763236 320
>>>>> 1457078] return 25, fallback to stat()
>>>>> 0/34: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 320
>>>>> 1457078] return 25, fallback to stat()
>>>>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
>>>>> 0/38: dwrite - xfsctl(XFS_IOC_DIOINFO) d0/f3[283 2 308134 1763236 496
>>>>> 1457078] return 25, fallback to stat()
>>>>> 0/38: dwrite d0/f3[283 2 308134 1763236 496 1457078] [2084864,36864] 0
>>>>> 0/39: write d0/d4/f6[283 2 308134 1763236 496 2121728] [2749000,60139] 0
>>>>> 0/40: fallocate(ZERO_RANGE) d0/f3 [283 2 308134 1763236 688 2809139]t
>>>>> 3512660 81075 0
>>>>> 0/43: splice d0/f5[293 1 0 0 1872 2678784] [552619,59420] -> d0/f3[283 2
>>>>> 308134 1763236 856 3593735] [5603798,59420] 0
>>>>> 0/48: fallocate(KEEP_SIZE|PUNCH_HOLE) d0/f3 [283 1 308134 1763236 976
>>>>> 5663218]t 1361821 480392 0
>>>>> 0/49: clonerange d0/f3[283 1 308134 1763236 856 5663218] [2461696,53248]
>>>>> -> d0/f5[293 1 0 0 1872 2678784] [942080,53248]
>>>>>
>>>>> Note one thing, there is no direct/buffered write into inode 283 offset
>>>>> 8192.
>>>>>
>>>>> But from the trace events for root 5 inode 283:
>>>>>
>>>>>    btrfs_do_write_iter: r/i=5/283 buffered fileoff=393216(393644)
>>>>> len=90112(88327)
>>>>>    btrfs_do_write_iter: r/i=5/283 buffered fileoff=1396736(1400622)
>>>>> len=61440(56456)
>>>>>    btrfs_do_write_iter: r/i=5/283 buffered fileoff=708608(709121)
>>>>> len=12288(7712)
>>>>>
>>>>>    btrfs_do_write_iter: r/i=5/283 direct fileoff=8192(8192)
>>>>> len=73728(73728) <<<<<
>>>>>
>>>>>    btrfs_do_write_iter: r/i=5/283 direct fileoff=589824(589824)
>>>>> len=16384(16384)
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=8192 len=73728
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=589824 len=16384
>>>>>    btrfs_do_write_iter: r/i=5/283 direct fileoff=2084864(2084864)
>>>>> len=36864(36864)
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=2084864 len=36864
>>>>>    btrfs_do_write_iter: r/i=5/283 buffered fileoff=2748416(2749000)
>>>>> len=61440(60139)
>>>>>    btrfs_do_write_iter: r/i=5/283 buffered fileoff=5603328(5603798)
>>>>> len=61440(59420)
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=393216 len=90112
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=708608 len=12288
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=1396736 len=61440
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=3592192 len=4096
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=2748416 len=61440
>>>>>    btrfs_finish_one_ordered: r/i=5/283 fileoff=5603328 len=61440
>>>>>
>>>>> Note that phantom direct IO call, which is in the corrupted range.
>>>>>
>>>>> If paired with fsstress, that phantom write happens between the two
>>>>> operations:
>>>>>
>>>>> 0/31: writev d0/f3[283 2 0 0 296 1457078] [709121,8,964] 0
>>>>> 0/34: dwrite d0/f3[283 2 308134 1763236 320 1457078] [589824,16384] 0
>>>>
>>>> Just to be more accurate, there is a 0/33 operation, which is:
>>>>
>>>> 0/33: do_aio_rw - xfsctl(XFS_IOC_DIOINFO) d0/f2[285 2 308134 1763236 320
>>>> 1457078] return 25, fallback to stat()
>>>> 0/33: awrite - io_getevents failed -4
>>>>
>>>> The failed one doesn't have inode number thus it didn't get caught by grep.
>>>>
>>>> Return value -4 means -INTR, not sure who sent the interruption.
>>>> But if this interruption happens before the IO finished, we can call
>>>> free() on the buffer, and if we're unlucky enough, the freed memory can
>>>> be re-allocated for some other usage, thus modifying the pages before
>>>> the writeback finished.
>>>>
>>>> I think this is the direct cause of the data corruption, page
>>>> modification before direct IO finished.
>>>>
>>>> But unfortunately I still didn't get why the interruption can happen,
>>>> nor how can we handle such interruption?
>>>> (I guess just retry?)
>>>
>>> It's because you are mixing aio/io_uring, and the default settings for
>>> io_uring is to use signal based notifications for queueing task_work.
>>> This then causes a spurious -EINTR, which stops your io_getevents()
>>> wait. Looks like this is a bug in fsstress, it should just retry the
>>> wait if this happens. You can also configure the ring to not use signal
>>> based notifications, but that bug needs fixing regardless.
>>
>> Something like this will probably fix it.
>>
>>
>> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
>> index 6641a525fe5d..05fbfd3f8cf8 100644
>> --- a/ltp/fsstress.c
>> +++ b/ltp/fsstress.c
>> @@ -2072,6 +2072,23 @@ void inode_info(char *str, size_t sz, struct stat64 *s, int verbose)
>>                (long long) s->st_blocks, (long long) s->st_size);
>>   }
>>
>> +static int io_get_single_event(struct io_event *event)
>> +{
>> +    int ret;
>> +
>> +    do {
>> +        /*
>> +         * We can get -EINTR if competing with io_uring using signal
>> +         * based notifications. For that case, just retry the wait.
>> +         */
>> +        ret = io_getevents(io_ctx, 1, 1, event, NULL);
>> +        if (ret != -EINTR)
>> +            break;
>> +    } while (1);
>> +
>> +    return ret;
>> +}
>> +
>>   void
>>   afsync_f(opnum_t opno, long r)
>>   {
>> @@ -2111,7 +2128,7 @@ afsync_f(opnum_t opno, long r)
>>           close(fd);
>>           return;
>>       }
>> -    if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>> +    if ((e = io_get_single_event(&event)) != 1) {
>>           if (v)
>>               printf("%d/%lld: afsync - io_getevents failed %d\n",
>>                      procid, opno, e);
>> @@ -2220,10 +2237,10 @@ do_aio_rw(opnum_t opno, long r, int flags)
>>       if ((e = io_submit(io_ctx, 1, iocbs)) != 1) {
>>           if (v)
>>               printf("%d/%lld: %s - io_submit failed %d\n",
>> -                   procid, opno, iswrite ? "awrite" : "aread", e);
>> +                    procid, opno, iswrite ? "awrite" : "aread", e);
>>           goto aio_out;
>>       }
>> -    if ((e = io_getevents(io_ctx, 1, 1, &event, NULL)) != 1) {
>> +    if ((e = io_get_single_event(&event)) != 1) {
>>           if (v)
>>               printf("%d/%lld: %s - io_getevents failed %d\n",
>>                      procid, opno, iswrite ? "awrite" : "aread", e);
>>
> Exactly what I sent for fsstress:
> https://lore.kernel.org/linux-btrfs/20230820010219.12907-1-wqu@suse.com/T/#u

It's not really, as you only did the one case of io_getevents(). What
happens if the other one gets EINTR and aborts, now we do a rw operation
and the first event returned is the one from the fsync?

You should not just fix up the one that you happened to hit, fix up both
of them.

-- 
Jens Axboe

