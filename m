Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BB25AADFC
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 14:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiIBMBx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 08:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiIBMBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 08:01:45 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B35A71736
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 05:01:33 -0700 (PDT)
Received: from [192.168.230.80] (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 97B2280C16;
        Fri,  2 Sep 2022 12:01:31 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662120092;
        bh=O5qzWDaFBBYPd+Ip+ZSxi07Jcby4KvI9GCS6Rsij5B4=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=OxwzAx9qxzLrcdY5nq6j3rclfjA8cLaZreQuwvFR7Zo3OHL6bZjoaCvynt47vXBKy
         m6UWBzWuWoLnDs6240zXMfhFFh8kkO08AW3eyAwsoEYBHJAo5vyN/qTQ15BlV5YwI7
         rEWc7J02aY/p9uCfvSn28d3PdeFrfKT4Bc8LevGCBfYfvapD0iybjnqq9RMkGt2nrX
         vW3660ykoCj/zILr/QjYLhSxAe8K1RQSDKfoo6ShdqBmYYCrx3iFrXs23hRTQn47/T
         XBkzzdEYT8zqAzB4fWjWOH1Jrvt6FwVyUu1sCs6QFEzDEhT0z1dRVSwPlPR20QGIcH
         rrFUyvZnQKJdw==
Message-ID: <c4958f35-11e5-5dd9-83c5-609d8b16801b@gnuweeb.org>
Date:   Fri, 2 Sep 2022 19:01:28 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/4] zerocopy send API changes
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1662116617.git.asml.silence@gmail.com>
 <5aa07bf0-a783-0882-0038-1b02588c7e33@gnuweeb.org>
In-Reply-To: <5aa07bf0-a783-0882-0038-1b02588c7e33@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 6:56 PM, Ammar Faizi wrote:
> On 9/2/22 6:12 PM, Pavel Begunkov wrote:
>> Fix up helpers and tests to match API changes and also add some more tests.
>>
>> Pavel Begunkov (4):
>>    tests: verify that send addr is copied when async
>>    zc: adjust sendzc to the simpler uapi
>>    test: test iowq zc sends
>>    examples: adjust zc bench to the new uapi
> 
> Hi Pavel,
> 
> Patch #2 and #3 are broken, but after applying patch #4, everything builds
> just fine. Please resend and avoid breakage in the middle.
> 
> Thanks!

Nevermind. It's already upstream now.

-- 
Ammar Faizi
