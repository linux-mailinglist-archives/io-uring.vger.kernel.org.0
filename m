Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88F6F6F92
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 18:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjEDQGw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 12:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjEDQGv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 12:06:51 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1146B9
        for <io-uring@vger.kernel.org>; Thu,  4 May 2023 09:06:49 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B0D55C014D;
        Thu,  4 May 2023 12:06:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 04 May 2023 12:06:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1683216409; x=1683302809; bh=9n
        OyOsinE+S1ed9oE/Z09j55E/bxtTYDr12jQDg0Y0s=; b=IlJvfcg2SExqjT4lzu
        AD0KQa6BmuKwFql8ddfLdvZbScqcXtwt7ZljD8K5PLaB5QV7Am6FpYNQ4PdvL0Vk
        EEAqaPHIuHhmddc9NvZ4SNGi7sqWer+uH5QKfBYttvpxImrrgSe2TxeY3sgitMN2
        /KSDKBcmIC3G/Ph/sIlSGrsvhF/g/r37hFRsFWdBr1ABMKBNZ6cAX3bz3LBWtGSo
        nOaTlLii+uIImqwkh0FRXOIdGv3ocwIOXbFCJg/bGhZ6t0W2HHzjJG6rBibAKwlv
        ydd8iGSUWkAPHaHJJb8tqQMy3xMjHYLMo/W3HL1hRsqEwNOoaH0wllIKohxr1Elr
        BdgA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1683216409; x=1683302809; bh=9nOyOsinE+S1e
        d9oE/Z09j55E/bxtTYDr12jQDg0Y0s=; b=hOnmefJrmIbdzLnki71EY4At4Uv/O
        5bEiGbuGXXKjeZ9wlvZELx5nLNCeR8rsiT6lGo+mpCjy1Xcxkew71CAsgWGEBY6W
        CoLHWRE2K5wrt7QLup+Ex6ZsSHD+zkPlaNsXPaXwv7IV/DEkbYiwjwvrtjeCzvlJ
        j38eYUqao0Fh64i18xK05m0l8AfXTvqpcX9eE1FN46GUMZ2IiPG8CO2i8zH9MyoE
        1ho2vRNAG4g3iWdIonGkSWEj6bEFmMI1KzmgEqQaUxoMY9EkDXIPtx9CZD3zEp6u
        m/9fxiP8gFqhLa1nLRHmQxp1uzsY8Ulm7Y+Zk6hmYe02P8vlU2kvzkN5Q==
X-ME-Sender: <xms:GNhTZKg1OTCJON8dLPilO37USOEKzEMDsZe2-CVjRnGds2sHZZ-g_A>
    <xme:GNhTZLDkZl1nL-Uu6eyJmLylAIwo_JJwpY8nGcTz1i05PWoQC-grJSVRlYiSONMC-
    sbzIWEPd9cc2n8ObbI>
X-ME-Received: <xmr:GNhTZCHX5Z-0gqGIfBvnxtFhJwAQY_M9Uvs7zRKjPh6y2g7TOxk2wr-bSMMZAivK5_gLKSnYBITacdaPdjOufDPUXgO4JOxKEbuWA3-jPt_S>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeftddgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:GNhTZDSrc8lwiDruSDn3-6mo7Fh12ErLA9CYEDO-BTXr1t5zKILGBw>
    <xmx:GNhTZHxhRNoLoFNH2f8r3M7Ofq480gSIoS-4dkc7p9gOEsuvOazQEw>
    <xmx:GNhTZB6G6UXWCA4AQk10XW51W8qK3qRwMez7KJYsjzAQsLqvwaDBCw>
    <xmx:GdhTZJtsA3mpjLTO4-zL_ke4fp_R5JzvRjdp1N-0PrSgCBJYFmlddA>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 May 2023 12:06:47 -0400 (EDT)
References: <20230502165332.2075091-1-shr@devkernel.io>
 <20230502165332.2075091-3-shr@devkernel.io>
 <acd78dcf-f145-d7d3-a30d-4b6694089023@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v12 2/5] io-uring: add napi busy poll support
Date:   Thu, 04 May 2023 09:06:10 -0700
In-reply-to: <acd78dcf-f145-d7d3-a30d-4b6694089023@kernel.dk>
Message-ID: <qvqwa5ykcc8b.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

>
> I mentioned this in our out-of-band discussions on this patch set, and
> we cannot call napi_busy_loop() under rcu_read_lock() if loop_end and
> loop_end_arg is set AND loop_end() doesn't always return true. Because
> otherwise we can end up with napi_busy_loop() doing:
>
> 	if (unlikely(need_resched())) {
> 		if (napi_poll)
> 			busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
> 		preempt_enable();
> 		rcu_read_unlock();
> 		cond_resched();
> 		if (loop_end(loop_end_arg, start_time))
> 			return;
> 		goto restart;
> 	}
>
> and hence we're now scheduling with rcu read locking disabled. So we
> need to handle that case appropriately as well.

I'll have a look.
