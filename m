Return-Path: <io-uring+bounces-12446-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLsEBKjvoGmOoAQAu9opvQ
	(envelope-from <io-uring+bounces-12446-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 02:13:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E4A1B16D6
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 02:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C98F30A4552
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 01:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02F626D4DF;
	Fri, 27 Feb 2026 01:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UurKEzms"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4778D29E101
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 01:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772154736; cv=pass; b=WzKatF17KZMmxxzJoE4ksAMcdsddRYt2vKf87PztIkCZzqJ7YMfP4TWfpu3/LQcJboeeQ/lJ6pP+z0faR4l//3iIPUnkomOjb6Ox/l+lm/zO+C2OhovuAuIYsSjB5GF5HNeyXdZnO0wzTjR3lyTmp3lvO0zmG5UeADK7umFUdgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772154736; c=relaxed/simple;
	bh=6CYr7T8MzEUaXZzV6MRHPlZaEtYnuPxqMiOyyADI6dM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RS0i2XBqZRz3KzNYTdkn6J4HAdL2izUyFwwZNIl9O4nkSAzLSsgzDb0DJTxXZu8auL4QPJ6wifPRA57z37LXmg5BEHDq1uNWcFtcy2jV98DYBWq60cOmXmtq2MyTP3+Qa1kAABTpzDA0U9I12THYNh3TDwDF50p/A0LdIhL/J+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UurKEzms; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506aa685d62so9075251cf.0
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 17:12:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772154733; cv=none;
        d=google.com; s=arc-20240605;
        b=EycJU8aMjLc3kaKpxSq/yaC8Wv+arPBvxBNh0SmZtT5YqnSUi7aBpNd421VYwLBEe7
         nujVp6rBr1RfCO5r1yPFcZD1qofaU/KiO9tRfDtPz2LRlZ5qwDnm1OsG98M/dzCiS85X
         VD23AIJEJekDyzKqBdntqoy0ZnLAZXxp9Hhn9tNFG9yF9f/gHtsGiV+rvM2zDbHSkxfj
         p8HO/9Y35TDhbaFzJSB5W1rNfaIYjkM5vgI8FZNNUX8kTlkPAtWQhJ0f2m1XAWLCbVJN
         U0E9Lpcbur6xuN2RiG61mdFu3IOlD8LU6+i46qlU6fLcr+akO5jQeh6Af7/dbWzzhAO+
         s8WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WOstYkB9Q2AgMJRvNGEc6lIdl5QiR5DuIxP/4gEsFp0=;
        fh=j7PK6wgmt/60gCOfkxO/l+gfuRxXGZdaz1ndaakp0qo=;
        b=az1EqgN2OW4c9yx/niIkGM2cLWc9UlmnpEHrVmqC9KhtxHoIEGLypWjpCewwnELteX
         umYzRhx5TtPfPT2uSm8Uiwds6cgJdJQPiSRUWjXvib2xr43VxS97D04N2yvzX1E+AgLR
         ek6BHxUflq+wSZqMvrnvXBgoqGAxght0EsjnuIfeFaLv8tHhs7TVp+pIAHnj1VBzACeh
         sihhMGPi7KIJzoyABeB2wrI/k4KHjl1PYSY1pLs0hLiL/xlgZhVOugHvJ/X59l4lYILu
         ag6zbdhwe1sNLXjMdyXC1B5IZISa8ow/FM310JyWHUPVveNtmbw//O2AC4e2BR5Eww9E
         Vveg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772154733; x=1772759533; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOstYkB9Q2AgMJRvNGEc6lIdl5QiR5DuIxP/4gEsFp0=;
        b=UurKEzmsgJeRXMlucn40YNFFMyP39nvr2Ofa2EIitZzd4boxPsPPLG93zKI1O+rgi/
         yjb/V8uJsOs2b4+gq+tVexyyXdGA82ZFkFfvX1jdbJ8h1C9LTYpbhXqQh6537nemDLoc
         s+uKWMyNSeNVzJBA3/MtE7ZH7EFjC7Wd0+pCYuK4bUHhBp+C7PVcZkVZGXGsAaSX5h1c
         +WobxnYxDIBgl9ytO4ItalZvtvGgP2kk8QIp03JVnrB8Wh45ugfLTr1Hrd/+9K3y4nmM
         L8ghPdFWE1RqwWNviLlXx+vLt3/OXiDZaYbCYqMXzmwu1+cHZpGSHCGDbk/XiuvfYDXY
         Yv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772154733; x=1772759533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOstYkB9Q2AgMJRvNGEc6lIdl5QiR5DuIxP/4gEsFp0=;
        b=RncTxJqwSY3j2C+SO8/8UFGbALpro0R9iIV4i8mGC05Aia+awGGwWFnw9PtaiekeYe
         d3TZ4jpbX06COrxPEKgGLivTejDiaQOkq+XIhXiS9lMgtaCR/3TkdpOsXVL57kbVE24u
         fcsHSFHQAEBaTGXw0nE7pFYFwflN6IfT/CyUXeP2A32wqblYvitwg/SjHjJDha2UPlrX
         Tw8OVd6+CRX1iTF38barRG7+bEMpvjnRMnyTctzYY8Yz6S3HBha8c6Z8O2O9K2CGreyf
         +cWsohRIqqMHlQYtk+W1z+4RKJr+TZ59GYQpHIDtpdOtbvaRfDo1YIrg9gHwLrcIMQOn
         vcgw==
X-Forwarded-Encrypted: i=1; AJvYcCVyyCpVCC0Kl/nq8OzuWIJoh+oNBnGF96abAwll6wmyOmxjBfPv2OcSBBGJmU+G5Vd3kW0Y8MG76Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ4wWCMbNjFBBPET3OftEurGR4D7ElnvOIDThjAB/GeYAplhiV
	8JCvDGPit2xM83lYn16Te0awyEDHuVDeerj1SyVodMcZG/fsFtYF/opF34UUd7bqgcZ/2n0DifV
	m2+R7Y+NBuOEOgvyx43cbmS8/gOp/v+k=
X-Gm-Gg: ATEYQzy3xYODzjASks3PCPYSdsQ41uitcr6hMxtQVfHbEuuaxoWkKOas5zjls8gqUfq
	d4leJBm3u1ERYS/MZ1dLzfjTuR2i6VzmpPrTxWxIOXs5NIEcUfPMEOQrBPKU4Z6U/jZ/Rid+t15
	9CQYii1eVJZRPQikVjnPhJGXkaPuHaF1LAvRJgoMd9T3EG3Qrm7DjZ2+7ugNljqk/9q2HomSaDH
	J+D4jv9TFIGfrM3wXeZmE3QWcaucXrztQnKYl2DoGv+6/Iy5sMuWxUwaOJmNDupgSE4p9YD1Qhr
	ik7oyQ==
X-Received: by 2002:ac8:5a81:0:b0:4ed:6dde:4573 with SMTP id
 d75a77b69052e-507529a8606mr12840511cf.52.1772154733110; Thu, 26 Feb 2026
 17:12:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com> <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com> <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
In-Reply-To: <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Feb 2026 17:12:01 -0800
X-Gm-Features: AaiRm51DUGU78O75qpvj-Q89bRyh_-LRasIvedVgKFuTGIZjmW0a7g5kcb4_4eY
Message-ID: <CAJnrk1YoaHnCmuwQra0XwOxf0aC_PQGby-DT1y_p=YRzotiE-w@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, csander@purestorage.com, 
	krisman@suse.de, bernd@bsbernd.com, hch@infradead.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12446-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 95E4A1B16D6
X-Rspamd-Action: no action

On Wed, Feb 11, 2026 at 2:06=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Wed, Feb 11, 2026 at 4:01=E2=80=AFAM Pavel Begunkov <asml.silence@gmai=
l.com> wrote:
> >
> > On 2/10/26 19:39, Joanne Koong wrote:
> > > On Tue, Feb 10, 2026 at 8:34=E2=80=AFAM Pavel Begunkov <asml.silence@=
gmail.com> wrote:
> > >
> > >>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > >>> index aa9b70b72db4..9bc36451d083 100644
> > >>> --- a/io_uring/kbuf.c
> > >>> +++ b/io_uring/kbuf.c
> > >> ...
> > >>> +static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
> > >>> +                            struct io_buffer_list *bl,
> > >>> +                            struct io_uring_buf_reg *reg)
> > >>> +{
> > >>> +     struct io_uring_buf_ring *ring;
> > >>> +     unsigned long ring_size;
> > >>> +     void *buf_region;
> > >>> +     unsigned int i;
> > >>> +     int ret;
> > >>> +
> > >>> +     /* allocate pages for the ring structure */
> > >>> +     ring_size =3D flex_array_size(ring, bufs, bl->nr_entries);
> > >>> +     ring =3D kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
> > >>> +     if (!ring)
> > >>> +             return -ENOMEM;
> > >>> +
> > >>> +     ret =3D io_create_region_multi_buf(ctx, &bl->region, bl->nr_e=
ntries,
> > >>> +                                      reg->buf_size);
> > >>
> > >> Please use io_create_region(), the new function does nothing new
> > >> and only violates abstractions.
> > >
> > > There's separate checks needed between io_create_region() and
> > > io_create_region_multi_buf() (eg IORING_MEM_REGION_TYPE_USER flag
> >
> > If io_create_region() is too strict, let's discuss that in
> > examples if there are any, but it's likely not a good idea changing
> > that. If it's too lax, filter arguments in the caller. IOW, don't
> > pass IORING_MEM_REGION_TYPE_USER if it's not used.
> >
> > > checking) and different allocation calls (eg
> > > io_region_allocate_pages() vs io_region_allocate_pages_multi_buf()).
> >
> > I saw that and saying that all memmap.c changes can get dropped.
> > You're using it as one big virtually contig kernel memory range then
> > chunked into buffers, and that's pretty much what you're getting with
> > normal io_create_region(). I get that you only need it to be
> > contiguous within a single buffer, but that's not what you're doing,
> > and it'll be only worse than default io_create_region() e.g.
> > effectively disabling any usefulness of io_mem_alloc_compound(),
> > and ultimately you don't need to care.
>
> When I originally implemented it, I had it use
> io_region_allocate_pages() but this fails because it's allocating way
> too much memory at once. For fuse's use case, each buffer is usually
> at least 1 MB if not more. Allocating the memory one buffer a time in
> io_region_allocate_pages_multi_buf() bypasses the allocation errors I
> was seeing. That's the main reason I don't think this can just use
> io_create_region().
>
> >
> > Regions shouldn't know anything about your buffers, how it's
> > subdivided after, etc.
> >

I still think the memory for the buffers should be tied to the ring
itself and allocated physically contiguously per buffer. Per-buffer
contiguity will enable the most efficient DMA path for servers to send
read/write data to local storage or the network. If the buffers for
the bufring have to be allocated as one single memory region, the
io_mem_alloc_compound() call will fail for this large allocation size.
Even if io_mem_alloc_compound() did succeed, this is a waste as the
buffer pool as an entity doesn't need to be physically contiguous,
just the individual buffers themselves. For fuse, the server
configures what buffer pool size it wants to use, depending on what
queue depth and max request size it needs. So for most use cases, at
least for high-performance servers, allocation will have to fall back
to alloc_pages_bulk_node(), which doesn't allocate contiguously. You
mentioned in an earlier comment that this "only violates abstractions"
- which abstractions does this break? The pre-existing behavior
already defaults to allocating pages non-contiguously if the mem
region can't be allocated fully contiguously.

Going through registered buffers doesn't help either. Fuse servers can
be unprivileged and it's not guaranteed that there are enough huge
pages reserved or that another process hasn't taken them or that the
server has privileges to pre-reserve pages for the allocation. Also
the 2 MB granularity is inflexible while 1 GB is too much.

I'm not really seeing a way where we can honor the physical contiguity
requirements for the buffers without going through kernel-managed
bufrings with the allocation done on a per-buffer basis. Or am I
missing something here?

Thanks,
Joanne

