Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F2A2A720E
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 00:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgKDXoh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 18:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732784AbgKDXoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 18:44:02 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA0C0613CF
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 15:44:01 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 13so18670336pfy.4
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 15:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=17UeQdTZqUibitgRHwc6pYwOpWA34muwj5f6WQ9gi5I=;
        b=HjIIMX3HWDqMazjsIFypwNMmjnKxUi6BoiOAXMaYkrw31yyWw79H9+Br/M0PS77heQ
         +iCxn8bbVa221xv1VPyCPoNxweUAekWa39b4armP7RM8eSh9OhvML/QvQyAKHuWUPl4i
         vFwN1gkKo7Dk0cZ7JQwsF4G357hBjPb/Q3XC3IvOuTjHXAmFsKss+NHSbstCZIwMqpwE
         eVrGWaMGRExcKFZysVTYymVuFEqQ0XQWnkKf7fNTU2ED8zCrkaaaci7sH+a0N8a5wp0N
         KZ9jQDJaBgOPvR2UJNwaaWBw8E0UiPE8kZQPO1lTLXuNyEK4VSkYw1NGnnh1HA25xKTX
         GFmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=17UeQdTZqUibitgRHwc6pYwOpWA34muwj5f6WQ9gi5I=;
        b=cj7csOaPKjQiC6R2OCgENJSSiGfalt9apYt2dZ39sVBBGUwTxeMUPRAZV5I7PpeDpK
         8LlxALUcwKNRln2cilJBL5Ef2vfAXQJrJzLhntpRoPgFy7r0zu0ru/sxkw0g45A2zzLQ
         k+VvcbBpryHwkXINIQ7ss82ZpNM+zDrOU5D6/HP7Kxtb7pDJF3+vLgje2bWmZjxTWHzi
         o1d5jDichbGispkiL8mtLOEkqaacwIeCbKVKu67ZF2iz/aFhtNkGbk3oa8zKIQZ+P/yA
         426FV1ABtRVb76tlsb3Q7KFXcLz6ugDk4d0SIdBuXmKOneOqPc1SwUoGq8EF6pvA/Tev
         vS5A==
X-Gm-Message-State: AOAM5319fNvMx9P9d5LigRfwgFvYAQXKm04bGxv+4NXVovjVEjxRysJs
        QfAkosCnL0hTg/KUqABBiP19+Z0og3s8EA==
X-Google-Smtp-Source: ABdhPJwO4lHyL2qYCzSn5m+IKxJIitGIHhBjcC9XUrmGKWcyNdY/+YgYF1JGfPYw7ShayZD/+wIfxQ==
X-Received: by 2002:a63:ff5b:: with SMTP id s27mr338872pgk.383.1604533440406;
        Wed, 04 Nov 2020 15:44:00 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w187sm3562212pfb.93.2020.11.04.15.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 15:43:59 -0800 (PST)
Subject: Re: relative openat dirfd reference on submit
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Vito Caputo <vcaputo@pengaru.com>, io-uring@vger.kernel.org
References: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
 <d57e6cb2-9a2c-86a4-7d64-05816b3eab54@kernel.dk>
 <0532ec03-1dd2-a6ce-2a58-9e45d66435b5@gmail.com>
 <c7130e35-6340-5e0b-f0d9-3c8465d0eaf9@kernel.dk>
 <efe65885-6bf3-a3d1-5c67-dc7b34dd96c2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c97e1b84-9c48-fe91-7c79-57de98c7fc0a@kernel.dk>
Date:   Wed, 4 Nov 2020 16:43:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <efe65885-6bf3-a3d1-5c67-dc7b34dd96c2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/20 5:41 PM, Pavel Begunkov wrote:
> On 03/11/2020 00:34, Jens Axboe wrote:
>> On 11/2/20 5:17 PM, Pavel Begunkov wrote:
>>> On 03/11/2020 00:05, Jens Axboe wrote:
>>>> On 11/2/20 1:52 PM, Vito Caputo wrote:
>>>>> Hello list,
>>>>>
>>>>> I've been tinkering a bit with some async continuation passing style
>>>>> IO-oriented code employing liburing.  This exposed a kind of awkward
>>>>> behavior I suspect could be better from an ergonomics perspective.
>>>>>
>>>>> Imagine a bunch of OPENAT SQEs have been prepared, and they're all
>>>>> relative to a common dirfd.  Once io_uring_submit() has consumed all
>>>>> these SQEs across the syscall boundary, logically it seems the dirfd
>>>>> should be safe to close, since these dirfd-dependent operations have
>>>>> all been submitted to the kernel.
>>>>>
>>>>> But when I attempted this, the subsequent OPENAT CQE results were all
>>>>> -EBADFD errors.  It appeared the submit didn't add any references to
>>>>> the dependent dirfd.
>>>>>
>>>>> To work around this, I resorted to stowing the dirfd and maintaining a
>>>>> shared refcount in the closures associated with these SQEs and
>>>>> executed on their CQEs.  This effectively forced replicating the
>>>>> batched relationship implicit in the shared parent dirfd, where I
>>>>> otherwise had zero need to.  Just so I could defer closing the dirfd
>>>>> until once all these closures had run on their respective CQE arrivals
>>>>> and the refcount for the batch had reached zero.
>>>>>
>>>>> It doesn't seem right.  If I ensure sufficient queue depth and
>>>>> explicitly flush all the dependent SQEs beforehand
>>>>> w/io_uring_submit(), it seems like I should be able to immediately
>>>>> close(dirfd) and have the close be automagically deferred until the
>>>>> last dependent CQE removes its reference from the kernel side.
>>>>
>>>> We pass the 'dfd' straight on, and only the async part acts on it.
>>>> Which is why it needs to be kept open. But I wonder if we can get
>>>> around it by just pinning the fd for the duration. Since you didn't
>>>> include a test case, can you try with this patch applied? Totally
>>>> untested...
>>>
>>> afaik this doesn't pin an fd in a file table, so the app closes and
>>> dfd right after submit and then do_filp_open() tries to look up
>>> closed dfd. Doesn't seem to work, and we need to pass that struct
>>> file to do_filp_open().
>>
>> Yeah, I just double checked, and it's just referenced, but close() will
>> still make it NULL in the file table. So won't work... We'll have to
>> live with it for now, I'm afraid.
> 
> Is there a problem with passing in a struct file? Apart from it
> being used deep in open callchains?

No technical problems as far as I can tell, just needs doing...

-- 
Jens Axboe

