Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F374A87F9
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 16:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351950AbiBCPsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351962AbiBCPss (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:48:48 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AE5C061714;
        Thu,  3 Feb 2022 07:48:48 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id w11so5874544wra.4;
        Thu, 03 Feb 2022 07:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gCcRTHRJr7f01fevcrPC8GA217103t1QOb6ugGoVskc=;
        b=CCcL5YW9kYYLEnd4F0UXJcgwesKgEIBd+r9GfzB3qZ0coS3mlSxusvIR7vnWERfGa3
         qNXoGebUErKgrYfx3v3/uh+4RQZ9dKGaOkN0IHAmcBUINWoeEtbLD9fzJ6JPq9yLP/PJ
         kRqKFOjkkgVi2Ad2dCtDmDz/188N9WHRAd3As9xC6jVl8RGoYFt0pQOb5fe/7cgbJ2dv
         3vdNeGO0vRDbSKN+u7jykuG7PDphZzSL+So5pyd7GQ6rnPsUr92nVr4uPSaWMQcRHWTj
         rMf/AmHvHiBrHvNnfodF0PXg6APw4gLjoVDNAPGvQFtChnDw22OMIbNhvaCXTUTp6CTN
         9shw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gCcRTHRJr7f01fevcrPC8GA217103t1QOb6ugGoVskc=;
        b=5C/i77Cqh70yeNABRVBLB1td39hLAATwMTiG7y2FR6PM0FFpQYed2HTK5vK0cQjFRQ
         c7K8J1gZ2emX7dfIm3ZiUSqH4GSx0YKoCJ4zp55ayTHAo6QynNc5+HeV1UeWdOKPU0lu
         OJkIkOZDVpbIw9YYkD8oERCBZqC4hfkhpNZZIBuY3BV+e1dB9lQRGSYUk9ahUDEn87Nn
         PmfnkFkSwlS1vLvdkmajRUFE16/ryBptGKUJtZ5EFOMTrsuWPIHx9kqAW6Ed433XWAex
         qbdivKtqGFNdWx383G86ieMBHQGZClKHUBO+sdK9BNXRSN6KLIOf2LXbnFiJo/P+5OqI
         5cug==
X-Gm-Message-State: AOAM530QT/6niwyftLF133HAR1s2hSnqT75qRuwtqcFkp3J50SrlKKuj
        aTQZmDfuvgdAOPS/xe9hsMLWw3bzxzc=
X-Google-Smtp-Source: ABdhPJzVqtTWNdQ8ZTlZGEZXefEtRmguBwaFcZdYYdh5sJl0775P+Rymry8UlUfMBoOI5Mja0DguAQ==
X-Received: by 2002:adf:e411:: with SMTP id g17mr12916563wrm.275.1643903326813;
        Thu, 03 Feb 2022 07:48:46 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id x6sm23958986wrn.18.2022.02.03.07.48.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 07:48:46 -0800 (PST)
Message-ID: <6cce16d3-e2ca-ca1e-1209-e6e243241231@gmail.com>
Date:   Thu, 3 Feb 2022 15:44:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [External] Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
 <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
 <7df1059c-6151-29c8-9ed5-0bc0726c362d@kernel.dk>
 <1494b8f0-2f48-0aa1-214c-a02bbc4b05eb@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1494b8f0-2f48-0aa1-214c-a02bbc4b05eb@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 15:14, Usama Arif wrote:
> On 02/02/2022 19:18, Jens Axboe wrote:
>> On 2/2/22 9:57 AM, Jens Axboe wrote:
>>> On 2/2/22 8:59 AM, Usama Arif wrote:
>>>> Acquire completion_lock at the start of __io_uring_register before
>>>> registering/unregistering eventfd and release it at the end. Hence
>>>> all calls to io_cqring_ev_posted which adds to the eventfd counter
>>>> will finish before acquiring the spin_lock in io_uring_register, and
>>>> all new calls will wait till the eventfd is registered. This avoids
>>>> ring quiesce which is much more expensive than acquiring the
>>>> spin_lock.
>>>>
>>>> On the system tested with this patch, io_uring_reigster with
>>>> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.
>>>
>>> This seems like optimizing for the wrong thing, so I've got a few
>>> questions. Are you doing a lot of eventfd registrations (and
>>> unregister) in your workload? Or is it just the initial pain of
>>> registering one? In talking to Pavel, he suggested that RCU might be a
>>> good use case here, and I think so too. That would still remove the
>>> need to quiesce, and the posted side just needs a fairly cheap rcu
>>> read lock/unlock around it.
>>
>> Totally untested, but perhaps can serve as a starting point or
>> inspiration.
>>
> 
> Hi,
> 
> Thank you for the replies and comments. My usecase registers only one eventfd at the start.

Then it's overkill. Update io_register_op_must_quiesce(), set ->cq_ev_fd
on registration with WRITE_ONCE(), read it in io_cqring_ev_posted* with
READ_ONCE() and you're set.

There is a caveat, ->cq_ev_fd won't be immediately visible to already
inflight requests, but we can say it's the responsibility of the
userspace to wait for a grace period, i.e. for all inflight requests
submitted before registration io_cqring_ev_posted* might or might not
see updated ->cq_ev_fd, which works perfectly if there was no requests
in the first place. Of course it changes the behaviour so will need
a new register opcode.

-- 
Pavel Begunkov
