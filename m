Return-Path: <io-uring+bounces-10514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC07C49E52
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 01:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B11674E88CA
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 00:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882491C6FE1;
	Tue, 11 Nov 2025 00:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="fy5mz9Ob"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B76E288D2
	for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 00:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762821937; cv=none; b=LFPXR/PM9vqRo7ahA0lnJ/DEA71W3HSMj3HUEWB2XTiH+5fbtct5eqGyuaHbKGlk07xvWd1ce2MiDW0CUPeL6jO+5+CliMuCX9D48E+cMKsAHKJilOuIyiaXnJLFhpv9FjVIFAWHVGoo2eQylvyGcd4nCSCGMPNqMqtLVP19FJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762821937; c=relaxed/simple;
	bh=fcNq+EFGs2dqeN9lFY8Vp0zqR4Dg/1JtF/IfkAKf1FQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pQbzVp0qTGfMwlZVa27Obbob4w21LpMQpDGdB8PLRA/ktnIr11lePxI2Vt7/rozhOTnfod4GcBRw+5kmTMAcHW4txwF76Zx9gBiwwyrg4vRAzUTdBHQ0CH1z4qDGOKvmowfwruGG/j5OZLKUw3RVKIvkdvSDBdNTgHKJ7NF7vPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=fy5mz9Ob; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so2642208b3a.1
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 16:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1762821934; x=1763426734; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFcDFpDYqeidNRVe7BX6WWpapdX8938kAv/0VmMA05g=;
        b=fy5mz9Ob4mMIgTcxzpT1vyWmlFOAnI8YfrusVO0wS7KC1S9pavQr495xL3zGe/irQt
         YpnCN+eASAVm8h7Aj/5OW3vcvtqwbYD6CLu+0uaPthyydzDrI1mm7syuY7xcqbGR7noq
         OWH7UVc1A04dCQsdwGVQAq4Ho8isNRli7UmU0aQy8Op2XSUcWjgRHnhpTe92frRO3b4E
         f7gvzix4Y9rptpzi345CO7zuEFEpxRyP24dbLcg9gLOOQUrVem3Fjdby5NrviRR5Onwp
         KdGbuUjjiZmsg16y2btPuUci+097L1dt8seiSy9ol2xJowowTfUPtJDWRvSb7Fpj0ifE
         PrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762821934; x=1763426734;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FFcDFpDYqeidNRVe7BX6WWpapdX8938kAv/0VmMA05g=;
        b=m5hi+PBmAxzMyLOGWsY0QN8LXikTMvyCEdN3XHtX9tAsO1zUg45b8o9PXvj9CDjQw6
         KsJBqF4tYvDVMxYQFNE0HADmGDvRv26ubm02Xgj8iKERi5LOcQwGSEnPzevhpPhpfQ99
         1eMm6u6vbL2T/ndt5NNr5+T57i64w4kvhmZOc30OorT1GQPnebZrVtaDhwXDPxPXKftQ
         r9h/hkptl23mz15nwyuODOJw1D00C3fgpew6cHTk7Vl8tu9DRPNsUg+r3vszGAke5uFB
         Dr/FgYUTQ2HKLkyYmTgRxe9g2Hd+J9oS01uxvM5pp9STQ2k1MDA9daoqByUpU9tvN/sB
         7ebQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJxRsKbdUSJo3p1Iv0YQXEI0TrQmh3ZmvBnacU2BbMyDF5b+xosE+MtphCIaKsWdog/NBeDueN1w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy72f6jifI0/iyN7HkIdTCsFMP7rjSEFPtFCYSTDMyqFPZvy/tB
	NyOg+rplS+zzauvEbAKwcrngdKgpt7GEj8f6JacnMw/ncr9v58K7zTguqx3YyXFaBAYqBmtWNYO
	Yc/Q3KAJBqjiZhlR8oiDVST+QrCXpyNz4dH4WXLiq
X-Gm-Gg: ASbGncv8YUmqWDSOabOKRFIadhH2wcmXDLkQGEye8N7PL0/eGWgVQjKQJnGbJLcQkUE
	uLNm+rYdYVMmq/9wlnHmcdtUqo7oK7dcrKf4FGTFjeIcobM7yWf9Q4x58oZoK+t8qUL3q+cmFCH
	ZUbmsXZkiIHiKd3vjxWsL0ILdAw8cNZOdXWkDgiKwpyEtwEhO8Ng69mcggQagTOPz4UBJC/v9Qn
	3DB0DYba4he88WkIZ7MxsnCewpaEKawp/1Ii+SoNlMjhtW8SRwwWtd/igAh
X-Google-Smtp-Source: AGHT+IGgVRvS/WxslDT+nRoM/RAtG1+YqCt4yCXBON8bAr46CAyLSwspCMdgp3zlNVnrVFtn4e+3m62gMqJ6MOnE8KQ=
X-Received: by 2002:a17:90b:384e:b0:340:a961:80c5 with SMTP id
 98e67ed59e1d1-3436ccffbfdmr12303090a91.32.1762821934348; Mon, 10 Nov 2025
 16:45:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk> <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
In-Reply-To: <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 10 Nov 2025 19:45:22 -0500
X-Gm-Features: AWmQ_bkp5kdBOwtDjJWOMXmskiEXBmyOcu1NzlmFaP64t_IbnVnVP4UzXMmG5SU
Message-ID: <CAHC9VhQroZriXXeG=iYhQJ3_BwdSbn+wsk0hUeBSK3k+V0q=uQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 11/13] allow incomplete imports of filenames
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 1:38=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
>
> There are two filename-related problems in io_uring and its
> interplay with audit.
>
> Filenames are imported when request is submitted and used when
> it is processed.  Unfortunately, the latter may very well
> happen in a different thread.  In that case the reference to
> filename is put into the wrong audit_context - that of submitting
> thread, not the processing one.  Audit logics is called by
> the latter, and it really wants to be able to find the names
> in audit_context current (=3D=3D processing) thread.
>
> Another related problem is the headache with refcounts -
> normally all references to given struct filename are visible
> only to one thread (the one that uses that struct filename).
> io_uring violates that - an extra reference is stashed in
> audit_context of submitter.  It gets dropped when submitter
> returns to userland, which can happen simultaneously with
> processing thread deciding to drop the reference it got.
>
> We paper over that by making refcount atomic, but that means
> pointless headache for everyone.
>
> Solution: the notion of partially imported filenames.  Namely,
> already copied from userland, but *not* exposed to audit yet.
>
> io_uring can create that in submitter thread, and complete the
> import (obtaining the usual reference to struct filename) in
> processing thread.
>
> Object: struct delayed_filename.
>
> Primitives for working with it:
>
> delayed_getname(&delayed_filename, user_string) - copies the name
> from userland, returning 0 and stashing the address of (still incomplete)
> struct filename in delayed_filename on success and returning -E... on
> error.
>
> delayed_getname_uflags(&delayed_filename, user_string, atflags) - similar=
,
> in the same relation to delayed_getname() as getname_uflags() is to getna=
me()
>
> complete_getname(&delayed_getname) - completes the import of filename sta=
shed
> in delayed_getname and returns struct filename to caller, emptying delaye=
d_getname.
>
> dismiss_delayed_getname(&delayed_getname) - destructor; drops whatever
> might be stashed in delayed_getname, emptying it.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/namei.c           |  45 +++++++++++++++++--
>  include/linux/fs.h   |  10 +++++
>  io_uring/fs.c        | 101 +++++++++++++++++++++++--------------------
>  io_uring/openclose.c |  16 +++----
>  io_uring/statx.c     |  17 +++-----
>  io_uring/xattr.c     |  30 +++++--------
>  6 files changed, 129 insertions(+), 90 deletions(-)

I don't have any patches to share for this yet, but as a FYI, I've
started working on some audit patches to deal with this issue in a
more general way; the io_uring approach of splitting processing
between a prep and work stage causes audit problems beyond just
filenames.  My current thought is to setup an audit_context in the
io_uring prep stage for those ops that need auditing, and then carry
around the context in the io_kiocb for later use, swapping it to
current->audit_context when the work is performed.  Still plenty of
hand wavy stuff to sort out, and it's entirely possible that it
doesn't work out, or is too ugly to see posted, but it seemed relevant
to the patch.

Regardless, I think this approach is reasonable; best case it is a
stopgap until we have something more general, worst case it becomes a
more permanent fix.  I can live with either outcome.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

