Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C65C3D8ACE
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 11:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhG1JjJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 05:39:09 -0400
Received: from ste-pvt-msa2.bahnhof.se ([213.80.101.71]:11690 "EHLO
        ste-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbhG1JjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 05:39:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 2F2FD3F64D;
        Wed, 28 Jul 2021 11:39:03 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
X-Spam-Flag: NO
X-Spam-Score: -2.99
X-Spam-Level: 
X-Spam-Status: No, score=-2.99 tagged_above=-999 required=6.31
        tests=[BAYES_00=-1.9, NICE_REPLY_A=-1.091, URIBL_BLOCKED=0.001]
        autolearn=ham autolearn_force=no
Received: from ste-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (ste-ftg-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Gmxp4NXcSx4z; Wed, 28 Jul 2021 11:39:02 +0200 (CEST)
Received: by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 208923F623;
        Wed, 28 Jul 2021 11:39:01 +0200 (CEST)
Received: from [192.168.0.10] (port=63846)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1m8g1k-000Auu-OJ; Wed, 28 Jul 2021 11:39:00 +0200
From:   Forza <forza@tnonline.net>
Subject: Re: Stack trace with Samba VFS io_uring and large transfers
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <c6bd5987-e9ae-cd02-49d0-1b3ac1ef65b1@tnonline.net>
 <83566716-691f-ca91-295b-6d8aaafa50d2@kernel.dk>
 <49c893e9-8468-f326-9404-d23ed5a4b89f@tnonline.net>
 <74609547-b920-364b-db3b-ffb8ca7ab173@kernel.dk>
 <4848096b-7fc8-ba06-1238-849372d3851e@tnonline.net>
 <1e437b44-3917-3ea2-3231-f147b6a30ece@samba.org>
Message-ID: <de44675f-472f-76ff-406d-546f02dce844@tnonline.net>
Date:   Wed, 28 Jul 2021 11:39:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1e437b44-3917-3ea2-3231-f147b6a30ece@samba.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2021-07-28 02:16, Stefan Metzmacher wrote:
>> I am using Btrfs.
>>
>> My testing was done by exporting the share with
>>
>>    vfs objects = io_uring
>>    vfs objects = btrfs, io_uring
>>
>> Same results in both cases. Exporting with "vfs objects = btrfs" (no io_uring) works as expected.
> I don't think it makes a difference for the current problem, but I guess you want the following order instead:
> 
> vfs objects = io_uring, btrfs
> 
> metze

I haven't tested that combination. However the docs mention that 
io_uring must be last VFS object loaded.

https://www.samba.org/samba/docs/4.12/man-html/vfs_io_uring.8.html

"The io_uring VFS module enables asynchronous pread, pwrite and fsync 
using the io_uring infrastructure of Linux (>= 5.1). This provides much 
less overhead compared to the usage of the pthreadpool for async io.

This module SHOULD be listed last in any module stack as it requires 
real kernel file descriptors."

The manpage for vfs_btrfs mentions that btrfs is stackable and in their 
example they have btrfs loaded before vfs_shadow_copy.

https://www.samba.org/samba/docs/4.12/man-html/vfs_btrfs.8.html

What would be the implication of having io_uring before the btrfs module?

Regards
Forza
