Return-Path: <io-uring+bounces-10488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D51C8C44966
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A08FE188B631
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A277A21B9C5;
	Sun,  9 Nov 2025 22:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Chv18WiG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA863255E43
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762728289; cv=none; b=MUwBw2SEDO+Y+obcHPRcAiGg2OFa8A+aJmy4s7HuBmHt1RULotkbSk3oRvdp6tNyGyOb5E+SDCeBNSyLqErsWS5YHDvdCBTRrEK5q4Kdhf5ZGKhLfh+AI70B2tBPvsCsG2fDGq2zraaz3JLcAvDoKlRAZuvSFJLYYHIB6YLSik0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762728289; c=relaxed/simple;
	bh=JyYqEeLnWZ0z1NADpRPZfSdR8cGolArsUHrUE2T2Vrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mitNt+K4aS3xF4G+/dHfgnTlbNoDxCZbyqqZJp0HggKMWwxeksdYFujjfYPBan4fdd1KhAX/L6e+O8pXuANDM9E5me9HD6YKfBMOPw15Lq/drNlD0tyxZFXT1EaSmHUeRikwb69G1M1VUtY/OIV2KO7PXu7kDz8zIFc0WWYS0wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Chv18WiG; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3e9d633b78so423834766b.1
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762728286; x=1763333086; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pMxRTSFq+KiC/PO/c3X5DJYPCM+6QHM19lCO2aQiEdI=;
        b=Chv18WiGl1Sl5n+nd9/tiRVWI/DpzKrHtdlsNadbT6RAP75wXtRp8mTbZYrz3dhcNv
         skqTcoyidydQhNLwiXy5Ef7388Z2qSqEcaQ2BcFNMkEJDKHFtCOEb3RS1aeEjyDkjHqj
         pz4T+JVe0rJgnmX0f5ifakfcefTDd6EuyrodI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762728286; x=1763333086;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMxRTSFq+KiC/PO/c3X5DJYPCM+6QHM19lCO2aQiEdI=;
        b=d6894p8EMZznCBLpVEnYLz3XIXLI/9UBWmG5b+62KddLi1LpiBKInr7WwmRQg7k7er
         0aVU1y/CxVfoKTqMlBTKdAAenL71OTgyxUSsATv7N9VGyks9reijKCdzUqZvcDA3TpOh
         9dQqHFSN3vp+9AaJuUBkOfko/MgPw415aklSW26bLUZ3ZWQyRpboyEy3jWAODPQl9FPW
         1v7eBr4N/Z/Enx7o8wg1SHIYjtfIsEXGXDcsEdhp4PQJSvwmoEx+hOjW2VjdO7AFSIXS
         rNjX5kFdVsqotTu3Kx7plySrIy8o00SGFNTqNS+/0LsxHGbC6WEiH0zZQz12lblIXEyz
         vlew==
X-Forwarded-Encrypted: i=1; AJvYcCXekar+JEYylrj4xmf2g0JKKbnIPXTatA1M79cq95ngQabl65bxk+Gq388hN9IyOrf3nROH4R0Bng==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLjb1078SevQdmPuWDPHzH6kix/4Bl7OOot62fyMnPbHRVJNN/
	XNAdT2UkoYuHzfu5lJ//7Sm8K8/JUmRysUw22OCFP9RuSFWZ2vagcYOs8K9B9DEnkMgHu26cTgl
	DydVwgFA=
X-Gm-Gg: ASbGnctPLQCiB+7e0q5lOEGQhjzAcB9Ue71dO015EyzN5qI8uPEPVeoP/1VOx9HEQO2
	NSOqWWL57cHpZyLABD4p6vLkF9heccBysAs1WR38WPGe6sZf7a5yBglz/vYxNrOe5daRUsbG7Mk
	GPD4GKqK2KR7CfIZEDlUZ/KSDEAeuiiMKfWWssvxSE0C5t5juW/d2GHXwXMnp9BG4PRbT94PoZx
	9wDN/qOc7tCJujOIXUjXOHbkyKG8KCn/TVaPvEqECQo8RLgjRL9hGnq4Q2ZaX8fck7+/bQ6MqDj
	r1YckvIq6Z7ZM0cfL7eEgmEAc0DOUU/8MTzeLRAQW0rJ6UrcPrScDq9ustKBavObrJb4z0URxLv
	Om6Sox1dnj2k4GXWRrXaRxv8FbGrypwUAOY1xLLeWG6/ql6xeJC2MvhbzPRG0dXJVC+gxRh7hzB
	Pd68VPeF0ZJpatzn2IzG91MS1cAwBGUnyOn3wrLHqOAtoWHyxiXgt7SRyg24Pw
X-Google-Smtp-Source: AGHT+IHETETJRfC/TuVbeAhbMQ3CJjEYrruSNmbJzt3vkkPuaH1vupFQIx2znIHLNMtPH1tncJiDpA==
X-Received: by 2002:a17:906:c155:b0:b72:6224:7e95 with SMTP id a640c23a62f3a-b72df905857mr541845966b.1.1762728285907;
        Sun, 09 Nov 2025 14:44:45 -0800 (PST)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72fcde0779sm265345766b.40.2025.11.09.14.44.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 14:44:44 -0800 (PST)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3e9d633b78so423830766b.1
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:44:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWJ0oaeHXvOVfhyHNv1+IU0nmlUstFvh9NLlVo3yBEIK1OE1FoCk7LqJZ5KsQngkKMJOFsjqp+kOA==@vger.kernel.org
X-Received: by 2002:a17:907:7b9a:b0:b3a:8070:e269 with SMTP id
 a640c23a62f3a-b72df9d994bmr743402766b.14.1762728283808; Sun, 09 Nov 2025
 14:44:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
 <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
 <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com>
 <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com>
 <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com> <CAHk-=wj5GSLaqf+rVE6u-4-rzdUK+OM_oUnPLQoqVY4J_F0uRw@mail.gmail.com>
In-Reply-To: <CAHk-=wj5GSLaqf+rVE6u-4-rzdUK+OM_oUnPLQoqVY4J_F0uRw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Nov 2025 14:44:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgbn+6pGaPw1k6LsMyaPQqz4PxOqF_kN+drQvNudF_1XA@mail.gmail.com>
X-Gm-Features: AWmQ_blFRyp2aK66FJENgGjkorwps5yaIcGGW5kQ_CdDWidiXHxD-MbAtM3Q3ZI
Message-ID: <CAHk-=wgbn+6pGaPw1k6LsMyaPQqz4PxOqF_kN+drQvNudF_1XA@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 14:41, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> We optimize for the common case.

Side note: I'm now running that second version of the patch I posted.
It boots. It seems to work.

And again: that patch will slow things down, because it doesn't
actually take advantage of any stack allocation model. So I'm not
claiming that it's an optimization in *that* form. It might _allow_
optimizing things, but as-is is only adds more allocations (but not
particularly many more)

               Linus

