Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740582FC7C6
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 03:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbhATC0J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 21:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731123AbhATCUw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:20:52 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362FC061575
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:20:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m5so1166812pjv.5
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nUUDTC9LRTxK0DVPS8Jc6UOGVR1HMLI2wfz5qIMqw3k=;
        b=wA5RScgWv4Tb6Hf2PzuBq0Kusyk4AjnAnNM3Dbi9uaa8c83Q1tzClHQkoiIhALoi0Q
         klizZPL6YDKpLIYu8tUax2uIGalf1wX7HXc1rUE3a8s2NPLR/pOEeWDziPxyfjy/Ag0Z
         XalYyHqczS7+hYEZRhTSYkvX/lmXTeti9+aynyazkJiTUjkNGAxbij6K13R401XY1L4Y
         7B55o6WcUk8Xdc9cCVENJpM3HFE3aZ60KwVOwOUGDJ9yGWbTBf2BpLOFrlzgmZyRj5FD
         ASqOZT7oo6RJGAqHT/IaxV683TFywANNYrxY+4aH00+ceRerrj3VhiiRB/3yecfrHPsK
         75Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nUUDTC9LRTxK0DVPS8Jc6UOGVR1HMLI2wfz5qIMqw3k=;
        b=FRcY/i595VamYkCKXEXRXlpTyt1TYY/ljiy6/89fI5Laob/Wg5riFr9VSZ1RmXZju/
         2ufZQ/vL7fQJ14wzJiqxR+eRd+1p7+rKlg6vMtsWDzb9oK02FbAgDFLwPEqArlUonAB2
         O+/WpJeAJNzVnrYMjKJfYs4/DrA7v4C0+6lRv0ooSc2z9GtD0LKx0QbY4H/c9nBJPGu6
         8MkC4yApXBS2Wz/pdM1jmAYE2iwdQhFoNfygRyTKMaC7JBpQGQL2uOMw/n9ih4/gWWJG
         GG6JqwStc76HJGMxn4yc4+yb8TO/VoJQs7UbDx/a9GuduwHGTZjFahbkYxRg0Jf+xQnM
         i/DA==
X-Gm-Message-State: AOAM532qcHUpTesrWtYO21IaAPAw3wEGh8QaB4rq0YOaQG0T5Yyehkz5
        bfdWTDzmXzRgzcDAOmwBi3uyFr0jbqYSSA==
X-Google-Smtp-Source: ABdhPJx7Kp3dMhxohpFD5o+4m6ok8xxILHHvmgrcNWqcbFHW1ZBYtpMWEIQ9X6skhMtF5QwQcCNllg==
X-Received: by 2002:a17:902:be11:b029:da:ba30:5791 with SMTP id r17-20020a170902be11b02900daba305791mr7657312pls.13.1611109209973;
        Tue, 19 Jan 2021 18:20:09 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x186sm364959pfb.26.2021.01.19.18.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 18:20:09 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix SQPOLL IORING_OP_CLOSE cancelation state
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <e1617bdf-3b4f-f598-a0ad-13ad68bb1e42@kernel.dk>
 <7c176c50-0f62-6753-eeef-bbb7a803febf@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <93a9c6e2-3d62-852b-b4fb-0f1cfebe43ec@kernel.dk>
Date:   Tue, 19 Jan 2021 19:20:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7c176c50-0f62-6753-eeef-bbb7a803febf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/21 7:07 PM, Joseph Qi wrote:
> 
> 
> On 1/20/21 1:18 AM, Jens Axboe wrote:
>> IORING_OP_CLOSE is special in terms of cancelation, since it has an
>> intermediate state where we've removed the file descriptor but hasn't
>> closed the file yet. For that reason, it's currently marked with
>> IO_WQ_WORK_NO_CANCEL to prevent cancelation. This ensures that the op
>> is always run even if canceled, to prevent leaving us with a live file
>> but an fd that is gone. However, with SQPOLL, since a cancel request
>> doesn't carry any resources on behalf of the request being canceled, if
>> we cancel before any of the close op has been run, we can end up with
>> io-wq not having the ->files assigned. This can result in the following
>> oops reported by Joseph:
>>
>> BUG: kernel NULL pointer dereference, address: 00000000000000d8
>> PGD 800000010b76f067 P4D 800000010b76f067 PUD 10b462067 PMD 0
>> Oops: 0000 [#1] SMP PTI
>> CPU: 1 PID: 1788 Comm: io_uring-sq Not tainted 5.11.0-rc4 #1
>> Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>> RIP: 0010:__lock_acquire+0x19d/0x18c0
>> Code: 00 00 8b 1d fd 56 dd 08 85 db 0f 85 43 05 00 00 48 c7 c6 98 7b 95 82 48 c7 c7 57 96 93 82 e8 9a bc f5 ff 0f 0b e9 2b 05 00 00 <48> 81 3f c0 ca 67 8a b8 00 00 00 00 41 0f 45 c0 89 04 24 e9 81 fe
>> RSP: 0018:ffffc90001933828 EFLAGS: 00010002
>> RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000d8
>> RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
>> R13: 0000000000000000 R14: ffff888106e8a140 R15: 00000000000000d8
>> FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00000000000000d8 CR3: 0000000106efa004 CR4: 00000000003706e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  lock_acquire+0x31a/0x440
>>  ? close_fd_get_file+0x39/0x160
>>  ? __lock_acquire+0x647/0x18c0
>>  _raw_spin_lock+0x2c/0x40
>>  ? close_fd_get_file+0x39/0x160
>>  close_fd_get_file+0x39/0x160
>>  io_issue_sqe+0x1334/0x14e0
>>  ? lock_acquire+0x31a/0x440
>>  ? __io_free_req+0xcf/0x2e0
>>  ? __io_free_req+0x175/0x2e0
>>  ? find_held_lock+0x28/0xb0
>>  ? io_wq_submit_work+0x7f/0x240
>>  io_wq_submit_work+0x7f/0x240
>>  io_wq_cancel_cb+0x161/0x580
>>  ? io_wqe_wake_worker+0x114/0x360
>>  ? io_uring_get_socket+0x40/0x40
>>  io_async_find_and_cancel+0x3b/0x140
>>  io_issue_sqe+0xbe1/0x14e0
>>  ? __lock_acquire+0x647/0x18c0
>>  ? __io_queue_sqe+0x10b/0x5f0
>>  __io_queue_sqe+0x10b/0x5f0
>>  ? io_req_prep+0xdb/0x1150
>>  ? mark_held_locks+0x6d/0xb0
>>  ? mark_held_locks+0x6d/0xb0
>>  ? io_queue_sqe+0x235/0x4b0
>>  io_queue_sqe+0x235/0x4b0
>>  io_submit_sqes+0xd7e/0x12a0
>>  ? _raw_spin_unlock_irq+0x24/0x30
>>  ? io_sq_thread+0x3ae/0x940
>>  io_sq_thread+0x207/0x940
>>  ? do_wait_intr_irq+0xc0/0xc0
>>  ? __ia32_sys_io_uring_enter+0x650/0x650
>>  kthread+0x134/0x180
>>  ? kthread_create_worker_on_cpu+0x90/0x90
>>  ret_from_fork+0x1f/0x30
>>
>> Fix this by moving the IO_WQ_WORK_NO_CANCEL until _after_ we've modified
>> the fdtable. Canceling before this point is totally fine, and running
>> it in the io-wq context _after_ that point is also fine.
>>
>> For 5.12, we'll handle this internally and get rid of the no-cancel
>> flag, as IORING_OP_CLOSE is the only user of it.
>>
>> Fixes: 14587a46646d ("io_uring: enable file table usage for SQPOLL rings")
> 
> As discussed with Pavel, this can not only happen in case sqpoll, but
> also in case async cancel is from io-wq.

Correct, I actually did change that after the fact, just not before I
sent out this email...

>> Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> 
> In fact, it is reported by "Abaci <abaci@linux.alibaba.com>"

I'll fix that up.

>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Reviewed-and-tested-by: Joseph Qi <joseph.qi@linux.alibaba.com>

And add that. Thanks for the initial report, and for the subsequent
testing! I know we didn't end up using your first patch, but I do
really appreciate you taking a stab at it. I hope we'll see more
patches from you in the future.

-- 
Jens Axboe

