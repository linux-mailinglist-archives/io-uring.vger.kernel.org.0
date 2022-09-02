Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6E5AAE25
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiIBMKK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 08:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbiIBMKD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 08:10:03 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB9B13DCC
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 05:10:00 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k9so2105944wri.0
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 05:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ScxFCfSmsf4ktM89XCJbfoKnxJ+cv0ldYKLZ/fnEdvk=;
        b=SPtdFIdQdN7uKeLImy4B5tSsmcppLlxdwbr3BaNARWMpXU7AKy+7+ReCGiuocLNjmk
         0CfG0GqV+xD3H/QQqTswYfho1cgxch5yZlSvD/7MsuxjblSrtUVL/ZwRHWQaFbDK5vrL
         W4aoB6vAijFCiTNEit8b2KTonfQ4YpyDDIzyZBcVh3lK+wizLdaI9ixEDsO8No+T0vbZ
         VOBnVsRKuonH1Nph88YNq/Xaw6dQYiy4U0nCqnHUpdsQb77Re4ar8G/cCwL0VgSgEzcT
         42Fite775bils6I0f3LT3z3CpZMNDeZvip1ehAn1ZQxoKPBcGllw77xFhgucjeuPeKtk
         vM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ScxFCfSmsf4ktM89XCJbfoKnxJ+cv0ldYKLZ/fnEdvk=;
        b=NUGgeXzk5wUA7DNlPqaT3NnMsPWP9UFkGhj8+g+z4H8zIqMly9xvDPL0NjpQkVeC5Y
         oRk4lKpGCZeM4MeQumUn5Ti+4pwjLCM0xVEhnRL1bJSpnCt1XrFzf+mEZ3PbHZ2/FUCr
         /we+C7hDA/ciQjnR224Gq8HtLhTJh3QfAaQYA6Iz6/kT25ZYWYhTalQm9SEnC+mSKSMI
         Z/ygJsjsgu7zdXhTXZHAJEa6zVGyuoACOHvndNofUOY8Qsy4uF0NxeDKRFiUKGdq9ZZV
         9ggqx4RIQSJqQpx1fTonh5l5oyorjirt519Gc+CHbUj83BA4E6E8ZCOJmY9ZA1TjPfzy
         N0VA==
X-Gm-Message-State: ACgBeo3kp/eG1Rsw8qCotZUQSdR648RBccBOgx9qIDrP6svrFpSTrMxJ
        zsynaeYbOoooDJQI9b72ZgQ=
X-Google-Smtp-Source: AA6agR557uzw36x9pyQFlAM1lcB8PDW1AuU2i/BKZEBvMMv6GSWxHzn9XRR3ycgXSFufib/gvJ4VCA==
X-Received: by 2002:a05:6000:1f83:b0:223:60ee:6c08 with SMTP id bw3-20020a0560001f8300b0022360ee6c08mr16720275wrb.682.1662120598797;
        Fri, 02 Sep 2022 05:09:58 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id l12-20020a5d560c000000b0021ef34124ebsm1431088wrv.11.2022.09.02.05.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 05:09:58 -0700 (PDT)
Message-ID: <cebbf0d4-2fba-71cc-16a1-b95d7b31d646@gmail.com>
Date:   Fri, 2 Sep 2022 13:07:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH liburing 0/4] zerocopy send API changes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1662116617.git.asml.silence@gmail.com>
 <5aa07bf0-a783-0882-0038-1b02588c7e33@gnuweeb.org>
 <c4958f35-11e5-5dd9-83c5-609d8b16801b@gnuweeb.org>
 <6fedd5a1-1353-9e71-6b3e-478810b5fc8a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6fedd5a1-1353-9e71-6b3e-478810b5fc8a@kernel.dk>
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

On 9/2/22 13:03, Jens Axboe wrote:
> On 9/2/22 6:01 AM, Ammar Faizi wrote:
>> On 9/2/22 6:56 PM, Ammar Faizi wrote:
>>> On 9/2/22 6:12 PM, Pavel Begunkov wrote:
>>>> Fix up helpers and tests to match API changes and also add some more tests.
>>>>
>>>> Pavel Begunkov (4):
>>>>     tests: verify that send addr is copied when async
>>>>     zc: adjust sendzc to the simpler uapi
>>>>     test: test iowq zc sends
>>>>     examples: adjust zc bench to the new uapi
>>>
>>> Hi Pavel,
>>>
>>> Patch #2 and #3 are broken, but after applying patch #4, everything builds
>>> just fine. Please resend and avoid breakage in the middle.
>>>
>>> Thanks!
>>
>> Nevermind. It's already upstream now.
> 
> Ah shoot, how did I miss that... That's annoying.

We can squash them into a single commit if we care about it.
Don't really want do the disable + fix +e nable dancing here.

-- 
Pavel Begunkov
