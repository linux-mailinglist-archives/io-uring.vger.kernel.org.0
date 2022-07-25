Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A9558043B
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 20:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiGYSz7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 14:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiGYSz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 14:55:58 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A21BE1C
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 11:55:56 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id x64so9550988iof.1
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 11:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PHMslPJXw8iRyb/GfZ+AMr3mdCJKPXY38ROkWMUvJ3c=;
        b=nH5oBF1O0CI264TIWJL653jmmh/JGNNGW3MivlGn0Rmiazl4/KA8ndVyUILFr53XpC
         3zzhly+On8/h7PVpy18mrq7cYv94cgo83J4EYt2xuH6cVGIW2Jjh/0xsrn4gkMgfhkY9
         +OiCOFTcuAJm1zRH5z2iXwTHCU0cknxjVFKpiEtVzNC/w4LIAczLuJ5tjeMrTI8VtAJ+
         vjoTxUc2VC6kxmU5IafKC7pQv1xB3QmgbyK7TLuz+1Fos6iRcx98mz0lbXs1PsUwxq0a
         hfp+o5vm461YFhhg4RaB3cFUKtva6dEUy8kYPAcH15x1Wd71IPAUh2QLiOIIbqLbFCCd
         Xpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PHMslPJXw8iRyb/GfZ+AMr3mdCJKPXY38ROkWMUvJ3c=;
        b=bk0hQVHtQKLllDm9NwAksm5EJNiPOXIzp1XVOBhp1UKsJ9yFvMRoxwu8Q9kCP6uxHF
         l38oS7UrFXcH39EeLJjnptx9VD7XEvdQ7Omjlsfj4x7xdChZXfQJrSt5APuRBaxocFXC
         mLR6bDOuvQMLoG4AfmDPXChMq1E3jsqDPnsReLLnYlz6Ikp6XsqjaLG585HQRfgozezO
         NrjPQXlkAMI+rJxXOwckYwFlGisqKFsuoN8RSI7FrGMUZJ8Qv8znmcA7pW6VqIw9QlcS
         1vmCMF8egEA/bND1XuBffrL+GOqn1izAWWwV+WHDnDUsSxPJtxJj3n/vE0uO/uOtR0uP
         EAAw==
X-Gm-Message-State: AJIora85GoEYO9bixCXuzw8WKLEKUArHThEHvBc8/408pttbQ3EB8pHx
        iSd1ADcKcZyoUBQwojtE071jmrkeedurxM6M
X-Google-Smtp-Source: AGRyM1tk9xxrIeEokNlFZ/mYT6FF6PjJ25/FkSWnmBo3D+Tji4cmokpUQT0vWB0GCOtZwaMema/+qA==
X-Received: by 2002:a5d:888e:0:b0:67c:a59e:5ce4 with SMTP id d14-20020a5d888e000000b0067ca59e5ce4mr1862676ioo.21.1658775355280;
        Mon, 25 Jul 2022 11:55:55 -0700 (PDT)
Received: from ?IPV6:2600:1700:57f0:ca20:763a:c795:fcf6:91ea? ([2600:1700:57f0:ca20:763a:c795:fcf6:91ea])
        by smtp.gmail.com with ESMTPSA id g17-20020a022711000000b0033f3a1a1b60sm5700674jaa.171.2022.07.25.11.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 11:55:54 -0700 (PDT)
Message-ID: <7f146700-ad7a-08b2-ecb8-c88d4f57a8eb@gmail.com>
Date:   Mon, 25 Jul 2022 14:55:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and
 notifications
Content-Language: en-US-large
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
 <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
 <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com>
 <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org>
From:   Eli Schwartz <eschwartz93@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
In-Reply-To: <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 8:08 AM, Ammar Faizi wrote:
> On 7/25/22 6:28 PM, Pavel Begunkov wrote:
>> By the way, while we're at it, what is T_EXIT_ERROR? Why it's not used
>> anywhere
>> and how it's different from T_EXIT_FAIL?
> 
> [ Adding Eli to the participants. ]
> 
> Ummm... yeah. I am curious about it too now. I just took a look at commit:
> 
>    ed430fbeb33367 ("tests: migrate some tests to use enum-based exit
> codes").
> 
> Eli said:
> 
>     From: Eli Schwartz <eschwartz93@gmail.com>
>     Date: Mon, 27 Jun 2022 14:39:05 -0400
>     Subject: [PATCH] tests: migrate some tests to use enum-based exit codes
> 
>     For maintainability and clarity, eschew the use of integer literals in
>     reporting test statuses. Instead, use a helper enum which contains
>     various values from the GNU exitcode protocol. Returning 0 or 1 is
>     obvious, and in the previous commit the ability to read "skip" (77) was
>     implemented. The final exit status is 99, which indicates some kind of
>     error in running the test itself.
> 
>     A partial migration of existing pass/fail values in test sources is
>     included.
> 
>     Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>
> 
> 
> That T_EXIT_ERROR is 99 here. Not sure when to use it in liburing test.
> Eli?


A test failure means that the test ran "successfully", and reported that
something is wrong with the software being tested. It is collected as a
test result which needs to be investigated to fix the software, but only
usually. It's also possible for some test harnesses to have a list of
tests where you know you have a bug, you know it's not fixed, and you
don't want to be constantly bothered by it, so you mark it as
"should_fail: true" (Meson) or XFAIL_TESTS= (GNU autotools) so that the
test report harness doesn't list it either as a "pass" or a "fail".
Instead it's listed as "expected/known fail" and the test harness itself
doesn't count it as an overall failure.

(If that test starts to pass, it's reported as an "unexpected pass" and
the test harness itself counts it as an overall failure. The idea is
that you then want to do your bookkeeping and record that whatever
commit caused the unexpected pass, has fixed a longstanding bug.)

...


T_EXIT_ERROR is different. It doesn't mean the test ran, and reported
something wrong with the software (e.g. liburing). Instead, an ERROR
return value indicates that the test itself broke and cannot even be
relied on to accurately test for a bug/regression. For example, if that
test was designated as an expected failure, it still knows that in this
case, error != fail, and it won't ignore the result as an expected failure.

Also in general, if you see test errors you know to look at bugs in the
testsuite instead of trying to debug the software. :)

I added T_EXIT_ERROR because it may be useful, without knowing in
advance whether I would have cause to use it anywhere. It's a valid
possible state.


To quote
https://www.gnu.org/software/automake/manual/html_node/Generalities-about-Testing.html


"""
Many testing environments and frameworks distinguish between test
failures and hard errors. As we’ve seen, a test failure happens when
some invariant or expected behaviour of the software under test is not
met. A hard error happens when e.g., the set-up of a test case scenario
fails, or when some other unexpected or highly undesirable condition is
encountered (for example, the program under test experiences a
segmentation fault).
"""

-- 
Eli Schwartz
