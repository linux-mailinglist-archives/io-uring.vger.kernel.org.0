Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A332D14FF
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgLGPnH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgLGPnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:43:07 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22013C061749
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:42:27 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id i9so13802866ioo.2
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KGuP04Yh5ZseJNv/4+3M6j57gxslXZrgP+sgHsyOAzo=;
        b=ICznjA1rFsrMyRf9e3LLtRhJfQ0qm9c1oCCwOJhPfwE2Xu9H1e9QG9LzeLCLEdv5Yz
         X54uDybUb/SL3RLSXbXFP2CCgyFBQtS7VYvLXphgjqqPiibzj6sf/SZ9gtrgcxxfSzTH
         c5bR/c/CD0R011J1OAjF7wmifZkQNbl+QPMyOmYs1HpSWBp6sOTV060iX14ZxMX3M5Ov
         5HQ0VOXYbGHsTNFyHnGswcfvgz62MNTpvRv+FPLeOpsC8RFmibZNg6rS0pVp0Z153w+z
         fJKaWbr6oYMhZWROgqRoHbXANhGLwbp9vlBrRiK8IY2zES0C0rv+zBpxBWMq08baqVS8
         9yPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KGuP04Yh5ZseJNv/4+3M6j57gxslXZrgP+sgHsyOAzo=;
        b=skkxYiKbHIEk9SW50QIFJenQSF+Ad2/LT98Y/vd73RvTY6b5Z/J32zLpXGx4rIRYZC
         cws9lddZEoy5S3UGW4kQ1+CtbPk+S8QBZCcSXltm4F3BjHl0mUf/tkyYpzQo+QK0RAH5
         AnU1XebX6MRQ9UpzkdePr84p1xOs67DvhpaxyZ+h6Xfrwv2pq/NyLkKP9QCguM/k9UOx
         +5kVnMKqUnvbarjFlId4aUNxTrrhNShxIG7EqMY85GlHnRU+Q59nqwi6tdyZNdFy9c5S
         O6bRIoJXt2GhIr/4aZor79U0tXJHGkCo/aWH7z6EBAX0yBKMrszE25WBJrvxiDT5HphC
         Nrow==
X-Gm-Message-State: AOAM53120w3wED2rs8T3906cYEPfBRsNeJPItEOA9tbdp/pe7Z2L+yMA
        MzxPuJwba3xMjc3Gel3SXIW75Q==
X-Google-Smtp-Source: ABdhPJxw7qUWgoXa0MWZoyTHrpX/po4qk0rzl9IjAznXpUHq6v3KgIxYzII5z+U7WREDwYXWwNIZzw==
X-Received: by 2002:a05:6602:26d4:: with SMTP id g20mr9323995ioo.152.1607355746498;
        Mon, 07 Dec 2020 07:42:26 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x17sm7497915ilj.67.2020.12.07.07.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:42:25 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix file leak on creating io ctx
From:   Jens Axboe <axboe@kernel.dk>
To:     Hillf Danton <hdanton@sina.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+71c4697e27c99fddcf17@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20201207081558.2361-1-hdanton@sina.com>
 <13bd991a-be45-6521-655d-74b8d810b714@kernel.dk>
Message-ID: <848ad126-c4f7-6dba-24da-d7e29cbcfb67@kernel.dk>
Date:   Mon, 7 Dec 2020 08:42:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <13bd991a-be45-6521-655d-74b8d810b714@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/20 8:04 AM, Jens Axboe wrote:
> On 12/7/20 1:15 AM, Hillf Danton wrote:
>> Put file as part of error handling when setting up io ctx to fix
>> memory leak like the following one.
>>
>>    BUG: memory leak
>>    unreferenced object 0xffff888101ea2200 (size 256):
>>      comm "syz-executor355", pid 8470, jiffies 4294953658 (age 32.400s)
>>      hex dump (first 32 bytes):
>>        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>        20 59 03 01 81 88 ff ff 80 87 a8 10 81 88 ff ff   Y..............
>>      backtrace:
>>        [<000000002e0a7c5f>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
>>        [<000000002e0a7c5f>] __alloc_file+0x1f/0x130 fs/file_table.c:101
>>        [<000000001a55b73a>] alloc_empty_file+0x69/0x120 fs/file_table.c:151
>>        [<00000000fb22349e>] alloc_file+0x33/0x1b0 fs/file_table.c:193
>>        [<000000006e1465bb>] alloc_file_pseudo+0xb2/0x140 fs/file_table.c:233
>>        [<000000007118092a>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
>>        [<000000007118092a>] anon_inode_getfile+0xaa/0x120 fs/anon_inodes.c:74
>>        [<000000002ae99012>] io_uring_get_fd fs/io_uring.c:9198 [inline]
>>        [<000000002ae99012>] io_uring_create fs/io_uring.c:9377 [inline]
>>        [<000000002ae99012>] io_uring_setup+0x1125/0x1630 fs/io_uring.c:9411
>>        [<000000008280baad>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>        [<00000000685d8cf0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Applied for 5.10, thanks.

I take that back, this patch is totally broken. Please test your patches
before sending them out, this cannot have been even put through the most
basic of tests.

-- 
Jens Axboe

