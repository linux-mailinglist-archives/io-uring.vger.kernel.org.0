Return-Path: <io-uring+bounces-7643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB319A97ACF
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 01:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68B171B61A6B
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 23:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4022D1913;
	Tue, 22 Apr 2025 23:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vSTPJmDW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A27190472
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 23:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745362857; cv=none; b=tqFsBjsF5mWzbbVvnMmkaCf9S4L9a1Kk4Wh7vRPN4ANMGeFil1UTaQ3abPEetWfgk8+bY/HssMWIo6FpsqY6FfcPzC/jO2l7lQFHoedwN/YP8MEjYtw3zHvFrY3e1Qcixo7kKY/C0Ba/paaW5vC94li/QlB4vwXq7xeWujnQna4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745362857; c=relaxed/simple;
	bh=vA0x1LF+TTujtzA/a9qIyOuUZvc6uTpZ8L2xS4rCm/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cwf0tqmh07u3m37G0SXs1tRvDGIlgjGBSu7ci0HqLUv+xGDGqOxqcKb+qqQvNRWup6p0FatSs8FYuJuk+3LtH0YxJ8Ikst95wrCpoT0Q7sx4lsuBR0nWF9TnhtnQumEmixI0xHbZbEvaZEQyMdZsebqTzy4mJtqZtlQm7EOkFx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vSTPJmDW; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2240aad70f2so102535ad.0
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 16:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745362854; x=1745967654; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X0wkS+mYcttDoYH2cbzpbLqiayCSdu0EeV0O89OnxB4=;
        b=vSTPJmDW/0RBiNQ+pXo+/ZFUu9NXOW/mYR/LTeXX0PDtkS2kzlnEhrDftAorprnLh9
         B/ocgO6V4ijHaBDVDYg9jL9VOb/JTTXw0+6S+4tY7MtwRoZ5UvWVUsbIXQaus6pT7WIM
         w9JyPlBFdKdDqkaPdhGNJyHXBD3R1sPHkcrer5Y+IzcoOu9zjO12veodho3lesqRnqS/
         ZAStMrBVqSDj4W5etdANq85mg8kvu8N2Yyfeq9+o7t2dSSKpzsDi4P2t4oGQC/1IFwHS
         Bak+lxuGPw4pkmdTAXPNdW6jRVAwnpbPvESvT2YSRlvhPL7TLc7E1y0fQt/+j6nPSPYZ
         Y8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745362854; x=1745967654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X0wkS+mYcttDoYH2cbzpbLqiayCSdu0EeV0O89OnxB4=;
        b=D5VO9imlTPdf1P1YzqI7so6sfmBSbvybjK1nbPIl4VsAnwXZzxErqM2uc/znLCIEZn
         e3jq6YISeCCGx/uhEAesw9uki8ZjGeUdws+FBZjJ3frUpmaPsEPl85joa2/98YwVzyyj
         tJAciH+XMWBz6v1X5brVOda18n7/u1obN1dYJ0I8iQSTYK/vv3I8sQWbgL+TQ30xOIyZ
         EeUEYLUIn5KzKQGBXmvAuP3hv5tEicBdGN47Wn3awcLkwvMMXIsDITQCnyAFxtKr0NUF
         MHVqXk/lxGCrOIt+H5vlUE5n8XPXCL1wLuXx1P9N151nFyEZJwYdmuLab+Dfn16Ri9ds
         QReA==
X-Forwarded-Encrypted: i=1; AJvYcCXU5YgXN8IaBBQSiE0nb8sxpAkrBR0CPYtphPfC4xBNxR0krjvQCF3H/xmgZ6s6YAubD7HYLk9BNg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1MUzsWzwhs74XBMI3zakmjGR0I2/MtdUk0no8Yf+JWa23cBt/
	1w0URy1YHDdf9EbOJgALROve/zzpgYwktGmAXgOHmhXD1Zjm0XLnqgQzmk01WW2b1SudRqtX7fD
	ZTCYfxW3mrke19BTuYwtottSCWMEkl/PqpQgN
X-Gm-Gg: ASbGncs1dut7qdmIWms1aPXLc1GWRBDPsI1ThcH5381e/nygYmGcWfgpXWVNLkW6LC/
	km7GrdDLNxJhcIMdgrMfZPduj5RegZWCQfNwMOn4hsFT6d14oLZDyJn1M4/R4aWcTBIWo5yMIh8
	SlXH+KG1T4IShsT1HIDjbkVDD/nmPXepW0NQZjTcK+4/JA1X8nvb3/ab5OJaFtr3Y=
X-Google-Smtp-Source: AGHT+IFcA8eNct2OIuHlbOvxzm3T6NVzaOSOXt3ivEIqSJ8wke0kgYVfmjCEtUHN4nE+IsPWRgGhH+7fhESmeCiNRMo=
X-Received: by 2002:a17:902:ef07:b0:215:86bf:7e46 with SMTP id
 d9443c01a7336-22da4ebcff9mr256305ad.7.1745362853731; Tue, 22 Apr 2025
 16:00:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-8-almasrymina@google.com> <CAEAWyHckGSYEMDqVDT0u7pFCpO9fmXpEDb7-YV87pu+R+ytxOw@mail.gmail.com>
 <CAHS8izNZXmG0bi15DpmX2EcococF2swM83Urk19aQBvz=z3nUQ@mail.gmail.com>
In-Reply-To: <CAHS8izNZXmG0bi15DpmX2EcococF2swM83Urk19aQBvz=z3nUQ@mail.gmail.com>
From: Harshitha Ramamurthy <hramamurthy@google.com>
Date: Tue, 22 Apr 2025 16:00:42 -0700
X-Gm-Features: ATxdqUGxkrayoAGMPm_qgEhKu-sQHz14vjXf4E7ZJdbEqvqiDvu9MHtNVHd91NA
Message-ID: <CAEAWyHf7Qzi8CDBeRMB5nMvvNawrFrUCh52k4JevbSHX1Y=zcw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 7/9] gve: add netmem TX support to GVE DQO-RDA mode
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 2:30=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> On Tue, Apr 22, 2025 at 10:43=E2=80=AFAM Harshitha Ramamurthy
> <hramamurthy@google.com> wrote:
> >
> > On Thu, Apr 17, 2025 at 4:15=E2=80=AFPM Mina Almasry <almasrymina@googl=
e.com> wrote:
> > >
> > > Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
> > > enable netmem TX support in that mode.
> > >
> > > Declare support for netmem TX in GVE DQO-RDA mode.
> > >
> > > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > >
> > > ---
> > >
> > > v4:
> > > - New patch
> > > ---
> > >  drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
> > >  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
> > >  2 files changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net=
/ethernet/google/gve/gve_main.c
> > > index 8aaac9101377..430314225d4d 100644
> > > --- a/drivers/net/ethernet/google/gve/gve_main.c
> > > +++ b/drivers/net/ethernet/google/gve/gve_main.c
> > > @@ -2665,6 +2665,10 @@ static int gve_probe(struct pci_dev *pdev, con=
st struct pci_device_id *ent)
> > >
> > >         dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
> > >         dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queu=
e_format);
> > > +
> > > +       if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
> > > +               dev->netmem_tx =3D true;
> > > +
> >
> > a nit: but it would fit in better and be more uniform if this is set
> > earlier in the function where other features are set for the
> > net_device.
> >
>
> Thanks for taking a look. I actually thought about that while trying
> to implement this, but AFAIU (correct if wrong), gve_is_gqi and
> gve_is_qpl need priv to be initialized, so this feature set must be
> performed after gve_init_priv in this function. I suppose this feature
> checking maybe can be put before register_netdev. Do you prefer that?

Ah yes, you are right. Thanks for checking. That would be preferable.
Another option is to move it inside gve_init_priv() after the mode has
been set. Either is okay.

Thanks,
Harshitha
>
>
> --
> Thanks,
> Mina

