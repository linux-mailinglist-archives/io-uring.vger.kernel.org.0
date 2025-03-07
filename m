Return-Path: <io-uring+bounces-7016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9E9A56E15
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:42:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8F661883AD5
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2A023F43C;
	Fri,  7 Mar 2025 16:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QbXbRWOU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD4B23CEF7;
	Fri,  7 Mar 2025 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365614; cv=none; b=F6RuhOfssOaFTMrCY94j5/LS7eDUrRw3XBLQ2zNCZVcZglWlfETsO7P2IuW6yjF6LrbYgP767HuWbO01CQ+1je7yZxKGoqxFNNQNNdCWP6f0+qJLpsVFeUXKaqm4yez0JSCyO4fvOJZb2j5bT0C5r3cXN2XK2OSVMqYc5e70Apw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365614; c=relaxed/simple;
	bh=Kmxhyxrwjp//r+bpc2Z6eVEXPg58EqO7GXtLztsea6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9Ygx/IF3FiGyciRnc+jk1Pncd9qyMi1su6ItzoCiMu10POa+FUiYRrIip2smm4hYwNYrmRTeFBrCj5L5HI/2cQzu5Nj0E7ZaTJhH9aRO5Ho23zWG9Ri6GUbS/ReyDPFim0WzL2KAbiFRVnt82GS0/R8nIw4WA7cvJPxoFU3RBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QbXbRWOU; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab78e6edb99so319040966b.2;
        Fri, 07 Mar 2025 08:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741365611; x=1741970411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kmxhyxrwjp//r+bpc2Z6eVEXPg58EqO7GXtLztsea6k=;
        b=QbXbRWOUfA+TBm6h7g3XKLyvUt4Yk9q00pS8XHrV7FIkE/DLnLL7Yt76rhKgJZEnZA
         2Ga2NWpp7GlDDNKiXXX9rGJNkSxLTQEA1n+EBl5qxNaEiNcv7xZTM0mhwq6O5Ty98LxI
         2ZDZE3zNBThvjZZ9pax3XKFNOqYof6DoPrYz92jylP14IwQT/bIbLaT4kmFBom4prP2I
         j0v3PDATf5ZCIkkvqm/wt6B5BnbD0TcLU7SjNNbUiUdsUVq1PNYX1DoEQbcyjyQDIBp3
         KZED1XD3rUtMXFijzp8vQcSiVSZNkSnUEqGUm/octTQH3cRhPHi9mQKxEoj3OXJStPfW
         cJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365611; x=1741970411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kmxhyxrwjp//r+bpc2Z6eVEXPg58EqO7GXtLztsea6k=;
        b=D7V7uo0xcoyT0wbVPMUvWDtyiBeCl+XAFQ+z83Ylopp9/pK/0rnIA28bv1KcC9VGZE
         +ZnK1wOSQTY94DkehEA+5CMyoC7IQB8IZbPFnYSkucP4jepk87rAKcRV/mL68BXAR8RO
         gaK71ChGrmrN+RToMdAAyDb9hYg3npwlIB6Xv163d3pdLOE0W6w3tIT+JdpH8hXi4/zW
         ZYR8RV5By19+GNaE6en5bGnwYGuaH2uGF/LQpvlLY8GAMSClv3PxAo9YWFAPuFc/czMu
         DvrtwWi8/9SWFx0S09RpsZBBw5bTCSIvm+tMZhjSqHC60DMVixKf1vyKveJhNIsqFWmd
         UFnA==
X-Forwarded-Encrypted: i=1; AJvYcCU01ygQ1vrwWUxOeSsFF2GJHdbHHQ7XNYDjRw6zS9E1QDYju/estB5Tjj5fEAgIfed/CRs9YgbPmhLig22zuQ==@vger.kernel.org, AJvYcCUKwMQdL2X1KlhEMSoCQBv5MxEKcakSz8LLyaNERgTaGC/jwjYFfaBHIOCmS3cScH+NCkAbZzuqU8c=@vger.kernel.org, AJvYcCUk0iJ7qvxbd3oSIa+VSeb8VCKUoIkQxcGnh9kxtjpsuregkUsI8HQd2XI8DlVMaTIQb13z3w==@vger.kernel.org, AJvYcCWtswBeEu51bt6q4muTZfX90hRfaosQWuRnGJquG37V6uNxNQwBCybgpclAawCDFo3g32Vz9ZnivAqCSSGf@vger.kernel.org
X-Gm-Message-State: AOJu0Yzogkw4Fuaqs+QcO5EhtPrz721ujKpZJeQ89Fib5cc+pva20MQc
	S2g4nKlV6wl2eAalK29pxhSowlbTZZiwBe63ICBF41NkKPwk0lKSQm2G+yAYBCEY0jjptL+MBKi
	EzWqtPDsU5JnF6ETrzFqCsyM2Tyg=
X-Gm-Gg: ASbGncsn4YpEMc2mWR0KMqxtyAuvzflBFd9NjjzvwQzS1imZbSYpsE0BikaPehdaw12
	ZULsiXp1fBl8x3OdMhUHi+hA/go8WUMN/vD+zS/cKOHNFO2NTMmGoW40UA1A73Y/YNDO47Br45u
	6XIjtGECusinIPkAr9Ny6Ov7cZXw==
X-Google-Smtp-Source: AGHT+IGfgzupT1N78CE1t69WuHvRf4LNh39K6gwj8FK0GANT7XNKhNWDiXpUV694rg1VOA8+CxSKj8XG5jjfr767kGc=
X-Received: by 2002:a17:907:1c9c:b0:ac1:e881:8997 with SMTP id
 a640c23a62f3a-ac2525e0444mr523566066b.3.1741365610455; Fri, 07 Mar 2025
 08:40:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161155.760949-1-mjguzik@gmail.com> <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
 <CAGudoHGina_OHsbP_oz5UAtXKoKQqhv-tB6Ok63rRQHThPuy+Q@mail.gmail.com>
 <5a0ddd31-8df1-40d7-8104-30aa89a35286@kernel.dk> <CAGudoHFE8D4itzs=DC14cJpRo-SNqJTz7J4g5B0VsjrNuE0_pA@mail.gmail.com>
 <ccfd73e6-7681-4c76-bdc6-7dd7e053e078@kernel.dk>
In-Reply-To: <ccfd73e6-7681-4c76-bdc6-7dd7e053e078@kernel.dk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Mar 2025 17:39:57 +0100
X-Gm-Features: AQ5f1JrG5iu4H51JZiL5fHK8E5ZJrO7ru1XEbytlnvVJdrqmuzvzQNFK45ln3lQ
Message-ID: <CAGudoHH-q3p4miyuJwPPnZLNmLJFUhDdsgjYTGkDRJfYMrd9pg@mail.gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Jens Axboe <axboe@kernel.dk>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:38=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/7/25 9:35 AM, Mateusz Guzik wrote:
> > Since you volunteered to sort this out, I'll be happy to wait.
>
> I'll take a look start next week, don't think it should be too bad. You
> already did 90% of the work.
>

Sounds good. In the mean time there may be io_uring-unrelated feedback.

--=20
Mateusz Guzik <mjguzik gmail.com>

