Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8925F67F173
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 23:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjA0Wxr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 17:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjA0Wxq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 17:53:46 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0FA8B066
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:53:36 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so8997712pjq.1
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IV1QL6twj3JbhXkP12EpxrGpBWc/55NNcKUr7Mxc/IE=;
        b=bt7Qt8azkZwjE0NJyI8sPmgV4yiJByc5P86rPhjdkunG0MmxfGbStzBGdljJs2oU07
         hn2hq+STrYhE0og7JZ2V327nYR1cJyX+8bzKYIljMTixoX9lGry2Dc2u/cUVZcMyPedR
         dQfDs8RdUsGByiUaFCeq6k5Wcg2d6qNOpU4BNqSPvcABnA0WyiibkmV3WZpaSIvPQ4G2
         9rhj+b2osuwrYhkkC3t3I0l8bFYMpPhGxUydi81FwoQiwbmmGJfFqmionWukazpm9eX9
         KwBnhk3MrCZ+QeByvDpHRJL6P43hK1vAcn1nBY+MynI+gPBJXdIykzSFoxb+BC5jkuh4
         33Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IV1QL6twj3JbhXkP12EpxrGpBWc/55NNcKUr7Mxc/IE=;
        b=dmDJpGZ9/Ire8NrIJHsGlAlVqpT8KBJafsHBge0Km1ZhZ1hB+1Kos5htZMC8ySyfoz
         tKIwLXeWOuP+4lZxEwqN+6T+mG8BM5pnUmETVAhIy7pkObktzcydO8DyJLOtoiOo/cQh
         +4lcm5wqSPgQXZPgxPVOIfG+pXyWZ7FGCRXNcQn+ZrC2ZWxMLWilEmPAHx4gxg+081ks
         sn3jW9yWvN+fPbeekzrrRkKuYAIXPkr5zYU+qcvabJwo0euUbdoJCCrD6Bn/2RU2ZvjO
         +Cn7gZ3dHOAEEzFyJ3sYHwX0Paavr2zzlz8GUr5dwHH7LQtwE932anaV6WhOipYk+IhK
         XFUg==
X-Gm-Message-State: AFqh2kqytzRHZwLOySH8CuUuvicrpeDuSQ75KG/s8yvpgU8gYuT1E3w4
        29yxDkfrglIW6A1Xcvy1ugSLpZvGYRyv7An7DyWJ
X-Google-Smtp-Source: AMrXdXufkx+kARXGM/WQldtmYWplok4guDRE8z7yAssUVY4SPs2oyYPKUpHQdS8QvQhpPla60vomTv3S+RkjSqPlqy4=
X-Received: by 2002:a17:90a:5b0c:b0:223:fa07:7bfb with SMTP id
 o12-20020a17090a5b0c00b00223fa077bfbmr5377808pji.38.1674860016129; Fri, 27
 Jan 2023 14:53:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com>
 <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk> <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
 <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
In-Reply-To: <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 17:53:24 -0500
Message-ID: <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 27, 2023 at 5:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/27/23 3:38=E2=80=AFPM, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 1/27/23 12:42=E2=80=AFPM, Paul Moore wrote:
> >>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 1/27/23 10:23=E2=80=AFAM, Richard Guy Briggs wrote:
> >>>>> A couple of updates to the iouring ops audit bypass selections sugg=
ested in
> >>>>> consultation with Steve Grubb.
> >>>>>
> >>>>> Richard Guy Briggs (2):
> >>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
> >>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
> >>>>>
> >>>>>  io_uring/opdef.c | 4 +++-
> >>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>>>
> >>>> Look fine to me - we should probably add stable to both of them, jus=
t
> >>>> to keep things consistent across releases. I can queue them up for 6=
.3.
> >>>
> >>> Please hold off until I've had a chance to look them over ...
> >>
> >> I haven't taken anything yet, for things like this I always let it
> >> simmer until people have had a chance to do so.
> >
> > Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
> > of different behaviors across subsystems and wanted to make sure we
> > were on the same page.
>
> Sounds fair. BTW, can we stop CC'ing closed lists on patch
> submissions? Getting these:
>
> Your message to Linux-audit awaits moderator approval
>
> on every reply is really annoying.

We kinda need audit related stuff on the linux-audit list, that's our
mailing list for audit stuff.

However, I agree that it is crap that the linux-audit list is
moderated, but unfortunately that isn't something I control (I haven't
worked for RH in years, and even then the list owner was really weird
about managing the list).  Occasionally I grumble about moving the
kernel audit development to a linux-audit list on vger but haven't
bothered yet, perhaps this is as good a reason as any.

Richard, Steve - any chance of opening the linux-audit list?

--=20
paul-moore.com
