Return-Path: <io-uring+bounces-12769-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJEMKy6evWmW/gIAu9opvQ
	(envelope-from <io-uring+bounces-12769-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 20:21:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 411852DFDA1
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 20:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02BAE3049258
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D373E222584;
	Fri, 20 Mar 2026 19:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9ZLTZ6y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB534C802
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 19:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774034448; cv=pass; b=hYhGRxrTXfFPAOUuClCBrtWoozUZ1LaFoWuoPszgcZIpN4zZV9BRnzu86ea5xRGtCelz/BUudqcNKxCyDJEvxZDJ/hvsVb4hpMDgymKadU1b82zKFibUeQoTm3rqNLqb+F3u3iWb4JlVkFXL+TA6gf0czvhawxlyspcMzMVrIHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774034448; c=relaxed/simple;
	bh=MNfx2BYNGYMTkKqDWTCyruai8zm31dAVqiEWKRHSqh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IUhKNObTnOXkpoMBZuIh6iiiwkesPpAA7Z7MUYq70qm62nlkSQP2VqRKN3jnOv6yPNuxAh3WVo7d3+WI2qxAqpzSQRQK2M4BcW9wEqThHnVFOhSs31wWPAOilGALStiAY2OJ7K2EwGdSmJ8yOE968JUKP7n9j2FVbE6xsHz9alA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9ZLTZ6y; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso18870655e9.3
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 12:20:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774034444; cv=none;
        d=google.com; s=arc-20240605;
        b=LwUjyB0Rgb6xUQQPkgYP2exASd14LlZgW35EjsXChCvQUjIyaqoLNwx7Q4uaWTa/jb
         OBmqJRxpArGosnwf1iMQy2TLjDqU6YgMhR3nGWxHuryEvFC9QY6929CnLVpdzoQZNghZ
         7LlRQXKmjm9ZiIiqcxOmplLFHNeu/9VQX2M5btHZ8t9dxq0v+I3ZRnLCiPuw/sK3Hs6G
         eNLJYtPtgrPsMyZT5Xsek+VhIKjCotIPkj0wK/pa2vi9MRogdS/Nkuk+ZBroAtNv4/69
         bABhXEotGLpFHOgzDJZOXaCkw9vIkuAD/nroWq+BWSXIefX1hZXXRd8mPikTxEkd30/q
         5n2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MNfx2BYNGYMTkKqDWTCyruai8zm31dAVqiEWKRHSqh4=;
        fh=7s4OG4z+SU50qCdQKXkfIkQzHxUDXqUk3it8DbTDuY8=;
        b=UoUpZF5I2wpoEQuwZBP7QQo6zjVM1vLBQ8MDyhcwMYi3rcJdF9CPRN2W4pksy+9Iwz
         Lcu7yyci47Q6kmy86vxuyfbsSfrNEygq8H9OZypgU1sck0noi0SapBQzjssJNJF+vHTO
         sJtheTMGdf7YyRTRTJYQzvnpt/Lu9lyXhuBCTlHz048kOTQEoDd1u6dwIC7nXn44Q/gj
         qWyfrgvIP+Cql3v+7kH7ZwwzVO3rSq6zs3JD4+/vy4dtLH08tveb4Ps2b/FHEpqLRY0k
         5hRyEnSy0ugfiE6SVvcy3M9evwAbuC9pNeddx5efU4qaefi5gnxv8MRPbJuJj6wtYaYf
         d+dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774034444; x=1774639244; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNfx2BYNGYMTkKqDWTCyruai8zm31dAVqiEWKRHSqh4=;
        b=d9ZLTZ6y+I+SEwFC+rEm+Z1SJStEJlDGevPwDUqsO7TCg644hsZTzHWPJUgXbD63H4
         YkI0Zo/09TE38EHtWcp1QeTbQ01fkkjbBqbvl9aZMShqs2vakB3erNDsVlTemDZOmd/G
         rKzM+OewCYR42ai+JWZPsN/3VLYziKVP/YXEKwVCPQ4wvkvvN+mZES3VcruPN4pzV24t
         eCowdxRNm+NzH+1Ush0H3ggu2SCDQX2waM7EC91iABD4VYSRBa1D/j7W/0ERXExOZvsh
         6Yxjgukx0xGImFDtFakoB61Ezjl3g77oEBMwytn6FoIXU+2ysWPFnXShMWXyF2/F7VdT
         uJdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774034444; x=1774639244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MNfx2BYNGYMTkKqDWTCyruai8zm31dAVqiEWKRHSqh4=;
        b=X78Z48Scf0inMbyJkET97FM1D0uioaDDngn3zoUfrkPoD4QvstbkN+JLYLAMbsS70k
         7IQvfJV/mHU9ilo0Rr4OTDqJUiMBaBpZHI93mKXAEX4TxUhdb1OiwhVFELJ3zsCjEwyc
         gn2zYtlM8cXVc5KlroKAJVGc6WcQSZLsVrJRW+89ezFcHyvpqUBkkOZOUHDacpArzQdX
         4FQFfD04cE0EC29+XTNr5KfBpLF2Zt6XqNDxTDl/cwq+vsdCkRFk+eyZq5llRvSTBTEL
         TElSkmFKxc/l/47+OYBKcY8MOx/sKDG80pf6Jd8Ccf6Pbp0Z2D/k/KoLeug0Su/CRFdw
         852Q==
X-Forwarded-Encrypted: i=1; AJvYcCVxpHJu16++Kn1OH9ficXS74GMAAHdk9AZ9ZSVRgwPizwFPzYrXLInOc0pNQlsl0C7J9Rss5uiaGg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+QTgbYaSGvFuMl/TINpfuPoX4QXHoWzg7dPu3bvmi+vOD41XS
	UUeiBGM2a9R8ZzYTpch2Up4ooI51nHPnEgTAjmvJcYMwcBpHb3phmyJKe83d+iNCT7l8GrpmE4p
	udN8Fmx7yTO15d7Ngn2MOjWS8DeLXFtw=
X-Gm-Gg: ATEYQzwSdS2VejFQR2AA7yXrWzdDJZvqHIKP7aPGgqr+UcoAWIS2r8ZnVUhy6jPp9Ua
	EHdihHwCVjrcTi1qo/SodkGVAw5T2vrkzV+jGa0wysPtUdO2PooVdO27eE9PDInheRSLeSnAcq/
	yqyaJydAL59FmOqP5oIIq+yVwMirVD9wX79Rx8Av6QuWIrHefUT1wtrQ8FJMWicE+ZHLPl4xmJd
	kdpNiBVVQz2LBbuL/OsNjZpCN4fS9U/9ElLiMzBMvZWYmfOeCbjx0LFMEYcvC+URVGHxeYkI7fM
	yIJ6Zw==
X-Received: by 2002:a05:600c:c167:b0:486:fc5f:1ab9 with SMTP id
 5b1f17b1804b1-486fedcbeb7mr63242375e9.14.1774034444285; Fri, 20 Mar 2026
 12:20:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com> <59dcb27f-875c-4a2a-82dc-63b832f8eb1e@bsbernd.com>
In-Reply-To: <59dcb27f-875c-4a2a-82dc-63b832f8eb1e@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 20 Mar 2026 12:20:32 -0700
X-Gm-Features: AaiRm50hJzK0X55Rku5ox_27tI_ceg0eV6uUGvyg8VQiHW1NtcpSSQLg_51a0fU
Message-ID: <CAJnrk1YLtQF=SF-GoG4irKYzzePNewNgyTeU7VLvUN6Ub_NFVw@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	csander@purestorage.com, krisman@suse.de, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Horst Birthelmer <hbirthelmer@ddn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12769-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,purestorage.com,suse.de,vger.kernel.org,ddn.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.622];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 411852DFDA1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 20, 2026 at 10:16=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com>=
 wrote:
>
> On 3/6/26 01:32, Joanne Koong wrote:
> > Currently, io_uring buffer rings require the application to allocate an=
d
> > manage the backing buffers. This series introduces buffer rings where t=
he
> > kernel allocates and manages the buffers on behalf of the application. =
From
> > the uapi side, this goes through the pbuf ring interface, through the
> > IOU_PBUF_RING_KERNEL_MANAGED flag.
> >
> > There was a long discussion with Pavel on v1 [1] regarding the design. =
The
> > alternatives were to have the buffers allocated and registered through =
a
> > memory region or through the registered buffers interface and have fuse
> > implement ring buffer logic internally outside of io-uring. However, be=
cause
> > the buffers need to be contiguous for DMA and some high-performance fus=
e
> > servers may need non-fuse io-uring requests to use the buffer ring dire=
ctly,
> > v3 keeps the design.
> >
> > This is split out from the fuse-over-io_uring series in [2], which need=
s the
> > kernel to own and manage buffers shared between the fuse server and the
> > kernel. The link to the fuse tree that uses the commits in this series =
is in
> > [3].
> >
> > This series is on top of the for-7.1/io_uring branch in Jens' io-uring
> > tree (commit ee1d7dc33990). The corresponding liburing changes are in [=
4] and
> > will be submitted after the changes in this patchset have landed.
> >
> > Thanks,
> > Joanne
> >
> > [1] https://lore.kernel.org/linux-fsdevel/20260210002852.1394504-1-joan=
nelkoong@gmail.com/T/#t
> > [2] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joan=
nelkoong@gmail.com/
> > [3] https://github.com/joannekoong/linux/commits/fuse_zero_copy_for_v3/
> > [4] https://github.com/joannekoong/liburing/commits/pbuf_kernel_managed=
/
>

Hi Bernd,

> Hi Joanne,
>
> I'm a bit late, but could we have a design discussion about fuse here?
> From my point of view it would be good if we could have different
> request sizes for the ring buffers. Without kbuf I thought we would just

Is your motivation for wanting different request sizes for the ring
buffers so that it can optimize the memory costs of the buffers? I
agree that trying to reduce the memory footprint of the buffers is
very important. The main reason I ended up going with the buffer ring
design was for that purpose. When kbuf incremental buffer consumption
is added in the future (I plan to submit it separately once all the
io-uring pieces of the fuse-zero-copy patchset land), this will allow
non-overlapping regions of the individual buffer to be used across
multiple different-sized requests concurrently.

From my point of view, this is better than allocating variable-sized
buffers upfront because:
a) entries are fully maximized. With variable-sized buffers, the big
buffers would be reserved specifically for payload requests while the
small buffers would be reserved specifically for metadata requests. We
could allocate '# entries' amount of small buffers, but for big
buffers there would be less than '# entries'. If the server needs to
service a lot of concurrent I/O requests, then the ring gets throttled
on the limited number of big buffers available.

b) it best maximizes buffer memory. A request could need a buffer of
any size so with variable-sized buffers, there's extra space in the
buffer that is still being wasted. For example, for large payload
requests, the big buffers would need to be the size of the max payload
size (eg default 1 MB) but a lot of requests will fall under that.
With incremental buffer consumption, only however many bytes used by
the request are reserved in the buffer.

c) there's no overhead with having to (as you pointed out) keep the
buffers tracked and sorted into per-sized lists. If we wanted to use
variable-sized buffers with kbufs instead of using incremental buffer
consumption, the best way to do that would be to allocate a separate
kbufring to support payload requests vs metadata requests.

> register entries with different sizes, which would then get sorted into
> per size lists. Now with kbuf that will not work anymore and we need
> different kbuf sizes. But then kbuf is not suitable for non-privileged
> users. So in order to support different request sizes one basically has

Non-privileged fuse servers use kbufs as well. It's only zero-copying
that is not possible for non-privileged servers.

> to implement things two times - not ideal. Couldn't we have pbuf for
> non-privileged users and basically depcrecate the existing fuse io-uring

I don't think this is necessary because kbufs works for both
non-privileged and privileged servers. For how the buffer gets used by
the server/kernel, pbufs are not an option here because the kernel has
to be the one to recycle back the buffer (since it needs to read /
copy data the server returns back in the buffer).

> buffer API? In the sense that it needs to be further supported for some
> time, but won't get any new feature. Different buffer sizes would then
> only be supported through kbuf/pbuf?

I hope I understood your questions correctly, but if I misread
anything, please let me know. I am going to be updating and submitting
the fuse patches next week - the main update will be changing the
headers to go through a registered memory region (which I only
realized existed after the discussion with Pavel in v1) instead of as
a registered buffer, as that will allow us to avoid the per I/O lookup
overhead and drop the patch for the
"io_uring_fixed_index_get()/io_uring_fixed_index_put()" refcount dance
altogether.

Thanks,
Joanne

>
>
> Thanks,
> Bernd

