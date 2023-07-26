Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6A4763DDD
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 19:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjGZRp7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 13:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjGZRp6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 13:45:58 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F712697;
        Wed, 26 Jul 2023 10:45:55 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6C7493200958;
        Wed, 26 Jul 2023 13:45:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 26 Jul 2023 13:45:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1690393552; x=1690479952; bh=6+
        BtwAiVSxh1iYhM2LPLsKH6+zDmGG6P7lMP2V1Zi70=; b=Qmd4H+Br8tMw1XghlU
        Nlz7bHPXrAx6O7RV5E6WKRL6rQQP51jw9IPDGgQwag+n2TQEAtFZeu+B4DkVRixu
        knbljF++UyO50c9qQcu39POEQdRSvN7SSKrqiRYeb9C7kJAjmG2fFMYqkuhu4GiD
        6VCz+CUcl2MUy+kMtmsZhZ5ifKaav7aJaGHf56Yn82fgUkEAzFjgak/wYvduI1sG
        6IF0ct+HP96ffssE6OE1JGDPOr25oJtN13dEqt4NBL53rvwAC2j2aDKigCuLANHh
        qmagOEN2ZyXd09Lq5nVCQbFaExvslxhr1v8z9FdOAR9NaHTjync2HAoe4yGmNKnB
        AZ2w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1690393552; x=1690479952; bh=6+BtwAiVSxh1i
        YhM2LPLsKH6+zDmGG6P7lMP2V1Zi70=; b=rDnqFY0bc6eP7jdogZERouKz7ECYX
        6nCbYyW334nUrGDCwxfK7/t5D6yySDQAmtx4tZu5+0F8dqDdh4YgaVnuHhHHpvRv
        73SZ0NmZRL0fQmLeuEcMaZisoC4N+/Yx+OyTqT625Le6AZqzIGUCEAxAiO37HmA+
        V007MCKdZ+uMeFf+HS0YTyOZY41MFohQV/7Si/H9ITky/9F9WHX9RVz7AB3ntGJJ
        h5JOpBGdJ2K4jjiqu5HQTyPL93LnAUhe7xSV1O6h0l9s5KN5hCknYIVymL4wERnT
        72mJzFjvbKnSkDnHeN900WH0UYs/v5mviuONbcPLyBhBxLlMbXtle5yjQ==
X-ME-Sender: <xms:0FvBZC0Tryiu1D6O4NZbVVbVzDLWI1bD1Z4-AqT3CmXiTH9DQQ7JIA>
    <xme:0FvBZFG0N5nR_MVs_OL-pvmicF_iP3pEiteKryyMhJDDowCACQwNcD37H3bphf0mu
    RVjmdYPY8RmP8t7WA>
X-ME-Received: <xmr:0FvBZK7kxLgOSa_vrT3uuwJqKJ_M38nXYdrha9UV3p4mGcDCfRHElIP6L6i9CzU_z2JUe7MZ5Hl2pqfpg6dBEHVJJfyT84iCFAGbbFvHPOEF0Gb6TkOiMqgXoHW1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedriedvgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughr
    vghsucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecuggftrf
    grthhtvghrnhepvdfffeevhfetveffgeeiteefhfdtvdffjeevhfeuteegleduheetvedu
    ieettddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnughrvghssegrnhgrrhgriigvlhdruggv
X-ME-Proxy: <xmx:0FvBZD0elYr1hQwUGBen7BvOVriKMtEmoAFtRr5poakX9SUE7dz-pQ>
    <xmx:0FvBZFFyKP3XOu7msWLMIV8gYPAE-RIJoXY3I5o9WlioId0J5vQRlw>
    <xmx:0FvBZM8OgEJ2xjxfOjgaF7kcJSMl_vJ2gXKsLuCdPG7miNwX7vKO7g>
    <xmx:0FvBZD8JXMKwcfwFm9JcCrLET6MyEpTBP1XchL84iDs0O9I04wlMIQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Jul 2023 13:45:51 -0400 (EDT)
Date:   Wed, 26 Jul 2023 10:45:49 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Matteo Rizzo <matteorizzo@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        corbet@lwn.net, akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        jmoyer@redhat.com, krisman@suse.de
Subject: Re: [PATCH v3 1/1] io_uring: add a sysctl to disable io_uring
 system-wide
Message-ID: <20230726174549.cg4jgx2d33fom4rb@awork3.anarazel.de>
References: <20230630151003.3622786-1-matteorizzo@google.com>
 <20230630151003.3622786-2-matteorizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630151003.3622786-2-matteorizzo@google.com>
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

On 2023-06-30 15:10:03 +0000, Matteo Rizzo wrote:
> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1,
> or 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior. When 1, all calls to
> io_uring_setup fail with -EPERM unless the calling process has
> CAP_SYS_ADMIN. When 2, calls to io_uring_setup fail with -EPERM
> regardless of privilege.

Hm, is there a chance that instead of requiring CAP_SYS_ADMIN, a certain group
could be required (similar to hugetlb_shm_group)? Requiring CAP_SYS_ADMIN
could have the unintended consequence of io_uring requiring tasks being run
with more privileges than needed... Or some other more granular way of
granting the right to use io_uring?

ISTM that it'd be nice if e.g. a systemd service specification could allow
some services to use io_uring, without allowing it for everyone, or requiring
to run services effectively as root.

Greetings,

Andres Freund
