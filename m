Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343AA703C44
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 20:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244907AbjEOSRD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 14:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243743AbjEOSQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 14:16:45 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F8102
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 11:14:46 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f42397f41fso380515e9.1
        for <io-uring@vger.kernel.org>; Mon, 15 May 2023 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684174484; x=1686766484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOKorS2J4RYeRLpH2nZdhlw6zsIATdNqLobWtCvJD3c=;
        b=DpNqjRLY3IjEbVTtLp9Kk6Ri2D3jZqUZuaqV+eSWm/5pfZ3m00ggUO5t/pmOKiyAbl
         qO1P3zAi7M35RkwUqpB9tsiiL6rvYdQtBxjPe4f8RpmCM9Kt7GH+GtFWuw1YmS/6H4D0
         PsnMNk6Io7+y5yZFSE6SeN541sOPK2sTzZqBKb+xIW7eAqVuJtvv6119YLYt/yr+0AWN
         FVF0GOXUhBkfFAOPlYkpLlJXdMORcGy4FuuuWZObKxGNyDHc51QuRW0zx1ziylqq8ePf
         88NbIw8qSa60wDkwJixdlgXzSYNSsoWi5XgGxU7w890891Qjj+SnQM9ft0t3Wbplp+Cl
         YRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684174484; x=1686766484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zOKorS2J4RYeRLpH2nZdhlw6zsIATdNqLobWtCvJD3c=;
        b=Ybry1YS3JNl1EbuXXYq0prB71zVfGvMBqKd5sihEXdcuHwaY8E4tW46OC9/cq4lpib
         I3u3YiZa732YNXmjzM0EqGVwz8nIJ3zDNy8c5KFoJ8aScQxdXKG+KVFXvBwJB+vtUq9P
         EmHYPOuiVoG/yKnWR7efygfHluV/WIv74cQiiW2vZjbh7FTMkqJdoaPX2biWbGfjhMb5
         CAok5uoW7Rks9dUmisff064/JGw+6d5JuyEvAUUtnSmtTh1BHnyVdQuNJCMcBtlvCMMc
         wHXtodglyNVQkzMDECpYqlddYXNQ/D5rUBxsOu8lF8ObXDHUhRmnM2FhcgtqEIgMG27f
         QT9A==
X-Gm-Message-State: AC+VfDzAS7LUueU12Tun0fqLIDRzaNHbi/dmqxDdrvZlAJm4/iyKiABe
        IYyv7/y/nK6aEP9ROpmL12gRo1kX2lM9rYU2+hDnRw==
X-Google-Smtp-Source: ACHHUZ61bSyFE689iTPi5t1L/hhfohsO49e6+ZdfQiMJj132LmBFGhlB75QCHHUgGdiWeKVMyUsIiD/J9fqaXUlrhww=
X-Received: by 2002:a05:600c:3547:b0:3f4:1dce:3047 with SMTP id
 i7-20020a05600c354700b003f41dce3047mr6981wmq.2.1684174484515; Mon, 15 May
 2023 11:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1684166247.git.asml.silence@gmail.com> <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
In-Reply-To: <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 May 2023 20:14:32 +0200
Message-ID: <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf refcounting
To:     David Ahern <dsahern@kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 15, 2023 at 7:29=E2=80=AFPM David Ahern <dsahern@kernel.org> wr=
ote:
>
> On 5/15/23 10:06 AM, Pavel Begunkov wrote:
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 40f591f7fce1..3d18e295bb2f 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1231,7 +1231,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >       if ((flags & MSG_ZEROCOPY) && size) {
> >               if (msg->msg_ubuf) {
> >                       uarg =3D msg->msg_ubuf;
> > -                     net_zcopy_get(uarg);
> >                       zc =3D sk->sk_route_caps & NETIF_F_SG;
> >               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
> >                       skb =3D tcp_write_queue_tail(sk);
> > @@ -1458,7 +1457,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >               tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
> >       }
> >  out_nopush:
> > -     net_zcopy_put(uarg);
> > +     /* msg->msg_ubuf is pinned by the caller so we don't take extra r=
efs */
> > +     if (uarg && !msg->msg_ubuf)
> > +             net_zcopy_put(uarg);
> >       return copied + copied_syn;
> >
> >  do_error:
> > @@ -1467,7 +1468,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct ms=
ghdr *msg, size_t size)
> >       if (copied + copied_syn)
> >               goto out;
> >  out_err:
> > -     net_zcopy_put_abort(uarg, true);
> > +     /* msg->msg_ubuf is pinned by the caller so we don't take extra r=
efs */
> > +     if (uarg && !msg->msg_ubuf)
> > +             net_zcopy_put_abort(uarg, true);
> >       err =3D sk_stream_error(sk, flags, err);
> >       /* make sure we wake any epoll edge trigger waiter */
> >       if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err =3D=3D -EA=
GAIN)) {
>
> Both net_zcopy_put_abort and net_zcopy_put have an `if (uarg)` check.

Right, but here this might avoid a read of msg->msg_ubuf, which might
be more expensive to fetch.

Compiler will probably remove the second test (uarg) from net_zcopy_put()

Reviewed-by: Eric Dumazet <edumazet@google.com>
