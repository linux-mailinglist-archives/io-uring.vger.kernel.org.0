Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BD92FE017
	for <lists+io-uring@lfdr.de>; Thu, 21 Jan 2021 04:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhAUDk1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jan 2021 22:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391630AbhAUBiZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jan 2021 20:38:25 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79834C061575
        for <io-uring@vger.kernel.org>; Wed, 20 Jan 2021 17:37:45 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 30so265846pgr.6
        for <io-uring@vger.kernel.org>; Wed, 20 Jan 2021 17:37:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M4zx81qy1YTuIE5AZRew/GPoQyMNGInnSA+Of1bHKws=;
        b=ZFdcv0z74umuFPxvnurxzbYu8rYtRnt76zeUlNBqiQKmHJlAuyw8gcPZJ57KuuKCsF
         zM5BLwOo5xFPSKjEUoCrXpTlUyFG+2D0o244Qg9B1jxYKBQRZanPA0OewdkA5cnwvDIY
         17TDXsqMckA1hs3DxK5Rn85lIMrXNjvXf7NqexyG2dmURLRHrdEvNpl23KdJS216u+dc
         8otnc3DKe3JC/dsLMYe3OeQhouGSu/Ean2yEhEqmsu/ilCtG2njihc9Ymm2eXdiP1x23
         /rtbikVk1pV3e1360Xf2xqeMzhRMKY2nq5CtPkmHKJpH0CLIHYyDP5o82u54ao1KCb6w
         dvig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M4zx81qy1YTuIE5AZRew/GPoQyMNGInnSA+Of1bHKws=;
        b=GtbDfI+27857ximhMa3J3nmHLeIR80meP89caVIQ7T0QWPa2Vs51atFLGEj0MZVKPt
         Gik3EH4OH3Ch7hFa2ij2Fe37fOjCiI5A2hH7mp2olzdCBaFYQjJVWL7X+lvdf8wwcSVn
         ORob4L6T494XgiFeMJhJ4cAClC6FkFRFLNizJ/wcbyZEKXk3F1n7Go50mS9X5/y5RN3J
         Sfxvy1jE7wGO2z1wxnLz0/WwMgOreCZGwBH7moATPeLiQo+rxXZmSxTezOuAX5q7lp/a
         CeJK3dcEHOdRmuJCLCf764OdMd6M+THIpUaW5I8ehwzLCxJM95L9ciozmA/nR7xFmE8Y
         2Omw==
X-Gm-Message-State: AOAM5339Dz8ogMh8jRoPggYQ3Kbp/m6Pk3/cLspmDGKKaZC14UFn6dVn
        5kL94vd/6IRojzReFkkjPXPXWeciMzQ=
X-Google-Smtp-Source: ABdhPJyieJb/fAvxzvPf7snhjBfFMckNVq7ABvtMd1U6yjZiZHIfq+CPVxQe1yFxxo/d1ekHDm2Hsg==
X-Received: by 2002:a63:d149:: with SMTP id c9mr12173517pgj.351.1611193064072;
        Wed, 20 Jan 2021 17:37:44 -0800 (PST)
Received: from B-D1K7ML85-0059.local ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id s23sm3455211pgj.29.2021.01.20.17.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 17:37:43 -0800 (PST)
Subject: Re: [PATCH] io_uring: leave clean req to be done in flush overflow
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1611130310-108105-1-git-send-email-joseph.qi@linux.alibaba.com>
 <62fdcc48-ccb2-2a51-a69f-9ead1ff1ea59@gmail.com>
From:   Joseph Qi <jiangqi903@gmail.com>
Message-ID: <0de4ca7e-fd6b-2821-00cd-6c69deb1d9e0@gmail.com>
Date:   Thu, 21 Jan 2021 09:37:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <62fdcc48-ccb2-2a51-a69f-9ead1ff1ea59@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/20/21 8:35 PM, Pavel Begunkov wrote:
> On 20/01/2021 08:11, Joseph Qi wrote:
>> Abaci reported the following BUG:
>>
>> [   27.629441] BUG: sleeping function called from invalid context at fs/file.c:402
>> [   27.631317] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 1012, name: io_wqe_worker-0
>> [   27.633220] 1 lock held by io_wqe_worker-0/1012:
>> [   27.634286]  #0: ffff888105e26c98 (&ctx->completion_lock){....}-{2:2}, at: __io_req_complete.part.102+0x30/0x70
>> [   27.636487] irq event stamp: 66658
>> [   27.637302] hardirqs last  enabled at (66657): [<ffffffff8144ba02>] kmem_cache_free+0x1f2/0x3b0
>> [   27.639211] hardirqs last disabled at (66658): [<ffffffff82003a77>] _raw_spin_lock_irqsave+0x17/0x50
>> [   27.641196] softirqs last  enabled at (64686): [<ffffffff824003c5>] __do_softirq+0x3c5/0x5aa
>> [   27.643062] softirqs last disabled at (64681): [<ffffffff8220108f>] asm_call_irq_on_stack+0xf/0x20
>> [   27.645029] CPU: 1 PID: 1012 Comm: io_wqe_worker-0 Not tainted 5.11.0-rc4+ #68
>> [   27.646651] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
>> [   27.649249] Call Trace:
>> [   27.649874]  dump_stack+0xac/0xe3
>> [   27.650666]  ___might_sleep+0x284/0x2c0
>> [   27.651566]  put_files_struct+0xb8/0x120
>> [   27.652481]  __io_clean_op+0x10c/0x2a0
>> [   27.653362]  __io_cqring_fill_event+0x2c1/0x350
>> [   27.654399]  __io_req_complete.part.102+0x41/0x70
>> [   27.655464]  io_openat2+0x151/0x300
>> [   27.656297]  io_issue_sqe+0x6c/0x14e0
>> [   27.657170]  ? lock_acquire+0x31a/0x440
>> [   27.658068]  ? io_worker_handle_work+0x24e/0x8a0
>> [   27.659119]  ? find_held_lock+0x28/0xb0
>> [   27.660026]  ? io_wq_submit_work+0x7f/0x240
>> [   27.660991]  io_wq_submit_work+0x7f/0x240
>> [   27.661915]  ? trace_hardirqs_on+0x46/0x110
>> [   27.662890]  io_worker_handle_work+0x501/0x8a0
>> [   27.663917]  ? io_wqe_worker+0x135/0x520
>> [   27.664836]  io_wqe_worker+0x158/0x520
>> [   27.665719]  ? __kthread_parkme+0x96/0xc0
>> [   27.666663]  ? io_worker_handle_work+0x8a0/0x8a0
>> [   27.667726]  kthread+0x134/0x180
>> [   27.668506]  ? kthread_create_worker_on_cpu+0x90/0x90
>> [   27.669641]  ret_from_fork+0x1f/0x30
>>
>> It blames we call cond_resched() with completion_lock when clean
>> request. In fact we will do it during flush overflow and it seems we
>> have no reason to do it before. So just remove io_clean_op() in
>> __io_cqring_fill_event() to fix this BUG.
> 
> Nope, it would be broken. You may override, e.g. iov pointer
> that is dynamically allocated, and the function makes sure all
> those are deleted and freed. Most probably there will be problems
> on flush side as well.
> 
> Looks like the problem is that we do spin_lock_irqsave() in
> __io_req_complete() and then just spin_lock() for put_files_struct().
> Jens, is it a real problem?
> 
From the code, it is because it might sleep in close_files():

...
if (file) {
	filp_close(file, files);
	cond_resched();
}


Thanks,
Joseph

> At least for 5.12 there is a cleanup as below, moving drop_files()
> into io_req_clean_work/io_free_req(), which is out of locks. Depends
> on that don't-cancel-by-files patch, but I guess can be for 5.11
