Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E2B2590CF
	for <lists+io-uring@lfdr.de>; Tue,  1 Sep 2020 16:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgIAOif (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 10:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgIAOR6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 10:17:58 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFA4C06125E
        for <io-uring@vger.kernel.org>; Tue,  1 Sep 2020 07:17:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q3so593050pls.11
        for <io-uring@vger.kernel.org>; Tue, 01 Sep 2020 07:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KeS8GKVJq4T+CUgWiidHvzznWbWtkMB2WevyIbiUS5I=;
        b=XLzONATGaZUk6RmUTMF0GqUspbosIonDxdLp5n7lUSWgIaD9z1FySY8zCcjgDgdO9c
         UfwDEOX20gSkEu9ogQk1AmBfwiYDZAMyTtT+OQwliywIdq0yzqV5xju1jDq8CypTR7er
         AcudE8BiwbZkuQsOze0xqL/NtoOQdF5TsCWkedgUUBmTzuyg+2CZrBvq7hkqKwQVvtWZ
         mhkPySDERdy15+hmLSDJMq0rV3bsG+0B+YBokrPl2XrFYDExJFQrB3umYTmJPnKTIwJp
         15CukajAo9d9+K+gzOSNhPvM1zW6CcXg0x5QhowwfWHJR8hE1n9+0MQfFCi+HslBbPvJ
         ysrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KeS8GKVJq4T+CUgWiidHvzznWbWtkMB2WevyIbiUS5I=;
        b=HBU0snYB7ZRfXumdITaFnvJ91s54btqm0Pu6tFGCddb6TetL+dm5l1IRXjfsMWzOGu
         3FVw9LPKykN9V1UdFLxk49IkzfnktMWR62DUtatkOZVH5vI8aH0ZKqei1tMjr5pTCAG0
         zlUzzbJgTcWq5/qHbWfag8L3KPOppRVJMXquOYP6h6ue1WAwSdxhT2Wit+KW1TKinuRC
         geb/xjqkNQcbLjndwJQUcrYPgbVokDvaOrTULBHASbJL+Ok4D4rSu5Sr8hYO7hQzUpHg
         eiUUYa7fopHR04lHCSAIWrgPVP+YFJu+0bgNn/9Ix2lGofLg46fJzChPaoIiBcdLGyV4
         3EWg==
X-Gm-Message-State: AOAM531LMjnZvVrzI0YO97lAnQxvdNiwcXZbENUYu3FvLs3vqjnxxcBg
        wDTquAIMSaM0CB0r7nWF2/eG9A==
X-Google-Smtp-Source: ABdhPJwTKTTtzYF2fDa2cowvfZektAF3tPSKAyVIQ88mb1mgNFiqoQOXUnIV/DKwOj3wmrEflZZYiA==
X-Received: by 2002:a17:902:ff12:: with SMTP id f18mr560148plj.118.1598969875941;
        Tue, 01 Sep 2020 07:17:55 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c8sm2041855pfc.203.2020.09.01.07.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 07:17:55 -0700 (PDT)
Subject: Re: [PATCH v2] io_wq: Make io_wqe::lock a raw_spinlock_t
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     peterz@infradead.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
 <20200819131507.GC2674@hirez.programming.kicks-ass.net>
 <f26205ac-9da9-253e-ea43-db2417714a94@kernel.dk>
 <20200819194443.eabkhlkocvkgifyh@linutronix.de>
 <20200901084146.4ttqrom2avcoatea@linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dd494f20-40d3-1abd-697b-f69d3edbb406@kernel.dk>
Date:   Tue, 1 Sep 2020 08:17:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901084146.4ttqrom2avcoatea@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/20 2:41 AM, Sebastian Andrzej Siewior wrote:
> During a context switch the scheduler invokes wq_worker_sleeping() with
> disabled preemption. Disabling preemption is needed because it protects
> access to `worker->sleeping'. As an optimisation it avoids invoking
> schedule() within the schedule path as part of possible wake up (thus
> preempt_enable_no_resched() afterwards).
> 
> The io-wq has been added to the mix in the same section with disabled
> preemption. This breaks on PREEMPT_RT because io_wq_worker_sleeping()
> acquires a spinlock_t. Also within the schedule() the spinlock_t must be
> acquired after tsk_is_pi_blocked() otherwise it will block on the
> sleeping lock again while scheduling out.
> 
> While playing with `io_uring-bench' I didn't notice a significant
> latency spike after converting io_wqe::lock to a raw_spinlock_t. The
> latency was more or less the same.
> 
> In order to keep the spinlock_t it would have to be moved after the
> tsk_is_pi_blocked() check which would introduce a branch instruction
> into the hot path.
> 
> The lock is used to maintain the `work_list' and wakes one task up at
> most.
> Should io_wqe_cancel_pending_work() cause latency spikes, while
> searching for a specific item, then it would need to drop the lock
> during iterations.
> revert_creds() is also invoked under the lock. According to debug
> cred::non_rcu is 0. Otherwise it should be moved outside of the locked
> section because put_cred_rcu()->free_uid() acquires a sleeping lock.
> 
> Convert io_wqe::lock to a raw_spinlock_t.c

Thanks, I've applied this for 5.10.

-- 
Jens Axboe

