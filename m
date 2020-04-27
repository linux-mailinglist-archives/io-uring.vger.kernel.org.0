Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3141BADCB
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgD0TV1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgD0TV0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 15:21:26 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD57C0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 12:21:26 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id u6so18827490ljl.6
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 12:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4cHgSjEPoMmt6ubw7HV3nxIOaw6puMj10ujckObz/P0=;
        b=UQUgfZyduAwD1OnLyiVfz4s33exIjMboLOFxlytve5HtAd+QlLtYzkDsnn/qa/t6ia
         gc5XiMfQN/sHa/YwJT0xMBkNGhLRAZv3xq4wJvE1fQgx8UTOxnynaE9mD69V9JqqKdlc
         VKU/3gqso5favCjBFi20I5ifYDGkAMD2HJrKUjUq87+HUo1BWSGYvR3TbFjzVrLJj+bK
         K5eOcdxIqWiD9xXI/tLtB39GyaPntAi8sFIgBDXQL8GC24z4wg/i5okJite0RPvxxbVX
         rAhwiOarh6Nka6L+19G/gvYIB4drAaVUQrvcCAEwM1EcSsdhPuEa5N/AqHNo3oGx+OOp
         /Nng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4cHgSjEPoMmt6ubw7HV3nxIOaw6puMj10ujckObz/P0=;
        b=KMTFkOjV3LGCuBvh1stnxlL+Pgi8o29wQT5yZ6h3VNQ8cyQSvAVeWQU2Or2ryu4sQj
         d7eODyi+zDO+0btzgPIgr8e+ce1cnFQFyBvmSjphtEh4oYmHSkyIS+b3N+NQ0Pj33aJ6
         a+xH+mJ8ph7XGRInBdF7cPa7ee7tlAuJWdmEu6JGnJUUy/vLzSde18VNyMTw6JuWztni
         OH8T373dJbAi8FtTUjJedIG2RILPaopczsaLOg0JPEyLkNCm0ZuEX+CfxMm51qdy5oT3
         Fez6LfXyqUysb4/S1dX21og1P+6SG70QQ7gxqqRy7+1n6Cib3h1uNHBCuT/UgaDVXk9A
         s5Gg==
X-Gm-Message-State: AGi0PuYfkIgOKnVRc7iNyPsMju+1b9qoyqiUp4zKgww7aXwwkfrFpavK
        NBrbSnhRdxrhsKua1VGQhvPYc/m21pyZIcWn61Csvg==
X-Google-Smtp-Source: APiQypKGflSj7oYxM9EC6zirKMxaj+YhMYZpG7rZCM7q1jgEZhFt6XAgesu7rliUn/XjBXxFEQqbNjgsTbNCmsE2fOo=
X-Received: by 2002:a2e:8999:: with SMTP id c25mr15466764lji.73.1588015284701;
 Mon, 27 Apr 2020 12:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAObFT-S27KXFGomqPZdXA8oJDe6QxmoT=T6CBgD9R9UHNmakUQ@mail.gmail.com>
 <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
In-Reply-To: <f75d30ff-53ec-c3a1-19b2-956735d44088@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Mon, 27 Apr 2020 21:20:57 +0200
Message-ID: <CAG48ez32nkvLsWStjenGmZdLaSPKWEcSccPKqgPtJwme8ZxxuQ@mail.gmail.com>
Subject: Re: io_uring, IORING_OP_RECVMSG and ancillary data
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andreas Smas <andreas@lonelycoder.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 25, 2020 at 10:23 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 4/25/20 11:29 AM, Andreas Smas wrote:
> > Hi,
> >
> > Tried to use io_uring with OP_RECVMSG with ancillary buffers (for my
> > particular use case I'm using SO_TIMESTAMP for incoming UDP packets).
> >
> > These submissions fail with EINVAL due to the check in __sys_recvmsg_sock().
> >
> > The following hack fixes the problem for me and I get valid timestamps
> > back. Not suggesting this is the real fix as I'm not sure what the
> > implications of this is.
> >
> > Any insight into this would be much appreciated.
>
> It was originally disabled because of a security issue, but I do think
> it's safe to enable again.
>
> Adding the io-uring list and Jann as well, leaving patch intact below.
>
> > diff --git a/net/socket.c b/net/socket.c
> > index 2dd739fba866..689f41f4156e 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -2637,10 +2637,6 @@ long __sys_recvmsg_sock(struct socket *sock,
> > struct msghdr *msg,
> >                         struct user_msghdr __user *umsg,
> >                         struct sockaddr __user *uaddr, unsigned int flags)
> >  {
> > -       /* disallow ancillary data requests from this path */
> > -       if (msg->msg_control || msg->msg_controllen)
> > -               return -EINVAL;
> > -
> >         return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
> >  }

I think that's hard to get right. In particular, unix domain sockets
can currently pass file descriptors in control data - so you'd need to
set the file_table flag for recvmsg and sendmsg. And I'm not sure
whether, to make this robust, there should be a whitelist of types of
control messages that are permitted to be used with io_uring, or
something like that...

I think of ancillary buffers as being kind of like ioctl handlers in
this regard.
