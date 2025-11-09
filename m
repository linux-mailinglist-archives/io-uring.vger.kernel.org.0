Return-Path: <io-uring+bounces-10480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F45C44683
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 20:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A23F23AC771
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 19:56:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E5324A049;
	Sun,  9 Nov 2025 19:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h3xv8v/B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F178720A5E5
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 19:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762718156; cv=none; b=t7QX2e8bXmL7xYbQACI3ydl5+4GUvDqBhyTrpy7ALpUcBAFP0vxknXGq2W4AU9E2ScHGZ1uuzbwoKTViI10AGnlPNslkIF6hwSo42WhmAX794bmaAPQ0woiNwa36gxJlRnPLmGABvsQ4cxOJzgRL8o83bAvke94h9DCCBxTSQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762718156; c=relaxed/simple;
	bh=Ji6DwMlMN8CaxkUNYoWO0yeIXZAwhuvFRKjf56mogUA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EECwfngjEMpaQxdUgGpyaQnkPo2URLYDmHQ6jbgvyjbikMcQp4xxnPN+1XkKFcmy2UrBYQeWyVO4CJf+q20IPw8otFJcznN/KIepMM+J56PRUvECqLtsopEwGJqOi8dey4NnKsvyGkg18l1/rUYm9qpSdj/adwEmT7vo0Jvguic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h3xv8v/B; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b72134a5125so337103366b.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 11:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762718153; x=1763322953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcyRvQ5BWmuhxa99TkWLL6vqD6kswgiu0T8eLECURAo=;
        b=h3xv8v/BAeisJeh4XxXkOR45HsuscxT/YlpsLIyj4jSXGA0xZlWY5qLfUYb8+K31tL
         LjDs+pFpiRIR2hPrrFZeXGKd5A5XBzgHDom/Po5KjNbCPEK7E8dNL2eBh0bPvyHXEbxt
         +jexPIhXiDNgtN1Hs8DuIFRwLkPP9aW+sfK9hApf2BIs8wvlvp1zhM6gBlY++e8I5rPh
         qNxmX3huDRJum0c4rQBwRKpzMqtETmuKWHlrJKf5kHZoJ88PNl1WRkVB2/stkRT/c4/l
         DlX4rVYMPwL4YX8tbkxpA2h3P7nw5SWiZNrwD9NfMPxC3XaynVdyWBRlEWpQ3RkDXfd4
         mI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762718153; x=1763322953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HcyRvQ5BWmuhxa99TkWLL6vqD6kswgiu0T8eLECURAo=;
        b=QkiKmYr/L0903DySgjO3nG9bnjXcAWWclAxQrXaky4iyz7m+EeXw3hYFP5jZTuqzl3
         fjnzlJ5EowDAZG91GZ92RJ2+ZDUYpSxYkW4BtQHyDAWCM4yrZ83htauimoMyPUX2SEXi
         9wRMGUHBgpJB+G+2esKTP+fY3UbK0IcdNkzvnmRl7VN8cbqJmCyXRPL5XrWBd1Oa06UP
         90mKi18k2TMRspRlJcuEkKXGGH3RGx6wzZy6U0jHAzTepHIVuHASZ1xtcuS/KDf0z4IF
         Mej+w6nJh7uL8i44CcmSdUnPYjceHxav4q6qluSZph5r1aew3upIBovmH0veQXPSAVBN
         AZ6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUlCFMnxvzalmOb9j/f7Uz/DvKddA9Ffyk7xNwUpkx/MpKf22By0Yj9PdQkLHt91S/RdiRJEfLDcQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIuQ816bUSFJFPgeeNefnJveI/DGNb3bgMrKEL5ZWUa57ahDSz
	TUajOGbM6Za6gBcSsgqRDjsXtMg14Nr4vWUIjz5mPvy8biCjjnEpi1F7IhGKr1NTRpLRKeLXrM2
	lcIpAv1Q1KAgf+/MWbMvCeU0OVGTapSw=
X-Gm-Gg: ASbGncvfIomGi26ttM3De1VD7EYIVuc4AA1O2TgG7oVE/BLLSrJbu2Ll/xvF9EXkhOc
	S1gA4txIKMRG8w74HO2eL2dCtTfnla0LOUBtmr4vgm0to5grgLAQmnv+hfCpRvciFfRDBd0fQcn
	BFkd6bcXJ8ZICGv4pAa/Dg38MKaELs82CtJqQK9pwh5z49dKduVxUzu3fE7tFRxzmbaD6ExTuCv
	59DEaynN6EPMd96q9xw/HMhnLjnZidJ6/sDh47J1DEz91D8A8vuEmZYKovLjG2K+Dz6vRfkhArl
	DFQu0k21e2y07Uut6zGgYGd6cw==
X-Google-Smtp-Source: AGHT+IEJCgiSucxtulit9BfgtiUFhXxGXU3X/Af+a3d5W7s6ZwCxLSq9hCronQnPafiuMWNaswfyJjDhfpl/FqcUENI=
X-Received: by 2002:a17:907:94d1:b0:b72:1b8b:cc3 with SMTP id
 a640c23a62f3a-b72e05626c9mr673442466b.33.1762718153194; Sun, 09 Nov 2025
 11:55:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
In-Reply-To: <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 9 Nov 2025 20:55:41 +0100
X-Gm-Features: AWmQ_bliPSq7XXfs20U05pA0IPp_kEb85lD9jJkcNmzDbC2EW1Ybr__mANNaRXU
Message-ID: <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 8:18=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, 8 Nov 2025 at 22:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > These days we have very few places that import filename more than once
> > (9 functions total) and it's easy to massage them so we get rid of all
> > re-imports.  With that done, we don't need audit_reusename() anymore.
> > There's no need to memorize userland pointer either.
>
> Lovely. Ack on the whole series.
>
> I do wonder if we could go one step further, and try to make the
> "struct filename" allocation rather much smaller, so that we could fit
> it on the stack,m and avoid the whole __getname() call *entirely* for
> shorter pathnames.
>
> That __getname() allocation is fairly costly, and 99% of the time we
> really don't need it because audit doesn't even get a ref to it so
> it's all entirely thread-local.
>

I looked into this in the past, 64 definitely does not cut it. For
example take a look at these paths from gcc:
/usr/lib/gcc/x86_64-linux-gnu/12/../../../../x86_64-linux-gnu/lib/x86_64-li=
nux-gnu/Scrt1.o
/usr/lib/gcc/x86_64-linux-gnu/12/../../../../x86_64-linux-gnu/lib/../lib/Sc=
rt1.o
/usr/lib/gcc/x86_64-linux-gnu/12/../../../x86_64-linux-gnu/12/Scrt1.o
/usr/lib/gcc/x86_64-linux-gnu/12/../../../x86_64-linux-gnu/Scrt1.o

Anyhow, given that the intent is to damage-control allocation cost, I
have to point out there is a patchset to replace the current kmem
alloc/free code with sheaves for everyone which promises better
performance:
https://lore.kernel.org/linux-mm/20251023-sheaves-for-all-v1-0-6ffa2c9941c0=
@suse.cz/

I tried it and there is some improvement, but the allocator still
remains as a problem. Best case scenario sheaves code just gets better
and everyone benefits.

However, so happens I was looking at this very issue recently and I
suspect the way forward is to handroll a small per-cpu cache from
kmalloced memory. Items would be put there and removed protected by
preemption only, so it should be rather cheap without any of the
allocator boiler-plate. The bufs could be -- say -- 512 bytes in size
and would still be perfectly legal to hand off to audit as they come.
The question is how many paths need to be cached to avoid going to the
real allocator in practice -- too many would invalidate the idea.

