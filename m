Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB293E5DE2
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbhHJO2a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 10:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239783AbhHJO22 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 10:28:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BA8C0619E4
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 07:24:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso4614818pjb.2
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 07:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cE5Duj56ugJml1WWttHkSOG5BdjvCKPDcIyyykdg/Uk=;
        b=UtWsltE3Ww3Dl4t8IggrMi5tNjWx9aMvEL3dOAOmeYbQr/QKf7uny/HEWMbHgruGAH
         Q9Q52KdH/NL3CoX0LeZY54REq7WQsTi5wNgz8LVWlIS2l6bXXj3nJQJuKAkuZYM8JX+e
         oMUrQXRZvf3ej2FOKTfLMBPNaKWMRAfe3ebHqoLqeEe4jku9ialfYhRRV0z3XN6pdaep
         FBdxoGRm2fwlsTbWxHsJuxSc5Vm8ucsOMij+kvZxsfVu/9RRszoZJx57ydCzS5Bo19NG
         tGN8Qq3+J8g+t/S+dZGgwGOJLUSh7/Kl0QlR3YhDqUD306z1v0CWvHUq2PlIop3/SqKp
         s64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cE5Duj56ugJml1WWttHkSOG5BdjvCKPDcIyyykdg/Uk=;
        b=pWIxOcd2LUSxD7r3+H0TOXyqsaQ6ZJKI40o/5dzw7udO/hQA+9tv+CQeGt+BeuMvrH
         cDt85WACmPDP8g24Lqe0C+dTOR74hiOPt+s/GlLsfyB5ndCakj7nZD9xiHDxean4pRic
         QT8FhTH3meViBAJv0OsS6gF/zKznS7hlE8nUo7wOAxZsB1N4w6r7nhdpDEzwaBqLfADt
         VlVmxCfiqspB9OYZ4A2qmw6PU71CiMFIejkDr/mO1V1lbASbFJBpe7UiPXNhPWjJdUWo
         QcnEyfp0tBuZ0+3BqDlGo+O7UAkKnWlbNYmyv6Ijmy5kO4AIQ3olfUD2gaQPqe3BekbS
         v8dg==
X-Gm-Message-State: AOAM531PV68PnUyck+LlxBwRkqWsaTENS2Fg8JnySv5am8TgPiE46zpB
        fYGpUQGVCGgAYeFJaMq5gTVj7w==
X-Google-Smtp-Source: ABdhPJwyGRgI9Ylh1m8IrL+RZNlOECQqTH+eOr4xDshvNGR3gcKNCAT7d/biX9nQuHyjwX8G6L4K9g==
X-Received: by 2002:a17:90b:3ec5:: with SMTP id rm5mr5141814pjb.132.1628605490727;
        Tue, 10 Aug 2021 07:24:50 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x69sm1428731pfc.59.2021.08.10.07.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 07:24:50 -0700 (PDT)
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-2-axboe@kernel.dk> <YRJ74uUkGfXjR52l@T590>
 <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk>
Message-ID: <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
Date:   Tue, 10 Aug 2021 08:24:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 7:53 AM, Jens Axboe wrote:
> On 8/10/21 7:15 AM, Ming Lei wrote:
>> Hi Jens,
>>
>> On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
>>> Add a set of helpers that can encapsulate bio allocations, reusing them
>>> as needed. Caller must provide the necessary locking, if any is needed.
>>> The primary intended use case is polled IO from io_uring, which will not
>>> need any external locking.
>>>
>>> Very simple - keeps a count of bio's in the cache, and maintains a max
>>> of 512 with a slack of 64. If we get above max + slack, we drop slack
>>> number of bio's.
>>>
>>> The cache is intended to be per-task, and the user will need to supply
>>> the storage for it. As io_uring will be the only user right now, provide
>>> a hook that returns the cache there. Stub it out as NULL initially.
>>
>> Is it possible for user space to submit & poll IO from different io_uring
>> tasks?
>>
>> Then one bio may be allocated from bio cache of the submission task, and
>> freed to cache of the poll task?
> 
> Yes that is possible, and yes that would not benefit from this cache
> at all. The previous version would work just fine with that, as the
> cache is just under the ring lock and hence you can share it between
> tasks.
> 
> I wonder if the niftier solution here is to retain the cache in the
> ring still, yet have the pointer be per-task. So basically the setup
> that this version does, except we store the cache itself in the ring.
> I'll give that a whirl, should be a minor change, and it'll work per
> ring instead then like before.

That won't work, as we'd have to do a ctx lookup (which would defeat the
purpose), and we don't even have anything to key off of at that point...

The current approach seems like the only viable one, or adding a member
to kiocb so we can pass in the cache in question. The latter did work
just fine, but I really dislike the fact that it's growing the kiocb to
more than a cacheline.

-- 
Jens Axboe

