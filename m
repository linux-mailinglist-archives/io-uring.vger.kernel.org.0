Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF5A2C29FB
	for <lists+io-uring@lfdr.de>; Tue, 24 Nov 2020 15:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389253AbgKXOpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 09:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388319AbgKXOpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 09:45:12 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31741C0613D6
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 06:45:11 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so5295679pga.9
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 06:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aX04/fgjZI0ow5+uLP7WW65WQQgC/QsXCZrREB9IGVQ=;
        b=TG9fsPoVdLEYmfpax6i7iYP7jfdNcyriIHK2WDi7V/pWO90Eln1fMATurvuGLlbBaf
         sDlu7ai7qYey6MajCSuMng6ysA7DdeG7xQI6Ma0ABqCktmLJ0ASq5NkKkeSG9216ojia
         y2+C2SwSXc5SQVGtIDo+EuMEtuRyvHdbkpiISuHov2dZUciMk2Llxba5AfKIwm3CoI5F
         1OH5valjKnJC3DWOhHqW2od2UuZNy8ftOHASUCJSqCIsMNoG+SPYfWLTFSzpoWlFRSfR
         shrSwGB7ThsucOP3NLcX2/63BsHWyUFg3Z/Tm5jXBqH4QCxlCdPLSNGJsyejc8jPy2Rk
         gEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aX04/fgjZI0ow5+uLP7WW65WQQgC/QsXCZrREB9IGVQ=;
        b=tjjNsMw4D0/lIdbp7jGkZTfMsVU8rWPROr5OjcVNBL5w9vlQcXJyHc9Q1LabpZaUPI
         ff/4Ggh0Qh9nkJIl/g2iso04xNSOyiyUS/r4Fnlop89M65n0YC8LU+zolgp0kcOu96nR
         ZH/YCYXNLYpeK0I/ql2N/9uTS7gbH8YnLVnxlbHzJXlcnvw2h+r3TRQYYu5P0ubw8tX8
         LTGyCmked7OSdS0RkFno4ufZHxZlNOA2hcPxEzueH4f8tSybX8RWqeCdFq7QcGPUbiu6
         dlpMKKJwg9CH0P2td1Tx6ARUhWnw5scw3F9yQANyLcHcKYXPtbjiGVlgZQG22nzVEHLe
         zrZQ==
X-Gm-Message-State: AOAM530PAyG4IJCKxz4Vw4hDSnhCnaWFKaFz1mwcZcOkSnUVCgM/W60k
        dlG7H1YH8cKmj6G08soQSTd/zOqsbypNFg==
X-Google-Smtp-Source: ABdhPJw88jSU3QKT/ieEN3OFDGBJK+8FgynjM35WbTuGYBQBkDqN+2quOLHL8taKpC03OrLIm2Q0yA==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr5260700pjb.40.1606229110301;
        Tue, 24 Nov 2020 06:45:10 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o29sm8488015pfp.66.2020.11.24.06.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 06:45:09 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix shift-out-of-bounds when round up cq size
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <1606201383-62294-1-git-send-email-joseph.qi@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <effe8264-5ab1-0caa-4999-501396782460@kernel.dk>
Date:   Tue, 24 Nov 2020 07:45:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1606201383-62294-1-git-send-email-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/20 12:03 AM, Joseph Qi wrote:
> Abaci Fuzz reported a shift-out-of-bounds BUG in io_uring_create():
> 
> [ 59.598207] UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
> [ 59.599665] shift exponent 64 is too large for 64-bit type 'long unsigned int'
> [ 59.601230] CPU: 0 PID: 963 Comm: a.out Not tainted 5.10.0-rc4+ #3
> [ 59.602502] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [ 59.603673] Call Trace:
> [ 59.604286] dump_stack+0x107/0x163
> [ 59.605237] ubsan_epilogue+0xb/0x5a
> [ 59.606094] __ubsan_handle_shift_out_of_bounds.cold+0xb2/0x20e
> [ 59.607335] ? lock_downgrade+0x6c0/0x6c0
> [ 59.608182] ? rcu_read_lock_sched_held+0xaf/0xe0
> [ 59.609166] io_uring_create.cold+0x99/0x149
> [ 59.610114] io_uring_setup+0xd6/0x140
> [ 59.610975] ? io_uring_create+0x2510/0x2510
> [ 59.611945] ? lockdep_hardirqs_on_prepare+0x286/0x400
> [ 59.613007] ? syscall_enter_from_user_mode+0x27/0x80
> [ 59.614038] ? trace_hardirqs_on+0x5b/0x180
> [ 59.615056] do_syscall_64+0x2d/0x40
> [ 59.615940] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 59.617007] RIP: 0033:0x7f2bb8a0b239
> 
> This is caused by roundup_pow_of_two() if the input entries larger
> enough, e.g. 2^32-1. For sq_entries, it will check first and we allow
> at most IORING_MAX_ENTRIES, so it is okay. But for cq_entries, we do
> round up first, that may overflow and truncate it to 0, which is not
> the expected behavior. So check the cq size first and then do round up.

Applied, thanks.

-- 
Jens Axboe

