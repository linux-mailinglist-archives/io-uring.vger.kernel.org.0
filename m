Return-Path: <io-uring+bounces-11547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAAAD06987
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 01:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A0C33025F9C
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 00:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329422E40B;
	Fri,  9 Jan 2026 00:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoWE8l+F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACEA2745E
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 00:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767917458; cv=none; b=i67kb90N74jr+FBTDPsnL7mqKnwECcWm0r8hBpbfjhd28hljp32z8jeGjlAg0lJGpaJPyeeqC0gCLHe099kQFXbBn4ufWb0XfY58jS2Zw/h4j2tTDn5V2EtRrfdlP3AujoADDXlHxPlCVTDmEOe3+R7Lnw6Vn86vVWi6TZGMNsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767917458; c=relaxed/simple;
	bh=9aJSC2x1m+868DWnJu2WZWbYy0I8FxNRBYN9IH6lmuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CO1nnVUcIu8j3EJf05NbwNls6k9x5ooVJAbjDTHF9IAZICaX4Qg2kdMo7P0KSspCfsaB66LOltmJy0zfpAL2ZM8w0ot8UH5Cww6dI+40YUK+o8TIdzKANIBO7si6mij2uR639IwoPTC4sjBIbQlXaodqC27dhqkipkw6zAWTjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoWE8l+F; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ffa95fc5f1so36200591cf.3
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 16:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767917454; x=1768522254; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hdkIlQ92g3yoewQ/1YLASbjQN70IOWFt/r8ioUdXHQA=;
        b=FoWE8l+F20wbKrcuN4tScKgwtH5MHG9Mw6qSXJYrM8fVYwHvzoUga31I/nxcWTm2JY
         z2Smw3FVvYg4iFmXir0edS/l1Iai3J8cOW8cf3wl5zkuEMPn1eJKK3WYNaQZ4xlsfV/B
         6TMaOVi4Jl5e5L6u2SeQANWDtSmD/2cAi5wdxB+SWPgxNqAiI4MpXmoQHJGgibTpPeGc
         4rDxtQ91luc8YHWwUxJTZWMKEZUe/X/dwWAnNxNB1+hMCV1CeeYzwuPdD/PI/NCAq4lo
         gQv6Wx8NrO6V1+kBctMWsyUy6bW3dzttc+J+mO4Z4/NgEuY4v25dGuv1s2zX2sYiPQZ0
         S9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767917454; x=1768522254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hdkIlQ92g3yoewQ/1YLASbjQN70IOWFt/r8ioUdXHQA=;
        b=nY3QJ2C0FRP/TaeSLjIpA0RkAJlEs9OyY08/c4UeB+Cj5e2hAy/sXGL5+OavuSoFPr
         lVg0wD7gbq1U7qfuUsN7gBaPmWh+svEiG40AHmLrhTOIO+/vAFDDFWMyievJIkQE1HSN
         0GOoawGyCMcjCQFlFlZPdfgvlE/vCOMoPgLhXfsj9ztB/MhNPYmbr6l7SHzZlSoctwv8
         U44LtzASvPtdQnwyno8i44mZi+mD1EoX3n/nc8eX/laKctVZ+NsJke49jjBRhFW3amfJ
         e6TwSi1udt67WUmKJTHr7pyQCRjsxiBbUDD6czyizNZKQWaBi4FNE8x6iCD5ecyCb0PN
         UIcw==
X-Forwarded-Encrypted: i=1; AJvYcCUylqKafGwlZG73HBW+haVOPksGOOYFjEMS5DR1/sAeQvmMWpileVkosk4lQZmWukmgMVKXJsqJ2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZwWPoLWSCmwYWtcIKIRem7bgwUqU/rmWenqT6EVzdYBF4XldM
	hmS9dUqRpsrSU4smJgTzCENtYW6KdL8NsyDZ2gDjO8/LOC48brOrMRE7PD85357tfL/7gmb02Gx
	UWBCv0Cnc1UEycAH8T9haq4c4L0ccJrw=
X-Gm-Gg: AY/fxX7NZpyIRDKJtmm/krmAobBJ78uNdS6vZJueurv3ShXIIF8jyU+DTyrpj5X2g/H
	iBJCqqCkWuwh3+LJxjiIcwgzImlyMzymVDUiGHutUJ3shLBU4yF4iWlIuFsPC6d+IX4tHi7G+tA
	7/vOFteyHvU7Shd0Mu2LAsDHMvokESWQpYg3Ba+xQR+0F3fvDi0c1deinajrmMvpmyf153ilLea
	/U708yel/jukMhvKdneQq3DXcKAekZiXi91m6I67Qr3WqndrLW9iXXFV1chzjwLDkJFdA==
X-Google-Smtp-Source: AGHT+IGRpNs2BVM2M3mmA6EJFK/F8gQRBPsbNdnT/JjPHAB18Z5c8PXXflr5K2EcfLWfgkhn+kSsbucB1ooWTiJbN4E=
X-Received: by 2002:ac8:5990:0:b0:4ee:219e:e74 with SMTP id
 d75a77b69052e-4ffb4a64015mr100743181cf.77.1767917454239; Thu, 08 Jan 2026
 16:10:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-24-joannelkoong@gmail.com> <CADUfDZoph-=on3E3sis0eLy_Fm7kUGShRUc89-0V1OjMHNLLAQ@mail.gmail.com>
In-Reply-To: <CADUfDZoph-=on3E3sis0eLy_Fm7kUGShRUc89-0V1OjMHNLLAQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 16:10:43 -0800
X-Gm-Features: AQt7F2owGGc8SFUyf0A9PJnA-aVLIQfN01k8fWSFvCybzy0fMobi8XIvVBrTnDs
Message-ID: <CAJnrk1a-rHrCEXyxSRrZDJgSavK-qyb0aMXJ1XfdZUhfMswwtA@mail.gmail.com>
Subject: Re: [PATCH v3 23/25] io_uring/rsrc: add io_buffer_register_bvec()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 1:09=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 22, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Add io_buffer_register_bvec() for registering a bvec array.
> >
> > This is a preparatory patch for fuse-over-io-uring zero-copy.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 12 ++++++++++++
> >  io_uring/rsrc.c              | 27 +++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index 06e4cfadb344..f5094eb1206a 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -106,6 +106,9 @@ int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd =
*ioucmd,
> >  int io_buffer_register_request(struct io_uring_cmd *cmd, struct reques=
t *rq,
> >                                void (*release)(void *), unsigned int in=
dex,
> >                                unsigned int issue_flags);
> > +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct bio_vec *=
bvs,
>
> Could take const struct bio_vec *? Might also be helpful to document
> that this internally makes a copy of the bio_vec array, so the memory
> bvs points to can be deallocated as soon as io_buffer_register_bvec()
> returns.

I'll add the "const" and your suggested documentation for v4.
>
> > +                           unsigned int nr_bvecs, unsigned int total_b=
ytes,
> > +                           u8 dir, unsigned int index, unsigned int is=
sue_flags);
> >  int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
> >                          unsigned int issue_flags);
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 5a708cecba4a..32126c06f4c9 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1020,6 +1020,33 @@ int io_buffer_register_request(struct io_uring_c=
md *cmd, struct request *rq,
> >  }
> >  EXPORT_SYMBOL_GPL(io_buffer_register_request);
> >
> > +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct bio_vec *=
bvs,
> > +                           unsigned int nr_bvecs, unsigned int total_b=
ytes,
> > +                           u8 dir, unsigned int index,
> > +                           unsigned int issue_flags)
> > +{
> > +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > +       struct io_mapped_ubuf *imu;
> > +       struct bio_vec *bvec;
> > +       int i;
>
> unsigned?

Will do for v4.

Thanks,
Joanne
>
> Other than that,
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

