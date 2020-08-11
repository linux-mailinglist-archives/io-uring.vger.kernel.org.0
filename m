Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE58241D91
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgHKPtc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 11:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgHKPtb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 11:49:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86512C06174A
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 08:49:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j21so6898119pgi.9
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 08:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1RoNYDYvCgpLLRWCuumNMoAb1U/U13+su+iqhg08vrA=;
        b=G+ZaOUTABRY2uaa7exuF9V693p1+/Aq92mMnUXDM0xSjDLxYZHnk2loQum0lmZklvu
         gavDX8FnkFLF3m0LF13jEKwqunJXhebTR9C+PVK0+27BF2MdYni5G5s0QMPclcDbw33y
         pivUFiiYDDl+K8jkY08D8WSKQhccYO0eANN2qrLBsppanGGSLmyM0rg1KFCIuXeRtd5W
         ja2xxU/wZU1/K/GUKfE56yofuh/+8iY4+fq3391Id0hYaYmIJORKt4333Q+mZLEJVtyO
         uKh1JW/lNXMQvUmN3hcPiqbKSCdjLrPHI20sUx5TlnAAiAxsU/etOwfVJHX+qNmBBM9i
         LC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1RoNYDYvCgpLLRWCuumNMoAb1U/U13+su+iqhg08vrA=;
        b=pA70XwSWonbUGJy/tgO3aQjWPBfQmcqfvSGHwVARbLQ16qfEPwMTM2blmFz+5M3l9c
         r80UyuOvV8ZwWy7J+Zlf5o09rN1lXXtB2W/UybBd7xZDk6lhqIZ+MsbVgoHoUbZZpO60
         mkEZLtpUdMwkzSQX3vywV6UpMFEoofxwI6ki5L9gxcDZbnMTCP92yhOquT8OR0BgnmmZ
         MB3bYx4RySUyEP9cMDv2qMiPV3t++NDXNeqwZ1WsyfmVF5ZkHHs7881nzWIZpstd3+IR
         /SRoj8Dzy3cwgrH0tiuK3AKJZbLxJ/FM0MvDUWcviKZ3iMJzRZOeTq55K2/NVTdbBYQO
         ByKA==
X-Gm-Message-State: AOAM531vnuWgzdGPsOjMspOACsJo1Gt1eRrdYBVxETAaZGgXNwclPxIo
        8qH6jRODnFAhM6gFesHwqEwiBQ==
X-Google-Smtp-Source: ABdhPJyImT5VS2jSW7cIWKnDAuCFRuBhWkOy7HCCCtavJT7faPpml2SIfF69oV5pKG86DD3ZalrbtQ==
X-Received: by 2002:a65:4103:: with SMTP id w3mr1362290pgp.426.1597160970982;
        Tue, 11 Aug 2020 08:49:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id bf8sm3311237pjb.4.2020.08.11.08.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2020 08:49:30 -0700 (PDT)
Subject: Re: memory leak in io_submit_sqes
From:   Jens Axboe <axboe@kernel.dk>
To:     syzbot <syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000f50fb505ac9a72c9@google.com>
 <b8c5db23-c3cf-7daf-6a0a-8a5f713e9803@kernel.dk>
 <f0386716-eba3-392c-b6b6-35109a1b009b@kernel.dk>
Message-ID: <f6595321-fc08-6c5a-c39c-dc3a2fbb83ed@kernel.dk>
Date:   Tue, 11 Aug 2020 09:49:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f0386716-eba3-392c-b6b6-35109a1b009b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/20 9:23 AM, Jens Axboe wrote:
> On 8/11/20 8:59 AM, Jens Axboe wrote:
>> On 8/11/20 7:57 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    d6efb3ac Merge tag 'tty-5.9-rc1' of git://git.kernel.org/p..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13cb0762900000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=42163327839348a9
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=a730016dc0bdce4f6ff5
>>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16e877dc900000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1608291a900000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+a730016dc0bdce4f6ff5@syzkaller.appspotmail.com
>>>
>>> executing program
>>> executing program
>>> executing program
>>> executing program
>>> executing program
>>> BUG: memory leak
>>> unreferenced object 0xffff888124949100 (size 256):
>>>   comm "syz-executor808", pid 6480, jiffies 4294949911 (age 33.960s)
>>>   hex dump (first 32 bytes):
>>>     00 78 74 2a 81 88 ff ff 00 00 00 00 00 00 00 00  .xt*............
>>>     90 b0 51 81 ff ff ff ff 00 00 00 00 00 00 00 00  ..Q.............
>>>   backtrace:
>>>     [<0000000084e46f34>] io_alloc_req fs/io_uring.c:1503 [inline]
>>>     [<0000000084e46f34>] io_submit_sqes+0x5dc/0xc00 fs/io_uring.c:6306
>>>     [<000000006d4e19eb>] __do_sys_io_uring_enter+0x582/0x830 fs/io_uring.c:8036
>>>     [<00000000a4116b07>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>>     [<0000000067b2aefc>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> BUG: memory leak
>>> unreferenced object 0xffff88811751d200 (size 96):
>>>   comm "syz-executor808", pid 6480, jiffies 4294949911 (age 33.960s)
>>>   hex dump (first 32 bytes):
>>>     00 78 74 2a 81 88 ff ff 00 00 00 00 00 00 00 00  .xt*............
>>>     0e 01 00 00 00 00 75 22 00 00 00 00 00 0f 1f 04  ......u"........
>>>   backtrace:
>>>     [<00000000073ea2ba>] kmalloc include/linux/slab.h:555 [inline]
>>>     [<00000000073ea2ba>] io_arm_poll_handler fs/io_uring.c:4773 [inline]
>>>     [<00000000073ea2ba>] __io_queue_sqe+0x445/0x6b0 fs/io_uring.c:5988
>>>     [<000000001551bde0>] io_queue_sqe+0x309/0x550 fs/io_uring.c:6060
>>>     [<000000002dfb908f>] io_submit_sqe fs/io_uring.c:6130 [inline]
>>>     [<000000002dfb908f>] io_submit_sqes+0x8b8/0xc00 fs/io_uring.c:6327
>>>     [<000000006d4e19eb>] __do_sys_io_uring_enter+0x582/0x830 fs/io_uring.c:8036
>>>     [<00000000a4116b07>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>>     [<0000000067b2aefc>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> This one looks very odd, and I cannot reproduce it. The socket() calls
>> reliably fails for me, and even if I hack it to use 0 for protocol instead
>> of 2, I don't see anything interesting happening here. An IORING_OP_WRITEV
>> is submitted on the socket, which just fails with ENOTCONN.
> 
> Dug a bit deeper and found the missing option, I can now reproduce this!
> I'll take a look.

This should fix it.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 99582cf5106b..8a2afd8c33c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4883,7 +4883,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
-	if (ret) {
+	if (ret || ipt.error) {
 		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(apoll->double_poll);

-- 
Jens Axboe

