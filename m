Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D449E6CAFDC
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 22:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjC0UVU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 16:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjC0UVT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 16:21:19 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61853C1
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 13:21:16 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3ddbf70d790so955851cf.1
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 13:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679948475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/6o+GwcMkKuxxBkDa+vsp2Da1zGZT+YmMJLXs8JFCaU=;
        b=ZXz/jJVrK02KaMfEhSaa/SnraVT2PHnRnMMY+Fu4veAniVBF4fMszcd/E9O9V8TFai
         lzx6uxmNvsxXZ//r8sx+f47D99EDVVSy4yFWjNv6Vm/c4WIzzoGvM5NtturBPYElQmWA
         Jp4hA2oZXVLx86L/HyldQoaBjLJ/iAIMy91nF70z90zmQj4sQqRzeSedwCDDp9zO0dyS
         fyqJqzrMBGFqaB9vcKsU195lvGic7ZpP4te1PLwoRQsPs7B/YBTKMzOmsOeA9HQxo4Hv
         MLsKiW3UOTOhAFVUituyhjyPrnqoxwKk18XVjlDoaRhsqbug5ge1A3vTWtbooroy4Fk9
         WNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679948475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6o+GwcMkKuxxBkDa+vsp2Da1zGZT+YmMJLXs8JFCaU=;
        b=IqrCBUhf3Ou5kp5uKfYHOqveCoK+PX5A5iqcQjphN1jy1MMfTWE6KCSGywyk5gF7dN
         uPyDlH+kiJtxNBft4D0TqOh/+XoAxZYFqnOpPf8mHgsvubvo83jtBnR0Y2TCtlStJbWQ
         TSNZf10ZLy+qIM4ANAoEcaFkI5m50QkAk5So0pecxH1X7n1qOzznStnjsBIfU1oMe8Qg
         kIIfFCdwjAXVa1QCRK11Qth+GAH3VYy+IDlRISm8Z2Ef/ggHoYiHcUqAwud77Vv0Cab9
         3lsJYbWE5PvHtjKFoJF4D52iZB+Im8xIV0mC36UwF8wRIWhCHs1hJyWRT5LmBwof0lX0
         MUkQ==
X-Gm-Message-State: AAQBX9fL2foMonQ7l//uF5O8f6gTnSrUFARr2bG9tDignpA1W8JpdNuz
        vk5qEeke70w4sV9A7LygzjuIIzdSTy6tJpRNO3D5Ng==
X-Google-Smtp-Source: AKy350bSeD1EoRAUPiQsJ5zikY+LKym3+kKUSBJ6mdxREezg88uAfS5nHbzIOb1XFSdl40wjo34EVZDuf7/frUKj2Ag=
X-Received: by 2002:ac8:5dc6:0:b0:3d4:edfd:8b61 with SMTP id
 e6-20020ac85dc6000000b003d4edfd8b61mr112036qtx.0.1679948475400; Mon, 27 Mar
 2023 13:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bb028805f7dfab35@google.com> <20230327192158.GF73752@sol.localdomain>
 <4045f952-0756-5b04-8c60-6eed241a52fe@kernel.dk> <ZCH02Fp0YAhrLnug@gmail.com> <11ccf63c-2822-1e1e-6f4b-833136d46628@kernel.dk>
In-Reply-To: <11ccf63c-2822-1e1e-6f4b-833136d46628@kernel.dk>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Mon, 27 Mar 2023 22:21:02 +0200
Message-ID: <CANp29Y5kn4tgRKUwkfxoMHxESX=FC0GU4Yu-et45bh_MWBzviA@mail.gmail.com>
Subject: Re: [syzbot] Monthly io-uring report
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Eric Biggers <ebiggers@kernel.org>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+lista29bb0eabb2ddbae6f4a@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 27, 2023 at 10:00=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 3/27/23 1:56=E2=80=AFPM, Eric Biggers wrote:
> > On Mon, Mar 27, 2023 at 01:25:14PM -0600, Jens Axboe wrote:
> >> On 3/27/23 1:21?PM, Eric Biggers wrote:
> >>> Thanks for getting syzbot to classify reports by subsystem and send t=
hese
> >>> reminders!  These should be very helpful over time.
> >>>
> >>> One thing that is missing in these reminders is a mention of how to c=
hange the
> >>> subsystem of miscategorized bugs.  Yes, it's in https://goo.gl/tpsmEJ=
 halfway
> >>> down the page, but it's not obvious.
> >>>
> >>> I think adding something like "See https://goo.gl/tpsmEJ#subsystems f=
or how to
> >>> change the subsystem of miscategorized reports" would be helpful.  Pr=
obably not
> >>> in all syzbot emails, but just in these remainder emails.

That makes sense, thanks!
FWIW We can also add a subsystem-changing command that could be sent
just as a reply to such reminder email, so that there's no need to go
to the per-bug threads.

> >>
> >> I did go poke, it is listed off the reports too. But it'd be really
> >> handy if you could do this on the web page. When I see a report like
> >> that that's not for me, I just archive it. And like any chatter with
> >> syzbot, I have to look up what to reply to it every time. It'd be a lo=
t
> >> easy if I could just click on that page to either mark as invalid
> >> (providing the info there) or move it to another subsystem.
> >>
> >
> > Well, one problem that syzbot has to deal with is that to meet the kern=
el
> > community's needs, it can't require authentication to issue commands.
> >
> > I understand that the current email-only interface, where all commands =
are Cc'ed
> > to the syzkaller-bug mailing list, makes that not a complete disaster c=
urrently.
> >
> > I'd imagine that if anyone could just go to a web page and mess around =
with bug
> > statuses with no authentication, that might be more problematic.
>
> What prevents anyone from just sending an email to the syzbot issue email
> and modifying it?
>
> I love using email as it's easier when you're replying anyway, but the
> problem is that I can never remember the magic incantations that I need
> to send it. So I invariably click the link ANYWAY to find out what to
> reply, and now it's more hassle using email. Maybe we can solve this by
> making the email footer actually contain the common responses? Then
> I would not have to click, switch desktops, scroll to find, copy part
> of it, switch desktops, paste into email, open terminal to generate
> the rest, switch back to email, paste in, click send. It really isn't
> a very pleasurable experience.

Thanks for the feedback and the idea!
It would indeed be much easier if we listed some sample commands at the bot=
tom.

>
> --
> Jens Axboe
>
>
