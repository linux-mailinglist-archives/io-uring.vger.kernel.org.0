Return-Path: <io-uring+bounces-4332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B29509B9934
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:12:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 460F9283235
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35F71CEAAC;
	Fri,  1 Nov 2024 20:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y66KX+dq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188A21E1322
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730491921; cv=none; b=Vai1hLUpjelaCA2tQbnorRcDIC7qyVPPPJLNnGH6Vr6/7t/ZFekYrKro7zF9pxN6yDFKTCtmbSKR+J1FFwBVvz42smZtQx8PBaEMgK6QIxkprCElXj0zAeS8+bDlwM9alHGrJ/aCgoxaYm1rgodc7kodLYxtpnEiy3Poma/Thmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730491921; c=relaxed/simple;
	bh=hr97Yp3Qp6SmW8JuJbDwdSzmRhchs4ulWgoo6MWx2hI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mlEv0lhwST9AGG1eqB4rCrTQ7Q3hpXy+SjqT7bJpGM0H+KqTVcPu+pgE2Ya2AbOqwXoLG1cID6ASFDjpe/Ng1vefjwho3JZiCndqubZnuaKpA05QH8PwuenTHpHjt/upYKvvf6FG1B+APFL4J249QCX6bLYcWWUuzqh3Zlkw8Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y66KX+dq; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4608dddaa35so75521cf.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730491919; x=1731096719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ejiV3nojKU8JOSRuqbEiFZ2lXr3DMRw92KQ2wPjl88w=;
        b=Y66KX+dqIUF/kiMMuILdaoMfa7BOoK8P/JD7e3jkubRqEC0JiNmzku704pdOooZwvG
         QSjweK4ptQkFXd/SbN2ukdh7Ed3ksiiOUkBHkx5yfScgkXXgUN1Lt7kHaguRrbCfdtrr
         y85G+wGHON591di9BXLRK30SCe+ouq/v73kidEg8QiNdVICf1qWMZhoM9DHUhWPsrTGS
         yJaxOUgHLwzgeoWYZjYqwnhvXFEvQjggGE8+qTM0/trMrjC7umtq8+qMJdtCS/SmVIzR
         0uqmDz2gqNswXDzbSRvmEcu3T+clOQuFBGFLPZgEQfEv1BE/5m5PrC2pFH1rLIQ3qgQH
         fNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730491919; x=1731096719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejiV3nojKU8JOSRuqbEiFZ2lXr3DMRw92KQ2wPjl88w=;
        b=vr/YCu/NeXMIclfrlMuC1UI2JZEj6VOdP8B8BpvxigBuhok1sTrQVlzthu9rnorx7e
         df7Ch9/2HW6mLskrhyAC+yhVq79U2XBHWjggyduubly0gRaS6OIIA6koML2vdxeWtAW+
         WwwFzbJOhbooIQK1exbF7k6YFCMTjME5Co3kFRnqlgAUKpXpJchaoymrR1YUeD9VN08u
         3EbU35cK2a5qy4svE/i2Gb9fNc7DnA/7f6bxrd6PK6tm3/tte1TpDhrsfxhYb1Axw+dt
         mh0DkVJNSVGRPBPFk7ayeXYhnSBQquHyA66tfhqYMWWYK3BPfb9BvC+Wn3Tpi7b3Ky4Z
         ePyQ==
X-Gm-Message-State: AOJu0YwKP1pDRJBUnAs6NGilUX8AK6sJKZOgBGxANOcJgGnztjFVXyRk
	EheLmkewYg/0+l8n/fYKzpCkJWBWie+dkSwzVfcyBj9AcxumMk8nVeiTLFUHGZ+sk18AqrCxT+T
	MeNz6LH0LomBDnMqCTBMWYMKu46WS1GmWKOor
X-Gm-Gg: ASbGncvrdPC2Pwnc3zC+de+eNnTi+lQGM9iY2KfLs+xL8fCD8giZWlkFNA07uVu4C4M
	HdVfNI2LbQIufCt5XI4VxSrbdC9TdgJzCNxcIHCm6Bf7+1ijGyqI4XRZt98Rsyg==
X-Google-Smtp-Source: AGHT+IHhchjVNua+q1hjFSSUiFjye5O8F2gFXrFh+qB1xxZL2N98zYmsGHlhpJipLyhO/M3LOagO1DK9x+u5isJgcdM=
X-Received: by 2002:a05:622a:2991:b0:461:5b0d:7aa5 with SMTP id
 d75a77b69052e-462c5ef8accmr680331cf.16.1730491918776; Fri, 01 Nov 2024
 13:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-13-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-13-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 13:11:46 -0700
Message-ID: <CAHS8izP=S8nEk77A+dfBzOyq7ddcGUNYNkVGDhpfJarzdx3vGw@mail.gmail.com>
Subject: Re: [PATCH v7 12/15] io_uring/zcrx: add io_recvzc request
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
...
> +static void io_zcrx_get_buf_uref(struct net_iov *niov)
> +{
> +       atomic_long_add(IO_ZC_RX_UREF, &niov->pp_ref_count);
> +}
> +

This is not specific to io_rcrx I think. Please rename this and put it
somewhere generic, like netmem.h.

Then tcp_recvmsg_dmabuf can use the same helper instead of the very
ugly call it currently does:

- atomic_long_inc(&niov->pp_ref_count);
+ net_iov_pp_ref_get(niov, 1);

Or something.

In general I think io_uring code can do whatever it wants with the
io_uring specific bits in net_iov (everything under net_area_owner I
think), but please lets try to keep any code touching the generic
net_iov fields (pp_pagic, pp_ref_count, and others) in generic
helpers.

--=20
Thanks,
Mina

