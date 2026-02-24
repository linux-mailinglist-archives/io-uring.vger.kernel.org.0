Return-Path: <io-uring+bounces-12392-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EJMVOCHtnGnqMAQAu9opvQ
	(envelope-from <io-uring+bounces-12392-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 01:13:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE1918027F
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 01:13:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C60A53053DC1
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 00:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7840F12B143;
	Tue, 24 Feb 2026 00:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h9p5Hu4A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B31C23741
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 00:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891998; cv=pass; b=I7a8oJcxrm9H/vivT5yPIrG7jwAT0pXWuDjGfZteGqMsrJc9OKzKwGlS48vwjIDqpddaBrNdHvHzQRcpBirD7ZLQxzxkmBI5hvBPxlku7GGbIFGgujYtkMAC24fkLlqccx4AShDyYg4kJtyIFBo/9NYeCd8Huu8vRWZhrCWD9g8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891998; c=relaxed/simple;
	bh=bweRSyy13JW5iYuGfSQw8Rmf+z1/DCVAjagAYtz2NFs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HozHr6MI9aq8fSjh2bdTFAdqAjvMtly8bp1yZTpNo9jtdoKbUGAuQim0sYTQDAS8evH0OKvFxT30FzEpGa8h6zM5yQkPcNzGBeRlpq/mmWjsAi871Oa1qLw+Pq7erZCEEKyr2c6nlhWfGQrMOaq8assEBK070OORONo4Zvms/so=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h9p5Hu4A; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48318d08ec2so12475e9.1
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 16:13:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771891995; cv=none;
        d=google.com; s=arc-20240605;
        b=j2KQUX8zSlqH/xQnBBliA4Cm68FLbXEhEonGo3c8+RiTmBLI8GvdevjzLeJgPSiN0L
         G45DAFOXiAvFEmdGoZQHKDsSRWZJ0h3ppYAZAPZ1RkcjiYnSVsYhni9NTtz/c9ctfKcR
         etyvML9sGd7IoFxqFBYuAjFHPKzI8Lq5L2JKzRTdmMPkA/3ujB9+J17BxSgl4yQOCK1z
         RdZvE5doG0PgbmSGTJpdwGgA+Bbc/C5QlkBV9+F32f/Y/OW3Pa4w/rN1SzxiCodg7Jln
         Fx7/ZFhKnWEebsEh85SlEvhYF2sdBvKNf8iwyDPfMEKoMLX6N/z02lHIiS5N2oWSNJOj
         WnTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bweRSyy13JW5iYuGfSQw8Rmf+z1/DCVAjagAYtz2NFs=;
        fh=Tds3coVqW9ZlXL3SQtQlhnF2n49sf9G1h0FIyOxIoic=;
        b=gfaio3AJwGGOUCCUvq4Ld7Dd+5kbOfRc8e2RFxu1FLHWMiZh8T5e+xQxyueS399fs/
         fQCFDIeFjHCyUOqAT05IjUjmLAf6fw8+ZkPGtsosDlpT247m+LZTbyeXFFuSNB0Sr5sb
         NXeyr30/bvKcIPVatZ5mcxAn9Bb1U59zzYtiG1RPcO57jSKFNNMCj9dXFhmks9YRCtbw
         srSh58sRz69zIJ7S1b/1B+kV6P1qdnCLx2Y0TgODaePUrObKhZqy2iLjlqx2hkmLNkOQ
         aGOuVC5CkGuzrX1Moraop3gLqECC7M7AsX2VaX7P4lwITNYvowRkwrXhQ6/JKG53bI6X
         xHzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771891995; x=1772496795; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bweRSyy13JW5iYuGfSQw8Rmf+z1/DCVAjagAYtz2NFs=;
        b=h9p5Hu4AebmpuXWbGnMMcptNbZmMfVpVrr9UFRCQUpHyy63x1nEdboaPIC8dcOZIaV
         79reG78+XTH/eCsHYoIM+vaPGVNH5TPdudnGKqAUShaVfzHMy9kLFncutZ3jpgOCD2/7
         6cBk8+rv9FPHTsXCFiNkp4xnaYHG4TGA7CzGu9HBsmq/IW7f2gNHi4iK5z0qsSxwN+XE
         kJWGCnHbjXfBbm03lPzQdiZHM1l7dLvye6mwuVDGs6iZF/D5t3sQuFaiCyugsnaYE2b5
         ini5rLcGKYyJE5GR7oTi8t04rYPdoBTp++f5n+fSAe2SccIjnv6s5fYPqd4VhXVYz3zB
         xhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771891995; x=1772496795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bweRSyy13JW5iYuGfSQw8Rmf+z1/DCVAjagAYtz2NFs=;
        b=HDDf3AEbV+hOHqIEqYUJdXJWCa27xdyQOTXWTIjVR4UGlTk+p0iVnkLMezg0GEIoFA
         jDjZ5rVS2FeHjK4KpkpFdLxoUQoWuQxXbrD2z4tVNYlgOERyhgNVZX/Mb/yc0wmB6QCx
         85oYO0HRsWYJNmdWjFRLW9Dt/7BhVBEOI0exderff6Jfc/KYZLBIna137boyXMN7wBhj
         X/dq7LAOYOMKPYlRYMJCeeAcO9t6DzIeKq2bMXok2V8uCw3SE2SGJxb1avr0AEd9gqV7
         cy1/xNlvhH4d4uhbt5Ve49LejxWcQDAB1OIBD2DU76102cGukg764FZ3e96Cqjw3gd0q
         K5Zw==
X-Forwarded-Encrypted: i=1; AJvYcCXsXJrtsjzkTWzuRRBuMLPKUYIMA1RFWG51STcsMMP8XE1sMO4j22Ka/7QKH9NScE+61AoPjhn0mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvqCEuE8YIZ1wnS0mzbkojfV7c8HVbpNy8PsGWVLMsJi4e3OZ5
	4WA+nwN5H+9G3dnbiwLNVTiwEOHjONxfUPkSAT0n0BVdn0yQmTi1SGqZ0DReybZhNqlQ57UTZgG
	jwiVgSVK4opT5rVuUxaCgY00m9XTnWW/8xaRjbUoY
X-Gm-Gg: AZuq6aIhE+xQTLHS5SCQYrZI40LO6Ycl1MCrmo0tELsVDYyqiVSxBUb5lgqz+axv2KU
	LtFh2gFBwVqV9j8c+JEuvk8Y7wvPd51cVnQk5DZRsmOyqfG2mb4r8hq7uwSdmIWaTt/8lxDdUfy
	wUqX54GD4JJo7NZbMeBVyiJLdCAb7htvHBevgeVHbt7yNS1/6/pO1gByDHWqHCufRIOkArK6Ufq
	3iW5i2Q2ixqwEQrwhTxiWqZ/CtSutZIRfkPcaE/rJ2mX+DJsBH0qDhWK4850DfjUA5FGWdsKWDF
	wpcT+Ksroeot8KVn5n+T+TD/aAOpnFKQCCSTgA==
X-Received: by 2002:a05:600c:3011:b0:47e:de1d:ce99 with SMTP id
 5b1f17b1804b1-483b876e3ccmr255025e9.12.1771891995111; Mon, 23 Feb 2026
 16:13:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
In-Reply-To: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 23 Feb 2026 16:13:03 -0800
X-Gm-Features: AaiRm53fe0m1UF9UR81dGOPUcovFTRZhHstytiajG9W0XdK3GHymEz_MxNhuT1c
Message-ID: <CABdmKX2+OiqobQKf5G0ABiTeW5oqXS0p1dH7wRe2H7Gwdroi0g@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "Gohad, Tushar" <tushar.gohad@intel.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12392-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tjmercier@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3EE1918027F
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 6:29=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Good day everyone,
>
> dma-buf is a powerful abstraction for managing buffers and DMA mappings,
> and there is growing interest in extending it to the read/write path to
> enable device-to-device transfers without bouncing data through system
> memory. I was encouraged to submit it to LSF/MM/BPF as that might be
> useful to mull over details and what capabilities and features people
> may need.
>
> The proposal consists of two parts. The first is a small in-kernel
> framework that allows a dma-buf to be registered against a given file
> and returns an object representing a DMA mapping. The actual mapping
> creation is delegated to the target subsystem (e.g. NVMe). This
> abstraction centralises request accounting, mapping management, dynamic
> recreation, etc. The resulting mapping object is passed through the I/O
> stack via a new iov_iter type.
>
> As for the user API, a dma-buf is installed as an io_uring registered
> buffer for a specific file. Once registered, the buffer can be used by
> read / write io_uring requests as normal. io_uring will enforce that the
> buffer is only used with "compatible files", which is for now restricted
> to the target registration file, but will be expanded in the future.
> Notably, io_uring is a consumer of the framework rather than a
> dependency, and the infrastructure can be reused.
>
> It took a couple of iterations on the list to get it to the current
> design, v2 of the series can be looked up at [1], which implements the
> infrastructure and initial wiring for NVMe. It slightly diverges from
> the description above, as some of the framework bits are block specific,
> and I'll be working on refining that and simplifying some of the
> interfaces for v3. A good chunk of block handling is based on prior work
> from Keith that was pre DMA mapping buffers [2].
>
> Tushar was helping and mention he got good numbers for P2P transfers
> compared to bouncing it via RAM. Anuj, Kanchan and Nitesh also
> previously reported encouraging results for system memory backed
> dma-buf for optimising IOMMU overhead, quoting Anuj:
>
> - STRICT: before =3D 570 KIOPS, after =3D 5.01 MIOPS
> - LAZY: before =3D 1.93 MIOPS, after =3D 5.01 MIOPS
> - PASSTHROUGH: before =3D 5.01 MIOPS, after =3D 5.01 MIOPS
>
> [1] https://lore.kernel.org/io-uring/cover.1763725387.git.asml.silence@gm=
ail.com/
> [2] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.c=
om/
> --
> Pavel Begunkov
>

Hi, I'm interested in this topic. I'm guessing this will be in the FS track=
?

Thanks,
T.J.

