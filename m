Return-Path: <io-uring+bounces-12863-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCjrJM4+xGnZxgQAu9opvQ
	(envelope-from <io-uring+bounces-12863-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 21:00:14 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C3D32B882
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 21:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D28D307652E
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 19:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6856330F93D;
	Wed, 25 Mar 2026 19:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7/FEaAG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31C2301472
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774468585; cv=pass; b=Ei0y4yK3fUn2z2AzzrpEjaqw89yuBPGW2p6a+zCNhZFf7YNqRAF3LT8FBkE5gA+N3VbSvrKsLkNT35tIfoDdEmoXQ1+2U3nWjTaahNL9kM+HjziFD3WCDRQ3rcknyw6pyHXMNql2la1z5CkVMpHVPDIBR4mh4ylz+gK+2FN+qCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774468585; c=relaxed/simple;
	bh=QxHvh+R7B77YNN26V+nVpBuCSOqaaOY/jg9xGAk14EI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sunCxfx5+1yw0f3kpyUEJF9/CV469H445um6tdT0QHeoPvhhL6I0jp+dmc+QiqsuKsx99h8ACPTtJGVjiM4Z//8K/9UHJlLngItck3hRTS9xOpZH+lcetrG0o85AJkrdjiqa0EYG6JMluKv/SELDr91VFoa3nSnmpsQlpazO/+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a7/FEaAG; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43b4f48c47cso160126f8f.0
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 12:56:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774468582; cv=none;
        d=google.com; s=arc-20240605;
        b=DwvFwo/PuM6ckryZAUfYJjDrz39evPJidX5f2HA5muUW5K+t5p9MQEchw+yfdMFoSs
         zvTM4mYOfMxTj/COnvWc0cJtgK+2MFDfaQ0YAPvmnK4YETxYe7A3MhjbSwTmom5xMjlO
         HQhE25VDoJe0EOD7zlHm1HXtE7jnRypLnAfxYCidMbuee6RX1k9BU52bZWA0NDwFWVdN
         pkovr9skYA4cXhqRPRR0y8Gl2DUDpBOsUe/XbPNUSuxs7oES/WHLYqNJWfwfsUUMIEq7
         ku22h/wlQCxbjiVOK7v7MybXnCLJxn+RDU28pih/ETyIxa+zq3sam7gDKmMAOr7T01bM
         GOYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+Y/cQo2cDIh6eM1J5dXxKlYpTiGeFYEThIZz2/uhTMM=;
        fh=CApDCuAyP3YnyMkoilhcO6ROdHSyRQyuMxor9gXUIk8=;
        b=l1DgCf4SEHDYjgfjSqRx8qyVBQ5wbjU8wBDNuWJzC6v2akvYR/Pu/1JBhBIcQNBWm5
         vXrv34ZKtWpu5OekpWH2cdjh6XCjFsihR0ZtEBIg9AT2NG7HP1T5pCCgRaZcn7Bh0Z7h
         6nAGh6LlGmf2YuxBRDr94P6QXlkC8g+OrpeQavpU7ODPBVVZ5Aq4C1TZR5H2bEAVCyAg
         CS0Pz26kMH3clafMLIzoC4CKurjUAu7czVqUDk/aGwNSNsT4yb3cSLNq9K1+UrbubSJN
         UIW6F+Xu2rZzl9E2wGlaGfucKIlUVi6ixpvd/aBuZrJ2gxJug7MyS0GCOoS1LF1pTVFx
         PNng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774468582; x=1775073382; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Y/cQo2cDIh6eM1J5dXxKlYpTiGeFYEThIZz2/uhTMM=;
        b=a7/FEaAG8t6YP4W76QPWVHqyYu+swjPWObEQI6pS/DCaG3//QoyiP3FFrxt1auKIyY
         TLL36Bu+peIv87ZiZIaf0Yl1VlJ0l7JmlGIGcUpzSc/IUM5shLF7/9rldZ7CiOJvEfxq
         ws6eyjX3YoYKWZoWSaJdrspoWfkU62CEvOnLcMQc7e/Ni3TAslIATnHFQZvJ+vNkOBsG
         rmI0M5Cuq1oTXw5DypN3jzSmXYIFIRwzNZ9ZrNK098G4BvwWDwWq+1KZGH1IdgOBCngU
         sX4HuQvd48M1VJbJErsduj4n1RnTlUZFD7uxN35k6MqEVX6gRyDf3YsFuiy1cLnkWkp7
         11ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774468582; x=1775073382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Y/cQo2cDIh6eM1J5dXxKlYpTiGeFYEThIZz2/uhTMM=;
        b=Z9gd1Iv01hZ9RY3I3zevONMuy1jAELGdxzWZ2G93yGBLSm+j+RjKOAGPUFOfeLuhMN
         +2hwCY58ldKjxPE4gFfy+BhPbgvCYmyw5wWV4bKjJKUDRhffsKdwHF/H6IZyaq2I/u6R
         pLFTf2UCHtUoOCir4xAexKRdGUEqrbHowncHRqpn4F0iVlVT4hgAChplkgoZecBP5aaA
         BysYYWkSd9P8AhweUewQ+7hDyh/TeJ9Kx7e4ekSE4PIUA+uj8UzI0Fr6UP0suHTObfsR
         zm5/+FJAvo8JJOPAPrZsQ/b1pO+wQC4I4bqjOylgRwf642W3+GolaUqqrhhH11CIXRiL
         7f2g==
X-Forwarded-Encrypted: i=1; AJvYcCVmLuOkUeoxb9bB3vq/J9A6PEZmvNXA+paBekNvbSdjHFPYR8Z7MABUwy9POEFDujjIC4vpSBL7dA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/eRdHVoeR62ZSYhXnTifAGAp3k7Cb1BCU5AHapOvXYPZckqRp
	XOUtRryBiiGvaG6UxwBiVVc0B1WeFpAz61sr5DxmmrEeVO8ZAXXSQQn43S1bxW+8G60QFbQJVOt
	kTPRRFwaevxYc+EyGgabCWcmBnDqWZ9o=
X-Gm-Gg: ATEYQzwcldxWsj5yz9qNKoKdjQwQwxqgJdNphl29XCkj/WkSk/z+aeWX7O3DMynbbmx
	wW5PrLVewtIsni9PGP1l1vnhjX8aJKt6ZFw1G8+4z5DJ813hb9tCiVTKhJujfNnm+eEs6QzhE3+
	i+4Mv8x0rIXYDND1dzdXw7GYNNHvKgXkzFvWi4/vsl8HYzFa/YJDv8ZB/0Wnjlm3dMngzAcFqwf
	QVzkM6QiVgir6Tf9fS11ISuxXpeAq/3vcX/P9fDB9KBGrNkw8ItsTcG+E9lU2U1MzmaY5fh2qNl
	QxH7pfMblmQ9mBSe
X-Received: by 2002:a05:6000:220b:b0:43b:468e:3d78 with SMTP id
 ffacd0b85a97d-43b88a39b3dmr7158294f8f.52.1774468582198; Wed, 25 Mar 2026
 12:56:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260324221426.3436334-1-joannelkoong@gmail.com>
 <20260324221426.3436334-6-joannelkoong@gmail.com> <78925323-89b4-4def-aa5a-6138b4aa5d1c@kernel.dk>
 <CAJnrk1Z1n2xTem3xoP9oGDsJ3o9wPO_CfQ1GQy+d3ggLXP-9yg@mail.gmail.com> <147aa05f-2e03-4d0d-a86e-b145913d8584@kernel.dk>
In-Reply-To: <147aa05f-2e03-4d0d-a86e-b145913d8584@kernel.dk>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 25 Mar 2026 12:56:11 -0700
X-Gm-Features: AQROBzDBhE0klcMkeJCXgFBuHeOIKAv4nTxuq_0Ooqz__TTNOTZjUz-4eJv8fhE
Message-ID: <CAJnrk1YWh=bVNZkHYgtG4QSePTC2LGi-x=-AuecS=HG5wCTpKw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
To: Jens Axboe <axboe@kernel.dk>
Cc: csander@purestorage.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12863-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E3C3D32B882
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 25, 2026 at 10:27=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 3/25/26 11:24 AM, Joanne Koong wrote:
> > On Wed, Mar 25, 2026 at 7:56?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 3/24/26 4:14 PM, Joanne Koong wrote:
> >>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> >>> index cf5638406a0c..c706324fd66d 100644
> >>> --- a/io_uring/rsrc.c
> >>> +++ b/io_uring/rsrc.c
> >>> @@ -1182,6 +1182,24 @@ int io_import_reg_buf(struct io_kiocb *req, st=
ruct iov_iter *iter,
> >>>       return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
> >>>  }
> >>>
> >>> +void *io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
> >>> +                                      unsigned *nr_pages,
> >>> +                                      unsigned issue_flags)
> >>> +{
> >>> +     struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> >>> +     void *ptr;
> >>> +
> >>> +     io_ring_submit_lock(ctx, issue_flags);
> >>> +
> >>> +     ptr =3D ctx->param_region.ptr;
> >>> +     *nr_pages =3D ctx->param_region.nr_pages;
> >>> +
> >>> +     io_ring_submit_unlock(ctx, issue_flags);
> >>> +
> >>> +     return ptr;
> >>> +}
> >>> +EXPORT_SYMBOL_GPL(io_uring_registered_mem_region_get);
> >>
> >> This looks suspicious, but I actually think it looks suspicious becaus=
e
> >> you add the submit locking around it. For patterns like that, it makes
> >> the brain go "hmm, what protects this from going invalid the instant
> >> io_ring_submit_unlock() is called??". But this should be stable for th=
e
> >> duration of the ring, hence the locking should not be needed at all?
> >
> > My understanding is that once a memory region is registered to the
> > ring, it's registered for the ring's lifetime. There's no uapi to
> > unregister a memory region and my interpretation of the last paragraph
> > in this thread [1] is that unregistration is not intended to be
> > added/supported. I think the submit locking is needed in case another
> > thread is currently registering it so we don't see partially
> > initialized state between ptr and nr_pages (eg if the caller calls
> > this from a task work callback).
>
> Yes good point - can you please add a comment to that effect? Both why
> it's safe to return this state outside the lock, and also why the lock
> is actually required to ensure we see a sane state (either region fully
> registered, or not there)?

Good idea, I will add a comment about this to make this more clear,
something like:
/*
 * The submit lock ensures we don't see partially initialized state
 * if another thread is currently registering the region. Once registered,
 * the region is stable for the ring's lifetime (no unregister API exists),
 * so it's safe to access the returned pointer outside the lock.
 */

I will wait a day or two to send out v4 in case additional comments come in=
.

Thanks,
Joanne
>
> --
> Jens Axboe

