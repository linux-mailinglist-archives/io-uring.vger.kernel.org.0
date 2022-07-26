Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E09D5817D5
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiGZQsb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbiGZQsa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:48:30 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C0925E9E
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:48:29 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 3682C7E254;
        Tue, 26 Jul 2022 16:48:25 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658854108;
        bh=gHHOXEloAo924tHqCgTdaJw+WSK4ZrFmYZEDj3X0B6I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZlfHDqP1B6VWZm3Glp6W64zWNswvRyepA6j15p35SFeMhX9DHea0vBCSaCMOh7rSw
         fFLAZrINcSlwT6ZvXkgSZ+O79sEpKUeklaVck/90L1/3/gKTRtKGZYHk8kOG6DOmku
         JLhv83rWHtIUuijNhJdxQFFX1g7sHK5jXbTSqFo7Ew84YDvYADQun2M4PxkFe7j+oF
         xtK+Te+huC37NkVKchpqwj0b4DyHlEV7D/MHkACJhYwnziSwQLuzWvaDiQVEDY1/EW
         uiamgCrd+h+b5ldP32jcDfDHBHr9C/ZJbb8XxJaLs3OqLP4uXTqrasdA+HFal7h7Sn
         uN5TDrPCBFjqA==
Message-ID: <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
Date:   Tue, 26 Jul 2022 23:48:22 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
 <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
 <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/22 11:40 PM, Jens Axboe wrote:
> On 7/26/22 10:32 AM, Ammar Faizi wrote:
>> On 7/26/22 11:23 PM, Jens Axboe wrote:
>>> [5/5] add an example for a UDP server
>>>         commit: 61d472b51e761e61cbf46caea40aaf40d8ed1484
>>
>> This one breaks clang-13 build, I'll send a patch.
> 
> Hmm, built fine with clang-13/14 here?

Not sure what is going on, but clang-13 on my machine is not happy:

     io_uring-udp.c:134:18: error: incompatible pointer types passing \
     'struct sockaddr_in6 *' to parameter of type 'const struct sockaddr *' \
     [-Werror,-Wincompatible-pointer-types

     io_uring-udp.c:142:18: error: incompatible pointer types passing \
     'struct sockaddr_in *' to parameter of type 'const struct sockaddr *' \
     [-Werror,-Wincompatible-pointer-types]

Changing the compiler to GCC builds just fine. I have fixed something like
this more than once. Strange indeed.

-- 
Ammar Faizi

