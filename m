Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3035823E8
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiG0KLX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 06:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiG0KLP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 06:11:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4655643323
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 03:11:14 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id A78FA80108;
        Wed, 27 Jul 2022 10:11:11 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658916674;
        bh=D88NiykOLr8ePsFqbq3xq7Eknx0IQi7ilMjyCoOFu1g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aGrmMsulo4R3OBQvKu1gNBvYWK9rBUmpiEFjDgXNB5Y9IViVVfj0AjQm2P5nbrmxk
         MFdVDYvJukXOzk0UwXENH6uZ8PcdKUNZEWYOtD8/90QWmARb0hSEUmeTMM09qOQG9e
         RsQC4OUvJuQfYGRii2Tax0sslAVrqlHe5ZgvtpqtmLqgzcHLnDavfe+KXtZZlSJgvX
         u9rYj3JgBzf9iwpMBO+Smr9lCPH8iO1OFKKPFj2ssMe2L3cB4LF4s5Te5hKHGxAcRF
         4iWKSOAyEy9uDg0EfrArSTL70v+1OdHa9vta6INLgP+567hYIEo12B7LBGOReMZ5me
         VVyBe7kVCYclg==
Message-ID: <9f3afabb-9c6b-4da4-c235-d02cd2142162@gnuweeb.org>
Date:   Wed, 27 Jul 2022 17:11:08 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
 <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
 <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
 <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
 <e126981a-c4c1-ca53-b98e-63ba1322f675@kernel.dk>
 <30e8595a4570ff37eb04cb627f64b71a5f948fd5.camel@fb.com>
 <dcb072b9-89d8-bc9d-1f79-daaa7b51cbe1@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <dcb072b9-89d8-bc9d-1f79-daaa7b51cbe1@gnuweeb.org>
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

On 7/27/22 4:59 PM, Ammar Faizi wrote:
> Interestingly GCC also complains here, but it doesn't complain when
> compiling your code. Your code only breaks my clang-13.
> 
> What is the magic behind this?

OK, I figured it out.

This work:

    gcc -D_GNU_SOURCE test.c -o test;

These 3 break:

    clang -D_GNU_SOURCE test.c -o test;
    clang test.c -o test;
    gcc test.c -o test;


So -D_GNU_SOURCE is the culprit. It seems to be unavoidable as
the warn seems to be compiler specific or something. Maybe that
_GNU_SOURCE patches the definition of bind().

-- 
Ammar Faizi

