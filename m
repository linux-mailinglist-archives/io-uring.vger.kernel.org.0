Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBCB36FA0C
	for <lists+io-uring@lfdr.de>; Fri, 30 Apr 2021 14:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhD3MVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Apr 2021 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhD3MUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Apr 2021 08:20:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9ADC061361;
        Fri, 30 Apr 2021 05:19:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z6so9066449wrm.4;
        Fri, 30 Apr 2021 05:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hFHDClOPR5JDkvoBqZr7ZlMk8+r3t4UekKeu+8XR9cE=;
        b=elwKV3eJ92aK6GglBreD3R6f0Qzm2olbhR3lV4n5BKc20t2nsSsa+UdfVKQbCivPa3
         MDT5yUpQjksTJkk8FymYUv1MLAY7CyIVEYXjm8Y7ysaNW0i5AFmIhKB2Tb5l7a/fTgiH
         L8cWOGtckry5TNQYShyek3gbvRwM9T4vj8PmWUeD7rRsF5gHHXjvzRH7QWO1CIY8kKm8
         9hz3ctgEuc1/WzJZo+gnOIHRKhODwQp87t1yk8Xpewh9oKClaOIj9EDmxh5EqHlAqkNg
         oGl53mUqa02wnTHVszKTUbf18x8PUUZxN9aaRz1BfIuVSvgEGcFEWOfeSF/wkLn0r185
         CR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hFHDClOPR5JDkvoBqZr7ZlMk8+r3t4UekKeu+8XR9cE=;
        b=SdSB38a+BKQhEEJ2Pr5YyE4UImxsxqvymgzzqVD/juBS4IJiPLaedWyu2ZLf2+1FNP
         OqNZUyU7CwUGhXS7uTMZvzUy/nTu8bvCoFWRYxauE6K5H/Mj61otGW1TXjec7Qqj/l5L
         T55vp1Y0EUVU4Z9D9qa/RYrf1fZJgBxg6dh5wRoShkaGWKbhRZKlKTMRBI/3iVQ1AUxg
         VFXig1IjSp55p9GTS7qGszY6q378tbqaMcGzuekhaXaOqU3Z/8Is4bOW3Nj7SMwZKgih
         gqgh+wZbJC9ffcILh0V5AcYs403ebjEcQHh3R1guYrCuYUzB5k/q6VKbh8R+Hfel2U4k
         kEBA==
X-Gm-Message-State: AOAM532bEFRghTlk5u8B0TxhVwGrtE3IJtRrBkquIpHfNCEZ0cZILJ8D
        CCxv9B71rX1oB1Ced5FDMOU=
X-Google-Smtp-Source: ABdhPJxh6Q+YNAQw+ZuGYfAyKbPk09fnpk/LaGln4yL8jtXLK4LJnbQqyluIY+3BJqn86mqJvZhSuw==
X-Received: by 2002:adf:e845:: with SMTP id d5mr6351971wrn.96.1619785176391;
        Fri, 30 Apr 2021 05:19:36 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id q19sm13443237wmc.44.2021.04.30.05.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 05:19:35 -0700 (PDT)
Subject: Re: [syzbot] memory leak in io_sqe_buffers_register
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+0f32d05d8b6cd8d7ea3e@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000758d3005c12b18d2@google.com>
 <20210430075138.2256-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a443802d-ed33-61d8-2fac-f525d59ee531@gmail.com>
Date:   Fri, 30 Apr 2021 13:19:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210430075138.2256-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 8:51 AM, Hillf Danton wrote:
> On Thu, 29 Apr 2021 23:55:21 -0700
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    d2b6f8a1 Merge tag 'xfs-5.13-merge-3' of git://git.kernel...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=173639a3d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=337dc545ba10a406
>> dashboard link: https://syzkaller.appspot.com/bug?extid=0f32d05d8b6cd8d7ea3e
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14df6ba3d00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12815385d00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+0f32d05d8b6cd8d7ea3e@syzkaller.appspotmail.com
>>
>> Debian GNU/Linux 9 syzkaller ttyS0
>> Warning: Permanently added '10.128.1.62' (ECDSA) to the list of known hosts.
>> executing program
>> executing program
>> executing program
>> BUG: memory leak
>> unreferenced object 0xffff8881123bf0a0 (size 32):
>>   comm "syz-executor557", pid 8384, jiffies 4294946143 (age 12.360s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffff81469b71>] kmalloc_node include/linux/slab.h:579 [inline]
>>     [<ffffffff81469b71>] kvmalloc_node+0x61/0xf0 mm/util.c:587
>>     [<ffffffff815f0b3f>] kvmalloc include/linux/mm.h:795 [inline]
>>     [<ffffffff815f0b3f>] kvmalloc_array include/linux/mm.h:813 [inline]
>>     [<ffffffff815f0b3f>] kvcalloc include/linux/mm.h:818 [inline]
>>     [<ffffffff815f0b3f>] io_rsrc_data_alloc+0x4f/0xc0 fs/io_uring.c:7164
>>     [<ffffffff815f26d8>] io_sqe_buffers_register+0x98/0x3d0 fs/io_uring.c:8383
>>     [<ffffffff815f84a7>] __io_uring_register+0xf67/0x18c0 fs/io_uring.c:9986
>>     [<ffffffff81609222>] __do_sys_io_uring_register fs/io_uring.c:10091 [inline]
>>     [<ffffffff81609222>] __se_sys_io_uring_register fs/io_uring.c:10071 [inline]
>>     [<ffffffff81609222>] __x64_sys_io_uring_register+0x112/0x230 fs/io_uring.c:10071
>>     [<ffffffff842f616a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>>     [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Free rsrc data with the routine available.

right, only the other sent patch by Zqiang is more complete

> 
> +++ x/fs/io_uring.c
> @@ -8385,7 +8385,7 @@ static int io_sqe_buffers_register(struc
>  		return -ENOMEM;
>  	ret = io_buffers_map_alloc(ctx, nr_args);
>  	if (ret) {
> -		kfree(data);
> +		io_rsrc_data_free(data);
>  		return ret;
>  	}
>  
> 

-- 
Pavel Begunkov
