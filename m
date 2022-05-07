Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4E251E8E4
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245209AbiEGRYv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 13:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243599AbiEGRYu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 13:24:50 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EB23389E;
        Sat,  7 May 2022 10:21:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n8so10262066plh.1;
        Sat, 07 May 2022 10:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=XdmhxkvYsFoTqodAcfh3aQxaaXGZSFPtQ+0H3380Lbw=;
        b=PRRws8WmyHBzIAhAW3eKcznC0dy4F/s5ITUrx9H66GPZubrvnNZ8/qX9NscumP130N
         z/mxxHC7HxBjoE5LptrVv830y+OM5feykFYJYChQ2IQyVutgSFM2XN67LGSIDsrZodOk
         hk4Ef1G1j6RXbRnprSXTNA0pySLjnnziWZYfxYjOxThb1SRHb8HZgwpA2B25335gSvtc
         UMwbM+YjXWb5wE1KocdIOh/VFGaTXJHlY4ZjwJvKOU7+xxodKIgqHiGglKkQ+n0VTs0y
         NCFNd4vrkOMCYpElNJxRHLJSihkVCEgqKP7Jy/w3EqvBxU4a7gYaxcXgZYq/kSA1b9X5
         BUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XdmhxkvYsFoTqodAcfh3aQxaaXGZSFPtQ+0H3380Lbw=;
        b=kZfPit9xtXPItiTg3SqGdxXC5rhqD0YZfNQVfsbuABFs0Qag8YHIVsic6X+DG1i3mw
         nfFpdQvlU1Wh3EXVXMiv1Jc9VkzBS37KNuwftG4qxkcpIjaDOBva7xCL6rDWV4nASHGk
         WPKb1BFahP9jZ3xQ6PchWvr8km03vYsXD1wWCcepUyMkbbiTVFiPkSQNrgrv9JfvAOS6
         K+mw+F00L9gRwIWmvgvSMpPBUJw5Wm7sJS1MnIEcE9HVUFZXJR8p9RloOLpwBmG+c2dz
         YqQvGIyuoQDy5h66dJFlkkyyicWkfNBBRMqf8/hmCJK4fqdsKRYK4Q5RNZj+8LNOGOyJ
         ijxw==
X-Gm-Message-State: AOAM530hVmWexvPWHWhChZiwC4FbM01xB0gOGbRhz3qib7O5X8gpVQmv
        1zPpzOgSNFsy9JGI99WcomKwnEE6lWs9XzmQJF8=
X-Google-Smtp-Source: ABdhPJxOJD9v02p69pJHsP1FpXcyQ45Adr+qZO7rhwlSMaLaTrUt7x0DSHndogkVtLs7V3dQlmv/Mw==
X-Received: by 2002:a17:902:f652:b0:156:701b:9a2a with SMTP id m18-20020a170902f65200b00156701b9a2amr8963214plg.14.1651944062023;
        Sat, 07 May 2022 10:21:02 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.115])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902f10c00b0015e8d4eb1e0sm3903463plb.42.2022.05.07.10.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 10:21:01 -0700 (PDT)
Message-ID: <0b52bbd2-56de-c213-df3f-73f0f83a1f3a@gmail.com>
Date:   Sun, 8 May 2022 01:21:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 0/4] fast poll multishot mode
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <305fd65b-310c-9a9b-cb8c-6cbc3d00dbcb@kernel.dk>
 <390a7780-b02b-b086-803c-a8540abfd436@gmail.com>
 <f0a6c58f-62c0-737b-7125-9f75f8432496@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <f0a6c58f-62c0-737b-7125-9f75f8432496@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/8 上午12:11, Jens Axboe 写道:
> On 5/7/22 10:05 AM, Hao Xu wrote:
>>> But we still need to consider direct accept with multishot... Should
>>> probably be an add-on patch as I think it'd get a bit more complicated
>>> if we need to be able to cheaply find an available free fixed fd slot.
>>> I'll try and play with that.
>>
>> I'm tending to use a new mail account to send v4 rather than the gmail
>> account since the git issue seems to be network related.
>> I'll also think about the fixed fd problem.
> 
> Two basic attached patches that attempt do just alloc a fixed file
> descriptor for this case. Not tested at all... We return the fixed file
> slot in this case since we have to, to let the application know what was
> picked. I kind of wish we'd done that with direct open/accept to begin
> with anyway, a bit annoying that fixed vs normal open/accept behave
> differently.
> 
> Anyway, something to play with, and I'm sure it can be made better.
> 
Thanks. I tried to fix the mail account issue, still unclear what is
wrong, and too late at my timezone now, I'll try to send v4 tomorrow
