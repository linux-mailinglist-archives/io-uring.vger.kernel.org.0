Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F306D62AA
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 15:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjDDNWh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 09:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbjDDNWg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 09:22:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D0E71;
        Tue,  4 Apr 2023 06:22:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t10so130385798edd.12;
        Tue, 04 Apr 2023 06:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680614553;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DL+vsAXqBzSlNOVEu1L4Y71uBsHCeeGwqe10gSIxe3I=;
        b=eZztO4Yo8z02kgUPSrp63a3GPxa9Qs+YevGQHZ181rGVMRRlEyNDtrGY7L9nSJG7d8
         Elo2XaPTr8M6dWHdZY2E9E28LaF9rpZ+5Q0M3A0dqeBvJ80eKD9xToJsuhrxkrAacDCo
         xiN6b8S5Qba+anwP+RaeQy5ozP63ByKRQXRfFhnY0eMpr24jhOXipg4eoXw9tcoLDMPX
         v70Ro2R4JeNrNDiu6amr9e/Khj1TLsnylsU6WF6OiK5P/PBL+Tu7a4/CWCgo4b+ysCLf
         XB4+XvYiFeNU58/9WrEv5P25LDw+81H/r6XR0BaFP86qyf4Fv+y8LRs3RtKQaRmi5Rmj
         nwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614553;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DL+vsAXqBzSlNOVEu1L4Y71uBsHCeeGwqe10gSIxe3I=;
        b=YOD8SGcAHXNqRpRm6hlxxsPnN0r+dj0L6DhCN+ZJ2QQkz5JqRJkqJ4IMqYguZxxQ/s
         wmczsmz3d4ahmPjeaxWkw1sh37sxN+lZ8t6IYsUdBoOM8WexQbO8/PyAEiP1QDPDGywi
         7AOgM6fVsUgfe8xq3+26fsd1Xbo27jOC4ZDgtTNqZE8o25tS4+vfAhQplqDwj1rUdiph
         /xygBQlLuN+5XigHbSCBUAarK0HGqr/wyF57mNT3JWCu6JtxLi576RvZJPsx5k6lX6Jn
         ljG8M5spQo352qi5v4aFraKBUDzOqm8UlPsd/ZD9PCGejAirnPcLPrsMsAy584xgV//X
         p1Lg==
X-Gm-Message-State: AAQBX9eL2/2qfWAxogvpv1OFcorX4ZJXDsyUbCaRaOR5tBJ7BBhwRLT6
        FsgEc5C5JbqCfEDBo4zebPxfH2n6v70=
X-Google-Smtp-Source: AKy350ZFYVKk5OqfTXg+OASDJFR24FKJ5w4qZ9my0IFgLL0Io1h5UD0wDQA4t5GN3dg7IDZIIunsAA==
X-Received: by 2002:a17:906:340d:b0:930:2e3c:c6aa with SMTP id c13-20020a170906340d00b009302e3cc6aamr2092665ejb.49.1680614553051;
        Tue, 04 Apr 2023 06:22:33 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id gy15-20020a170906f24f00b0092fdb0b2e5dsm6007394ejb.93.2023.04.04.06.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 06:22:32 -0700 (PDT)
Message-ID: <4cc86e76-46b7-09ce-65f9-cd27ffe4b26e@gmail.com>
Date:   Tue, 4 Apr 2023 14:21:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
References: <cover.1680187408.git.asml.silence@gmail.com>
 <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
 <87cz4p1083.fsf@suse.de> <6eaadad2-d6a6-dfbb-88aa-8ae68af2f89d@gmail.com>
 <87wn2wzcv3.fsf@suse.de>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87wn2wzcv3.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/23 01:04, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> On 3/31/23 15:09, Gabriel Krisman Bertazi wrote:
>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>
>>>> Add allocation cache for struct io_rsrc_node, it's always allocated and
>>>> put under ->uring_lock, so it doesn't need any extra synchronisation
>>>> around caches.
>>> Hi Pavel,
>>> I'm curious if you considered using kmem_cache instead of the custom
>>> cache for this case?  I'm wondering if this provokes visible difference in
>>> performance in your benchmark.
>>
>> I didn't try it, but kmem_cache vs kmalloc, IIRC, doesn't bring us
>> much, definitely doesn't spare from locking, and the overhead
>> definitely wasn't satisfactory for requests before.
> 
> There is no locks in the fast path of slub, as far as I know.  it has a
> per-cpu cache that is refilled once empty, quite similar to the fastpath
> of this cache.  I imagine the performance hit in slub comes from the
> barrier and atomic operations?

Yeah, I mean all kinds of synchronisation. And I don't think
that's the main offender here, the test is single threaded without
contention and the system was mostly idle.

> kmem_cache works fine for most hot paths of the kernel.  I think this

It doesn't for io_uring. There are caches for the net side and now
in the block layer as well. I wouldn't say it necessarily halves
performance but definitely takes a share of CPU.

> custom cache makes sense for the request cache, where objects are
> allocated at an incredibly high rate.  but is this level of update
> frequency a valid use case here?

I can think of some. For example it was of interest before to
install a file for just 2-3 IO operations and also fully bypassing
the normal file table. I rather don't see why we wouldn't use it.

> If it is indeed a significant performance improvement, I guess it is
> fine to have another user of the cache. But I'd be curious to know how
> much of the performance improvement you mentioned in the cover letter is
> due to this patch!

It was definitely sticking out in profiles, 5-10% of cycles, maybe more

-- 
Pavel Begunkov
