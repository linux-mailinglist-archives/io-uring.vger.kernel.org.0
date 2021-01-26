Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A455304353
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 17:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbhAZQBy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 11:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730814AbhAZQBo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 11:01:44 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F9C0617A7
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 08:01:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id jx18so2451545pjb.5
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 08:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3DT9uihTk7TbPAf93SEFyTGz/zQG62tw5zH79pD/6EI=;
        b=E+DUMd8Gz0BFXvtIBR4Z0UJfnRvs96hOqrM9yYh5R9WOehHoPxX8YR9Ypc+GADvWO9
         YKao47C2CZMDlcT1EvaAJ6IOqbTQ/wzSixkyu3TcoZYae3DL/JAoLeiMl6l5EIj/FIOu
         HmSG0Vc/g3PDxAPLMCA9Xqkl3LmgZF3FYCgWPZawAlR7prI8j7777wsoeaMKOHYaRbG1
         rjXkiSTB4YkM47OTo4hIT1Upq7rYyYn/u0rSMZQjARn34ltwcF7MlzFTQKGOyUZ7nu08
         vc8ZZC/1cTdlabJ3CWBCKpa8ObagBnka+i0XCJUKHQErWXwtElACVkcf0l0rEMeu3GZG
         UMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3DT9uihTk7TbPAf93SEFyTGz/zQG62tw5zH79pD/6EI=;
        b=Ghlmn+IH5YSGcM9xbAPtLpMfnJI6tnKe5x4rAAUbfWPx3cLpa5A/Hm21uUCCGjFXuK
         kb9hcrgoyUTggzHWX/vMWwMTUEWmoLgmWO8GLVbbAAieSonftBG1ZHPr1pLpsprqSCg0
         yPeBwKRKv6WdFfmtcD1KY1aIx0d2eoeoTPten/LqkcuQLBq5mwwzsou9PcXZ3iOw6Iz2
         AAfl6IoKWn1u1zyM+rrn1lO05gn/9DrrAGOAqVDnMKyrQfWjlVErCmGFxDGyzjMkPcHi
         gzFuKfu8yo1ZnlzOHvWhvLFBgb+EebtT3M60I4NLIObLsIF1AdfpsljH5lnn39GQh7+L
         O0bA==
X-Gm-Message-State: AOAM532Sz4ecuUkSvBcVbgTdN3o6zmSsuZr+WpjJcvz/roCeTuSZkvKs
        qD54ObSLQ5msKaP59Yrg7BWWzQMEZudLGg==
X-Google-Smtp-Source: ABdhPJySHMmfai6k7SFlSSHLpmafK4sWZtl1oXG4i9/088+cclvKwrr71ttsDiOCwN0+bKhDwUzi/A==
X-Received: by 2002:a17:90a:ae07:: with SMTP id t7mr418770pjq.115.1611676863445;
        Tue, 26 Jan 2021 08:01:03 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 85sm19795597pfc.39.2021.01.26.08.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:01:02 -0800 (PST)
Subject: Re: [PATCH 2/2] io_uring: fix cancellation taking mutex while
 TASK_UNINTERRUPTIBLE
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org,
        syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
References: <cover.1611674535.git.asml.silence@gmail.com>
 <70fb7f91ecc0aeff3427c215ec7f46ceb77f88ef.1611674535.git.asml.silence@gmail.com>
 <5955c0cc-b671-9470-fe31-e4450e9c9c9a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ac56bc4-49ef-9321-41a8-5dd16b599824@kernel.dk>
Date:   Tue, 26 Jan 2021 09:01:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5955c0cc-b671-9470-fe31-e4450e9c9c9a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 8:56 AM, Pavel Begunkov wrote:
> On 26/01/2021 15:28, Pavel Begunkov wrote:
>> do not call blocking ops when !TASK_RUNNING; state=2 set at
>> 	[<00000000ced9dbfc>] prepare_to_wait+0x1f4/0x3b0
>> 	kernel/sched/wait.c:262
>> WARNING: CPU: 1 PID: 19888 at kernel/sched/core.c:7853
>> 	__might_sleep+0xed/0x100 kernel/sched/core.c:7848
>> RIP: 0010:__might_sleep+0xed/0x100 kernel/sched/core.c:7848
>> Call Trace:
>>  __mutex_lock_common+0xc4/0x2ef0 kernel/locking/mutex.c:935
>>  __mutex_lock kernel/locking/mutex.c:1103 [inline]
>>  mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
>>  io_wq_submit_work+0x39a/0x720 fs/io_uring.c:6411
>>  io_run_cancel fs/io-wq.c:856 [inline]
>>  io_wqe_cancel_pending_work fs/io-wq.c:990 [inline]
>>  io_wq_cancel_cb+0x614/0xcb0 fs/io-wq.c:1027
>>  io_uring_cancel_files fs/io_uring.c:8874 [inline]
>>  io_uring_cancel_task_requests fs/io_uring.c:8952 [inline]
>>  __io_uring_files_cancel+0x115d/0x19e0 fs/io_uring.c:9038
>>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>>  do_exit+0x2e6/0x2490 kernel/exit.c:780
>>  do_group_exit+0x168/0x2d0 kernel/exit.c:922
>>  get_signal+0x16b5/0x2030 kernel/signal.c:2770
>>  arch_do_signal_or_restart+0x8e/0x6a0 arch/x86/kernel/signal.c:811
>>  handle_signal_work kernel/entry/common.c:147 [inline]
>>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>>  exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:201
>>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>>  syscall_exit_to_user_mode+0x48/0x190 kernel/entry/common.c:302
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Rewrite io_uring_cancel_files() to mimic __io_uring_task_cancel()'s
>> counting scheme, so it does all the heavy work before setting
>> TASK_UNINTERRUPTIBLE.
>>
>> Cc: stable@vger.kernel.org # 5.9+
>> Reported-by: syzbot+f655445043a26a7cfab8@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 41 ++++++++++++++++++++++++-----------------
>>  1 file changed, 24 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 09aada153a71..f3f2b37e7021 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8873,30 +8873,33 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
>>  	}
>>  }
>>  
>> +static int io_uring_count_inflight(struct io_ring_ctx *ctx,
>> +				   struct task_struct *task,
>> +				   struct files_struct *files)
>> +{
>> +	struct io_kiocb *req;
>> +	int cnt = 0;
>> +
>> +	spin_lock_irq(&ctx->inflight_lock);
>> +	list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
>> +		if (!io_match_task(req, task, files))
> 
> This condition should be inversed. Jens, please drop it
> 
> p.s. I wonder how tests didn't catch that

Probably just make it cnt += io_match_task(req, task_files) to simplify
it. But yes, it looks reversed.

-- 
Jens Axboe

