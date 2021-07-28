Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D103D8B55
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 12:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235619AbhG1KCM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 06:02:12 -0400
Received: from pio-pvt-msa3.bahnhof.se ([79.136.2.42]:44844 "EHLO
        pio-pvt-msa3.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhG1KCM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 06:02:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTP id A31793F3AD;
        Wed, 28 Jul 2021 12:02:09 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.99
X-Spam-Level: 
X-Spam-Status: No, score=-2.99 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, NICE_REPLY_A=-1.091, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from pio-pvt-msa3.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa3.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YzhRDma9BRDo; Wed, 28 Jul 2021 12:02:08 +0200 (CEST)
Received: by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTPA id 4928B3F36D;
        Wed, 28 Jul 2021 12:02:08 +0200 (CEST)
Received: from [192.168.0.10] (port=52288)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1m8gO7-000BlX-Oi; Wed, 28 Jul 2021 12:02:07 +0200
From:   Forza <forza@tnonline.net>
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
 <ccb2cce6-cb7b-6d94-e7b9-dca724cef930@kernel.dk>
 <58316a28-ca37-2eab-3d07-48227649dad8@kernel.dk>
Message-ID: <e7f41c88-5f51-ddd4-be9a-fcd44cb20178@tnonline.net>
Date:   Wed, 28 Jul 2021 12:02:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <58316a28-ca37-2eab-3d07-48227649dad8@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2021-07-26 18:35, Jens Axboe wrote:
> On 7/26/21 10:07 AM, Jens Axboe wrote:
>> On 7/24/21 1:51 PM, Forza wrote:
>>>
>>>
>>> On 2021-07-24 21:44, Jens Axboe wrote:
>>>> On 7/24/21 12:23 PM, Forza wrote:
>>>>> Hi!
>>>>>
>>>>> On 2021-07-24 19:04, Jens Axboe wrote:
>>>>>> I'll see if I can reproduce this. I'm assuming samba is using buffered
>>>>>> IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
>>>>>> possible to reproduce without samba with a windows client, as I don't
>>>>>> have any of those. If synthetic reproducing fails, I can try samba
>>>>>> with a Linux client.
>>>>>
>>>>> I attached the logs from both a Windows 10 client and a Linux client
>>>>> (kernel 5.11.0).
>>>>>
>>>>> https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
>>>>>
>>>>>      smbd_smb2_read: fnum 2641229669, file
>>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>>> offset=736100352 read=4194304
>>>>> [2021/07/24 17:26:09.120779,  3]
>>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>>      smbd_smb2_read: fnum 2641229669, file
>>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>>> offset=740294656 read=4194304
>>>>> [2021/07/24 17:26:09.226593,  3]
>>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>>      smbd_smb2_read: fnum 2641229669, file
>>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>>> offset=748683264 read=4194304
>>>>
>>>> Thanks, this is useful. Before I try and reproduce it, what is the
>>>> filesystem that is hosting the samba mount?
>>>>
>>>
>>> I am using Btrfs.
>>>
>>> My testing was done by exporting the share with
>>>
>>>     vfs objects = io_uring
>>>     vfs objects = btrfs, io_uring
>>>
>>> Same results in both cases. Exporting with "vfs objects = btrfs" (no
>>> io_uring) works as expected.
>>
>> Seems to be specific to btrfs, I can reproduce it here. I'll dive in
>> and see what I can find.
> 
> This looks like a race in dealing with the task_work running. At least
> this on top of current -git closes the gap for me and I can't reproduce
> it anymore.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c4d2b320cdd4..998a01cbc00f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1959,9 +1959,13 @@ static void tctx_task_work(struct callback_head *cb)
>   			node = next;
>   		}
>   		if (wq_list_empty(&tctx->task_list)) {
> +			spin_lock_irq(&tctx->task_lock);
>   			clear_bit(0, &tctx->task_state);
> -			if (wq_list_empty(&tctx->task_list))
> +			if (wq_list_empty(&tctx->task_list)) {
> +				spin_unlock_irq(&tctx->task_lock);
>   				break;
> +			}
> +			spin_unlock_irq(&tctx->task_lock);
>   			/* another tctx_task_work() is enqueued, yield */
>   			if (test_and_set_bit(0, &tctx->task_state))
>   				break;
> 

Thanks! Is there a way to get this on current stable such as 5.13.5?

