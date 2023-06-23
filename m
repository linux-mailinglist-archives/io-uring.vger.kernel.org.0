Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CD673BEAA
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 21:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjFWTEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 15:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjFWTEZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 15:04:25 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FDC10D2
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 12:04:23 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 261605C01C1;
        Fri, 23 Jun 2023 15:04:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 23 Jun 2023 15:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1687547060; x=1687633460; bh=Js
        KDZTGOFynl45izTGONDlo4Ljx0GQkWmzgHwsDkC/Q=; b=jdsJX9D3hiGJ5k2xPE
        y8IVhQ7r4gU+KA7nt9Q44T8QEV3+sa7NL9W7rx2vr4NqFyop9Wu0WP71VYP1wnM5
        z9Qnt+7HsM3v3W4G2PBUYg6sl466t0Z8y1UrHC5bKicR0OpH9HsbXAc9IMiGZNny
        zYSwdpnaZ+SHs1j1Lu11yctF+G3CKCj0r/c+droBf9FNyqhGAHMgEFWxSJpML5I6
        /XoxXcY80RnFF6SLBqrMl09lHWyG2Vr1S9nmppasohWeBvzKd7AZAGsZhOMzsP78
        zzn2ypKn8Aqd9DwRp6icbyHUiL/oAfGIKzjHs7VFYsNnGZ0pSiZaXmomi/k+x2dg
        E5vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1687547060; x=1687633460; bh=JsKDZTGOFynl4
        5izTGONDlo4Ljx0GQkWmzgHwsDkC/Q=; b=ey8rUdcM8V3Dj30nYeru/81SFq9bs
        e/TtrA5fvuDkSUBMlv1zTtvM1GZ0hbQ+QJarMQibIESBftzEcLN5pPQF9LGr7K4D
        JYeJrzQkfhqat5Q/k9L4YTLyzqIFCpJhKacO7L3DIjbPOuvhN6RfupRCPL1EsuLd
        QwnuSNNGQLQYeZ7RuTRYcJQbKHag4mMSRaKMA6KSWdVwl7AngKQ2svPbo2ijU1CV
        YHACYkPCDy2DKl7zAlhU0K8keC/4tRFLVUmsi6c0k6pnAIyy3kddryK2n3w628OI
        yMDbCoai2ScSw5JqQbR61C8Fzw0Rn2oGkGIZESv1g5Ngke2YbPE8Vtg1Q==
X-ME-Sender: <xms:s-yVZKYCiQ74yS3Psvyh6hpVndMPwhS2gLzqiP_TYgMxpnVBX2JZkA>
    <xme:s-yVZNZgtfUd5ns1fSk-SA_KTbFLhq2zjCOSrHQAnbqABSFQ0nTRNcUsw51F413rq
    IyABHZ_VpeKKAY2vw>
X-ME-Received: <xmr:s-yVZE_X4mN4XGkaldZZU-lzb5C2mzfFijQcCcp3OLVA3kAjPMSKGjdEhpTYwKNXKHK9eRfVC0EQBXRG189WGkiKwHF1JDSlWA75r5x-x4e5ak-63yUIXSsmpB2n>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeeggedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:s-yVZMoSvphfd047RZsap226C845Oi7R6zIEE_GyielnnX--_CSj_g>
    <xmx:s-yVZFpAS4ibZNBKS-wEgFO76xAgLOqTcJu5k0YOOMW3bYSSZIjCig>
    <xmx:s-yVZKTeuYMhkKrN7jecS2BTHMBpRkG-f3o55MFtgQ3UXYAl0WpzdA>
    <xmx:tOyVZETvrxv8OC2Kd5ILhQRl7AnWHu6YUw8Vboo8mPoPfOihsWv1Xw>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Jun 2023 15:04:19 -0400 (EDT)
Date:   Fri, 23 Jun 2023 12:04:18 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Message-ID: <20230623190418.zx2x536uy7q5mtag@awork3.anarazel.de>
References: <20230609183125.673140-1-axboe@kernel.dk>
 <20230609183125.673140-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609183125.673140-6-axboe@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I'd been chatting with Jens about this, so obviously I'm interested in the
feature...

On 2023-06-09 12:31:24 -0600, Jens Axboe wrote:
> Add support for FUTEX_WAKE/WAIT primitives.
> 
> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
> it does support passing in a bitset.
> 
> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
> FUTEX_WAIT_BITSET.

One thing I was wondering about is what happens when there are multiple
OP_FUTEX_WAITs queued for the same futex, and that futex gets woken up. I
don't really have an opinion about what would be best, just that it'd be
helpful to specify the behaviour.

Greetings,

Andres Freund
