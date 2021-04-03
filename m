Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0526353215
	for <lists+io-uring@lfdr.de>; Sat,  3 Apr 2021 04:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbhDCCT7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 22:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhDCCT6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 22:19:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A03C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 19:19:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id o2so3229898plg.1
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 19:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IJ4JiQ0O+iCT/UvlKUACXmGtug149JhChGDGN7Fax9U=;
        b=mvNpGdtw0cuzy1k1SkTz5uX7nOEX49EhoLxFT1fJmnGt6SzWCA3Dg8MCicPErc0z5V
         FWy10+iuOwozt22BlGPAR5HETopk8srXfRW5T3anDHDlmd11QE4doOYbjN0JTNV91vHU
         /e07wCZRjQczjbdGJ2uP5spI4T5cih7ov7Ygxb6AE+Q84YXWGsb71kUVfKrKirLkXdbu
         r9j/BLs9AssHwPhiH/bHrkjG328G0bLT7le4SJpdLgp6fe395eAW/5LJE794R/VdBqyo
         0MvfVURDx6pZ8RrjbGfDeHYITugNAoy4WjY5nUzm5f4IIZP6nwfa7PDl9YCUqsfU9Vlw
         ItTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IJ4JiQ0O+iCT/UvlKUACXmGtug149JhChGDGN7Fax9U=;
        b=jT61pgRWsnkWrkNWy4+Ku7dCq0DIpBv8v/icr8Pm4X1TZnU79Ujm5tkNLplBT4mKw+
         2j5YLpIRsbDDcab3V71BuKCmJmVO+ozzZCXB0Rgt7CsXP61oGjUVw5jsblrMQ1t+B8qa
         K9jmIWRtgBJflt2PzHOQKr2YBcdPF8CKoZ9TRKXfgpr0EcbXGMvzXQHFFE1xR4FGHDgi
         ELGzigSi1YgMH9EFy/5uoAcfPuZmK7AkbaEwkoJbMCwr4ER62MtZCAqLmVyYQxTesHXi
         /bR28WSQK1h9k9WdpW3XunfJNN8lXDAfoDMNHXlQcWyb/8mcTsvrrN8bKAseevIZn5Ql
         SpzQ==
X-Gm-Message-State: AOAM533msGX5kVCOXn0juGcGkXNAOHDV2GQKLYab/gcNHz5NzP3aEoij
        fnu3K0g3izqy8UHWDalliFm7eK/Lyuf7kw==
X-Google-Smtp-Source: ABdhPJzjvu4W9L8diM0O0y2OzMgbSjMo5Q4uHmXLT2e6NztEuqDVj/dSOrT47GnEdJFDTU9ayLXzyA==
X-Received: by 2002:a17:90a:be07:: with SMTP id a7mr16529961pjs.12.1617416395793;
        Fri, 02 Apr 2021 19:19:55 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y66sm9108136pgb.78.2021.04.02.19.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 19:19:55 -0700 (PDT)
Subject: Re: [RFC 5.12] io-wq: cancel unbounded works on io-wq destroy
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <932defeefef1b025b22f69f7f420f162460eb842.1617382191.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b9d6abfa-b75d-311b-2a01-fe410f33a7fa@kernel.dk>
Date:   Fri, 2 Apr 2021 20:19:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <932defeefef1b025b22f69f7f420f162460eb842.1617382191.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/2/21 10:52 AM, Pavel Begunkov wrote:
> [  491.222908] INFO: task thread-exit:2490 blocked for more than 122 seconds.
> [  491.222957] Call Trace:
> [  491.222967]  __schedule+0x36b/0x950
> [  491.222985]  schedule+0x68/0xe0
> [  491.222994]  schedule_timeout+0x209/0x2a0
> [  491.223003]  ? tlb_flush_mmu+0x28/0x140
> [  491.223013]  wait_for_completion+0x8b/0xf0
> [  491.223023]  io_wq_destroy_manager+0x24/0x60
> [  491.223037]  io_wq_put_and_exit+0x18/0x30
> [  491.223045]  io_uring_clean_tctx+0x76/0xa0
> [  491.223061]  __io_uring_files_cancel+0x1b9/0x2e0
> [  491.223068]  ? blk_finish_plug+0x26/0x40
> [  491.223085]  do_exit+0xc0/0xb40
> [  491.223099]  ? syscall_trace_enter.isra.0+0x1a1/0x1e0
> [  491.223109]  __x64_sys_exit+0x1b/0x20
> [  491.223117]  do_syscall_64+0x38/0x50
> [  491.223131]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  491.223177] INFO: task iou-mgr-2490:2491 blocked for more than 122 seconds.
> [  491.223194] Call Trace:
> [  491.223198]  __schedule+0x36b/0x950
> [  491.223206]  ? pick_next_task_fair+0xcf/0x3e0
> [  491.223218]  schedule+0x68/0xe0
> [  491.223225]  schedule_timeout+0x209/0x2a0
> [  491.223236]  wait_for_completion+0x8b/0xf0
> [  491.223246]  io_wq_manager+0xf1/0x1d0
> [  491.223255]  ? recalc_sigpending+0x1c/0x60
> [  491.223265]  ? io_wq_cpu_online+0x40/0x40
> [  491.223272]  ret_from_fork+0x22/0x30
> 
> Cancel all unbound works on exit, otherwise do_exit() ->
> io_uring_files_cancel() may wait for io-wq destruction for long, e.g.
> until somewhat sends a SIGKILL.
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Not quite happy about it as it cancels pipes and sockets, but
> is probably better than waiting.

I don't think there's any other way, if it's not bounded execution,
we have to cancel it. The same thing would happen these requests
if they were not punted async. It's either this, or "re-parenting"
the requests, if the exiting task is part of a ring that belongs
to a parent.

-- 
Jens Axboe

