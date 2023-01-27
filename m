Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18DD67F20A
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjA0XJD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjA0XJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:09:01 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588D28CA9C
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:09:00 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso6110359pjp.3
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6d/NJ7u5M57ZMs5/XSzme6T+NlQRBMweiU7KSI07KS4=;
        b=cTt2KK2+aNMaouNcwN4m6XrNG2a5K95Fdz29ZxsUvUadYwrKItESLU+rsRq1Uxcbf5
         J+DYxA5XGTWb0BOrxYM0FEI/V/wZf5ZhWx6cP7eVgX2+CdOI7nmTzNBuoxq8nG7nDw0h
         914YYqwFLGpyLdwZbLwiRDMrtNsh4ydKQ+WNLLlzSAIBASL0BAQiMlZeW13b5DozyWZy
         Zz0OY2t3fjMaPVgAKEcw9+l7vg/QjTX7Zjnulwul8xJMD4xLDdVSwOCLk8bPQeuZE5gO
         nq0QDuIclN/s0eOmv7GevCptd2U7bzWXKTWbs8ic5CPZlGV/2Wazt7LzTTlWwhNPfCxU
         2DDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6d/NJ7u5M57ZMs5/XSzme6T+NlQRBMweiU7KSI07KS4=;
        b=NJ9Pdj68Eu8bo9TE7FqEm9Hy/g/yXFpyEaqSfDChOLgh2NTzmOONH41KO5EDbVwod2
         7VLbuoYnPPXV2st5O/KLvH999ZkatFEi12351T2kzx5hSwclNQIDQhJRwHsJqnwLNtl6
         gRljD9OabvijBWpevk2WhCAvS/J7Z1Nt3lfEhhXaq66zM1xd1kWqwAaNL8+lxsCRBIZR
         hOsX10UTT5LzM5SAX8pfQtzRkQ8PHPJx7+/2Ap1/FnxoRqBB5OhQVZP/WURWep/V4hQX
         F+uYj52O5NSOqV1NMwLgrltyPQo2A8y4CQ2i4Ib9F3BddQuImXX6NAoE8T+OGXlH5CrC
         DwXw==
X-Gm-Message-State: AFqh2kridmdxUMFVmmsk+G0/sEP3rYxxL5azQaWP3KW4xfV9JFi2B+iq
        i0ytDL1LMk7/sSOkqhbBDl9GwYINpPeybdRPx6uH
X-Google-Smtp-Source: AMrXdXuDLNSwckzSbYBFhsjXhjIrmP5IfNXjBk21l5WN/BcBzKlpCMhzzC2X4ht26fooVzU6d6eV9Xcu/nsn2XzBtNI=
X-Received: by 2002:a17:902:b496:b0:172:86a2:8e68 with SMTP id
 y22-20020a170902b49600b0017286a28e68mr4831485plr.27.1674860939399; Fri, 27
 Jan 2023 15:08:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
 <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk> <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
 <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk> <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com>
 <7904e869-f885-e406-9fe6-495a6e9790e4@kernel.dk>
In-Reply-To: <7904e869-f885-e406-9fe6-495a6e9790e4@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 18:08:48 -0500
Message-ID: <CAHC9VhRipXMCiaGZ-9YLycKWaq1FnV0ybC2B7G8Dua56P7bHkw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
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

On Fri, Jan 27, 2023 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/27/23 3:53=E2=80=AFPM, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 5:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 1/27/23 3:38=E2=80=AFPM, Paul Moore wrote:
> >>> On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 1/27/23 12:42=E2=80=AFPM, Paul Moore wrote:
> >>>>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote=
:
> >>>>>> On 1/27/23 10:23=E2=80=AFAM, Richard Guy Briggs wrote:
> >>>>>>> A couple of updates to the iouring ops audit bypass selections su=
ggested in
> >>>>>>> consultation with Steve Grubb.
> >>>>>>>
> >>>>>>> Richard Guy Briggs (2):
> >>>>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVI=
SE
> >>>>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
> >>>>>>>
> >>>>>>>  io_uring/opdef.c | 4 +++-
> >>>>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>>>
> >>>>>> Look fine to me - we should probably add stable to both of them, j=
ust
> >>>>>> to keep things consistent across releases. I can queue them up for=
 6.3.
> >>>>>
> >>>>> Please hold off until I've had a chance to look them over ...
> >>>>
> >>>> I haven't taken anything yet, for things like this I always let it
> >>>> simmer until people have had a chance to do so.
> >>>
> >>> Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
> >>> of different behaviors across subsystems and wanted to make sure we
> >>> were on the same page.
> >>
> >> Sounds fair. BTW, can we stop CC'ing closed lists on patch
> >> submissions? Getting these:
> >>
> >> Your message to Linux-audit awaits moderator approval
> >>
> >> on every reply is really annoying.
> >
> > We kinda need audit related stuff on the linux-audit list, that's our
> > mailing list for audit stuff.
>
> Sure, but then it should be open. Or do separate postings or something.
> CC'ing a closed list with open lists and sending email to people that
> are not on that closed list is bad form.

Agree, that's why I said in my reply that it was crap that the
linux-audit list is moderated and asked Richard/Steve to open it up.

--=20
paul-moore.com
