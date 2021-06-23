Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350F63B1972
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 13:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFWMAi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 08:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhFWMAh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 08:00:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BBDC061574;
        Wed, 23 Jun 2021 04:58:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id nb6so3579732ejc.10;
        Wed, 23 Jun 2021 04:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WK/HISxtTDClzpLnEMoc9YQ1CVO76vHxT1gzzdpEwQU=;
        b=if1bPksMNeotQxN9zAr7M12E8fRG0Gv+EE46i6NBDXQ2dKFK2iE72I1Lh4oUtPh6dF
         orQK5MCKMaJ0Z79qLGA8HdDHgbGvYZQp3khOuAj3zeJbeIMr8N3alPPBG81xw11zlaU6
         Ev4cP10btfb1EhT7SHLuBF+GA8P0IWWmPWfUXTPX+KKjNb+J8TP5cFiiTqZZI1ik4At8
         SwIiZ9oq/OxM4SuswKX/X1MZm93VrmVKT0cNVjKl6T4r0v3oKB4Nq8lPDqUYc95kEoyA
         kkKEQ+TGU9Vcd92UUZHWn4OiIxXpd5O/r8fjksuXMYa2RHHitE4egbVXwCpplnxpWRi4
         KIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WK/HISxtTDClzpLnEMoc9YQ1CVO76vHxT1gzzdpEwQU=;
        b=LrpSLa3Tw/jSlg7R/TJk3Zb8ed2gnuLwkHhNf+Nnuu2J7t4+jwq4qziXONSK33HV5a
         GLsKRSYrcl7xuJmZSSGfVvI5EpUV6+JxV3dN7mpzl1pjfvs7ojYR6j3AOv8MvSz1OKOe
         bh5VB9OwtUXaQdunxBWMU/TYIbUZOn5LyzTwr6k4CIkRUetjFX0GU1genXlJss7ic7wT
         xSdu9EADXeN5W3cgSto753JgqRILsChX4o3BuaJqvsVpMc8CfpIeGau0LORS1wSyiQq9
         8MWzhCEwyv8BgHILoM2+zq5X0YE/ICKT1x3y484KLw0C0FNtfOb0c9CQyRWF4eOaRrbs
         qG+A==
X-Gm-Message-State: AOAM531ofc24QUUhrPwSBHxmD/Eo555ON7RCnklxOZSd0ByvB5Y5cRNz
        VjhKb9krEeUE8R+1sIMuemSh6nqm1benp6oi
X-Google-Smtp-Source: ABdhPJz83a5s6bIhbPcUB2llURLwCSqlxWx808a4ng9SvOvVQSx4PgJYvgXVaPhp1XcjtS4a/kH2Pg==
X-Received: by 2002:a17:906:ce4f:: with SMTP id se15mr9699363ejb.232.1624449497745;
        Wed, 23 Jun 2021 04:58:17 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:6d82])
        by smtp.gmail.com with ESMTPSA id d6sm3280739edq.37.2021.06.23.04.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 04:58:17 -0700 (PDT)
Subject: Re: [PATCH v5 10/10] io_uring: add support for IORING_OP_MKNODAT
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-11-dkadashev@gmail.com>
 <1a3812fe-1e57-a2ad-dc19-9658c0cf613b@gmail.com>
 <CAOKbgA489C=ZS_E6YCBFxo+zYNb5ccE4dfFBntAO=qNH7_Uu=A@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <66153284-5989-00be-7d57-2a4cb75aedc7@gmail.com>
Date:   Wed, 23 Jun 2021 12:58:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA489C=ZS_E6YCBFxo+zYNb5ccE4dfFBntAO=qNH7_Uu=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 7:26 AM, Dmitry Kadashev wrote:
> On Tue, Jun 22, 2021 at 6:52 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>> IORING_OP_MKNODAT behaves like mknodat(2) and takes the same flags and
>>> arguments.
>>>
>>> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
>>> Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
>>> ---
>>>  fs/internal.h                 |  2 ++
>>>  fs/io_uring.c                 | 56 +++++++++++++++++++++++++++++++++++
>>>  fs/namei.c                    |  2 +-
>>>  include/uapi/linux/io_uring.h |  2 ++
>>>  4 files changed, 61 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/internal.h b/fs/internal.h
>>> index 15a7d210cc67..c6fb9974006f 100644
>>
>> [...]
>>
>>>  static bool io_disarm_next(struct io_kiocb *req);
>>> @@ -3687,6 +3697,44 @@ static int io_linkat(struct io_kiocb *req, int issue_flags)
>>>       io_req_complete(req, ret);
>>>       return 0;
>>>  }
>>> +static int io_mknodat_prep(struct io_kiocb *req,
>>> +                         const struct io_uring_sqe *sqe)
>>> +{
>>> +     struct io_mknod *mkn = &req->mknod;
>>> +     const char __user *fname;
>>> +
>>> +     if (unlikely(req->flags & REQ_F_FIXED_FILE))
>>> +             return -EBADF;
>>
>> IOPOLL won't support it, and the check is missing.
>> Probably for other opcodes as well.
>>
>> if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>         return -EINVAL;
> 
> This change is based on some other similar opcodes (unlinkat, renameat) that
> were added a while ago. Those lack the check as well. I guess I'll just prepare
> a patch that adds the checks to all of them. Thanks, Pavel.
> 
> Jens, separately it's my understanding that you do not want the MKNODAT opcode
> at all, should I drop this from the subsequent series?

I guess that comment was to my note that the patch with it
doesn't compile, but as it should be already fixed up...

-- 
Pavel Begunkov
