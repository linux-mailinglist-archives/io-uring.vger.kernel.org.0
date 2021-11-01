Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDDA441EF8
	for <lists+io-uring@lfdr.de>; Mon,  1 Nov 2021 18:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKARIs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Nov 2021 13:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhKARIs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Nov 2021 13:08:48 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F5CC061714
        for <io-uring@vger.kernel.org>; Mon,  1 Nov 2021 10:06:14 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id l7so19169895iln.8
        for <io-uring@vger.kernel.org>; Mon, 01 Nov 2021 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L2BBY6/WnfxbZZfiEsySKGxKfIcV+7q1Wif5p+eFnKQ=;
        b=nNAXjwUJWD9uH1xTgRZwq38XJc7RTaEC239uFRWTB2T6+Kbzv5i1v7dm4l1LyXOTpm
         0JokvLWhMhIjzx0t8oVkmc8Tn3RIICGrj03qB8tQm9yI8iJujBMrPR+Xq9HfGYxca2Tp
         x70vQr8a0o0+llgz8a5QfFxNwu6NzlH/LKJrzbn1w5FDjnIIvhQRR+gpWYBj2c4ZOOev
         X7OH05mJuvUcnKf2jr4wpLGzpB9dnEdDZmkzQ+opUD71G95e8Ni7cZfadUAFUx/TB4xW
         x4PV9rrQWuDSPJ9U03HBsZQXyGHbbEKH2pp28FmQsyni9E0d9cFSogFFUzlCLmSQIiym
         yG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2BBY6/WnfxbZZfiEsySKGxKfIcV+7q1Wif5p+eFnKQ=;
        b=hrvkgadzk0agI+PNtgCnzBWqT05RQq7Lab2BJhkFxGfTNj0RBT6z54ZLrD3wEFfdu9
         4WUEZvjNsofHug5LjhsF9MuJ/KiM0iL6Mx7wJlL+JeKbCsJwJuyrZ6/nBHiZ8Q9yBmp2
         xwkLTSYWmiFzOOJmilLhF9cK8JbAdiclS6DEG8NrqdLn0kc7IbL+bybM8FsZmWwqDCH+
         F/KB38plM2Ve3LkFDkMTaPsQyLdAjjTEe2tYhwmq5oEXnmtrmmG18nrNgh3fypVB4O8q
         tAG4lYineVb8rNiuoArqki/1LURRDmKUAhZ1T1rQg1OBqVUXI4+i1feS7NE4ChyylRTp
         qJOQ==
X-Gm-Message-State: AOAM5317Fkc8/FgBWH42JDcg2N588d9UVV/lysv68VO8iZtpuwmUN/Ov
        GAJBbfDB1FRU0utckFxxtjYMfAHtLM0MAA==
X-Google-Smtp-Source: ABdhPJxpVl6DCYXIAzwMeM4PL5oXzuPpTEwtyWc63KZkHPKBcmIHQfEk3UkOO4w+Iku/jiCYijZx5A==
X-Received: by 2002:a05:6e02:1d07:: with SMTP id i7mr18480914ila.205.1635786373726;
        Mon, 01 Nov 2021 10:06:13 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x11sm1495911ilu.51.2021.11.01.10.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 10:06:13 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.16-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <c5054513-d496-e15e-91ef-dcdbf9dda2c4@kernel.dk>
 <CAHk-=whuMiJ3LdGZGPsKR+FuM4v4Qz6Xp-dnr7G3QN3Nr24NdA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <726220a3-b0b2-02b5-08e4-e1a355a5afd2@kernel.dk>
Date:   Mon, 1 Nov 2021 11:06:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whuMiJ3LdGZGPsKR+FuM4v4Qz6Xp-dnr7G3QN3Nr24NdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/1/21 10:49 AM, Linus Torvalds wrote:
> On Sun, Oct 31, 2021 at 12:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This will throw two merge conflicts, see below for how I resolved it.
>> There are two spots, one is trivial, and the other needs
>> io_queue_linked_timeout() moved into io_queue_sqe_arm_apoll().
> 
> So I ended up resolving it the same way you did, because that was the
> mindless direct thing.
> 
> But I don't much like it.
> 
> Basically, io_queue_sqe_arm_apoll() now ends up doing
> 
>         case IO_APOLL_READY:
>                 if (linked_timeout) {
>                         io_queue_linked_timeout(linked_timeout);
>                         linked_timeout = NULL;
>                 }
>                 io_req_task_queue(req);
>                 break;
>     ...
>         if (linked_timeout)
>                 io_queue_linked_timeout(linked_timeout);
> 
> and that really seems *completely* pointless. Notice how it does that
> 
>         if (linked_timeout)
>                 io_queue_linked_timeout()
> 
> basically twice, and sets linked_timeout to NULL just to avoid the second one...
> 
> Why isn't it just
> 
>         case IO_APOLL_READY:
>                 io_req_task_queue(req);
>                 break;
>   ...
>         if (linked_timeout)
>                 io_queue_linked_timeout(linked_timeout);
> 
> where the only difference would seem to be the order of operations
> between io_req_task_queue() and io_queue_linked_timeout()?
> 
> Does the order of operations really matter here? As far as I can tell,
> io_req_task_queue() really just queues up work for later, so it's not
> really very ordered wrt that io_queue_linked_timeout(), and in the
> _other_ case statement it's apparently fine to do that
> io_queue_async_work() before the io_queue_linked_timeout()..
> 
> Again - I ended up resolving this the same way you had done, because I
> don't know the exact rules here well enough to do anything else. But
> it _looks_ a bit messy.

Yes I agree, and it's mostly just to keep the resolution simpler as I
don't think the current construct makes too much sense when both of them
end up being queueing the linked timeout. I think the cleanup done here
made more sense in the context before, not now.

We'll get a cleanup done for this shortly.

-- 
Jens Axboe

