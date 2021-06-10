Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681173A2795
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 11:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFJJCw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 05:02:52 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:40730 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhFJJCv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 05:02:51 -0400
Received: by mail-wm1-f51.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so6022346wmd.5
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 02:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=merpaTZYaWVNk2ypZSwnQuXUDSS1midwIMSD0JYgeyQ=;
        b=OIuS7CepMmhtim/UwX6lMAmTK363wZPS8Z6QhemIU9TpdZQN0RlYDwVa/ky0d6RleD
         2MA/taovybpiWSnmZ5cDZcMOf6/Rc0AFWHpU7syGbtvMK3/9CtBzwIe1swJfg/SV3hdc
         pOmPkJ99C9eQPzadf240o4G8hIoQ41NVMU8YQlEQUcnxda0A+Iolk97iOzWreLXX9+2X
         v9TDDG2YwLiHt7hIO7Cg4vyXVpz7hFAaRltJE4qZTGwZ1bHZd0bKYTZIsUoPaRYvcTRL
         OahruZb9BcnfDlWtZHBuXvNWlxK4ApAhnrgk/E5GpD7hNEtxDvSfaEFcCS45i64i04l6
         gtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=merpaTZYaWVNk2ypZSwnQuXUDSS1midwIMSD0JYgeyQ=;
        b=qO1DIjx6N6nNaFSL8mm1WX9NyquUXjmfFzD8ZTdrzYNSYYMF4us9cLuLACoV0ev4tm
         dHVp6XmECSzajIkgBaZnblo/KYzlhxoYBSeUPyKIlZQKEtjfsjDk/faBs1fB51rzMv2F
         xPFZ0RfxaQ0e35bO7QumafJABdm/mMuD5Q9WEvh9KQgmJ/9ygoGugG6ibNRhzHWs3LpE
         IMCsr0jP/R0KiboGfBarhfx9z1tujQrrT5Zdmd7KFAd7OalsGI0bKzkXq+edBeGs5rsy
         3VWvCw7wPixDph8/BmBIzLXc+N6Kr3DQ5q/y0cGtV8f4sXbKY3n/MSe7SlHUnG5nwqOC
         I2xA==
X-Gm-Message-State: AOAM533Ffj/FMpg+TtoHSG2MP0IGAaeZcje0ahPxTnp9tfG/DZX8XhBX
        1mYcoimiMbDyWSLEc6XVODY=
X-Google-Smtp-Source: ABdhPJy6ikPFHUG2icU6SSp7ZIoR1RE0xezg3Zl/TP9PUBIAvaJJ42RN5UozM/v71yhEQ28AnLF0rw==
X-Received: by 2002:a1c:e915:: with SMTP id q21mr3964180wmc.110.1623315595314;
        Thu, 10 Jun 2021 01:59:55 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id p187sm2279761wmp.28.2021.06.10.01.59.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 01:59:54 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use io_poll_get_double in io_poll_double_wake
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1623314716-55024-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3e3894ee-398d-02ba-c72c-f40ef121a724@gmail.com>
Date:   Thu, 10 Jun 2021 09:59:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1623314716-55024-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/21 9:45 AM, Hao Xu wrote:
> Correct wrong use of io_poll_get_single in io_poll_double_wake, which
> I think is a slip-up.

Not really. It removes both poll entries


> [   55.204528] WARNING: CPU: 0 PID: 2660 at fs/io_uring.c:1512 io_poll_double_wake+0x1d6/0x1f0
> [   55.204546] Modules linked in:
> [   55.204560] CPU: 0 PID: 2660 Comm: a.out Not tainted 5.13.0-rc3+ #1
> [   55.204575] RIP: 0010:io_poll_double_wake+0x1d6/0x1f0
> [   55.204584] Code: ff 48 89 eb e9 8b fe ff ff e8 c6 68 d3 ff 49 c7 44 24 08 00 00 00 00 48 8b 7b 08 e8 e4 7b 9d 00 e9 5d ff ff ff e8 aa 68 d3 ff <0f> 0b e9 76 ff ff ff e8 9e 68 d3 ff 0f 0b e9 59 ff ff ff 0f 1f 80
> [   55.204592] RSP: 0018:ffffc90003c73cc8 EFLAGS: 00010093
> [   55.204599] RAX: 0000000000000000 RBX: ffff88810fcf6500 RCX: 0000000000000000
> [   55.204604] RDX: ffff88810d38b500 RSI: ffffffff814d3dd6 RDI: ffff88810ff5fd60
> [   55.204610] RBP: ffff88810fcf6500 R08: ffff88810d38bf38 R09: 00000000fffffffe
> [   55.204615] R10: 00000000e2886200 R11: 000000005dbbc615 R12: ffff88810d068658
> [   55.204620] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000040000000
> [   55.204625] FS:  00007f84d6170700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
> [   55.204635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   55.204640] CR2: 00007f84d616fef8 CR3: 000000010ffd2006 CR4: 00000000001706f0
> [   55.204646] Call Trace:
> [   55.204656]  __wake_up_common+0x9f/0x1b0
> [   55.204674]  __wake_up_common_lock+0x7a/0xc0
> [   55.204694]  tty_ldisc_lock+0x44/0x80
> [   55.204705]  tty_ldisc_hangup+0xe3/0x240
> [   55.204719]  __tty_hangup+0x26b/0x360
> [   55.204736]  tty_ioctl+0x6be/0xb20
> [   55.204747]  ? do_vfs_ioctl+0x1af/0xaa0
> [   55.204757]  ? __fget_files+0x15a/0x260
> [   55.204774]  ? tty_vhangup+0x20/0x20
> [   55.204787]  __x64_sys_ioctl+0xbb/0x100
> [   55.204801]  do_syscall_64+0x36/0x70
> [   55.204813]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Fixes: d4e7cd36a90e ("io_uring: sanitize double poll handling")
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b2cc1e76d660..2be2db156094 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4950,7 +4950,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
>  			       int sync, void *key)
>  {
>  	struct io_kiocb *req = wait->private;
> -	struct io_poll_iocb *poll = io_poll_get_single(req);
> +	struct io_poll_iocb *poll = io_poll_get_double(req);
>  	__poll_t mask = key_to_poll(key);
>  
>  	/* for instances that support it check for an event match first: */
> 

-- 
Pavel Begunkov
