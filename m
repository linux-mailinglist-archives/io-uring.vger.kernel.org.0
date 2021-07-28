Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723B93D90C1
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 16:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhG1OgA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 10:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhG1OgA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 10:36:00 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841EC061757
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 07:35:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i10so2953501pla.3
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 07:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tGgbYRCfKfmbwY0VEpOHN2/Noaaj0A4POap97Xl4XyU=;
        b=fb0l9mnH7UghpzVWpTq1D4qehpQ9knU+arCsolY+4QXp1KiSPG3jY9bbTRzSZE+4dU
         kPqAI/XJ/yNlKKJ/H4lN9TdDI9xmbshUBJ2teT+fF5UKCXym/RvvCj0VuRlckpSD1f8V
         TFQ3cIwQr5+Cb4r1oo6hO7MkJw4Byihp4mp7XAkfKAZquMFkvGDKoWMZ5tPzW5RlwRB5
         pnBi3xa4rfxVL1X0ZvlAqJmQVNo1h4UPRw5+jn0ocOrmsMPgcDDT0pQO7kUazdnn3/Yy
         TbVjQHmmDXazwgQaiXkL3ab5MSL0UG3kw22bFrBkL4KpxPg8QgWNFG6eMY32F04PHDih
         Mkiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tGgbYRCfKfmbwY0VEpOHN2/Noaaj0A4POap97Xl4XyU=;
        b=qsvY2/RS9X+lkNZX+cxyp+fTMjVnX+wiqph6GsVDsyySXWjXq6N8V/3XqXI+iLZe1V
         CuCNIrZhKD42/utpNlQiqtxADhFuMk3KGSRnGubmsFOUkgN5pL8M/pIx5XHkRkwWk/O0
         XmEfNPPrTY0oud8DteZPPKEddGRE1qeHvDxgVUmY9YGfBxSnFqV7OeTRJ86f7W/7/+p9
         +gtVfvLVFxEjbAEbaEVVhguAHeSNFKWz1jhhjQmzOl5EAliMHHqWwU5aYGIzbfsRObc9
         JBhnyJi1IeVGgam0mk9Km7J3i2yoxuUUFwkHvmTifP5zJSkywvSCt687AGpbzgFAwYM2
         Syhw==
X-Gm-Message-State: AOAM531pPI7XbgNlF58d3ZxAgqyndmKniLk6E6Ox8MF+1lxreDIxfO2r
        KZM1GxtOVTgqltpC+6qW9CGZG5ouG1rlpAUk
X-Google-Smtp-Source: ABdhPJzrWeV3XviRbG9ug7i+fiuME/ZVETF4xyTBRGUEsK/k4Y6iY+v1QUd/3aXzezsxaDJ2z3p48Q==
X-Received: by 2002:a63:3ec1:: with SMTP id l184mr120136pga.39.1627482958207;
        Wed, 28 Jul 2021 07:35:58 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id ms8sm687637pjb.36.2021.07.28.07.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 07:35:57 -0700 (PDT)
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Forza <forza@tnonline.net>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
 <ccb2cce6-cb7b-6d94-e7b9-dca724cef930@kernel.dk>
 <58316a28-ca37-2eab-3d07-48227649dad8@kernel.dk>
 <e7f41c88-5f51-ddd4-be9a-fcd44cb20178@tnonline.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5ee2467b-0de1-eb7e-ccdb-a0e73eb305bd@kernel.dk>
Date:   Wed, 28 Jul 2021 08:35:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e7f41c88-5f51-ddd4-be9a-fcd44cb20178@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/28/21 4:02 AM, Forza wrote:
> 
> 
> On 2021-07-26 18:35, Jens Axboe wrote:
>> On 7/26/21 10:07 AM, Jens Axboe wrote:
>>> On 7/24/21 1:51 PM, Forza wrote:
>>>>
>>>>
>>>> On 2021-07-24 21:44, Jens Axboe wrote:
>>>>> On 7/24/21 12:23 PM, Forza wrote:
>>>>>> Hi!
>>>>>>
>>>>>> On 2021-07-24 19:04, Jens Axboe wrote:
>>>>>>> I'll see if I can reproduce this. I'm assuming samba is using buffered
>>>>>>> IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
>>>>>>> possible to reproduce without samba with a windows client, as I don't
>>>>>>> have any of those. If synthetic reproducing fails, I can try samba
>>>>>>> with a Linux client.
>>>>>>
>>>>>> I attached the logs from both a Windows 10 client and a Linux client
>>>>>> (kernel 5.11.0).
>>>>>>
>>>>>> https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
>>>>>>
>>>>>>      smbd_smb2_read: fnum 2641229669, file
>>>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>>>> offset=736100352 read=4194304
>>>>>> [2021/07/24 17:26:09.120779,  3]
>>>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>>>      smbd_smb2_read: fnum 2641229669, file
>>>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>>>> offset=740294656 read=4194304
>>>>>> [2021/07/24 17:26:09.226593,  3]
>>>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>>>      smbd_smb2_read: fnum 2641229669, file
>>>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>>>> offset=748683264 read=4194304
>>>>>
>>>>> Thanks, this is useful. Before I try and reproduce it, what is the
>>>>> filesystem that is hosting the samba mount?
>>>>>
>>>>
>>>> I am using Btrfs.
>>>>
>>>> My testing was done by exporting the share with
>>>>
>>>>     vfs objects = io_uring
>>>>     vfs objects = btrfs, io_uring
>>>>
>>>> Same results in both cases. Exporting with "vfs objects = btrfs" (no
>>>> io_uring) works as expected.
>>>
>>> Seems to be specific to btrfs, I can reproduce it here. I'll dive in
>>> and see what I can find.
>>
>> This looks like a race in dealing with the task_work running. At least
>> this on top of current -git closes the gap for me and I can't reproduce
>> it anymore.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c4d2b320cdd4..998a01cbc00f 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1959,9 +1959,13 @@ static void tctx_task_work(struct callback_head *cb)
>>   			node = next;
>>   		}
>>   		if (wq_list_empty(&tctx->task_list)) {
>> +			spin_lock_irq(&tctx->task_lock);
>>   			clear_bit(0, &tctx->task_state);
>> -			if (wq_list_empty(&tctx->task_list))
>> +			if (wq_list_empty(&tctx->task_list)) {
>> +				spin_unlock_irq(&tctx->task_lock);
>>   				break;
>> +			}
>> +			spin_unlock_irq(&tctx->task_lock);
>>   			/* another tctx_task_work() is enqueued, yield */
>>   			if (test_and_set_bit(0, &tctx->task_state))
>>   				break;
>>
> 
> Thanks! Is there a way to get this on current stable such as 5.13.5?

Yes, we'll get it to stable once it's upstream. For your particular
testing, not sure there's an easy way... You'd have to apply it to
5.13.5 and compile it on your own, I'm afraid.

If all else fails, hopefully it'll be in 5.13.6 and you can re-test
with that :-)

-- 
Jens Axboe

