Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0783399F23
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 12:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFCKmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 06:42:20 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:41958 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhFCKmU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 06:42:20 -0400
Received: by mail-ej1-f52.google.com with SMTP id gb17so8491603ejc.8;
        Thu, 03 Jun 2021 03:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jjgngqqiD1MzF4drjDhfJO81FwwmSm8rHRAQDoLI4hk=;
        b=i5zdCu7eh+exc3xVtGwn/14tE99F9S6SruDvOQWgTazyiiWQej8zLeVr2UmL4UvcE4
         feRfK8yNI/0EVqCRgzt4FDrXsFhXitU/G5Kr7vmnJy2h8CxxTlQ/mY4WUjlcrqgE0epg
         0GrCkvW1TMNs5xoY5poEBZlfW50G0Ay6IkEFxzGZzaibL52u8IlG09QzmHMajSdAg+dH
         zzEnJcXMVB6R+FW3kgS0AYEoJyv8HlB6kTD/1F/5+vqfFNTH4qS80g7stAYowIr7O4i6
         Ir6CJRD/7o6g7jZ9q+1XbuPqThLD+ES/asQm7haHvhoahEOgULrRGaITDwkKWtLHhB2y
         fFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjgngqqiD1MzF4drjDhfJO81FwwmSm8rHRAQDoLI4hk=;
        b=KF7M7MHyQ72Lgsz9h4BAaNPN7OqToOkulRHxtxfp6wxNzBKAsPyW4GcuUud2Lr/dUs
         DTX94thpJ1fQvGaWS+xKkh2Nb7xR0NTQCmTx0US4mNQZ0Xe5rhRy0pw+9jwYEDRj5P2F
         CXJ2rSCW4azglrH+G9IQB9nu0t67oiVDv995b/5g9IIlIqwi0QNOC2oPTEQVxWcOIaJW
         R/rPNDmdotlHCM+J5398FYhnUdLDypfuav1YuvkYB/Ae21I6X/V0vktryn4cOz3IPi/S
         NndfA/9vm3qSRMlkqqbLctn6yRF+iMrWauRHQsSeOgaDYCmzG7U7uvAqpy5EJjrV/o7y
         5aTw==
X-Gm-Message-State: AOAM533SluP/l9klCIlVrqwU3ZB8/dultsiXwI7T45BbgRUE0W3YIKUK
        uuLwYL+T6J4+E1xtJSZd6xU=
X-Google-Smtp-Source: ABdhPJxBNyhzAnY+FdObN7pnTAta+DGpnvQFV2i3L7an+ohCIQSKtw/KtDZc/3aOtErcO8sTHGd/6Q==
X-Received: by 2002:a17:906:af7b:: with SMTP id os27mr23608805ejb.154.1622716761257;
        Thu, 03 Jun 2021 03:39:21 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:6c45])
        by smtp.gmail.com with ESMTPSA id s2sm1565455edu.89.2021.06.03.03.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 03:39:20 -0700 (PDT)
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
 <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
 <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk>
 <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
 <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
 <20210602154638.GA3711857@madcap2.tricolour.ca>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <dc48fc10-d4f8-4592-02e1-f24094df801a@gmail.com>
Date:   Thu, 3 Jun 2021 11:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210602154638.GA3711857@madcap2.tricolour.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/21 4:46 PM, Richard Guy Briggs wrote:
> On 2021-06-02 09:26, Pavel Begunkov wrote:
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
>>
>>
>> Another question, io_uring may exercise asynchronous paths,
>> i.e. io_issue_sqe() returns before requests completes.
>> Shouldn't be the case for open/etc at the moment, but was that
>> considered?
> 
> This would be why audit needs to monitor a thread until it wraps up, to
> wait for the result code.  My understanding is that both sync and async
> parts of an op would be monitored.

There may be a misunderstanding

audit_start(req)
ret = io_issue_sqe(req);
audit_end(ret);

io_issue_sqe() may return 0 but leave the request inflight,
which will be completed asynchronously e.g. by IRQ, not going
through io_issue_sqe() or any io_read()/etc helpers again, and
after last audit_end() had already happened.
That's the case with read/write/timeout, but is not true for
open/etc.

>> I don't see it happening, but would prefer to keep it open
>> async reimplementation in a distant future. Does audit sleep?
> 
> Some parts do, some parts don't depending on what they are interacting
> with in the kernel.  It can be made to not sleep if needed.

Ok, good

-- 
Pavel Begunkov
