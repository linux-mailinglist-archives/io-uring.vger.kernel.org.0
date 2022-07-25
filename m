Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B94457FEBF
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbiGYMIM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 08:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbiGYMIM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 08:08:12 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D67DF61
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 05:08:08 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 72E9F7E328;
        Mon, 25 Jul 2022 12:08:06 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658750887;
        bh=2W5s4hBKpEKWfqpEjEhXd7acpOHdB8KEaKRcLMgyvK8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mqgY9828OOMWZoHtY51VuZKEXnc0Ax2srZGr54xAEHiT/wrj/qlqFqViVsewgA6Pa
         KUzdhBnfME8rwX2dE3VHdk+lH9cQJkRzSnOoC4DoHLYoq2Z2R5hjGqBeaevGaKHxVO
         fBLretFLcsnne/cENUO8tiD8scl9TXhcDqVXC1WKSelhlcNSfLelJDjTRYAWFeCaig
         0PGI6j8ImwJSrD1sa8uYh9GzwtoPkTEtrNH6QlsdT2FZIMuzI4UGOYh1WH3/gjZxgG
         KfZb5cx6bc8grI/NALqgsbLSkbJto/rU/LR7j3ZrY9Jod1ae5V8Bp7X9qQGRd7jgnc
         4oFUzleZzZl+g==
Message-ID: <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org>
Date:   Mon, 25 Jul 2022 19:08:03 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and
 notifications
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Eli Schwartz <eschwartz93@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
 <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
 <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com>
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

On 7/25/22 6:28 PM, Pavel Begunkov wrote:
> Don't see any reason for that

Not that important, just for easy finding. Especially when the number of tests
increase. And yes, it always increases from time to time.

> especially since it's not sorted.

It was, but since that skip-cqe.c exists, it's no longer :p
OK, OK, that's trivial, never mind. Let's move on.

>> New test should use the provided exit code protocol. This should have
>> been "return T_EXIT_SKIP;"
> 
> Oh, I already hate those rules, sounds like they were specifically
> honed to make patching harder.

Lol, how damn hard is it to use it.

> By the way, while we're at it, what is T_EXIT_ERROR? Why it's not used anywhere
> and how it's different from T_EXIT_FAIL?

[ Adding Eli to the participants. ]

Ummm... yeah. I am curious about it too now. I just took a look at commit:

    ed430fbeb33367 ("tests: migrate some tests to use enum-based exit codes").

Eli said:

     From: Eli Schwartz <eschwartz93@gmail.com>
     Date: Mon, 27 Jun 2022 14:39:05 -0400
     Subject: [PATCH] tests: migrate some tests to use enum-based exit codes

     For maintainability and clarity, eschew the use of integer literals in
     reporting test statuses. Instead, use a helper enum which contains
     various values from the GNU exitcode protocol. Returning 0 or 1 is
     obvious, and in the previous commit the ability to read "skip" (77) was
     implemented. The final exit status is 99, which indicates some kind of
     error in running the test itself.

     A partial migration of existing pass/fail values in test sources is
     included.

     Signed-off-by: Eli Schwartz <eschwartz93@gmail.com>


That T_EXIT_ERROR is 99 here. Not sure when to use it in liburing test. Eli?

[ Just for reference in case you (Eli) want to see the full message:

   https://lore.kernel.org/io-uring/c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com/  ]

-- 
Ammar Faizi
