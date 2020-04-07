Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48271A1068
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 17:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgDGPkr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 11:40:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46425 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728917AbgDGPkq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 11:40:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id s23so1365604plq.13
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 08:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4P7T8G+It1lfEow5NzikVDxZyacALu9+lI4kOz3PtQA=;
        b=dqeq7MOGSR0kCtHXvaK7zjxls5hbATkcGz1zbQ3ln24ykPTf7HuauvJ3F58ftHWDWP
         mWPEog2H9dFFAlLvM4Eu2CB24vwd02kJcTVLVnQO+ZWRDwqXVOb2531iFR+Ti/Ej29xK
         mNcqZ+vRznwnfcFeSAauWvvD4QyW1jLciuS5wst+19JiHSMVL4/it7tVz0oL2PNi8Yzv
         FUQYC2x7xKmJoT2qumfBQKdIE+I7hodFb7PyPnN+RMPj2/8Wzn40DPVjXqF7wSazhG37
         zmA4RLcpGA+xVdDoGBgHZp6XigE3vN/fIDNcCA4cCo7Q/CKqY7ikGOda8xXPHkDdChnc
         +Z9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4P7T8G+It1lfEow5NzikVDxZyacALu9+lI4kOz3PtQA=;
        b=TMxpSt+U4QFXl71dGY7KtaSOeI1RRuRg2pCUhnXusr8qR30q3YhQxqv3SXjRfJdwuY
         11mpChXWTHuq/2IGxW2DxToXXInxFTM8nSW8ubOTpKOCRPhRF8rJqc+i9kYPVb3Hi1GP
         BIfoIQ//aU93Wv5bmefrVB+EX5rbDRODHjzDRxUhejbuNAfHxpfQRZDhiSZQJCMJBh7R
         36LXPUg+iSCHVi3AQG7YrAzqyJjAqMGWtg1+mimkQ/JmYMwBzr+vSxoF7BgMlUIs1y+D
         976s1oK3CDng8duIgmhzyTAp0q5FFMBkWNSFiA2c9oTvCRMSd+dzZWw/vI38VT8ozjWM
         hKRg==
X-Gm-Message-State: AGi0Pua203dL/rg69gYN0CERX3akPXx5UGTuQ7HtsnUdhtjb/aRTb2WW
        7Qs1kbge3u60K6J4fF5n6Hxv0g==
X-Google-Smtp-Source: APiQypJ2MqLD1wzAwj37A4NOafUppZbd3WmBdViAf9iOB96zmEIoiBieYjr79sJisnNFcSwUnbizZw==
X-Received: by 2002:a17:902:aa4c:: with SMTP id c12mr3130173plr.168.1586274045434;
        Tue, 07 Apr 2020 08:40:45 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id k20sm13389823pgn.62.2020.04.07.08.40.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:40:44 -0700 (PDT)
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited is
 queued
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, peterz@infradead.org
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk> <20200407113927.GB4506@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <147b85ab-12f0-49f7-900a-a1cb0182a3f1@kernel.dk>
Date:   Tue, 7 Apr 2020 08:40:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407113927.GB4506@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 4:39 AM, Oleg Nesterov wrote:
> On 04/06, Jens Axboe wrote:
>>
>> +extern struct callback_head task_work_exited;
>> +
>>  static inline void
>>  init_task_work(struct callback_head *twork, task_work_func_t func)
>>  {
>> @@ -19,7 +21,7 @@ void __task_work_run(void);
>>
>>  static inline bool task_work_pending(void)
>>  {
>> -	return current->task_works;
>> +	return current->task_works && current->task_works != &task_work_exited;
>                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Well, this penalizes all the current users, they can't hit work_exited.
> 
> IIUC, this is needed for the next change which adds task_work_run() into
> io_ring_ctx_wait_and_kill(), right?

Right - so you'd rather I localize that check there instead? Can certainly
do that.

> could you explain how the exiting can call io_ring_ctx_wait_and_kill()
> after it passed exit_task_work() ?

Sure, here's a trace where it happens:


BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: 0010 [#1] SMP
CPU: 51 PID: 7290 Comm: mc_worker Kdump: loaded Not tainted 5.2.9-03696-gf2db01aa1e97 #190
Hardware name: Quanta Leopard ORv2-DDR4/Leopard ORv2-DDR4, BIOS F06_3B17 03/16/2018
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9002721bc78 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff82d10ff0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffc9002721bc60 RDI: ffffffff82d10ff0
RBP: ffff889fd220e8f0 R08: 0000000000000000 R09: ffffffff812f1000
R10: ffff88bfa5fcb100 R11: 0000000000000000 R12: ffff889fd220e200
R13: ffff889fd220e92c R14: ffffffff82d10ff0 R15: 0000000000000000
FS:  00007f03161ff700(0000) GS:ffff88bfff9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 0000000002409004 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __task_work_run+0x66/0xa0
 io_ring_ctx_wait_and_kill+0x14e/0x3c0
 io_uring_release+0x1c/0x20
 __fput+0xaa/0x200
 __task_work_run+0x66/0xa0
 do_exit+0x9cf/0xb40
 do_group_exit+0x3a/0xa0
 get_signal+0x152/0x800
 do_signal+0x36/0x640
 ? __audit_syscall_exit+0x23c/0x290
 exit_to_usermode_loop+0x65/0x100
 do_syscall_64+0xd4/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f77057fe8ce
Code: Bad RIP value.
RSP: 002b:00007f03161f8960 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
RAX: 000000000000002a RBX: 00007f03161f8a30 RCX: 00007f77057fe8ce
RDX: 0000000000004040 RSI: 00007f03161f8a30 RDI: 00000000000057a4
RBP: 00007f03161f8980 R08: 0000000000000000 R09: 00007f03161fb7b8
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000004040 R14: 00007f02dc12bc00 R15: 00007f02dc21b900

-- 
Jens Axboe

