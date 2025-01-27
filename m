Return-Path: <io-uring+bounces-6145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD18A1FF9B
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 22:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DA443A04D2
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 21:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4B31A83E8;
	Mon, 27 Jan 2025 21:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="IL6qGAdP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9D21991DB
	for <io-uring@vger.kernel.org>; Mon, 27 Jan 2025 21:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012998; cv=none; b=YnV2kq+3gHdzlVsfyXJs/54ZR21ejALsy5rCRYSH58BJdpcAT3CPdFFLXpWRQX2bmIjyMeVXaqPnq+8pR2Coq/W3X7N8AUcCN8njB+ZTbzIl2nd1jl0TnvfmsVR1V/jj8D2sLLycLjXh1dU2mFy3tRRa01RqrXf2IDjHbPuyFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012998; c=relaxed/simple;
	bh=XAyVRpnsN3psIErJlMt7zXtv2npL60nto/i5id7ai5s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dy8tqydlBp/D1pZtIawAI+LcpCUz4Jv1yXyITwciOb7Ph6CUa8CqpOeVyHaWfYDCBu4grkfP3cBJ73rUBs5Ienmob1xAUQ/QS5BcsmBkQZbcR1aIXn0uPqS34L5ADlH/er7JSLshbsfc6YBKBpVcd4LmsDi+oNZEGseJp8H4kRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=IL6qGAdP; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e4a6b978283so9481793276.0
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2025 13:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1738012995; x=1738617795; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAyVRpnsN3psIErJlMt7zXtv2npL60nto/i5id7ai5s=;
        b=IL6qGAdP5KtEU89F6UIipJRoq4GL+ZhA3eAAkGqA4SrDh2TYRUAF8DRvUZgaMK+4Em
         Vju0utuOfqEV1TK7KYxBVastQt5wpBxkkdonXc8DXT9wUvL3Cqto44Qc60CG29f+RV+9
         DACf/0mKDPDIs8FdEYC1UXQOV+1d0MvgLqw4Ru5YsoWIkSPoiDHFS0EHKAk6FWeUkaB6
         +JRCJR3+V7ULJ4i7DtH0Ev2VWq4XIEr80GK+hHjpsVggPeLqUblieuofzX65wZL9kksq
         BbEo4qE9nkXEm36GuprA9WhIeou12fGcioXTjGRlogmf4wW+5GXiTcfXx4vYU9DkUlx1
         EouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738012995; x=1738617795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAyVRpnsN3psIErJlMt7zXtv2npL60nto/i5id7ai5s=;
        b=cLaegQmFfs1r6UfOOmBPAceO3M+H6EbO3h8NWEq6nprziQwrvHL4L2YLFSj3dO5wcY
         biNQRz0CGjtiLswiB1+5W9s23mlRjw042sBoglStJ1WZWlYKeTfg7N/j0xxjvCNFp0dT
         bg7LRMp5xC5AzPWNDyMOmiegj9ej8EvzX+/fyBUDV4+npGTw0OFbIma1sKhFeMn4cUG5
         tbNqFLq0ExQnJgTpgcTavnL2ZNV8UGR4/NvRtTPqNae3JbDNQBj8kGLfPfEXIJqMxP7Q
         VMV95MSul+2K7A9J7NgCXZ8KGYW4Yc+u8FNt2MepF+3kFopibgH4jK3Nx++O0nHxKrdu
         UU5w==
X-Forwarded-Encrypted: i=1; AJvYcCUNO6ljQwHdMISTIMlT/DwxE+Zh9sMoUhWDQYeBLiY68Z7esdJzcPb30Byl+FP8/+KuziTNPUcqpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YySqrSSIEGDuD5I3wOqGc90PC1Kmvv+fZBozVOENL6g478Wm1kL
	lJKFBRxeLgvxHl4DaXjuaa/tREe55j2z1wTGPKJfYX/omXSZqlK6O7ePvY7FyDH7pWgfux9BArV
	QyUeQxUwEba+lTl+M2AJkAKP9RLfB2zzAIxUX
X-Gm-Gg: ASbGnctj2+HBHcqxOuA3zX/gqugLKyDrM3+ALn4FCxl30XIpy3lAymDiyCVvXjOjNYR
	VBGiagd3MiBWRJkdI3PIh3VuCxA81L0l08SxkHJ23CMowbFARiM7x9L8MqCq3
X-Google-Smtp-Source: AGHT+IF5t5BkdSOg4TSJrHoTqiHeMhIdCAWFpEFPilYMsqGS822/Rm3nUcgF1QsJ8yeEYre5K2r6eTgn+B9c1RFUO7c=
X-Received: by 2002:a05:690c:7342:b0:6ea:88d4:fd4f with SMTP id
 00721157ae682-6f7976f7cc0mr9495627b3.18.1738012995453; Mon, 27 Jan 2025
 13:23:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
 <20250127155723.67711-2-hamzamahfooz@linux.microsoft.com> <bd6c2bee-b9bb-4eba-9216-135df204a10e@schaufler-ca.com>
In-Reply-To: <bd6c2bee-b9bb-4eba-9216-135df204a10e@schaufler-ca.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 27 Jan 2025 16:23:04 -0500
X-Gm-Features: AWEUYZk_66DBXYyyXGpF3__XoAd1UXYaUgnN9Z9hxMeEkqEEj3wnGpO9yXQUN_Q
Message-ID: <CAHC9VhRaXgLKo6NbEVBiZOA1NowbwdoYNkFEpZ65VJ6h0TSdFw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] lsm,io_uring: add LSM hooks for io_uring_setup()
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, linux-kernel@vger.kernel.org, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	=?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, linux-security-module@vger.kernel.org, 
	io-uring@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2025 at 12:18=E2=80=AFPM Casey Schaufler <casey@schaufler-c=
a.com> wrote:
> On 1/27/2025 7:57 AM, Hamza Mahfooz wrote:
> > It is desirable to allow LSM to configure accessibility to io_uring
> > because it is a coarse yet very simple way to restrict access to it. So=
,
> > add an LSM for io_uring_allowed() to guard access to io_uring.
>
> I don't like this at all at all. It looks like you're putting in a hook
> so that io_uring can easily deflect any responsibility for safely
> interacting with LSMs.

That's not how this works Casey, unless you're seeing something different?

This is an additional access control point for io_uring, largely to
simplify what a LSM would need to do to help control a process' access
to io_uring, it does not replace any of the io_uring LSM hooks or
access control points.

--=20
paul-moore.com

