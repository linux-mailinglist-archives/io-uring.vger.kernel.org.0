Return-Path: <io-uring+bounces-12076-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yL9gNXsDhmmyJAQAu9opvQ
	(envelope-from <io-uring+bounces-12076-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:06:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D08FFF723
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 16:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA2FC3070B28
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 15:03:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1212749FE;
	Fri,  6 Feb 2026 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1pb0TJY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C907277029
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390210; cv=pass; b=A+1udhLrOliF/zHDjHV++7p+6mRM0+uQWe3deA1QJeABIwCyM/BGnXRuwI/TyHJkH+R+7JHz5yQOPSL/bHf2QKYeeontpy4/3UBWQtHYKQI8fWorW/dHvrTt6GZRL8SaIvwPrqqWR9gyx0DP6WNQNv2pWs6CGY93qp6b24IKx50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390210; c=relaxed/simple;
	bh=2r86Fx4ramj4tYJizidhOVEFXq0HJLOP0RBDUmIE1UQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L1Sc5Hh/ya6dJFhG6d6qLJM9rvDWZnlFubvsj6CPIBetPmwUxfzwkJCMD3adrA+uSOqaDLSCZ/YGrNyGWkKchIAru+NpFROnbDWCbD9RU647DWf7/MtY0OPwuzMptZCVE8hMRA4rgsJC2rDuI4/+PXTbKarU9p25WgLpJ1bXWiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1pb0TJY; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-658034ce0e3so3701192a12.3
        for <io-uring@vger.kernel.org>; Fri, 06 Feb 2026 07:03:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770390208; cv=none;
        d=google.com; s=arc-20240605;
        b=VFW5CYi1ahsR3+9/bZJ9dq1fH4lV/XB7Lx5BdB14TfCgrk4GBgK6RyOG7TISrrB0ky
         SeNp/YzFRz5brFYmmhoegGxCmbEsGYbD9fNZsIWijK3TrMcNK09JX0FqDJYcRtrJuBgV
         wvvkZuTdQynmSyNuUKWdYHdck+6KD8zB3ycnY9s8hA+diBWmQCtIxXKEUH84YOZ79DEE
         XwQDWk4O3LFFmDjbM8Q/GBuUhkFS9QxUhy/F704mglXuihgx1HMby4J9BvOYA2jnUQ4J
         59cXkm/cyu6wYopyXCUtO/FlVEJCSlgAq2pAF0mnD4fNRoNB2g2U9kYvRi7aKr1K5SQI
         Dxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cbNYgILYh6T0L6GkBJIakhSOuBf8eodDKh7A+HpUyVc=;
        fh=z7buc9myADk1gHMqqznNh8QVwzl9qGtLJnLNujF0SjM=;
        b=E0sY88kUQpEhYNQ10UslOc4X1ThHS+6FG0o+GMXCBtvfzX3qni5BaEr/d08W1SDoY4
         C5dCWG8Car/eGx/YnpTpftQNTVlnSAcRd9KJj3ZnW0xzIYJ4RVXug51JywSgUKPC05mh
         tJjllAB98k7laNFoPgQFO1SzYHt8PCMpSHbRwQ66mM7v8my+2uoq9PzQY0IYgEZBR8gt
         xjZwsGwvVFVE6vW1aRT33PKWPZUaJEy4tqnChph3fCynRPBIASDPvPQEB+fiwl1eB9BV
         wnrIynZYueoyl4ZCuMBnKADLeWYUg79ongkwZkd3keRaalhAQXVhJZj8EUCxUZ3C2TgZ
         /giw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770390208; x=1770995008; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cbNYgILYh6T0L6GkBJIakhSOuBf8eodDKh7A+HpUyVc=;
        b=R1pb0TJYVoZjbsMHFlQAoOiME1o0UQqzz+hseInQVsX3sGpz08Nd02QNWoZVgVn26k
         kEA+UJEyBGdKDw/mR01Egz6ACDt8Cp9PrKKgyrmXkWBS4Yu0HxxziOwbQLUXA+hyMWzO
         Cl/ZNLRn0DTjtH3jLxnubQBaIvjBDvrvc5NU9hQRVePatQ50Sd/HBjfLiCocmUL3PMpc
         NZU7hNiLVN8G70kPlk0OdNBlNukESZQU79N6BMN6NHL0+NMmnVg4vCUe1NqYeui1YuhO
         0y5a8sFUD0OLUfwFN0kDsMs6VC0RLKHxE9+IR9/e3w/TPdD0nN8WHA6vfePmiopRNplZ
         p6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770390208; x=1770995008;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbNYgILYh6T0L6GkBJIakhSOuBf8eodDKh7A+HpUyVc=;
        b=elBeLSrq7lDdUW6v9/F73vcL1Y7p4rpZ/0iFQciIZp+NEubUgLuOSphI4IQ+Y7MDBg
         6Pn1MF5mMhBc+mnE3eCMx2K5DjDI51tIo17S1goBKQgR0UgrxjhZLkudi++3E++a5ke/
         p7GY8XvnVOWRZuEC6qMmNKq5yMTbVy1agKXobaIHanEixakAIgtk69Hvnq7868Xy2jGL
         gDbJ9PIfWPCgZN53t2VBkkmqIZa9/E3O+wHYKiCnKA31XE/tiEsGRjx+vODVPzWqd2c9
         dqIAcKFbFlsnvRKrWJUXjc5DDCdIM673AgRj1MjNlNe+oyuZe/vVU7lcpW06VP+s5ux9
         cYFw==
X-Forwarded-Encrypted: i=1; AJvYcCUnIhQNqg+Id2quUbE9nrW2iMr3lzZ3eeb+cFLp1a6fKfT/3iiOcWGFPxu75TqzOcug/U8vNvKnAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOfgV+yZadW3MYjCGS5QyOxwzLb8prbsGTrb6WXRhuKSA7G0ng
	GHs47oJCyXZ/pTPDbiik4w1nkBOfaeMa1iL3MMaV4CBT/tRJCT+XEqsSQYUP32QXOU69D5fCQHG
	L3LJhHniK64eQyOias8AbT4puQK7oJA==
X-Gm-Gg: AZuq6aIFON06xEG+8FMjqS3MTKyOda/M7ici9UzKyneZQYPlboYHhzujT13W74GBaIS
	tYfRGTfloEhqnyBnDgOf5ydBe+uqmACXZsefOuBSCrQBWngEfN/YFRf4mUnmnaGzEWvAJRqT+Bh
	vRBALgYs9rrumgbu7x1SyOv1KGLI2+/sa2yCMdU053tgQTmosgcZk1BE667uugzcENeNf+gzFU4
	KnSSsEYsLJc5LrQRyL0BzkPe6roNLudmldmu5QEDrvuRLvyAS1InGAEj/wLigyeJa8xQKEi+d5a
	Dx2ms7m8ZXlq8TFoukZm95iVuylNzqtmNMMr++uALtxmJJ4CiVKzoeO/mA==
X-Received: by 2002:a05:6402:3583:b0:659:4383:c491 with SMTP id
 4fb4d7f45d1cf-65984193946mr1569160a12.33.1770390205748; Fri, 06 Feb 2026
 07:03:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763725387.git.asml.silence@gmail.com> <f57269489c4d6f670ab1f9de4d0764030d8d080c.1763725387.git.asml.silence@gmail.com>
In-Reply-To: <f57269489c4d6f670ab1f9de4d0764030d8d080c.1763725387.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 6 Feb 2026 20:32:47 +0530
X-Gm-Features: AZwV_QgZhDOY8h13FRDtMZqnV6_xaqir1VOWq2MTchb4BXyrN5R68VQhosU9bGY
Message-ID: <CACzX3Av_g5g=ssfSjHzkosEj7DMU=+xY5fpdU-zYGYc0cUWPSA@mail.gmail.com>
Subject: Re: [RFC v2 02/11] iov_iter: introduce iter type for pre-registered dma
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12076-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.974];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anuj1072538@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4D08FFF723
X-Rspamd-Action: no action

> +void iov_iter_dma_token(struct iov_iter *i, unsigned int direction,
> +                       struct dma_token *token,
> +                       loff_t off, size_t count)
> +{
> +       WARN_ON(direction & ~(READ | WRITE));
> +       *i = (struct iov_iter){
> +               .iter_type = ITER_DMA_TOKEN,
> +               .data_source = direction,
> +               .dma_token = token,
> +               .iov_offset = 0,

nit: iov_offset is getting below too. can get rid of this one.
> +               .count = count,
> +               .iov_offset = off,
> +       };

