Return-Path: <io-uring+bounces-7835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C135AA9C71
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 21:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D495017E0B1
	for <lists+io-uring@lfdr.de>; Mon,  5 May 2025 19:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71F512701D6;
	Mon,  5 May 2025 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKjissC1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3CD26FDB4
	for <io-uring@vger.kernel.org>; Mon,  5 May 2025 19:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472930; cv=none; b=mwaM8q9pDct2qH2E9JrzlkcbfesnuoIqMtz/Kr2t8WcUtWLwlVn6HcCa8WOErkeuCVb+5ZyaoiWaTUE+fT3JA/XqSDDMzxVy9wHZ2GwZHyUdwZ1gWiEH/YubnrWzCTcQFP8fd2E29vWJjo/N5PtPRowa61+eNTvx+noqYz8SSAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472930; c=relaxed/simple;
	bh=gYD/Kzs6oTsv+0ZH4aOAnzhos7PNt9I66XbHWq8bNHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nFa6Xdyxkbn4GbLphYa273TdUi6rcYPviPrUdEmJpcxi0A+5gGjYJri1filMxrdLsks+5s+g2eyUkJxR5WO4R+wXh9lH1+8vnjs4vv5OR8AtMdI0xjNN/eS1ejsL/P1Sk+sYwTM7wnzW8vxwjme4Bbo4qE+a1ZQQ4WW6F7Ighjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKjissC1; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2263428c8baso25185ad.1
        for <io-uring@vger.kernel.org>; Mon, 05 May 2025 12:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746472926; x=1747077726; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13EmT6a1TZnyupdlDEzlBX0OfGBAsXa0Pw9qfUJ6O8k=;
        b=PKjissC1ASZ4Z423+/lTq3pVNF8JcFpAnJlQ0ZDptuCniIEzDk8TArLduucGcz+GuK
         /Zb/tgBXkoM1M/ObO6sGId7VJfDmofAV5qmM1PAzlXw/DdTDAiVOVOS8+XwZHq9yYyTa
         rTeJP8p9m2jVaTtgf/VdM4ynI/JoqDQS8TgTwMk5vwIaKparng0bPH6OL8h+0wUqSICP
         XnIXslcW9uwQ/9sprUMD/2Ws4elqLUMmqtP7+SLN55l1wUaLn5TNgBbmT42bmapyV7nj
         R0x0WFLzLPs8NvjwkGC8e6Adg4/kOnAoo/paiz4QxZQ+gBmxhUcn5p0HcOGDfHe1HUV2
         VSfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746472926; x=1747077726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13EmT6a1TZnyupdlDEzlBX0OfGBAsXa0Pw9qfUJ6O8k=;
        b=ZC07g0oq8BDWJoK6hjKYzRGk+eRJ8shrvtQtesuXBDlGSFsPt0M/SEKggFWZwA8qI6
         5k0Tu6p4eX9p2DiSZPnMZzQUwc83fecYJhg3Qbibk1R4iJkVGagI0XMbbwxmYHq7s7VT
         Fq46sOexZZACVkDkhiX8IDavh8aVrgQol9op3LU1685aFG0aG6A3xLgpin8MoKUtSSv1
         tQPRbeJBMmYHFW8ly0vVOdh0r70Ul8GIOVmQBIlUWLEwsH1RrbaP3Rf9ukfHQhaLP0RC
         P8qvWbhWP4HDgwpCLiAjalUT81RGtkVBccw/c02QD59n0DUu52Wm0paJ/OCo91vhYTDd
         nVuw==
X-Forwarded-Encrypted: i=1; AJvYcCX/XPx1/3m8FMH5fBNSBf4P8Tyc+dOFstJs9bOyFk3yMupffOBhSjtawivq8NxU3o3JjfRyWvoqXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQRUMwEL5PWC09Us1AFhQEOeT5/ZmJXAfkCqPwrafdMfbpSrrP
	oC/FnlXCGgnZ+C7JCzsIzxoKxyMT3kokz+B01KZSomYJ7JYC+Wd9By3+XDgheEFX+6SLD7uDIjZ
	WygdPJV2fQkVZCqNHpBlsb47pXFDFXDnAzkz+
X-Gm-Gg: ASbGnctHbD8MLyTmbtntoKxBaMy1+AjyFL4FnHRB3vwCVh/knYF6zrEuwjKlMaYDtbR
	2GzVQOVIhjmQuKUd4ZC50oYmZi52fVhC0zaeMFY2erg7x5qIiKKTLEtMybA5EGfGxA1O7WYfc18
	YMsU9rH7ZvEcDpvmi40vHHjEdQjaOeJH6RKqje2os/o0pBXRr3Xth8
X-Google-Smtp-Source: AGHT+IH+1FHQJvKJ+5gk0ObZr0RxyrgBMmy3GsQ5pvSVSaH+9ABf1o8pwmLf6DaYpLoD5CckC/+0XsPmpQDgIq/k6Hw=
X-Received: by 2002:a17:903:46cd:b0:223:37ec:63be with SMTP id
 d9443c01a7336-22e34dee32bmr522795ad.4.1746472926072; Mon, 05 May 2025
 12:22:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
 <20250429032645.363766-5-almasrymina@google.com> <53433089-7beb-46cf-ae8a-6c58cd909e31@redhat.com>
 <CAHS8izMefrkHf9WXerrOY4Wo8U2KmxSVkgY+4JB+6iDuoCZ3WQ@mail.gmail.com> <8cdf120d-a0f0-4dcc-a8f9-cea967ce6e7b@redhat.com>
In-Reply-To: <8cdf120d-a0f0-4dcc-a8f9-cea967ce6e7b@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 5 May 2025 12:21:51 -0700
X-Gm-Features: ATxdqUF0TufrZ5sNnCdYBkqjbvffoKrpOyGeuWbNVRLX_hL4oSnD4IZmYehVOSg
Message-ID: <CAHS8izOVV-NviR-Ty=hDdg29OCpJCQwW_K7B+mg1X=r3N7Lr7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v13 4/9] net: devmem: Implement TX path
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 12:42=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 5/2/25 9:20 PM, Mina Almasry wrote:
> > On Fri, May 2, 2025 at 4:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> =
wrote:
> >>> @@ -1078,7 +1092,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct =
msghdr *msg, size_t size)
> >>>                               zc =3D MSG_ZEROCOPY;
> >>>               } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
> >>>                       skb =3D tcp_write_queue_tail(sk);
> >>> -                     uarg =3D msg_zerocopy_realloc(sk, size, skb_zco=
py(skb));
> >>> +                     uarg =3D msg_zerocopy_realloc(sk, size, skb_zco=
py(skb),
> >>> +                                                 sockc_valid && !!so=
ckc.dmabuf_id);
> >>
> >> If sock_cmsg_send() failed and the user did not provide a dmabuf_id,
> >> memory accounting will be incorrect.
> >
> > Forgive me but I don't see it. sockc_valid will be false, so
> > msg_zerocopy_realloc will do the normal MSG_ZEROCOPY accounting. Then
> > below whech check sockc_valid in place of where we did the
> > sock_cmsg_send before, and goto err. I assume the goto err should undo
> > the memory accounting in the new code as in the old code. Can you
> > elaborate on the bug you see?
>
> Uhm, I think I misread the condition used for msg_zerocopy_realloc()
> last argument.
>
> Re-reading it now it the problem I see is that if sock_cmsg_send() fails
> after correctly setting 'dmabuf_id', msg_zerocopy_realloc() will account
> the dmabuf memory, which looks unexpected.
>

This is my intention with the code, let me know if you think it's
actually wrong. In this scenario, sockc_valid will be false, so
msg_zerocopy_realloc() will account the dma-buf memory, then later if
!sockc_valid, we goto out_err which will net_zcopy_put and finally
unaccount the dmabuf memory. It is a bit weird indeed to account and
unaccount the dmabuf memory in this edge case but AFAICT it's
harmless? It also matches the scenario where the user uses
MSG_ZEROCOPY with an invalid cmsg. In that case the zerocopy memory
will be accounted in msg_zerocopy_realloc and unaccounted in
net_zcopy_put in the error path as well.

Improving this edge case is possible but maybe complicates the code.
Either the dmabuf id needs to be split up into its own parsing like
you suggested earlier, or we need to record that the user is
attempting to set a dmabuf id, but since the whole sock_cmsg_send
failed we may not know what the user intended to do at all.

> Somewhat related, I don't see any change to the msg_zerocopy/ubuf
> complete/cleanup path(s): what will happen to the devmem ubuf memory at
> uarg->complete() time? It looks like it will go unexpectedly through
> mm_unaccount_pinned_pages()???
>

Right, this works without a change in the cleanup path needed. When
the dmabuf id is provided, we skip calling mm_account_pinned_pages in
msg_zerocopy_alloc and msg_zerocopy_realloc, so we skip setting
uarg->mmp->user.

mm_unaccount_pinned_pages does nothing if uarg->mmp->user is not set:

void mm_unaccount_pinned_pages(struct mmpin *mmp)
{
  if (mmp->user) {
     atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
     free_uid(mmp->user);
   }
}

Although maybe a comment would explain why it works to improve clarity.


--=20
Thanks,
Mina

