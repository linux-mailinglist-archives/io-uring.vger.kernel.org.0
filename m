Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0AB6F0AE2
	for <lists+io-uring@lfdr.de>; Thu, 27 Apr 2023 19:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbjD0Ree (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Apr 2023 13:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244000AbjD0Red (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Apr 2023 13:34:33 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E7E30EE
        for <io-uring@vger.kernel.org>; Thu, 27 Apr 2023 10:34:33 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 774085C015E;
        Thu, 27 Apr 2023 13:34:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Apr 2023 13:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1682616872; x=1682703272; bh=4Q
        9v0gmuQl1IuYRxCxa9rQwJ0UIheZAXCuPIF/4EI1Q=; b=DMaUi7fsnXp/lnab6U
        1s8J6cB5aU1YRieQeIAlQhh9vBUvj9hDqj/Tjv/TQXZf4cRkyeuj6U7T1OOWD4oq
        61bC9XLX8V83G7M4CIvPU3rVTXlmbnoS2/jIVfQuywYqB+UlIggVUYYHt8eR5Fjt
        Y6dLKbkRdBhx3xUIS42jdukbL1c8zEoRJBahJTLuFWRP/2vP9zljJ2twEZ6slWU4
        dkrgYa/luBpVqf+1PrCSJQpoAMA6QzMr7T/OUpsZaRKAMJ5ij2M8oShRLgIm1kmq
        pd8EwXxvHdygea2+mxF76E06TjkPUPZzPx+q5bAlfJU3bK9qNUscLRBCoNRRhmVk
        lFcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682616872; x=1682703272; bh=4Q9v0gmuQl1Iu
        YRxCxa9rQwJ0UIheZAXCuPIF/4EI1Q=; b=HhUvmpfeci98LPOTtNsgz6nmy+V70
        MFNb53AvD/lBwzRQadmKBt68UXL7aHtlvnn6wqBcy6J3NmU0dcnWgyY8cFauzCU5
        hEHpNGTb8FYwV9PIvTMKSdx9vENkFJUn0Axun54NIbbUiUeg0Caxg9KOQ5n8xpn7
        FVupD8tub1g/JJbXHA2/nGoqBJuEdpxEADoEGJeB7bYRDKTdCfMo0KgsY0/GMxVT
        1ivnF1ArrHa5ZZwobqQNVSWn3woeJv15KqmjASocf+jQZZcH3bAd0daR/HcMsSOT
        R/OtMPVK4Lnug6LglcVS1NPiS7YiksitYFGWYK8E2aOWv2IcnhsYYjYaA==
X-ME-Sender: <xms:KLJKZN0b1cLSTnv7sSeF1mvvdLPEoEO3N0Z8alySkeaTbczDTSHL9Q>
    <xme:KLJKZEGHdwkrShZS9qxKEWWpBAk0JDU7UJV5EMpwVfh9F6agYUBGrmkguVJZwzySV
    G9mBQ8ide8H59Fs5OE>
X-ME-Received: <xmr:KLJKZN5UtXCH7Utovv0fvW5UT11XX0XuscjXyXl5KS3LnE2ScPoHq531Tw5MDiJOFHw6OPP3srTM0OxLLZdZ_nZF9dElHcWw9DthqfMKLnM5wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduiedgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:KLJKZK0CAO1d4iur_9e3hRz2GzBRNcpNNuj6vBMNA6P6qP8mmo2qZg>
    <xmx:KLJKZAFWKKVeXWMmIQzxITXaLNL4W32dFkeRMJnuAp2IqFFK2b57Mg>
    <xmx:KLJKZL8gRDeMVwR4d8zFQ8SycpkHDAFmYV2cbNpjm6hmskvYgfokyw>
    <xmx:KLJKZMgNPODsSJEM6YtMcrvTnvRPzi9e6icM4Vd31U-fH7co7WXdRQ>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Apr 2023 13:34:31 -0400 (EDT)
References: <20230425181845.2813854-1-shr@devkernel.io>
 <20230425181845.2813854-3-shr@devkernel.io>
 <ddb2704e-f3a2-c430-0e76-2642580ad1b5@kernel.dk>
 <64a48f3b-b231-7b9e-441b-6022693377f3@kernel.dk>
User-agent: mu4e 1.10.1; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        ammarfaizi2@gnuweeb.org, Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v10 2/5] io-uring: add napi busy poll support
Date:   Thu, 27 Apr 2023 10:34:14 -0700
In-reply-to: <64a48f3b-b231-7b9e-441b-6022693377f3@kernel.dk>
Message-ID: <qvqwy1md9ql5.fsf@devbig1114.prn1.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

> On 4/26/23 7:41?PM, Jens Axboe wrote:
>
> I'd probably also do this:
>
>
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index ca12ff5f5611..35a29fd9afbc 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -95,12 +95,17 @@ static bool io_napi_busy_loop_should_end(void *p, unsigned long start_time)
>  {
>  	struct io_wait_queue *iowq = p;
>
> -	return signal_pending(current) ||
> -	       io_should_wake(iowq) ||
> -	       io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to);
> +	if (signal_pending(current))
> +		return true;
> +	if (io_should_wake(iowq))
> +		return true;
> +	if (io_napi_busy_loop_timeout(start_time, iowq->napi_busy_poll_to))
> +		return true;
> +	return false;
>  }
>
> as that is easier to read.
>
Will be changed in the next version.
