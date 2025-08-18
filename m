Return-Path: <io-uring+bounces-9045-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4A8FB2B4C8
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 01:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52F5E1B63B24
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 23:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A7927603A;
	Mon, 18 Aug 2025 23:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ALV5OOfJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417C05FDA7
	for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 23:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755560033; cv=none; b=RYh77JcEDKhkvPtU1Ex/RJHMXwxkkJwikVAcBsM+j8IYP6UDhxb67OzQPlftHjJiZBVTc5loAQCwENighat5bhZxRrRfPfsmAU2VLW6YFDXpK+t3pIkzXcVTxw8ltBJC6ybTdgzEuopz8KdwR31lkk5tKYkZR8/BW+25BTKKquY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755560033; c=relaxed/simple;
	bh=OoeYFB/BvC/0eRzNt4z96d91dntS57ys6UGlVQXsAGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aPD4rmNngZWloZaAWmdAgLuKRX6G7KJoYGi1ytQWwvMpqRSkmCxNPz/BUSa0aaxUVMpqXAZNaXOP0qXhRjnNFIAlq4M35jbBKVpK3TGJ0ehSXE4XhLiLcXaHS2h/ouoK7LldajH2rf+vTgcYtNGWZqS2vAhnKhu015+DgK5J1mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ALV5OOfJ; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55cdfd57585so2064e87.1
        for <io-uring@vger.kernel.org>; Mon, 18 Aug 2025 16:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755560029; x=1756164829; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ve2DzLaZnDqnbb7Kf6oBSozuJ15Yl3sv46ZZmhVCBOo=;
        b=ALV5OOfJwrWkFApNk++CdI5JqRT1SFNkuoBR4ninRxPJOMlvyDvldgDZNL1bbqIork
         rlf1DuToLYUSz1sgNPLqDkWrU80C86K1mbWu/MihZVc83F0TTUAeeUM05iVw156UhtCK
         GKMtpjJMyquMEjMu67PLzfHsZG7Fh5J5kdfUBg1HrTUKoNCN1L+fKoUpliwjRYiqFwa4
         DGitOVsWqb0+yWyFhs8SMvHAtBAeAfS5fyKff5dtjmgO6FhOTPcnw7RZQ+mxjh06bIJU
         DmZC4VKYXrhfIPowsfQLRUeDT4YfhOHEgjm6ujaesoUkK2hRfSwcODwGpyHyA4Asp0f8
         XdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755560029; x=1756164829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ve2DzLaZnDqnbb7Kf6oBSozuJ15Yl3sv46ZZmhVCBOo=;
        b=YCJYb5oc4EfbpVsl1VVmvLWniiQ24q57Di3DwXjQulOjucMOruAGHU0i9Kzvk73PaC
         f3jiUsdu79QqBm1YpZh0FxNtr+RhnpMfMEnpMFaz8ZD/Y3622DdQZ0R9m8LYB40i/+iu
         /GxScJjjUraM1V1nSNxB5KUFd3Sw9Wl6M7vPeTG9NlIRkaFPwxcvX0DILnqDoLrMcD9v
         ifvWVyo0L9kJVbNjGSd9qqC/LxBvR/jCH7KBKOdnJADt3i2HF6/syR8C7zJPeoto1jNk
         QkZkLuLw0DXYjf0GOYSvaGrrwFFIROCU298ieT3jVAmBf984I++komu/k6wHPa4JR15Y
         cVQg==
X-Forwarded-Encrypted: i=1; AJvYcCUfwk4VLcObiXF0u8Ubem8KPybGVfMbEzVDsyITRpp7hbDqOny/abOBcDIX8KxLo4OR5XIRary1ZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi131bFt8TwS+6uQJcvz90qWDdmrcXzi3QLYgPhNgvdWUS+4yp
	DH51lqGQQV8QKKJt6aVue2HKgkxQ/ZdXA9JtLKQe1p+uEFHeT0Soz/bt56Gb7LPAhVjs5WSMe2F
	bSjNBG2D75VkxlC1j06gKEE/5ebSO2HGWtUKlCwlG
X-Gm-Gg: ASbGnctHsIqOh87lLHHFKBpTdPjHL7wPRYMMJCHbsBW/T0JAWDjEwQOV4wVU7qwYdfV
	vJR+A8TeVz/fTVIsK3pBhMxJnsLlsxJc7UexoP3ISLcCpnvzeyMlWFPKqMZ1glNxhAGjvEKFHDj
	1+sWKdKpebwL5cxvygL9kRhOdT9kzcFeD5BzdjQ70SN2MZVarlPflwO3aipqswQxpDkOlIEcUBU
	cXnai8b4D8MQ6Y8HxcGkA7X/BZjS/dme4bccEbLvYx+FI+iW8sE04o=
X-Google-Smtp-Source: AGHT+IFwQTCOO7naIVkzrh2yLXB0Ye5C7kP2H4rJJJq+y1I2xqZOOFQLhHsiWjrfXhQk7xhvimRErO3eSsYfBgTtoKg=
X-Received: by 2002:a05:6512:134d:b0:558:fd83:bac6 with SMTP id
 2adb3069b0e04-55e009c6000mr76627e87.4.1755560029185; Mon, 18 Aug 2025
 16:33:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <9b6b42be0d7fb60b12203fe4f0f762e882f0d798.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <9b6b42be0d7fb60b12203fe4f0f762e882f0d798.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 18 Aug 2025 16:33:35 -0700
X-Gm-Features: Ac12FXwfrqXSKcjrhl3FF7ja5U6Np0FPNPSAiVBM9uAKgBQErhZT7EQQpCxE7UU
Message-ID: <CAHS8izO76s61JY8SMwDar=76Ech0B_xprzc1KgSDEjaAvbdDfA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 01/23] net: page_pool: sanitise allocation order
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> We're going to give more control over rx buffer sizes to user space, and
> since we can't always rely on driver validation, let's sanitise it in
> page_pool_init() as well. Note that we only need to reject over
> MAX_PAGE_ORDER allocations for normal page pools, as current memory
> providers don't need to use the buddy allocator and must check the order
> on init.
>
> Suggested-by: Stanislav Fomichev <stfomichev@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Mina Almasry <almasrymina@google.com>

I think I noticed an unrelated bug in this code and we need this fix?

```
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 343a6cac21e3..ba70569bd4b0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -287,8 +287,10 @@ static int page_pool_init(struct page_pool *pool,
        }

        if (pool->mp_ops) {
-               if (!pool->dma_map || !pool->dma_sync)
-                       return -EOPNOTSUPP;
+               if (!pool->dma_map || !pool->dma_sync) {
+                       err =3D -EOPNOTSUPP;
+                       goto free_ptr_ring;
+               }

                if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops))=
) {
                        err =3D -EFAULT;
```

I'll send a separate fix.


--
Thanks,
Mina

