Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D619A1A5F22
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 16:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgDLOwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 10:52:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37040 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgDLOwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 10:52:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id u65so3441189pfb.4
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 07:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WuIgZzWQi9iERcI2eZDS7hTrGgy5VNCS2wRVMjyig3g=;
        b=gFJ/lB4V6bIBFSuXb+CUirdIQub+4dDYix6Dywuqx9OiS7CzgbZ38iNK2eMtB43fbc
         niV6ViJZNDoN5UsDchmNftOfP5yoSzJVts4ZjgGT5cF9Zm6WETV425VMRcc4umn7qJKU
         sTAoWH1FHjJMIbzbcKXNVxvX/Fj5lkCfWKTdKLa5P1VoRbXnz9EGRvK45HuYQpbu/ngI
         sgEDu6t44F3QsmQwJROJ5N0Cd5L7k/8X4UsHJ6YtNH/m7PqqdkcS3KllwbbkIJyZXRpH
         wV+4GFLAGeoEkeX+7rX/i4c0Pc2h4x1gTtjgKhKvAwjuzo6KqE6vy2EN5tC95yUZA2li
         3+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WuIgZzWQi9iERcI2eZDS7hTrGgy5VNCS2wRVMjyig3g=;
        b=iX8RG3zZ/qD8ovbYrK7fml+wVnrM+ibETMF0VLzkmF+vjLPjnRHkAiOKals7XGwlli
         MsqHiKRCuBwaz6eRUh0A6SIW8Az0d09wECv7ASzBb29hLD4FzMeOuRTxDp1H1NIoy0Ra
         3MT9zOBYzlAeVDzZ2spwaijGC/7nsqPGuU6dBFg/mlxGeKN8wHD9E/891j/hdIFAXzlq
         okFoeArZ5H67/DzuJXrR9ms/wmAt7As1DJEss0g0Nx+BFLk9OuDwAfm9dr/WjvSziKCO
         diS4QndHvJr6dmd36p+tDxUQ+obL+GYds6y0ulsneBU2tYfIWxExZNCaCABA/rS3aYkK
         eHkQ==
X-Gm-Message-State: AGi0PuYvKDw4VPb9c70xXak0xHIod7w92lObyo5J6YsfP+V4/0C9jnJV
        b9wsEA4yBnzOdTEdO/KXY8cWRuoXYWFWuQ==
X-Google-Smtp-Source: APiQypIn7vbMqMgLwPLOLH3vX71DEF3dMKqGezRxCyI15ut0bFtEzB7lDnmFMJsSmbBLJ9QCTZUwlQ==
X-Received: by 2002:a65:608a:: with SMTP id t10mr5269564pgu.307.1586703129961;
        Sun, 12 Apr 2020 07:52:09 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id ml24sm3980867pjb.48.2020.04.12.07.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 07:52:09 -0700 (PDT)
Subject: Re: [PATCH] io_uring: restore req->work when canceling poll request
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200412065054.2092-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06ca7239-0075-c75f-d7f6-4a0329596883@kernel.dk>
Date:   Sun, 12 Apr 2020 08:52:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200412065054.2092-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/20 12:50 AM, Xiaoguang Wang wrote:
> When running liburing test case 'accept', I got below warning:
> RED: Invalid credentials
> RED: At include/linux/cred.h:285
> RED: Specified credentials: 00000000d02474a0
> RED: ->magic=4b, put_addr=000000005b4f46e9
> RED: ->usage=-1699227648, subscr=-25693
> RED: ->*uid = { 256,-25693,-25693,65534 }
> RED: ->*gid = { 0,-1925859360,-1789740800,-1827028688 }
> RED: ->security is 00000000258c136e
> eneral protection fault, probably for non-canonical address 0xdead4ead00000000: 0000 [#1] SMP PTI
> PU: 21 PID: 2037 Comm: accept Not tainted 5.6.0+ #318
> ardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
> IP: 0010:dump_invalid_creds+0x16f/0x184
> ode: 48 8b 83 88 00 00 00 48 3d ff 0f 00 00 76 29 48 89 c2 81 e2 00 ff ff ff 48
> 81 fa 00 6b 6b 6b 74 17 5b 48 c7 c7 4b b1 10 8e 5d <8b> 50 04 41 5c 8b 30 41 5d
> e9 67 e3 04 00 5b 5d 41 5c 41 5d c3 0f
> SP: 0018:ffffacc1039dfb38 EFLAGS: 00010087
> AX: dead4ead00000000 RBX: ffff9ba39319c100 RCX: 0000000000000007
> DX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e10b14b
> BP: ffffffff8e108476 R08: 0000000000000000 R09: 0000000000000001
> 10: 0000000000000000 R11: ffffacc1039df9e5 R12: 000000009552b900
> 13: 000000009319c130 R14: ffff9ba39319c100 R15: 0000000000000246
> S:  00007f96b2bfc4c0(0000) GS:ffff9ba39f340000(0000) knlGS:0000000000000000
> S:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> R2: 0000000000401870 CR3: 00000007db7a4000 CR4: 00000000000006e0
> all Trace:
> __invalid_creds+0x48/0x4a
> __io_req_aux_free+0x2e8/0x3b0
> ? io_poll_remove_one+0x2a/0x1d0
> __io_free_req+0x18/0x200
> io_free_req+0x31/0x350
> io_poll_remove_one+0x17f/0x1d0
> io_poll_cancel.isra.80+0x6c/0x80
> io_async_find_and_cancel+0x111/0x120
> io_issue_sqe+0x181/0x10e0
> ? __lock_acquire+0x552/0xae0
> ? lock_acquire+0x8e/0x310
> ? fs_reclaim_acquire.part.97+0x5/0x30
> __io_queue_sqe.part.100+0xc4/0x580
> ? io_submit_sqes+0x751/0xbd0
> ? rcu_read_lock_sched_held+0x32/0x40
> io_submit_sqes+0x9ba/0xbd0
> ? __x64_sys_io_uring_enter+0x2b2/0x460
> ? __x64_sys_io_uring_enter+0xaf/0x460
> ? find_held_lock+0x2d/0x90
> ? __x64_sys_io_uring_enter+0x111/0x460
> __x64_sys_io_uring_enter+0x2d7/0x460
> do_syscall_64+0x5a/0x230
> entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> After looking into codes, it turns out that this issue is because we didn't
> restore the req->work, which is changed in io_arm_poll_handler(), req->work
> is a union with below struct:
> 	struct {
> 		struct callback_head	task_work;
> 		struct hlist_node	hash_node;
> 		struct async_poll	*apoll;
> 	};
> If we forget to restore, members in struct io_wq_work would be invalid,
> restore the req->work to fix this issue.

Thanks for debugging this. But how about we just use 'apoll' to see
if we need to restore or not. Just a slight modification to your patch:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c0cf57764329..68a678a0056b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4318,11 +4318,13 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 
 static bool io_poll_remove_one(struct io_kiocb *req)
 {
+	struct async_poll *apoll = NULL;
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
+		apoll = req->apoll;
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &req->apoll->poll);
 		if (do_complete)
@@ -4331,6 +4333,14 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 
 	hash_del(&req->hash_node);
 
+	if (apoll) {
+		/*
+		 * restore ->work because we need to call io_req_work_drop_env.
+		 */
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll);
+	}
+
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);

-- 
Jens Axboe

