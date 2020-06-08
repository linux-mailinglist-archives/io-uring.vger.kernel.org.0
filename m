Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80B11F13A5
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 09:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgFHHg5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 03:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgFHHg4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 03:36:56 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84340C08C5C3;
        Mon,  8 Jun 2020 00:36:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n21so2682828ejg.3;
        Mon, 08 Jun 2020 00:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZIEVPByf7q2KBEmomKulfdMrwJXv/E4f3FAMpa/LInw=;
        b=umBGfh/3Mi0JmJ/6+2BcJDyow0tcHLXFbH/6MoST2AS20JpDr4hEFbaulEnZJObhgx
         mcrK/4z9XOeLNiYxvpMnjtWrIeRZ4BirGx8dKaC2cZ2mV14oK015MwgUQV0mFbGGjF0G
         f/YckSKBML8gP1v5AxhFfOryE/LJijMEo8uQH25bmjnTZek2mo49u/YnOf8kRtATUcwq
         5kDljKv1ZMpuVFAsGIapcNEdmSWzrql5kPVuFgIG5HjcKGrsR0A5EXHLfRQS6xuEYqQb
         /HXZ5rI5HK177mFOZmkuMf7g7f1ILhJ67RRWhqxHe/3i8rVG5dQU2QiYbL+ilY6jQjPQ
         ENTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZIEVPByf7q2KBEmomKulfdMrwJXv/E4f3FAMpa/LInw=;
        b=PCj6KBqR2T49IDc8iHTy3gv7m+Pw06SyMQKMCBwgYpxNslMtKOmT6OQ32+2EWFvGnN
         G8gxbH7KpUiJd6u2FbkgYEVYmx0df1cdWLmgHISo1sZD3WLtZ8P9UW9UJiJ5ZQbzCn0Z
         RvycqM4tvrXLkYNqJ50zhj6kMw8W3Epy5RXH1CSs/0asl7SNwSnD85ObcDEatTUxHZLz
         6QX2qnV1IG+JazuBBn6Re23heeqXAVBrsmEdkFFWjFbKlDjMrCRu2y7NkX5kEdo1Zw4M
         9Bljo3oSXhlieRrlkvwojdlLeIrq6dISUFuZoF7Zyv8vQGNSUQmfK3FTYXsc4LXw1Bpb
         bkqw==
X-Gm-Message-State: AOAM532fB1UZa5dCdzRAM2HAf+J2WNvjgwAtJLAsoyZVZwO8DfYhBfD+
        0vmjIOy6X+1cflZzrx0JenR5XMYJ
X-Google-Smtp-Source: ABdhPJxjqlnRAaXr/QjBWyRDLRzvdah9Q4LN1m7nrp0y993GA3ntu55tCfanmwXYyuhAqhbBjDpFwQ==
X-Received: by 2002:a17:907:1110:: with SMTP id qu16mr20354098ejb.539.1591601814879;
        Mon, 08 Jun 2020 00:36:54 -0700 (PDT)
Received: from [192.168.43.135] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id k8sm11311716edn.28.2020.06.08.00.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 00:36:54 -0700 (PDT)
Subject: Re: [PATCH 0/4] cancel all reqs of an exiting task
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591541128.git.asml.silence@gmail.com>
 <3924c8b4-fb37-0d85-b8ce-4183e6fff317@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7bbbb26c-6584-16d9-76c4-a2ca00d994f3@gmail.com>
Date:   Mon, 8 Jun 2020 10:35:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3924c8b4-fb37-0d85-b8ce-4183e6fff317@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/06/2020 03:12, Jens Axboe wrote:
> On 6/7/20 9:32 AM, Pavel Begunkov wrote:
>> io_uring_flush() {
>>         ...
>>         if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>>                 io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
>> }
>>
>> This cancels only the first matched request. The pathset is mainly
>> about fixing that. [1,2] are preps, [3/4] is the fix.
>>
>> The [4/4] tries to improve the worst case for io_uring_cancel_files(),
>> that's when they are a lot of inflights with ->files. Instead of doing
>> {kill(); wait();} one by one, it cancels all of them at once.
>>
>> Pavel Begunkov (4):
>>   io-wq: reorder cancellation pending -> running
>>   io-wq: add an option to cancel all matched reqs
>>   io_uring: cancel all task's requests on exit
>>   io_uring: batch cancel in io_uring_cancel_files()
>>
>>  fs/io-wq.c    | 108 ++++++++++++++++++++++++++------------------------
>>  fs/io-wq.h    |   3 +-
>>  fs/io_uring.c |  29 ++++++++++++--
>>  3 files changed, 83 insertions(+), 57 deletions(-)
> 
> Can you rebase this to include the changing of using ->task_pid to
> ->task instead? See:
> 
> https://lore.kernel.org/io-uring/87a71jjbzr.fsf@x220.int.ebiederm.org/T/#u
> 
> Might as well do it at the same time, imho, since the cancel-by-task is
> being reworked anyway.

Ok, I was thinking to look there after anyway


-- 
Pavel Begunkov
