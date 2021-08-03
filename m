Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCED3DEEF7
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhHCNTa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 09:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbhHCNT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 09:19:26 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DA4C061757;
        Tue,  3 Aug 2021 06:19:15 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so2116538wmg.4;
        Tue, 03 Aug 2021 06:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4bTL95jDgra7LC9A5D9r1ZcZc4mY/FmKMB407SmhfYM=;
        b=gKaHlsmBzLnKCGD7KDdkTxaJGT4/d7MCE4LAGHMRHJ5yyonNdfF09ofRlESE/Q3u87
         txgOn5WyXypBSvWi1ChGO2ryDIczIj5D95m8zF+PViXJz0FDs6qOPUCB4YuusHmzysca
         vVAQeZ5LCWnAbsyQUItlw1NUfU4JT9Q9mMEMQdqyPBOPz/cYztCp00fmuL/CaD4ZEFzp
         /BsZfV/S6b7IguHXgvE/pqsfVeS+hfWevMKLR4PkombpbWV/TtoVy+7trnRScRZa5pis
         Tz9JOo3B8rZhzNN1uKbM5ZiVFKNHJOgLxm39/ylgh/k/dBCaYVeN7cgtSGZaQyfZJffC
         4zAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4bTL95jDgra7LC9A5D9r1ZcZc4mY/FmKMB407SmhfYM=;
        b=tHmqwEiHJ6VwBQXDse138Ng9bGZK/n+0ne8cOApVH0vJmFSiFbmO6NMgU7uz4HID3C
         BVGDHBvYiWTA7vBXHkmeoPttygnyqQMo0soPvw0GGvOEafdz4urs8dMU8YjA7K2uary/
         1Nwz/AiYNMZGswsqIMD8mL+Xod6XUM3TIVslnt78CBGb/shaH/7mfNO5S9NUCg3edUIz
         p+BNVgsDKzqqVO+mR0WOt1/fqsQhqMlvlClpPsMRVkT9Irrhr52rv81SX3GQsaBX/zRV
         tGELwOgHQ1kS0+rXzu9TCNVFp/Kykj17wtutfEuesJRwuYikgq/Mk3wvvGMtCAy7gDEU
         Denw==
X-Gm-Message-State: AOAM530S5zwL8EQLOmd17EghxE4FWRAEi1x5Ou2cgHSiW/kzFt1jVNW7
        h4q3gRJASRAqvhuyLWaFQ1YrBY+BGZ4=
X-Google-Smtp-Source: ABdhPJyUVnbCvP0mqsqQ4xEJKu5fmjhfDS9rk7EfgqGR8yMdVCkyq54EDsQd0VmpkWIt/CqRh6svTQ==
X-Received: by 2002:a05:600c:3b9b:: with SMTP id n27mr4411307wms.188.1627996754347;
        Tue, 03 Aug 2021 06:19:14 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.39])
        by smtp.gmail.com with ESMTPSA id a2sm14498423wrn.95.2021.08.03.06.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 06:19:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <CADVatmOf+ZfxXA=LBSUqDZApZG3K1Q8GV2N5CR5KgrJLqTGsfg@mail.gmail.com>
 <f38b93f3-4cdb-1f9b-bd81-51d32275555e@gmail.com>
 <4c339bea-87ff-cb41-732f-05fc5aff18fa@gmail.com>
 <CADVatmPwM-2oma2mCXnQViKK5DfZ2GS5FLmteEDYwOEOK-mjMg@mail.gmail.com>
 <8db71657-bd61-6b1f-035f-9a69221e7cb3@gmail.com>
 <CADVatmPPnAWyOmyqT3iggeO_hOuPpALF5hqAqbQkrdvCPB5UaQ@mail.gmail.com>
 <98f8ec51-9d84-0e74-4c1c-a463f2d69d9d@gmail.com>
Subject: Re: KASAN: stack-out-of-bounds in iov_iter_revert
Message-ID: <245f52f4-8b27-6477-2012-78e42398167d@gmail.com>
Date:   Tue, 3 Aug 2021 14:18:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <98f8ec51-9d84-0e74-4c1c-a463f2d69d9d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/21 11:34 AM, Pavel Begunkov wrote:
> On 8/3/21 8:47 AM, Sudip Mukherjee wrote:
>> On Mon, Aug 2, 2021 at 12:55 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> On 8/1/21 9:28 PM, Sudip Mukherjee wrote:
>>>> On Sun, Aug 1, 2021 at 9:52 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>> On 8/1/21 1:10 AM, Pavel Begunkov wrote:
>>>>>> On 7/31/21 7:21 PM, Sudip Mukherjee wrote:
>>>>>>> Hi Jens, Pavel,
>>>>>>>
>>>>>>> We had been running syzkaller on v5.10.y and a "KASAN:
>>>>>>> stack-out-of-bounds in iov_iter_revert" was being reported on it. I
>>>>>>> got some time to check that today and have managed to get a syzkaller
>>>>>>> reproducer. I dont have a C reproducer which I can share but I can use
>>>>>>> the syz-reproducer to reproduce this with v5.14-rc3 and also with
>>>>>>> next-20210730.
>>>>>>
>>>>>> Can you try out the diff below? Not a full-fledged fix, but need to
>>>>>> check a hunch.
>>>>>>
>>>>>> If that's important, I was using this branch:
>>>>>> git://git.kernel.dk/linux-block io_uring-5.14
>>>>>
>>>>> Or better this one, just in case it ooopses on warnings.
>>>>
>>>> I tested this one on top of "git://git.kernel.dk/linux-block
>>>> io_uring-5.14" and the issue was still seen, but after the BUG trace I
>>>> got lots of "truncated wr" message. The trace is:
>>>
>>> That's interesting, thanks
>>> Can you share the syz reproducer?
>>
>> Unfortunately I dont have a C reproducer, but this is the reproducer
>> for syzkaller:
> 
> Thanks. Maybe I'm not perfectly familiar with syz, but were there
> any options? Like threaded, collide, etc.?

Never mind, reproduced the issue.

fwiw, I was too optimistic with u16 in the diff, but if
replaced with size_t, it solves the out-of-bounds bug,
but it has another issue.

In any case, need to patch it up, thanks

-- 
Pavel Begunkov
