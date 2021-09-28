Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5BE41B2FC
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 17:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241608AbhI1Pd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 11:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241586AbhI1Pd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 11:33:58 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF197C06161C
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 08:32:18 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b12so11995501ilf.11
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 08:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=i3E6j+dUCAVMX0P+Wo8lZXkTkGRjikV1/Qo1b66reg4=;
        b=Mueja4+gFZpC5IjHtV5fy0Br+2C4M6nvx8G/NBycjc8AjFNsxoQyV1WKImnQU2I/12
         lXm9vC7HNgbdj5Cmoz+V9DDdXp7V41imjXmFraYpWMnbE/wtmaaLo2Dm3f0264w7xHYb
         /rOJ9LIrtLZnTbUcO5ovyA1ZdTUUUgTtBlGvED/pETfEHjZUXMcz2+2jOpv8K1QAXiQD
         DIjGtEL5Dfa4PknI+OqAfjrWlMGOqqIYrhF6S6MYimb5kQyX310S8Mt/dRb3f9n4PL0V
         Nnt/TVmSzmQVDkBOKIq6nPlCR0CeI9SI84/I+d5tz5hq+yw9d9eRqpjWOrZswxgQ60SK
         eabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i3E6j+dUCAVMX0P+Wo8lZXkTkGRjikV1/Qo1b66reg4=;
        b=tdUf1A0RsqKL2wIs08+fLibCgdv9qxL2UTEJGpQda63/pEOtRfl2kYTNMX+EyupDNi
         O/zIHRUIuAyznzFhvJ6rm3cg8yLydXvOx85ww4UVO9XG8nXvj5QO21iBFKUbIarCB5WC
         ND/qmlALQXERu73bwivX9rP4EHKt8Bpq6gPHkAW3ijOiXnFn1z5u/UDDBA9/z9ARiSxP
         rz4W0BXJNKsWl3Ndcz1suf1zAdPU0hRsH4gLOW5VCEYrgLpXT35FWVG6xcqD49pq54eA
         VFqcmZyb7ldisUGlRoOlTH8+dxZex2FAEu82Sr//T64iKjI4jREhyA8krp8QkYvCw+3O
         sk9g==
X-Gm-Message-State: AOAM5334ZQpiVIw0FBRKTXWEtXXQ67HY3yEUJdtZ5329Os0Wz2KB7gaS
        TmRZeDtBSLIR1YINdbbto5bf932l6w8mbLHAhp4=
X-Google-Smtp-Source: ABdhPJxDwWstpmYPOCdmcaFJfocxAhkex5sJYhDlSmHufFG/en0Lmp4j2U3bxUIt0hRm6AVKvGmyLA==
X-Received: by 2002:a05:6e02:158c:: with SMTP id m12mr4807573ilu.132.1632843137921;
        Tue, 28 Sep 2021 08:32:17 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r3sm11506812ilc.56.2021.09.28.08.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 08:32:17 -0700 (PDT)
Subject: Re: [PATCH v2 04/24] io_uring: use slist for completion batching
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
References: <cover.1632516769.git.asml.silence@gmail.com>
 <a666826f2854d17e9fb9417fb302edfeb750f425.1632516769.git.asml.silence@gmail.com>
 <c4b3163b-fc75-059e-1cc9-2b5ed9ce93a3@linux.alibaba.com>
 <f3631cc8-59e9-3a82-1982-1ee5f84f4674@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <acf2f64a-a9da-b707-0d8d-8374d4e4ab9a@kernel.dk>
Date:   Tue, 28 Sep 2021 09:32:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f3631cc8-59e9-3a82-1982-1ee5f84f4674@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/21 3:41 AM, Pavel Begunkov wrote:
> On 9/26/21 7:57 AM, Hao Xu wrote:
>> 在 2021/9/25 上午4:59, Pavel Begunkov 写道:
>>> Currently we collect requests for completion batching in an array.
>>> Replace them with a singly linked list. It's as fast as arrays but
>>> doesn't take some much space in ctx, and will be used in future patches.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   fs/io_uring.c | 52 +++++++++++++++++++++++++--------------------------
>>>   1 file changed, 25 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 9c14e9e722ba..9a76c4f84311 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -322,8 +322,8 @@ struct io_submit_state {
>>>       /*
>>>        * Batch completion logic
>>>        */
>>> -    struct io_kiocb        *compl_reqs[IO_COMPL_BATCH];
>>> -    unsigned int        compl_nr;
>>> +    struct io_wq_work_list    compl_reqs;
>> Will it be better to rename struct io_wq_work_list to something more
>> generic, io_wq_work_list is a bit confused, we are now using this
>> type of linked list (stack as well) for various aim, not just to link
>> iowq works.
> 
> Was thinking about it, e.g. io_slist, but had been already late --
> lots of conflicts and a good chance to add a couple of extra bugs
> on rebase. I think we can do it afterward (if ever considering
> it troubles backporting)

Agree with both of you - it should be renamed, but at the same time it's
also really annoying with trivial conflicts for eg stable patches due to
random renaming. I was bit by this again just recently, function rename
in that case.

So let's keep the name for now, and once we have some quiet time, we
can get that done.

-- 
Jens Axboe

