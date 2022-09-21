Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E5F5E53B6
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 21:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiIUTS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 15:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIUTS6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 15:18:58 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CA79FA82
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 12:18:56 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id m16so3677537iln.9
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 12:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=ZSzIht6m4BK5nSdTrovsRnx7M+qkycFQcOav7HgBsfk=;
        b=mNlw7d11FjH0PHl8IilnpS4+yu58B719eD9XlJECGjSDTuuM2FCAUOghRvV6zCJi8c
         XEXk5MYynkMgn1P6xOGmW2CPO4HSLn7YIdjgZfCAePRVx0+Vz3UwdctRBFQO4GcIm4p8
         NNTY1LF+ospGy7qbc1AY1z5ULl5utQpxd4x0j9jkyM09OlDLJ76Pt9LDsAPpdYgAQctM
         /g4JkiNiWsufs56yu2svxDtXMxc0u5agxqihH6yoX3G5ZFzU1iYa4P2tqGpTE3iAZbtC
         BY/TaMm9j68PSKFW5GXXCOxUklM6JBiwUrcRBpvd7CPQKU4harckBj2SlJ/2VniSNMyQ
         jJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=ZSzIht6m4BK5nSdTrovsRnx7M+qkycFQcOav7HgBsfk=;
        b=4lg8B9dnyJv9zrrn1rQd90BaQOxhQeJdhJKOcFEdtUslRqlwt+einfdp35pAmz0buk
         NVo4E+H4H1ApIuUKAOfWcAZXVjpxr3ILfipS44/NvLSRsVAzKIBAaai2ZkcQLzYdcr38
         eQO0CsMW9L2byzmbCllkU2i+6cRQovVMVa4okE72tjUkd2umAvGwIxraErHaxxu7Met7
         zkEGdxDbmnKpOE2ueYLXW9QqBFWC20EKTaNjPRGiMMSIaJ6V9pRq4kPbP5owlVCDJPGg
         3GGvhwo1Y2onsp55vlgO9xZodLLlNSRaP2CQJPMVvdwk41hbDaS7B+LCWrI8zP3FZfcQ
         VCow==
X-Gm-Message-State: ACrzQf1ab2duqFDMOnyLb9oUoDF8AgaWqjDpeJ38g3f/EszKWqqsqJWA
        yvck3qTFSa7qnBnQaMpQS2lGY+eGt29RkQ==
X-Google-Smtp-Source: AMsMyM6VeGzWZEo3Y8kagcQpDSL75Dr2T9KBYJRW8GSVfvHRY8DjsNIl8ofiLeZiEofF2lbJVgetqQ==
X-Received: by 2002:a92:cdaa:0:b0:2f5:8f98:3ec2 with SMTP id g10-20020a92cdaa000000b002f58f983ec2mr7852287ild.93.1663787935912;
        Wed, 21 Sep 2022 12:18:55 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cn11-20020a0566383a0b00b0035a723e5b23sm1328581jab.7.2022.09.21.12.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 12:18:55 -0700 (PDT)
Message-ID: <5e86f644-2076-1a59-cc2a-6a9f2b927afc@kernel.dk>
Date:   Wed, 21 Sep 2022 13:18:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Dylan Yudaken <dylany@fb.com>, Stefan Roesch <shr@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring: ensure local task_work marks task as
 running
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring will run task_work from contexts that have been prepared for
waiting, and in doing so it'll implicitly set the task running again
to avoid issues with blocking conditions. The new deferred local
task_work doesn't do that, which can result in spews on this being
an invalid condition:

  [  112.917576] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000ad64af64>] prepare_to_wait_exclusive+0x3f/0xd0
[  112.983088] WARNING: CPU: 1 PID: 190 at kernel/sched/core.c:9819 __might_sleep+0x5a/0x60
[  112.987240] Modules linked in:
[  112.990504] CPU: 1 PID: 190 Comm: io_uring Not tainted 6.0.0-rc6+ #1617
[  113.053136] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[  113.133650] RIP: 0010:__might_sleep+0x5a/0x60
[  113.136507] Code: ee 48 89 df 5b 31 d2 5d e9 33 ff ff ff 48 8b 90 30 0b 00 00 48 c7 c7 90 de 45 82 c6 05 20 8b 79 01 01 48 89 d1 e8 3a 49 77 00 <0f> 0b eb d1 66 90 0f 1f 44 00 00 9c 58 f6 c4 02 74 35 65 8b 05 ed
[  113.223940] RSP: 0018:ffffc90000537ca0 EFLAGS: 00010286
[  113.232903] RAX: 0000000000000000 RBX: ffffffff8246782c RCX: ffffffff8270bcc8
IOPS=133.15K, BW=520MiB/s, IOS/call=32/31
[  113.353457] RDX: ffffc90000537b50 RSI: 00000000ffffdfff RDI: 0000000000000001
[  113.358970] RBP: 00000000000003bc R08: 0000000000000000 R09: c0000000ffffdfff
[  113.361746] R10: 0000000000000001 R11: ffffc90000537b48 R12: ffff888103f97280
[  113.424038] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000001
[  113.428009] FS:  00007f67ae7fc700(0000) GS:ffff88842fc80000(0000) knlGS:0000000000000000
[  113.432794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.503186] CR2: 00007f67b8b9b3b0 CR3: 0000000102b9b005 CR4: 0000000000770ee0
[  113.507291] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  113.512669] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  113.574374] PKRU: 55555554
[  113.576800] Call Trace:
[  113.578325]  <TASK>
[  113.579799]  set_page_dirty_lock+0x1b/0x90
[  113.582411]  __bio_release_pages+0x141/0x160
[  113.673078]  ? set_next_entity+0xd7/0x190
[  113.675632]  blk_rq_unmap_user+0xaa/0x210
[  113.678398]  ? timerqueue_del+0x2a/0x40
[  113.679578]  nvme_uring_task_cb+0x94/0xb0
[  113.683025]  __io_run_local_work+0x8a/0x150
[  113.743724]  ? io_cqring_wait+0x33d/0x500
[  113.746091]  io_run_local_work.part.76+0x2e/0x60
[  113.750091]  io_cqring_wait+0x2e7/0x500
[  113.752395]  ? trace_event_raw_event_io_uring_req_failed+0x180/0x180
[  113.823533]  __x64_sys_io_uring_enter+0x131/0x3c0
[  113.827382]  ? switch_fpu_return+0x49/0xc0
[  113.830753]  do_syscall_64+0x34/0x80
[  113.832620]  entry_SYSCALL_64_after_hwframe+0x5e/0xc8

Ensure that we mark current as TASK_RUNNING for deferred task_work
as well.

Fixes: c0e0d6ba25f1 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Reported-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3875ea897cdf..f359e24b46c3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1215,6 +1215,7 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	if (llist_empty(&ctx->work_llist))
 		return 0;
 
+	__set_current_state(TASK_RUNNING);
 	locked = mutex_trylock(&ctx->uring_lock);
 	ret = __io_run_local_work(ctx, locked);
 	if (locked)

-- 
Jens Axboe
