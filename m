Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A688A3D6453
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 18:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhGZP41 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 11:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240447AbhGZPza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 11:55:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BA4C061757
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:35:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l19so13738365pjz.0
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fRzRMnJ321F3ZCc/Gr2WoKYRzIp8+yXjLbA7+YSI7a0=;
        b=FZtcyIWejZhUqfcx6d5vOh7RAKruQD4MsyWpW4J2IJudLpilH9M1n+/uRgTTFAILdg
         ustb60IMEFahVK4D/lQeEYEMqRbpYfY00JnLLPtxdl8imR0hf73l3eIhWFGMgF58TuPg
         xrkYsJmKkeq9cqsNIWCWCJWxY55ec7+f9bivSndc3Wk68hdzGC6pmhWATOJ56LO1r/4j
         pMxDFNbs/S+pT/srg90IHPETTUnWQLu1VWP8hOX6+ZgfHYcbkTUjhWc96C4qUFowXiSp
         1ObmilIGZSSw9v2FdwVvjPTe2ZFBq2atA3jOYYNGoJZFVRcR4ztjo8oweCQqedeGn4F+
         8W0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fRzRMnJ321F3ZCc/Gr2WoKYRzIp8+yXjLbA7+YSI7a0=;
        b=rBMPob4rADoI3wFWkNYkvwCw9nSNc353yi40kgicMKDmm3bjzI+ntcAQxnG5/si6fX
         LaNX2Hp+CpxW9aULvWAygRfTcj/0urpIj08grYtJmTRF7uF0CW0M/rHAG3uG2uazxq4d
         Lc/zAqRPWAGyBkgLhtnFO91tKQkrTeRDR3ac9s3OlhOHy0PnprEVlPrKCRJ0g1Pb+VIT
         JNcjFRLiZA74TMgvj1Vovai404Dl+hUr9Hdv00RFUQBKQFPAZaGpLXEfWeDJGMpcHyUz
         LE/jjSvXX1QsAinT/EJs9Iup8pQwhZkLlP737ZebU5Yuo0eIe9gVSwfMrtmsT4HGe0dm
         xgPA==
X-Gm-Message-State: AOAM531St5JZAq1kalh2og1SmmrQb7ogTu9jDi/W8hmzSqcs+oHyK+E+
        FmSL/W/SyLB+x/1sL+lfjkOagipqYrGh4bMb
X-Google-Smtp-Source: ABdhPJwb6m8ndJEszHojGSkFZx6T2ufCddsfGwZWiLUaoV+nr/NuDdQVQUqEr7I3+SS/QlfJfug+gQ==
X-Received: by 2002:a17:903:230b:b029:129:bd60:cd20 with SMTP id d11-20020a170903230bb0290129bd60cd20mr15031732plh.72.1627317357924;
        Mon, 26 Jul 2021 09:35:57 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id p53sm480119pfw.168.2021.07.26.09.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:35:57 -0700 (PDT)
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
From:   Jens Axboe <axboe@kernel.dk>
To:     Forza <forza@tnonline.net>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
 <ccb2cce6-cb7b-6d94-e7b9-dca724cef930@kernel.dk>
Message-ID: <58316a28-ca37-2eab-3d07-48227649dad8@kernel.dk>
Date:   Mon, 26 Jul 2021 10:35:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ccb2cce6-cb7b-6d94-e7b9-dca724cef930@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/21 10:07 AM, Jens Axboe wrote:
> On 7/24/21 1:51 PM, Forza wrote:
>>
>>
>> On 2021-07-24 21:44, Jens Axboe wrote:
>>> On 7/24/21 12:23 PM, Forza wrote:
>>>> Hi!
>>>>
>>>> On 2021-07-24 19:04, Jens Axboe wrote:
>>>>> I'll see if I can reproduce this. I'm assuming samba is using buffered
>>>>> IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
>>>>> possible to reproduce without samba with a windows client, as I don't
>>>>> have any of those. If synthetic reproducing fails, I can try samba
>>>>> with a Linux client.
>>>>
>>>> I attached the logs from both a Windows 10 client and a Linux client
>>>> (kernel 5.11.0).
>>>>
>>>> https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
>>>>
>>>>     smbd_smb2_read: fnum 2641229669, file
>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>> offset=736100352 read=4194304
>>>> [2021/07/24 17:26:09.120779,  3]
>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>     smbd_smb2_read: fnum 2641229669, file
>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>> offset=740294656 read=4194304
>>>> [2021/07/24 17:26:09.226593,  3]
>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>     smbd_smb2_read: fnum 2641229669, file
>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>> offset=748683264 read=4194304
>>>
>>> Thanks, this is useful. Before I try and reproduce it, what is the
>>> filesystem that is hosting the samba mount?
>>>
>>
>> I am using Btrfs.
>>
>> My testing was done by exporting the share with
>>
>>    vfs objects = io_uring
>>    vfs objects = btrfs, io_uring
>>
>> Same results in both cases. Exporting with "vfs objects = btrfs" (no 
>> io_uring) works as expected.
> 
> Seems to be specific to btrfs, I can reproduce it here. I'll dive in
> and see what I can find.

This looks like a race in dealing with the task_work running. At least
this on top of current -git closes the gap for me and I can't reproduce
it anymore.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4d2b320cdd4..998a01cbc00f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1959,9 +1959,13 @@ static void tctx_task_work(struct callback_head *cb)
 			node = next;
 		}
 		if (wq_list_empty(&tctx->task_list)) {
+			spin_lock_irq(&tctx->task_lock);
 			clear_bit(0, &tctx->task_state);
-			if (wq_list_empty(&tctx->task_list))
+			if (wq_list_empty(&tctx->task_list)) {
+				spin_unlock_irq(&tctx->task_lock);
 				break;
+			}
+			spin_unlock_irq(&tctx->task_lock);
 			/* another tctx_task_work() is enqueued, yield */
 			if (test_and_set_bit(0, &tctx->task_state))
 				break;

-- 
Jens Axboe

