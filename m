Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8B772EAC
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 21:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjHGTbI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 15:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjHGTbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 15:31:07 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C866A1715;
        Mon,  7 Aug 2023 12:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1691436657; x=1692041457; i=deller@gmx.de;
 bh=wSVekA65K/Veo0+qcLBCE3xG4Xh3gJNZbn/pjzzV/0U=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=UDuB0t0wYXkYW+AkWVH2Y+QZ3cxgVYvLKghzqt38aJPWbN4CTaXOX6uN4TDy9aV16i680rE
 sTduDM7eRU7/MLLxyBsNU1/bnV3qvwXqnfrnZ6neX+hR3MXVYa8h7Uy1KeXvNi0PnrVKZvGq0
 fjP6L3c3Vvq7B0btN0Xr6szfpk5+nQtjnLbQyvTOpAhTxF1zo0S1FBvVReLYypxKVPwjtk830
 CYZ95UmOs12DbJs5i/XToQiag4kfavfrduCetKaYVAUNQTdITv1EJsGvkIbLF70C/kj/aLjDJ
 TvjUF5W/drQGW6zsYNkOI7kmxJfpnXWjgeGVcC2Q6Muo/Q4qbFBw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.150.52]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N1Obh-1pngQV3Spv-012oIr; Mon, 07
 Aug 2023 21:30:56 +0200
Message-ID: <9f784da2-b700-14ee-ad52-e7c039f005f0@gmx.de>
Date:   Mon, 7 Aug 2023 21:30:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring/parisc: Adjust pgoff in io_uring mmap() for
 parisc
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-parisc@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
References: <ZMle513nIspxquF5@mail.manchmal.in-ulm.de>
 <ZMooZAKcm8OtKIfx@kernel.org> <1691003952@msgid.manchmal.in-ulm.de>
 <1691349294@msgid.manchmal.in-ulm.de>
 <f361955c-bcea-a424-b3d5-927910ab5f1d@gmx.de>
 <b9a15934-ea29-ef54-a272-671859d2bc02@gmx.de> <ZNEyGV0jyI8kOOfz@p100>
 <c4c3ae81-33aa-26ba-3a24-33918e0446e4@kernel.dk>
 <ac18c4d4-7ca2-4648-77d2-3053c1de93f7@gmx.de>
 <f5cc80b6-566d-816f-7fd9-099c58cca3d0@kernel.dk>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <f5cc80b6-566d-816f-7fd9-099c58cca3d0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OtWTpjT+IECRyQXWiluZdwiCk5f+3gdeq4dOl+toC6/Nbpu3mkD
 eTJkRm9lN9F7a5s92r7NX27PfjRmUFHTfV9DimnnRu6FXvvmCB2el8MeehDn6wgDX9qQsFw
 v16uH/3aNJH4svDPcoQMvmnqtDf8BmunS/VTkaUNUDOW8XrDg3DIEjCpnuRNf8O4hqzanl6
 bBqiECsqZb2QKBWPJkkMw==
UI-OutboundReport: notjunk:1;M01:P0:jbHO8hn0CRs=;eT63EMuxODbrZ2bgOXTOHu1wB2X
 aqCxO27egUzMmkReZc5K0O5IURBcAvE1q0pgyUSVjbY1AwmYfL7H6CGabz+EFKFSv8kTn1TT8
 iZKRNFB30NfOD7XTPYJM//JQiShXiodzjCVqk3FbS2MEXC+UAQAiUytRdCNqu2nzvU/uxsW7c
 f7WYR20kJXL0HMXVaw1uZCcd0MbqcmsXNI596ZJhoOPUXQnJXc9gj1FzoVc2G0ZF+gmbfnnHg
 wcBhToohsQXJmXpidtvyjcp0MiKYzhY+cDUVgLupNYPo49Xedw1YN2eYFXxfC6Inh3xp5pxPm
 Y8sj9N1zh5olIXVmZsqnSSHYU7HjLo7YEOJQjU6CP287QB8fh7C+7BLr9x5CIBDd9CuYqoDYB
 qVkDDO6BwzTl+sqZR22LzOYHJQ9Dg3KpYNl10norCOhFko3Z3T+WKGme7DQpKVGbHn+HkyV4Q
 bQR2LvrM1p8ZZGI2YpAvDNOW7GnsrMmx8IQBGeluu9NLqAQlvrO89j2DCII8i1W1vRGcWaZqk
 wpNTAeFL9LMr4rphwMuKvKT4QALJBj68JSha4E82pdMwFZMMict1MJouQ5l2hU8Ht6Lxat4Re
 KsXuNimlwD0ydVNh7WR9l7iyEmToQOFEzVKxd/Y+D0+dE0AAV3efoGWJZhBZSawbN6kwz3ZMx
 4skP9zXq4DjdreSOSReATXaUrpHVYVW/aouM/yEyegIrapWvsXvtCdQg64SKi0RqneOUcNlOc
 uS0I1cPL0u5+Y1QStj1ATa7aoBMVO7hm3MKafLmseMAE+hOb+li3MoFXFLeGOXParmpqBvlT1
 KUU1XT1ylopeUHIYJFtS0DdCoAMQctFXt+E8QOPtVpamaCq10s3Sk3Y7ia3/R/Ry7eoyW+xxu
 QIlE1V0bG0fHH75fEmqjv1WvkiwwNJeG7ovBan8Xk2gI6mEe/dQy7LVkVGTtj8VMsDAcW6MG4
 QYOB6oyZhvglr1CDLRcbDphmrUk=
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/23 20:33, Jens Axboe wrote:
> On 8/7/23 12:27?PM, Helge Deller wrote:
>> On 8/7/23 20:24, Jens Axboe wrote:
>>> On 8/7/23 12:04?PM, Helge Deller wrote:
>>>> The changes from commit 32832a407a71 ("io_uring: Fix io_uring mmap() =
by
>>>> using architecture-provided get_unmapped_area()") to the parisc
>>>> implementation of get_unmapped_area() broke glibc's locale-gen
>>>> executable when running on parisc.
>>>>
>>>> This patch reverts those architecture-specific changes, and instead
>>>> adjusts in io_uring_mmu_get_unmapped_area() the pgoff offset which is
>>>> then given to parisc's get_unmapped_area() function.  This is much
>>>> cleaner than the previous approach, and we still will get a coherent
>>>> addresss.
>>>>
>>>> This patch has no effect on other architectures (SHM_COLOUR is only
>>>> defined on parisc), and the liburing testcase stil passes on parisc.
>>>
>>> What branch is this against? It doesn't apply to my 6.5 io_uring branc=
h,
>>> which is odd as that's where the previous commits went through.
>>
>> applies for me on git head / Linux 6.5-rc5
>
> Hmm, maybe something unrelated then. I'll take a look. The patch is
> garbled fwiw, but that's nothing new. If you download the raw one from
> lore you can see how.

That's strange. I usually send to the mailing list, and then apply
from patchwork, in this case from here:
https://patchwork.kernel.org/project/linux-parisc/patch/ZNEyGV0jyI8kOOfz@p=
100/
That worked for me.

Helge
