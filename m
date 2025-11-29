Return-Path: <io-uring+bounces-10856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF3DC945C8
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 18:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 87760347276
	for <lists+io-uring@lfdr.de>; Sat, 29 Nov 2025 17:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462C726738D;
	Sat, 29 Nov 2025 17:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7GWnThM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C520F067
	for <io-uring@vger.kernel.org>; Sat, 29 Nov 2025 17:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764437670; cv=none; b=WOpp+fQ31Rf4DB6SjBB4kFBFg1QSGlnXgrPa8rTERVIF5nCNQX4Ye9E+iZBWaupLxJpBijPqGsNyqW/rg0UIlUReZdORdR9Y5kDG2QI7INldjT0mWjNyIohFG+xSnx/2WZN1sQEfdr6rdGRC8NnEWLOKnznaD9jD5C58T7tj63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764437670; c=relaxed/simple;
	bh=FuHIwQlAP2udp8Fj5L14YtvfrFs0p8IftgEhMCUlArQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ovuaksTfukhitvjwFKBPeEPAe7NTiRCSt5Ck961Nv0IOmMOfJIEv2HbgeHaM1pR+ZkHrYkCUZN+PLC4ojgZmusFFFxxdJksj/nBD/vX41npQFVOF8EMCRHLQlxy4IJhgoc6OBr3mxYEPVv26HYCN8P7MY1uU5GFk7xtXyBdoc80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7GWnThM; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7633027cb2so299952366b.1
        for <io-uring@vger.kernel.org>; Sat, 29 Nov 2025 09:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764437667; x=1765042467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maDmEz6leEp8x7U+/M22lqhF5pJqnpo6KdJXDX8pL/c=;
        b=f7GWnThMerd/210BpPKT/PTJz1Uk07X5X4RB3uqT6Ef+Ni40xKVDXIaVxvUyILd52K
         h/WCWZuGQDWwWq4oJcrQX+6atPBJiu9k4RkqJbYpl4GWyMvqYbEqN6vsTLPo71pGUBRn
         kZDY29UmpGagMC4e1bzyc3RWuFv39znzA/XcKzKnXcpt3aB8rhNQ5r9YszFDqVVi4nDE
         qIgIRiM5W7kY64cZIjeN3GPkZRAXxR8T+2HLsllLiZAOPVsgfitfXFpxpdMTxxvAn8Z7
         ERcVcxmiUQJAh2xLfzibkZHIsZuYIIrCBun44ON1/Fx7e2irVAR3BhVZKwykrRonw6R3
         9XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764437667; x=1765042467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=maDmEz6leEp8x7U+/M22lqhF5pJqnpo6KdJXDX8pL/c=;
        b=suw8sRmzq/fwPuGsIxWHx/Axpbh9OcVwehFupBFY6vKdhnlFr7cDNaJ+bsX+fwK8jv
         vJSTF/P+Pe8ygTRwe6pPda/fNQ4jZitbGU01QhpXkCReRvxdlpyYcOCHbR6YrvKjHq63
         jrxspOpZecY/zMew1jgO0VJ7LTAJBSxkPd7xbMSs617eBfiJAu4642WOlrkp2ToJAuSo
         t92T25gFCZic0eqFKEAPB9guGkX3iYTH6tdLotzJklTIe20TtmvtSTyaFFyTLXZWzjg7
         m2M0BQQttzH0Nn0aKrOC9lFf73GE3yEeH+Uz1k5+Bt7IuMWIH4eSIBkVPttQKgi5n4GT
         PxyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqceRA2/VPirBDG7RasjVZqncDAj4LS9WdI2N6S25q+Ld9ukz/DGtTRhqP45tNhMZpX+atCSz+Ig==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsE6iKiMY9C+WhXZ1GoIbBdmsPG6/ZHk6W3/OPW2fGPjLdtfxF
	JZmDOxMvc70UdcF4zc1Peyunio/oFYC8nZKxBo/ubjDZs6gUCrYgPhLxLj1oyt5xC0TnuPLw0ki
	HpyRAW31xNwp0rEHO7STeQ6QND0bGKL0=
X-Gm-Gg: ASbGncsGqaiY6ZieZBo5rWwKeHhh8k4jS8L08E4G2QKDR6qzbKxAfRDSdkpIV0iTS/i
	qpNg1SaEoBF6sWtUoyph82FxtM9a1jwWAkRZiDqoU3DP2UtaPjO3EqG+fKRJ+82KCwmUDjDnvxY
	z2sSjs871uw6WnxRLizT3brlA7aILuLWIji8vAS1+6x1IV7kQPLFcHgBXC9ItczY4SCgNX7AmgS
	Q1RxX+iUkJE85rcqX9FuvcuRRw9EBlU0QNDQMompAGg5j6yLrNbl8TcvQa79/6CgcNXUg1NqcKt
	gY7H9QgvLEektEaohtZ2x0dvLwDZWfKcA1aj
X-Google-Smtp-Source: AGHT+IEH5c/pRAcr4BaNTwk+9mX9y+JuA5kpYcYrpik7c+/rjbm2lZ4NulyqOyXcGRACGwaRbgIWFZkTSqKxtbn7HYE=
X-Received: by 2002:a17:907:97c7:b0:b73:4e86:88ac with SMTP id
 a640c23a62f3a-b767153ee6amr3765863766b.12.1764437666585; Sat, 29 Nov 2025
 09:34:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk> <20251129170142.150639-18-viro@zeniv.linux.org.uk>
In-Reply-To: <20251129170142.150639-18-viro@zeniv.linux.org.uk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 29 Nov 2025 18:34:14 +0100
X-Gm-Features: AWmQ_bkYhg8ZsPoSvIKVjWFzG0z_YCpKLtzShxZuCW-4-gHoAXRd9J8KuVL5peY
Message-ID: <CAGudoHENCNV87W_wngFsfC99xYohQUiXOjeB24VcYTTOQPv5VQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 17/18] fs: touch up predicts in putname()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

this was already included by Christian, although with both predicts. I
don't know if the other one fell off by accident.

regardless, this patch needs to get dropped

On Sat, Nov 29, 2025 at 6:01=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> From: Mateusz Guzik <mjguzik@gmail.com>
>
> 1. we already expect the refcount is 1.
> 2. path creation predicts name =3D=3D iname
>
> I verified this straightens out the asm, no functional changes.
>
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> Link: https://patch.msgid.link/20251029134952.658450-1-mjguzik@gmail.com
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 37b13339f046..8530d75fb270 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -285,7 +285,7 @@ void putname(struct filename *name)
>                 return;
>
>         refcnt =3D atomic_read(&name->refcnt);
> -       if (refcnt !=3D 1) {
> +       if (unlikely(refcnt !=3D 1)) {
>                 if (WARN_ON_ONCE(!refcnt))
>                         return;
>
> --
> 2.47.3
>

