Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F1A2BBC79
	for <lists+io-uring@lfdr.de>; Sat, 21 Nov 2020 04:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKUDAg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 22:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgKUDAf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 22:00:35 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661AAC0613CF
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 19:00:34 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id 5so5881923plj.8
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 19:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OzHhik2UmZHvmSec3Pnmvmxe9cQ+b9e2Wszp9R3ciIg=;
        b=DX1fOgscNU2pOak+v7C05FaOavpeahTINU5v7McJz29d+jdUAgOeJlliP+eQipUAR8
         lUxTXtYvaUWMThRAVzxf3oEGK90nJkwfbEKijPwYInIaF29EsgVNReUhdeoEVlVEdewZ
         cJF8YUBT2sxF2kK00JslLp7FnJnTqLS1SOgwCEPJQjxfQ7BjwtMS2x+019v8SpxHyN6U
         qnrwlojuM9ISq9ILSBabZzA/VCb5Z+CwNdKXzqOGWOIh7wM3Bntovtxx6dd06VtuCD2n
         apGFJvPp3uyTfDRAXYaiKkgKyduVoz15u5Q2LRCFYmI5qzdC6D1KsXcaBZmuQnziXZ5v
         vdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzHhik2UmZHvmSec3Pnmvmxe9cQ+b9e2Wszp9R3ciIg=;
        b=HYLXI8Rl/yX1IO/a2qkXtTyZb3JDaDr3mGLZV+fNLFfcwo4Wf7XK84J87NXyW/M80G
         pGh1e7dJDKNZOxzIumhat92SsUZ/DDyKja6E7MMOJU6L8uWa8nWHdbd2VNHeHsGv91aS
         INYbGVSyiJvhCHTss8o5I/PsSp4zIFdPhnZsJd0PiE0/PCY9xaencTXNz6/1oh1yPT9T
         wTWi8Nzdm/kOr6oI28A6xR3xcc/xWNDrpdsqn8HN2ON8MX9v6scdVHBO79WkylGFSiK5
         LQ+8itKLg16bU9S/IuqDS4ty0e/0FDrzoqak92AdYtRdbP9dvWkeLW/o4uxEx4P9M2YG
         aQ3Q==
X-Gm-Message-State: AOAM531F5AyHzVAV/6a00TC6kqrea26fJYXp0wYEmeSNRf40TaXwY4Ic
        mxFweAYpcOlUYfkKKhDjsGA8XQGjZ52UYA==
X-Google-Smtp-Source: ABdhPJxSvFEXb1pGA4Q1UDqBRFBkuzSPFebLabQaXecI8ozmwhss2+Y/eEIjVDiPj81ihlddaKRGMg==
X-Received: by 2002:a17:902:fe07:b029:d6:88c5:f5d5 with SMTP id g7-20020a170902fe07b02900d688c5f5d5mr15706358plj.63.1605927633824;
        Fri, 20 Nov 2020 19:00:33 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k26sm5255235pfg.8.2020.11.20.19.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 19:00:33 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.10-rc
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6535286b-2532-dc86-3c6e-1b1e9bce358f@kernel.dk>
 <CAHk-=wjrayP=rOB+v+2eTP8micykkM76t=6vp-hyy+vWYkL8=A@mail.gmail.com>
 <4bcf3012-a4ad-ac2d-e70b-17f17441eea9@kernel.dk>
 <CAHk-=wimYoUtY4ygMNknkKZHqgYBZbkU4Koo5cE6ar8XjHkzGg@mail.gmail.com>
 <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk>
Message-ID: <d7095e1d-0363-0aad-5c13-6d9bb189b2c8@kernel.dk>
Date:   Fri, 20 Nov 2020 20:00:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ad8db5d0-2fac-90b6-b9e4-746a52b8ac57@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/20/20 7:41 PM, Jens Axboe wrote:
> On 11/20/20 5:23 PM, Linus Torvalds wrote:
>> On Fri, Nov 20, 2020 at 1:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> I don't disagree with you on that. I've been a bit gun shy on touching
>>> the VFS side of things, but this one isn't too bad. I hacked up a patch
>>> that allows io_uring to do LOOKUP_RCU and a quick test seems to indicate
>>> it's fine. On top of that, we just propagate the error if we do fail and
>>> get rid of that odd retry loop.
>>
>> Ok, this looks better to me (but is obviously not 5.10 material).
>>
>> That said, I think I'd prefer to keep 'struct nameidata' internal to
>> just fs/namei.c, and maybe we can just expert that
>>
>>         struct nameidata nd;
>>
>>         set_nameidata(&nd, req->open.dfd, req->open.filename);
>>         file = path_openat(&nd, &op, op.lookup_flags | LOOKUP_RCU);
>>         restore_nameidata();
>>         return filp == ERR_PTR(-ECHILD) ? -EAGAIN : filp;
>>
>> as a helper from namei.c instead? Call it "do_filp_open_rcu()" or something?
> 
> Yes, that's probably a better idea. I'll move in that direction.

Actually, I think we can do even better. How about just having
do_filp_open() exit after LOOKUP_RCU fails, if LOOKUP_RCU was already
set in the lookup flags? Then we don't need to change much else, and
most of it falls out naturally.

Except it seems that should work, except LOOKUP_RCU does not guarantee
that we're not going to do IO:

[   20.463195]  schedule+0x5f/0xd0
[   20.463444]  io_schedule+0x45/0x70
[   20.463712]  bit_wait_io+0x11/0x50
[   20.463981]  __wait_on_bit+0x2c/0x90
[   20.464264]  out_of_line_wait_on_bit+0x86/0x90
[   20.464611]  ? var_wake_function+0x30/0x30
[   20.464932]  __ext4_find_entry+0x2b5/0x410
[   20.465254]  ? d_alloc_parallel+0x241/0x4e0
[   20.465581]  ext4_lookup+0x51/0x1b0
[   20.465855]  ? __d_lookup+0x77/0x120
[   20.466136]  path_openat+0x4e8/0xe40
[   20.466417]  do_filp_open+0x79/0x100
[   20.466720]  ? __kernel_text_address+0x30/0x70
[   20.467068]  ? __alloc_fd+0xb3/0x150
[   20.467349]  io_openat2+0x65/0x210
[   20.467618]  io_issue_sqe+0x3e/0xf70

Which I'm actually pretty sure that I discovered before and attempted to
do a LOOKUP_NONBLOCK, which was kind of half assed and that Al
(rightfully) hated because of that.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43ba815e4107..9a0a21ac5227 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4069,36 +4069,25 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	struct file *file;
 	int ret;
 
-	if (force_nonblock && !req->open.ignore_nonblock)
-		return -EAGAIN;
-
 	ret = build_open_flags(&req->open.how, &op);
 	if (ret)
 		goto err;
+	if (force_nonblock)
+		op.lookup_flags |= LOOKUP_RCU;
 
 	ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
 	if (ret < 0)
 		goto err;
 
 	file = do_filp_open(req->open.dfd, req->open.filename, &op);
+	if (force_nonblock && file == ERR_PTR(-ECHILD)) {
+		put_unused_fd(ret);
+		return -EAGAIN;
+	}
+
 	if (IS_ERR(file)) {
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
-		/*
-		 * A work-around to ensure that /proc/self works that way
-		 * that it should - if we get -EOPNOTSUPP back, then assume
-		 * that proc_self_get_link() failed us because we're in async
-		 * context. We should be safe to retry this from the task
-		 * itself with force_nonblock == false set, as it should not
-		 * block on lookup. Would be nice to know this upfront and
-		 * avoid the async dance, but doesn't seem feasible.
-		 */
-		if (ret == -EOPNOTSUPP && io_wq_current_is_worker()) {
-			req->open.ignore_nonblock = true;
-			refcount_inc(&req->refs);
-			io_req_task_queue(req);
-			return 0;
-		}
 	} else {
 		fsnotify_open(file);
 		fd_install(ret, file);
diff --git a/fs/namei.c b/fs/namei.c
index 03d0e11e4f36..eb2c917986a5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3394,8 +3394,11 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 
 	set_nameidata(&nd, dfd, pathname);
 	filp = path_openat(&nd, op, flags | LOOKUP_RCU);
-	if (unlikely(filp == ERR_PTR(-ECHILD)))
+	if (unlikely(filp == ERR_PTR(-ECHILD))) {
+		if (flags & LOOKUP_RCU)
+			return filp;
 		filp = path_openat(&nd, op, flags);
+	}
 	if (unlikely(filp == ERR_PTR(-ESTALE)))
 		filp = path_openat(&nd, op, flags | LOOKUP_REVAL);
 	restore_nameidata();

-- 
Jens Axboe

