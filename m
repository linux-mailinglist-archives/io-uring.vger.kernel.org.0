Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21052327374
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 18:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhB1RBa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 12:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhB1RB2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 12:01:28 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0F5C061756
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 09:00:47 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id b8so5596603plh.0
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 09:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Denx7bVQXCP6YfuPAwEe4t9EGKBMnQn7SlWiMFUGxOs=;
        b=Xo3sZSgrW1NhJE5dl2OJTlvB3AtZNMI877HR8upcSV6t+MAklNn6CShP8XRRRaz8ZC
         IkzJBdDDz+o1ZXx7Ec4o7naroVrI9k3VtuiTXQu4LOgncoenaPRImTQ2o/VU3vKjkC4c
         nTVsY68Qh/DXSKsSukyqXjg6k8WZxI/nm3NS5lBTtqgjln+3Q0LdP7bi9v0BbdOu2n1O
         s4EzkPZZp9NQOxEwfHP0ua8EBwWSYNM5j8UWzHv4zA2VOZE3wYQjGtnK1Fe4b2vLSRFa
         Q2ZRa0gU1dDQUCxozDx1Eg+Jj/5N1CquCcq+hlIRkv/ycAPxj9vfsmB13y/167f/mbvi
         ZLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Denx7bVQXCP6YfuPAwEe4t9EGKBMnQn7SlWiMFUGxOs=;
        b=otfShE9BcE9bPW0rKoZ8F2PmMOlOGTMncDX18ldRztedPkNyluDTi98XyV2T7aAznq
         G3j/1HmJJszqcrRZtixYY3KOgXOHwcrqR5EPcCaOsE96JXkb6EGHDxbThXhqUsH6z+Rj
         Df78DJ9+uXIB+sWcBeKNz3GUZF8yIJiDCE+kY1oe6tg/JBWKVmfKU06TITWKWZ5LKTpj
         xfNrSkzjIL4nWmQ9MPCMJpJHwhJD/N0/UYlZepsdFX58wmdrlIm1daaPlZixN3jHC7o+
         N5KjkPmtD0jWgKZVVO4CFcMlT4NpEwOkBpmRW73HMLpNmUaVgo5Y3lxGidyKCm3p0PNw
         fRRw==
X-Gm-Message-State: AOAM530VxWPmLZmfPf0HasHdI/ahAGUt4msoKvUk8EOOprt47ONNToky
        pE9dJFdWVBCsPIo/bz6tDUCk5aRvhsoouA==
X-Google-Smtp-Source: ABdhPJz7944pxBYukv3GgmwZQSOZf1DRsn8Jj/uqXefzM5Ua3K+ux0lbrREcPLZAJB4dvRSniXuhNA==
X-Received: by 2002:a17:902:d886:b029:e1:7784:4db5 with SMTP id b6-20020a170902d886b02900e177844db5mr12090286plz.72.1614531647260;
        Sun, 28 Feb 2021 09:00:47 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o11sm15110420pjg.41.2021.02.28.09.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 09:00:46 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in tctx_task_work
To:     syzbot <syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000fd274b05bc628d6a@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f6566e78-f7c8-d30b-29ad-d60775906017@kernel.dk>
Date:   Sun, 28 Feb 2021 10:00:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000fd274b05bc628d6a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/21 2:59 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    29c395c7 Merge tag 'x86-entry-2021-02-24' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11cd05cad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c581c545cb4ffac7
> dashboard link: https://syzkaller.appspot.com/bug?extid=a157ac7c03a56397f553
> compiler:       Debian clang version 11.0.1-2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __tctx_task_work fs/io_uring.c:2217 [inline]
> BUG: KASAN: use-after-free in tctx_task_work+0x238/0x280 fs/io_uring.c:2230
> Read of size 4 at addr ffff88802178e3f0 by task syz-executor.2/12656

This should fix it.


commit adc34362605c08e622c0750ae3377ed03637abd1
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Feb 28 09:59:26 2021 -0700

    io_uring: don't attempt to re-flush completions
    
    If 'node' is NULL, there are no more completions to flush after doing
    this round. And since the req flushing will put ctx references, it's
    quite possible that the ctx is gone after the flush. Don't dereference
    it unless we know we have more to flush.
    
    Fixes: 65453d1efbd2 ("io_uring: enable req cache for task_work items")
    Reported-by: syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87e8e40b566e..9db79d4b0827 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1829,7 +1829,7 @@ static bool __tctx_task_work(struct io_uring_task *tctx)
 			mutex_lock(&ctx->uring_lock);
 			io_submit_flush_completions(&ctx->submit_state.comp, ctx);
 			mutex_unlock(&ctx->uring_lock);
-			ctx = this_ctx;
+			ctx = node ? this_ctx : NULL;
 		}
 	}
 

-- 
Jens Axboe

