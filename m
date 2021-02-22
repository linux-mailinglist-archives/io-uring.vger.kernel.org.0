Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCB43219E4
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 15:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhBVOMI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 09:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbhBVOKX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 09:10:23 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FB0C06178B
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 06:09:43 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id g9so10886103ilc.3
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 06:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RGQ4/qtHx2bjdFvrHFwyUEeeg/OYwFG54DfzAdrz3+k=;
        b=EDxEVjCtWelZXXeakBVsc8YZubZAU7JLWC6I7/OEx0f857/LgLETMq2fSvd0Wn33yE
         wiNVbR26+rzROP7lOyk1NiniRyN+Tmbx8/TX8kUI+QAHy6SevnynVy4AGjUvS8A4HNrW
         pCv74qIdjzWQJCKOnvqy1CtOlM+Htf3hJJLYYpYvUvMeRVWcDo2x4kYK1hQBYffhJNDX
         gi7OqwkkSeb95SI+OmGKyu1MupaXsqM4zM0NuhjC07//HtEiHCLN43G57FjVdjPqlySD
         jcg+iqtDSpZdyO0qXAId3gbjT0UNioWIR2BzYToAWmT+Iw+GUQRlPAmX5CiWPPei1CwV
         2GzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RGQ4/qtHx2bjdFvrHFwyUEeeg/OYwFG54DfzAdrz3+k=;
        b=CM8rMAjk6kVO7oto1mZ/YRWP3iVziem0QwOGMlW5gM+RKMxpMNzPajPpTMK804xbhf
         Ad7LgxpbEhj3SiwDV6b5UKwzPnkJIKLrRhWsI3IS8bXxQtvIxShjwUkQ0CTK+VEWAdSk
         fxKjRsKQDrDGSVOxLHVxs0o+out/kXg8J25G2FhXKV/hfAI2crE720sMZXpZM7nGDZSk
         GorYLTKXL7vwZ+yHbqaDoh2aiiLfmbOKpM/U/E1AsUJpV3qlWegh+Xszs/o3vxrgPgjX
         Az+rs4xG5DYUJW2NbmWi3X72T+So9PnZfyuxFzxzbZN0W1KNcKV7k2pBetHJFXyHXpBD
         muuA==
X-Gm-Message-State: AOAM530kw6Itw6jQ0V7Xd0l9mO+ba8mj+OHd63JOtONNfehnIdcdGKBO
        fkjidQXQS/TwW02r0nkMK+U3IQ==
X-Google-Smtp-Source: ABdhPJwfv5KNzqsw67r+b7VQyZku80bYaY0gjNcsmqJnjU4Ord9470UDNCt6Qu3Xn1tHFTovcoFSOA==
X-Received: by 2002:a05:6e02:1d8a:: with SMTP id h10mr14087421ila.224.1614002982921;
        Mon, 22 Feb 2021 06:09:42 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g16sm11480253iln.29.2021.02.22.06.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 06:09:42 -0800 (PST)
Subject: Re: [PATCH v6 3/7] Reimplement RLIMIT_NPROC on top of ucounts
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <72fdcd154bec7e0dfad090f1af65ddac1e767451.1613392826.git.gladkov.alexey@gmail.com>
 <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
 <20210222101141.uve6hnftsakf4u7n@example.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <73b37a89-79d2-9c04-0626-2b164e91c3a8@kernel.dk>
Date:   Mon, 22 Feb 2021 07:09:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222101141.uve6hnftsakf4u7n@example.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/21 3:11 AM, Alexey Gladkov wrote:
> On Sun, Feb 21, 2021 at 04:38:10PM -0700, Jens Axboe wrote:
>> On 2/15/21 5:41 AM, Alexey Gladkov wrote:
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index a564f36e260c..5b6940c90c61 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -1090,10 +1091,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>>>  		wqe->node = alloc_node;
>>>  		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
>>>  		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
>>> -		if (wq->user) {
>>> -			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
>>> -					task_rlimit(current, RLIMIT_NPROC);
>>> -		}
>>> +		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = task_rlimit(current, RLIMIT_NPROC);
>>
>> This doesn't look like an equivalent transformation. But that may be
>> moot if we merge the io_uring-worker.v3 series, as then you would not
>> have to touch io-wq at all.
> 
> In the current code the wq->user is always set to current_user():
> 
> io_uring_create [1]
> `- io_sq_offload_create
>    `- io_init_wq_offload [2]
>       `-io_wq_create [3]

current vs other wasn't my concern, but we're always setting ->user so
the test was pointless. So looks fine to me.

-- 
Jens Axboe

