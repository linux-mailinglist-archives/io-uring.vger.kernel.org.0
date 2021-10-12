Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7842A372
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 13:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhJLLl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 07:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbhJLLl4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 07:41:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3E6C061570
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 04:39:54 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id i20so63428245edj.10
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 04:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=qmMcC50MGvcfhIVy+eUt7L3TPYhU9WJT78QWLPOgqqc=;
        b=Vin4ZO8oWn3gI20FgTyFRItVHY0cTTK0YFN5ipxgVqIb583Sd7dfWQkQsEqWie0/BB
         MxXmVVoq/lc753r/BGAYnvVvpED2S0YlbDykFkMy/h0ySbdesXbriTBphyYmwTUxRIr4
         ah/Sc7iCyufAtv7V7Fa4XBrhVEBBzqOpMPe4g5cVyKrUofu4GAdvt32R7S+Q/r/+vDpe
         g7s11h5c5TWqELnWSvPORxkqq9F9xwvrufLK6bh2xgt/kxGyD01rPs7xYzB5NXvnbi/0
         dSdbu4Vykma/RmgrVXTm8m9i0Oy9yHWRRvlZBFu2ndOnWLBocopcP0rzJIiUTteVIAYn
         t+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=qmMcC50MGvcfhIVy+eUt7L3TPYhU9WJT78QWLPOgqqc=;
        b=0rT/CRSr7AeYY/cfMwfV5BqN/HcCPKaUmPVIVbuEmR6TWK7Cs4NEeRIrFzMT7tp3u2
         xr/yXLJy1XJaH0/xacj+WqOos0gXeVX5o4lqRS5Lt3US7U6/4KfKCjDpI1RbPB08XHPK
         vvY82W7KWEYJJi2wdVtXKTktZjyVjvxhAfX8DuEtiQqd1fntqbkcHTN6Pan2msssGMJA
         efAAL2SlgTvO+aXsChzzCIVUFBX4y7faH8P6CW84aPAX1sgq4Z82CkM0OpAVAK21+S2j
         yfdZvTHmr8vw3RG7ijvyuJc44ksAvMBP2jQKjOwt+J1iBL12stMV9ZsMBuAlstKihOAf
         thsg==
X-Gm-Message-State: AOAM533Cl2Lex8RYN5PfrIukB7O1sCWNy38By4Ne4+ATk574jexd8Cbc
        puz/9br+pLBtXKoN+oW0XV62tx912Wg=
X-Google-Smtp-Source: ABdhPJwYRnse35kUNiJosOkQjRrNqvuuiyn8RocrqIoNuIp7iW3ZTYISteOAQTE3U/oIRiIKz+xBVg==
X-Received: by 2002:a17:907:77c8:: with SMTP id kz8mr15865379ejc.188.1634038792054;
        Tue, 12 Oct 2021 04:39:52 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.215])
        by smtp.gmail.com with ESMTPSA id 6sm4811661ejx.82.2021.10.12.04.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 04:39:51 -0700 (PDT)
Message-ID: <16da92ff-39a5-2126-0f12-225017d4d825@gmail.com>
Date:   Tue, 12 Oct 2021 12:39:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
 <57f4b76d-6148-98e2-3550-8fde5a4638f7@gmail.com>
 <c0602c8a-d08d-7a0d-0639-ac2ca8d836b1@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH for-5.16 0/2] async hybrid, a new way for pollable
 requests
In-Reply-To: <c0602c8a-d08d-7a0d-0639-ac2ca8d836b1@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/21 04:08, Hao Xu wrote:
> 在 2021/10/9 下午8:51, Pavel Begunkov 写道:
>> On 10/8/21 13:36, Hao Xu wrote:
>>> this is a new feature for pollable requests, see detail in commit
>>> message.
>>
>> It really sounds we should do it as a part of IOSQE_ASYNC, so
>> what are the cons and compromises?
> I wrote the pros and cons here:
> https://github.com/axboe/liburing/issues/426#issuecomment-939221300

I see. The problem is as always, adding extra knobs, which users
should tune and it's not exactly clear where to use what. Not specific
to the new flag, there is enough confusion around IOSQE_ASYNC, but it
only makes it worse. It would be nice to have it applied
"automatically".

Say, with IOSQE_ASYNC the copy is always (almost) done by io-wq but
there is that polling optimisation on top. Do we care enough about
copying specifically in task context to have a different flag?

a quick question, what is "tps" in "IOSQE_ASYNC: 76664.151 tps"?

>>> Hao Xu (2):
>>>    io_uring: add IOSQE_ASYNC_HYBRID flag for pollable requests
>>
>> btw, it doesn't make sense to split it into two patches
> Hmm, I thought we should make adding a new flag as a separate patch.
> Could you give me more hints about the considerration here?

You can easily ignore it, just looked weird to me. Let's try to
phrase it:

1) 1/2 doesn't do anything useful w/o 2/2, iow it doesn't feel like
an atomic change. And it would be breaking the userspace, if it's
not just a hint flag.

2) it's harder to read, you search the git history, find the
implementation (and the flag is already there), you think what's
happening here, where the flag was used and so to find out that
it was added separately a commit ago.

3) sometimes it's done similarly because the API change is not
simple, but it's not the case here.
By similarly I mean the other way around, first implement it
internally, but not exposing any mean to use it, and adding
the userspace API in next commits.

>>>    io_uring: implementation of IOSQE_ASYNC_HYBRID logic
>>>
>>>   fs/io_uring.c                 | 48 +++++++++++++++++++++++++++++++----
>>>   include/uapi/linux/io_uring.h |  4 ++-
>>>   2 files changed, 46 insertions(+), 6 deletions(-)
>>>
>>
> 

-- 
Pavel Begunkov
