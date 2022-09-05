Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70465AD439
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 15:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiIENpH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 09:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbiIENpG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 09:45:06 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164054D813
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 06:45:05 -0700 (PDT)
Received: from [192.168.169.80] (unknown [182.2.42.181])
        by gnuweeb.org (Postfix) with ESMTPSA id B6E30804D1;
        Mon,  5 Sep 2022 13:45:02 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662385504;
        bh=gvVQxJZSMT1cgcGMiAAZO6uHSrSU0CE8Hh3ghvOty1E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nfsU00yARqeDy6JGzelXXRQlRhsTxxR0gKo2Mljx1aCoIeZKB4WKJim68YyZ40Y6c
         8/VzlSjrfIePrCSBwVbhXF/pr38FecFDlEJbsQY6SN4CScziTM7BQfesWAAVXT7UPy
         xIN5pKQsjYe2TUVeYz54YTWkspfd+/3PGjPJv2sohTGR97iGDhGHKrySEgrTZ6l34B
         L2NzKem7DivSYneu9pKC7vZ5V9h8b5OC4S+Fx2R9e5P6tC4QNyWLAs4DDz289FCGK1
         2yXTMSgWPYrzY8+w2ePmCUrd+ZZOEicavXXnmmO4PTV6NyXqFMd46WinDyK68XsApD
         dHqSWg5MA+DAA==
Message-ID: <d2bacef0-e641-38e8-c5e3-fcb1618246b8@gnuweeb.org>
Date:   Mon, 5 Sep 2022 20:45:00 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v3 00/11] Defer taskrun changes
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Facebook Kernel Team <kernel-team@fb.com>
References: <20220905132258.1858915-1-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220905132258.1858915-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_SORBS_WEB,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 8:22 PM, Dylan Yudaken wrote:
> Dylan Yudaken (11):
>    Copy defer task run definition from kernel
>    Add documentation for IORING_SETUP_DEFER_TASKRUN flag
>    add io_uring_submit_and_get_events and io_uring_get_events
>    add a t_probe_defer_taskrun helper function for tests
>    update existing tests for defer taskrun
>    add a defer-taskrun test
>    update io_uring_enter.2 docs for IORING_FEAT_NODROP
>    add docs for overflow lost errors
>    expose CQ ring overflow state
>    overflow: add tests

Build tested each patch with GitHub bot, everything builds fine:

    https://github.com/ammarfaizi2/liburing/commits/testing/20220905132258.1858915-1-dylany@fb.com

Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org> # Build

-- 
Ammar Faizi
