Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49ABA692263
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 16:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjBJPjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 10:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbjBJPjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 10:39:32 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432113757E
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:39:31 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g9so3706650pfo.5
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 07:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1676043570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvRly2U+sCgGvEcPil/n1kT1uf7hR8ywFA21WCXqph0=;
        b=LHr06vqTRs8P6GauQb2IAyyj2ZkCyMPCqKeym+vdQ6tmf63IhA6ozHmd7HeSE6ZKpa
         CVeOH+ZkLeuDoJrJMnILmAGq3J4hPZJjNP/eRRNuPzsxYnnBq17U6ePONEpFTLF5NJ+I
         XYi357yRqgnULhpXYrA+DRLitUJkBd9dDwPrTsERN9pTwCyLMW/Scp2/fgIW07vUWWsD
         AT/B3bZtSVHvdrHq1DiNa58EkvqSK4MkOnUjGXTKfcVHja7N70dZu+fJ130zNtLfJU1W
         fMK3WTjZUXU1Z3nZ8LEN/DHZrmrU57fToE333gE9Prfbd1kJh5dz6BR96gVLygfA2eE0
         Rk5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676043570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvRly2U+sCgGvEcPil/n1kT1uf7hR8ywFA21WCXqph0=;
        b=tUbVi9k7Zd8S/xOg4+o/4PefKDeSfZmpSjSFwevoOC/MssNMAsK3l4M3yREi/TsE7I
         282YTlcsEB/fN0w0Nejt1X9J4hXQSTHTIFj31zAPgX86PjtQAUdcbLFcYBdfFQWTztdy
         2ktdRMDMf2yKOZ1uFuLybajKbAPqUfbuz5pIOPcCItWqK2y8Nc/HhYjDoB5musnyjU5h
         kf73+spGu5zG9z5oF4TLUo6vcuhXRegX1MoGPitjG3+w5PVVliRv79cQP7/9I7Vvzxkf
         NqjOcMMwyr5Sz1uqszN/4toC2i/vdER94NOrEJKzTbbRyLcNXiVLZfMp/NMG5dcZg2az
         HSQQ==
X-Gm-Message-State: AO0yUKXnR6OzblUDOTVYOyms7wjKOT4LBH2H3za6g9khurf8mMcnMo2r
        PNzrtGrnWspnwcs45NwUPrwurGK7+SUW1pJ+Qk7b
X-Google-Smtp-Source: AK7set+wCx2QL0mp3Ry5zhoh712ELZsFVGrSVHsRG9bb1cWzRQ28Qqq5D9cm5akwetXgY83HEmq0ABlPquIPy79JaDg=
X-Received: by 2002:a05:6a00:dd:b0:5a8:189d:b53f with SMTP id
 e29-20020a056a0000dd00b005a8189db53fmr2236320pfj.6.1676043570619; Fri, 10 Feb
 2023 07:39:30 -0800 (PST)
MIME-Version: 1.0
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca> <CAHC9VhTNb4gOpk9=49-ABtYs1DFKqqwXPSc-2bhJX7wcZ82o=g@mail.gmail.com>
 <13293926.uLZWGnKmhe@x2> <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
In-Reply-To: <6939adfb-ce2c-1911-19ee-af32f7d9a5ca@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 10 Feb 2023 10:39:19 -0500
Message-ID: <CAHC9VhTGmGJ81M2CZWsTf1kNf8XNz2WsYFAP=5VAVSUfUiu1yQ@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 9, 2023 at 7:15 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/9/23 3:54=E2=80=AFPM, Steve Grubb wrote:
> > On Thursday, February 9, 2023 5:37:22 PM EST Paul Moore wrote:
> >> On Thu, Feb 9, 2023 at 4:53 PM Richard Guy Briggs <rgb@redhat.com> wro=
te:
> >>> On 2023-02-01 16:18, Paul Moore wrote:
> >>>> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com>
> > wrote:
> >>>>> fadvise and madvise both provide hints for caching or access patter=
n
> >>>>> for file and memory respectively.  Skip them.
> >>>>
> >>>> You forgot to update the first sentence in the commit description :/
> >>>
> >>> I didn't forget.  I updated that sentence to reflect the fact that th=
e
> >>> two should be treated similarly rather than differently.
> >>
> >> Ooookay.  Can we at least agree that the commit description should be
> >> rephrased to make it clear that the patch only adjusts madvise?  Right
> >> now I read the commit description and it sounds like you are adjusting
> >> the behavior for both fadvise and madvise in this patch, which is not
> >> true.
> >>
> >>>> I'm still looking for some type of statement that you've done some
> >>>> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> >>>> up calling into the LSM, see my previous emails on this.  I need mor=
e
> >>>> than "Steve told me to do this".
> >>>>
> >>>> I basically just want to see that some care and thought has gone int=
o
> >>>> this patch to verify it is correct and good.
> >>>
> >>> Steve suggested I look into a number of iouring ops.  I looked at the
> >>> description code and agreed that it wasn't necessary to audit madvise=
.
> >>> The rationale for fadvise was detemined to have been conflated with
> >>> fallocate and subsequently dropped.  Steve also suggested a number of
> >>> others and after investigation I decided that their current state was
> >>> correct.  *getxattr you've advised against, so it was dropped.  It
> >>> appears fewer modifications were necessary than originally suspected.
> >>
> >> My concern is that three of the four changes you initially proposed
> >> were rejected, which gives me pause about the fourth.  You mention
> >> that based on your reading of madvise's description you feel auditing
> >> isn't necessary - and you may be right - but based on our experience
> >> so far with this patchset I would like to hear that you have properly
> >> investigated all of the madvise code paths, and I would like that in
> >> the commit description.
> >
> > I think you're being unnecessarily hard on this. Yes, the commit messag=
e
> > might be touched up. But madvise is advisory in nature. It is not secur=
ity
> > relevant. And a grep through the security directory doesn't turn up any
> > hooks.
>
> Agree, it's getting a bit anal... FWIW, patch looks fine to me.

Call it whatever you want, but the details are often important at this
level of code, and when I see a patch author pushing back on verifying
that their patch is correct it makes me very skeptical.

I really would have preferred that you held off from merging this
until this was resolved and ACK'd ... oh well.

--=20
paul-moore.com
