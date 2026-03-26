Return-Path: <io-uring+bounces-12874-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OmFKRyUxWmq/gQAu9opvQ
	(envelope-from <io-uring+bounces-12874-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 21:16:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3141033B528
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 21:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E9B3300C586
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3F23988FE;
	Thu, 26 Mar 2026 20:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IOpa/SrV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198D23976BB
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 20:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774555925; cv=pass; b=KQDT8NSHTZpibbFvBgioiNIxXpjnv9hH85Wpp7DF2VI8p/mGTXZq+PYIXLUEzDkKSRnKaV2ZarhIF8UgOMuNjKkENVcltTTXD1VkzhRon8sXvjizqfGSoEDoKxquXuoJ8I+ZVpVFltEol6uI4+vAlt5hp1w5X5i0+5jE1w7k+gg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774555925; c=relaxed/simple;
	bh=aQ6Aq/POQfqqEmXu9zuXl6Xin5wscy4aVe2hMd0YT8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D0NJidZCNwihctJahuWqjO23G580bNPwKU9rXSs/Rmk+3sXtmp5aVF+ZWtOtV9ySMJEJSRaDja4AS3I/yuGNtx1gmgfxxazBhbmUpNpkKwVtIEPapNnHQU/IYkz7RrMG6uRBYSVwHMINqCORevmvVqSA4KLUMqwsjLCQS5UznJA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IOpa/SrV; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b4f48c47cso1034311f8f.0
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 13:12:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774555922; cv=none;
        d=google.com; s=arc-20240605;
        b=POsg6aWzR3CKS4xM2iMOT/H3ruEx7gExnfSgL22/XjnXATaErqAbbBg9d/zZkV/R2R
         28NK+x/idefBG2Bk8tuduMEwHtwlmtUGoUcyOb2toMmY2jLKJbZWwOIVVi0KosNdl44I
         omR4lU9JF0eEvka/NxUJT3eFm8h/r7Wkw9WgtkMPSNhO/rNxynGqoSPPyhuAb9Y+yoF/
         8W76Ou9zZpmLqXZ4k2tHxVTNteVZyyBNhAZCcVcqhzIQvKyzlQ1D8H/J//3gv8veEDVw
         Idh1bchGK0fXyWguGAGGgIxsjSjyXpp4JBV+6cnS3mzi1nuDytwWOI8J2aZkGhJ5D7P8
         bB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aQ6Aq/POQfqqEmXu9zuXl6Xin5wscy4aVe2hMd0YT8I=;
        fh=mkJBnx3CL4mQB55eO8Dd9izGfcMjVmV/rcThJ51tnIA=;
        b=hBkBrtQoAiBNzTqIQ11hOZthNBV1uFVAzfVpmbl6JQd9j5IuTCREBzvG/th7dtv8DV
         QZ8Vp4LM3jvIW92FfDfrQJdpHNiQptJN13zxjMtty6ZebT1p4h2zJv0AlFsUlTQKG+gb
         xrohCjb6oSE1rU6qo3VXh717X+c86dxkOJzpBKYej25S1WBlAf11HWljcscvXJX/nYnb
         w09n9NOJe2w5oDD7tIrwJUJAiP0hL8Too/9L6Y2sR4c/DbmF7jVykEVom339ky7xBR2E
         ve929WOnzSGPxcY1lixqkZauMPr0hC+yE3D9CJ6OccX0C517XvdI7gywjf7scXsX8bvp
         wWQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774555922; x=1775160722; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQ6Aq/POQfqqEmXu9zuXl6Xin5wscy4aVe2hMd0YT8I=;
        b=IOpa/SrVSzfjkxzWDu6zax++eMmuHtlcf5jwKPZvzWYm59o/2ehRorit7rMi/4C51B
         JlXRfMPc4MrtaT7NsbZc1q1EPEYwEbQrtmKrpoAFqVZ9Vbwb+lQS1vFzALeXV64yLd+P
         aQtVMtufOXNI0qykQMdIHJtoBhJtIbRNP0COzJfS5dyLp5B9o041vu7Av2tC3rb+OHXL
         859wyXVlbb7oxr+BIbJGq88jiu9lKYnH8Xj0bzkurYg2/MZIYF30eZtfX4QfSie9wUL6
         fe6/v4FnEhOiSpQo3ktrJWHI6e0MQ2qV4yDP9F6onYExbHuG3LCQGwGAaGLDNXSIjJ12
         DlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774555922; x=1775160722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aQ6Aq/POQfqqEmXu9zuXl6Xin5wscy4aVe2hMd0YT8I=;
        b=Ndbgtv4JU4ySGIVSQEj7165+EMmsg5kDPNsacObtGAfzbH445ODRyqCu9a8wYSPBMa
         +WAQ099yQE6+QziH9apbcc1DxnWhMUdXYqAnrVo92+JdqWS6cqaRXmK2XjoIGNyd0lul
         7dF9RgNsNcCT0cn6zXI310bHr2QDqlEyIh24kQCo0xfln9yUvxQGDltbbaMyBaUo/kff
         KHcV6zprT9m41yzyHn8bx54zvI/00D5OyzvbqiG1xrS2qouLj0boTjOJLmuFNzZeyw6O
         XOFsCUpw8sKh4rAOu+2LL4BTJ6GJrtGUie4S2JcxpNOeRHvlI4F7IGWrmyJAyByfw6Si
         LsEg==
X-Forwarded-Encrypted: i=1; AJvYcCWUKlXnEJNcUjepWBXT5YFgpd/waFk1a7LxSJ0Cjag+W7N3eZUDM7HGdsKS06vQEXAoRzSsqwWPUg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPZMgom1L55ZipeJanlRhD3Fan3VaWNhwUvtPW28aG+BePvA6Y
	4UEKZcoaeLjgexCINy6H5nluxu4efnG9+X33SUmM5a/IaQeXxiwsmX8+CrBwwHMtjLQwG+TpEVD
	fgqOdCjR8XA1XwrVHNLftzbAAn0F2ZGs=
X-Gm-Gg: ATEYQzxAJXSItR0jFL6+ImsQ1Rl1+ImoSX2ERKuhWDMeseguMbh4Eu61yOkrTTzvZRz
	ka54zW5iX98MCmwZuU4uboTnZqGK0832qZFMzPZCfk68tscGpzdi5UEgjPCdaBJuWqu40+g+F+5
	/jHfQd8jPc9v5Yhywpk+gX7/CLdAdMiiWA/DteexOzayjQaL3oVmhMacoyWkFOEb/9L50xO13gy
	MGqvYHG9+Y0xjHYfV8VoGoIzEMxY+QMwrw87Jtkw3J6pSLl00ieMQaG3xv3/JaiYNN0RhVVL9bX
	HBVSBw==
X-Received: by 2002:a5d:5d01:0:b0:43b:9986:2fbe with SMTP id
 ffacd0b85a97d-43b99864385mr3860955f8f.49.1774555922211; Thu, 26 Mar 2026
 13:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
 <CAG48ez0H_Z-NQvfOeczECz_sO=MzVDvu+8m+msB55rcAPfQOgQ@mail.gmail.com>
 <CAJnrk1aTnoDwDVdgYrcN3tHm-_j79GKYY=8q_Lu=xi8=Cxi4bg@mail.gmail.com> <CAG48ez2o=OzSjuPYm44gCDrG_tqzXC3=PCJHXCBVJyYmemtzsw@mail.gmail.com>
In-Reply-To: <CAG48ez2o=OzSjuPYm44gCDrG_tqzXC3=PCJHXCBVJyYmemtzsw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Mar 2026 13:11:49 -0700
X-Gm-Features: AQROBzCKIqfx2y0xdE_s3cDvS-5ttLByg-r-ogTcKv2e1J_I2Ot6s_Y1MeHI0DI
Message-ID: <CAJnrk1a3xz4fcA+rB7Y3Cvp=D24-4TOF7bE5O9KTTZPjqOwfoA@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Jann Horn <jannh@google.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	bernd@bsbernd.com, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-12874-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3141033B528
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Mar 26, 2026 at 1:00=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> Hi!
>
> On Thu, Mar 26, 2026 at 8:55=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> > On Thu, Mar 26, 2026 at 12:33=E2=80=AFPM Jann Horn <jannh@google.com> w=
rote:
> > > Am I missing something that prevents normal io_uring operations from
> > > grabbing IOBL_KERNEL_MANAGED buffers and accessing the wrong union
> > > member?
> >
> > Hi Jann,
> >
> > I am going to be submitting the changes for kernel-managed pbufring
> > compatibility with normal (non-fuse) io-uring requests as part of a
> > separate patchset. You're right that there is a functional gap right
> > now where trying to use kernel-managed pbuf rings fails with errors.
> > In those patches, an iter_kvec will be constructed for
> > IOBL_KERNEL_MANAGED rings instead of an iter_ubuf. I'm intending to
> > submit that patchset upstream in time for the 7.1 merge window before
> > it closes in mid-April.
>
> Ah, thanks for the explanation. Please CC me on that patchset, I'd be
> interested in taking a look at how that will be implemented.

I will make sure to CC you on the patchset.

Thanks for taking a look at this.

Thanks,
Joanne
>
> Thanks,
> Jann

