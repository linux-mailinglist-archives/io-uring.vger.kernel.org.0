Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13D3592C16
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiHOJSr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 05:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiHOJSn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 05:18:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA6A22508
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 02:18:42 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e27so3672476wra.11
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 02:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=YeJwL0SGhH7TVmrhLe9TQyPGcOzlAS5D8shSJB7WYtw=;
        b=V+/lTUoudlP8GvDtgiZPZpTBzXF/sQZzI6gllPxrajNgSakxexbkqok+SbGuUGYbva
         6W+CGoIPFiajKsVxLw/8DOR1Bl8SHidSnEcxcHpakWDQM43R/+z2TIOnmcn7s13z+gJt
         ZVg/UoTHw3hEgt2Kz+W++4F33nzuFp9RxkmBfOQof/4fFQL2LDnYWmk+gnPG/DhGDmUa
         0okjJOQADqRa/Vf3N2hSt1ENx2TWIgzI5gR6+PScoFc7bB8nOPMYNW2zgfJcLk4btQTP
         5Z2Js0zS1TVAfKFAVpo+Sr178FfdAuM4zW4TfV0EGoedghSAiN3z/mwAQpbOsxtKJxk2
         gHOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=YeJwL0SGhH7TVmrhLe9TQyPGcOzlAS5D8shSJB7WYtw=;
        b=usAP0V7UhGB5sqgMdrlt4AfVYz31x4aX1oQmp4QHy1YH/qz8dEYN5NKWejZr33kmzN
         H2YaALikBFatviZYfZnw2hQlYEbpOyMfEvKRBxBU/EJk+YnshLRfB4I0fyvtJkf/9Mp9
         prt/d32EonDv6fH2v2p5O1WrcLZOza1LG5HzO4CPHqUcqsYu0yKYX4nge8FebURA357U
         wazlSxBRrkTC6ryQuQl07Je+U8RuCY2pfhbcyMtiV30cf0COGffb4NF40MxFtAwonTXN
         h1jQdOMTGE7tHzaYarz3LpAKenQ4FUbIIknXwjqlqE9kCAAZaXeP2lTCCUP3vfRvYQRY
         jPzg==
X-Gm-Message-State: ACgBeo2q1Orrz+ZLUocVb+NR4i6gKrj6gWdmetmrqan8R9VLNN9N1piR
        3uanzyIMeurv04UqUsZCHaQ=
X-Google-Smtp-Source: AA6agR6HeSKt0iHZ1xI6VOgTwmEZ9ErlOOYZ9/343X2jSAWpJHfnXWl3qhuUS3Q4wU0DGBlFekug7Q==
X-Received: by 2002:a05:6000:1686:b0:220:66b1:d897 with SMTP id y6-20020a056000168600b0022066b1d897mr8466249wrd.653.1660555121226;
        Mon, 15 Aug 2022 02:18:41 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id e6-20020a5d5306000000b0021e519eba9bsm6636920wrv.42.2022.08.15.02.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 02:18:40 -0700 (PDT)
Message-ID: <c9ab79bc-3e2c-635e-3991-2aa659166d96@gmail.com>
Date:   Mon, 15 Aug 2022 10:14:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/1] io_uring/net: send retry for zerocopy
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <b876a4838597d9bba4f3215db60d72c33c448ad0.1659622472.git.asml.silence@gmail.com>
 <064b4920-5441-1ae2-b492-cb75f7796d8d@samba.org>
 <14283cb1-11b3-2847-4f48-9ea30c48c1bf@kernel.dk>
 <6357d22c-2fcc-ccc9-882c-9ebf83add50d@samba.org>
 <8d91ba5e-5b28-5ec0-b348-7eebd1edf2dd@kernel.dk>
 <6e523a67-96ce-e67e-e07d-3b63a86e5e3f@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6e523a67-96ce-e67e-e07d-3b63a86e5e3f@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/22 15:48, Stefan Metzmacher wrote:
> Am 14.08.22 um 16:13 schrieb Jens Axboe:
>> On 8/14/22 8:11 AM, Stefan Metzmacher wrote:
>>>>> Don't we need a prep_async function and/or something like
>>>>> io_setup_async_msg() here to handle address?

>>> This has support for sockaddr address compared to io_send(),
>>> if the caller need to keep io_sendzc->addr valid until the qce arrived,
>>> then we need to clearly document that, as that doesn't match the common practice
>>> of other opcodes. Currently everything but data buffers can go after the sqe is
>>> submitted.

Yes, can be this way if we agree it's preferable.

>> Good point, it's not just the 'from' address. Pavel?

It is

> It's basically dest_addr from:
> 
>         ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
>                        const struct sockaddr *dest_addr, socklen_t addrlen);
> 
> It's not used in most cases, but for non-connected udp sockets you need it.
> 
> Maybe the fixed io_op_def.async_size could be changed to something that only
> allocated the async data if needed. Maybe the prep_async() hook could to the allocation
> itself if needed.

It's details, easy to implement, e.g. we can just decouple the
allocation from async preparation. I'll give it a try after sending
other small zc API changes

-- 
Pavel Begunkov
