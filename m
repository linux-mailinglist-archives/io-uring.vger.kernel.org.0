Return-Path: <io-uring+bounces-9130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6669DB2E5EC
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9445F7A1C12
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B6AA26E6F8;
	Wed, 20 Aug 2025 19:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyGd/Ktd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC09272805;
	Wed, 20 Aug 2025 19:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755719911; cv=none; b=kqC0T7k0LRdtQ42+XDOYjAqgNgcj+bMlAIrZ0W5eQH2q25olgTq5fPVJiX7GysFCyB803Cwd92ctk2056OBknuLMGmUYr4w1wvi8cGYScxsp0II33hmPdN2aRt4lt5ZN8Bu13+K//n488HfJhm6qvKNA5XMlRluoLto9SyyxCkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755719911; c=relaxed/simple;
	bh=DrCLzJGKL9IMdLrVr3WmS2MqRMf53NqUvSEUy18gl0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p/i28Q14d+55GD34NmxMg+ED0Qk50ZZLFWQynvdo1WyP9EB6dNXpJGkt5yo3NH0qQjLYoCgF7ywHbXmEOsYMyqDl3JOQBEOFbBpD51H8xAVC7j2nQmrYMZzAdxW478xEzG4DHCdI6Gz7fpCeAmAEYQetRpr9IMS5chx5AMNJhJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyGd/Ktd; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6188b5b11b2so355504a12.0;
        Wed, 20 Aug 2025 12:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755719908; x=1756324708; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DrCLzJGKL9IMdLrVr3WmS2MqRMf53NqUvSEUy18gl0M=;
        b=gyGd/KtdO1ESFbNJnRgQCItFZLsxw0BL/tc167nOlkjMnKWA43Gk7soOUzdZV2QlIc
         D9L0NvIarW1ymCdGjaFj3mkaH1fTRwGz8JrBntCY8IL6CLbjMJMSSnq4/dj6xOluvZTr
         5+JyE3gHNfjR3R0lvwwkYnW+0oWbWdFsIQEIsXURtj8UPNtHScKhS9R2xTzPZlswUWZl
         LtoTJAOCsy2xqrj9/VAT4+3uQ/mluORUV7O0bPCXNbPYNYPapL7sH+5CeiCnffn73/wm
         9vLQFt/sOU98tPOF0JLdb6QPiprh9q7z23uQS9x/p8+ggWSUMjSFQzoeONPXcMT9BPps
         qzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755719908; x=1756324708;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DrCLzJGKL9IMdLrVr3WmS2MqRMf53NqUvSEUy18gl0M=;
        b=hd8DB+kVhCv5VwqmRKG7AjxJWfNoSq14p7j858tIP7tz58JVpB15vyhOgtBFAZKNbe
         9oofS6CkLkwekrLpiBeV/aYloHJha1h4aWPgdxYrYyVEJW0661tZiFC1OVpQcbYxcLXV
         ClahLKSG2+gjVqXmNNFD43EPrEY5ONrIDSd9d2tGohMlIvxaSFsyo4dFGmW7H0sYsOw7
         D2MZR9gYPo8InijB8RF56J89TTN6BGGNBxjxmuQJNYbfInA+dWpCOfymDWdvSylseQYD
         GbN8uP1wHg0NtLjCfj5nsRhaJQK1BPWG1HXqDkzGJ3rDI0ZqRWwZbeJUTp6WYkgN5eXF
         uXBw==
X-Forwarded-Encrypted: i=1; AJvYcCW1Wt/BUvp3PDRfVzLUxgBaSxejN0CGkBUexpV362ydYz7bPKrnpk9AMYLkNiEipsDKE2/+fwmavCxC@vger.kernel.org, AJvYcCWB02OH9vs9SzYWVvryjILino5DLU1VmKz1jzWoFLK6YABp6vvdNdDv7WpIg0A78wU87XJCs4E4yA==@vger.kernel.org, AJvYcCWYxhDU/WFK55ywJ+0NUJqDLm8im8HEN5zn4Si3N/vJ4El1u/9/oNDDhp/hoNPU3cKZiyUQptW08xsRcSNBug==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4OirzAtteHrOVlRWt5EfjDLm0jV5CyPqnGITorMpghENjp6jD
	bs64Sn0r4Zc+b/vuEgXk1P1pGw4w2Hl368HbqH0ZzQCDrDIxnUBqazZYl7w0YxyfcZBDHssmI76
	jw6yoH4suYv0R+TnUzlnHz2Fu6bZJrreklBekc0Y=
X-Gm-Gg: ASbGncsnJgNWLdQZLu0jytWeZHPeB/BPpAwWzZRyTAE3yF52efa6sHAX0PI4PWgSVlZ
	xF6q9Z3YQrE9BAYHPj0Tep/9dJrexYUTcDjVH27gMxiT/JWFPOvdzXGSJlHCJUrn+27c4+DYKPc
	6b7/nbmwfWufCW/pJefRQOt2HzMkqx4RHF8ukhXsH4rOHZilsJxyH4r5UCZ/dXxLM8YBeLvZ1Np
	SbbsS4=
X-Google-Smtp-Source: AGHT+IHz3RUpxwLj7iccb8tWUFo4rVFO25gpGufkQ9Kdvzb+LHpYlkwD3M/A09Q7s7Yo0DemFLD1+3I2vSBAQhRt6P8=
X-Received: by 2002:a05:6402:5113:b0:617:b2ab:fba2 with SMTP id
 4fb4d7f45d1cf-61a97852204mr3668137a12.34.1755719907563; Wed, 20 Aug 2025
 12:58:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk> <DC6X58YNOC3F.BPB6J0245QTL@gmail.com>
 <CAOQ4uxj=XOFqHBmYY1aBFAnJtSkxzSyPu5G3xP1rx=ZfPfe-kg@mail.gmail.com> <DC7CIXI2T3FD.1I8C9PE5V0TRI@gmail.com>
In-Reply-To: <DC7CIXI2T3FD.1I8C9PE5V0TRI@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 20 Aug 2025 21:58:15 +0200
X-Gm-Features: Ac12FXyBjV4DVeabWqrwgWWH8D97_E8xUqiThZ4IEFLodWZ22x2R_8SezBmTlNc
Message-ID: <CAOQ4uximiUryMV=z_3TrEN1KCSA-2YdCt0t7v1M1gRZpnWec=Q@mail.gmail.com>
Subject: Re: [PATCHSET RFC 0/6] add support for name_to, open_by_handle_at(2)
 to io_uring
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 5:00=E2=80=AFPM Thomas Bertschinger
<tahbertschinger@gmail.com> wrote:
>
> On Wed Aug 20, 2025 at 2:34 AM MDT, Amir Goldstein wrote:
> > On Wed, Aug 20, 2025 at 4:57=E2=80=AFAM Thomas Bertschinger
> > <tahbertschinger@gmail.com> wrote:
> >> Any thoughts on that? This seemed to me like there wasn't an obvious
> >> easy solution, hence why I just didn't attempt it at all in v1.
> >> Maybe I'm missing something, though.
> >>
> >
> > Since FILEID_IS_CONNECTABLE, we started using the high 16 bits of
> > fh_type for FILEID_USER_FLAGS, since fs is not likely expecting a fh_ty=
pe
> > beyond 0xff (Documentation/filesystems/nfs/exporting.rst):
> > "A filehandle fragment consists of an array of 1 or more 4byte words,
> > together with a one byte "type"."
> >
> > The name FILEID_USER_FLAGS may be a bit misleading - it was
> > never the intention for users to manipulate those flags, although they
> > certainly can and there is no real harm in that.
> >
> > These flags are used in the syscall interface only, but
> > ->fh_to_{dentry,parent}() function signature also take an int fh_flags
> > argument, so we can use that to express the non-blocking request.
> >
> > Untested patch follows (easier than explaining):
>
> Ah, that makes sense and makes this seem feasible. Thanks for pointing
> that out!
>
> It also seems that each FS could opt in to this with a new EXPORT_OP
> flag so that the FSes that want to support this can be updated
> individually. Then, updating most or every exportable FS isn't a
> requirement for this.

Makes a lot of sense. yes.

>
> Do you have an opinion on that, versus expecting every ->fh_to_dentry()
> implementation to respect the new flag?

Technically, you do not need every fs to respect this flag, you only need t=
hem
to not ignore it.

Generally, if you pass (fileid_type | EXPORT_FH_CACHED) as the type
argument, most filesystems will not accept this value anyway and return
NULL or PTR_ERR(-ESTALE), so not ignoring.

But I think it is much preferred to check the opt-in EXPORT_OP
flag and return EAGAIN from generic code in the case that fs does
not support non-blocking decode.

And fs that do opt in should probably return PTR_ERR(-EAGAIN)
when the file type is correct but non-blocking decode is not possible.

Thanks,
Amir.

