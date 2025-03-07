Return-Path: <io-uring+bounces-7018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6893CA56E27
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:45:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A27D4164A15
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A097B23ED6F;
	Fri,  7 Mar 2025 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FqmbsUlj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C923ED6C;
	Fri,  7 Mar 2025 16:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365917; cv=none; b=D2wodK7TmY9t98F0C34Pda5ebYQAd0kQWJ7HLzLXifeDPlMtWLBk8gY6a3pQxB4MyKCM+iS/WOiRv8Ez/Imbe9lEguzFRfb+2zmC94RX0Q+NVE+4Ge9M/Vlfk/q+ImAjj9c4lCY40z3KU/Vry/tU2WkojsNUfHrbjsHSjtcg5Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365917; c=relaxed/simple;
	bh=yObUS2YQxxpK6Tcsa8ZDIUAE66RCNQ4OmalZ8Sapy0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwshlAb8u62coUf5Rfz5oFaIsQ0WhPyhRnTFro88HfUXdgSyCnDxo9Kna7+LPlrTPevorwQhVlihzBmiH+E7qQc+u0AmaDAIk8YjLNMdrYJqOmQw5JNN01JHhe7RrdJCArEjAzSGK1lMiHIBfof0GrW+NnISYdqHS+miZYHXKEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FqmbsUlj; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac0cc83e9adso638112466b.0;
        Fri, 07 Mar 2025 08:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741365914; x=1741970714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yObUS2YQxxpK6Tcsa8ZDIUAE66RCNQ4OmalZ8Sapy0w=;
        b=FqmbsUljJvricopOXuQYTOvAi2FJFVXWwp0DyS7By5HKelgVwF4qXU3C/H4Z0y7jDC
         XuM960LpiUMax1q0MqyDNUP+9JXz6dAfhLXpJKhQ5eYT+TlGunGK+0JETwnjHLWbuHvl
         2s3oTLytaBQUI88m8npHZSL2oSNuiqE+lxAvwEXkdeWKnocfQUUcgavGzrplYKoh4reT
         3gbcXHX6s4VLphoCvsuw6YxmOhyYFAjQYKVQQTpzRmoOksxdF9pKqZ9RjIPZZR8cjblK
         WAqqMOg/90WYsK0vvV0PoOyRL4/fYpL5powMV9vC+Za1CK3Rfe78fgDIX+PXj0FVbaAt
         FLzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365914; x=1741970714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yObUS2YQxxpK6Tcsa8ZDIUAE66RCNQ4OmalZ8Sapy0w=;
        b=v6lNpwSVXRsukhYUQiCfm/xWUARHF6eZQTRHIxq6BcuPrFvKcplZH2vDzbXf5mnQ/W
         lmIj3r4PTTz9QrsFQRs/PFK14lmVUgmsI7j6+om6YGqF8RtiKFOYf7OfKq9WjC9/aaHx
         nNMZI7XVdyGmyEgSXElgskpOwBfP9+tw1cTx2wD0HM6CSkPJwFsRfuWv2R6uJQzWaYof
         nNjm82cbINTqgLcfIVZpQflBhHTv65uMduehwvzCPa8dNUAWHL41elCby0onWr+udV75
         /eA7ptYGVb7eWO8GAltjDdyJLd+joaCzjvYYTlHigmfbbZDWVjR+PhZrDX5uyOm8B2Ok
         dHhA==
X-Forwarded-Encrypted: i=1; AJvYcCUTXeQp5r1yslMAegoHG/HevkC1hM2ZIHiNqE1Q1EFH91zthLIwz1Dmiyi57zhTHuBOyh6sI4Jvtc2qybfj@vger.kernel.org, AJvYcCVwpEG8J5viT930zGGplaKJm1lw4pKy55Z/e4lxrgUiCmCNGuwqwcIbILwLQtDzhviVURZ7KiYVwmQ=@vger.kernel.org, AJvYcCWQl/N2saa3PA5jXW4+AA6LmaF8sVzfQifmV7QZFednZTwSta5a5ljEJqaGbzefS8Efm4zvnUDwL9OTI0mDuw==@vger.kernel.org, AJvYcCWuhYHBwUGGbg53cciUcqstgmkS9tD/oKIvmp/3JyUxVEeMYmx/DEOo9RUHiWl0Jd7eSq/DmA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy68SwHb79X0wYNsSrzVG+vu8qI/9+Cyb9uQf2851gv0P0WOjK
	nK46PSF2aegiN+e0oURm58IZ/zw7JYMNH6Oe9fJHFA/NDCjwto5LWVWY224UCU9NGgSzl34stkt
	9bF9bDWyD7hSGtZMdw52MKy0ZRGo=
X-Gm-Gg: ASbGnctq0hYWK2Ka/rK0KrXuhfT94iUB9pW80R7T3qHJxbahjx+GfL3AKlF/zyD4V/C
	eW8B6uOTwfaj7nE/Tkl41THEQfORlMLRrmc/pQsvmlby7l7m2Snl+w/APBIuit0/WncVz6JqKRP
	RzhURWWF42n8dKkdoz6pHHQQASuQ==
X-Google-Smtp-Source: AGHT+IHopYBJx1mgx5LeTQc4m4LZnSKPLCKXMYn0njA5opMfDTmm8qs1SyU+pxRhHh07QewdZn5f2BsnGaQ6vCQYGE8=
X-Received: by 2002:a17:907:c913:b0:abf:23a7:fc6 with SMTP id
 a640c23a62f3a-ac26cab9079mr23579566b.16.1741365913939; Fri, 07 Mar 2025
 08:45:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161155.760949-1-mjguzik@gmail.com> <20250307164216.GI2023217@ZenIV>
In-Reply-To: <20250307164216.GI2023217@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Mar 2025 17:44:57 +0100
X-Gm-Features: AQ5f1Jpo1dIuW1b7ry84nc2tM9AJQequs9mTW__QY0p-auFq_EfDunHxvmPQwlo
Message-ID: <CAGudoHGwaoCMnpFyF3Zxm4BxLqyYD8TiRtpdTyfjJspVa=Re9A@mail.gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: brauner@kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	audit@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:42=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
>
> On Fri, Mar 07, 2025 at 05:11:55PM +0100, Mateusz Guzik wrote:
> > Atomics are only needed for a combination of io_uring and audit.
> >
> > Regular file access (even with audit) gets around fine without them.
> >
> > With this patch 'struct filename' starts with being refcounted using
> > regular ops.
> >
> > In order to avoid API explosion in the getname*() family, a dedicated
> > routine is added to switch the obj to use atomics.
> >
> > This leaves the room for merely issuing getname(), not issuing the
> > switch and still trying to manipulate the refcount from another thread.
> >
> > Catching such cases is facilitated by CONFIG_DEBUG_VFS-dependent
> > tracking of who created the given filename object and having refname()
> > and putname() detect if another thread is trying to modify them.
>
> Not a good way to handle that, IMO.
>
> Atomics do hurt there, but they are only plastering over the real
> problem - names formed in one thread, inserted into audit context
> there and operation involving them happening in a different thread.
>
> Refcounting avoids an instant memory corruption, but the real PITA
> is in audit users of that stuff.
>
> IMO we should *NOT* grab an audit names slot at getname() time -
> that ought to be done explicitly at later points.
>
> The obstacle is that currently there still are several retry loop
> with getname() done in it; I've most of that dealt with, need to
> finish that series.
>
> And yes, refcount becomes non-atomic as the result.

Well yes, it was audit which caused the appearance of atomics in the
first place. I was looking for an easy way out.

If you have something which gets rid of the underlying problem and it
is going to land in the foreseeable future, I wont be defending this
approach.

--=20
Mateusz Guzik <mjguzik gmail.com>

