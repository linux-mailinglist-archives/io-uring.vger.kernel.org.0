Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D7557FEDB
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiGYMR6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 08:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiGYMR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 08:17:57 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA97E08A
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 05:17:56 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 90FD37E257;
        Mon, 25 Jul 2022 12:17:55 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658751476;
        bh=U7g3GFzd3m9WTrZYay9SfzKM9NTbpxkhHnYFcSx/nNw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=EW3LUU1w+qqQBxSJtk9cLm+NLDmgYSPBqr5+rUpQMBekynVigecBUX+jEd+mxgWyM
         wGE9oBxD1nrqBfUbVGEIT1pCfUed7xPIPfLfHC5kp3uwt/rNOQoRe94c75cFZKUdA6
         dgQsqpLdq0Zr7NPzMHMvvKD02o5g7XA85rluV2Rrj9QKoYXfepG+3W/wy1Qzp4dof7
         fQAm7gzExk6MuL07ZQmO2vWMW2yOUKGyaLJq8ojEkW9aOCsE0Ph74bxrqzzkC3CyZk
         LAcEZ3+LteJwlLmn2jKpE44MZgD2zNhEzIga1VunTPh5x8/d2G6WRxY6m71FmAwzlJ
         gWbnw+4xhpQRA==
Message-ID: <ee27c605-20fa-2a6c-ecb4-738d859f8cd1@gnuweeb.org>
Date:   Mon, 25 Jul 2022 19:17:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v2 0/5] zerocopy send headers and tests
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1658748623.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <cover.1658748623.git.asml.silence@gmail.com>
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

On 7/25/22 6:33 PM, Pavel Begunkov wrote:
> Add zerocopy send headers, helpers and tests
> 
> v2:
> 	use T_EXIT_*
> 	fix ptr <-> int conversions for 32 bits arches
> 	slight renaming
> 	get rid of error() in the test
> 	add patch 5/5
> 
> Pavel Begunkov (5):
>    io_uring.h: sync with kernel for zc send and notifiers
>    liburing: add zc send and notif helpers
>    tests: add tests for zerocopy send and notifications
>    examples: add a zerocopy send example
>    liburing: improve fallocate typecasting

I can confirm it compiles fine on all architectures now. Nice.

-- 
Ammar Faizi
