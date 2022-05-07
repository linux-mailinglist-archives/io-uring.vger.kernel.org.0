Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6C51E86D
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358677AbiEGQKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 12:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350131AbiEGQKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 12:10:42 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E1F286CB;
        Sat,  7 May 2022 09:06:55 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id a191so8533639pge.2;
        Sat, 07 May 2022 09:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=iu8buOXQvfsQhqYK7MF3BOzmHDXx0qq/JOSnnIr112A=;
        b=GNxM0Z8M7UUBkMUyRc/mBCcgpc4iI2BNKUAPQAF+g33kUb41m9NVpQr43L3/p+GiDV
         ctPGqj1+u5eFFx4Gf7JolM7MURGXZKzqJge4Lg3hktEwlbcCYkYcLT+1r+hcKLSSkM1j
         zTu2//KtNDzNn9lo3tEuIL0pdDDSGsh24Xg5DUpdnHIKd00xng7GIQgD35wJzsBpatmk
         j2GnWb2IYETXxLgvmS2IIs9skNWWdrMIiIQOIE2/Kc224PeOKHfr/ogD1LNxduXxNN4m
         L/DBMATT95Y5VI0hiAYE+2tMK2mWFndUQiQsOSE/+gabSQWbM+p1T6XaoOp91k/IVHp2
         nucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iu8buOXQvfsQhqYK7MF3BOzmHDXx0qq/JOSnnIr112A=;
        b=0tVWc5dFE5BINwJBQi8eHob5dDqNXefmp+n0pmoRQdxGyBvjhVevT+kN1eXqcmPg7d
         MYgZbAMftonI8gZyuBgsIXRKziPG8HGItfHY1TIvq7LkPFLkgOdGHiDYBdrVGupLccSx
         YIPT9eAp2cAByjpt/Rg7wsfK1OlITCYy3XNio8eOtKV8HnRICrmpDsxceU5VK7rEuhb+
         7HmI5E+UbtbFyIa+8sX0QXp0o1UFz+fB+nEsNt44EUf9RMaGVPXs/MehKQcPQYmZjWGS
         wJjsoH3baO4ZjgaWMEOuu4iJqpQ5FPtNB3dwFpkH09vOWOn0d6o8l8lJLL+rcB85KBdd
         n0Lg==
X-Gm-Message-State: AOAM530cBaZ9CGEolXwQha/HHBknPJh4eWv86EFSdJISLHlCTlr1SBwx
        Z7i5o0kkW4kFPSVdMBF2bVcfdRXOoAiNe2SOVOA=
X-Google-Smtp-Source: ABdhPJyLB4h19nEDKZk+uv2Aj3Q6T1TBcK8ia8B17tbRgk68F26mgtXQIM4ghKqCPsdsu8i9/tpC5Q==
X-Received: by 2002:a05:6a00:248d:b0:510:5d7d:18ab with SMTP id c13-20020a056a00248d00b005105d7d18abmr8192950pfv.51.1651939615047;
        Sat, 07 May 2022 09:06:55 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id y9-20020a170902b48900b0015e8d4eb21asm3819190plr.100.2022.05.07.09.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 09:06:54 -0700 (PDT)
Message-ID: <d39ea43c-e361-d7b5-274c-ed7f97d157f2@gmail.com>
Date:   Sun, 8 May 2022 00:07:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <20220507140620.85871-2-haoxu.linux@gmail.com>
 <21e1f932-f5fd-9b7e-2b34-fc3a82bbb297@kernel.dk>
 <c55de4df-a1a8-b169-8a96-3db99fa516bb@gmail.com>
 <0145cd16-812b-97eb-9c6f-4338fc25474a@kernel.dk>
 <c347be9c-0421-c8a1-1d9d-26ef7fc377ec@gmail.com>
 <4560ea22-4d20-95e4-56e9-9caed6093ac2@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <4560ea22-4d20-95e4-56e9-9caed6093ac2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 下午11:57, Jens Axboe 写道:
> On 5/7/22 9:52 AM, Hao Xu wrote:
>> ? 2022/5/7 ??11:38, Jens Axboe ??:
>>> On 5/7/22 9:31 AM, Hao Xu wrote:
>>>> ? 2022/5/7 ??10:16, Jens Axboe ??:
>>>>> On 5/7/22 8:06 AM, Hao Xu wrote:
>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>
>>>>>> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
>>>>>> support multishot.
>>>>>>
>>>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> Heh, don't add my SOB. Guessing this came from the folding in?Nop, It is in your fastpoll-mshot branch
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=fastpoll-mshot&id=e37527e6b4ac60e1effdc8aaa1058e931930af01
>>>
>>> But that's just a stand-alone fixup patch to be folded in, the SOB
>>> doesn't carry to other patches. So for all of them, just strip that for
>>> v4. If/when it gets applied, my SOB will get attached at that point.
>>>
>> Sorry, paste a wrong link, should be this:
>> https://git.kernel.dk/cgit/linux-block/commit/?h=fastpoll-mshot&id=289555f559f252fbfca6bdd0886316a8b17693e2
> 
> Right, but that's just me applying it to a test branch.
> 
I see, sorry, will remove the sign-off in v4
