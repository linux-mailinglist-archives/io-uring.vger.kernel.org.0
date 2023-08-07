Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6335C772DDB
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 20:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjHGS1Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 14:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbjHGS1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 14:27:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002ADFD;
        Mon,  7 Aug 2023 11:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1691432833; x=1692037633; i=deller@gmx.de;
 bh=kZEl7A/Sjwt99jFmYUwnCrQsmd0fkFfRATdOTgUBFhk=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=Gw22L2Cb/C/lPy/gNd9S050798TbbXBRCw/VXZv7v50sVq062n4SxSJ9+izQQkPRDWhRtqy
 PkvdxvwYgrrfNmbVSW/AdS5PPxtLZAJEKZwhHBszeRFhwG3iCte2DpjI7BK+YBkzslcFh5siq
 3r5Nd/qBv2XOj9MdOfwRLHmFvO/nS6o/YQMYyZX8Qy6H3e1RBQfgX/V2Y7CitYyAfCZseWjQq
 ySVGn4QsLnX2xNcOUFHBHHxBYskRjNUv5INS8ZleZrfebgT9vHQths6e0ED6xMvDch7SSyMGu
 YNQ4vXtsv76/TrFsxwkgQTpITeQGhDJEq+QiI82C/gvotUqjf/Sg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.150.52]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MhlKs-1ppbKj0DUO-00dmiy; Mon, 07
 Aug 2023 20:27:13 +0200
Message-ID: <ac18c4d4-7ca2-4648-77d2-3053c1de93f7@gmx.de>
Date:   Mon, 7 Aug 2023 20:27:12 +0200
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
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <c4c3ae81-33aa-26ba-3a24-33918e0446e4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8hEMBp7VV8lCVHBYjPf80RnCfTHxHIELEbGmq7zVVRMPCsCO4TD
 Az0PWqfADgiznNCrLoexvJlju1FO1YPds6Ore1zjQq1ldMCYf666siNEaIH92VEG54Q/rlU
 cRSzKnbuZ7bCaEZ/RfqhkZSVPOWLbAzimXn6R6xmzVy5NvqzNEMAVPKx0suK9QDniDilJ2i
 /NGX0VUPCuK0mE2WS5cTw==
UI-OutboundReport: notjunk:1;M01:P0:NAyfbFltTaM=;MYQLTrLe40fgLIkziAIFLsTgtF6
 p8bZzsrbxfb1wZXmIRJq/DP5VX4rYOpRSQ86BV933Me+TandXxh2kJmh9IFX1cOo/c+b5t2H3
 yPPHN4nCueHYMQOBf3Nq8SFOPL8vbLz+eQ9/J1h9hr1mu0yYEZesgX1TdcyQ8aCNB7rLth3Ka
 rmbVgrfno2oDVqz8cEiU6HglxE1mYsFsQgLKkcjckcOYxwFqc9BFA/aE0rQoIiiyAecOI4xi6
 hDXq+DpCFgs8LVnhjQPW27Lk33BduZVDVRml6RqtwYRIIoAGhrZY3kBqyL4pBqzCDgTV1C5JY
 dPGoDn2oRv5fdZ9Vhnax46fkMrZV7rQ/mLLc7SnzLFIMlRMULWiT8pllxg3Cl0R4aPGwhwgve
 Kz4blgKdjRyniq8FXz8NIsqJTcW0Grr0b9fx0G/dy20roQPINWWLmXiCb+j50sY/ypXI06oI6
 RoI/GC+Hi1AO3diHsG++lDo3/YVYLsup7Sa03KgyYZHoGtVTDHO+dkGql3WNM90WSq6smJ84G
 NnGpfRBtNfrIWSj/pjZAR9KaAcr+opEdSQHJJswU2pOH2/bBbvIEmRejk428x89BEOk7bHXKN
 F6nnU8Cr7Bds3CUqy+hKcYEdWm9+0NsvZJK2yGrrCAWypsz8VQXaDSnR/ws6nHvbGe6YxwROr
 azDDAVxkhTZlxeYzSqDUgWChNNrEBBEwNamCdyJ+Nd01WCVl+GlzwE6oERbN3c8lttO9pBWPv
 GROg3cFL6aaKYJ2xc/BRJIZVmgtc17pA77uPQ48tRRQcKkWKimCc2FO/HDTpYkJx8N9z8uyju
 VJOeU2d9qQPm1YdhrZYDtbPSR/pWwlM/m7EW1U7jn2HaM4FM/VBsbAeilN9xzN8EjyS45ouUG
 pYQV9BSOHa7gEC6fywN8n8jAjg+GGjQeOeUDpc5NW/khBEk0AVg2vA8GH6ABGPJrznahC9VAy
 ZvF7siWcZtQsAs1uGDy0wmm7ngw=
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/7/23 20:24, Jens Axboe wrote:
> On 8/7/23 12:04?PM, Helge Deller wrote:
>> The changes from commit 32832a407a71 ("io_uring: Fix io_uring mmap() by
>> using architecture-provided get_unmapped_area()") to the parisc
>> implementation of get_unmapped_area() broke glibc's locale-gen
>> executable when running on parisc.
>>
>> This patch reverts those architecture-specific changes, and instead
>> adjusts in io_uring_mmu_get_unmapped_area() the pgoff offset which is
>> then given to parisc's get_unmapped_area() function.  This is much
>> cleaner than the previous approach, and we still will get a coherent
>> addresss.
>>
>> This patch has no effect on other architectures (SHM_COLOUR is only
>> defined on parisc), and the liburing testcase stil passes on parisc.
>
> What branch is this against? It doesn't apply to my 6.5 io_uring branch,
> which is odd as that's where the previous commits went through.

applies for me on git head / Linux 6.5-rc5

Helge
