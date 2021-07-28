Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA913D85EE
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 04:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234632AbhG1CeF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 22:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhG1CeE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 22:34:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4B8C061757
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 19:34:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mt6so2959492pjb.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 19:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YNjtNCp33wE+RJfI6xPWVXu/vy84VXiqu6ffxAZx51Q=;
        b=Oew9WYkcSeb1a8f2bmDeb1qZVnkOgqwytE6UxwzD778KIhYDU3+xYk0sbKyQyvGmMf
         sEjy8KgnLdEcs8/Yd8uKKZr86HlgVHT+GUDfPkT6MBsoVskIC98xi+HaLm8uP5fFKoLu
         af46ArJeM6Zx5/Y5HTguLt90BYr7iUB/JWWmWK+vZ7gvEWzyDx7bSGuTOWeKn7CD0Wef
         PmuwrVcCzTTggStuTqXA2XkYxg26ynkmZ5/cXpLSkJ/wyrDXhJM9FF+xZersbbI6FTV5
         SSs2UzcezV2YPXoIUqm5eCK4t/7GVdRl8pbvH7o0yw1O7r2Z9Mr/8Dju5cIWZTTUaH61
         uL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YNjtNCp33wE+RJfI6xPWVXu/vy84VXiqu6ffxAZx51Q=;
        b=Q1OxT6gpOrkKBsijy8KdoFjiuy4FPmuBOR1d8gKwdtc8SYZFa+QCuYP0WObrwTaZan
         Qk0s8LYlT8C9MdddldU70CXkLBziS3eLz7INW0gKePElxIoCiqqoU3qTB7eQACA/2iJX
         q1a+X84SV5LvnrhYoNl8Hoy+IrOgBKKEQEl6/eD3a3lDgFqBvl8dNxYhWKFkgATo7Koo
         QsQUstT58A4mHsEwX6c+hfe6OJZwRd3l/1HG4mXgGKPf+F9RiGKw1HUIQ3vV0R4bvwoe
         M3P9BV396BlJbdYmzsWZ4gHxa1Pgi6LKRhSRxwuQpVX9IoyHJXVNG2UVzyJpiMrNiVKh
         q7KQ==
X-Gm-Message-State: AOAM532gSYS3CHE5V8DJuUUVhOF5vDdwif//Uv1T5zqrcCPCBDqlUxA6
        S/cy9D9KkzbaEj5Po82qP6goX+Yu/O/n++ZQ
X-Google-Smtp-Source: ABdhPJyiKbWzgOKJ4OGTkEywUoTAT3jYSN8o/Rueps3yRwJOyRgJDRBE7iVEzaWu2+vOfeYSOgGrfQ==
X-Received: by 2002:a05:6a00:114f:b029:340:aa57:f69 with SMTP id b15-20020a056a00114fb0290340aa570f69mr26445742pfm.28.1627439643315;
        Tue, 27 Jul 2021 19:34:03 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id v5sm5765950pgi.74.2021.07.27.19.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 19:34:02 -0700 (PDT)
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Stefan Metzmacher <metze@samba.org>, Forza <forza@tnonline.net>,
        io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
 <1e437b44-3917-3ea2-3231-f147b6a30ece@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e337dc5f-b473-d630-f724-a1e251d865ff@kernel.dk>
Date:   Tue, 27 Jul 2021 20:34:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1e437b44-3917-3ea2-3231-f147b6a30ece@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/21 6:16 PM, Stefan Metzmacher wrote:
> 
> Am 24.07.21 um 21:51 schrieb Forza:
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
>>>>     smbd_smb2_read: fnum 2641229669, file
>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>> offset=736100352 read=4194304
>>>> [2021/07/24 17:26:09.120779,  3]
>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>     smbd_smb2_read: fnum 2641229669, file
>>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>>> offset=740294656 read=4194304
>>>> [2021/07/24 17:26:09.226593,  3]
>>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>>     smbd_smb2_read: fnum 2641229669, file
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
>>   vfs objects = io_uring
>>   vfs objects = btrfs, io_uring
>>
>> Same results in both cases. Exporting with "vfs objects = btrfs" (no io_uring) works as expected.
> 
> I don't think it makes a difference for the current problem, but I guess you want the following order instead:
> 
> vfs objects = io_uring, btrfs

Hopefully the fix I posted takes care of the other part :-)

-- 
Jens Axboe

