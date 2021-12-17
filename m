Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107CB47953E
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 21:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhLQULK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 15:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhLQULJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 15:11:09 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F923C061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 12:11:09 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p65so4630749iof.3
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 12:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tGfDXOwtEOHSdnxDYvLn//dkRj1Ys4fg+t1OZXgviII=;
        b=26OBkVSJzt3rEIKd/RXb2mD1XoS4DCjYTGqsMkIdBhNxBGVH32eyv9lSGOY4KbBoES
         LVhxY6zPfNOVzBc8e7zp265bWlaAjMIhI6bNrBOXMmRemPmDX8SMJSfOk7JTjBYm9SXC
         uFWYQac8Jy59fIrqFDo+GRhy3EIFOF+HIclCHwuRYMBxfg50udHXxE7qHhZzEqMX4lnt
         NlQkLjNJUN4DgNAEXDvKHYoS68XMlgdbEE/XWFUOiNGwwiLR3Dp5unrzsDqE6vS7UNNV
         M3YhrZtF40MtwKaJbZVmmHLUIqw8LyxHb3C75F5vz/SS1d6TzDiDQ+LH4cAUyT7+u8l7
         1FoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tGfDXOwtEOHSdnxDYvLn//dkRj1Ys4fg+t1OZXgviII=;
        b=ywlqGTt3DzrUb3kV60lR4U5+zWnOl+mtUk3d11cgJoKZqOSe44ToE6ib0TjZaGOARJ
         U6Is2nFh9fVHghAuY8xjT6yjEs7gCpgo50k4ZatkIZz2KQtoO3e2G2zJjcsO8PR00gB6
         RfGB0xw++ehcZRE2yzhDDP2ju3PdLgNY3Pd0oJuBYftAZvad+Sb4vC8FAGshbpZqSU8A
         aHAXWB932zvmAgBwdQAy2C0HqIjOrFeuwOB95gcrYg5zYrjHRbV7+lR3H3uqb4HsQsw+
         4ATtxRFMJUVZxvOdLXNqSKGdFpyiO7pJDlA7eeY8Ra2KbmyH6fK95pFr6McPvFCLdYKW
         NFUA==
X-Gm-Message-State: AOAM532DMSDSyPZ6jXmyvDrZDinqHOUAOOghf65RmdIr0ZZpulFVVH2+
        Tz1ZrT+gepLCyLlZ2GeQ0EMc3LRrKrRSHw==
X-Google-Smtp-Source: ABdhPJzt6nRybjSZ1VKwdZ6ptNpDXkDOsRt+He5rqEbsNwmDJEYtRvLsc9GeJjRZqEVEYTV1+P3yXg==
X-Received: by 2002:a05:6638:dc3:: with SMTP id m3mr2977469jaj.304.1639771867282;
        Fri, 17 Dec 2021 12:11:07 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n11sm5466997ili.33.2021.12.17.12.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 12:11:06 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a6bc93c-df75-d47e-e90e-e90a87e48a56@kernel.dk>
 <CAHk-=wgFYF+W7QZ1KW3u-uFU=rC0jbyUFZBzCVX1-SH9-qe16w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ac64e80-b686-6191-33f0-11a18c0ac295@kernel.dk>
Date:   Fri, 17 Dec 2021 13:11:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgFYF+W7QZ1KW3u-uFU=rC0jbyUFZBzCVX1-SH9-qe16w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/21 12:45 PM, Linus Torvalds wrote:
> On Fri, Dec 17, 2021 at 9:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Just a single fix, fixing an issue with the worker creation change that
>> was merged last week.
> 
> Hmm. I've pulled, but looking at the result, this is a classic no-no.
> 
> You can't just randomly drop and re-take a lock and sat it's "safe".
> 
> Because I don't think it's necessarily safe at all.
> 
> When you drop the wqe->lock in the middle of io_wqe_dec_running to
> create a new worker, it means - for example - that "io_worker_exit()"
> can now run immediately on the new worker as far as I can tell.
> 
> So one io_worker_exit() m,ay literally race with another one, where
> both are inside that io_wqe_dec_running() at the same time. And then
> they both end up doing
> 
>         worker->flags = 0;
>         current->flags &= ~PF_IO_WORKER;
> 
> afterwards in the caller, and not necessarily in the original order.
> And then they'll both possible do
> 
>         kfree_rcu(worker, rcu);
> 
> which sounds like a disaster.

The worker itself calls io_worker_exit(), so it cannot happen from
within io_wqe_dec_running for the existing one. And that's really all
we care about. The new worker can come and go and we don't really
care about it, we know we're within another worker.

That said, I totally do agree that this pattern is not a great one
and should be avoided if at all possible. This one should be solvable by
passing back a "do the cancel" information from
io_queue_worker_create(), but that also gets a bit ugly in terms of
having three return types essentially...

I'll have a think about how to do this in a saner fashion that's more
obviously correct.

-- 
Jens Axboe

