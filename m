Return-Path: <io-uring+bounces-12182-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iP8lFhAOjmmS+wAAu9opvQ
	(envelope-from <io-uring+bounces-12182-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 18:29:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7596D12FEB2
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 18:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B4FA330131DC
	for <lists+io-uring@lfdr.de>; Thu, 12 Feb 2026 17:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7E62580D1;
	Thu, 12 Feb 2026 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bQaPPedn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FF3134AB
	for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770917385; cv=pass; b=h9M+tvGGEmUyyWJBcADAE/rHgfCiMS53Q5Z9YOh01ou6csb/HbtJX6VMJctDIRviEuFZrQ5rr32VQi7W9VNSWEo2+6q4AG7PbamXH4Dyf4uk8sHid8OuQARlDl4pXcYwhrsUDikdyZuLRwgp8XxXb/ikEQW/N9NRc5LUsmUB4Gw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770917385; c=relaxed/simple;
	bh=1EByc7pPcUDpjYuGji62SyQGdnhfUhO6Z5xF3S7UI6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sdVQc/FUI9yY/bIFe7+DNCaWjEzfR2ERWg07Qca31cWQG9SghPgqihb5CvIWL9mTkaUsvlBF7C1jSezPnE9fyzdC7RyW0JkGwKJhyZzmOkWqLMHEn3EWsCXpJZL7d8J/lthvfuFuSCVGWmg9qGkfEeyC1NJcLE+okjV5UROLckQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bQaPPedn; arc=pass smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cb39647a70so15757785a.0
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 09:29:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770917383; cv=none;
        d=google.com; s=arc-20240605;
        b=kiLpZc3QtUs0HhIaXc/wDSY4iXQWyjdEh1mMBo1fgN2HX2pGmbHqvka25TJ/1zSEAL
         hMcddf+xI4KQGLgWx/hDjzQ3kXk9XXhQXMCobJKKK0xnTW6I/dziojNuZ4c77hP7LCEf
         wNcEP7e/kqJX7gzmvzyqsUUO//zPRcrCSJgSHnv8mcCGiIP4PO+bDYfbQxylGXkZ+ZVr
         ojww5F2jrVdaL2LdmvonS/XeeBIoqD5PGaKmD0xlOPzFLpiUnp8380K88P59Y60Qwgcz
         7vuafC3JJn/8vzxKTnbYm+qt7vrfMzHAizb94XfIMSfoQox0Cry5An+SQiS+By3o9F9c
         aXeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gGRtar0eNrSBMa5mAb00tI7qTYYP3hc8LonPzVdLY28=;
        fh=RTLX4yz48mlW4vN3Tp9rzHNenXCpa1zwczoV6lwl8jE=;
        b=ZUs6xaobpWkZkZ+ae/l+vn3cT6iqPjfiAeiPI/rX+Jf4ezIu3JRlHTgGybyllaU2UR
         DG6bpbp7xR0B3Ij0mDJixr08zjKugbe30seHC+7ZcyUjf/Pgx8vI8Qu+r+nMYgeHxONK
         t8bosZtd76B0r/7s6LfYH51iPqQfp+0qsyYvrNgbVwKl9hVV/g2kDB3R2LvxbYxlQvax
         dD4M02nqh9/YE1o0wwqrdP4H5JdG9v3BHTa9bRxbCpdX+xkwK47E2CISGHI3D1/Q/idq
         oFT4BlRidJ2y3M8ctdsMx5DQkDyzjsNbQEcPhamEKN33j14fu0hEn0OUrzmW9vOEKTfo
         c8mA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770917383; x=1771522183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gGRtar0eNrSBMa5mAb00tI7qTYYP3hc8LonPzVdLY28=;
        b=bQaPPednqGBAwKKDeymcmjSrv0os+UZgWjRwbXKDTFxhx/UUtNHm+6nkHWSAl9XjB7
         wCQRVJEKTE2kL2LQaMK7b4QjSXJdDKA3xjlFjqio3S59xKTi8/PWTFMQQxJapcTyGRt4
         pnCChn/FwM/8ZUF26owR/paWr0XpW6WKbtV+qtj5zmiQBzZ5WrzQsVz908pw/vdUk7Cd
         hqE33zUsRhXGUh6o3ULYl+7XHwgC0SItoWLhH4xDekq2dMzVwCQCUvZhaRTddQ72b1EW
         iB/nkwymvcQ1AMKUwgnk83ckgQUrtOq8hZW8CnPI5HCfBmBX7FDoU/3/tJxM9z4QJ9QD
         Zd/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770917383; x=1771522183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gGRtar0eNrSBMa5mAb00tI7qTYYP3hc8LonPzVdLY28=;
        b=jEw4+vr2D4ZJRcOEkrwq6n75JPXvH93plidoCFUMcZAmDs5eEndcV/6Oe9GL9GDupF
         K175C/2lxJdSQZPgwYYMVlpcgJZ72RSA66ymRBMBeuEScFG/qe2ZS3qaAcStb2hsBtmx
         nniJp7rZlWLg4G9leYFVzElYy3mgY4ZK+gpOxPBAXfVf1jsSl7Y8Babfdp7XcVZD52C7
         JizX0ymh2uwdkfnekmIXxhrGkx0FPoXm6b4jV7CFaC/DClPLmEp4KdMLW+GOowYpr0d8
         z0McWQMFxsDMk7jt3adnB5QSBCG/cHCsdxkePzI+Mjva+9nFb1IeexUja+xufQ6DLq1U
         8Ogw==
X-Forwarded-Encrypted: i=1; AJvYcCUvszjxnsSMla210I9Ubko6S8SRtEz5OlGL76pxo1isVKb2hzLeoPb7+o57KR7wLgP5I3fimDBIZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyExZn/mThht7ehZyZeb51P4ejN4BihT+lFFV+T0Mw+g17ek8RE
	7wNYn7j0bFlDdQM2g4V+7kiqmzHh+Ugs8hLkf64bUWRuLaxLLvmxRpi8C6IXpcz0JTAsuhlmDIk
	OkESDyWLxe/eGxdtCs6ywsSDsSoQ7Ozw=
X-Gm-Gg: AZuq6aJtQgObfvgrt+r+zRu6ywjRlAeq95AutHofNmm3m6fvdSOZBqjeCB4ja87rkKb
	rITD0Pmy+3/cO/rcmSQG/cIgCg1CqNuo90BtyeIv+rokK4zrWek9Ld9hrCJJPc7kf2Vp9RiJUyB
	Fv1k5CPPAEuB9fRTL2vb5G+c+9wgl3Rc0CznM3q5R+sxtJ3H8dNyESKCSVoXdHNLEkClo9Dk3LE
	CzRBnsSXrFJW560jzNfylshXM206IadK3RE31AlupxJWQKF1ZpnYCVlA41Gs9tNr1kknyYqzqGF
	wUlCIa+brACuj1b3
X-Received: by 2002:ac8:7f81:0:b0:503:2f21:6355 with SMTP id
 d75a77b69052e-50691ceb8cdmr47743991cf.34.1770917382679; Thu, 12 Feb 2026
 09:29:42 -0800 (PST)
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
 <aY2mdLkqPM0KfPMC@infradead.org> <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
In-Reply-To: <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Feb 2026 09:29:31 -0800
X-Gm-Features: AZwV_Qhwfszf8ijKJetXoa5_RTHnDqlX39tu-a_UpQ9gTpK2zQI2VVCnpbohqyM
Message-ID: <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12182-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7596D12FEB2
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 2:52=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/12/26 10:07, Christoph Hellwig wrote:
> > On Wed, Feb 11, 2026 at 02:06:18PM -0800, Joanne Koong wrote:
> >>> I don't think I follow. I'm saying that it might be interesting
> >>> to separate rings from how and with what they're populated on the
> >>> kernel API level, but the fuse kernel module can do the population
> >>
> >> Oh okay, from your first message I (and I think christoph too) thought
> >> what you were saying is that the user should be responsible for
> >> allocating the buffers with complete ownership over them, and then
> >> just pass those allocated to the kernel to use. But what you're saying
> >> is that just use a different way for getting the kernel to allocate
> >> the buffers (eg through the IORING_REGISTER_MEM_REGION interface). Am
> >> I reading this correctly?
> >
> > I'm arguing exactly against this.  For my use case I need a setup
> > where the kernel controls the allocation fully and guarantees user
> > processes can only read the memory but never write to it.  I'd love

By "control the allocation fully" do you mean for your use case, the
allocation/setup isn't triggered by userspace but is initiated by the
kernel (eg user never explicitly registers any kbuf ring, the kernel
just uses the kbuf ring data structure internally and users can read
the buffer contents)? If userspace initiates the setup of the kbuf
ring, going through IORING_REGISTER_MEM_REGION would be semantically
the same, except the buffer allocation by the kernel now happens
before the ring is created and then later populated into the ring.
userspace would still need to make an mmap call to the region and the
kernel could enforce that as read-only. But if userspace doesn't
initiate the setup, then going through IORING_REGISTER_MEM_REGION gets
uglier.

> > to be able to piggy back than onto your work.
>
> IORING_REGISTER_MEM_REGION supports both types of allocations. It can
> have a new registration flag for read-only, and then you either make
> the bounce avoidance optional or reject binding fuse to unsupported
> setups during init. Any arguments against that? I need to go over
> Joanne's reply, but I don't see any contradiction in principal with
> your use case.

So i guess the flow would have to be:
a) user calls io_uring_register_region(&ring, &mem_region_reg) with
mem_region_reg.region_uptr's size field set to the total buffer size
(and mem_region_reg.flags read-only bit set if needed)
     kernel allocates region
b) user calls mmap() to get the address of the region. If read-only
bit was set, it gets a read-only address
c) user calls io_uring_register_buf_ring(&ring, &buf_reg, flags) with
buf_reg.flags |=3D IOU_PBUF_RING_KERNEL_MANAGED
     kernel creates an empty kernel-managed ring. None of the buffers
are populated
d) user tells X subsystem to populate the ring starting from offset Z
in the registered mem region
e) on the kernel side, the subsystem populates the ring starting from
offset Z, filling it up using the buf_size and ring_entries values
that the user registered the ring with in c)

To be completely honest, the more I look at this the more this feels
like overkill / over-engineered to me. I get that now the user can do
the PMD optimization, but does that actually lead to noticeable
performance benefits? It seems especially confusing with them going
through the same pbuf ring interface but having totally different
expectations.

What about adding a straightforward kmbuf ring that goes through the
pbuf interface (eg the design in this patchset) and then in the future
adding an interface for pbuf rings (both kernel-managed and
non-kernel-managed) to go through IORING_REGISTERED_MEM_REGIONS if
users end up needing/wanting to have their rings populated that way?

Thanks,
Joanne

>
> --
> Pavel Begunkov
>

