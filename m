Return-Path: <io-uring+bounces-10674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 615D9C71B9C
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 02:51:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE35534F768
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 01:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949331D416C;
	Thu, 20 Nov 2025 01:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6XbgyMt";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="s4h6KpwI"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D753516EB42
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 01:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763603498; cv=none; b=rikrBslm67M9WWBk3+jc0HkvNrpXRZEXA2S5pWheH6jUQQ9Vk/p3xk1UpLGmj1dFdU5Nvn6cunXU4hqBDW55h4f8NKVfl0fdLSIdp0yXCRQK95UAR1cTSR0JraNdfT8TmCS67PdpEOMuT5azhgOUR0Lh3OaTjtdOc8aev6yPUSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763603498; c=relaxed/simple;
	bh=IzPJoad719/5qJDev1vzr1zoqezBRTRtv4dRctcZ+7Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TGXJxlrP5W43AzlL7eLibMR6VVXcRKXyJuGQULKH10QS7jZAgVzp5V1DV3p2CumDNdzcyzFHpM+C21IaiGzsLR8EKy2oDSO2waGpOFnfRIAc6SdGmKyFfKtGXtxADh0OjA18sNcn9kXhP9xCZVXVbAp95/14Q0tOBpQhfvj3b4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6XbgyMt; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=s4h6KpwI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763603495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2FviHimsytcciadszbcSsJW/Z97xTnwLdF5ls/H7GOk=;
	b=J6XbgyMtEPIetefzY9mz8+GlDj5cGZDS0yXpCNPtvdaxTVfBs5JCQ74vlDfXVH3pEXkEin
	23NN+6Oj3NyEA9gUEyvSrGmMrEblDN5zBV9t9J4xKxCacPfSSKMyjjlDCn3Glz1naY0Uw6
	lVXlh/wbKZBKBkontX9GnXlNsCnse6A=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-p0Jn5P31OoiJHsbkhXRVTg-1; Wed, 19 Nov 2025 20:51:34 -0500
X-MC-Unique: p0Jn5P31OoiJHsbkhXRVTg-1
X-Mimecast-MFC-AGG-ID: p0Jn5P31OoiJHsbkhXRVTg_1763603494
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-559eda577e9so226765e0c.3
        for <io-uring@vger.kernel.org>; Wed, 19 Nov 2025 17:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763603494; x=1764208294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FviHimsytcciadszbcSsJW/Z97xTnwLdF5ls/H7GOk=;
        b=s4h6KpwI6EUJLc7qNIN3jrDTqS8ahAf36dAkWceib6NcJ+493u727Kqwth0WCywfdk
         NBN3+mCZm3ed8Fnnbp+6/i26ajTzd1M/+x7ck1exlomoOhKzzlnLv380JQz8gi9xON4y
         NIIf/0ecCJ6ZLbGg4yrcoqKiMRNSJS37KBxt79Dk837fnuZjUXMn5e7XSrrcrWsAuFFp
         OfdMKMNaXWxw1fPImk/2zuSi49SDpuYtgUcXWquc1Eq+a+knVuCwiEq/jAGRdnU5OFtR
         jHPy5JBkioNE5AZGyMKhhdJ7Eme3WOpfPPipFzwe2u1jy3k2+CtCo1bzisTeIJDs3C7I
         ctuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763603494; x=1764208294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2FviHimsytcciadszbcSsJW/Z97xTnwLdF5ls/H7GOk=;
        b=u4kqUPchCfuA0j+Ah1h1yEqgDCLUW0MIJQr7ishbLUsEQ/KKh9PzrdbWnHjzVWTM54
         4TbrLLTB4+cRrbvj47f1qtMMSJaGgkJDdCAgEkK2J6//4jh8UHKrl37zEjCn7RXwe+Ey
         D01ToLl4NyJq8SrX9FQ741ohSXGOWdkU17vp61TOxEQd6akk0PBUI+86Uafs+cPBlFvx
         gbpFzwXgqrmkZ5hwzrxPZ/b6PsXskYVk6bQtHnUwP0fb4BG2gYEbYcT6a97h3hiKJtvB
         yeXTWom5aUi2aOdSX+DCZsZX3r9vd2YjOAWv2hJphFfTPiV3NKebKiaKT0uJc+XZ9pGC
         USCg==
X-Forwarded-Encrypted: i=1; AJvYcCXR8xwMK+cawD5YpYVPVNOrqEk+TWhrfg/LR6lbhWXGqDYx11vI89GCIi2iwWWfQWxsl7U2Xb5iDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YynSfT6X5eYp/afrGsor+LSmvPn3fW7myN35jlEok9zwX1A+tVf
	P00zzNRFxSoG/0oAyhcYrwtDK28+J9jUpB4czIuQJYj9Er7IG8j8yKbym5XWlLwFpEYK+qNbIaU
	7qcuWda9M4jYPCebHG4Ew2zRkkww2TaX5E1751mfv+G+6/W5dr6LdIVgDbJuRpvlD7AW2un1HAZ
	vTMDU8a2W/1VsOSMBwQGFLDEabH/ZABrwx/IM=
X-Gm-Gg: ASbGncuvZwqghpV/wAtbRkNvWwnZ6xmlJ5h6QWdcPcRo6U05SSg+nPP40Q+IjIZqAvE
	YLdHr1KS2E21BVREzPAz168z7rGLUgtk4pBhwlYGlHka9LCCRbXdO+pJmiSuuAxcuoqtEfx9NCD
	LPUeYuT2DwzW0JIoOJrbdsEAf6rh0/PNdN2xfDneIFF8+o1vy5ehoID6zy4QQSRgCT2SA=
X-Received: by 2002:a05:6122:2090:b0:556:92b0:510a with SMTP id 71dfb90a1353d-55b834a98cfmr36141e0c.14.1763603493908;
        Wed, 19 Nov 2025 17:51:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFE2k5CaBlCaOUDyFAZL59khcKOSke7MmanpokA3dJd0nOQPh9lnMYPOnSQ4XTsf7JkGbSpx8Urw+Sa3WXusGc=
X-Received: by 2002:a05:6122:2090:b0:556:92b0:510a with SMTP id
 71dfb90a1353d-55b834a98cfmr36134e0c.14.1763603493558; Wed, 19 Nov 2025
 17:51:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104162123.1086035-1-ming.lei@redhat.com> <20251104162123.1086035-4-ming.lei@redhat.com>
 <87346a2ijz.fsf@trenco.lwn.net> <aR5y3pFTgDDNptdx@fedora>
In-Reply-To: <aR5y3pFTgDDNptdx@fedora>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 20 Nov 2025 09:51:22 +0800
X-Gm-Features: AWmQ_bmBoqDRBcHD4m4x0NJV-o73KA2BYbG3mwP-S1h8owflFyDJZWCqNqjEZ7A
Message-ID: <CAFj5m9KiPcKKjYTY3Jov_T=tWrknivoPiaao_wW25=ZjJ6XGrQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] io_uring: bpf: extend io_uring with bpf struct_ops
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Caleb Sander Mateos <csander@purestorage.com>, Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 9:46=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Wed, Nov 19, 2025 at 07:39:12AM -0700, Jonathan Corbet wrote:
> > Ming Lei <ming.lei@redhat.com> writes:
> >
> > > io_uring can be extended with bpf struct_ops in the following ways:
> >
> > So I have a probably dumb question I ran into as I tried to figure this
> > stuff out.  You define this maximum here...
> >
> > > +#define MAX_BPF_OPS_COUNT  (1 << IORING_BPF_OP_BITS)
> >
> > ...which sizes the bpf_ops array:
> >
> > > +static struct uring_bpf_ops bpf_ops[MAX_BPF_OPS_COUNT];
> >
> > Later, you do registration here:
> >
> > > +static int io_bpf_reg_unreg(struct uring_bpf_ops *ops, bool reg)
> > > +{
> > > +   struct io_ring_ctx *ctx;
> > > +   int ret =3D 0;
> > > +
> > > +   guard(mutex)(&uring_bpf_ctx_lock);
> > > +   list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> > > +           mutex_lock(&ctx->uring_lock);
> > > +
> > > +   if (reg) {
> > > +           if (bpf_ops[ops->id].issue_fn)
> > > +                   ret =3D -EBUSY;
> > > +           else
> > > +                   bpf_ops[ops->id] =3D *ops;
> > > +   } else {
> > > +           bpf_ops[ops->id] =3D (struct uring_bpf_ops) {0};
> > > +   }
> > > +
> > > +   synchronize_srcu(&uring_bpf_srcu);
> > > +
> > > +   list_for_each_entry(ctx, &uring_bpf_ctx_list, bpf_node)
> > > +           mutex_unlock(&ctx->uring_lock);
> > > +
> > > +   return ret;
> > > +}
> >
> > Nowhere do I find a test ensuring that ops->id is within range;
> > MAX_BPF_OPS_COUNT never appears in a test.  What am I missing?
>
> bits of `ops->id` is limited by IORING_BPF_OP_BITS and it is stored in to=
p
> 8bits of ->bpf_flags, so ops->id is within the range naturally.

oops, misunderstand your point.

Yes, ios->id needs to be checked in io_bpf_reg_unreg(), sorry for the noise=
.

Thanks,


