Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D293E5C3F
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242008AbhHJNx3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 09:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241985AbhHJNx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 09:53:29 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3EAC0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:53:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z3so21057591plg.8
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3BaQG7uNacgdVp+drfazKFG6Tgy96a7rOj8pZqTgzhc=;
        b=1Mo+/RZNvWDNjdmXd/QIeKdpWn2FxSb6ryjjbIgaCAWijH40jFBZFekGmZR5+o21M+
         qWvwrD/880UDQMbVaRs0RPvBwoH30kOJNLxqepJ+lUgMPrvew2CwoLtZyl1fLnz+S3po
         0dAw9d3Ec+voR0Z/iRPbXgzcqVSbz8cL4g5g++XJT8vfI0WLB8unYSNilVbKJ7vrATWC
         K/UX22DEJGLT3qGdkp9U5UGMNFnMSMBzIeUFNm2pX5rI+c8WU/r6vuerGI8FlGfAkbGz
         yZc0tUKv4sGpNusWP1tjflcoxmcPxydV4avKEHYBoP0uhZsapSXkP0n6gGPDSUy4Tx3R
         povQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3BaQG7uNacgdVp+drfazKFG6Tgy96a7rOj8pZqTgzhc=;
        b=Kjlg14j1E+AZZfutlGSphdt8u74wC5Mh+k7b00v+rNd9xZNENm96cfxYyMk7ZxfPyk
         vD8yXjOD9j1AdH5U5pY7erjfVDHuzRTpXXUXe+0r0DbQ5yJL/C6Dik9/oRx96g4hNy+f
         01aBlJ9qbSm2NBVmKMfr9QHfVdBYBLj3OHTzWY4J3lP9F4GJiJgVOGDkDAS4HEEwtEdO
         avAbidC0AWa7A1v/S2LMxJyic2buoKSFY60l12WfQ2gcPyulX4QBNXqOu5FI3qDZhek0
         aORAbTUMX8eT8VBzgHI3YcclgvSzl+BlPIi5k1C/LkrlLvqlXwB+srpaHD0rko46x6lx
         8v7A==
X-Gm-Message-State: AOAM531/I8wJbC8vt5WkFWY1IxN+UQEHtsvHccN5c4iYA8Fub4HD8uMt
        ZilfAc1Vq4qRi9Q07I1Ytlvf3g==
X-Google-Smtp-Source: ABdhPJz+dgHKaPdfvp762hdQb6DzhTCzglW6Zw6wa8i3RPOE2gY86BPWyxP7sR1SB7oWb+b/FxRkAg==
X-Received: by 2002:a17:902:7786:b029:12c:dac0:15ba with SMTP id o6-20020a1709027786b029012cdac015bamr25309235pll.27.1628603586628;
        Tue, 10 Aug 2021 06:53:06 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id y20sm10985632pfb.54.2021.08.10.06.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:53:06 -0700 (PDT)
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-2-axboe@kernel.dk> <YRJ74uUkGfXjR52l@T590>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk>
Date:   Tue, 10 Aug 2021 07:53:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRJ74uUkGfXjR52l@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 7:15 AM, Ming Lei wrote:
> Hi Jens,
> 
> On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
>> Add a set of helpers that can encapsulate bio allocations, reusing them
>> as needed. Caller must provide the necessary locking, if any is needed.
>> The primary intended use case is polled IO from io_uring, which will not
>> need any external locking.
>>
>> Very simple - keeps a count of bio's in the cache, and maintains a max
>> of 512 with a slack of 64. If we get above max + slack, we drop slack
>> number of bio's.
>>
>> The cache is intended to be per-task, and the user will need to supply
>> the storage for it. As io_uring will be the only user right now, provide
>> a hook that returns the cache there. Stub it out as NULL initially.
> 
> Is it possible for user space to submit & poll IO from different io_uring
> tasks?
> 
> Then one bio may be allocated from bio cache of the submission task, and
> freed to cache of the poll task?

Yes that is possible, and yes that would not benefit from this cache
at all. The previous version would work just fine with that, as the
cache is just under the ring lock and hence you can share it between
tasks.

I wonder if the niftier solution here is to retain the cache in the
ring still, yet have the pointer be per-task. So basically the setup
that this version does, except we store the cache itself in the ring.
I'll give that a whirl, should be a minor change, and it'll work per
ring instead then like before.

-- 
Jens Axboe

