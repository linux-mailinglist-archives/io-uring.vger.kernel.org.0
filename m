Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F45F28879E
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 13:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731727AbgJILNe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 07:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgJILNe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 07:13:34 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF60C0613D2;
        Fri,  9 Oct 2020 04:13:33 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 13so9451464wmf.0;
        Fri, 09 Oct 2020 04:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:cc:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xQGmikQ6qE8XE7CIqs+7KCZpNNncfn6RoV4oeJtNd1E=;
        b=tHuzqDahggSxCagXgsRx7GQ9PIos54VEPcXFVyperxa8+8cQfK2hxVkIZiyT/2aNjl
         GJU8xtjGUzwYdV4QW8iyMz3kidj97b+SzNJf9jcz5ZJGpwFvrtojMVbC5+azfo1L1shf
         VBPwnTB5U7J/0QNVEDh4jVk3AG1SuYAkieRb/G4XJyJGC8ZMqzNZq3ozTgEg3xiC3me3
         MWPbO20gFBY0N9bL5HHFa/0Kh1FeVg5eT5kMTRh3FNAO9jQGsx3Mq30PEyNCMadgvG4f
         jPySw8VAw8hsnvC5MnDzrcZTkimvWi/B+E76FqTn0gYM4ZIX7sDFwwdruvw0f13NUNzE
         2Nrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:cc:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xQGmikQ6qE8XE7CIqs+7KCZpNNncfn6RoV4oeJtNd1E=;
        b=Vi8CyTMNXjJVu55Ne49oHdwMKU1ixMX8lUEt0bazoP9Br5O+DDZNCmP3lcpt1dtnlh
         OMsZXAWjgL5RbMOA9yBo/JSSZljDf6bUnRCj7YW8VviNcIC+gOtoJ1wTGaqGVwIA/GA/
         /OL20t4tlI9oiNT14UwhC0bwlaxwibxmE+UHnVftbvN95l2GsoPmcSWt/5TLnLOW19nz
         vP3reYPZwTXQzqbGWKbmngpwceUyxGDSYfyb3C/8G9hfHJ/s+rgXhuo/cDVKxYEHZ0qj
         pHcIU2EVCZheUjwTGYekkeZS4yNKdnQHRFg9JpBJ61rn8QZIotJU1UgV+f2/CaVabQqs
         jJIQ==
X-Gm-Message-State: AOAM530FRjUHNFriTcO8cvtIoEiWfbAOItHJ1gOXa7ahFtZwih3CJiI6
        V7qrHPrj6SRsTFaPIpR8nO4=
X-Google-Smtp-Source: ABdhPJzJDh/o2qCZD+v9/3/UHjs6FXi2S5xnbOHJ0uYyV9bHi0n3nNvSfAs6vygzGCdLIo3vX6GPgw==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr13489092wmj.101.1602242012463;
        Fri, 09 Oct 2020 04:13:32 -0700 (PDT)
Received: from [192.168.1.73] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id d9sm10724326wmb.30.2020.10.09.04.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 04:13:31 -0700 (PDT)
To:     syzbot <syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Matthew Wilcox <willy@infradead.org>
References: <0000000000001a684d05b1385e71@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Cc:     viro@zeniv.linux.org.uk
Subject: Re: KASAN: use-after-free Read in __io_uring_files_cancel
Message-ID: <3a98a77a-a507-954a-f2ec-e38af18c168f@gmail.com>
Date:   Fri, 9 Oct 2020 14:10:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0000000000001a684d05b1385e71@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/10/2020 11:02, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1592ee1b900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
> dashboard link: https://syzkaller.appspot.com/bug?extid=77efce558b2b9e6b6405
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in xas_next_entry include/linux/xarray.h:1630 [inline]
> BUG: KASAN: use-after-free in __io_uring_files_cancel+0x417/0x440 fs/io_uring.c:8681
> Read of size 1 at addr ffff888033631880 by task syz-executor.1/8477
> 
> CPU: 1 PID: 8477 Comm: syz-executor.1 Not tainted 5.9.0-rc8-next-20201008-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fb lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  xas_next_entry include/linux/xarray.h:1630 [inline]
>  __io_uring_files_cancel+0x417/0x440 fs/io_uring.c:8681
>  io_uring_files_cancel include/linux/io_uring.h:35 [inline]
>  exit_files+0xe4/0x170 fs/file.c:456
>  do_exit+0xae9/0x2930 kernel/exit.c:801
>  do_group_exit+0x125/0x310 kernel/exit.c:903
>  get_signal+0x428/0x1f00 kernel/signal.c:2757
>  arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
>  exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
>  exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
>  syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9

It seems this fails on "node->shift" in xas_next_entry(), that would
mean that the node itself was freed while we're iterating on it.

__io_uring_files_cancel() iterates with xas_next_entry() and creates
XA_STATE once by hand, but it also removes entries in the loop with
io_uring_del_task_file() -> xas_store(&xas, NULL); without updating
the iterating XA_STATE. Could it be the problem? See a diff below

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 824ed4e01562..356313c7aec2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8617,10 +8617,9 @@ static int io_uring_add_task_file(struct file *file)
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_task_file(struct file *file)
+static void io_uring_del_task_file(struct file *file, struct xa_state *xas)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	XA_STATE(xas, &tctx->xa, (unsigned long) file);
 
 	if (tctx->last == file)
 		tctx->last = NULL;
@@ -8643,7 +8642,7 @@ static void __io_uring_attempt_task_drop(struct file *file)
 	rcu_read_unlock();
 
 	if (old == file)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(file, &xas);
 }
 
 /*
@@ -8687,7 +8686,7 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 		io_uring_cancel_task_requests(ctx, files);
 		if (files)
-			io_uring_del_task_file(file);
+			io_uring_del_task_file(file, &xas);
 	} while (1);
 }

-- 
Pavel Begunkov
