Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A2C3218FB
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 14:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhBVNfK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 08:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhBVNcx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 08:32:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC2EC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 05:32:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id e9so9068227pjj.0
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 05:32:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z+w72aKkxeOdHPhcx33QKBOYbbgiTmhCTrKzAwz5mto=;
        b=SvlZVzA/JRCV8R4IXdwDoK9deESKtOP9NNQXulFAdRXJGCxSYgD5juObBvR91RRUtT
         tcs+428cA/Nt4p4ZXib/32HLOTJ40ttt0RAyMkF4k1S9J2RsutqHdUL/4KhRh49QIXob
         hmrmpU/dQe7ZYRYa6T7aO8M+UvALYS2jUqteYHC2K40S4RpU4gAtBt18uvbrJGrJ7GWs
         aW08h1Q7cWs9Er6DgxA/9keJCK2jhYuwdINH7K5GfrXdsRLBIV8BQSoYpvilnM/28mQu
         ZSY1oy367l/FhaMszF/F2AcF534Oae6/G4w/OOd7W3/5SXNIP5z6BcEMOiOYvl6xGQeV
         NxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z+w72aKkxeOdHPhcx33QKBOYbbgiTmhCTrKzAwz5mto=;
        b=h7k4EvkQmLPitgMGYzR6DRqjN4g/EQC/lEFOwo4A9cvFoY8U1Fan58xbECycZByDBo
         vWFQkvoaFVRpFjtKEiZDW+PJFOTT94hwQkUts4oz+Iq7bfs0p3fmwVtTyvSvrWMvjIBR
         dyXBqkEHXQ1W8NnxHN0h42d+aXGmx2kbRb+lceoB3OAcFUaIW7QMge6DZA+PBmkdgYYG
         OnIlKfnp8j7DNkpLZDZ431VZ74f2UTXMn/MWmRp7CE62scKnSYqANpJcSKOmU5SgwZVM
         9/KSepmmBbUPOfTNXwPjPnWZ/DJ3Ofu+NUYLEc8FAiVslLmBRwe8M4SpKw0MShlGgMr9
         MMYg==
X-Gm-Message-State: AOAM533Gu1okxgsLWCEv8CKfxaqUqKEM8+8xMuLC5rBLIWXkLaQcb6mG
        3rcZIDkLEsYTymMjuu4O+4HT5FCO7ovGXQ==
X-Google-Smtp-Source: ABdhPJxgJeBksGn3OvwZVSZITAkcV4NH7dCjEnNvwIn+ygRASsH6sjuRJceDCXqW8yaWmzHCY2uCiw==
X-Received: by 2002:a17:902:b688:b029:dc:240a:2bd7 with SMTP id c8-20020a170902b688b02900dc240a2bd7mr21930145pls.50.1614000728836;
        Mon, 22 Feb 2021 05:32:08 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k6sm19001950pgk.36.2021.02.22.05.32.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 05:32:07 -0800 (PST)
Subject: Re: [PATCH] io_uring: double freeing req caches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     syzbot+30b4936dcdb3aafa4fb4@syzkaller.appspotmail.com
References: <756158e9db165fcb380f1f60c347b1d70bc65491.1613994305.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e595143d-f6c1-f1f7-6fb1-1911462aee62@kernel.dk>
Date:   Mon, 22 Feb 2021 06:32:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <756158e9db165fcb380f1f60c347b1d70bc65491.1613994305.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/21 4:45 AM, Pavel Begunkov wrote:
> BUG: KASAN: double-free or invalid-free in io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
> 
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  [...]
>  __cache_free mm/slab.c:3424 [inline]
>  kmem_cache_free_bulk+0x4b/0x1b0 mm/slab.c:3744
>  io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
>  io_ring_ctx_free fs/io_uring.c:8764 [inline]
>  io_ring_exit_work+0x518/0x6b0 fs/io_uring.c:8846
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> Freed by task 11900:
>  [...]
>  kmem_cache_free_bulk+0x4b/0x1b0 mm/slab.c:3744
>  io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
>  io_uring_flush+0x483/0x6e0 fs/io_uring.c:9237
>  filp_close+0xb4/0x170 fs/open.c:1286
>  close_files fs/file.c:403 [inline]
>  put_files_struct fs/file.c:418 [inline]
>  put_files_struct+0x1d0/0x350 fs/file.c:415
>  exit_files+0x7e/0xa0 fs/file.c:435
>  do_exit+0xc27/0x2ae0 kernel/exit.c:820
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  [...]
> 
> io_req_caches_free() doesn't zero submit_state->free_reqs, so io_uring
> considers just freed requests to be good and sound and will reuse or
> double free them. Zero the counter.

Oops indeed, thanks! Applied.

-- 
Jens Axboe

