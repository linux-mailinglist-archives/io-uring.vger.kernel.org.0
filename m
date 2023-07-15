Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB2475472A
	for <lists+io-uring@lfdr.de>; Sat, 15 Jul 2023 09:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjGOHMi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Jul 2023 03:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjGOHMi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Jul 2023 03:12:38 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD93B3;
        Sat, 15 Jul 2023 00:12:37 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 8D17C32008FA;
        Sat, 15 Jul 2023 03:12:34 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Sat, 15 Jul 2023 03:12:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1689405154; x=1689491554; bh=NP
        Zdg7U5OFteWw9mt8dxF3+d1wDU2AjLnh9vC531+Dw=; b=R4emI4FzB/qbHnS4sI
        ErpYBlztRokW6tQLn39i1ez18R2u2jIAmWa//MDOjcq5oKGRG9Fj5JI0OtQfqJjb
        s5Cca0wXHq7Ca7a2HBM+pbGf4gCHyXXv73pIjzmL2Llq2eSW8grsxBkdgfzXO8w+
        DxL75vTapBCynfdenaQ66ICYLutd4EuZ51GrM2lz6DBXc89B7guvAhyu0ADKuIrb
        wi1WAt+kyzDxa6xpV7G65jwjVHYZK7e13FgYBvE7AqgovgoQ9kwM7TOZPNbQDnwt
        WlsI/UazeW8UUpmPfSKRpP6vMuafmBBkjRHEL7gCLo2iJ9XAT31VjoUPwGhCzoMW
        9d5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1689405154; x=1689491554; bh=NPZdg7U5OFteW
        w9mt8dxF3+d1wDU2AjLnh9vC531+Dw=; b=T3hBSK9Numj+hlXwDTKXJ1TO83oV6
        qpnKnoCzdLLmUJrVk/MfCtPUAmr2msVmX3wFbni4ls9g+pZrcYrfGXisZKWW1ucu
        nli4Q3zX68BoKxZuJUKLLofa9NNbGqk47tzOU39lihrk2l3jcGgN8dgfeEhJNGhd
        ifs7tD7R8FTOHRe5vTDlAeLpQR0OnXu4eKokUj8zWLkUkE4C3h8Dy5toZ0z1rif2
        IwLR9lTG+lLHczDpy2rgGKkLHZcfHnAqkmD8+vzXjKSxvl1ayp9536k7pqu4VAIS
        Qnh5w1RmfOFlLAQ3fMMDK0gzQgec3NSDFXuvalxhO/7F2Il5Ih/OzG3+A==
X-ME-Sender: <xms:4UayZKSHldNEQpTUFaZX8klTfERbZq745XyAle0kiAhf_v46CSdLvQ>
    <xme:4UayZPw0rvnOyYxdmKVG8oSidx4SZLmVe7BxGJklb8m_-MVGa7ZnI6Bl6YRUgJ0gp
    iLYlzjUY1AcXJuXxIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrfeejgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvdfhleffveegleeiuefhveekheeguefhfeejgfetffdtgeegveegteegudei
    ueefnecuffhomhgrihhnpehkvghrnhgvlhdrughknecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:4UayZH1Pdyq7__eTz4ug9smsl64E3dntcWGhcdq9RcE4WvQoECYZYg>
    <xmx:4UayZGCSVjgFOPSjhlXUdlf4SyGgKYVabL0lvzizhjqo4sbSnR4qvA>
    <xmx:4UayZDhXIjFJgA6BstcUJmgbnGAyOY72Vt9K3NRKhMzOFstmhRWLFw>
    <xmx:4kayZLaJSeur22oTd3zZ4U0ArYeV_gfXFn7qpQYv6tsvs7MJNFRHJQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 86529B60086; Sat, 15 Jul 2023 03:12:33 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-531-gfdfa13a06d-fm-20230703.001-gfdfa13a0
Mime-Version: 1.0
Message-Id: <57926544-3936-410f-ae0e-6eff266ea59c@app.fastmail.com>
In-Reply-To: <ca82bd8b-5868-8fbb-6701-061220a1ff97@kernel.dk>
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
 <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
 <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
 <d53ed71a-3f57-4c5e-9117-82535aae7855@app.fastmail.com>
 <ca82bd8b-5868-8fbb-6701-061220a1ff97@kernel.dk>
Date:   Sat, 15 Jul 2023 09:12:13 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Jens Axboe" <axboe@kernel.dk>,
        "Christian Brauner" <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Type: text/plain
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

On Fri, Jul 14, 2023, at 22:14, Jens Axboe wrote:
> On 7/14/23 12:33?PM, Arnd Bergmann wrote:
>> On Fri, Jul 14, 2023, at 17:47, Christian Brauner wrote:
>>> On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
>>>>>> Does this require argument conversion for compat tasks?
>>>>>>
>>>>>> Even without the rusage argument, I think the siginfo
>>>>>> remains incompatible with 32-bit tasks, unfortunately.
>>>>>
>>>>> Hmm yes good point, if compat_siginfo and siginfo are different, then it
>>>>> does need handling for that. Would be a trivial addition, I'll make that
>>>>> change. Thanks Arnd!
>>>>
>>>> Should be fixed in the current version:
>>>>
>>>> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc
>>>
>>> In kernel/signal.c in pidfd_send_signal() we have
>>> copy_siginfo_from_user_any() it seems that a similar version
>>> copy_siginfo_to_user_any() might be something to consider. We do have
>>> copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
>>> context why this wouldn't work here.
>> 
>> We could add a copy_siginfo_to_user_any(), but I think open-coding
>> it is easier here, since the in_compat_syscall() check does not
>> work inside of the io_uring kernel thread, it has to be
>> "if (req->ctx->compat)" in order to match the wordsize of the task
>> that started the request.
>
> Yeah, unifying this stuff did cross my mind when adding another one.
> Which I think could still be done, you'd just need to pass in a 'compat'
> parameter similar to how it's done for iovec importing.
>
> But if it's ok with everybody I'd rather do that as a cleanup post this.

Sure, keeping that separate seem best.

Looking at what copy_siginfo_from_user_any() actually does, I don't
even think it's worth adapting copy_siginfo_to_user_any() for io_uring,
since it's already just a trivial wrapper, and adding another
argument would add more complexity overall than it saves.

      Arnd
