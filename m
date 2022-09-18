Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFC35BBCC8
	for <lists+io-uring@lfdr.de>; Sun, 18 Sep 2022 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiIRJ3X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Sep 2022 05:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIRJ3W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Sep 2022 05:29:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE4E2182E
        for <io-uring@vger.kernel.org>; Sun, 18 Sep 2022 02:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=Z1jocfH9ktIaIxMzxW5SBnVmtyCLYeye+hO9Lp3JTgg=; b=uLOLzcmpfO9KsOxdPWA9P8luX5
        G70ERjR9FFL7QTTdvBWDm88HZGG+DBrndrml0Ttefb5s7lfXAKinYaBMAgsrlw4e0+feR7qVb+eCm
        jGt+svtFhsInii16jGrG0y2vGDHWvqKjuTnX/mOaKlLreHf8cWnYG3SCkS1S55YFrApn0qwRoVUN5
        bVZrHfOC3a4SwvHZCVhb16poNKNAQMBltjBzeOKUC4r+CmLvupJ9FK++3Qu5pm3SHlv66OZZYKvfX
        yBNVAFPLHbGMNg6OafsZ9jHGEkS9gHQDrZhDbKHXx3XMwPhP88Bs//k2i8rsSb+BV5MdGUiQPfe6i
        YpDmB9IS/i/48CGa3EyKUZk2UNR2rdl2ozcneuJ1t3HDxLP6gU9BbbDELJ8WVVtdUWVDA1M/DDgii
        kkNsticO68hVU9DAUSmRypNsJKCnzLjG5MCVX6ZhJqQUvyjYV3Ytw/6gpEFKraxFs0Q63nS2h1aux
        s/7+XNiLYhrWVRwydvLmRUBo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZqc0-000vMx-Ok; Sun, 18 Sep 2022 09:29:16 +0000
Message-ID: <80c90ff6-989c-ef1f-8448-fd64b813359d@samba.org>
Date:   Sun, 18 Sep 2022 11:29:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/1] io_uring/net: fix zc fixed buf lifetime
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
 <7099cb6d-4cfc-8860-0206-0844c4768a0f@samba.org>
 <b8656d4e-112e-1292-5d2f-52492e979c1d@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <b8656d4e-112e-1292-5d2f-52492e979c1d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 17.09.22 um 13:58 schrieb Jens Axboe:
> On 9/17/22 4:27 AM, Stefan Metzmacher wrote:
>> Am 17.09.22 um 00:22 schrieb Pavel Begunkov:
>>> Notifications usually outlive requests, so we need to pin buffers with
>>> it by assigning a rsrc to it instead of the request.
>>>
>>> Fixed: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Looks good to me :-)
> 
> Can I turn that into an acked-by or reviewed-by?

reviewed-by is fine.

metze

