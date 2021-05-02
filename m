Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA1A370DC1
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhEBP53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 11:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhEBP53 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 11:57:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75237C06174A;
        Sun,  2 May 2021 08:56:37 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id g65so1902183wmg.2;
        Sun, 02 May 2021 08:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iE0/1+DQAvjT7mxedPOLj9B11v3SoDtPVESyVolZSTM=;
        b=G3/iYb6NJJ/JXrFJYLkjgnsFEaVcS/vu10zurP0bOQtWqwZkK+hN5JyTD/p+nw8uSZ
         /LoDZrFP5z+Cxh1XtzB43BEPi0CEFSzQKpxSZrfLLbUxOKJZ9fJDMGejQ2lRaMdRK5e/
         CATosKQR76z4Z57n3zItIhaeKrCkCk9qPgMRp6/ugSOAnTrznotP/6CXvqDUP9Nx7zbT
         cXjVYI43WgMqp3/L87gxu8Q8x2AjMQnIFlNx7RHO0a/0TtqcMygqYBwQHOpV7G3Rds98
         GjPy8madettgexgiPCwRbxPvlz6Ae3PzffHtMxDtbiVjhLvsEEoSAxGWR0Wzx0YFLTOV
         1cwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iE0/1+DQAvjT7mxedPOLj9B11v3SoDtPVESyVolZSTM=;
        b=OdExbTOikzWKuHmD6nS0a31VD3wsZYXJBF2zLe52MBUnQ18bwi1GHrlyK7uIB4aBIK
         V9yeY4y3DZoRBhFhJiFuCQ/Az4RTaUbQQ2eYfgREnzP6twxTNKtqCuIX5nZ+HQyqV/hf
         OQ4gXikee5+WhHaISmIdDpljJvMK9mViA4YVJRu4FfZVR7hkxH+i4S8ZP9AiGsiu7Yrj
         8bLR7fiNTf1wPQVslHU+Kl3vz7aeEntS3IkU7w3JR5dtw0xsaD6gJV79b3lnYlpm/PGi
         AAf98e+g+QnzfwymSND7FmfBkUEO+QlLlBYq9jGdoDDEIlT2Lr0qKTgoKEBNMCPOBjIW
         xT/Q==
X-Gm-Message-State: AOAM5301pmfXI2hUa7oWdDLAxxN6Lvfw+tgwnbRL+AOw/QpMutSapQnX
        s/XrVcxwliewUd5j9OLG+LI=
X-Google-Smtp-Source: ABdhPJwVAc9Oli13vnWIUUcEZz5cucZedc3rCenFGPZUTO7GOr8Tu8Pl/RG4ERd68Ia+vsGJGMV+rQ==
X-Received: by 2002:a05:600c:322a:: with SMTP id r42mr6065428wmp.98.1619970996227;
        Sun, 02 May 2021 08:56:36 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.156])
        by smtp.gmail.com with ESMTPSA id 6sm22916152wmg.9.2021.05.02.08.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 08:56:35 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_sqpoll
To:     Palash Oswal <oswalpalash@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot+11bf59db879676f59e52@syzkaller.appspotmail.com
References: <0000000000000c97e505bdd1d60e@google.com>
 <cfa0f9b8-91ec-4772-a6c2-c5206f32373fn@googlegroups.com>
 <53a22ab4-7a2d-4ebd-802d-9d1b4ce4e087n@googlegroups.com>
 <CAGyP=7fpNBhbmczjDq-vpzbSDyqwCw2jS7xQo4XO=bxwsy2ddQ@mail.gmail.com>
 <a6ce21f4-04e7-f34c-8cfc-f8158f7fe163@gmail.com>
 <CAGyP=7czG1nmzpM5T784iBdApVL14hGoAfw-nhS=tNH5t9C79g@mail.gmail.com>
 <12e84e19-a803-25e3-7d15-d105b56d15b6@gmail.com>
 <CAGyP=7fAsgXjaK9MHOCLAWLY9ay6Z03KtxaFQVcNtk25KQ5poQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <35f8d506-fb3b-94a5-8aab-f1bde0e5f48a@gmail.com>
Date:   Sun, 2 May 2021 16:56:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7fAsgXjaK9MHOCLAWLY9ay6Z03KtxaFQVcNtk25KQ5poQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/21 4:01 PM, Palash Oswal wrote:
> On Sun, May 2, 2021 at 4:04 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> 
>>> I tested against the HEAD b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
>>
>> However, there is a bunch patches fixing sqpoll cancellations in
>> 5.13, all are waiting for backporting. and for-next doesn't trigger
>> the issue for me.
>>
>> Are you absolutely sure b1ef997bec4d5cf251bfb5e47f7b04afa49bcdfe
>> does hit it?
>>
>>> commit on for-next tree
>>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/?h=for-next
>>> and the reproducer fails.
> 
> Hi Pavel and Hillf,
> 
> I believe there's a little misunderstanding, apologies. The reproducer
> does not trigger the bug on the for-next tree which has patches for
> 5.13. The reproducer process exits correctly. Likely one of those
> commits that will be back-ported to 5.12 will address this issue.
> When I wrote `the reproducer fails`, I meant to indicate that the bug
> is not triggered on for-next. I will word it better next time!

I see, great it's clarified

-- 
Pavel Begunkov
