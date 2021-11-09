Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452F344AFBD
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 15:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhKIOuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 09:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbhKIOuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 09:50:23 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF97C061764
        for <io-uring@vger.kernel.org>; Tue,  9 Nov 2021 06:47:37 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id h23so20821766ila.4
        for <io-uring@vger.kernel.org>; Tue, 09 Nov 2021 06:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+U+0rgpwENh1FGWUmr8UhK/DQhDcZpVgI1C+vzG08yA=;
        b=g7phe7c/ewD7CTH6ZxJICc87YHWr3vFBpfhtjYeFGBikaaWJ3k7B78BCvVY4sBeg0b
         xjYbxOqrStNBEBREPOAqm0CwKgB1TEobU8QkusSS4oZelWKaNT34y9NDhnJlj0dgnWxs
         Er7SnTNdlJ+a/cXlG5N8e3OXbLmROQ+Kyom2NsltGOfWHJGMozBlhaqENXwhJnquahxN
         DhGbj3K3irGBK/T56JkhkL5n2UdxnODcratbil9vGvnx7bqsrf3fxhiLjxWrJtwGRY5r
         zULJFCu5OLA/paLclsbO189QmtXewK+hCGn6NPW3Dsj3UQe8oUytMEWVepBB69VE61XU
         jLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+U+0rgpwENh1FGWUmr8UhK/DQhDcZpVgI1C+vzG08yA=;
        b=QGTn6LtZX8VESfqNVHycNZ4OfYw7leXs7fdCl2aqGGePKdxnT2vtquiRk4aGtWne0D
         7ppl1RQaqDkRnkyhGBKL9NQkz1h8hQzP6m21hU+YzzyHXgW6dyLdJU32/1w06QRCx+pe
         rDjL6in4Kf0csUHCGisEPmjVeLtuPqFkzmG3AM6YI52IT+UbLEjjIxD42zmgMzJLtgfn
         tVH0B8mSQcC788XP30R9dpjQQBBcmwK/MHBmBm/r/ArB+3nKFj38xwk0VgH/IKIpzuQW
         B4lkip5Py9A7FHEKqbLCUqOXbWMXoN8Lw1Y2vbecK4Jn42JXwW3zGzFQDzLvdsZK0wSl
         WYDA==
X-Gm-Message-State: AOAM531G8kLehRQR07M3zvrzPZbEmj5bgt+cKVjY+MbHfinOWxOxRx40
        A5h0s9mpG7wLSvCPPlRkcjmn+Q==
X-Google-Smtp-Source: ABdhPJxqwXl8TAG+0XKTU2GG7jYfF76M4uFURIA0U55e1+UqyugEijpekoyfaPzxlyiR06Agk/L3AQ==
X-Received: by 2002:a92:cb4e:: with SMTP id f14mr5653339ilq.109.1636469256489;
        Tue, 09 Nov 2021 06:47:36 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c9sm9796003iom.9.2021.11.09.06.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 06:47:35 -0800 (PST)
Subject: Re: [PATCH v6 liburing] test: Add kworker-hang test
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Bedirhan KURT <windowz414@gnuweeb.org>
References: <20211106113506.457208-1-ammar.faizi@intel.com>
 <20211106114758.458535-1-ammar.faizi@intel.com>
 <CAGzmLMWsFYe3VJLonr7dc6Z3qe7YoB8b1meX6hyiHQdacpzBtw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ede7d490-4e48-7acf-725a-161e350e39a0@kernel.dk>
Date:   Tue, 9 Nov 2021 07:47:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGzmLMWsFYe3VJLonr7dc6Z3qe7YoB8b1meX6hyiHQdacpzBtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/21 10:44 PM, Ammar Faizi wrote:
> On Sat, Nov 6, 2021 at 6:49 PM Ammar Faizi wrote:
>>
>> This is the reproducer for the kworker hang bug.
>>
>> Reproduction Steps:
>>   1) A user task calls io_uring_queue_exit().
>>
>>   2) Suspend the task with SIGSTOP / SIGTRAP before the ring exit is
>>      finished (do it as soon as step (1) is done).
>>
>>   3) Wait for `/proc/sys/kernel/hung_task_timeout_secs` seconds
>>      elapsed.
>>
>>   4) We get a complaint from the khungtaskd because the kworker is
>>      stuck in an uninterruptible state (D).
>>
>> The kworkers waiting on ring exit are not progressing as the task
>> cannot proceed. When the user task is continued (e.g. get SIGCONT
>> after SIGSTOP, or continue after SIGTRAP breakpoint), the kworkers
>> then can finish the ring exit.
>>
>> We need a special handling for this case to avoid khungtaskd
>> complaint. Currently we don't have the fix for this.
> [...]
>> Cc: Pavel Begunkov <asml.silence@gmail.com>
>> Link: https://github.com/axboe/liburing/issues/448
>> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
>> ---
>>
>>  v6:
>>    - Fix missing call to restore_hung_entries() when fork() fails.
>>
>>  .gitignore          |   1 +
>>  test/Makefile       |   1 +
>>  test/kworker-hang.c | 323 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 325 insertions(+)
>>  create mode 100644 test/kworker-hang.c
> 
> It's ready for review.

This one is still triggering in the current tree, I'd prefer waiting with
queueing it up until it's fixed. I can park it in another branch until
that happens.

-- 
Jens Axboe

