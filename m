Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8417F30F562
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbhBDOu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 09:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbhBDOuD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 09:50:03 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7F5C061573
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 06:49:21 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id q9so2818589ilo.1
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 06:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aBYjUxLr0F7kODE1s9iOfl2P536CgMiPacyTkR0loyU=;
        b=N3dYk1cqFSJI5XafD1RW61n/5ZJS0KaO7cUuZXELXAomSzvAbAJNQ2AgMwv9w8OZN7
         vO4RFJgxvdOqkjwr4r4FSYsQ8fxrRHKDQ1fQjPESNMva7wE4waw3iBoET5/xZsVEF80b
         ybpaCKeHuIFumhePZX6CXJ0N45Epdrptv0FwRg5LJum7cEmz3I3ZLQthyvgI/msUIE/D
         fU/lw3pyFKaINDI4KiIyt8pFfZipMU3/AfbpDJ9k2/j2ICyNCVqmWuvHiSN5KyM16Gg8
         J7IOFAYK6bgtdcnYjz6t7LX4L11dsbcFANBxbiNoBWTvSrrM8Yqf40gxZhCHEik2iKAb
         4P3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBYjUxLr0F7kODE1s9iOfl2P536CgMiPacyTkR0loyU=;
        b=Uh2PesPaV38LTOGzKwPxD8ld352OYC9c7IPNm4yElDrO4g19O27fEIInZqVPxZP1ha
         OcFxkJmSzxCnMIIhIqcpgJSkmVMem+X1cnZCxEX1VFO1WB5OSCMRjZEDTJQPbDMuVnPT
         cCZqljIPDKzqMwj4FLJbZnh6679FSGeDNQtyk6KqQe5YtGF0VxBlOLw2dsXBc6wTcHLo
         L/F8HvGu3SuTGB4wtpKx+7Gl+p3UK+5hHpsFE7szICGVMfTwI6oyqo4Sgvk8iczBIxtI
         5e7r0iFCs4ov6YMpyi+2POK4teqIU1V2TR+Pk2cCcP7/sugCi/5X31sVrzBGXD4b5EhU
         qRtQ==
X-Gm-Message-State: AOAM531LUhiVFevCr9qZWGgGJkvDWkx5pMpxCxJJogzy03oChCw+9QAt
        D/3vzzS48+bO8nY5ofr9vw5vLw==
X-Google-Smtp-Source: ABdhPJzId/jyjt4HS62R05ih06vWg9N6/BobG8XVVpuO9TNrlys66mX/0eqNYM0Fjx0ywaG07YEReA==
X-Received: by 2002:a05:6e02:1544:: with SMTP id j4mr7065110ilu.67.1612450161091;
        Thu, 04 Feb 2021 06:49:21 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t7sm2697167ilg.9.2021.02.04.06.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 06:49:20 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: add uring_lock as an argument to
 io_sqe_files_unregister()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612364276-26847-1-git-send-email-haoxu@linux.alibaba.com>
 <1612364276-26847-2-git-send-email-haoxu@linux.alibaba.com>
 <976179ed-6013-3cd7-46a0-aa3201444ac4@gmail.com>
 <a6827c98-c4f6-a0fd-6453-1351c654c3a5@linux.alibaba.com>
 <9792fbbb-fa88-a276-9a4a-42fed4426424@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5694f44b-767f-4d42-962a-0953af98b6c3@kernel.dk>
Date:   Thu, 4 Feb 2021 07:49:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9792fbbb-fa88-a276-9a4a-42fed4426424@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/4/21 4:11 AM, Pavel Begunkov wrote:
> On 04/02/2021 03:34, Hao Xu wrote:
>> 在 2021/2/4 上午12:33, Pavel Begunkov 写道:
>>> On 03/02/2021 14:57, Hao Xu wrote:
>>>> io_sqe_files_unregister is currently called from several places:
>>>>      - syscall io_uring_register (with uring_lock)
>>>>      - io_ring_ctx_wait_and_kill() (without uring_lock)
>>>>
>>>> There is a AA type deadlock in io_sqe_files_unregister(), thus we need
>>>> to know if we hold uring_lock in io_sqe_files_unregister() to fix the
>>>> issue.
>>>
>>> It's ugly, just take the lock and kill the patch. There can't be any
>>> contention during io_ring_ctx_free anyway.
>> Hi Pavel, I don't get it, do you mean this patch isn't needed, and we can just unlock(&uring_lock) before io_run_task_work_sig() and lock(&uring_lock) after it? I knew there won't be contention during io_ring_ctx_free that's why there is no uring_lock in it.
>> I tried to just do unlock(&uring_lock) before io_run_task_sig() without if(locked) check, it reports something like "there are unpaired mutex lock/unlock" since we cannot just unlock if it's from io_ring_ctx_free.
> 
> 
> The ugly part is @locked. I know that there is already similar stuff
> around, but I may go long why and how much I don't like it.
> 
> io_ring_ctx_free()
> {
>     ...
>     lock(uring_lock);
>     files_unregister();
>     unlock(uring_lock);
>     ...
> }
> 
> With this you'll always have the mutex locked in unregister, so
> can drop it unconditionally (if that will ever be needed). It's
> also cleaner from the synchronisation perspective.

Yes that's a much better approach - passing around a 'locked' flag
is not very pretty, and the fewer we have of those the better.

-- 
Jens Axboe

