Return-Path: <io-uring+bounces-10943-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B16CA1DF3
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 23:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86F7F3004184
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 22:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED16A23816C;
	Wed,  3 Dec 2025 22:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkJGw5ZV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52692398FAF
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 22:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764802483; cv=none; b=J0SGxMSMvdo2YBaSax9fyfcChtjzigunm3qML1NXjIdttmbuVnJJRmuotb8V0xuSUvEGclg2j2H4gjyP+dHOgyyInmDFxKWAMQ4iO3C8bhe5AnOVrrI2F5waJwZzPM3Vborw54A2rbOenw6XJfgVVF6mpM27aI+lEgFiR/kr2QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764802483; c=relaxed/simple;
	bh=6tJGWZZCoO+r0gC7HnwLMzkrop1h39jLGGfXFY4U9UA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uJohTFvsOmpLswN6AeNPYWq3l2a1DTCk/Um71jJXkFi38+5LknFBzTyl1ulEoGRgO6aAgkbHyT9RNdp9agF6DV2NoYEyfonwtrWJDNabLUseauR7OkWNgPEZu6ckMN8h7pN4cAu3V67xrpwdnbzZOl0C/0YZGgAzRuFHIkUYxdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkJGw5ZV; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8845498be17so2832156d6.3
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 14:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764802481; x=1765407281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ibbE6G0sj0VXpSJX096wxxY8pg0SLImHUCWhfoJU+Lg=;
        b=NkJGw5ZVpc8kHb7Dq7RtWlL7X5I3IUTDvBVJIC5Q96Y+a+ZA/jav6lxypkRsnwG2N8
         ceVnFnMwzIJnAzQRz9LPx79UOFaEIs4vu/k3pRTZtg8+Rk3Z61jaltvrf6L2TZAw+6ml
         lKcMioB6IxhAW2UGnGg9sSBxYgb17hVkwKAmac/OQwQMIkHuC2hqviq24Tq9jFYQz5Om
         pefxD0X6rutmDeOj7qwANIDPvkHVWU8EAvNZ4MMKykWTE30C6MFvZzVUMLTqJw9WYLzA
         1XFXO3nmgV7BUD9zZ2zXV2cnmRy2QTntqPxmqw8JljYzf1StlabzA93d1GQR8CrExJYt
         IwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764802481; x=1765407281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ibbE6G0sj0VXpSJX096wxxY8pg0SLImHUCWhfoJU+Lg=;
        b=qV8+paw4f2sj+pzGNmuCOt/xtKeLyERf8xOqYdbfSr94jTQeSH9Ft1vjkR3HEb6xFw
         O3KOTlEv9wyUe42gPNKxa6r5vt3IXix3eVOHCyvSSYfqVUwzLK00lyPxJfOiWxFkanwx
         R2bIYzDsQWApH8IUNgnj7P7yuH7BfzusNn78FWy3/aO88zOwShWdvO9Y2q5iAbQIZ7gl
         zbx0Yj3JWXMs+xw5UoXN72rcraFRo6jsQWNVR8pJoLCnIzmKcv3uEm8elSoCHHsldsvf
         0+Qbqd9IFvJkXxY5coeDmkvsWHvIYvdwfuObAQQFbCv5jUXF1NWvlMoP1RiYQUC5hZje
         F9WA==
X-Forwarded-Encrypted: i=1; AJvYcCVWDujFADU3BHywF0RwQYgHGpEZdRxIlsKe63d/hFgpgA/efKRYM66nIDsL1L4QayzdoPPY5ZSjtg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwciuEoxz1gCXcvIpvllIijcxe0m8VJdzs+zWXIbvxKTopFfO4/
	i82PJMuNU3H2os/2XwRMyG5WbxeA1JvL2fENn3rcrZn0UpMIAvc1e6raEk1hVQv/A3Yp+ix+XyO
	QGQXGvg4Aqoyx14zZAkgRu/Omjg4pejA=
X-Gm-Gg: ASbGnct5MtQJVjUqT6TguCLHak3ZS0emMq30FicNnM+l1g8LEi6YVNwuCKx/FpendWP
	MG1Wv4KxQzHtJbzRj3rIOB97a80zsSdiKaGEar+5EJ537vGduFDlGm7end5C7bArtrszo5Uv16r
	RlxQgI9/x91xOOFpPKdqDOD5Pcc6sbFLjcqRnMxXW98YJqG8LgGfjC8pMojzl0AO+fNbYmNY2Tj
	t6hCmPWFHpehVSmUbWGN2k5jRXI
X-Google-Smtp-Source: AGHT+IHJsViZkMTmCBMxoi5TkpMIEizyyeWGbzB4REIEmL3aB1T868RfMi+DH6hVro0JfQcSeaYFGLbzFktIyTi9l0s=
X-Received: by 2002:ac8:5d92:0:b0:4ee:1e82:e3f4 with SMTP id
 d75a77b69052e-4f0176bf57fmr57600061cf.64.1764802481157; Wed, 03 Dec 2025
 14:54:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-15-joannelkoong@gmail.com> <CADUfDZrtOdabnxd5x70gN5ZLWj=nQNhwezTfs_0XN9kuDAVsQg@mail.gmail.com>
In-Reply-To: <CADUfDZrtOdabnxd5x70gN5ZLWj=nQNhwezTfs_0XN9kuDAVsQg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 3 Dec 2025 14:54:30 -0800
X-Gm-Features: AWmQ_bnQJaV1Fc6Bw1dt0qhqIMTFKSwQkPyZv7clpAmFphuLK1jEqjgX5JFvHyQ
Message-ID: <CAJnrk1be1WaZ-WBgpSu7m0K0=4xtwPTt2jvHOz3DECoW=tn9zw@mail.gmail.com>
Subject: Re: [PATCH v1 14/30] io_uring: add release callback for ring death
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 2:25=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > Allow registering a release callback on a ring context that will be
> > called when the ring is about to be destroyed.
> >
> > This is a preparatory patch for fuse. Fuse will be pinning buffers and
> > registering bvecs, which requires cleanup whenever a server
> > disconnects. It needs to know if the ring is alive when the server has
> > disconnected, to avoid double-freeing or accessing invalid memory.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring.h       |  9 +++++++++
> >  include/linux/io_uring_types.h |  2 ++
> >  io_uring/io_uring.c            | 15 +++++++++++++++
> >  3 files changed, 26 insertions(+)
> >
> > diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> > index 85fe4e6b275c..327fd8ac6e42 100644
> >
> > +void io_uring_set_release_callback(struct io_ring_ctx *ctx,
> > +                                  void (*release)(void *), void *priv,
> > +                                  unsigned int issue_flags)
> > +{
> > +       io_ring_submit_lock(ctx, issue_flags);
> > +
> > +       ctx->release =3D release;
> > +       ctx->priv =3D priv;
>
> Looks like this doesn't support the registration of multiple release
> callbacks. Should there be a WARN_ON() to that effect?

Great idea, I'll add that in for v2.

Thanks,
Joanne
>
> Best,
> Caleb

