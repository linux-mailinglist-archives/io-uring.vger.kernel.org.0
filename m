Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856903D612B
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhGZPaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 11:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbhGZP1K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 11:27:10 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5633C061765
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:07:33 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so687107pji.5
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 09:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0LWcxY/+T8JeRgoouM5EGNbfdZukYzbSTeRQ9t/AkwI=;
        b=yQumTqiWgakZzxiqFx7gV3A6IBRjHMJNTqwwYYnx7vHsKSgal7rKr5L+8jn5ogNduT
         6qdDMYsSi7yh7tzZM0gQRIS/WCJZyw9tlfSnnMgSLrRfSXQtDKtoAoGwDx8m6RmxIbde
         QZshyCV125Wg2JYhFW9ODfGF6nmuQ42omMw2eQ22O+07BUZJEh/Rbq05NZfBnoc80uV9
         WHz8i6sdF47lM0Q4OBbymRvbWLR3Ud7Pm2HxhbDJBNIlBmu+McS5wcGL1qqbYQLE7yrH
         FLU2QQxE5YLVDuwmgQXwnYgsswf3k9p8mjgyF92zcFae5EWc3ARyYajD+F8cho2MBNoe
         7n4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0LWcxY/+T8JeRgoouM5EGNbfdZukYzbSTeRQ9t/AkwI=;
        b=SBWELQv4pgqzbA65ZM5Xh8D8S1awO60BoD1FWfpw00BhDSDKSE+12hq/hFB8ALNSCh
         HvvDlyiBvotaVoJoDnS33L6BzAt2DJNdZkjYqK0O+DHS4aLMcdz+j/SbFBq+xcgXb2E+
         X11PGJ4XxSZbYPGIdGINie7uLvknCAYLZ1GpqwIorl4GU5z3+QTaoR+HsWL+eZ1cXIsT
         eARWIi8L3Aqd4gEf3dsaZ/SBUEnIwDJNpZUz4siCHBdqtxSQum8hjs8RbdAapJhVWjSR
         Ew6x6lF9FvAIEiG2OInBTwmVmwWKeU31IWsX8MhsUDroCDVZemFFhjs8Lp+Ctk1kyBkW
         eL7A==
X-Gm-Message-State: AOAM532RG7rks2TXxqliXWc2HQVeaQUOXSkSX0RVG44xKeoj1Qj5237i
        bpl1kMwlBm3RJftGbkETw7lDG1UfOtGiDYA5
X-Google-Smtp-Source: ABdhPJx4i1U6AW/AkEAGJ2pSeIMrN+XGpIFERPH/zWj3x9nUemE6AJeVG7+TRSM+6qyhRAZUnfkojg==
X-Received: by 2002:a17:90b:34e:: with SMTP id fh14mr10311012pjb.100.1627315652928;
        Mon, 26 Jul 2021 09:07:32 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x10sm425464pfd.175.2021.07.26.09.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:07:32 -0700 (PDT)
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Forza <forza@tnonline.net>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ccb2cce6-cb7b-6d94-e7b9-dca724cef930@kernel.dk>
Date:   Mon, 26 Jul 2021 10:07:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/21 1:51 PM, Forza wrote:
> 
> 
> On 2021-07-24 21:44, Jens Axboe wrote:
>> On 7/24/21 12:23 PM, Forza wrote:
>>> Hi!
>>>
>>> On 2021-07-24 19:04, Jens Axboe wrote:
>>>> I'll see if I can reproduce this. I'm assuming samba is using buffered
>>>> IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
>>>> possible to reproduce without samba with a windows client, as I don't
>>>> have any of those. If synthetic reproducing fails, I can try samba
>>>> with a Linux client.
>>>
>>> I attached the logs from both a Windows 10 client and a Linux client
>>> (kernel 5.11.0).
>>>
>>> https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
>>>
>>>     smbd_smb2_read: fnum 2641229669, file
>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>> offset=736100352 read=4194304
>>> [2021/07/24 17:26:09.120779,  3]
>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>     smbd_smb2_read: fnum 2641229669, file
>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>> offset=740294656 read=4194304
>>> [2021/07/24 17:26:09.226593,  3]
>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>     smbd_smb2_read: fnum 2641229669, file
>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>> offset=748683264 read=4194304
>>
>> Thanks, this is useful. Before I try and reproduce it, what is the
>> filesystem that is hosting the samba mount?
>>
> 
> I am using Btrfs.
> 
> My testing was done by exporting the share with
> 
>    vfs objects = io_uring
>    vfs objects = btrfs, io_uring
> 
> Same results in both cases. Exporting with "vfs objects = btrfs" (no 
> io_uring) works as expected.

Seems to be specific to btrfs, I can reproduce it here. I'll dive in
and see what I can find.

-- 
Jens Axboe

