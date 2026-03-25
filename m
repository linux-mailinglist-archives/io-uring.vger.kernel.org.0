Return-Path: <io-uring+bounces-12861-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uA35DuwcxGnlwQQAu9opvQ
	(envelope-from <io-uring+bounces-12861-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 18:35:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CEFAB329EDA
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 18:35:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 76A073179FB6
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 17:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62C5402BA9;
	Wed, 25 Mar 2026 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mv7y59sN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E8C3EDACE
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 17:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774459491; cv=pass; b=UmeXf26MKtSiiCNW/prBGYdEH8s9nRLiJPkVKW945OdW1ttJgbuDVKrJtnLsFlyToaK4N4wE5zP5E6PJafltas7GNyM34BN+H3Cf0SoXt0hepVw2SKqzur5WVmcR497zv/fjWrsjr8Ij3en0HF6Oe9g96xoGtBOcsI3hyi612dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774459491; c=relaxed/simple;
	bh=oYFJagS2iv2i/2FDMiYH+pefXFCvv/yajXcKUiuiomg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMfPBcEGDwc9WMbTVzAYhUZYAbL4kUvjvsmmxBTTt5MvPu2+hG46nqRN76MbVeX/gnYlzZpUO5IO7dJVd41iDBnkKcJzW6idgciYzPpEz6+Em8OibZXObfRS5ioYP0Xhmo1obRRLCO03LblOqB3gB9WbAZ0bns4smbsXQ/Qw3Qo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mv7y59sN; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso913525e9.3
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 10:24:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774459485; cv=none;
        d=google.com; s=arc-20240605;
        b=IrciZDh40kAwe8+OWCKTNCqePP239UW5fmIeZPaK6G6qwW0uqnPi/4lEfI18sz84Vf
         n/msxOvi2VVUHXSvc0SXYY9s23/bl0/G8ZFZ/HlU6xwFIiCai3X3j6qwG7/5sP1oyLmm
         UmXRd8uZuqsWkMI0F0Xfv51icNXyySwxREp4XMrWEdTch+8m9GXiO0QKD9y4OKthPtu8
         U+k/4VAWCDyxGLPb9RNCgJUaqBpUwaRRrYKGn2Rw/BZvGhROngx7ulwZkyvzSTOkk/7C
         NBbe8RDebiGpLemhX9mlBkbcvI13tRIeE+HjbCbGJhDlVYeyN2F5SdYmTcALMpLYFQiM
         CTYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NO+271hvfgZXz6iwYhNUivLZ2DGdoQtuDSZaz1xGIV4=;
        fh=8inJBaZPdK1569zA+RO7RqLuwX07MAHKYKKOsphTS9w=;
        b=i3TdhzukpchA0/dU0TLU4D2TvC+Fcgg/UBMSTH+KWcmDA2abERjfdL55kZpAi6J2+7
         ADH2dfAUdXRGHdej1Dtft+uwhD6MdKn8/KKOUIHhfHq85nGfTcmgcXIfY8MIW57k7GXr
         t7Cwpn8pAmbrysdbBQVcizhOILNSTFIiCkhTuDupEw/lEY4NOSKblMgUDR1Bk1FRvjly
         gTRzzbm+oE4Y5SsnG6DTFd7ssAOIIj9asgtEKCg40vpzp/sSIausOrh8mx0vrUgN0Yqw
         Bv10vObdDLiNUFvYaMKb/sgiVo9Th2dDLaiqdRgKk0OQO/Jl8YsjA4moR5o2dh8JaaJc
         p4rA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774459485; x=1775064285; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NO+271hvfgZXz6iwYhNUivLZ2DGdoQtuDSZaz1xGIV4=;
        b=mv7y59sNIwIdHFaQDf6szYBzpDFyUaFDtPznFcOhraF4AHlvd1DQ4AXvVv2K8A9yB2
         tayxsc3w4WuxZ7lpFaOxdo59D9Q2Aq9mV7BUSjGe8VZMfCYsPhR7CSAqp9fCqKIfSadZ
         WTi2Tz5WO37xBgoilzRsfMYWvMQQVlf0WjV2MvF/9g9VpAWfEm+3zCRw1IytOsDeGZK+
         D7JKpOxUJjeY/M0CHHtZ8/eyE4JQEBPDywJuxQf2Dx62uWu5IjK76vJzyAPCK/adxvKb
         jZxOF4RfbgyfFNoubUtm5rObHdV/jUwMNQ6BsrO4UYKvc9u5sO+Pi4AIXaXLM90KTw+b
         FJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774459485; x=1775064285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NO+271hvfgZXz6iwYhNUivLZ2DGdoQtuDSZaz1xGIV4=;
        b=e4b2KiYeOUc96cv3yxC1ZuMArangtCaEojwuXVrqbUeuNVcN3EHr6BgUHMlvmAD2pl
         MOcgWOF29kkq/F0RqstFsQ8+IVTZaIpELRlocnmrOaqXWVKjlvLHUGFACwykq4kwU012
         6QVqzYklCqShzXmLpY2hvvUOleGgpzP++nyDj+nwrjh92zOtKh9StWA6SrT6nBA9POQb
         p9xMtc539sB+1nvdNQUqZV496io0HhB9GK/Xjtj63KOtCvg4Vq/ON//0P6binI5i4W0r
         ADy/au70qItsLd2V+LJ5NEZtgKf0EIdkwg3hSqoomMm6g9bioY5vu2bMJkKA5nDPhd6o
         Ij9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWekN5G2eoKmep+StsPWciVVha5ViI0NxsEEQGwytSXTi9PUF8fEd18Sz7dtGImwlO50RjhHzBp5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgZVTWw1uw1+nmztGWpee0YhJ7VoaaraYDOO8X4XcjAtqwvcrZ
	r/Ff3Pexo0ySThdj2jK9hQG2MzLyUg19jnsuQinBs64bsYo34E3mKieENvWXMNPWh68DvNsSiJ+
	W0xcBkL30BxTge0Xur6EWXcrDLiSmLts=
X-Gm-Gg: ATEYQzxjVEKu2Aa+xcmqkXd2djftP1syYMNQOhmDERi4ODe/tf7GmKb9caIRZ2tzGpo
	Nb4VKkYOhETb3AnRnG+c3AV/ze3LOmTsYgr28ldRVMHUtdbFI0aohlKeOcUFGNZ8MbVkKWJ+4/5
	/dPutJTsT88gJan3VoiqETXdsV38AZ0YAvmuwtn3Fkfe+lPKQxBApPfTDYSN/sBvqnE07k5AqJ7
	nJtiK+mnTMUG8+0tRBfNuHCwmYCbW6JEvUz4f8m0aerAz0uEsKmjpSOscnQmV7iPLzlT8t218RR
	QA4+3o/5UmgicdFy
X-Received: by 2002:a05:600c:1f8e:b0:487:1108:48bc with SMTP id
 5b1f17b1804b1-48716039cd1mr67711885e9.17.1774459485249; Wed, 25 Mar 2026
 10:24:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324221426.3436334-1-joannelkoong@gmail.com>
 <20260324221426.3436334-6-joannelkoong@gmail.com> <78925323-89b4-4def-aa5a-6138b4aa5d1c@kernel.dk>
In-Reply-To: <78925323-89b4-4def-aa5a-6138b4aa5d1c@kernel.dk>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 25 Mar 2026 10:24:34 -0700
X-Gm-Features: AQROBzA-sn_dFrkxlMMYjPAopghlvnU7BpIkxHLuVVFudpb2pOVM6Geq73R3dWE
Message-ID: <CAJnrk1Z1n2xTem3xoP9oGDsJ3o9wPO_CfQ1GQy+d3ggLXP-9yg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
To: Jens Axboe <axboe@kernel.dk>
Cc: csander@purestorage.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12861-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CEFAB329EDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 7:56=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/24/26 4:14 PM, Joanne Koong wrote:
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index cf5638406a0c..c706324fd66d 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1182,6 +1182,24 @@ int io_import_reg_buf(struct io_kiocb *req, stru=
ct iov_iter *iter,
> >       return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
> >  }
> >
> > +void *io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
> > +                                      unsigned *nr_pages,
> > +                                      unsigned issue_flags)
> > +{
> > +     struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> > +     void *ptr;
> > +
> > +     io_ring_submit_lock(ctx, issue_flags);
> > +
> > +     ptr =3D ctx->param_region.ptr;
> > +     *nr_pages =3D ctx->param_region.nr_pages;
> > +
> > +     io_ring_submit_unlock(ctx, issue_flags);
> > +
> > +     return ptr;
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_registered_mem_region_get);
>
> This looks suspicious, but I actually think it looks suspicious because
> you add the submit locking around it. For patterns like that, it makes
> the brain go "hmm, what protects this from going invalid the instant
> io_ring_submit_unlock() is called??". But this should be stable for the
> duration of the ring, hence the locking should not be needed at all?

My understanding is that once a memory region is registered to the
ring, it's registered for the ring's lifetime. There's no uapi to
unregister a memory region and my interpretation of the last paragraph
in this thread [1] is that unregistration is not intended to be
added/supported. I think the submit locking is needed in case another
thread is currently registering it so we don't see partially
initialized state between ptr and nr_pages (eg if the caller calls
this from a task work callback).

[1] https://lore.kernel.org/linux-fsdevel/000f7db7-5546-4680-bef2-84ce740ad=
8fd@gmail.com/

>
> I'd probably also prefer wrapping this in some kind of return struct, so
> that you just return that rather than having one part returned directly
> and one stuffed in a pointer to an unsigned for number of pages.

Sounds good, I will make this change.

Thanks,
Joanne
>
> --
> Jens Axboe

