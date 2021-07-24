Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F402A3D49A6
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 21:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGXTEI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 15:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbhGXTEF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Jul 2021 15:04:05 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BBCC061575
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 12:44:37 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id n10so7133817plf.4
        for <io-uring@vger.kernel.org>; Sat, 24 Jul 2021 12:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Oc1fbiKRJ4kefBJPMscGcMNFCRMMjmHyQv+Ku9wzreo=;
        b=vnjRnGP2ubQkO/2PSOAWdtOVPASi2mUe/BMnTFLXRiLXGkjX95clCLbZpXzrN5y1D9
         X1q847YaCZuZ/7+8SgKgmm5N8LNpEcbHXRAt+ZUklmDYhCEg+3+ZkU6m3+jEOgVJsUzL
         TjbiN5qur5j7RDMOZe9v7CP44d+FLK5gtLmEIe1A9N57jE/PcFc6Z0C8gmnd0FibijJy
         2rUV5BesvZO/lSNZCyvLMXbB2+cZxDf1KxqoY8TZJt5xPNfAbOT7JaHmebsnimzVV/gk
         ZrF8CyYiCTRW3inNcb2YxlZ/rInyWs8QmdEVRXJQz66npnTcp7urdo9q/KxDn/P08Icg
         6mBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oc1fbiKRJ4kefBJPMscGcMNFCRMMjmHyQv+Ku9wzreo=;
        b=UPUBlDm+hNHnNnJMAeYkfhKdAp5LrUJN4nGcmDAWLjN5wT4HqdxSz6IItGBSM6eQjo
         9eqDtq5KiXIxlcDp4t+nENOmWhArY4rpBNwwahEsz6w1EHhJ3QCh2X+YdvxMfk5FXbvE
         6TrSJFJm4DOKpzHziyQB1zq1lOjrA5MMWswQs4NVQjV7uTUILdui2l1HPbLcnmbdHgAq
         J9OjxlkpfY2EA/KfOxojmU2hM8VEdta1nLSV7cSeJNzP8yVAOLR3htRvrGxhTZh1jWlj
         JTBOHIBcZSUJm+CQW4LIxj3EwcaBHp4zjC2qP52GSeiEo0Sov9uLFuydoK+wNQdWRC2V
         purQ==
X-Gm-Message-State: AOAM530d3jHNwQrFNo+0l4UAT+EQ9X7f+KKb02wsKbJszVsXDjS9uZ3J
        9liP/JTAxrRkEoo2tXvQAt/CB8JaAoYN3aOB
X-Google-Smtp-Source: ABdhPJzTmOJSxga7D90RFM4QKtW++9wQ34ecZWTD4jcllTjFpAf/mNyyU5oLfe7pb7zDhQlYApdb+w==
X-Received: by 2002:a05:6a00:10cd:b029:30a:ea3a:4acf with SMTP id d13-20020a056a0010cdb029030aea3a4acfmr10789450pfu.51.1627155876844;
        Sat, 24 Jul 2021 12:44:36 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id i14sm23686897pgh.79.2021.07.24.12.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jul 2021 12:44:36 -0700 (PDT)
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Forza <forza@tnonline.net>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
Date:   Sat, 24 Jul 2021 13:44:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/21 12:23 PM, Forza wrote:
> Hi!
> 
> On 2021-07-24 19:04, Jens Axboe wrote:
>> I'll see if I can reproduce this. I'm assuming samba is using buffered
>> IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
>> possible to reproduce without samba with a windows client, as I don't
>> have any of those. If synthetic reproducing fails, I can try samba
>> with a Linux client.
> 
> I attached the logs from both a Windows 10 client and a Linux client 
> (kernel 5.11.0).
> 
> https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
> 
>    smbd_smb2_read: fnum 2641229669, file 
> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304 
> offset=736100352 read=4194304
> [2021/07/24 17:26:09.120779,  3] 
> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>    smbd_smb2_read: fnum 2641229669, file 
> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304 
> offset=740294656 read=4194304
> [2021/07/24 17:26:09.226593,  3] 
> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>    smbd_smb2_read: fnum 2641229669, file 
> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304 
> offset=748683264 read=4194304

Thanks, this is useful. Before I try and reproduce it, what is the
filesystem that is hosting the samba mount?

-- 
Jens Axboe

