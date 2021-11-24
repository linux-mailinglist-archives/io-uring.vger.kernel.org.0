Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3873A45CBA9
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350117AbhKXSBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 13:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350059AbhKXSBI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 13:01:08 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1F4C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 09:57:58 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id e144so4311433iof.3
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 09:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YXuq3J0fJjqtVhtl+omi+DqvXZW2aqvwmbP0Hujl2uI=;
        b=ndQA2VXw+ouUu/L3tPOKpLHAg3LDn1W21Xgldw2MkNOssvE0npR5thP5k2bCR4Mzwg
         YrkDif6CqKOL0xDeln1PCnQWLsoah3kI3FHRqbzShfSWZx4MP0GuOH3G9X6OSFnDUzKP
         YyON4dddFa3JSXf92gLti7eF+EBBksMLbO72hGAMu6yAchleQQO/pNrFE4D8iSWNUr2a
         q7KI/fXgLf2YVeArC2Rc3JmYs/uSmcHZiWCt7PR7ZcinBzjk8xurmu0mXXJ+C6POOJLl
         kEozaHLo/svEm1ZUmX0HBCAhET+QGU0ryjYa3YnHzq2hNzh4WVge5CQuflJnulUHuXib
         m6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YXuq3J0fJjqtVhtl+omi+DqvXZW2aqvwmbP0Hujl2uI=;
        b=PHI706ydJDMWaZPIwGh3MdKa9i/qTciTzFzWL++2J6ApGK1DrpEI9/QjLgREXb4iVa
         PRu6k8pcQd9fScyrRChSjdy+MTqha12nBPJuqbp4BPbOOtYUbdIbNvN5/WJTsLX7sD4x
         bC5gx4HHdVPsOhBCE31s9U29BA6EYg4aNgIoIaYm4sDzUdDLxc+S55yN9lPPvPOLikwQ
         u8f7sLiVY4zt1DcglLf7Skvh0OXFkxAi6vhUHRm+Tr666UMEkT9IpUKtF5Vu4+4pTcWg
         vR33OUTTfiqqLw5kMUVhDo0+dqYuAncTUpW3Btoc0BKm0kDJRbdX1DsIapvnQzwFfnBj
         6Haw==
X-Gm-Message-State: AOAM530+mw3GmXnj1kogPhy92CYGhNmdWfB/6YtziXZQzQF44IYQykuJ
        ib28+AcJlVK9NYQA+vezke/l/st+N9sj6mlU
X-Google-Smtp-Source: ABdhPJyWI+LQHKTvxC/yMaa6AUuyohPkhc1hfoI/BumUjWJdeJnNDEm/kQ/Vf1jv5w9vrDOdaj0xgA==
X-Received: by 2002:a5d:9a95:: with SMTP id c21mr16261522iom.189.1637776677438;
        Wed, 24 Nov 2021 09:57:57 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i20sm360210iow.9.2021.11.24.09.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 09:57:56 -0800 (PST)
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
 <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
 <7a4f8655-06df-9549-e3df-c3bf972f06e6@kernel.dk>
 <39fad08c-f820-e4ef-6d30-4f63f00a3282@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3c9d0246-97f5-deb5-7d82-d6ba4d9aa990@kernel.dk>
Date:   Wed, 24 Nov 2021 10:57:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <39fad08c-f820-e4ef-6d30-4f63f00a3282@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 10:55 AM, Pavel Begunkov wrote:
> On 11/10/21 16:47, Jens Axboe wrote:
>> On 11/10/21 9:42 AM, Pavel Begunkov wrote:
>>> On 11/10/21 16:14, Jens Axboe wrote:
>>>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>>>> It's expensive enough to post an CQE, and there are other
>>>>> reasons to want to ignore them, e.g. for link handling and
>>>>> it may just be more convenient for the userspace.
>>>>>
>>>>> Try to cover most of the use cases with one flag. The overhead
>>>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>>>> requests and a bit bloated req_set_fail(), should be bearable.
>>>>
>>>> I like the idea, one thing I'm struggling with is I think a normal use
>>>> case of this would be fast IO where we still need to know if a
>>>> completion event has happened, we just don't need to know the details of
>>>> it since we already know what those details would be if it ends up in
>>>> success.
>>>>
>>>> How about having a skip counter? That would supposedly also allow drain
>>>> to work, and it could be mapped with the other cq parts to allow the app
>>>> to see it as well.
>>>
>>> It doesn't go through expensive io_cqring_ev_posted(), so the
>>> userspace can't really wait on it. It can do some linking tricks to
>>> alleviate that, but I don't see any new capabilities from the current
>>> approach.
>>
>> I'm not talking about waiting, just reading the cqring entry to see how
>> many were skipped. If you ask for no cqe, by definition there would be
>> nothing to wait on for you. Though it'd probably be better as an sqring
>> entry, since we'd be accounting at that time. Only caveat there is then
>> if the sqe errors and we do end up posting a cqe..
>>
>>> Also the locking is a problem, I was thinking about it, mainly hoping
>>> that I can adjust cq_extra and leave draining, but it didn't appear
>>> great to me. AFAIK, it's either an atomic, beating the purpose of the
>>> thing.
>>
>> If we do submission side, then the ring mutex would cover it. No need
>> for any extra locking
> 
> Jens, let's decide what we're going to do with this feature

Only weird bit is the drain, but apart from that I think it looks sane.
Are you going to send a documentation update to liburing as well? Should
be detailed in terms of what it does and the usability of it.

-- 
Jens Axboe

