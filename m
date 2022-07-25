Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9776580072
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiGYOIa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 10:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235499AbiGYOID (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 10:08:03 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D8B17ABB
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 07:07:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id z13so16123349wro.13
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 07:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z9Io2TZT6ClcZgsL7PDcqqMHOyjLDeORT4JMtbh6Kg0=;
        b=f5CqB+MFuiJvpdJ34dXDuwo9tIejR0yGKDLIDy48vLz6PgGXGX7GLLJaiaTyGHGrqf
         tiFxd4CFqrUzOHngKDeqs9D6iF+UzsyF3H04tCMJwvCdxrCdd98G/teuB6z55J4h/4/x
         nn8hojS+0RW1VRyQDuQU0+8mL5eaToU5kqeKX/5Ghos0/sjb+IoOyUk66tp2FZT1JOV1
         QL7+ghbKUCaxInWNlidK4OQUNQZ1C13/BNHCF0OtYk5yIyBNFjW9fwB8xbkEuLlYAPDh
         DhEUo9XuVom0H+wmWhwtkrORLJ/9i5m7Jrs21tw/uWiw7IcwWfqpfU/VtFY4DU7NRpVt
         c2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z9Io2TZT6ClcZgsL7PDcqqMHOyjLDeORT4JMtbh6Kg0=;
        b=7AEZ+0qhTbvmrFviU0xwKE4QceIIQ2Y6flDC/a12JADM/PEf/SnG5/lWak4ysZspkg
         SC5X+p2rIhfwhcGEJNJQf41+hqS+Wdo9yfWFhmIHQnkgCQIeyi0QDgAqDCg7+NqVT4Jk
         XDatz2BDAUCu02Z5GEKbHTtY8R0wQbzvC+5I0brxxGWh6PH+aiDsIM+esd7twc6ncEXR
         0XciUBbq3jk8xu4bqHHC7soFpm38wmcsYE8FpbyUAiaUkgo0jvFcsEMJrt7eO2cgnDEH
         GT1shrqlLI2hGiJP092FtLpb/OaFx9OM9G0Z9BC3a0XeQjcvQMfMSSBLL4x55JHbpUSd
         IcLA==
X-Gm-Message-State: AJIora/Q27nLuHPEzUS24uKcFuDvGH2k9QGRGZWe1Rjvn7sM+3lgHNRl
        Qrq8VnfXJPrvpfnqtUxAlXA=
X-Google-Smtp-Source: AGRyM1tgys55CMxE7t2Y2OyhAGtoANtv8cZAYcnU7n1oiRzXCWnCs5vqJPzZ7qQ+LoP9eXFruQ0b3Q==
X-Received: by 2002:a05:6000:1ac8:b0:21e:5842:7e49 with SMTP id i8-20020a0560001ac800b0021e58427e49mr7987161wry.672.1658758073060;
        Mon, 25 Jul 2022 07:07:53 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:846e])
        by smtp.gmail.com with ESMTPSA id o20-20020a05600c4fd400b003a305c0ab06sm20058697wmq.31.2022.07.25.07.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 07:07:52 -0700 (PDT)
Message-ID: <607cd14d-c1a6-52d2-0984-d67f04edf63f@gmail.com>
Date:   Mon, 25 Jul 2022 15:07:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and
 notifications
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Eli Schwartz <eschwartz93@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
 <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
 <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com>
 <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 13:08, Ammar Faizi wrote:
> On 7/25/22 6:28 PM, Pavel Begunkov wrote:
>> Don't see any reason for that
> 
> Not that important, just for easy finding. Especially when the number of tests
> increase. And yes, it always increases from time to time.
> 
>> especially since it's not sorted.
> 
> It was, but since that skip-cqe.c exists, it's no longer :p
> OK, OK, that's trivial, never mind. Let's move on.
> 
>>> New test should use the provided exit code protocol. This should have
>>> been "return T_EXIT_SKIP;"
>>
>> Oh, I already hate those rules, sounds like they were specifically
>> honed to make patching harder.
> 
> Lol, how damn hard is it to use it.

Not hard to use, I agree, but it's rather yet another thing that
I need to keep in mind and then it unavoidably gets forgotten and
makes to spend extra 10 minutes to fix/retest/resend/etc., which
is annoying.

Testing is not the most exciting part, frameworks are usually
trying to simplify writing tests even if there is a learning
curve. Implicit rules make it worse. I wouldn't have been
complaining if the compiler failed the build or at least
runtests.sh warned about it.


>> By the way, while we're at it, what is T_EXIT_ERROR? Why it's not used anywhere
>> and how it's different from T_EXIT_FAIL?
> 
> [ Adding Eli to the participants. ]
> 
> Ummm... yeah. I am curious about it too now. I just took a look at commit:
> 
>     ed430fbeb33367 ("tests: migrate some tests to use enum-based exit codes").
> 
> Eli said:
> 
>      From: Eli Schwartz <eschwartz93@gmail.com>
>      Date: Mon, 27 Jun 2022 14:39:05 -0400
>      Subject: [PATCH] tests: migrate some tests to use enum-based exit codes
> 
>      For maintainability and clarity, eschew the use of integer literals in
>      reporting test statuses. Instead, use a helper enum which contains
>      various values from the GNU exitcode protocol. Returning 0 or 1 is
>      obvious, and in the previous commit the ability to read "skip" (77) was
>      implemented. The final exit status is 99, which indicates some kind of
>      error in running the test itself.
> 
>      A partial migration of existing pass/fail values in test sources is
>      included.
> 
>      Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
> 
> 
> That T_EXIT_ERROR is 99 here. Not sure when to use it in liburing test. Eli?
> 
> [ Just for reference in case you (Eli) want to see the full message:
> 
>    https://lore.kernel.org/io-uring/c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com/  ]
> 

-- 
Pavel Begunkov
