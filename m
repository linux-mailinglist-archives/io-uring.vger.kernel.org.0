Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D70528D3B
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242794AbiEPSjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 14:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiEPSjJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 14:39:09 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB393E5E9
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 11:39:07 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i5so11138579ilv.0
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 11:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3eQ02kjrBJm3pP3IQQPhqRaXYnuZt0FpJtLq26rhSTc=;
        b=7pgtE5BgxtvCdKobQLIn3F+JGlA8bClHad3mwvaZSfu3A95TaeUK2nuDuDm4fCe2I+
         1bvlOodVc5JPWljWdjllrBgm71ZoPtHFWKSxR+zl4JhUVCA2i205D7MtTFjqFlVoVM+D
         SydXNGNKZWYSLV9B5bfJqNb10RNwsPLBIFtL6OhIouLHEbRLSIQ5Ioc0WB6xNLvYjWrK
         SRwoRT5rYjldnhlkh3Sintqm4fDWPEaisrYqnpdmFALdt0XSf8zEWGDPHkkHUuEy/+zy
         7BQDZ899YHLA+1xPfzqEBWuXFLYLqAV4Guuue2JKtnkIM8tNcyA4UQQSD4oIHFnrxpCN
         rRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3eQ02kjrBJm3pP3IQQPhqRaXYnuZt0FpJtLq26rhSTc=;
        b=YoTO1YDGj7wyAje4o7W3QQws3BNYqrCjqGlF+u831e0eTyWz3/NjZuKd/10/y35Nuf
         5o3EIl7WICNmsJdH4Bb48R8q81yNNjZ5nfe/DoEEIaZkzdIQsABpjbpwobszzbBpppby
         n2Im39Qr45n7daYvPprm8Fj4jCP9X1usTrArJyj0vAKcm7lYQqEvaG0FXINkjM89nkm8
         l9tOyINZv/v4pfpL24liAfcE2dgQmQKct+yBCdYMGLJ1s9THSLB+tIfBTU97GqvVF229
         z3lITESDuD3FhTRuc/Po6I0nRLBiryAou7FD2SbAB1SF4Ife9B+yLo8O3exk3Qeu2k9T
         LV+A==
X-Gm-Message-State: AOAM530I8SPDDViyZkwg0b8vmfpupNBUcRgkXS04N9DzOi4UPNyXvzJu
        qJWfR2nMFtpUf8POK8LPS6Nuow==
X-Google-Smtp-Source: ABdhPJxFCwYm1E5HggIdr+qL/ARzvjLrEEVlf1lnk5WG9zQMSO5Gx+DNggoaR5on1KJaFqtdzDKg5Q==
X-Received: by 2002:a92:c26a:0:b0:2d1:3622:1fd4 with SMTP id h10-20020a92c26a000000b002d136221fd4mr329556ild.79.1652726346890;
        Mon, 16 May 2022 11:39:06 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t14-20020a02ab8e000000b0032e2fc23508sm1088424jan.77.2022.05.16.11.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 11:39:06 -0700 (PDT)
Message-ID: <55ddaa3c-57a5-f17e-13a7-7427c5f1bb88@kernel.dk>
Date:   Mon, 16 May 2022 12:39:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Daniel Harding <dharding@living180.net>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
 <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
 <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
 <da56fa5f-0624-413e-74a1-545993940d27@gmail.com>
 <3fc08243-f9e0-9cec-4207-883c55ccff78@living180.net>
 <13028ff4-3565-f09e-818c-19e5f95fa60f@living180.net>
 <469e5a9b-c7e0-6365-c353-d831ff1c5071@leemhuis.info>
 <eaee4ea1-8e5a-dde8-472d-44241d992037@kernel.dk>
 <1ce76b24-9185-6b2e-844e-d6a0ce42bb0f@leemhuis.info>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1ce76b24-9185-6b2e-844e-d6a0ce42bb0f@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/22 12:34 PM, Thorsten Leemhuis wrote:
> On 16.05.22 20:22, Jens Axboe wrote:
>> On 5/16/22 12:17 PM, Thorsten Leemhuis wrote:
>>>>> Pavel, I had actually just started a draft email with the same theory
>>>>> (although you stated it much more clearly than I could have).  I'm
>>>>> working on debugging the LXC side, but I'm pretty sure the issue is
>>>>> due to LXC using blocking reads and getting stuck exactly as you
>>>>> describe.  If I can confirm this, I'll go ahead and mark this
>>>>> regression as invalid and file an issue with LXC. Thanks for your help
>>>>> and patience.
>>>>
>>>> Yes, it does appear that was the problem.  The attach POC patch against
>>>> LXC fixes the hang.  The kernel is working as intended.
>>>>
>>>> #regzbot invalid:  userspace programming error
>>>
>>> Hmmm, not sure if I like this. So yes, this might be a bug in LXC, but
>>> afaics it's a bug that was exposed by kernel change in 5.17 (correct me
>>> if I'm wrong!). The problem thus still qualifies as a kernel regression
>>> that normally needs to be fixed, as can be seen my some of the quotes
>>> from Linus in this file:
>>> https://www.kernel.org/doc/html/latest/process/handling-regressions.html
>>
>> Sorry, but that's really BS in this particularly case. This could always
>> have triggered, it's the way multishot works. Will we count eg timing
>> changes as potential regressions, because an application relied on
>> something there? That does not make it ABI.
>>
>> In general I agree with Linus on this, a change in behavior breaking
>> something should be investigated and figured out (and reverted, if need
>> be). This is not that.
> 
> Sorry, I have to deal with various subsystems and a lot of regressions
> reports. I can't know the details of each of issue and there are
> developers around that are not that familiar with all the practical
> implications of the "no regressions". That's why I was just trying to
> ensure that this is something safe to ignore. If you say it is, than I'm
> totally happy and now rest my case. :-D

It's just a slippery slope that quickly leads to the fact that _any_
kernel change is a potential regressions, as it may change something
that an app unknowingly depends on. For this case, the multishot ended
up being downgraded to single shot on older kernels, so you'd never see
multiple triggers of it. And multiple triggers is a natural effect of
the level triggered poll that io_uring does. The app didn't handle
multiple events in between reading them, which was an oversight in how
that was done.

Hence I do think this one can be safely closed.

-- 
Jens Axboe

