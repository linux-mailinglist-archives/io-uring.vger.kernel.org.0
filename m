Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4406993DB
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 13:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjBPMGA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 07:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBPMF5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 07:05:57 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B801CF43;
        Thu, 16 Feb 2023 04:05:52 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id EFCB932009A4;
        Thu, 16 Feb 2023 07:05:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 16 Feb 2023 07:05:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1676549149; x=1676635549; bh=GP18igZLzqH6StqM5Abx0AVQb
        dDetac0q1rbN6/756U=; b=C3kNiEkoOg/jd5BEEFOLuNsh+NwBxsTXG7UiHdkyU
        DjssOvoA1Y8P3uDKEkqgyBjCcjW6OmSLNZcI7sslmxNaZ6PxD+knB/i8C9a1Wk6D
        40cb7lV15UjSbnZbsZ1qNQLg4tmIuiSJjUDvPXkLxhmrMPL7dDWlu0UuJrWaGtyL
        6Awoh7zPaEFy+vcV7Zt1xcsfJZIPbmCJvSq8osXlP+SBNPMsm+r9yZaw790vIiDh
        gVzEgqZrXE+U5FMSI6AVeMNuFRW2kZwmMgl9N1IsgafN6fM5ylUAAuk/OaAGDJVJ
        93TeQzrZoapN5eXVbmp5gFwiyKBLw93zJmNde+xvnruRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1676549149; x=
        1676635549; bh=GP18igZLzqH6StqM5Abx0AVQbdDetac0q1rbN6/756U=; b=r
        CHZOQENdL7fbYi5mzkKy0e5LgGzrEtTrTczjNSbLqWbjN7l+JuT76qosOc3Nsjim
        GM258Mfi+Lm4LLZC6o/6sU7olACSsgEen/qylXnBdQj1/L4fv+mrdciLDoOu0o/t
        L1zVIvqrfF9oTufIGa8eQoumK74ftJtrQ2o1PVc16I8G27shgYiVI9f36mVP4VAy
        tWFuKbP8fjFotZZQ5q3Zx+mI3vJfSr3PeoquXcoZ0D/7j5khNT5QRnUFcF8dwv+M
        krQ16iIlg6KrsJZeH4hKclXuCLGxOQ1U3QLvHOE8ef8dF02wT2EvNYpxa+vs91Bn
        /L2GTRzNziDxceLDKHHDw==
X-ME-Sender: <xms:HRzuYyUgpQH71_uiRMbuSin_yB3y_dmc2lNhYGOz7MM78iZ1FTmW9g>
    <xme:HRzuY-kJQg7RqsifolV5aYtdcPpLOVqXqc1TPliwodsDgzR7lSRpZEFbxe9doAym3
    7LBOUi2oub3LgSK7rA>
X-ME-Received: <xmr:HRzuY2bmMY-ltNADHhfTkFrijjI-21lISmie0VkKscCJ2YmNp2FC6ZIoux0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeijedgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpeflohhs
    hhcuvfhrihhplhgvthhtuceojhhoshhhsehjohhshhhtrhhiphhlvghtthdrohhrgheqne
    cuggftrfgrthhtvghrnhepiefghfekgfeuieejveekfeeiueehjeegfeelfeelhefgvefh
    ieevfefggeduvddtnecuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjohhshhesjhhoshhhthhr
    ihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:HRzuY5UpKuxdjX9_RmSAlLPF53LOaK3mBUB8HQKbe12W1Xz723X97A>
    <xmx:HRzuY8lW7zaQCFkXXCStAFh2Ndkm0oEXr2XSFicgPYA5KWOjLX1I9g>
    <xmx:HRzuY-clEzzixF5bgQzFOzyYw7a5_bNzEhDl3XKAm8SmiqELorGRGA>
    <xmx:HRzuY2jBDXyXDoaRW6JMbmn1gNl_UOTLx9kqoV_3KUlhHJPoOvNtzA>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Feb 2023 07:05:48 -0500 (EST)
Date:   Thu, 16 Feb 2023 04:05:47 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Dylan Yudaken <dylany@meta.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Message-ID: <Y+4cG5yy8U0XGHP6@localhost>
References: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
 <be9f297f68ee3149f67f781fd291b657cfe4166b.camel@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be9f297f68ee3149f67f781fd291b657cfe4166b.camel@meta.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 16, 2023 at 09:35:44AM +0000, Dylan Yudaken wrote:
> On Tue, 2023-02-14 at 16:42 -0800, Josh Triplett wrote:
> > @@ -4177,17 +4177,37 @@ SYSCALL_DEFINE4(io_uring_register, unsigned
> > int, fd, unsigned int, opcode,
> >         struct io_ring_ctx *ctx;
> >         long ret = -EBADF;
> >         struct fd f;
> > +       bool use_registered_ring;
> > +
> > +       use_registered_ring = !!(opcode &
> > IORING_REGISTER_USE_REGISTERED_RING);
> > +       opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
> >  
> >         if (opcode >= IORING_REGISTER_LAST)
> >                 return -EINVAL;
> >  
> > -       f = fdget(fd);
> > -       if (!f.file)
> > -               return -EBADF;
> > +       if (use_registered_ring) {
> > +               /*
> > +                * Ring fd has been registered via
> > IORING_REGISTER_RING_FDS, we
> > +                * need only dereference our task private array to
> > find it.
> > +                */
> > +               struct io_uring_task *tctx = current->io_uring;
> >  
> > -       ret = -EOPNOTSUPP;
> > -       if (!io_is_uring_fops(f.file))
> > -               goto out_fput;
> > +               if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
> > +                       return -EINVAL;
> > +               fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
> > +               f.file = tctx->registered_rings[fd];
> > +               f.flags = 0;
> > +               if (unlikely(!f.file))
> > +                       return -EBADF;
> > +               opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
> 
> ^ this line looks duplicated at the top of the function?

Good catch!

Jens, since you've already applied this, can you remove this line or
would you like a patch doing so?

> Also - is there a liburing regression test for this?

Userspace, including test: https://github.com/axboe/liburing/pull/664
