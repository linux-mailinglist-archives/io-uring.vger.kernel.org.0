Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECA8233943
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 21:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgG3Trz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 15:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgG3Try (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 15:47:54 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D309BC061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 12:47:54 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y18so15060321ilp.10
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 12:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=VncnLA90NMebmt+R4sPMjdezbgLytuy9p27DiKdkMHk=;
        b=RP4jJz/hLxItxfy71IE3mZvoJhftlHZdVGjLklgkThB8/Fei97u6lEO73lNIHcnGlw
         h5yGCT387E0N2CoZTqH8xKcnPH1VbQs/ruDI9irtty11jwWWaLRJulSoK4q2FxiBLleX
         /0wYpe2auau8OFyqoJz/YFFN1XXfRpqwp+NX2A6GEW7YPbruFU02U5vyi0ivyOkBgW6e
         JJO1fra34oNbsmho8qLxo4vrvd3TR7heLo8CSy+VAVj+b6QoNY2hFwClSrSJtFpm0guO
         B8g0fZqaE1TDNbMdoT9AgT3c/GPOFddREGQ2kn2dn0jj4uxXQQSeAfCjbzQ4eZXXwTlb
         IfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=VncnLA90NMebmt+R4sPMjdezbgLytuy9p27DiKdkMHk=;
        b=dLmQ+5+Y36fNynB2JL3246NbIRS7RXNY5bbxQ0a+L5pEMlk7Gn/4qLXUniR8Gma6xr
         UHvlGU1uBjMilOI2+K0KruJsoUN/G055KIvFAYVb+uNoUBrOSB3DRv8uKsVjKylMYQwd
         pgH4qBYaJpqsoU+r5isQkTXSq/Dh/c2rE49nMD8Xhzo6ViG8409TFgDN8/47kzO6fmng
         BskNqzTlPfR7Rc5O5tbsumTXPdxZR9q0vcZBrlSRWn/WfUOBSNkvaPxNwl37Fbb8t58c
         uiknTksWwncydB6ImpMvBo9onzxtmqLm8XuiJaCbRQSY10lEvz2dQZYRn4knrABBCfI2
         m+IQ==
X-Gm-Message-State: AOAM533DXL+iKTeAd8LsL4TyhmGE9UfGD7z4/qCrGtLdDz/cnTP91dKA
        TtPzJW9OaUmZ0g1xFXsic5lCIODup74=
X-Google-Smtp-Source: ABdhPJwWQ1j5DsxOe+Kid+xNlgE2TTuL6s9RdHb5ISkhr58rdI/NZMztmo3kEDhPORWpGJgGCTR4Ew==
X-Received: by 2002:a92:8947:: with SMTP id n68mr158390ild.235.1596138474012;
        Thu, 30 Jul 2020 12:47:54 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v8sm963396ile.74.2020.07.30.12.47.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 12:47:53 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't touch 'ctx' after installing file descriptor
Message-ID: <5c2ac23d-3801-c06f-8bf6-4096fef88113@kernel.dk>
Date:   Thu, 30 Jul 2020 13:47:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As soon as we install the file descriptor, we have to assume that it
can get arbitrarily closed. We currently account memory (and note that
we did) after installing the ring fd, which means that it could be a
potential use-after-free condition if the fd is closed right after
being installed, but before we fiddle with the ctx.

In fact, syzbot reported this exact scenario:

BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145

CPU: 0 PID: 18145 Comm: syz-executor.5 Not tainted 5.8.0-rc7-next-20200729-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 io_account_mem fs/io_uring.c:7397 [inline]
 io_uring_create fs/io_uring.c:8369 [inline]
 io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c429
Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8f121d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008540 RCX: 000000000045c429
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000196
RBP: 000000000078bf38 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fff86698cff R14: 00007f8f121d19c0 R15: 000000000078bf0c

Move the accounting of the ring used locked memory before we get and
install the ring file descriptor.

Cc: stable@vger.kernel.org
Reported-by: syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fabf0b692384..33702f3b5af8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8329,6 +8329,15 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ret = -EFAULT;
 		goto err;
 	}
+
+	/*
+	 * Account memory _before_ installing the file descriptor. Once
+	 * the descriptor is installed, it can get closed at any time.
+	 */
+	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
+		       ACCT_LOCKED);
+	ctx->limit_mem = limit_mem;
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
@@ -8338,9 +8347,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
-		       ACCT_LOCKED);
-	ctx->limit_mem = limit_mem;
 	return ret;
 err:
 	io_ring_ctx_wait_and_kill(ctx);

-- 
Jens Axboe

