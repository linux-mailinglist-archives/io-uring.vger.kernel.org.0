Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7A968A46F
	for <lists+io-uring@lfdr.de>; Fri,  3 Feb 2023 22:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbjBCVPo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Feb 2023 16:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbjBCVPj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Feb 2023 16:15:39 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C02A58E5
        for <io-uring@vger.kernel.org>; Fri,  3 Feb 2023 13:15:29 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F2A005C035D;
        Fri,  3 Feb 2023 16:15:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 03 Feb 2023 16:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675458928; x=1675545328; bh=FRZ+RigALl
        /fWdaKNf2CYnSH8ZGw4ORjT43/V1BpWDs=; b=5v+fQwMbXle4YXNSf/nY39U4hv
        p+CPojeygapFdn5VQ6L0A/GfXXFUPfyj1N9GbXCfl+QBxLeKeFuAL468Zm6XEiPE
        n7OETxkXv33cBe0M2N0wlTaUOZ8ieOFV9Mr1jTtYKp9/EJpcPxmMCPAJu6sA/OD+
        DdqkuXDPJ94ZZG2aixeESAM4Y3Zng3XT1joOYKwFv3rNycmAUIAWRG9eo2oBhNv9
        Jaz59XDEGNi+vqsafcql/e7wxIHspT56brLuiHl+anNGDqbIlJX5TprXpTCBREPW
        o+NUbitDvnj6V4zOQp4yejVdkAYZn+kdlYQ0mU2x2feScq5yM+e8zi39UFsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1675458928; x=1675545328; bh=FRZ+RigALl/fWdaKNf2CYnSH8ZGw
        4ORjT43/V1BpWDs=; b=ZKU9kyKVZeW6uUsN6LlzVSTCkflHQb055hO8CiHO1+b3
        40WMJHoeLKeVIYYThjBWGlXBRUezF95EJtl8uYaM/BQ7KwpRcAQ7fXJ+hpVZyKXc
        2zDbUFk7N+clYy/9AooeBZ1mGKth4TyAwLSLeqUX6VYYIkd8dtlBUn3voFT+O6wf
        iDiLK7dcOJyWKj+oaMDXbX7bouvjg1jq1KT/VWvndeJJIS0il4rxhXHY9MvYELBj
        euJdJWXRVP999dr68UB1wDgEQDrzB3B4cRAnzlRhPk6UYGouodNsYQxJ37MmBEfb
        mKkIiOEjSoSPC2KpwJr2v3+cdFNsWjgbkVV07e9VhA==
X-ME-Sender: <xms:cHndY9TH9fqrPbfd0WcMbtk9SQZHhBPPk422DoqgJZpTv60u8qUhVQ>
    <xme:cHndY2yplAPRTQug9CccRW5x8oh4rTKkjnAY8kKy5KZyZ9zBfDmSfgVnxDQvXOlFE
    R8XlqON7BE1PHkHz2s>
X-ME-Received: <xmr:cHndYy2Dc-W8r9HSIvJLJNWzS6nXfCm4gZmumBGBPsSv5RT7BFzOHa8pZENZdontrA6-KenS_4ql8v_igERRRgd4tbncIypIgA6NXWU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegtddgudegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpehffgfhvfevufffjgfkgggtsehttdertddtredtnecuhfhrohhmpefuthgv
    fhgrnhcutfhovghstghhuceoshhhrhesuggvvhhkvghrnhgvlhdrihhoqeenucggtffrrg
    htthgvrhhnpeevlefggffhheduiedtheejveehtdfhtedvhfeludetvdegieekgeeggfdu
    geeutdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hshhhrseguvghvkhgvrhhnvghlrdhioh
X-ME-Proxy: <xmx:cHndY1C0aLIip-EQ9hWSnQmhKbf4oScGnmRjDJkXE9FUUcOUSfbpfw>
    <xmx:cHndY2hqmN6zQoUgMOi_TjrYQSKg5z6madKcV0df24ijf5ALFEzjMg>
    <xmx:cHndY5paRX-gIcf-e4-wgvu9NayyI_0QCFslOebcoyGQxsQ3A1DgUQ>
    <xmx:cHndY5tcjxGv4ccCFJuiqDYOWrVFJA9sp4LkKWNJbyUXdvksRkA0aw>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Feb 2023 16:15:28 -0500 (EST)
References: <20230203190310.2900766-1-shr@devkernel.io>
 <20230203190310.2900766-4-shr@devkernel.io>
 <Y91yCGR0mQkZC+TS@biznet-home.integral.gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 3/4] liburing: add example programs for napi busy poll
Date:   Fri, 03 Feb 2023 13:14:30 -0800
In-reply-to: <Y91yCGR0mQkZC+TS@biznet-home.integral.gnuweeb.org>
Message-ID: <qvqwh6w2pi1d.fsf@dev0134.prn3.facebook.com>
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

> On Fri, Feb 03, 2023 at 11:03:09AM -0800, Stefan Roesch wrote:
>> This adds two example programs to test the napi busy poll functionality.
>> It consists of a client program and a server program. To get a napi id,
>> the client and the server program need to be run on different hosts.
>>
>> To test the napi busy poll timeout, the -t needs to be specified. A
>> reasonable value for the busy poll timeout is 100. By specifying the
>> busy poll timeout on the server and the client the best results are
>> accomplished.
>>
>> Signed-off-by: Stefan Roesch <shr@devkernel.io>
>
> Those two break liburing's upstream CI. Also, it has many whitespace
> issues:
>
> Applying: liburing: add example programs for napi busy poll
> .git/rebase-apply/patch:258: space before tab in indent.
>         	avgRTT += ctx->rtt[i];
> .git/rebase-apply/patch:382: space before tab in indent.
>         	fprintf(stderr, "inet_pton error for %s\n", optarg);
> .git/rebase-apply/patch:391: space before tab in indent.
>         	fprintf(stderr, "socket() failed: (%d) %s\n", errno, strerror(errno));
> .git/rebase-apply/patch:392: space before tab in indent.
>         	exit(1);
> .git/rebase-apply/patch:794: space before tab in indent.
>         	fprintf(stderr, "inet_pton error for %s\n", optarg);
> warning: squelched 2 whitespace errors
> warning: 7 lines add whitespace errors.
>
> -----------------------------------------------------------
>
> napi-busy-poll-client.c:65:15: error: no previous extern declaration for non-static variable 'longopts' [-Werror,-Wmissing-variable-declarations]
> struct option longopts[] =
>               ^
> napi-busy-poll-client.c:65:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
> struct option longopts[] =
> ^
> napi-busy-poll-client.c:435:28: error: comparison of integers of different signs: 'int' and '__u32' (aka 'unsigned int') [-Werror,-Wsign-compare]
>                 if (opt.timeout          != napi.busy_poll_to ||
>                     ~~~~~~~~~~~          ^  ~~~~~~~~~~~~~~~~~
> napi-busy-poll-client.c:50:3: error: no previous extern declaration for non-static variable 'ctx' [-Werror,-Wmissing-variable-declarations]
> } ctx;
>   ^
> napi-busy-poll-client.c:33:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
> struct ctx
> ^
> napi-busy-poll-client.c:63:3: error: no previous extern declaration for non-static variable 'options' [-Werror,-Wmissing-variable-declarations]
> } options;
>   ^
> napi-busy-poll-client.c:52:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
> struct options
> ^
> 4 errors generated.
> make[1]: *** [Makefile:38: napi-busy-poll-client] Error 1
> make[1]: *** Waiting for unfinished jobs....
> napi-busy-poll-server.c:64:15: error: no previous extern declaration for non-static variable 'longopts' [-Werror,-Wmissing-variable-declarations]
> struct option longopts[] =
>               ^
> napi-busy-poll-server.c:64:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
> struct option longopts[] =
> ^
> napi-busy-poll-server.c:110:32: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
> static void setProcessScheduler()
>                                ^
>                                 void
> napi-busy-poll-server.c:48:3: error: no previous extern declaration for non-static variable 'ctx' [-Werror,-Wmissing-variable-declarations]
> } ctx;
>   ^
> napi-busy-poll-server.c:32:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
> struct ctx
> ^
> napi-busy-poll-server.c:62:3: error: no previous extern declaration for non-static variable 'options' [-Werror,-Wmissing-variable-declarations]
> } options;
>   ^
> napi-busy-poll-server.c:50:1: note: declare 'static' if the variable is not intended to be used outside of this translation unit
> struct options
> ^
> 4 errors generated.
> make[1]: *** [Makefile:38: napi-busy-poll-server] Error 1
> make[1]: Leaving directory '/home/runner/work/liburing/liburing/examples'
> make: *** [Makefile:12: all] Error 2
> Error: Process completed with exit code 2.

Do you happen to know which compiler and what settings are used in the
CI environment? I don't see these warnings in my local environment.
