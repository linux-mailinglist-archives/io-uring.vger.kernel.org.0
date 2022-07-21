Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE79157CF45
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiGUPgE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbiGUPf2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:35:28 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73654BCBE
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:35:13 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id E203C7E24B;
        Thu, 21 Jul 2022 15:35:10 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658417713;
        bh=CLJVRL0krx9zXhcNk71Yux6ohWEhnwRIr+nKd5s0z2o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mWnvngfY3G3s5vWTfJwJb7xYp1Z4Nfykz33Y+m2+vLEbLGLUDNpRhOAK4qUGqzjQX
         rb8uFCOgMNuEHKt84/Ab3IdXHfVsO40cvCV2ECkqhAtuxuuCHq2s5Y8HRWGmVD3vJv
         2Bw+EAmEOBWw/qJBJoCUU7h9KCA3F6oSaZk49/1Zv4ahe41NLoOjgJNNByti07yulY
         QWoNOAlqD2Mt0b6G7f5b9BLspAiGdInxujqzhqjTzpj8sLSX1TgPUAeoBoBkMFoDVj
         r4e5Q1U9RQINL1VCgYn64ytCOYDg4mrg/mXWBSavlbSq+7cAnS+iadxeK2kGQmHCWz
         SBsQAh/R/LYPA==
Message-ID: <aa364933-4113-3e69-eed9-8fe6a8197f42@gnuweeb.org>
Date:   Thu, 21 Jul 2022 22:35:08 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing] Delete `src/syscall.c` and get back to use
 `__sys_io_uring*` functions
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org>
 <165841756488.96243.3609313686511469611.b4-ty@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <165841756488.96243.3609313686511469611.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/22 10:32 PM, Jens Axboe wrote:
> On Thu, 21 Jul 2022 16:04:43 +0700, Ammar Faizi wrote:
>> Back when I was adding nolibc support for liburing, I added new
>> wrapper functions for io_uring system calls. They are ____sys_io_uring*
>> functions (with 4 underscores), all defined as an inline function.
>>
>> I left __sys_uring* functions (with 2 underscores) live in syscall.c
>> because I thought it might break the user if we delete them. But it
>> turned out that I was wrong, no user should use these functions
>> because we don't export them. This situation is reflected in
>> liburing.map and liburing.h which don't have those functions.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] Delete `src/syscall.c` and get back to use `__sys_io_uring*` functions
>        commit: 4aa1a8aefc3dc3875621c64cef0087968e57181d

Sorry Jens, it breaks other architectures, will send a patch shortly.

-- 
Ammar Faizi
