Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C9A6225E7
	for <lists+io-uring@lfdr.de>; Wed,  9 Nov 2022 09:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiKIIxc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Nov 2022 03:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiKIIxO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Nov 2022 03:53:14 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644001DA47
        for <io-uring@vger.kernel.org>; Wed,  9 Nov 2022 00:53:10 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 3416A81549;
        Wed,  9 Nov 2022 08:53:07 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667983990;
        bh=4zzzB8mzfI5mdvdc1b9/qpNmqM33QXkCDQUUy5HF5m0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Um02FXSk0tl/9yOAGVIzJDTk+AGcxwflLnWjN5vE6QXmzrXN5xSaLwaZXDA2l/SL5
         USqAsv0WeV3h6PXFV2zq1nBxtYADKtizk90jYlmAFCyRaxjzY1kkcIcErGMS63bp8G
         1hb9QDugiiskrU+7+vnG/dLgKWM5J4GvcH6a97znBQemPdm7tXmJAHjDLIPFNBNyXs
         oTiavmDdhkfJHRGebYSSaUdFEDHuHzuUNS/CofCxewX5k2oLhpQ+KQScRVmTyEw62T
         ARKFhUoxQW0K/MwTWD3Jrciqhpa64CsaYG6c1xmMlnl1fvBFSBlff06zM89wNnBlks
         X4yr/5ZpePENw==
Message-ID: <82790d88-8893-1856-9b99-85c96d4f44cb@gnuweeb.org>
Date:   Wed, 9 Nov 2022 15:53:05 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing] Alphabetise the test list
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     Dylan Yudaken <dylany@meta.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221108172137.2528931-1-dylany@meta.com>
 <Y2qdkSw4h/AXw3lZ@kbusch-mbp>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <Y2qdkSw4h/AXw3lZ@kbusch-mbp>
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

On 11/9/22 1:18 AM, Keith Busch wrote:
> On Tue, Nov 08, 2022 at 09:21:37AM -0800, Dylan Yudaken wrote:
>> Alphabetical order is commanded by the comment at the top of the list
> 
> We could create a make target to detect this kind of thing. A quick
> script off the top of my head gets pretty close to finding improper
> order, though not sure how pedantic it needs to be with the dashes '-'.
> 
> $ diff -u <(sed -e '/test_srcs :=/,/EOL/!d' test/Makefile | sed '1d;$d' | sed 's/\.c//g') \
>            <(sed -e '/test_srcs :=/,/EOL/!d' test/Makefile | sed '1d;$d' | sed 's/\.c//g' | sort)

Good idea, we can also do this checking in our CI.

-- 
Ammar Faizi

