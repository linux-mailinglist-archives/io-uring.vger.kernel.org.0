Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D602751075
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 20:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjGLSZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 14:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjGLSZ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 14:25:57 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C03F19A7
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 11:25:54 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4fb77f21c63so11879401e87.2
        for <io-uring@vger.kernel.org>; Wed, 12 Jul 2023 11:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689186353; x=1691778353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QH+MToNGXzmVAKM8WJ91Hd8fEko8qaEQox1dyEX70Ps=;
        b=n7dLrlbbn+WXcB/6iNCiFWpExRDsxhZyOLdeNioNJh/wdfrtNzGGtltpf9rpm+J51L
         tPISjbpInp9/7W0h80DSNfXdu4q4HDhUWEFcr06a5A9V0QtMVSsasU8hvCMZSyYTiGsj
         vZKRx8/k84t4fzrmgSTTflBk2kG3MMvbZIq3PsES+HpILlITvz8m3S6zSCK/a7bAXI3N
         ww+HmGsogkO9iJw+2jQY0PKsSw6sfx1TffVdTA3h6eC0C9815YKCyVtyhFPoLg2Ik8wz
         c1DZU9LgIcYZiSnpSyLO6rqK8itj+rW8u0MWjF6AhQR0xInpm9bLcsxMRrimzmJFXmoh
         mIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689186353; x=1691778353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QH+MToNGXzmVAKM8WJ91Hd8fEko8qaEQox1dyEX70Ps=;
        b=ba9a1TGx0/+6fX/Z/jl2FvmEylcqZIF5cFBvINM3ZgE12xZsVTbpXrAl1EGBh3K65X
         Et4TgOYyajfoaj12W76wqWjDgwS6KvvaLHlxuLczURDSB65XadfbMziwfilm5aUX3g02
         Ts8gaxt8vDZqdgLrQlW+9iUgTk8xevbGi+/YCgXknTesyFcDRNi4RxoRtJTK7EQrQ6Ah
         j4npPHhGltKTsQe3Izh0E3D9Ozfrfj0ifg7s2g3Qg8VjFNhx3QmvZqTJUIYI6nGlIpy7
         t/r3EMURSDTd5phkvfMNm6P/4S5nDutZGFAtO992WjpGbp8Wk+Kktwm2dwSK3/NWRy4q
         +0kQ==
X-Gm-Message-State: ABy/qLbgrnpG/reLXaOljdYHjRCfqB6u07Mor7Iv/sTySuIBmn74IeCH
        X1nc+t3YHpGIZKw8/eVJ2m3URu/aAg==
X-Google-Smtp-Source: APBJJlFZ/DIfdWvyMiJE4Yr2A0wkXIA5BH7qVIlGdPiXCVXPT2I9j3GnMOI4nZRMLLyi8sCsMMXF4Q==
X-Received: by 2002:ac2:5f52:0:b0:4f9:567b:c35d with SMTP id 18-20020ac25f52000000b004f9567bc35dmr14889517lfz.55.1689186352558;
        Wed, 12 Jul 2023 11:25:52 -0700 (PDT)
Received: from [192.168.100.16] ([81.26.145.66])
        by smtp.gmail.com with ESMTPSA id j14-20020ac2550e000000b004f9fdb0ed8esm806334lfk.304.2023.07.12.11.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 11:25:52 -0700 (PDT)
Message-ID: <c5626637-e85b-a567-46e9-45c01ce87852@gmail.com>
Date:   Wed, 12 Jul 2023 21:25:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Allow IORING_OP_ASYNC_CANCEL to cancel requests on other rings
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <62f84473-f398-fb00-84c0-711c59bd9961@gmail.com>
 <225f5595-bd8a-aeb9-049a-d8879d619a1d@kernel.dk>
Content-Language: ru-RU, en-US
From:   Artyom Pavlov <newpavlov@gmail.com>
In-Reply-To: <225f5595-bd8a-aeb9-049a-d8879d619a1d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

05.07.2023 21:32, Jens Axboe wrote:
> On 7/5/23 10:44?AM, Artyom Pavlov wrote:
>> Greetings!
>>
>> Right now when I want to cancel request which runs on a different ring
>> I have to use IORING_OP_MSG_RING with a special len value. CQEs with
>> res equal to this special value get intercepted by my code and
>> IORING_OP_ASYNC_CANCEL SQE gets created in the receiver ring with
>> user_data taken from the received message. This approach kind of
>> works, but not efficient (it requires additional round trip through
>> the ring) and somewhat fragile (it relies on lack of collisions
>> between the special value and potential error codes).
>>
>> I think it should be possible to add support for cancelling requests
>> on other rings to IORING_OP_ASYNC_CANCEL by introducing a new flag. If
>> the flag is enabled, then the fd field would be interpreted as fd of
>> another ring to which cancellation request should be sent. Using the
>> fd field would mean that the new flag would conflict with
>> IORING_ASYNC_CANCEL_FD, so it could be worth to use a different field
>> for receiver ring fd.
> This could certainly work, though I think it'd be a good idea to use a
> reserved field for the "other ring fd". As of right now, the
> 'splice_fd_in' descriptor field is not applicable to cancel requests, so
> that'd probably be the right place to put it.
>
> Some complications around locking here, as we'd need to grab the other
> ring lock. If ring A and ring B both cancel requests for each other,
> then there would be ordering concerns. But nothing that can't be worked
> around.
>
> Let me take a quick look at that.
Hi!

Any news?

 >If ring A and ring B both cancel requests for each other, then there 
would be ordering concerns.

I am not sure I understand the concern. Do you mean that task1 on ring1 
attempts to cancel task2 on ring2, while task2 attempts to cancel task1? 
I don't see how it's different when both tasks are on the same ring. 
Task2 may run when ring2 receives the cancellation request, but it looks 
similar to CQE for waking up task2 being already in competition ring. In 
both cases you would simply get -ENOENT in response to such SQE.

Best regards,
Artyom Pavlov.

