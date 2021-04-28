Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D999436D9B4
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhD1OkY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhD1OkY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:40:24 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774A6C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:39:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id z6-20020a17090a1706b0290155e8a752d8so737143pjd.4
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZyLcOi8DscQfP7+z6Kzn22PLaNAn9L88JEQN0ajJUHQ=;
        b=B6bA/DD/FZwqf2ZCIFwSwEhb7oSCxx7hGJLCRPa9JgY0oUeiV7NV3cqiZP7viV/cE8
         yiE9MmxJeM2KQ/P7Zs4vuP9WNJiaOlteREe+txNHkVjFEbJsM+SOJFsYHsaNRpzjpbkI
         3xFeKwsExOezKn/OP9UKVa6ysmG+DDKhO5DksOwRnWZ7n3j18JxY6sHe00CKuhYBb+8O
         hNjwEOY3ZKq9K6s/jcycfLJjkpu/1etIzaDGeionqsJp3OwIqGR7qOLHl9REkxNW6I8v
         1Lck+KJe683QCMfXai0K6h4FHSaDVE0zvcFFMnhB7HgN00+x/v0Gkx2S3gvjDdBe3jVv
         Kuug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZyLcOi8DscQfP7+z6Kzn22PLaNAn9L88JEQN0ajJUHQ=;
        b=p6paGVPjr1sRQGrVgWQFpYuMrZOZ/sdJHMwVdWO+SMzfd5h7Ka9sr7Zc8CxG3490gb
         J05lM+MDAhU1L3KEnapxIzaOUhyMheaBh4Td6IQ3VGY8A8Rph4sYSjRkiU1pLU+cz+LV
         DEe5AZOYxDZxo6TAqVh3cqGC7F1DEutc8PltPf+9ObzHYN/v9eUwBnHriuXfmWeodK6z
         8x6Hy9Br8KwlZZSEuvFqBwa4uLHgQiLGI6lOoZLvShj+SKDe4fFgylsLoCWYImz4TIhs
         Hp3LUI+5Dyzv/c2QRbcQfoXW2WB6AhZ71+ELm5FETzI64uCNKekdxg6PDf4PNfgTFlIN
         EY3A==
X-Gm-Message-State: AOAM531D0+oTfAgTLZb6g9QNYDUl7yKnY2ChzDrLIZ90l0yAumomLFr0
        ka/fVN2gFb2rAA9+dtyu89llOg==
X-Google-Smtp-Source: ABdhPJyf96yNvFzUuy33HZ0YKpmdv/Idd158neY9p4GzkH3Vc2HMUrr/JbpbgoOxtKlwPjiXDMT4ew==
X-Received: by 2002:a17:902:8d8b:b029:ed:64bb:db81 with SMTP id v11-20020a1709028d8bb02900ed64bbdb81mr6971673plo.53.1619620778813;
        Wed, 28 Apr 2021 07:39:38 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 39sm139713pjo.25.2021.04.28.07.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:39:38 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
Date:   Wed, 28 Apr 2021 08:39:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 8:34 AM, Pavel Begunkov wrote:
> On 4/28/21 2:32 PM, Hao Xu wrote:
>> sqes are submitted by sqthread when it is leveraged, which means there
>> is IO latency when waking up sqthread. To wipe it out, submit limited
>> number of sqes in the original task context.
>> Tests result below:
> 
> Frankly, it can be a nest of corner cases if not now then in the future,
> leading to a high maintenance burden. Hence, if we consider the change,
> I'd rather want to limit the userspace exposure, so it can be removed
> if needed.
> 
> A noticeable change of behaviour here, as Hao recently asked, is that
> the ring can be passed to a task from a completely another thread group,
> and so the feature would execute from that context, not from the
> original/sqpoll one.
> 
> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
> ignored if the previous point is addressed.

I mostly agree on that. The problem I see is that for most use cases,
the "submit from task itself if we need to enter the kernel" is
perfectly fine, and would probably be preferable. But there are also
uses cases that absolutely do not want to spend any extra cycles doing
submit, they are isolating the submission to sqpoll exclusively and that
is part of the win there. Based on that, I don't think it can be an
automatic kind of feature.

I do think the naming is kind of horrible. IORING_ENTER_SQ_SUBMIT_IDLE
would likely be better, or maybe even more verbose as
IORING_ENTER_SQ_SUBMIT_ON_IDLE.

On top of that, I don't think an extra submit flag is a huge deal, I
don't imagine we'll end up with a ton of them. In fact, two have been
added related to sqpoll since the inception, out of the 3 total added
flags.

This is all independent of implementation detail and needed fixes to the
patch.

-- 
Jens Axboe

