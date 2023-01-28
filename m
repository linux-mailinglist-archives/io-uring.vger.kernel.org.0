Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4D4467F9BA
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 18:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjA1RDy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Jan 2023 12:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjA1RDx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Jan 2023 12:03:53 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF6BEFA4
        for <io-uring@vger.kernel.org>; Sat, 28 Jan 2023 09:03:52 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r8so956397pls.2
        for <io-uring@vger.kernel.org>; Sat, 28 Jan 2023 09:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZB8lg0YeivU1JmY6qzB+xB0HCsqlxdwoCMFwmTxhGc=;
        b=YuWBbzUv750b3lluA0Xc6lKsr9XDMwG9ONJRXLFKTbkZw5XSnXEy80i6xh+hAwKICO
         09F9AfIAay1C21P2ZRssDSjfvhjxbcYu3VeUvBg9AqqSSmQuGXimp+OpQzy/VRa3Dq4e
         UMK+mkQ4eAdn4/zqmLakHLyO06OJ1Of4mojiF9+jQbBwmDFmClpTAt776z2kAPVMY0eW
         Ef8QZLIE/cdUpvAPr9Bls6jXYp1JPKDMyo//TNpJOb5xZp8Hcf8LQYHqvXify6hVcUyu
         JH+60kQqWeh5blSKY2lWPJUf6LNlWDqmFF2LJ6evItT/6tn6UhVgGx3tfoFHjOLc6N1H
         0DHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FZB8lg0YeivU1JmY6qzB+xB0HCsqlxdwoCMFwmTxhGc=;
        b=sQSV6MnSEqZC/U3RuinkRLNyV7MXyQJphuUE9FdNuzUSnrz/PKNqjgTlHKK2/UQ2fE
         RNevSuY2wNh6iCMBm+z762ucXvorddK+XJp+9H8h7nOwv6pnlWwlZVPgtDtL5/oEPoMt
         71G7fsbobuGrpvFErO5v+e057QPqYcy39N1fOioL7SnBZ4q5J0kJhQHmlpOWmdJp0MQb
         8X0WMKoaWtbHAaaEszIxV96cVJssRsZP/BRpcea3FTGkZyghKD6kxH1d8agUB3fWztL7
         KGMDd0wXCDjcgI4rC7jISrTtbS2+LmApmaQ68UFoa8a5R3cHo6GWVTmRscZ/ymbSu0g0
         cTYw==
X-Gm-Message-State: AFqh2krdakmk0atWkqqdh6bVILWegcOnBgnPjcJSYyrS2dRbmOXo1U1Q
        ygCGK9loG4Lx4HGTsWeQWPvMc4qiW+uXds1VI5Jj
X-Google-Smtp-Source: AMrXdXts3HgaSZ1OMsaBQlmOSyte1KDM2wha7k7fk7BHABCeqM3pzpwKqS0gOaF7QboopE3ejUebzS9ZE6jmFHPI+3w=
X-Received: by 2002:a17:902:c404:b0:194:954c:fb8 with SMTP id
 k4-20020a170902c40400b00194954c0fb8mr5105429plk.20.1674925431278; Sat, 28 Jan
 2023 09:03:51 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <d9da8035-ed81-fb28-bf3a-f98c8a1e044a@kernel.dk>
 <CAHC9VhRpu7WZDqWKcLDj18A0Z5FJdUU=eUL3wbJH1CnEBWB4GA@mail.gmail.com> <12151218.O9o76ZdvQC@x2>
In-Reply-To: <12151218.O9o76ZdvQC@x2>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sat, 28 Jan 2023 12:03:40 -0500
Message-ID: <CAHC9VhRoJRRcsXWOMkBQWKOUkCdJEL5mkb+w196rZPJn0KuFtw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Stefan Roesch <shr@fb.com>,
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

On Sat, Jan 28, 2023 at 11:48 AM Steve Grubb <sgrubb@redhat.com> wrote:
> On Friday, January 27, 2023 5:53:24 PM EST Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 5:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> > > On 1/27/23 3:38=E2=80=AFPM, Paul Moore wrote:
> > > > On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> > > >> On 1/27/23 12:42=E2=80=AFPM, Paul Moore wrote:
> > > >>> On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wro=
te:
> > > >>>> On 1/27/23 10:23=E2=80=AFAM, Richard Guy Briggs wrote:
> > > >>>>> A couple of updates to the iouring ops audit bypass selections
> > > >>>>> suggested in consultation with Steve Grubb.
> > > >>>>>
> > > >>>>> Richard Guy Briggs (2):
> > > >>>>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MAD=
VISE
> > > >>>>>   io_uring,audit: do not log IORING_OP_*GETXATTR
> > > >>>>>
> > > >>>>>  io_uring/opdef.c | 4 +++-
> > > >>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
> > > >>>>
> > > >>>> Look fine to me - we should probably add stable to both of them,
> > > >>>> just to keep things consistent across releases. I can queue them=
 up
> > > >>>> for 6.3.
> > > >>>
> > > >>> Please hold off until I've had a chance to look them over ...
> > > >>
> > > >> I haven't taken anything yet, for things like this I always let it
> > > >> simmer until people have had a chance to do so.
> > > >
> > > > Thanks.  FWIW, that sounds very reasonable to me, but I've seen lot=
s
> > > > of different behaviors across subsystems and wanted to make sure we
> > > > were on the same page.
> > >
> > > Sounds fair. BTW, can we stop CC'ing closed lists on patch
> > > submissions? Getting these:
> > >
> > > Your message to Linux-audit awaits moderator approval
> > >
> > > on every reply is really annoying.
> >
> > We kinda need audit related stuff on the linux-audit list, that's our
> > mailing list for audit stuff.
> >
> > However, I agree that it is crap that the linux-audit list is
> > moderated, but unfortunately that isn't something I control (I haven't
> > worked for RH in years, and even then the list owner was really weird
> > about managing the list).  Occasionally I grumble about moving the
> > kernel audit development to a linux-audit list on vger but haven't
> > bothered yet, perhaps this is as good a reason as any.
> >
> > Richard, Steve - any chance of opening the linux-audit list?
>
> Unfortunately, it really has to be this way. I deleted 10 spam emails
> yesterday. It seems like some people subscribed to this list are compromi=
sed.
> Because everytime there is a legit email, it's followed in a few seconds =
by a
> spam email.
>
> Anyways, all legit email will be approved without needing to be subscribe=
d.

The problem is that other subsystem developers who aren't subscribed
to the linux-audit list end up getting held mail notices (see the
comments from Jens).  The moderation of linux-audit, as permissive as
it may be for proper emails, is a problem for upstream linux audit
development, I would say much more so than 10/day mails.

If you are unable/unwilling to switch linux-audit over to an open
mailing list we should revisit moving over to a vger list; at least
for upstream kernel development, you are welcome to stick with the
existing redhat.com list for discussion of your userspace tools.

--=20
paul-moore.com
