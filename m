Return-Path: <io-uring+bounces-6317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29DA6A2D063
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 23:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 102697A396A
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 22:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F1C1AF0AF;
	Fri,  7 Feb 2025 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="SvhxL5Vf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70978479
	for <io-uring@vger.kernel.org>; Fri,  7 Feb 2025 22:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738966915; cv=none; b=mA6xdRZUAFal0TFnsCJ+rEIMoBBSiBgAXRItxvqdRbhJiCD69zwOVBzqaqIgJXZ8oyUyiChh4LRsYp2GwucytbU1TgY/bF60xlVoJbN508nAkfjUFkELxQ2bvKRDk/D3qoWqAAjOJJAufOA+dHtJU3Z6pqV8z+WnIhvId2TUHns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738966915; c=relaxed/simple;
	bh=tK3rfULmuKjq5ZkQcPkvEUu0wfRoYfeMb1VFEZvdmi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lISW5QBLi2ZmfwBLXXFHZMNoHVkq4IXWkSa4UVEhr/zUz0ccRRxB29TT0QtSCRzO0Pq+T3HfbFIvH0QE9gqBSSGaHZ2KftNRuFQ0BmSg+mtMXEU5kx1RJIn9NYCNDlzZbX8bXPXZUqWS4grg7+2fdBUxgZxklspJcd1eL7JsX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=SvhxL5Vf; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6f768e9be1aso31435277b3.0
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2025 14:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1738966912; x=1739571712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEPaswESS1PjI7HNTDsrPk0/PCf34GKT+5GZnVwgZXY=;
        b=SvhxL5VfunWjdcxlzGG8u4EHGFeoE7Hsd7VSpFB7mWXw538cZ6lDN4xCKYTXb/F+ny
         JbRof8Ynh2JOOl8IEVEzxfhATq8HT3CWC6o87hI1Dl3UZ3xrmnLWMIGhmVi/pE05I+rY
         wXAW8Gxfq1MDGFgixyMSTZ7C6RkY/wCTbtpQY/iUWB4Px9eYadHPzV5zmwu0p1ba1Fls
         KqkW5/VjK9BGXv1fuP1CZ9vmL9Az40NU67ezIiqr+Ds75KxDZMG7loRBZdD1GTsngRdi
         tzNxoG0aRQBGjAxlrwK8Jz8epBG8jx9S+R7TsMHL4XvmInAhe0rtltaxBlCKY3sgmmVa
         lQSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738966912; x=1739571712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEPaswESS1PjI7HNTDsrPk0/PCf34GKT+5GZnVwgZXY=;
        b=EIFKtlyrGT1LB+a2XezpeYiFBk5sHWL13wVRT6hRfqkZzH6cuDEmH7I6cb5RecEAPV
         vkPu1exhBSET6pYjSTkPZJv6EmuLP4WpT7qZHixm5rxS45omzTYBPAlHUqRVvIoQ0vUL
         V8LLn6eM0CYZCxNIXj+by2Fef6+NZ3zvI0rbnfTBVGuE5eVnHsJ8J80CBkKyTz87gXCm
         nSvNA0JJWwPTWtitCndND3g3+fWGPZcE5+OqH+N0vgTmlOVDXAQ+IlCdg8raPjAYY7XB
         9eRbXVYDz/oWP9GVpt4SSHOw/I4gSAcXEY8tW3bMyEvE2wWFxJ+m5B4zJmxKdworoA7c
         oiaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmvNbcKiYCHZFXZJz51uW50CbW3zYUgo1suK1qbFgk2I+jQxW4ITmFuUKT4tToDDc01sFVKYvicw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeFzem9zpdjiK1KWwTFI19FGRUE0YWdZ3oyBN/gq5lGJXP7Yuj
	RRffIi8VMmehgvUVNQwEL6iOAw8OD6+VLnq8qLss7mTEKt0MLTDIUieABlG6HiTvZFlLZ1cY7wA
	HxdFrS4hKoRUmrKxm8kaxOGHhxRhCUYtTpYck
X-Gm-Gg: ASbGnctUO6InjgtMxgxy41/pzvHkSKlB50/rfbNefzBzz/bChp5hMvAHvayMUamOyqN
	jNtchcjiZP3EpsDUg9oAKsBgGw3UjTJBO43aCdH+g83eGM7TqHvvoFlo6xJdptUc+isXuaIU=
X-Google-Smtp-Source: AGHT+IHBRA127lA39kegDN775o8sxuc/2TfRWjm6n/rOOXgCq5OxY/YTyMkihpXgx3uBbbWMJZ1NIqaD8HwuOOVN9kc=
X-Received: by 2002:a05:690c:730a:b0:6f9:c6e2:89a8 with SMTP id
 00721157ae682-6f9c6e2c8b3mr21691667b3.6.1738966912666; Fri, 07 Feb 2025
 14:21:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127155723.67711-1-hamzamahfooz@linux.microsoft.com>
 <8743aa5049b129982f7784ad24b2ec48@paul-moore.com> <f4efd956-ebe9-4a02-8b98-b80e16db95af@kernel.dk>
In-Reply-To: <f4efd956-ebe9-4a02-8b98-b80e16db95af@kernel.dk>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 7 Feb 2025 17:21:42 -0500
X-Gm-Features: AWEUYZm96FCzr6LWRjIh3Nuf8FgTiXEW22PFLZ07c4RqLniYHD_Dg4aIbl2L02M
Message-ID: <CAHC9VhQDMSw9VNzd1pLRv1a3v8y2wz9rM4k0wa1t-Wq8KO6kFw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] io_uring: refactor io_uring_allowed()
To: Jens Axboe <axboe@kernel.dk>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	=?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>, 
	=?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, linux-security-module@vger.kernel.org, 
	io-uring@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 4:54=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/7/25 2:42 PM, Paul Moore wrote:
> > On Jan 27, 2025 Hamza Mahfooz <hamzamahfooz@linux.microsoft.com> wrote:
> >>
> >> Have io_uring_allowed() return an error code directly instead of
> >> true/false. This is needed for follow-up work to guard io_uring_setup(=
)
> >> with LSM.
> >>
> >> Cc: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
> >> ---
> >>  io_uring/io_uring.c | 21 ++++++++++++++-------
> >>  1 file changed, 14 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >> index 7bfbc7c22367..c2d8bd4c2cfc 100644
> >> --- a/io_uring/io_uring.c
> >> +++ b/io_uring/io_uring.c
> >> @@ -3789,29 +3789,36 @@ static long io_uring_setup(u32 entries, struct=
 io_uring_params __user *params)
> >>      return io_uring_create(entries, &p, params);
> >>  }
> >>
> >> -static inline bool io_uring_allowed(void)
> >> +static inline int io_uring_allowed(void)
> >>  {
> >>      int disabled =3D READ_ONCE(sysctl_io_uring_disabled);
> >>      kgid_t io_uring_group;
> >>
> >>      if (disabled =3D=3D 2)
> >> -            return false;
> >> +            return -EPERM;
> >>
> >>      if (disabled =3D=3D 0 || capable(CAP_SYS_ADMIN))
> >> -            return true;
> >> +            goto allowed_lsm;
> >
> > I'd probably just 'return 0;' here as the "allowed_lsm" goto label
> > doesn't make a lot of sense until patch 2/2, but otherwise this
> > looks okay to me.
>
> Agree, get rid of this unnecessary goto.

Done.  Converted to return in patch 1/2 and brought the goto/label
back in patch 2/2.

> > Jens, are you okay with this patch?  If yes, can we get an ACK from you=
?
>
> With that change, yep I'm fine with both of these and you can add my
> acked-by to them.

Great.  Both patches have now been merged into lsm/dev, thanks everyone!

--=20
paul-moore.com

