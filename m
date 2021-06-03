Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B083399F43
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 12:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFCKxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 06:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFCKxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 06:53:55 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65789C06174A;
        Thu,  3 Jun 2021 03:51:55 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so6545049edu.10;
        Thu, 03 Jun 2021 03:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2l+/pTIkSAMgANRmwouFqdl/kEDa6lMjdLO01s6/yys=;
        b=Y2uPxWyhic09EXZIQ1ZF0iBGPh1sHCEKHj8LJc8Y7bFnP5EBQKLbaJb55cbQq8na12
         5SfIwlcAWnnlflpxnBs4tQtdlG/xJA2tiavyAhRNUpvGlzqpljysnyiUBe+jxVCg2KBN
         g6WLOmaVonCYtJy2FbaYuHFiER2766XM8w4vv7MccGhkExsDKOho78FeGwj5enXDtNSh
         C5udtDfu8IUtB0vsLylyMvG37hhKDMzjFZdxkdmFNrJHquN+zrhs3ZUqtL9Ggwa2ck9n
         pxfszCA2T729GMJxnEscxsRZuVq12RCzkMuoqXRYIasSzMKtX0QZAKyQcIjGwCCxnExZ
         O95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2l+/pTIkSAMgANRmwouFqdl/kEDa6lMjdLO01s6/yys=;
        b=ZQF1SyjMEADl0tNCcHYSMGWDuC8f5j+lfCf1ktZ3zc5JaXuq8BvvBK4YgJmwoWRhS/
         /gek6DkpmrDscSrnVZUcmqfCmB6gViC09Yf09VpyjTMBt7XwAk6Pfpp3wKjjCYi7HqOh
         VdiKtY/gaYQdTUeOqpuv5bulaFTVxhttalis512hVrVawnAjQyY8WzIhvrnMaysVXq42
         BS0qt/gnBd2o4DFn1Hq4J4CmXKPMt+KNyqTEopIIhD/fhgCZZZnjUGOQ1qxYSNriZtOX
         m64Dmm0K85H2//XopaE5FYbDPOaQ010BzxVsyEKXZrWtZ3QBxybG3UYXvjO8eqlu92jI
         lJDw==
X-Gm-Message-State: AOAM530+fcBKFlKsPA0viocwzV4xrHPrysXG7YAuF3Pcxo/wlc3stFhy
        A2d02r5F6BJ4t3a3Gl8wR0M=
X-Google-Smtp-Source: ABdhPJxUc5fUcgMU/ObpolC/f7QYCa63xLFOrtM2BNvy8DNUPsv88nO1fflfb7VAyJ9Z3Q1MegcQMA==
X-Received: by 2002:a05:6402:34cb:: with SMTP id w11mr20794266edc.299.1622717513978;
        Thu, 03 Jun 2021 03:51:53 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:6c45])
        by smtp.gmail.com with ESMTPSA id o21sm1343631ejh.57.2021.06.03.03.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 03:51:53 -0700 (PDT)
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
 <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
 <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk>
 <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
 <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
 <CAHC9VhS7Vhby4YR94U2YOwMtva-rc=_ifRcZYi1YVPwfi+Xuzg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <41bc1351-b07b-d9de-f7e3-8c58be14ba9f@gmail.com>
Date:   Thu, 3 Jun 2021 11:51:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhS7Vhby4YR94U2YOwMtva-rc=_ifRcZYi1YVPwfi+Xuzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/21 8:46 PM, Paul Moore wrote:
> On Wed, Jun 2, 2021 at 4:27 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 5/28/21 5:02 PM, Paul Moore wrote:
>>> On Wed, May 26, 2021 at 4:19 PM Paul Moore <paul@paul-moore.com> wrote:
>>>> ... If we moved the _entry
>>>> and _exit calls into the individual operation case blocks (quick
>>>> openat example below) so that only certain operations were able to be
>>>> audited would that be acceptable assuming the high frequency ops were
>>>> untouched?  My initial gut feeling was that this would involve >50% of
>>>> the ops, but Steve Grubb seems to think it would be less; it may be
>>>> time to look at that a bit more seriously, but if it gets a NACK
>>>> regardless it isn't worth the time - thoughts?
>>>>
>>>>   case IORING_OP_OPENAT:
>>>>     audit_uring_entry(req->opcode);
>>>>     ret = io_openat(req, issue_flags);
>>>>     audit_uring_exit(!ret, ret);
>>>>     break;
>>>
>>> I wanted to pose this question again in case it was lost in the
>>> thread, I suspect this may be the last option before we have to "fix"
>>> things at the Kconfig level.  I definitely don't want to have to go
>>> that route, and I suspect most everyone on this thread feels the same,
>>> so I'm hopeful we can find a solution that is begrudgingly acceptable
>>> to both groups.
>>
>> May work for me, but have to ask how many, and what is the
>> criteria? I'd think anything opening a file or manipulating fs:
>>
>> IORING_OP_ACCEPT, IORING_OP_CONNECT, IORING_OP_OPENAT[2],
>> IORING_OP_RENAMEAT, IORING_OP_UNLINKAT, IORING_OP_SHUTDOWN,
>> IORING_OP_FILES_UPDATE
>> + coming mkdirat and others.
>>
>> IORING_OP_CLOSE? IORING_OP_SEND IORING_OP_RECV?
>>
>> What about?
>> IORING_OP_FSYNC, IORING_OP_SYNC_FILE_RANGE,
>> IORING_OP_FALLOCATE, IORING_OP_STATX,
>> IORING_OP_FADVISE, IORING_OP_MADVISE,
>> IORING_OP_EPOLL_CTL
> 
> Looking quickly at v5.13-rc4 the following seems like candidates for
> auditing, there may be a small number of subtractions/additions to
> this list as people take a closer look, but it should serve as a
> starting point:
> 
> IORING_OP_SENDMSG
> IORING_OP_RECVMSG
> IORING_OP_ACCEPT
> IORING_OP_CONNECT
> IORING_OP_FALLOCATE
> IORING_OP_OPENAT
> IORING_OP_CLOSE
> IORING_OP_MADVISE
> IORING_OP_OPENAT2
> IORING_OP_SHUTDOWN
> IORING_OP_RENAMEAT
> IORING_OP_UNLINKAT
> 
> ... can you live with that list?

it will bloat binary somewhat, but considering it's all in one
place -- io_issue_sqe(), it's workable.

Not nice to have send/recv msg in the list, but I admit they
may do some crazy things. What can be traced for them? Because
at the moment of issue_sqe() not everything is read from the
userspace.

see: io_sendmsg() { ...; io_sendmsg_copy_hdr(); },

will copy header only in io_sendmsg() in most cases, and
then stash it for re-issuing if needed.


>> Another question, io_uring may exercise asynchronous paths,
>> i.e. io_issue_sqe() returns before requests completes.
>> Shouldn't be the case for open/etc at the moment, but was that
>> considered?
> 
> Yes, I noticed that when testing the code (and it makes sense when you
> look at how io_uring handles things).  Depending on the state of the
> system when the io_uring request is submitted I've seen both sync and
> async io_uring operations with the associated different calling
> contexts.  In the case where io_issue_sqe() needs to defer the
> operation to a different context you will see an audit record
> indicating that the operation failed and then another audit record
> when it completes; it's actually pretty interesting to be able to see
> how the system and io_uring are working.

Copying a reply to another message to keep clear out
of misunderstanding.

"io_issue_sqe() may return 0 but leave the request inflight,
which will be completed asynchronously e.g. by IRQ, not going
through io_issue_sqe() or any io_read()/etc helpers again, and
after last audit_end() had already happened.
That's the case with read/write/timeout, but is not true for
open/etc."

And there is interest in async send/recv[msg] as well (via
IRQ as described, callbacks, etc.).
 
> We could always mask out these delayed attempts, but at this early
> stage they are helpful, and they may be useful for admins.
> 
>> I don't see it happening, but would prefer to keep it open
>> async reimplementation in a distant future. Does audit sleep?
> 
> The only place in the audit_uring_entry()/audit_uring_exit() code path
> that could sleep at present is the call to audit_log_uring() which is
> made when the rules dictate that an audit record be generated.  The
> offending code is an allocation in audit_log_uring() which is
> currently GFP_KERNEL but really should be GFP_ATOMIC, or similar.  It
> was a copy-n-paste from the similar syscall function where GFP_KERNEL
> is appropriate due to the calling context at the end of the syscall.
> I'll change that as soon as I'm done with this email.

Ok, depends where it steers, but there may be a requirement to
not sleep for some hooks because of not having a sleepable context.

> 
> Of course if you are calling io_uring_enter(2), or something similar,
> then audit may sleep as part of the normal syscall processing (as
> mentioned above), but that is due to the fact that io_uring_enter(2)
> is a syscall and not because of anything in io_issue_sqe().
> 

-- 
Pavel Begunkov
