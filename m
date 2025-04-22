Return-Path: <io-uring+bounces-7641-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4E9A97838
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 23:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 298DD174F4E
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 21:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B64E32DEB98;
	Tue, 22 Apr 2025 21:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gkTb8zm2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52482DDD1B
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 21:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745356223; cv=none; b=b+M7rYODfhLh1ndPnwzTKJaLkedePMALkevCjidioaFkbekMshO2F+lRi81yOeTWgsgZ9LJGVdhHVBZ9Yfoo7QnEC515V3L7ZXHVCQghkuNrBgGTaIeS5wbx6g9a2A4jrj/h1q4ywXivmvVn+OaB4zAkN7VHMW301zNc1JsMDtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745356223; c=relaxed/simple;
	bh=DGei0lrNYocjpAo+fluDzi6pCQENfL0ofHkr/7MyVCc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lWCd8pd328B72uYWBqe102bMP1KLlEzzfi0IGMCzeRjcP7cwCq5Vg9xnAiyF1TNt9VlymA8EiMXO+bZujF9/LEQ/e6S9OxjYNwNj+LR6EmzMENiSZFxjB0KqScesnfpow+QBNpJKSZaFP8Ls/6vigR0ZlXsgMcL4nzVDsFhah4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gkTb8zm2; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2240aad70f2so75135ad.0
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745356221; x=1745961021; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7kxTjGBKB0aUEv3DpjjmftGzp6kA+GSoHXFlnyGsDM=;
        b=gkTb8zm2CyA7ntRa3aTsez52qSIVwAk3fZlk5npkOMuMl51y0eVARx8qiSvxtMEn82
         TVg4ZYJ4reXvPRkKGdNuGaRk743KSKz1dktQR2WK7rG6eraQAAUgppCC369xSh1K63af
         9EWLflP0rxE52O0+ZV9atxXuNaEixcDtl6KOu6qtj+ztvrLw31xKL+BW1+8F8Yz6BWt5
         4/PTlbLiWwgERn/DgY7aeRB5v9qFVwwTg8DK7/0CKQrZ/pmLi0Rxv4pS1Aq0aBvRGyta
         TTp1vFaYcuqn3xN0Lt9DeYtk+iK32vwyDB4/pPgKhrXnpUGHcnZAiY83sV815qp+ow0R
         E//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745356221; x=1745961021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7kxTjGBKB0aUEv3DpjjmftGzp6kA+GSoHXFlnyGsDM=;
        b=eS6iTmseOGsd1tr3eVdDzTEFZpA4OxPZtIYdHuyhRQvGWUCv2VFK4rdSi3DHZL5kaX
         kqcnkeWME8DYGBpIjT/vBN4AE+yVQg7B5ZCjaChb7C8P/R1X0XROQT2L/G3ePtI+jQfl
         uQfj+pU2P0kOCDt2KSIxbV9GOkDNndnlbyi3XMYtVsB0ptrj+YxESDYMDg6wNI+ZKHsL
         Iwx4Sd4Hj/OG2ZwNSro2p/ZzKBfKSUeiUtNpa4bQz5IsY7tKRmJEEd1NV2SrhwxAhAWK
         k/wfo8N+ZrsCcsRodT1wsMLOb1fYMC0GwmqaKqy3B2+HdegZWzrImhKRvJ/+jMt64nqJ
         qVhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYamo7SE08RcVSdkLgj96F7NNB9VpNx3Y3pUZadnoc4YYygKIMnCa0QAOKTI7qelR/WEsq/VeyOg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9rmnveUW54Ie8HPp9aDM3kjNbhays5wRTIGGUwvwsMDZSD5Wg
	VAQCx9VsyTPtwxIDZwxYQ7jPzwvYtSLsr8/It146qtmh1xEq66q8B8It8eNona04ZOisuZxi4iQ
	JPLEbBMlZusqfHMokAUH291OFRQk+LFBYY1rq
X-Gm-Gg: ASbGncs0Uj2wSNheg7260MPGFUmXZj+SWmw+ZR1/msH1JsEH+l+tkNVO6xzTIHTd/UB
	4yLTq5bMeSmr0hMI7pTwcz9KoZGRNjkj31Ka0pb6Zgb8Ho6mzgPtyIVAINpdfcXJoOdERmRPfrP
	/w79Y1dQlfn4iiunzN4Gr5dc1zbjBfU9j1YN4dkBRjNUG3eUrfDOTV
X-Google-Smtp-Source: AGHT+IH158SP9GigskzwrjsRVwtmkJmUMnK2yFgK5B4j6Q7h/21qQMUx52O/Zx9vaqWSN5WxUUUx40w0l4D2Gn/nHjY=
X-Received: by 2002:a17:903:440b:b0:21f:465d:c588 with SMTP id
 d9443c01a7336-22da2b93ca8mr912615ad.14.1745356220781; Tue, 22 Apr 2025
 14:10:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-3-almasrymina@google.com> <484ecaad-56de-4c0d-b7fa-a3337557b0bf@gmail.com>
 <CAHS8izPw9maOMqLALTLc22eOKnutyLK9azOs4FzO1pfaY8xE6g@mail.gmail.com>
 <957b74ed-f29c-4bb8-b819-af4e1168d6c1@gmail.com> <CAHS8izM8+zG6KOhV7ysTsCj_PEty5eL+P+uUxTZhdsOSZTwmow@mail.gmail.com>
 <c0bd45f7-0325-4e4b-b0ea-ccae24a1eabd@gmail.com> <8c1c6405-1e60-4512-a675-4c00b00d400a@gmail.com>
In-Reply-To: <8c1c6405-1e60-4512-a675-4c00b00d400a@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 22 Apr 2025 14:10:07 -0700
X-Gm-Features: ATxdqUGGcVSR15YZdMmTAEwjNhzjDLr5MPRZuyqszCuepKJwAh2SaRe-PxHXBXc
Message-ID: <CAHS8izPGuF1PxfdmXUC1XJHpmRqotXh=vUY_a-AEHdAgPmLQ1g@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/9] net: add get_netmem/put_netmem support
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 1:03=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 4/22/25 20:47, Pavel Begunkov wrote:
> > On 4/22/25 19:30, Mina Almasry wrote:
> >> On Tue, Apr 22, 2025 at 11:19=E2=80=AFAM Pavel Begunkov <asml.silence@=
gmail.com> wrote:
> >>>
> >>> On 4/22/25 14:56, Mina Almasry wrote:
> >>>> On Tue, Apr 22, 2025 at 1:43=E2=80=AFAM Pavel Begunkov <asml.silence=
@gmail.com> wrote:
> >>>>>
> >>>>> On 4/18/25 00:15, Mina Almasry wrote:
> >>>>>> Currently net_iovs support only pp ref counts, and do not support =
a
> >>>>>> page ref equivalent.
> >>>>>
> >>>>> Makes me wonder why it's needed. In theory, nobody should ever be
> >>>>> taking page references without going through struct ubuf_info
> >>>>> handling first, all in kernel users of these pages should always
> >>>>> be paired with ubuf_info, as it's user memory, it's not stable,
> >>>>> and without ubuf_info the user is allowed to overwrite it.
> >>>>>
> >>>>
> >>>> The concern about the stability of the from-userspace data is alread=
y
> >>>> called out in the MSG_ZEROCOPY documentation that we're piggybacking
> >>>> devmem TX onto:
> >>>
> >>> Sure, I didn't object that. There is no problem as long as the
> >>> ubuf_info semantics is followed, which by extension mean that
> >>> any ref manipulation should already be gated on ubuf_info, and
> >>> there should be no need in changing generic paths.
> >>>
> >>
> >> I'm sorry I'm not following. skb_frag_ref is how the net stack obtains
> >> references on an skb_frag, regardless on whether the frag is a
> >> MSG_ZEROCOPY one with ubuf info, or a regular tx frag without a
> >> ubuf_info, or even an io_uring frag which I think have the
> >
> > Yep
> >
> >> msg->ubuf_info like we discussed previously. I don't see the net stack
> >> in the current code special casing how it obtains refs on frags, and I
> >> don't see the need to add special casing. Can you elaborate in more
> >
> > You'll be special casing it either way, it's probably unavoidable,
> > just here it is in put/get_netmem.
> >
> >> detail what is the gating you expect, and why? Are you asking that I
> >> check the skb has a ubuf_info before allowing to grab the reference on
> >> the dmabuf binding? Or something else?
> >
> > get_page() already shouldn't be a valid operation for ubuf backed frags
> > apart from few cases where frags are copied/moved together with ubuf.

This is where I'm not following. Per the v5 changelog of this commit,
all these skb_helpers hit skb_frag_ref (which is just get_page
underneath):

tcp_grow_skb, __skb_zcopy_downgrade_managed, __pskb_copy_fclone,
  pskb_expand_head, skb_zerocopy, skb_split, pksb_carve_inside_header,
  pskb_care_inside_nonlinear, tcp_clone_payload, skb_segment, skb_shift,
  skb_try_coalesce.

I don't see many of them opt-out of skb_frag_ref if the skb is
unreadable or has ubuf_info. Are you saying all/most/some of these
callers are invalid?  I tend to assume merged code is the correct one
unless I have ample expertise to say otherwise.

> > The frags are essentially bundled with ubuf and shouldn't exist without
> > it, because otherwise user can overwrite memory with all the following
> > nastiness. If there are some spots violating that, I'd rather say they
> > should be addressed.
> >
> > Instead of adding net_iov / devmem handling in generic paths affecting
> > everyone, you could change those functions where it's get_page() are
> > called legitimately. The niov/devmem part of get/put_netmem doesn't
> > even have the same semantics as the page counterparts as it cannot
> > prevent from reallocation. That might be fine, but it's not clear
>
> Actually, maybe it's not that exclusive to netiov, same reallocation
> argument is true for user pages, even though they're reffed
> separately.
>
> It might be fine to leave this approach, while suboptimal it should
> be easier for you. Depends on how folks feel about the extra
> overhead in the normal tx path.
>

Right, I think there is only 2 ways to handle all the code paths in
the tcp stack that hit skb_frag_ref:

1. We go over all of them and make sure they're unreachable for unreadable =
skbs:

if (!skb_frags_readable()) return; // or something

2. or, we just add net_iov support in skb_frag_ref.

This patch series does the latter, which IMO is much preferred.

FWIW I'm surprised that adding net_iov support to skb_frag_ref/unref
is facing uncertainty. I've added net_iov support for many skb helpers
in commit 65249feb6b3df ("net: add support for skbs with unreadable
frags") and commit 9f6b619edf2e8 ("net: support non paged skb frags").
skb_frag_ref/unref is just 1 helper I "missed" because it's mostly
(but not entirely) used by the TX path.

--=20
Thanks,
Mina

