Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44395754298
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 20:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbjGNSdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 14:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbjGNSdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 14:33:36 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5BEC6;
        Fri, 14 Jul 2023 11:33:35 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id A6B2F5C00DA;
        Fri, 14 Jul 2023 14:33:32 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Fri, 14 Jul 2023 14:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1689359612; x=1689446012; bh=1QsNfDDyhcBoTHL2dhcRk5OXIDoFbkHDAQj
        OIzYIvug=; b=nvl1TKklNGn9d8aPp5gyt2KCexkoc9wZ3VO7E4qCeR0v52F88b4
        3tg3vSFNCgrCqxyHtn6aX+pxTSutexgGcBP2ZLzTULh3Fg2nrZygqkYe8zTRRPOD
        dcMMcvvSknxos/3Ueq+KOk2BdtGDFTc8zhymdHAtxBvCK6jaeuk7K7IMvQDzHxu7
        +1bXzSDx1h+dGZJR3zM+t9mRCqSr4KFTOimFjAh9CybR7dOQDvOQt8bpzeXBc6IO
        JOaKusyY1Xb5IBnoTkXtD05bsR9C90wcuxPps+tyHzSS2Yp/jVTKNIYMEj2G7i7i
        X33ZAcbhQga0ym+QlljbS0ETtcjsGl0DA0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1689359612; x=1689446012; bh=1QsNfDDyhcBoTHL2dhcRk5OXIDoFbkHDAQj
        OIzYIvug=; b=qaCVZnIp/sXHFtC0VUzp+tuz45buonTg8aft7r8VSvROka3Mbfc
        oxwzmkAv1mmrj1XElnv8rpsZPf//gm+XSa9ddcMXvDtDo2/7wYMGhmsWmWUMDdqn
        pxzItwOMbFrNs0EUA1cypOPrsfsNOnc8YLs9hz4UUJzLduW7UGnt2EU6VqBwRJjN
        oedwslK0D0KEIeWpFc+vOYi0Iv4WUFkCozkDMljx0Mwb3Il/eaRkNTXylxWMOzGe
        fb4PpvxktNJBUU4rA85whmkHUvHMU7Uvlx5FdNqJpfn65CdB1XCv1TTVwB6CFDVw
        N4qBCzdCewqbw/zc1e1CfFOz0vh65t8JE2g==
X-ME-Sender: <xms:_JSxZLy2se-eG09L2CeD6QC3DrmGxNdQv7jpGe1D9lUZjf2rq93VuA>
    <xme:_JSxZDTSHX6cZKrkqjEFHuYtBDCOmXdTjakZgtG4SXVaafmeBoWR8v0dpy7IwqFky
    5JPv63rPrvXS2EDOs0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrfeeigdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeduudehudeukeegkeduieeghfdvvdeiudegueehvdfgheekgedugfdujeeu
    feefjeenucffohhmrghinhepkhgvrhhnvghlrdgukhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:_JSxZFWQ3VTsm3n6YM3b8kCFcme3dz7YuxW6SGsHL7h4iO12RqmzEg>
    <xmx:_JSxZFg-QjvWSZlJuCagPueA6tUqNYm2RTeANU97KUfehXjMRcFkoQ>
    <xmx:_JSxZNBfm8SSnnEf_Vw6kIDaMAvEm1sTPDkPIL3WGaoIVQJg7dfy0g>
    <xmx:_JSxZK68UY7Edv6vG5HHJopR6NA15grfqP3p5yFZqZb54kyhRNRQrg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 377BEB60086; Fri, 14 Jul 2023 14:33:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-531-gfdfa13a06d-fm-20230703.001-gfdfa13a0
Mime-Version: 1.0
Message-Id: <d53ed71a-3f57-4c5e-9117-82535aae7855@app.fastmail.com>
In-Reply-To: <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
 <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
 <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
Date:   Fri, 14 Jul 2023 20:33:11 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Christian Brauner" <brauner@kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 14, 2023, at 17:47, Christian Brauner wrote:
> On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
>> On 7/11/23 3:22=E2=80=AFPM, Jens Axboe wrote:
>> > On 7/11/23 3:11?PM, Arnd Bergmann wrote:

>> >> Does this require argument conversion for compat tasks?
>> >>
>> >> Even without the rusage argument, I think the siginfo
>> >> remains incompatible with 32-bit tasks, unfortunately.
>> >=20
>> > Hmm yes good point, if compat_siginfo and siginfo are different, th=
en it
>> > does need handling for that. Would be a trivial addition, I'll make=
 that
>> > change. Thanks Arnd!
>>=20
>> Should be fixed in the current version:
>>=20
>> https://git.kernel.dk/cgit/linux/commit/?h=3Dio_uring-waitid&id=3D08f=
3dc9b7cedbd20c0f215f25c9a7814c6c601cc
>
> In kernel/signal.c in pidfd_send_signal() we have
> copy_siginfo_from_user_any() it seems that a similar version
> copy_siginfo_to_user_any() might be something to consider. We do have
> copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
> context why this wouldn't work here.

We could add a copy_siginfo_to_user_any(), but I think open-coding
it is easier here, since the in_compat_syscall() check does not
work inside of the io_uring kernel thread, it has to be
"if (req->ctx->compat)" in order to match the wordsize of the task
that started the request.

Using copy_siginfo_to_user32() and copy_siginfo_to_user() is
probably a good idea though, it's often faster and less
error-prone than writing each member separately.

      Arnd
