Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A573FF2F4
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 20:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbhIBSBe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 14:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346845AbhIBSBe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 14:01:34 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E87C061757
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 11:00:35 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id x5so2718711ill.3
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 11:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RRi6/kL9/FEDjPGtZKu7zb6d6VYXajVwfUuyvAHAAG4=;
        b=kYIwMu1LevdkHbawEkeMi5GOardoiEgFGDF6OdkKJRN4E16HpAYVkTBxJEE83RB4LD
         orioYYIcrNpdjtyXbO8E0OkbH2Zyci+BgY1ApQfqf9HWkYKBVNTRKW5MHhPcvV1lOJoK
         G7V6KKl163jjEN43Waa8yy15zxzA9cV3UvjnKcJxwV+9hD63z0bb6SUBFaVqJQwrqUPv
         ahvmtg4hK/psKaRKXkhRpKuSp2yQydob1Ozg1Y6uiWZkolOEUJgLmQ7k/2L+ruJRMA6M
         BJrzd3/zLrMa6QTRnLPC2cxsHPul03uGiaJc4WCQDswvH8+fa+AfatzLmJbDK7967YdY
         AfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RRi6/kL9/FEDjPGtZKu7zb6d6VYXajVwfUuyvAHAAG4=;
        b=H7MnK3wnGmTCbe2WdyB1PYMoxs1jCag01hV9TkUM2e6k/Jp/jYUiJUMtsyrENQ+7e5
         ToXCUUOrGIqnKDFQnRBN9cDNxFYpi2T+zhTYgbRxxiIGdszltHA0LVeTLmFBB7RpC/SI
         vgYhT2dAWaK2AthwN0dTSGyHalc2L57OXCWrKWKDYQ3G4YnZ9m9yJWgTu146ILJme3zV
         blA5c8ODvmyJl1ciWgbrRJl5PNxPmYwhiVJV7N/W9ujzhFip/3mu2vENBFWUCscg5atm
         VApqH7IKtOpjDxseO1qF1vqKAWzDtux3JxX3ACNKqSITAfhfhl+XwLv2txuZIi/kAhUc
         xu1A==
X-Gm-Message-State: AOAM530uGtVI9D0MURw0pKtKCeTqRVD+Th+qrC5GzTSYvicYULN8XlbP
        bnaXtIjEoaABsMYPP3gGYCuPwQ==
X-Google-Smtp-Source: ABdhPJwTl1K3F52xP43mF6RN35cXO7Wf0Rl0jMS8KzHa9Bq8yBMtzeIZ9liF2tUDrVMSrpBoFD2T2A==
X-Received: by 2002:a92:c6d1:: with SMTP id v17mr3312482ilm.302.1630605634905;
        Thu, 02 Sep 2021 11:00:34 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k21sm1300690ioh.38.2021.09.02.11.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:00:34 -0700 (PDT)
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210902164808.GA10014@blackbody.suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <efd3c387-9c7c-c0d8-1306-f722da2a9ba1@kernel.dk>
Date:   Thu, 2 Sep 2021 12:00:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210902164808.GA10014@blackbody.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 10:48 AM, Michal Koutný wrote:
> Hello Hao.
> 
> On Wed, Sep 01, 2021 at 08:43:20PM +0800, Hao Xu <haoxu@linux.alibaba.com> wrote:
>> This patchset is to enhance sqthread cpu binding logic, we didn't
>> consider cgroup setting before. In container environment, theoretically
>> sqthread is in its container's task group, it shouldn't occupy cpu out
>> of its container.
> 
> I see in the discussions that there's struggle to make
> set_cpus_allowed_ptr() do what's intended under the given constraints.
> 
> IIUC, set_cpus_allowed_ptr() is conventionally used for kernel threads
> [1]. But does the sqthread fall into this category? You want to have it
> _directly_ associated with a container and its cgroups. It looks to me
> more like a userspace thread (from this perspective, not literally). Or
> is there a different intention?

It's an io thread, which is kind of a hybrid - it's a kernel thread in
the sense that it never exits to userspace (ever), but it's a regular
thread in the sense that it's setup like one.

> It seems to me that reusing the sched_setaffinity() (with all its
> checks and race pains/solutions) would be a more universal approach.
> (I don't mean calling sched_setaffinity() directly, some parts would
> need to be factored separately to this end.) WDYT?

We already have this API to set the affinity based on when these were
regular kernel threads, so it needs to work with that too. As such they
are marked PF_NO_SETAFFINITY.

> [1] Not only spending their life in kernel but providing some
> delocalized kernel service.

That's what they do...

-- 
Jens Axboe

