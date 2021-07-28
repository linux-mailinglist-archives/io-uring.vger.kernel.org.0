Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD13D848B
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 02:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhG1AQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 20:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhG1AQF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 20:16:05 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F2AC061757
        for <io-uring@vger.kernel.org>; Tue, 27 Jul 2021 17:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=o2dwWwMSOVMkJ37aCniKjCSOjlXeBYB1ZOO7cbyDSK8=; b=naw1Pqz8BUXZuYy6n2ct8i2vo4
        qoFOJWbbOjagKMSof+rqP75mgZuiRDQ0HpmggbSTd1gwlY4FsKv+7meYyqsBVFvZYAP0jDatR7H+A
        y9a7InUYsLAmfvIX3XvNlD2oww5AjgBNDwRqanCF6uVPokWvbHtcv4iuDOdn25WmAkKNrHa9ReQgc
        BpcCupFZeCJ7i+JKEb3Y1c0JnwguM4rZlOv1HBnNt+Ul0Rrcp63Za6ZFst6lm6d744Y5an3wj/3Sv
        I0R8j6tDIk2YCCYulT7VRQqYBENzEOCNrKczB6Oj9nbqBo325rM1URPupBAJ5FZvh/qh70buI+G8k
        Ml08cEUhpMARDf4sjwIjTHQiw6CXoynqiTBlt7c1d6Z+w/Jr3lgHXoILSmIZSNKZr5opp6r1eTJXV
        +NyGgjirAfwDjMngs1dmGDYSCGtwq9bhWI1O93iE/leQezshUGFNKOYv0GwNwJMK7pGrRYoS9Srm3
        j/bU7mqXrOiv1CUrrufZJeqZ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m8XEv-00060Q-9V; Wed, 28 Jul 2021 00:16:01 +0000
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Forza <forza@tnonline.net>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <1e437b44-3917-3ea2-3231-f147b6a30ece@samba.org>
Date:   Wed, 28 Jul 2021 02:16:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 24.07.21 um 21:51 schrieb Forza:
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
>>>     smbd_smb2_read: fnum 2641229669, file
>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>> offset=736100352 read=4194304
>>> [2021/07/24 17:26:09.120779,  3]
>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>     smbd_smb2_read: fnum 2641229669, file
>>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>>> offset=740294656 read=4194304
>>> [2021/07/24 17:26:09.226593,  3]
>>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>>     smbd_smb2_read: fnum 2641229669, file
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
>   vfs objects = io_uring
>   vfs objects = btrfs, io_uring
> 
> Same results in both cases. Exporting with "vfs objects = btrfs" (no io_uring) works as expected.

I don't think it makes a difference for the current problem, but I guess you want the following order instead:

vfs objects = io_uring, btrfs

metze
