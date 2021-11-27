Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4BB645FEEA
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhK0Nuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 08:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354963AbhK0Nsc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 08:48:32 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CD0C061746
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:45:17 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id s11so4738303ilv.3
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 05:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rKneMjBOvS+P00oj3sggoRg13Lqf4qE6aDU5pd1JxPk=;
        b=0VPEn08TiGj43BmTMmfvPnDDbf6VNHidyhvKexhWE6VLHcZILjAsZgUoeIQO5ScA0e
         fpA2j8zlyZrNKbKtLZ1dMutIVroByZEfQiAN/78PlyscCknaoAuIFtCmrTpI9CrBJxyE
         eZ2O5rIYlSQvPFZI6bcQCFNTJbrtTG/mc9VjDj7GJ8C4O/+hneeDZ0k5cRz0r8x1odcW
         xpbf7mEZNeq+50zsC07P6Nf98WJgjqWhFN0LcZCBF5w1sDxQykl9LyB3oShSltV5JTW0
         Z/YXJZJiDxKL9gUtC0UAlv3TkKNq/rtqNAaslfr7MzjHNMW02UPSJ9Pq1ATY56vfftXs
         EWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rKneMjBOvS+P00oj3sggoRg13Lqf4qE6aDU5pd1JxPk=;
        b=CFUoNJ8U7mmjTGsBzWoUDP3w5RduMPeVCdGJi2Zog9g+utARZFbvec60ZW4jmtUctD
         bqawldgHYosShd1wh1yEDmW9IRwK1Ntuok4zm8GkWlzER2kkehMnIJ2tohF1AhvvdR8P
         rduX1pli/mvQqfiB1/r+CYGigxIjB6rgdzpegbpg417qATNwXViRWROXUSjlRI4YdDfz
         9CZI6LoTMhXlIpwDvh9cF4dIlP9dSCuJLAJWepl3nCmrIDfe6SLZcy9DwSUDr3+SZohi
         vedeOsQ8x+Yf7uoEBOpGQWvIq6VZL6S1WSqXUgzreiue0hu+8eT8PFl+6j8r06oZiqzS
         Bb9w==
X-Gm-Message-State: AOAM531LpAMt2U9vS6XdsQkVeBQukamDEhGp2NetmPTAAAIb2PmWlvQz
        Bz7Fe2e29OuyvPaAeQN+eeI66Q==
X-Google-Smtp-Source: ABdhPJy/91OEeAjvicfPuz9n4GTU3cpoj0Yi18cWWFstgFlwtwHuxwikK7seT1unVDLk08sNIjGYkw==
X-Received: by 2002:a92:cda6:: with SMTP id g6mr20071115ild.83.1638020717105;
        Sat, 27 Nov 2021 05:45:17 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z6sm6319253ioq.35.2021.11.27.05.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 05:45:16 -0800 (PST)
Subject: Re: [PATCH -next] io_uring: Fix undefined-behaviour in io_issue_sqe
To:     Ye Bin <yebin10@huawei.com>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211118015907.844807-1-yebin10@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d264f41a-2940-f1f8-1371-a24be6f2ad13@kernel.dk>
Date:   Sat, 27 Nov 2021 06:45:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211118015907.844807-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/17/21 6:59 PM, Ye Bin wrote:
> We got issue as follows:
> ================================================================================
> UBSAN: Undefined behaviour in ./include/linux/ktime.h:42:14
> signed integer overflow:
> -4966321760114568020 * 1000000000 cannot be represented in type 'long long int'
> CPU: 1 PID: 2186 Comm: syz-executor.2 Not tainted 4.19.90+ #12
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  dump_backtrace+0x0/0x3f0 arch/arm64/kernel/time.c:78
>  show_stack+0x28/0x38 arch/arm64/kernel/traps.c:158
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x170/0x1dc lib/dump_stack.c:118
>  ubsan_epilogue+0x18/0xb4 lib/ubsan.c:161
>  handle_overflow+0x188/0x1dc lib/ubsan.c:192
>  __ubsan_handle_mul_overflow+0x34/0x44 lib/ubsan.c:213
>  ktime_set include/linux/ktime.h:42 [inline]
>  timespec64_to_ktime include/linux/ktime.h:78 [inline]
>  io_timeout fs/io_uring.c:5153 [inline]
>  io_issue_sqe+0x42c8/0x4550 fs/io_uring.c:5599
>  __io_queue_sqe+0x1b0/0xbc0 fs/io_uring.c:5988
>  io_queue_sqe+0x1ac/0x248 fs/io_uring.c:6067
>  io_submit_sqe fs/io_uring.c:6137 [inline]
>  io_submit_sqes+0xed8/0x1c88 fs/io_uring.c:6331
>  __do_sys_io_uring_enter fs/io_uring.c:8170 [inline]
>  __se_sys_io_uring_enter fs/io_uring.c:8129 [inline]
>  __arm64_sys_io_uring_enter+0x490/0x980 fs/io_uring.c:8129
>  invoke_syscall arch/arm64/kernel/syscall.c:53 [inline]
>  el0_svc_common+0x374/0x570 arch/arm64/kernel/syscall.c:121
>  el0_svc_handler+0x190/0x260 arch/arm64/kernel/syscall.c:190
>  el0_svc+0x10/0x218 arch/arm64/kernel/entry.S:1017
> ================================================================================
> 
> As ktime_set only judge 'secs' if big than KTIME_SEC_MAX, but if we pass
> negative value maybe lead to overflow.
> To address this issue, we must check if 'sec' is negative.
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/io_uring.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f9e720595860..d8a6446a7921 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6157,6 +6157,9 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
>  		return -EFAULT;
>  
> +	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
> +		return -EINVAL;
> +
>  	data->mode = io_translate_timeout_mode(flags);
>  	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);

This seems to only fix one instance of when a timespec is copied in, what
about the ones in io_timeout_remove_prep()?

-- 
Jens Axboe

