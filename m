Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B58584CFD
	for <lists+io-uring@lfdr.de>; Fri, 29 Jul 2022 09:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234945AbiG2Hxa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Jul 2022 03:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiG2Hx3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Jul 2022 03:53:29 -0400
X-Greylist: delayed 331 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Jul 2022 00:53:27 PDT
Received: from faui40.informatik.uni-erlangen.de (faui40.informatik.uni-erlangen.de [IPv6:2001:638:a000:4134::ffff:40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ACC7E016
        for <io-uring@vger.kernel.org>; Fri, 29 Jul 2022 00:53:27 -0700 (PDT)
Received: from [10.188.34.160] (i4laptop09.informatik.uni-erlangen.de [10.188.34.160])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: flow)
        by faui40.informatik.uni-erlangen.de (Postfix) with ESMTPSA id 9A49E58C4AF;
        Fri, 29 Jul 2022 09:47:51 +0200 (CEST)
Message-ID: <29c0d848-0789-4062-dca0-88ab9e8ab3f6@cs.fau.de>
Date:   Fri, 29 Jul 2022 09:47:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing] add additional meson build system support
Content-Language: en-GB
To:     Bart Van Assche <bvanassche@acm.org>, io-uring@vger.kernel.org
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
 <678c7d14-22da-1522-ea41-5dbd21e0c7b4@acm.org>
 <20220727205329.jgr5i5ou4oxc2ttc@pasture>
From:   Florian Schmaus <flow@cs.fau.de>
In-Reply-To: <20220727205329.jgr5i5ou4oxc2ttc@pasture>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27.07.22 22:53, Florian Fischer wrote:
> On 27.07.2022 12:21, Bart Van Assche wrote:
>> On 7/27/22 08:27, Florian Fischer wrote:
>>>    11 files changed, 619 insertions(+), 4 deletions(-)
>>
>> To me this diffstat tells me that this patch series adds a lot of complexity
>> instead of removing complexity.
> 
> That's because Jens wants to keep both build systems in the repository.
> 
>   .github/workflows/build.yml      |  44 +++++--
>   .gitignore                       |   2 +
>   Makefile                         |  84 ------------
>   Makefile.common                  |   6 -
>   Makefile.quiet                   |  11 --
>   configure                        | 467 -----------------------------------------------------------------
>   examples/Makefile                |  41 ------
>   examples/meson.build             |  19 +++
>   man/meson.build                  | 116 ++++++++++++++++
>   meson.build                      | 119 +++++++++++++++++
>   meson_options.txt                |  14 ++
>   src/Makefile                     |  87 ------------
>   src/include/liburing/compat.h.in |   7 +
>   src/include/liburing/meson.build |  51 +++++++
>   src/include/meson.build          |   3 +
>   src/meson.build                  |  28 ++++
>   test/Makefile                    | 238 ---------------------------------
>   test/meson.build                 | 219 +++++++++++++++++++++++++++++++
>   18 files changed, 609 insertions(+), 947 deletions(-)
> 
> This is what the diffstat could look like if we would remove the old build system.

To point this out explicitly:

old Makefile-based build system: 947 LoC
new Meson-based build system:    609 LoC

That is a significant reduction in build-system complexity, while the 
new Meson-based build system has more features, e.g., out-of-source 
builds and a sensible test framework. For further features, see the 
cover-letter of this patch set.

- Flow


