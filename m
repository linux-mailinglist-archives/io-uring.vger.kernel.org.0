Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F24B4A8836
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 17:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351769AbiBCP7i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiBCP7h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:59:37 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C69C061714;
        Thu,  3 Feb 2022 07:59:37 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v13so5885009wrv.10;
        Thu, 03 Feb 2022 07:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=+dl81ox9oLOsNstIVpWsT45Px3A+yIV/7i1ehqaDn+Y=;
        b=jJRD9ovHm/6cgRNueQkqcsMQvaS0BPUQ0d77VlPILGy+vnI071ln2LB+ZcLtXtTGFe
         NwDa+bci7eqbkiT6EilNkuZ5Oj1/Iw6PoMjcY6D9b40A7YdyCkaqi1MuH2SSV4qxL8x8
         0WefZ/Epn26eZ8AwVZ7vsVL3Po23hByayQbj0E6BPmF9UY1IjdMZMNULMXK6vhtrvEhk
         pw91dCRzmR0nFvNmTGoB23eubtkt91m/yeKcOKYsGOddm/Gw86K1h0kJ0sEc6neiOcKo
         8lIUWcPxF0PzAu9je7SIDOlNQYN/KH1xDymDQuCe/G91aZkGLNkuS18XVMwNMHJPRWCO
         A1SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=+dl81ox9oLOsNstIVpWsT45Px3A+yIV/7i1ehqaDn+Y=;
        b=YSO7wdQKZ/x/qJ3X9xbuCfOYHyybK+/yQPfIDCSyErxotOrLFZgtM7ol0CEOKb85Sm
         vpRA2rsFSHQurM239mp2zNQVoD78zgxbF+mxTGF9k+ps+C6g2IwPEAvExQRFaamcBbvb
         xHaBKSTSH0S7fVQq05H3e7Ld1KgQdRDYpuWggBbve0NTyUQH+jZrGSy9aFslOpr385eT
         LiXbBkN1xuPCPRUynfWfl8dI4w675FJYKSTQu3USrho7SjYrHmU2ML/wRzpjXRX0uOq2
         9oCrQif/dRczAvKlW8+oQnVtr1+r/zaiLn1KifutMWCuqVIGXOrPlx0397XaWtk5Y0zw
         Z6wg==
X-Gm-Message-State: AOAM533Z0uT/8/vqdC4EmwJZ8VTm3Kr6bI+CkHfGTbUcq1dO1spP1aXX
        l2nOJpee+0hs8LFgZRJ1VRU=
X-Google-Smtp-Source: ABdhPJz4mcMO5VCu7emIg7Vqh7PQEV38Ck+n/XjSj7JuEF67UyNWFH5e7rbXhGvOPMDAZQEJmXqFIA==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr29965757wrv.449.1643903975849;
        Thu, 03 Feb 2022 07:59:35 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id l10sm20431426wrz.20.2022.02.03.07.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 07:59:35 -0800 (PST)
Message-ID: <02fb0bc3-fc38-b8f0-3067-edd2a525ef29@gmail.com>
Date:   Thu, 3 Feb 2022 15:55:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [External] Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Usama Arif <usama.arif@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
 <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
 <7df1059c-6151-29c8-9ed5-0bc0726c362d@kernel.dk>
 <1494b8f0-2f48-0aa1-214c-a02bbc4b05eb@bytedance.com>
 <6cce16d3-e2ca-ca1e-1209-e6e243241231@gmail.com>
In-Reply-To: <6cce16d3-e2ca-ca1e-1209-e6e243241231@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 15:44, Pavel Begunkov wrote:
> On 2/3/22 15:14, Usama Arif wrote:
>> On 02/02/2022 19:18, Jens Axboe wrote:
>>> On 2/2/22 9:57 AM, Jens Axboe wrote:
>>>> On 2/2/22 8:59 AM, Usama Arif wrote:
>>>>> Acquire completion_lock at the start of __io_uring_register before
>>>>> registering/unregistering eventfd and release it at the end. Hence
>>>>> all calls to io_cqring_ev_posted which adds to the eventfd counter
>>>>> will finish before acquiring the spin_lock in io_uring_register, and
>>>>> all new calls will wait till the eventfd is registered. This avoids
>>>>> ring quiesce which is much more expensive than acquiring the
>>>>> spin_lock.
>>>>>
>>>>> On the system tested with this patch, io_uring_reigster with
>>>>> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.
>>>>
>>>> This seems like optimizing for the wrong thing, so I've got a few
>>>> questions. Are you doing a lot of eventfd registrations (and
>>>> unregister) in your workload? Or is it just the initial pain of
>>>> registering one? In talking to Pavel, he suggested that RCU might be a
>>>> good use case here, and I think so too. That would still remove the
>>>> need to quiesce, and the posted side just needs a fairly cheap rcu
>>>> read lock/unlock around it.
>>>
>>> Totally untested, but perhaps can serve as a starting point or
>>> inspiration.
>>>
>>
>> Hi,
>>
>> Thank you for the replies and comments. My usecase registers only one eventfd at the start.
> 
> Then it's overkill. Update io_register_op_must_quiesce(), set ->cq_ev_fd
> on registration with WRITE_ONCE(), read it in io_cqring_ev_posted* with
> READ_ONCE() and you're set.

Actually needs smp_store_release/smp_load_acquire


> There is a caveat, ->cq_ev_fd won't be immediately visible to already
> inflight requests, but we can say it's the responsibility of the
> userspace to wait for a grace period, i.e. for all inflight requests
> submitted before registration io_cqring_ev_posted* might or might not
> see updated ->cq_ev_fd, which works perfectly if there was no requests
> in the first place. Of course it changes the behaviour so will need
> a new register opcode.
> 

-- 
Pavel Begunkov
