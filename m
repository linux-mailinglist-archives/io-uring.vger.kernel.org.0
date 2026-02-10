Return-Path: <io-uring+bounces-12142-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCVnIYZxi2mgUQAAu9opvQ
	(envelope-from <io-uring+bounces-12142-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 18:57:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC50B11E2BF
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 18:57:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C32133012BEB
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 17:57:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CF5322B9F;
	Tue, 10 Feb 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="aSsdi1p0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2454031ED8B
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770746242; cv=pass; b=laJMwAt/kxD+rDxB4aEH3RWa2ZSSxqx1QbMZSx8LFMjtX0lT6tw/yhcnWf9Wzy1kgh/WHsANF9dp2yJIQ7Qxmw3AHQHie76P7GVV4rv28CytM7WlK5lr20nhv5+vc9NLpApm1GUcvpmqYr7xN63i8LNoIf6rOsjqUzZhoIwZ6Fs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770746242; c=relaxed/simple;
	bh=GWrFpYjIUc/xj7N0wd3tBFD8akKoS2HrmAT5yE7jq5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P2NFVxO16qfFwaXxqy3taMvzd2ZVh75r6PHE7lHvcuYLDvLbhUeSrobKFRuaVT5iR/LuTi0CBWkE9uCV5KLfDjcYYyqtwWCjpfDaZXXsbZRGa/eBInV5V1seBquMlfSGFomziklX5vnZm/7I1EAMNynG/JpsPG07le/ecSl2Ef0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=aSsdi1p0; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64b6f22bc77so876436a12.1
        for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 09:57:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770746239; cv=none;
        d=google.com; s=arc-20240605;
        b=lnhUUtohm7x3X4U4nadK04panJ6/6sBgMQyMcyLa+UGUuP3JYqS2qIBy3UXcYcwZJK
         fmhIn5bVEGP2ZtaK4sbZX2hfFw++Y5L/R8Vrm1MmjFtWjezNjWxrukPI1nsh387PwZYC
         Tr+Z7kF9mjqYB59yX/E27LHK7QLYNFPyQzoesay8mzPQRVLzRyxtSCCaQ3lFgVrbE4mZ
         433se9sY0PnNuOk3sKPDFaLJ1c35UzNJISVFr750UZfvzN0C7upD4vtH2ltqftUe5bT0
         5jRC4HalJfc5DyaW/Z/fbW4iLxDgHaGwAzbfBeH92Dqn4c0i9144UZlxyqqbNWsdE5zr
         uNMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+nXNw/knapKCOCvKXk/sxttCrc1XoB9SJeujCBS22Zg=;
        fh=YXSnVCLrBg6pvLBJ9wuVOtvWk63i/h/8C+R68D4OUlg=;
        b=MCpT+iYJQlFv78MHGBvMA/96NCr/nHTAOrKjCvKY/QcM6hiE4PrQuF070mMwP0e+hG
         C43GJ9vzpLLrGMuzaAbGx+OOBiTwH0Qz075eIdKBwnTm7WN7CAE3T2/J7yc0C0U3aOHf
         AdIPeoqBALQuCLA4TSf8rTBQTjie2OX/pcD4bRs/o4yPiswGqGcL56+bmPu88p86sQK7
         o/cZDvahniQ0qVR0jDu9/iN4Q7O7UHCXsuHdO+pIEJAeOgowdcnJnN/j50q89c01hakb
         S/RvBu6IhzpuE7HBwIcxOVKbprDV0leIuDfTx9WBmABR5a9IJihahBFKE02rkDOJ/I//
         l3Fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1770746239; x=1771351039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nXNw/knapKCOCvKXk/sxttCrc1XoB9SJeujCBS22Zg=;
        b=aSsdi1p0Ha2F5eENwkNpXC1eH41Ep3s0s30PUKiUr6QXPHWz8au9yrYCcVMWrt62Mj
         xc28knHOt9wvQY8YVEerWln4eqJTp0/YN5ATaEQvUKlKTBY+fEcue+HAqbWWO3Xh9iVI
         mIEjXGMGcSe/F8Q/YuWY+rr28Fx4OKYmk/1zTtbqtPYDeO+twl/nge5eAqxEAezPXx7Q
         +N7v0H3cESmIQ/RDiWeSuUls2uvklQIpUZHBPtmlPir1Z2KLB6PNT7vFHMSZWZz5OoT2
         6YR9fO0+gVfvtXpuJuQC/4URLZ61eDH1bSctV2c9QiK9pN+PQAVI9N3z4ggCkKFesDas
         vyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770746239; x=1771351039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+nXNw/knapKCOCvKXk/sxttCrc1XoB9SJeujCBS22Zg=;
        b=V56yR+dfD82UjAAN5p8P/V9O+j2w9BD+Mdt08VRAiwK7SnbiusnjnTvjJxY7Prl7Bh
         Fdi6JAVvohaWtK2IGAjOgfkWPRl4Hbh8Gi+fE+LHFJft7U+TRQ2zQA7zYsCWAzh0kdpE
         HVWGzInz7WA/dLH6vafT0LVJ8JOAw0AoPPSbHJRP/JIr1gRl4OqN4n78BGotDB13RUr7
         EqgMRkyy7qw6TvdKqHtFbxnbX0zkvLXfiAo7bPSMvQPkFcbYravIiaNT1NtftFworiSk
         ctcz7neVsRFR5lK2f9s10/Rl8+FxFyZh7/7v+pJrLwJMOw4ElRgRoCROfjOchz8uSztE
         5pOA==
X-Forwarded-Encrypted: i=1; AJvYcCXn1hJUgFLBn3dL5ZQjxm4bQxwJ0NFxTD5OaNwia02WYczuWoACAFeNmETVf7XCdxBgbuXf8FqHvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0T3jd3bi43zx0WXTGS8apvT0ZEPpWXBQWllr8M3NSsuytbf9z
	PlL1I5NMN/jfHMUHAhCgLbz5Tgt47ciwMBQPvCWGSA/fWjctnOAhDwHHD+nJ8S1sLdklaYNqstA
	1/1on9Hj4KMK8V0o6H4I/8jL3wzOBMkCGGkr7pKNSuA==
X-Gm-Gg: AZuq6aKHG95k5sH3gyJJJ99qoEHbiEDOf9ittMPzqrgW+41u4DDGnTW1cXae7qz1Ecx
	gWANdUMcT5eP8DCCoYoWIG7FfL5pZfFsFwhG0i9Q2GYDI6vu9Kx5SiKF5T6uW8cNl5pwdbvsq7r
	Lcl7V7niBRAAQyPSSW2LcWapag/vmx8yBo/JyKLpLk5ZIXlS6sqlpuHCvAx5yMxkoD50lqYhM9s
	soyJZ/08KmIWuGOv7Z15KftEbIPMx9CQDTu8SOglJPScicPCpYjZgFXQRbTxUvk8C8Sx+IMR6+s
	HOnsFlDc
X-Received: by 2002:a05:6402:1465:b0:658:1392:84a9 with SMTP id
 4fb4d7f45d1cf-65a0f3987c8mr885820a12.5.1770746239535; Tue, 10 Feb 2026
 09:57:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-7-joannelkoong@gmail.com> <8826110e-cb5c-4923-99cd-b9f21f536d32@kernel.dk>
In-Reply-To: <8826110e-cb5c-4923-99cd-b9f21f536d32@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 10 Feb 2026 09:57:08 -0800
X-Gm-Features: AZwV_QgslXwEFKldAeimaqaA_t6syzgt7pXhnv3lDqCXqFqd0HdgXnYkW1EMbvI
Message-ID: <CADUfDZoiHYKrfb=NxLH=K99ALuDoABCnrOFC4_mZgqvT6qQPXw@mail.gmail.com>
Subject: Re: [PATCH v1 06/11] io_uring/kbuf: add buffer ring pinning/unpinning
To: Jens Axboe <axboe@kernel.dk>
Cc: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org, krisman@suse.de, 
	bernd@bsbernd.com, hch@infradead.org, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12142-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,suse.de,bsbernd.com,infradead.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Queue-Id: CC50B11E2BF
X-Rspamd-Action: no action

On Mon, Feb 9, 2026 at 5:07=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/9/26 5:28 PM, Joanne Koong wrote:
> > +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group=
,
> > +                       unsigned issue_flags, struct io_buffer_list **b=
l)
> > +{
> > +     struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > +     struct io_buffer_list *buffer_list;
> > +     int ret =3D -EINVAL;
>
> Probably use the usual struct io_buffer_list *bl here and either use an
> ERR_PTR return, or rename the passed on **bl to **blret or something.
>
> > +int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_gro=
up,
> > +                    unsigned issue_flags)
> > +{
> > +     struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > +     struct io_buffer_list *bl;
> > +     int ret =3D -EINVAL;
> > +
> > +     io_ring_submit_lock(ctx, issue_flags);
> > +
> > +     bl =3D io_buffer_get_list(ctx, buf_group);
> > +     if (bl && (bl->flags & IOBL_BUF_RING) && (bl->flags & IOBL_PINNED=
)) {
>
> Usually done as:
>
>         if ((bl->flags & (IOBL_BUF_RING|IOBL_PINNED)) =3D=3D (IOBL_BUF_RI=
NG|IOBL_PINNED))

FWIW, modern compilers will perform this optimization automatically.
They'll even optimize it further to !(~bl->flags &
(IOBL_BUF_RING|IOBL_PINNED)): https://godbolt.org/z/xGoP4TfhP

Best,
Caleb

>
> and maybe then just have an earlier
>
>         if (!bl)
>                 goto err;
>
> > +             bl->flags &=3D ~IOBL_PINNED;
> > +             ret =3D 0;
> > +     }
> err:
> > +     io_ring_submit_unlock(ctx, issue_flags);
> > +     return ret;
> > +}
>
> to avoid making it way too long. For io_uring, it's fine to exceed 80
> chars where it makes sense.
>
> --
> Jens Axboe

