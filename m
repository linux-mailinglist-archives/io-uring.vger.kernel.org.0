Return-Path: <io-uring+bounces-10484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F26D0C4490D
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:29:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACF073AB76C
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE2E26C3BE;
	Sun,  9 Nov 2025 22:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tzn7/aj3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF182594B9
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762727368; cv=none; b=WZzWSxNhtL2FXuiyjed6nw3nKwxLp/fHUR8j7ZjiPje4faEwARzxcTjfydB5McRULU6rLiHvYZk62Oj7IDZCn3hZNQF2C6cjE0T1/hkEjy+y7vMsOajGAbjxyW709GSyILoxrp8M2la8lN76ubIrNN+x4uA0sfyjq8EmwGrhDvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762727368; c=relaxed/simple;
	bh=XyKRq+klY1XpCUw5LERZ+VW2+vF/uljQ+cnRU4sIHJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/mRNhM2/nJv2CSg9POzDZl1CHtA35GZA5gs0MxUCV4EbYh5QIjxXT+UhOUDrud7kIjqYW1z5xDd+B87ik0tU1TbWiqjnNeyjnub/iqtRQn/vGpPlAuQfn5siE8MtJ4MuXCge0pfUn7b4C4JRAzx7DB604JVBqnxjdCizDo9fkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tzn7/aj3; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640f4b6836bso4359245a12.3
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762727365; x=1763332165; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FPZie8eb8w8Uk6fiaOTQBcY1xriqA9OV/bgfwL+5Tjg=;
        b=Tzn7/aj3BhDW9ohDP+rt6zmoyCzqbgjkzH+fxWFfrejkvYO5qFvVZ69jpTQxRwQVXz
         I2Qexmn5H2/P2Fq6MFbcUq8vy+keVZz/5GrhDExX5NSAlpP3bywfKvWfo/mwn/PL7fm4
         kMdxNeNAOhGqAWc+ZrqPW9LDLJeMxoWh6L0yY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762727365; x=1763332165;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FPZie8eb8w8Uk6fiaOTQBcY1xriqA9OV/bgfwL+5Tjg=;
        b=sp76XJt4drmJ79Gtr70uhYoDwgVbPeC6XZSL33vqebXofyP1PQf3IXf/S780iulTox
         8xXCl+CMy/L9BiWfFmlIOW3nTht0cVPs/q3ZLDLi2EzuyWcRqAwD6wZW3LjgxxUK+7Ri
         mO37uKdCBPjmpHmX6h4DRFOwi6QJ13S0iJb4zMLpnM9eJITLlM48e5VPQZ9XDEZNd6/V
         xjWuki3iFbXItszUn3d2eRcUg1lsMj19kkG9NDL9GDn+G63VvgWsrvIG8fPBqldpt9lE
         fHglJ0Q/oo5bTmv2lNl069ssG1qswmCz4QT9LHiStO35fSW3amz/HgZFOzNdse5OSw0A
         SFYw==
X-Forwarded-Encrypted: i=1; AJvYcCX9Vr2apVEfpC04VwTQCsQZOl12ewAn+DBYaziPOqXwfDWjrSfvq0GC3E8ezqG/GpJMx9Z/n0b0uA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdnJkaxklwUkPimsnEMn0TbsMHi/t0f4p2Cq/VFkbNc2WrP6lL
	L9ruH+oRGtj2bUEwbhvJVQMoAzzpJUjEUbqXC2ghOpOvD3/w/rnXKWDvfDL76Td6Q6GLqhrRaup
	E5wB+IhU=
X-Gm-Gg: ASbGnctxjkpg6s9MliEr/uPnK9yfwag2LFwjtw/zaH6OzMhxkGW6IuWjFnAhJroN1bJ
	dz6Ho4UryFVIYcehioJ5vPOS7hGghOeTxlCtbDVz4Ljg3wMMLZLFn3R3VCne/zzUHGBzs+Jvbwv
	vBkpsEgeGw+mrqipKWhP9kF0RDEkePYhD6t2+eC8t63qhjkuDuEgPsajbONJplmkWliAi/FnJ+H
	Ae1nbYTS2xzavo45weAc8ZuRbej+A+JRHnUEE2aVcaeQIHr/zf86k9cyMFBNc3vYpV77PrZ12xV
	2P7N1SrwdxJCsWbNA/prSNJQxM6KsqjgZeBqKRvqhuxLEAe8Sy+tLHj1JYZ2YPGO4AbVWWvwR9Y
	hLEyQUJ9HLUE3upyTEfxzNtWyIHYk5XJE9CkCx5VhIiGePDZzS+8AiBX5rK0knxLXOXk1Akh2V1
	GxOb3jr5nPxA1dIObYVLkaBrSwKIDtsv7YmotYjNwRx4o4Cq44Lw==
X-Google-Smtp-Source: AGHT+IEfoemrB+bR8SnD+0tip9pyKoX7lSiQ18dnbG+yC46efHvvJSu1lUyceKeTAJX6zEAegHGKHA==
X-Received: by 2002:a05:6402:35d1:b0:640:b99c:de83 with SMTP id 4fb4d7f45d1cf-6415e6fe664mr5213786a12.17.1762727364975;
        Sun, 09 Nov 2025 14:29:24 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f857839sm10027683a12.21.2025.11.09.14.29.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 14:29:24 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b72dc0c15abso279136566b.1
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:29:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWxAaLqagKqe2ljd7kOYNT4cI56ceCk7kaCZMNeGJzG36KCbhaTLaiyoaPgQbFzicbAeFMLmeb2jQ==@vger.kernel.org
X-Received: by 2002:a17:907:7e91:b0:b6d:9576:3890 with SMTP id
 a640c23a62f3a-b72e04ca2a7mr646520366b.45.1762727361843; Sun, 09 Nov 2025
 14:29:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
 <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com> <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com>
In-Reply-To: <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Nov 2025 14:29:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com>
X-Gm-Features: AWmQ_blmodcy0umvH9FZdE7IOt16sLGm5PW6HtUqYPgjmzsWiwn8iRr6Hrq0I0s
Message-ID: <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 14:18, Mateusz Guzik <mjguzik@gmail.com> wrote:
>
> You would need 256 bytes to cover almost all of this.

Why would you care to cover all of that?

Your very numbers show that 128 bytes covers 97+% of all cases (and
160 bytes is at 99.8%)

The other cases need to be *correct*, of course, but not necessarily
optimized for.

If we can do 97% of all filenames with a simple on-stack allocation,
that would be a huge win.

(In fact, 64 bytes covers 90% of the cases according to your numbers).

              Linus

