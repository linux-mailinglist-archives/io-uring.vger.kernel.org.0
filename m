Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC74F0B8A
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 19:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243742AbiDCRXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 13:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242679AbiDCRXW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 13:23:22 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BD239836
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 10:21:28 -0700 (PDT)
Received: from [192.168.148.80] (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id D158B7E342;
        Sun,  3 Apr 2022 17:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649006488;
        bh=8h2vcjBvCgvusgr24+XuRteLfYyKuWFby61tVd/ribY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UTurUved6vmZBkOhMcjGb7bT8IgV2vjFBGPlchybIq4tWGvnaSdXgggzXXLj6KynM
         BS3MVkbyFPcl7TWNlydz5kQ6isSXcgOXz4Oo+tpgtMr5p8lbywWfFY1xBCr41KcJVF
         dITpdskyss2UzeY4CuNIojsQH24jB76msRPl84JFqttCCprKfOQLNAjxOJSokIZaXy
         8mtWFllVjKGvfHq16gcYbVL8bMTH01sSsMgb3FdpBjZa9HnFijRHO4isqGmdQEHFe6
         v2zL8TAA/uz5ZjhuIOFSfXFc8YbXcig1i23atoEnum4CxJfFjBE3uxJbKcXQvhAmTD
         Lgbp9k7ItQFYw==
Message-ID: <731ea3f1-74e2-a61e-795c-ef3dd6cea359@gnuweeb.org>
Date:   Mon, 4 Apr 2022 00:21:23 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing 2/2] test/Makefile: Append `.test` to the test
 binary filename
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403153849.176502-1-ammarfaizi2@gnuweeb.org>
 <20220403153849.176502-3-ammarfaizi2@gnuweeb.org>
 <771eab67-74ba-710e-854a-975a779a9ced@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <771eab67-74ba-710e-854a-975a779a9ced@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 11:43 PM, Jens Axboe wrote:
> On 4/3/22 9:38 AM, Ammar Faizi wrote:
>> When adding a new test, we often forget to add the new test binary to
>> `.gitignore`. Append `.test` to the test binary filename, this way we
>> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
>> test binary files.
>>
>> Goals:
>>    - Make the .gitignore simpler.
>>    - Avoid the burden of adding a new test to .gitignore.
> 
> Just a cosmetic issue, but the .test does bother me a bit. Probably just
> because we aren't used to it. Maybe let's just call them .t? And we
> should probably rename the foo-test.c cases to just foo.c as a prep patch
> too.

Yes, I agree. Will do it in the next version.

-- 
Ammar Faizi
