Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A4397810
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhFAQbJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 12:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFAQbJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 12:31:09 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6CBC061574;
        Tue,  1 Jun 2021 09:29:26 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o2-20020a05600c4fc2b029019a0a8f959dso2297435wmq.1;
        Tue, 01 Jun 2021 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M+Wt77gwcQjul5PYu85EVePOuCkP6+G9utWtWXYGHkk=;
        b=gcnDim/odTZhMIwZZpal1dRFzmVljdi6FUGnhpL1j+LAt1wO2t8ypMJaXKT6viZwvy
         /IADCeUCqyQs5HRamF3aDrd2VVtRBQl1NUb13yNF5kpZsXY75w4vhW8GPVjbNKoBzXV0
         TSD/rHCu6+Hs60z/AOGKZHrjuLixP2zaLwwBl+/V+WPuLtlZXOE5iJVYezzOA21ZVSl9
         nIPbmtT2WYtLBkdDb35CaxNi+VVAnDSK2NXPS5pzO318nm+o8g62u5AeLc0LUG8DN8PF
         piMQ7TifSDXs/fPKs2d6SRwMBsqipjq/MT6yfCwoY8SKKtXxSyllXuv6fG/vjHPAfHgb
         Yxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M+Wt77gwcQjul5PYu85EVePOuCkP6+G9utWtWXYGHkk=;
        b=ljt07z4Rz1NRWyXHBP+PKEE6L7WuOimySgMePw7pDaLq8Gz9tFe+9poEhUa47xG46i
         PZmTv0uRQIjBxivNxoR70yiARXXGlA64VuhRkn134X4oY0F63k4T1ecAX0xrF6EcGFQP
         tXbqfFEHemVofko2sasGOgwLTP5d0vhshfODoxoBc1hwE2y1G3R0z2maA/lQiuESOt3P
         Isi5zVQs/qZBMgqagd2CZ0ihrUZH7Bz55BNNGpBeWhLJ5pPCzt9EjiG6pAqnG2SC8/1g
         M8g8gVEosuD79DkmMsUVZkkZtcReB4LXTZna6DVg/m22uul2AL5v7g4KojI/aHWZQBR9
         vheg==
X-Gm-Message-State: AOAM532UwQu0//7bbtCzm6dwAxsPjjapSCj+mQUOOp18vVtmansx8lmG
        3iw5rBcqFR07s728RDBSQ6+j8thYgUnaiQ==
X-Google-Smtp-Source: ABdhPJzlT3EjioGBboR7CQJ+mG43k9LhSLmblOQWozTBq8npYRaRvWkjqyV02VLpM7eHN9jOVXHr9A==
X-Received: by 2002:a05:600c:4f4e:: with SMTP id m14mr743106wmq.164.1622564965010;
        Tue, 01 Jun 2021 09:29:25 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id c206sm19972wmf.12.2021.06.01.09.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 09:29:24 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
Date:   Tue, 1 Jun 2021 17:29:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/21 5:01 PM, Jens Axboe wrote:
> On 6/1/21 9:58 AM, Pavel Begunkov wrote:
>> On 6/1/21 4:45 PM, Jens Axboe wrote:
>>> On 6/1/21 8:58 AM, Pavel Begunkov wrote:
>>>> Add futex wait requests, those always go through io-wq for simplicity.
>>>
>>> Not a huge fan of that, I think this should tap into the waitqueue
>>> instead and just rely on the wakeup callback to trigger the event. That
>>> would be a lot more efficient than punting to io-wq, both in terms of
>>> latency on trigger, but also for efficiency if the app is waiting on a
>>> lot of futexes.
>>
>> Yes, that would be preferable, but looks futexes don't use
>> waitqueues but some manual enqueuing into a plist_node, see
>> futex_wait_queue_me() or mark_wake_futex().
>> Did I miss it somewhere?
> 
> Yes, we'd need to augment that with a callback. I do think that's going

Yeah, that was the first idea, but it's also more intrusive for the
futex codebase. Can be piled on top for next revision of patches.

A question to futex maintainers, how much resistance to merging
something like that I may expect?

> to be necessary, I don't see the io-wq solution working well outside of
> the most basic of use cases. And even for that, it won't be particularly
> efficient for single waits.

-- 
Pavel Begunkov
