Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6165638DCD2
	for <lists+io-uring@lfdr.de>; Sun, 23 May 2021 22:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhEWU17 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 May 2021 16:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhEWU16 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 May 2021 16:27:58 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9558CC061574;
        Sun, 23 May 2021 13:26:31 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so430293wmk.1;
        Sun, 23 May 2021 13:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PygufLx+GftT6TS2etBhgc6+uuLN9BWMi/zqgHpQvsY=;
        b=esrTniYlKVIz1qwncB0fA1f6EoaGdXdv9Byf2wrzoXpJoI8ojdqkT7UMYtQ9tQdySr
         dSSenwaL0uFN0kSScz4CSe6aF58av5EQOYX0crNgBe7TucIZqRPeRPClZzCZd7yi8vWW
         O8nk+31pXBR9ihIKwxvRsCSxf62JDvRBeSK/GiTZ2dw/RpQpabwMEsy6xgjhQ8CbfoP5
         QLmJcJBTT4BYTPrUanoQCVObQvlzPbKoVnKLRz+H90+AnrvDsodYtO/tWjJExz5Adju5
         /lQx48WoVzuaUsfWYwEcjGsVXZwjY1oR64OEuEmYacUMdOdrwAbXifj7z1hl61xv6RDW
         +kLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PygufLx+GftT6TS2etBhgc6+uuLN9BWMi/zqgHpQvsY=;
        b=gLXj6Ac2l8Z0G8Ix7wJnc9AgD1h16l/ooQAG8LPDBLhJRKDmTde+2jT9rWquNdmVn3
         Md7APd2kH4SdX6St8WqxD7yMXx9Iten6ufr0VHC0WGQkIyW5Ak8f8C/uoMhZzmaR2tiB
         6JItb7srFisF6oH6TE6C7ItzXHlE/OdaVqhaw3IEYSOHnGDQu757ijliAYkJ2JSsU2xn
         uzHPjXOKYNo0Ze9KarabMK5jOFoIqx0ksVb8ZB3eby68thNsFxg8Ca0W+8cEWMduPzWi
         /4EBFZBbJnzbXuwgOftwH1hB7GwDjzgecb4o8aXEi+yc+eu1LziUfp1TvNfE/Dpeviem
         txuA==
X-Gm-Message-State: AOAM530hZhyBzj4zpbyxDDarbQ2COhHDISIQ/FtVtmVQ8RfG+EpucDLj
        GXs5F+cF11eqJSCVw6prF00F51Z0/rE0jefX
X-Google-Smtp-Source: ABdhPJwHSQNM+a1cD2dybYGpeqrMJbBTrEBwBzdhWHyWUNWiVsmNBtsEauiH5obSA1GKRpi7NeXYOw==
X-Received: by 2002:a1c:4b13:: with SMTP id y19mr17332089wma.102.1621801590115;
        Sun, 23 May 2021 13:26:30 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id 11sm5855772wmo.24.2021.05.23.13.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 13:26:29 -0700 (PDT)
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
Date:   Sun, 23 May 2021 21:26:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/21 3:36 AM, Paul Moore wrote:
> On Fri, May 21, 2021 at 8:22 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 5/21/21 10:49 PM, Paul Moore wrote:
[...]
>>>
>>> +     if (req->opcode < IORING_OP_LAST)
>>
>> always true at this point
> 
> I placed the opcode check before the audit call because the switch
> statement below which handles the operation dispatching has a 'ret =
> -EINVAL' for the default case, implying that there are some paths
> where an invalid opcode could be passed into the function.  Obviously
> if that is not the case and you can guarantee that req->opcode will
> always be valid we can easily drop the check prior to the audit call.

It is always true at this point, would be completely broken
otherwise

>>> +             audit_uring_entry(req->opcode);
>>
>> So, it adds two if's with memory loads (i.e. current->audit_context)
>> per request in one of the hottest functions here... No way, nack
>>
>> Maybe, if it's dynamically compiled into like kprobes if it's
>> _really_ used.
> 
> I'm open to suggestions on how to tweak the io_uring/audit
> integration, if you don't like what I've proposed in this patchset,
> lets try to come up with a solution that is more palatable.  If you
> were going to add audit support for these io_uring operations, how
> would you propose we do it?  Not being able to properly audit io_uring
> operations is going to be a significant issue for a chunk of users, if
> it isn't already, we need to work to find a solution to this problem.

Who knows. First of all, seems CONFIG_AUDIT is enabled by default
for many popular distributions, so I assume that is not compiled out.

What are use cases for audit? Always running I guess? Putting aside
compatibility problems, it sounds that with the amount of overhead
it adds there is no much profit in using io_uring in the first place.
Is that so?

__audit_uring_exit()
-> audit_filter_syscall()
  -> for (audit_list) if (...) audit_filter_rules()
    -> ...
-> audit_filter_inodes()
  -> ...

> Unfortunately I don't think dynamically inserting audit calls is
> something that would meet the needs of the audit community (I fear it
> would run afoul of the various security certifications), and it
> definitely isn't something that we support at present.

I see

-- 
Pavel Begunkov
