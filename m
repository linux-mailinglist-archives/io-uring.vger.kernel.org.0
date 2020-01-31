Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5094914EF4D
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 16:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgAaPO4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 10:14:56 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35080 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgAaPO4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 10:14:56 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so6455992ild.2
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 07:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=edSNLmQmmgQguLrgOmJEYPKP8z+l4pSZiMsVBSOHVhM=;
        b=ZA7evfpmQwezytM16YTzgM2Xd01P08tZc2V3hDwv1La/8oBQiecxHK/fi7yPKVXoi9
         S+meSHB3qDSHKfeGLlri2elc9NwFTnxwWocGJftJTCRDBT1rh9lXr4TAkTJFAGaXJLmK
         Z7bQ1ZREsUoLKrMId92QEwePk569vJIDg8vKqclGhZPi1KvpArHo/3rDh5EMxDORpLge
         AwJ8n1/qlzOGUexJnNlBynBlf3gLU9w0rylDdl+RZKvyE273iQjo2XP44QThYrpSSrfw
         DmOXfzwz1b2kqUll4yrVKt0a2ZM2h+6lssdlK7zxwh2HsSfEOzsj0eO8GrGkQiKve0xY
         2I+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=edSNLmQmmgQguLrgOmJEYPKP8z+l4pSZiMsVBSOHVhM=;
        b=a4Bi0YlDSKFirwZMclkF7SsV+ligFX+BX4/T+QiNMUWwWPaU+WEtA7AKGa+sesP68J
         dd1buRrMOKAkf+KN34nW49HlWkeog2RcbK2SyeqsNBeVMwWzTk1Ot7FYLGbWL/9XwluR
         giAH4WH61RAe92gMnkrUrKPk9qGGKS4lfBRDxw1BQAL/S2r9if592o9EUu0M9q3/QCuN
         7Jb+lL+jJVWcYZgyrG20kZtr8/pmLPmUV4ith2tvf30MKV7ZO6ZlPkcV9dnUy4rW37xX
         DdvY0oHXC271qXodG5hL+SDs1LDu+eF7W9gZdSinwPLNsUhcvB/DlE+8/qY+xkYj287b
         3BYA==
X-Gm-Message-State: APjAAAXl2OP3cZOEuIbfvHOKSQvcRPaFEsMjTZ1MNKJCe9n75jnpPhy8
        BQ7vXgraBb8gqMBv9zZbvfHxxrkoSVc=
X-Google-Smtp-Source: APXvYqz3ifnA5kitLTtCk3Sjh+x93S01SMhnJj0g5n+Z6qxdAp8MIZCKocw3s9bqfIsjCHdTvO/aWg==
X-Received: by 2002:a92:84dd:: with SMTP id y90mr2856331ilk.99.1580483694754;
        Fri, 31 Jan 2020 07:14:54 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v18sm3226348ilm.85.2020.01.31.07.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 07:14:54 -0800 (PST)
Subject: Re: [PATCH v2 liburing] add helper functions to verify io_uring
 functionality
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <20200130160013.21315-1-glauber@scylladb.com>
 <94074992-eb67-def1-5f74-5e412dda18fd@kernel.dk>
 <CAD-J=zZURZV46Tzx4fC4EteD4ejL=axKaw-CjtyFmYhCYzKEdg@mail.gmail.com>
 <3338257d-009d-1db0-c77a-2bf06e5518f2@kernel.dk>
 <CAD-J=zaHpYPj-UOK46AhdKgSHQF2Hd5b_tjZ_+d9qAdu5VHXhA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d08b04c0-535e-4837-bd83-531f231259b9@kernel.dk>
Date:   Fri, 31 Jan 2020 08:14:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zaHpYPj-UOK46AhdKgSHQF2Hd5b_tjZ_+d9qAdu5VHXhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 6:52 AM, Glauber Costa wrote:
> On Thu, Jan 30, 2020 at 11:31 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 1/30/20 9:29 AM, Glauber Costa wrote:
>>> On Thu, Jan 30, 2020 at 11:13 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 1/30/20 9:00 AM, Glauber Costa wrote:
>>>>> It is common for an application using an ever-evolving interface to want
>>>>> to inquire about the presence of certain functionality it plans to use.
>>>>>
>>>>> Information about opcodes is stored in a io_uring_probe structure. There
>>>>> is usually some boilerplate involved in initializing one, and then using
>>>>> it to check if it is enabled.
>>>>>
>>>>> This patch adds two new helper functions: one that returns a pointer to
>>>>> a io_uring_probe (or null if it probe is not available), and another one
>>>>> that given a probe checks if the opcode is supported.
>>>>
>>>> This looks good, I committed it with minor changes.
>>>>
>>>> On top of this, we should have a helper that doesn't need a ring. So
>>>> basically one that just sets up a ring, calls io_uring_get_probe(),
>>>> then tears down the ring.
>>>>
>>> I'd be happy to follow up with that.
>>>
>>> Just to be sure, the information returned by probe should be able to outlive the
>>> tear down of the ring, right ?
>>
>> Yeah, same lifetime as the helper you have now, caller must free it once
>> done.
> 
> Well, in hindsight, I should have called that
> io_uring_get_probe_ring() so io_uring_get_probe()
> doesn't take a ring.

Just change it - we just added it yesterday, and it's not released yet.
I don't break anything that's been in a release, and I maintain
compatibility between releases, but we can change it now.

> Alternatively, to keep things in a single function, I can change
> io_uring_get_probe() so that if it
> ring is NULL, we do our own allocation.
> 
> I actually kind of like that. Would that work for you ?

Not a huge deal to me, we can go that route.

-- 
Jens Axboe

