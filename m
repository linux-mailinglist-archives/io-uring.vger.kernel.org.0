Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2AE68A441
	for <lists+io-uring@lfdr.de>; Fri,  3 Feb 2023 22:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbjBCVIU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Feb 2023 16:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjBCVID (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Feb 2023 16:08:03 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F2CA8A16
        for <io-uring@vger.kernel.org>; Fri,  3 Feb 2023 13:06:46 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0427B5C05D6;
        Fri,  3 Feb 2023 16:06:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 03 Feb 2023 16:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675458403; x=1675544803; bh=Q7PNuqH0p6
        aea6Nb8ObFF9JCji7s0vWMUSRe3M3Jerk=; b=k0gFPyMPTHozUz4ZYhpAZR6FV/
        3OPZJniSHFOdkms20GOlSh+dsWANGnZ94X/9Am1ZrYTiZp1r+Z/yYWhJez4vFsOl
        CmoD/demWIeWu4w58Yd5S54rX8fpJfyQFcghvlAmIOYWnMIbz0/dS8hZkabD/Ps/
        q4QDvyDRqL7DRRoSnu4vLZ5Gn3kdaK+LMW+DbxEB/XADxGMhNLE100Zt3N0SDTyN
        xY7zv+jbVIy38KuDwTF/G8Phkg9ApHbV3mM1dMZ4s/qnHLopSwOIHFaTsTDNTVud
        I43wA3hdvCB1VM62dpPWuFekj2ZZTZV8eeTB0M7mijgazGwM8VWHWbQIrBVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675458403; x=1675544803; bh=Q7PNuqH0p6aea6Nb8ObFF9JCji7s
        0vWMUSRe3M3Jerk=; b=kynCuvJ+4yjaMfJ5EBT1ueSokaoyLckWEvY3ECQd8x62
        2Eylh/EruEbciuR8hAJB5BjshuSd6s3m6e4k8GPj8OMbWVNZqbyJhpTAj7dvPs2M
        NvXfJiN8CYALTsSVrveE3FSuRBDx9Lah+EdMdCAGF4lndV1eEL2DtcGYBwkNGTEr
        pMmhYO6MgLCPB/i7ydKbn0ElZCnoaUXq3X9MpW6YIcDxijDVAdxBY5xj4AxBsXPJ
        B2JeG6zH1upxiZ5U7w4O2zenPA6Y6qSHnZEJQmibF50TaFxReJB8Mi0YbE42U2kL
        m0fXhCbwkPKvswj58g0rsyCbNgm7hTA5+gRC+RX7Rw==
X-ME-Sender: <xms:YnfdYwrFlGehIA900QbWajdaFofwKL3X5nm5R1_-tKU458a3lOyfaA>
    <xme:YnfdY2r9jFwlkKOypRL11Gnlz3Y9ys3VZ9sSi8ISDhpvXPlYrfBbw7o8wD2_K4nYm
    Xgn3DMdn8A7pWon5fo>
X-ME-Received: <xmr:YnfdY1N6zZST7IQszXkquGIJFbJgg3xlN0vhfQGBJjFURAjM9YWC1BfUZ5i3zttw9xBLZIcxPmbk0Vb99ouiZz9AYQeMytsUvuFTMLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegtddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:YnfdY34Ty_pf3qR3Cj3Cc300efgr3jAXTEXPtbXA-QtVx4VMfmNlWA>
    <xmx:YnfdY_5EZrQNPsJIaWqmc8-hc2uAbBDacpr-KYQtQiDPlmVntBqnqw>
    <xmx:YnfdY3gwlhAkZGVmpk97bxnQJJrgwMyJT3IlV3zXlS70-NoMT2nQLw>
    <xmx:Y3fdY_GziT2cT7A4ljaIMfh1kcUhevwOFBkcQuh56yFsSryrjZ7O_w>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Feb 2023 16:06:42 -0500 (EST)
References: <20230203190310.2900766-1-shr@devkernel.io>
 <20230203190310.2900766-2-shr@devkernel.io>
 <Y91sW7ZQTg9Wytg4@biznet-home.integral.gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 1/4] liburing: add api to set napi busy poll settings
Date:   Fri, 03 Feb 2023 13:06:18 -0800
In-reply-to: <Y91sW7ZQTg9Wytg4@biznet-home.integral.gnuweeb.org>
Message-ID: <qvqwy1peo3vn.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On Fri, Feb 03, 2023 at 11:03:07AM -0800, Stefan Roesch wrote:
>> This adds two functions to manage the napi busy poll settings:
>> - io_uring_register_napi
>> - io_uring_unregister_napi
>>
>> Signed-off-by: Stefan Roesch <shr@devkernel.io>
>> ---
>>  src/include/liburing.h          |  3 +++
>>  src/include/liburing/io_uring.h | 12 ++++++++++++
>>  src/liburing.map                |  3 +++
>>  src/register.c                  | 12 ++++++++++++
>>  4 files changed, 30 insertions(+)
>
> We have a new rule. Since commit:
>
>   9e2890d35e9677d8cfc7ac66cdb2d97c48a0b5a2 ("build: add liburing-ffi")
>
> Adding a new exported function should also be reflected in
> liburing-ffi.map.

I'll add it to the next version.
