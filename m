Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB99A76B707
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 16:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbjHAOQn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 10:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbjHAOQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 10:16:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E84193;
        Tue,  1 Aug 2023 07:16:34 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9936b3d0286so888471266b.0;
        Tue, 01 Aug 2023 07:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690899393; x=1691504193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MS3FrAwxdHTx2tcLvzU7qgxEoR9kVyoORHvrr8ChlbE=;
        b=owneU93TDsctA0Qv8w+LA+V3D/ITFrHuxDdfPlMKgjOXjZriegSV8nzS9XFicVicjF
         B2OIHWXcrUmpUxd0izWle3vqvm2TaxBSXZ6QLINBaiSzJBMHJuwp2V9/dtIfm4Ai0MPY
         K9ih4RozFCwQ+uEzfBmpkgdQhz9yfXn3rM0/M4Vhve4BI27obxT9P77gs4Qs29ct0PYq
         UXn9k3HFGITMvNChEbIy88ML6jJT14TLQAe2EEnUlVR4quOp1wtSZjVe3BCKuqQF5ppi
         PAAkyjA+FElRdrF00xjmBnILJ819N5zfs0mO/aSnwK6ysSkvL8ZtlI2TUI3mNiv8Tpi/
         lJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690899393; x=1691504193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MS3FrAwxdHTx2tcLvzU7qgxEoR9kVyoORHvrr8ChlbE=;
        b=i0zCJb7kgkkLB/3YO+V6Pnlf3Iy34FSswVxYeQfSHZLAKMKFRWNsopOS6uhGvStM9/
         RjpASWuQvZzoBzFdy2shwoeLeZz4ILn7gjMJemcrirJEIkJnYCrMWjG8kd8P55NNThOm
         1nEu3OlqQPwQDpbfS2S/vp1gkQPy+J1ADb6Nf1A+wHQIqswtzv8ujZjYG6O9b2/KsUpE
         K5fbSh+9VOV4iWKoN4YltNHdJHV4jFp/D56LxnacsEk2TlzHB9u8EYpgC8VZSrtEyeND
         153lhWokoUOgRfIi0Mf7gDlZd12kMVqJv2dfUWI5MC6Ce5SO31QlIHJPL4Dlpa6PgsNM
         Qcrw==
X-Gm-Message-State: ABy/qLa9Bc0KvoaFLZDtGn27wr5Y34Q9n3vIycVkXxiyNlpz9Com4ti5
        2K0OxiS0MnYLk5jpSTyNXvs=
X-Google-Smtp-Source: APBJJlEmnJXGn4pxS1gM9Dw+XGVCxrc3ga3hDlEOCqiOj9PNPWsITeS+eJcT5Hcmp4pcU/y8GObeXQ==
X-Received: by 2002:a17:906:db:b0:99b:66eb:2162 with SMTP id 27-20020a17090600db00b0099b66eb2162mr2451109eji.5.1690899392876;
        Tue, 01 Aug 2023 07:16:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:d658])
        by smtp.gmail.com with ESMTPSA id pv24-20020a170907209800b009920e9a3a73sm7701306ejb.115.2023.08.01.07.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 07:16:32 -0700 (PDT)
Message-ID: <ce3e1cf4-40a0-adde-e66b-487048b3871d@gmail.com>
Date:   Tue, 1 Aug 2023 15:13:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: split req init from submit
To:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>
References: <20230728201449.3350962-1-kbusch@meta.com>
 <9a360c1f-dc9a-e8b4-dbb0-39c99509bb8d@gmail.com>
 <22d99997-8626-024d-fae2-791bb0a094c3@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <22d99997-8626-024d-fae2-791bb0a094c3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/23 22:00, Jens Axboe wrote:
> On 7/31/23 6:53?AM, Pavel Begunkov wrote:
>> On 7/28/23 21:14, Keith Busch wrote:
>>> From: Keith Busch <kbusch@kernel.org>
>>>
>>> Split the req initialization and link handling from the submit. This
>>> simplifies the submit path since everything that can fail is separate
>>> from it, and makes it easier to create batched submissions later.
>>
>> Keith, I don't think this prep patch does us any good, I'd rather
>> shove the link assembling code further out of the common path. I like
>> the first version more (see [1]). I'd suggest to merge it, and do
>> cleaning up after.
>>
>> I'll also say that IMHO the overhead is well justified. It's not only
>> about having multiple nvmes, the problem slows down cases mixing storage
>> with net and the rest of IO in a single ring.
>>
>> [1] https://lore.kernel.org/io-uring/20230504162427.1099469-1-kbusch@meta.com/
> 
> The downside of that one, to me, is that it just serializes all of it
> and we end up looping over the submission list twice.

Right, and there is nothing can be done if we want to know about all
requests in advance, at least without changing uapi and/or adding
userspace hints.

> With alloc+init
> split, at least we get some locality wins by grouping the setup side of
> the requests.

I don't think I follow, what grouping do you mean? As far as I see, v1
and v2 are essentially same with the difference of whether you have a
helper for setting up links or not, see io_setup_link() from v2. In both
cases it's executed in the same sequence:

1) init (generic init + opcode init + link setup) each request and put
    into a temporary list.
2) go go over the list and submit them one by one

And after inlining they should look pretty close.

-- 
Pavel Begunkov
