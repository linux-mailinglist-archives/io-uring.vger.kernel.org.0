Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15ED73B1AE1
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 15:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhFWNQN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 09:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhFWNQN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 09:16:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018ADC061574;
        Wed, 23 Jun 2021 06:13:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t3so3406675edc.7;
        Wed, 23 Jun 2021 06:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XlBBiIGTRm7Oai8doeMQtkjznNqlbG6xm7nxthjIP90=;
        b=t0MRikB6PJUqSUgfSZe+g1ak4K6b65U8FTqBVFk9Y/fpTkkyfwnGdlNbgq7D04SZCI
         0WEhiPdZKY8QhJkDVkgvcmPPkHPRybImqYhs3GEtqvzFdXOpfmIgc6aTL/2e/mdhKBMH
         aptRkCfRHBtmDkzWZIH34qOwZlGjlFadSf3T5aRdQkyhUm2xT1YvItS3bSvjrbX63Lke
         6kH0K8/g0yXgh8G+fN2/d7cc/CCYHwuRMenZ0WyDN9gomjpYHN6y6BqkGLkmCw4wrPZs
         x+34cAWqx0I/X6V9C5bwEeOzGOBMLAi9edmPoPSluu9q9Txjn7CoaxIUSek7hwMLQ+ee
         baZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XlBBiIGTRm7Oai8doeMQtkjznNqlbG6xm7nxthjIP90=;
        b=tb14lj3ImoP3OLCEyqUEqnUAxcNaW+XpG3Kuwr4Z10+WyXoELqNSG1d06shsc7Dyej
         h1mO1SuTuJNHximGrgPk9uLRS3858K+YmprRcPu+yycz/9Gv7W4fOzVZk0qLxXdYi4yX
         ped7/rVQeBTL8Unb6n+5AngDkqnDPdkN4ce7haAO8qqlCZhjH7+I4aFMWv5B2jIseuLv
         6YjJg1zJOMLV8hf3B8oUH8cNPGaiC7ZuiLvSzCaKcUugBDIZngqHNtIoJy/m3X3uNXlt
         9JHuzTH77WVVraSagTupAY5VEtaFm8lrSaztPktAtwVGaiRDP3FBz/F+vZ99HMsQt2Kg
         HKnQ==
X-Gm-Message-State: AOAM532WyPDlUcWpbL3OJRcHsnvl/8T+joszKJwDl0plWvUMu15RUGng
        MpNFfiP+vxVRRA89qTgFC6k3gwbQcHQJZgza
X-Google-Smtp-Source: ABdhPJzTl5Tr9pPE96f74cUW2UVthnGsduw+xoTdTlb67PRHCssic6TXZeXErCQNDj5TBu4R9mK8yw==
X-Received: by 2002:aa7:c84a:: with SMTP id g10mr12114473edt.326.1624454033485;
        Wed, 23 Jun 2021 06:13:53 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:ccb1])
        by smtp.gmail.com with ESMTPSA id gv20sm7333427ejc.23.2021.06.23.06.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:13:53 -0700 (PDT)
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-10-dkadashev@gmail.com>
 <77b4b24f-b905-ed36-b70e-657f08de7fd1@gmail.com>
 <CAOKbgA71puEF4Te+svaRD1MRYEpkQOLigq5xQu85Ch4rDO7_Rw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v5 09/10] io_uring: add support for IORING_OP_LINKAT
Message-ID: <2f18e4f1-60b6-0f50-f137-a08a8a2fa6af@gmail.com>
Date:   Wed, 23 Jun 2021 14:13:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA71puEF4Te+svaRD1MRYEpkQOLigq5xQu85Ch4rDO7_Rw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 7:09 AM, Dmitry Kadashev wrote:
> On Tue, Jun 22, 2021 at 6:48 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>> IORING_OP_LINKAT behaves like linkat(2) and takes the same flags and
>>> arguments.
>>>
>>> In some internal places 'hardlink' is used instead of 'link' to avoid
>>> confusion with the SQE links. Name 'link' conflicts with the existing
>>> 'link' member of io_kiocb.
>>>
>>> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
>>> Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
>>> ---
>>>  fs/internal.h                 |  2 ++
>>>  fs/io_uring.c                 | 67 +++++++++++++++++++++++++++++++++++
>>>  fs/namei.c                    |  2 +-
>>>  include/uapi/linux/io_uring.h |  2 ++
>>>  4 files changed, 72 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/internal.h b/fs/internal.h
>>> index 3b3954214385..15a7d210cc67 100644
>>> --- a/fs/internal.h
>>> +++ b/fs/internal.h
>>
>> [...]
>>> +
>>> +static int io_linkat(struct io_kiocb *req, int issue_flags)
>>> +{
>>> +     struct io_hardlink *lnk = &req->hardlink;
>>> +     int ret;
>>> +
>>> +     if (issue_flags & IO_URING_F_NONBLOCK)
>>> +             return -EAGAIN;
>>> +
>>> +     ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
>>> +                             lnk->newpath, lnk->flags);
>>
>> I'm curious, what's difference b/w SYMLINK and just LINK that
>> one doesn't use old_dfd and another does?
> 
> Symlink's content does not have to exist, it's pretty much an arbitrary string.
> E.g. try `ln -s http://example.com/ foo` :)
> 
>> Can it be supported/wished by someone in the future?
> 
> I don't really know. I guess it could be imagined that someone wants to try and
> resolve the full target name against some dfd. But to me the whole idea looks
> inherently problematic. Accepting the old dfd feels like the path is going to
> be resolved, and historically it is not the case, and we'd need a special dfd
> value to mean "do not resolve", and AT_FDCWD won't work for this (since it
> means "resolve against the CWD", not "do not resolve").

I see, I don't know it good enough to reason, but have to throw the question
into the air, ...

>> In that case I'd rather reserve and verify a field for old_dfd for both, even
>> if one won't really support it for now.
> 
> If I understand you correctly, at this point you mean just checking that
> old_dfd is not set (i.e. == -1)? I'll add a check.

... and we have all 5.14 to fix it and other parts if needed, so let's
leave it as is

-- 
Pavel Begunkov
