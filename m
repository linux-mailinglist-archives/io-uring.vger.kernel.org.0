Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7996D47C970
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 23:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhLUW52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 17:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbhLUW52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 17:57:28 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19411C06173F
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 14:57:28 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id y70so551695iof.2
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 14:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GZc/7ZbH80zC5cZbjEHIRFQalI0TJV7npC3ThbE1068=;
        b=AfVHqoowFQhemrl86UNEvokPR8AzUWdEcJbCKYeZc20EXT0H+xAEOT2XVzlgWaEGqg
         8StzWJoXeg84vjNilDMuqRTPfd2CpR5syTkFzMElK3MW9jW5V8pOncBbjoLtz1lI8j/b
         zeAO/tee7HyBdNgS8Jxv+gvxqYhHoWP0Sbf2QvYpr8nACGrE5f6puzjltR70/yoDZ81O
         MK09Z0mlEwWNAeVk3UuiL5l913HdCNqFnE8CRo+Hsbk2VwcxPCQUxivaGbTZVzeGRdx4
         0zIpja3H6t1E5y1AbFgBLFJMlfEK9FnRKkrwIMARQ7fwVrkDxzCg6Dikihc/2H2SAGWi
         E+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GZc/7ZbH80zC5cZbjEHIRFQalI0TJV7npC3ThbE1068=;
        b=lETOp+ezg+pSij5U+MKRz9q/wsSU6O1gC4M213tYoIuajveZAJ+XufTCyh60BMVF9C
         aok5/3t8WmAgjcdPxaG4HRrxU4ncizMOB/pB2gJOI6vtGjofOZUoIQE3RF4FgyTIay/m
         wROJ0RCeyBYb/QTXysFklra7uxXt+Bab+hZYTYuUcyjSFtwYAYZa6HJS8czWNYIyVJ2f
         MpuJjzXTe7QuhSkbePWbgT7hq8LpXYonNbcX9U34VBwAbE6WKLuDOy5/ezVGubmLfQbk
         6DuIclh3/asPbc/06eNAKJHfgw852pkdkI76dZayAXEGyxl6TI+TIYT5pATslSR0qeBt
         olHg==
X-Gm-Message-State: AOAM533XOGrLwVTKYIo763J7vimGEM8bjVk2oaQ1oymS8+31FGMs1n2H
        DERbqR0vPlJlxPRW+Zb/kEZh6NnOdsZceg==
X-Google-Smtp-Source: ABdhPJx7NOlVxxUYxciiB6JNSObK00DtBNXKdqBu+NtsLNMoSQsgKmeok1uiH2f0wcj1TzCzP5dnAQ==
X-Received: by 2002:a05:6602:2cce:: with SMTP id j14mr140767iow.111.1640127447433;
        Tue, 21 Dec 2021 14:57:27 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j19sm151969ila.6.2021.12.21.14.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 14:57:27 -0800 (PST)
Subject: Re: [PATCH v5 3/5] fs: split off do_getxattr from getxattr
To:     Stefan Roesch <shr@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20211221164959.174480-1-shr@fb.com>
 <20211221164959.174480-4-shr@fb.com>
 <CAHk-=whChmLy02-degmLFC9sgwpdgmF=XoAjeF1bTdHcEc8bdQ@mail.gmail.com>
 <a30eda4f-ebf2-5e46-d980-cd9d46d83e60@fb.com>
 <CAHk-=wjqUaF=Vj9f44m7SNxhANwoTCnukm6+HqWnbhhr2KHRsg@mail.gmail.com>
 <aff6327e-9727-e1a5-79bc-99557d9086aa@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7b102b63-7d21-4196-e6eb-763da25b0aee@kernel.dk>
Date:   Tue, 21 Dec 2021 15:57:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <aff6327e-9727-e1a5-79bc-99557d9086aa@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/21 2:59 PM, Stefan Roesch wrote:
> 
> 
> On 12/21/21 11:18 AM, Linus Torvalds wrote:
>> On Tue, Dec 21, 2021 at 11:15 AM Stefan Roesch <shr@fb.com> wrote:
>>>
>>> Linus, if we remove the constness, then we either need to cast away the constness (the system call
>>> is defined as const) or change the definition of the system call.
>>
>> You could also do it as
>>
>>         union {
>>                 const void __user *setxattr_value;
>>                 void __user *getxattr_value;
>>         };
>>
> 
> Pavel brought up a very good point. By adding the kname array into the
> xarray_ctx we increase the size of io_xattr structure too much. In
> addition this will also increase the size of the io_kiocb structure.
> The original solution did not increase the size.
> 
> Per opcode we limit the storage space to 64 bytes. However the array
> itself requires 256 bytes.

Just to expand on that a bit - part of struct io_kiocb is per-command
data, and we try pretty hard to keep that at 64-bytes as that's the
largest one we currently have. If we add the array to the io_xattr
structure, then that will increase the whole io_kiocb from 224 bytes to
more than twice that.

So there are really two options here:

1) The xattr_ctx structure goes into the async data that a command has
   to allocate for deferred execution. This isn't a _huge_ deal as we
   have to defer the xattr commands for now anyway, as the VFS doesn't
   support a nonblocking version of that yet. But it would still be nice
   not to have to do that.

2) We keep the original interface that Stefan proposed, leaving the
   xattr_ctx bits embedded as they fit fine like that.

#2 would be a bit more efficient, but I don't feel that strongly about
it for this particular case.

Comments?

-- 
Jens Axboe

