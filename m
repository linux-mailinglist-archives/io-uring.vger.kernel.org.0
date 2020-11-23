Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839FC2C17A5
	for <lists+io-uring@lfdr.de>; Mon, 23 Nov 2020 22:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgKWVYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Nov 2020 16:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgKWVYJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Nov 2020 16:24:09 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0692DC0613CF
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 13:24:09 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l5so18613391edq.11
        for <io-uring@vger.kernel.org>; Mon, 23 Nov 2020 13:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Et4fHNGjBXo9uqpsLTzTTKFLfRmQxJK2FeHZE24s8Y=;
        b=NSnRBScAecrJNyEXtk2XbFJzgxf4LBxDc9S0wXuhghis88rKOIaXQPmYPMAUa+JMlJ
         MSx7WHjozx9chvAnLoOTj8SouzPTpdTzl3CZja7cpvcL/Styv0BWqW9yZce06biASovS
         Dw3UVfikThJ/Qzk5zjVSKn3NplBi3jalKrA9WAEDv4VkhrdZYlJCVpcqPfKTmfrqI/Y5
         5RoHujDq6xIeyWgjWjlKiCr49EzeENcercM7eogm2NfYJXoJQAka9JlyeRgOAppdcUUj
         RWtHaWy3V8YbroxfrwvIc0Hprsa3yOq4B+AGVHndA49UDRlsu5/AIhXDT4aadTQUr8/H
         ES9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Et4fHNGjBXo9uqpsLTzTTKFLfRmQxJK2FeHZE24s8Y=;
        b=JbvU+g4HNOl0ywX9m/LGxvtVobghv6bQK1rsVe8DCR8B6hRGIyBBqBiTU5o/bvIMcf
         naVs66wBaajl1Vl/l3JOTLe6TEKvXr9ZX7+K5eYxXgWrLD2vfy/6OKEu520EYyz4e9Fa
         0O0GV14tOoMAQtM5y1YmHdn3DSXjVtp1ZBdE2er7NaAjbV/HHkKH0jvcOAQkVe75lLjE
         W55+qyCQszAH995ruXmPD4SZvZQ8lL2kM63KCha3VA8rS/28qY0izvmYM3HFjfgbGgFj
         OLsnxdQUxh5YIHmWClTs8GsXMIZ+Yagvvt77iMOAmmdg9lw+xgJn8hjQCSOfoKCAHpyh
         typA==
X-Gm-Message-State: AOAM533wJBZZpmjCxANLu19HtleuPHoT/xVjYS9DoVDgs1A3xvRkm/I1
        KzF6XFA13BCLjjNMi9pbr62oRZwVebINr0k/FhrEKXcVNjuDSQ==
X-Google-Smtp-Source: ABdhPJyPIUwawGKRiUfvm0U5fmH8YEwDqplYmLqUqi1Ft77GkpGPCjtJV22xsPD/BfAaFFLqmNTn1HEWeFD5JVCgNyo=
X-Received: by 2002:a50:f157:: with SMTP id z23mr1089718edl.303.1606166647721;
 Mon, 23 Nov 2020 13:24:07 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwjmGd8=992NjY6TjgsbMoxFS5j2_71bgaYUOUT0vG-19A@mail.gmail.com>
 <142638c1-8334-e45b-d1d7-b1feb060ff85@gmail.com>
In-Reply-To: <142638c1-8334-e45b-d1d7-b1feb060ff85@gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Mon, 23 Nov 2020 21:23:57 +0000
Message-ID: <CAM1kxwjFVutTb8jd+fRwvm_1QN=EmgRAbF+sY-pnGCMABry3hw@mail.gmail.com>
Subject: Re: [RFC 1/1] whitelisting UDP GSO and GRO cmsgs
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 23, 2020 at 8:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 23/11/2020 15:35, Victor Stewart wrote:
> > add __sys_whitelisted_cmsghdrs() and configure __sys_recvmsg_sock and
> > __sys_sendmsg_sock to use it.
>
> They haven't been disabled without a reason, and that's not only
> because of creds. Did you verify that it's safe to allow those?

conceptually i don't see how it would not be safe? but maybe someone
who knows better can make such an argument.

>
> >
> > Signed-off by: Victor Stewart <v@nametag.social>
> > ---
> >  net/socket.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/socket.c b/net/socket.c
> > index 6e6cccc2104f..44e28bb08bbe 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -2416,9 +2416,9 @@ static int ___sys_sendmsg(struct socket *sock,
> > struct user_msghdr __user *msg,
> >  long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
> >                         unsigned int flags)
> >  {
> > -       /* disallow ancillary data requests from this path */
> >         if (msg->msg_control || msg->msg_controllen)
> > -               return -EINVAL;
> > +               if (!__sys_whitelisted_cmsghdrs(msr))
>
> Its definition below and I don't see a forward declaration anywhere.
> Did you even compile this?

i knew it would be a hotly contested topic, so no i did not compile
it, that's why i put RFC not patch. Just to broach a potential
solution for discussion.

>
> > +                       return -EINVAL;
> >
> >         return ____sys_sendmsg(sock, msg, flags, NULL, 0);
> >  }
> > @@ -2620,6 +2620,15 @@ static int ___sys_recvmsg(struct socket *sock,
> > struct user_msghdr __user *msg,
> >         return err;
> >  }
> >
> > +static bool __sys_whitelisted_cmsghdrs(struct msghdr *msg)
>
> Don't call it __sys*

kk

>
> > +{
> > +       for (struct cmsghdr *cmsg = CMSG_FIRSTHDR(msg); cmsg != NULL;
> > cmsg = CMSG_NXTHDR(message, cmsg))
>
> no var declarations in for, run checkpatch.pl first

kk

>
> > +               if (cmsg->cmsg_level != SOL_UDP || (cmsg->cmsg_type !=
> > UDP_GRO && cmsg->cmsg_type != UDP_SEGMENT))
> > +                       return false;
> > +
> > +       return true;
> > +}
> > +
> >  /*
> >   *     BSD recvmsg interface
> >   */
> > @@ -2630,7 +2639,7 @@ long __sys_recvmsg_sock(struct socket *sock,
> > struct msghdr *msg,
> >  {
> >         if (msg->msg_control || msg->msg_controllen) {
> >                 /* disallow ancillary data reqs unless cmsg is plain data */
> > -               if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
> > +               if (!( sock->ops->flags & PROTO_CMSG_DATA_ONLY ||
>
> extra space after "("
>
> don't forget about brackets when mixing bitwise and logical and/or
>
> It would look better if you'd get rid of outer brackets and propagate !
>
> > __sys_whitelisted_cmsghdrs(msr) ))
> >                         return -EINVAL;
> >         }
> >
>
> --
> Pavel Begunkov
