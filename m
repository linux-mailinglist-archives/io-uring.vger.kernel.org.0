Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5179C3BE95D
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 16:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhGGOJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 10:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhGGOJc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 10:09:32 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E01C061574;
        Wed,  7 Jul 2021 07:06:52 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n33so1946005wms.1;
        Wed, 07 Jul 2021 07:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fAVhgqUM4VrGYDFZJ+nz9eDhvYDuxW+FXc9VOow4+Qo=;
        b=q3tdBjgDz5AC9GSL4GQkQZ2jBJsfPbIeAqxyvhzGpRLQiAqY++/NF75zZjsmtOG6cb
         zmjAxMi8S70TKJZnmqbJspszNKea+ackvKfTl7hKawcd/OqEZ1acdbRv/zxZQWO5eszh
         qHtOBYjTOxxyYR4aKLGrff+5tBvZ1i613l9oedFsVK6hHkyRpSBqGUibKowGGWxXDjc3
         Dos/rOVDo/RY0BqxxPm2YQteWZwQAva26+VahRKwLTLVQqQLXandQWrfH+P6xn9RO611
         seclOSYLNNQn0rIONZ5S6Ty4w4xU1TJFGzwH/rkrBSMBD8tAsPcJseXPQEeIdSXvZ+nl
         wRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fAVhgqUM4VrGYDFZJ+nz9eDhvYDuxW+FXc9VOow4+Qo=;
        b=OQpjRvdNOrXpNY+tUIymaSBgBm3VqQ7rwjHOF03pK95lJU8bJNnNY2EAyKXEgzJYAu
         NPJ0yKkG071IwP4AsvDjLhQsDrx2S7k1BdzK5r6CYvK7NTIuVXaHwgoDwfWnwCt6+zBb
         HQdo77dhhyVlBqo9aoK9wH9WDHLR4lcCQ9rRbyIf50HDa/qGFU8XUshNIn8hBruYWdBx
         N4WR1RHLaoqKZkNe27Cs+6a/zB4BjrfZYp1jNUK3RLMClbwBSsllG/lXAfHm009PmAYV
         JWcKnWscPU9NwXhFjo1rch54OI3Rv1qcxxSDz+kcRQ0fYqIBC7gp5iQayRaF4hPGzPow
         52/g==
X-Gm-Message-State: AOAM530TcXplRlKXoHf7r+MdQ9DvMfUEa0b2W8BjLFmNPq4W7sLHF9s2
        KS4HUmvhy9HRNchd0VVZGfyws0tVcJ8GqA==
X-Google-Smtp-Source: ABdhPJwkBxk4SBUd3ZSeQSo2NUR4845YL4xAU4KZXM/0q5dACogSJDxmmOfFMXs7Jpqi7EqRLMorBQ==
X-Received: by 2002:a1c:4b12:: with SMTP id y18mr7145268wma.111.1625666810461;
        Wed, 07 Jul 2021 07:06:50 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.234.206])
        by smtp.gmail.com with ESMTPSA id t16sm20485674wrp.44.2021.07.07.07.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 07:06:50 -0700 (PDT)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-3-dkadashev@gmail.com>
 <c079182e-7118-825e-84e5-13227a3b19b9@gmail.com>
 <4c0344d8-6725-84a6-b0a8-271587d7e604@gmail.com>
 <CAOKbgA4ZwzUxyRxWrF7iC2sNVnEwXXAmrxVSsSxBMQRe2OyYVQ@mail.gmail.com>
 <15a9d84b-61df-e2af-0c79-75b54d4bae8f@gmail.com>
 <CAOKbgA4DCGANRGfsHw0SqmyRr4A4gYfwZ6WFXpOFdf_bE2b+Yw@mail.gmail.com>
 <b6ae2481-3607-d9f8-b543-bb922b726b3a@gmail.com>
 <CAOKbgA6va=89pLayQgC20QvPeTE0Tp-+TmgJLKy+O2KKw8dUBg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v5 02/10] io_uring: add support for IORING_OP_MKDIRAT
Message-ID: <5a6e1315-4034-0494-878a-a417e8294519@gmail.com>
Date:   Wed, 7 Jul 2021 15:06:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA6va=89pLayQgC20QvPeTE0Tp-+TmgJLKy+O2KKw8dUBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/21 9:17 AM, Dmitry Kadashev wrote:
> On Thu, Jun 24, 2021 at 7:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/24/21 12:11 PM, Dmitry Kadashev wrote:
>>> On Wed, Jun 23, 2021 at 6:54 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 6/23/21 7:41 AM, Dmitry Kadashev wrote:
>>>>> I'd imagine READ_ONCE is to be used in those checks though, isn't it? Some of
>>>>> the existing checks like this lack it too btw. I suppose I can fix those in a
>>>>> separate commit if that makes sense.
>>>>
>>>> When we really use a field there should be a READ_ONCE(),
>>>> but I wouldn't care about those we check for compatibility
>>>> reasons, but that's only my opinion.
>>>
>>> I'm not sure how the compatibility check reads are special. The code is
>>> either correct or not. If a compatibility check has correctness problems
>>> then it's pretty much as bad as any other part of the code having such
>>> problems, no?
>>
>> If it reads and verifies a values first, e.g. index into some internal
>> array, and then compiler plays a joke and reloads it, we might be
>> absolutely screwed expecting 'segfaults', kernel data leakages and all
>> the fun stuff.
>>
>> If that's a compatibility check, whether it's loaded earlier or later,
>> or whatever, it's not a big deal, the userspace can in any case change
>> the memory at any moment it wishes, even tightly around the moment
>> we're reading it.
> 
> Sorry for the slow reply, I have to balance this with my actual job that
> is not directly related to the kernel development :)
> 
> I'm no kernel concurrency expert (actually I'm not any kind of kernel
> expert), but my understanding is READ_ONCE does not just mean "do not
> read more than once", but rather "read exactly once" (and more than
> that), and if it's not applied then the compiler is within its rights to
> optimize the read out, so the compatibility check can effectively be
> disabled.

Yep, as they say it's about all the "inventive" transformations
compilers can do, double read is just one of those that may turn very
nasty for us.

One big difference for me is whether it have a potential to crash the
kernel or not, though it's just one side.

Compilers can't drop the check just because, it first should be proven
to be safe to do, and there are all sorts barriers around and
limitations on how CQEs and SQEs are used, making impossible to alias
memory. E.g. CQEs and SQEs can't be reused in a single syscall, they're
only written and read respectively, and so on. Maybe, the only one I'd
worry about is the call to io_commit_sqring(), i.e. for SQE reads not
happening after it, but we need to take a look whether it's
theoretically possible.

> I don't think it's likely to happen, but "bad things do not happen in
> practice" and "it is technically correct" are two different things :)
> 
> FWIW I'm not arguing it has to be changed, I just want to understand
> things better (and if it helps to spot a bug at some point then great).
> So if my reasoning is wrong then please point out where. And if it's
> just the simplicity / clarity of the code that is the goal here and any
> negative effects are considered to be unlikely then it's OK, I can
> understand that.

-- 
Pavel Begunkov
