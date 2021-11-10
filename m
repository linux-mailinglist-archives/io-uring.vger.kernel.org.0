Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A3744C53D
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhKJQpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 11:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhKJQpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 11:45:12 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3653CC061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 08:42:24 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id z200so2794499wmc.1
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 08:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=bS6QL2D4r1EYrgDBPKoVyVXJi/NzfDehlVzwBsLltG8=;
        b=e//+jhOy01tcpvTLiLm0jcoyBDnMVDnqnBjsT85sR3YM9YdKYsrcX1+K4JeZL1eFKE
         ceYpFGZJnQxFBInkByQ/mM3k9Fq5Fp+AOyrrnkkGFlvGoPHihtgzPEr8o03HR2keeUU3
         ++7zWkPqUs5pFWB4ZkXPk47ZxAKHv/3tltlLszKT53zam1fSFxaH1e0yenfRmREMe4V3
         yoTwviSb8/GsBY3CCN8qDYRPJB0qTiXZ+Ru/PYqsSL3VxzYE0pQ/n6zjyGVkM2/M0erE
         XRfHmkkt5b8SMeYclluDNnbFhHRwIhjanT6TWVh+h52OKzN9DpEfDEh6XaVUlGkG4DM3
         ZfoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bS6QL2D4r1EYrgDBPKoVyVXJi/NzfDehlVzwBsLltG8=;
        b=nmNAvNDgxfPy+9yWr1DBVpYzd2ja8WFCTSS+TzF7vyDqSIh2fE/7NIExRx9npsKLD+
         gKOqFJTpQP+JLDPIeLMPL+Y674u/pAvb09o/U9idwiGYEAtC9/jMCqZAoMSQFnl6Kt1c
         CWRwrvBUHhAXFfWBkYEdadWeUdGpmNsVcncSr3yVwJWiOcUqYjo8Es9uvNXqWQt7ivDI
         3whbIuGnl+/Pbp21c3c5OB5ntLNp1Ur+BNjSqhLgHuVhxi8EWv4LVbtiMMd6o10O9VYY
         SFMl/YWCTglbakcj3EL4k8JaJL41KABBTTU1D6LyfVseWwRp5JcA793iODwVw5sFy+fj
         6ksw==
X-Gm-Message-State: AOAM5339hTgwpQejxB5GmK5d9oEPH5mXvzkx5Z+l5t9gPO69c6RbBgrd
        BOwUi67wnH9icJHb4ojRruhTqpN2keI=
X-Google-Smtp-Source: ABdhPJxC85ljbQFIkSA5/QMYKyUAc/TI4dCEcn84KPRpFdn1NXDqRa/WvcKoGDIoa680GCti+PG7OQ==
X-Received: by 2002:a05:600c:294c:: with SMTP id n12mr550000wmd.71.1636562542851;
        Wed, 10 Nov 2021 08:42:22 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.183])
        by smtp.gmail.com with ESMTPSA id f8sm6887055wmf.2.2021.11.10.08.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 08:42:22 -0800 (PST)
Message-ID: <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
Date:   Wed, 10 Nov 2021 16:42:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/10/21 16:14, Jens Axboe wrote:
> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>> It's expensive enough to post an CQE, and there are other
>> reasons to want to ignore them, e.g. for link handling and
>> it may just be more convenient for the userspace.
>>
>> Try to cover most of the use cases with one flag. The overhead
>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>> requests and a bit bloated req_set_fail(), should be bearable.
> 
> I like the idea, one thing I'm struggling with is I think a normal use
> case of this would be fast IO where we still need to know if a
> completion event has happened, we just don't need to know the details of
> it since we already know what those details would be if it ends up in
> success.
> 
> How about having a skip counter? That would supposedly also allow drain
> to work, and it could be mapped with the other cq parts to allow the app
> to see it as well.

It doesn't go through expensive io_cqring_ev_posted(), so the userspace
can't really wait on it. It can do some linking tricks to alleviate that,
but I don't see any new capabilities from the current approach.

Also the locking is a problem, I was thinking about it, mainly hoping
that I can adjust cq_extra and leave draining, but it didn't appear
great to me. AFAIK, it's either an atomic, beating the purpose of the
thing.

Another option is to split it in two, one counter is kept under
->uring_lock and another under ->completion_lock. But it'll be messy,
shifting flushing part of draining to a work-queue for mutex locking,
adding yet another bunch of counters that hard to maintain and so.

And __io_submit_flush_completions() would also need to go through
the request list one extra time to do the accounting, wouldn't
want to grow massively inlined io_req_complete_state().

-- 
Pavel Begunkov
