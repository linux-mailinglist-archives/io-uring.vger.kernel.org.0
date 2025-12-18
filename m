Return-Path: <io-uring+bounces-11174-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B3771CCA1D6
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9464E3007696
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D78263C8F;
	Thu, 18 Dec 2025 02:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5DaK+v/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZ8TJIdd"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BF3226D02
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766026705; cv=none; b=sMtCsw6T4R56PK1oOgHvsevrXUpx+/siM5cqicpHfa+7FAxwncICcsfYrPGAwp0nb95Mxb+Vk/+BG2mc1PMp79zPGMLmOW6buDeqRLl0G8OPQXDqyn3E1cNMbBnCpssD6PZd+127YJyz2tsybuxp/q+vwzKJtOwy2+blT3XsSrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766026705; c=relaxed/simple;
	bh=8OO16p9oJRvn3hEgBDI8gK//pMnqGDJ//aSC4aZTzQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJZG+5P0HBvU8DnQpMAx7EPDlv7ipAYwatpuiph/U5p6Hrw4x8AwtJhOOcqwWcUuWi36NdORj2eOy7kDSl65PGpLOPOLeGJ+Mf2luZfQJmHbfRjC9vYT0iEZxrUIPUafmZcgYJZlMeRoW/Rq8c5kG2+1BIgY0VYhDZVvcuJcpLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5DaK+v/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZ8TJIdd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766026702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8OO16p9oJRvn3hEgBDI8gK//pMnqGDJ//aSC4aZTzQs=;
	b=C5DaK+v/Phu8dmJ3mL5eF4H8W+CHh73L9YZjdf+6dKQPSzf2O38Qq0h7R9lhUuy93D+Fox
	qChwSuX7ORcOsERLBWEh5mwT9LqPjRr/kfye0k4731J7Fn0AVBrGnfIxLZgZ+ILP4eLP/o
	/R/1MrL96bzL9zTP2RktE8TCKRdMktE=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-PQ7OmVTAOEmi4nx7FBDXaA-1; Wed, 17 Dec 2025 21:58:21 -0500
X-MC-Unique: PQ7OmVTAOEmi4nx7FBDXaA-1
X-Mimecast-MFC-AGG-ID: PQ7OmVTAOEmi4nx7FBDXaA_1766026701
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-93f550cdb2dso110494241.1
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766026700; x=1766631500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OO16p9oJRvn3hEgBDI8gK//pMnqGDJ//aSC4aZTzQs=;
        b=aZ8TJIddOtN4gMuFWmoJbuwqyIwgv92TvYPwaHNXFCatSneOZNqEppXM3X+IhxHQF7
         YIJZLe68fg1f2k3O8MG3XzV/5y825llv1+8GGec5uqSAf/WLlDxI36BfuBdJQ0PGnHod
         Up594aZRLPyl5ckK4E38mXqT67oAy5j0y/h/pIH3nedbaXq3Ai7ohvA3/ceeAOPzPkg7
         ljAAV1Euf5jYYX+78iCyiTqcbaSw+uHq/98SuZWkP5DR8vfg2ilrrUh1ZPKvD3jnH10H
         MUjEaaXJokR2ETa2mcAD0JGdi/UcNYGT9pr2E1GU/t4jOs2wqQPTXD3oDYlxpPotpyFC
         0uvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766026700; x=1766631500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8OO16p9oJRvn3hEgBDI8gK//pMnqGDJ//aSC4aZTzQs=;
        b=T7HH+Qg6hGrAneAo/RBiI5jV6MNc9pB+3wl2+LsCBswKfq9j08XiO4TkvP2RR/VM5p
         iQgsGX+6fprku9mLfGTceyR59BnDJxP6pGCZAklvpmhMxW9HRgVIdMShsM36aW1cvOvM
         o1DZc0o8Zthdk9zkJNzbzlWvFrkGv9njBqyjp8R3F4gQrB4cUmznsNh21cycSvbbkgLA
         6FGSKlwmrfRf0DtjztX0MafigvkaDXHFUhvjCNELmOacUxnJZ4Vh7WkGn1MIOrs2AE9I
         lCSxVvkubw2AWFeD8ugmhCpzBCP0gfS8ZQ1Jxcy5savrQKa57Mcvhnz/9t+SYeAWZSsT
         kINg==
X-Forwarded-Encrypted: i=1; AJvYcCV2w2LHx2bGTgBNiEQioiDvUzS901puMUwdMwhuKyPuu82Lzsx3oTNBLB1XzjApxNcWLCWaSSZMhg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxF+tu6KOriNr4+TRmahFW2eEQnm9wFfNSh63EFKg0uW0GqZAkw
	7LYyWzh52wXtnbgZFzhppPuATl5KJ8VZM3S/kxKReVOBI6wNRFIZP4ZcQYqzHE8vMZp/DEJ+CZT
	7Pe3ld1a6la3d/gET9RV+iYWBD+qq1BALqsDWU7J5ROd5Fm9ZJM1lA7qhgRr1wugHNyjwbENT+R
	wJwzhyrpnXzvxz9L/h9Qaz+KAZ9Tys1lZPQTpvh4TaP6g=
X-Gm-Gg: AY/fxX486883ELT2i+QQ52TKHuzX8bT39fCYsUrQrakhDor4DbzrZlc+MAv+KH1mLmX
	WNVtyoVQRpjHAxbCQE9VEcqoVJIQfkF4eH/ToH9w9kzp8cbo8ccTNlzvpXbcjehEAgNZLTGscY6
	R0PuqmDrwvOO0E5DpsvtDX0De8vvm7wSL7Sp6hRZoj3cjxcAwDwRAedPUkRyYH5Lu8I3k=
X-Received: by 2002:a05:6102:f0b:b0:5df:c1b5:82e0 with SMTP id ada2fe7eead31-5e827803ccamr6424399137.32.1766026700573;
        Wed, 17 Dec 2025 18:58:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwduYIFtSkwgUZvgQRh4VxhUNQm1FWc4tHZ/qykw1gh2BTLM89pS/ThQdso2k382yWQzN1/RRp6ggGM2WuqFM=
X-Received: by 2002:a05:6102:f0b:b0:5df:c1b5:82e0 with SMTP id
 ada2fe7eead31-5e827803ccamr6424397137.32.1766026700222; Wed, 17 Dec 2025
 18:58:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217210316.188157-3-veyga@veygax.dev> <aUNLs5g3Qed4tuYs@fedora>
 <f1522c5d-febf-4e51-b534-c0ffa719d555@veygax.dev> <aUNRS1Qiaiqo1scX@kbusch-mbp>
 <80a3a680-e42c-4d4e-b613-72385d3f46d5@veygax.dev>
In-Reply-To: <80a3a680-e42c-4d4e-b613-72385d3f46d5@veygax.dev>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 18 Dec 2025 10:58:08 +0800
X-Gm-Features: AQt7F2rsbaKyMNOO0PBs-E7J-w8NUUQBpp-zuXfY_G8Le1IrmCwyBKZ64KUHMzM
Message-ID: <CAFj5m9+g-QeQhg0jwiTLqSY-8tcZ2idBUCup7d5VobLENUJ+Tg@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: fix slab-out-of-bounds in io_buffer_register_bvec
To: veygax <veyga@veygax.dev>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Caleb Sander Mateos <csander@purestorage.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 9:13=E2=80=AFAM veygax <veyga@veygax.dev> wrote:
>
> On 18/12/2025 00:56, Keith Busch wrote:
> > I believe you're supposed to use the bio_add_page() API rather than ope=
n
> > code the bvec setup.
>
> True, but I wanted fine control to prove my theory

But almost there aren't such cases for in-tree uses, :-)

Thanks,


