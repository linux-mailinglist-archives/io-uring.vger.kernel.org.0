Return-Path: <io-uring+bounces-9686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51450B504D0
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 20:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 061DF1C283D9
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8688C35CEBA;
	Tue,  9 Sep 2025 18:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJItl7ZR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6115627FB18
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 18:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757440902; cv=none; b=oMk6jfDw3OV/IMyNeqRSDFYMxQIwZYLrG6qirJ9QCsvagbohEprO7AUtF2MjO0YOeTHc5xN+iTKdZVmhhZgZNQzVAU2jONkjfkkw2wyiANB01isILVKuO39hBOrIi3cL+qCQsF/fN6PPmJWI5kUx+GdnBAgwwFMB8CslmobulCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757440902; c=relaxed/simple;
	bh=4jJ4vwrQYkp+N2xPfsd7uVQnm/Gczem/KStAtQyWA98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZaafD1kKEjeZFMAI8OcNpCBI/FTFLdBmurEXP7onP3WKmbUwOZIg+7lVILQPAOYXkBdHrcD3U+qAcHQQ9oPyUP7EdoEI3US7le02yre++00nNdjHDVccbHTgyWzy7aUW6PtdeP/4tw8EUrRkKaW4i5lSYwbD9+y4wnit9XDyv2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJItl7ZR; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6188b72b7caso6576284a12.2
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 11:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757440898; x=1758045698; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WGm5La2YGqWzfG7qHzDYQ/vd43mSA6C56DkDIwtwe8w=;
        b=WJItl7ZRnZVM6vjpVZtUzO64Vy7OcmXEk++k4pDMivfVu2V90ZPTCRJkUP+8rxOhYe
         QkMCPx6DmCLo1yNHI6EM39vubVzanBjNyIyms+dFF6wRhEcPSyTXzGf16GyGQsHJwY2k
         UBShaU5CKqPowacSnN6ikQmpKb9iV5586cV94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757440898; x=1758045698;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WGm5La2YGqWzfG7qHzDYQ/vd43mSA6C56DkDIwtwe8w=;
        b=CaGdoMWhO781WebXjwXC4V77WnsAlQN82uFSfOiaq0A2J7jGKKeWdyOKFoJXftMrUM
         2TgDlayn6NBf2q9g5KN7X+XE7eputAzg0E98GkLky7d+EJmn2Zy1Br76GDi8TCGqFk9H
         RnVlYUWN1stUsTZ2Phrl9bxD16wiol/6P94mvoKSBLZ/ygpR5Pr9mWDsDb9gKxZjhxac
         T2yqyquF30bpvv/xSpkIsjQrJtwZjw+jqiCBnPsTKwBzmefmIexBlE9cCY9jawUh2RUN
         YwdIC/seuMSzs7VAZ1kmZiV5i9DvbImbUbqzNvKEhhi3XBnORNvmVz71QW3c5Wj/zPEa
         EY1A==
X-Forwarded-Encrypted: i=1; AJvYcCUWmjLtZ4bj/3bap7G5H2y4L/5P3KHkH0Vq/0zL+D/M+UKDgVUph4t9frOptStAR5HOPiWIVmPQYw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLEtm7Zn9UYJmdkQRzs/upm7ury72hRcvZA1CU01YHFE6PEwAY
	O5acOq4aAaM8gd2NjlhkYCUSdotZWy/Xy4sbz1pIcL5/ZaxgenyEuxazqItETuyidhfLDCSpP7K
	K8RxKppU=
X-Gm-Gg: ASbGncuzPz5DyF78cl+Yx4aNLF6QK4hYNeKCv1HvWMtBqHws2pijTsia1nAkyXD011x
	pZiZbYk2pvXiW7YxjFqeLWbJO2jmghM2G57yPIgFuhPgvx1soxmBzSUV35KfC1ighdUpT1l0oxx
	oKqDmRn9dsF0Mq391sPLZa5aXwC6nFM/JpajFo74EkzbvqhLTqP9QQTik2jWS9odk1sL9u3R0Kw
	mujRMm9uPeYoM/RwlzLnbTguwxCW/dsqN3EI+UJAvbgKJNhhhg6/X4zK31ynXXpeKyow92UCclc
	MsH7flrkf7dC+sa325jifu+kvJTqCK5mZakPdSZArre72/GcsFRn/m6KWR8DkVLuDSDBnd7wAgn
	6DfnL5xzGeQdm2Mhfq/HAdfA8/ZDduvFTrJPM20c/7kWf8aKgt/lNAH9F2IgOq3jeJ/4Sg0Aq
X-Google-Smtp-Source: AGHT+IGMP8QjMwm4uB7iSpXSYjig/sBmeSDBLknlxl0I0bvuUYkuh9n1SQC2fYpi5P599mwIw7Tu6Q==
X-Received: by 2002:a17:906:fd82:b0:b04:71b1:7688 with SMTP id a640c23a62f3a-b04b16c3e04mr1111177266b.52.1757440898431;
        Tue, 09 Sep 2025 11:01:38 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07833ac50asm26953466b.80.2025.09.09.11.01.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 11:01:37 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so934861766b.3
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 11:01:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUgllvY6RTHl+r/MyzK9MvD3uTp22lkiXFYNQ5N7dX74DPvr71xI+s+LcTs8Md3qZ3W1H+qoCBhzg==@vger.kernel.org
X-Received: by 2002:a17:907:3e8c:b0:b04:522c:e0f7 with SMTP id
 a640c23a62f3a-b04b16bf0fcmr1058187066b.47.1757440897220; Tue, 09 Sep 2025
 11:01:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch> <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org> <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur> <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk> <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <68c062f7725c7_75db100eb@dwillia2-mobl4.notmuch> <u7jigxix5g3l274ciqkrcvg64fnrqute4vaiwn4tftfzs3cwzv@o4fyr7guogzj>
In-Reply-To: <u7jigxix5g3l274ciqkrcvg64fnrqute4vaiwn4tftfzs3cwzv@o4fyr7guogzj>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Sep 2025 11:01:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=winCxfCXfTgjfhdqkp2EXrx7fbrGookkHuAtT3Lp5xT1w@mail.gmail.com>
X-Gm-Features: Ac12FXx5QpA-3kwbUKV6WpHs60phw1MkKolvZNXPDmgvvKpYtrNovzWPkJMVvUI
Message-ID: <CAHk-=winCxfCXfTgjfhdqkp2EXrx7fbrGookkHuAtT3Lp5xT1w@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: dan.j.williams@intel.com, Jens Axboe <axboe@kernel.dk>, 
	Vlastimil Babka <vbabka@suse.cz>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Jakub Kicinski <kuba@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 10:56, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> It doesn't work reliably. Often enough maintainers massage the patch
> a bit while applying to fix minor nits and patch-id will be different.

Honestly, if you massage a patch you should probably mention it.

THAT is the kind of thing where it actually makes sense to say
"modified version of XYZ" and pointing to the original.

Look, at that point it's actually *IMPORTANT* to explicitly state that
you didn't actually apply the original patch.

This falls clearly under the "don't add links mindlessly, do it
mindfully" heading.

          Linus

