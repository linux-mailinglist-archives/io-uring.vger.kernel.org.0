Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A80D44C555
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 17:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhKJQu3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 11:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhKJQu3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 11:50:29 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84219C061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 08:47:41 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h2so3136207ili.11
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 08:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4ptsxKTZqCbx25+xmhHi0wOvxNTkKhxjN1Lwh35Qdrw=;
        b=Rbd0+3/ckjdvL308SQY6b40g/uJCnZNjvz+Hnwc7cjf6dl99AJnkDfXBg5qgVIYmwK
         CwCa533837kl3iYan5wrGQZYXZBLsIKQ5Udl4hhiym6sstT1HLplLIxjJrzgTtwfHOuo
         9Pbya6FiyJ134SRDXHYhF3H9s2EI7HygCLlks0lR7c+3jxIAEmEzqDcUpXZk6W1WUO75
         XhVJkZr+hZk+OGx/0V6IyB4Aq9IHTVlohlsFwUrWnOpJ49TjH5JfLqEqmedfG6INz5Dc
         bQivgFcdxyuSfxy2slmUeDRp5bv47piQbJYlZDhmxGvbz9WufjyhsUD1tDrgyUWz55Pc
         91FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ptsxKTZqCbx25+xmhHi0wOvxNTkKhxjN1Lwh35Qdrw=;
        b=DB9zbq5WJDCDPvR7hrDu0+qB6DyTClCcxuLiP9g/BO4no7hCBDUgTglAPgXyPK9vo8
         7wIJQBLmxjiw/N+fArW5G1HHOEjxsBDWn3+x9Gr7+JRSv7nFUs10kjHhzLmgqYRXTFdB
         EySbuH0E42jFd/EsOClJ+BP7dA7B6NLBxIhnp7a9yQGjMt8dy4XHnHnKK9YjQB2cmjHh
         dlyD1cVCwqD5d9FaplLNHro0D6SCumN9IvtfMnJHsvdR1uQdThSiWD3vPytlPaTPcrjl
         n251Gm2zNw0ZRUAkU8s9Hodsh1ztxZvCDwSY6DRm+mmKcKJqlhtqpwRG6Lybv12UhPD4
         Kn5Q==
X-Gm-Message-State: AOAM531GOe20BhQoNFZXaUnDGzmOwch+RkYJX2LHFaJO9+C/TtvSxyqj
        ukvXWBn6Zo+IS6HWUNY3JdZkUpXLl3EFkErm
X-Google-Smtp-Source: ABdhPJyWX89b79QSWYrfNLFJH+IaSDSTkD72jtYh6xSiFI71M/R45VopQwqupACXaxSOS0FdlCEEWA==
X-Received: by 2002:a05:6e02:1a4b:: with SMTP id u11mr299682ilv.96.1636562860648;
        Wed, 10 Nov 2021 08:47:40 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x15sm178836iob.8.2021.11.10.08.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 08:47:40 -0800 (PST)
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
 <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7a4f8655-06df-9549-e3df-c3bf972f06e6@kernel.dk>
Date:   Wed, 10 Nov 2021 09:47:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/10/21 9:42 AM, Pavel Begunkov wrote:
> On 11/10/21 16:14, Jens Axboe wrote:
>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>> It's expensive enough to post an CQE, and there are other
>>> reasons to want to ignore them, e.g. for link handling and
>>> it may just be more convenient for the userspace.
>>>
>>> Try to cover most of the use cases with one flag. The overhead
>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>> requests and a bit bloated req_set_fail(), should be bearable.
>>
>> I like the idea, one thing I'm struggling with is I think a normal use
>> case of this would be fast IO where we still need to know if a
>> completion event has happened, we just don't need to know the details of
>> it since we already know what those details would be if it ends up in
>> success.
>>
>> How about having a skip counter? That would supposedly also allow drain
>> to work, and it could be mapped with the other cq parts to allow the app
>> to see it as well.
> 
> It doesn't go through expensive io_cqring_ev_posted(), so the
> userspace can't really wait on it. It can do some linking tricks to
> alleviate that, but I don't see any new capabilities from the current
> approach.

I'm not talking about waiting, just reading the cqring entry to see how
many were skipped. If you ask for no cqe, by definition there would be
nothing to wait on for you. Though it'd probably be better as an sqring
entry, since we'd be accounting at that time. Only caveat there is then
if the sqe errors and we do end up posting a cqe..

> Also the locking is a problem, I was thinking about it, mainly hoping
> that I can adjust cq_extra and leave draining, but it didn't appear
> great to me. AFAIK, it's either an atomic, beating the purpose of the
> thing.

If we do submission side, then the ring mutex would cover it. No need
for any extra locking

> Another option is to split it in two, one counter is kept under
> ->uring_lock and another under ->completion_lock. But it'll be messy,
> shifting flushing part of draining to a work-queue for mutex locking,
> adding yet another bunch of counters that hard to maintain and so.

You'd only need the cqring counter for the unlikely event that the
request is failed and does post an cqe, though.

> And __io_submit_flush_completions() would also need to go through
> the request list one extra time to do the accounting, wouldn't
> want to grow massively inlined io_req_complete_state().

-- 
Jens Axboe

