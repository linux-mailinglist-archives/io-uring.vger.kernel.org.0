Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3853D49B0
	for <lists+io-uring@lfdr.de>; Sat, 24 Jul 2021 21:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhGXTKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Jul 2021 15:10:46 -0400
Received: from pio-pvt-msa3.bahnhof.se ([79.136.2.42]:60742 "EHLO
        pio-pvt-msa3.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhGXTKp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Jul 2021 15:10:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTP id 744A13F634;
        Sat, 24 Jul 2021 21:51:15 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -1.9
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, NICE_REPLY_A=-0.001, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from pio-pvt-msa3.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa3.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yY0HkOj5w3jq; Sat, 24 Jul 2021 21:51:14 +0200 (CEST)
Received: by pio-pvt-msa3.bahnhof.se (Postfix) with ESMTPA id 119DE3F330;
        Sat, 24 Jul 2021 21:51:13 +0200 (CEST)
Received: from [192.168.0.10] (port=58112)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1m7Ng1-000Cyc-72; Sat, 24 Jul 2021 21:51:13 +0200
From:   Forza <forza@tnonline.net>
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
Message-ID: <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
Date:   Sat, 24 Jul 2021 21:51:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2021-07-24 21:44, Jens Axboe wrote:
> On 7/24/21 12:23 PM, Forza wrote:
>> Hi!
>>
>> On 2021-07-24 19:04, Jens Axboe wrote:
>>> I'll see if I can reproduce this. I'm assuming samba is using buffered
>>> IO, and it looks like it's reading in chunks of 1MB. Hopefully it's
>>> possible to reproduce without samba with a windows client, as I don't
>>> have any of those. If synthetic reproducing fails, I can try samba
>>> with a Linux client.
>>
>> I attached the logs from both a Windows 10 client and a Linux client
>> (kernel 5.11.0).
>>
>> https://paste.tnonline.net/files/r4yebSzlGEVD_linux-client.txt
>>
>>     smbd_smb2_read: fnum 2641229669, file
>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>> offset=736100352 read=4194304
>> [2021/07/24 17:26:09.120779,  3]
>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>     smbd_smb2_read: fnum 2641229669, file
>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>> offset=740294656 read=4194304
>> [2021/07/24 17:26:09.226593,  3]
>> ../../source3/smbd/smb2_read.c:415(smb2_read_complete)
>>     smbd_smb2_read: fnum 2641229669, file
>> media/vm/libvirt/images/Mint_Cinnamon.img, length=4194304
>> offset=748683264 read=4194304
> 
> Thanks, this is useful. Before I try and reproduce it, what is the
> filesystem that is hosting the samba mount?
> 

I am using Btrfs.

My testing was done by exporting the share with

   vfs objects = io_uring
   vfs objects = btrfs, io_uring

Same results in both cases. Exporting with "vfs objects = btrfs" (no 
io_uring) works as expected.

Thanks.


