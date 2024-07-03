Return-Path: <io-uring+bounces-2438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EC6D9268D0
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 21:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A63A284026
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F528188CDC;
	Wed,  3 Jul 2024 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q2y0pQhg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B681862A8
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 19:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720033526; cv=none; b=VnIQD5k9FAJEWDcPE86R2yeiTMOeTXDxeU8srjM3xS0KUB+8bwmIGxtFKTuKg4ykHd89P0Ny+V1FQwDb41CqmtxrngIz6RhdD0a9OBbr8qBrumo+2UEdHnGtxwn414qRblB/Cd5yE5fBezPUmQ0PdBaY2DbeafsSjgbg9ERraQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720033526; c=relaxed/simple;
	bh=yBaVYEswZrvbgKnS47fptzlPQ1fF8FvBjoGLyqFPLwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aXqYj4lCJd03qA4DKQnD1uv9hjP0UgEiz0BXcC1WOjEI9byc5/4A5i2+NEEeEWbPK+99tbf26GzxZi9niA6nHJhMRYPCqEL1FzJrAVfbrTfTREHiGt5J47NhtS8VekDNI2LPl8iQdiV6j93nfs0Bysz8NiWtzv0lk0UVzbXxT4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q2y0pQhg; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-58b447c511eso3294404a12.2
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 12:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720033523; x=1720638323; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/Kf3K019bVOQK2OWkQy5jBzht4Y9Q+WIcCF0i+S26bo=;
        b=Q2y0pQhglU+5brt9qIBu4Ws3qolUOehnmV4uR0qMdGXg74nHPphEdpMLS0Xyc3cG1+
         lZJTp06Lo/GBP0+yDlTj5QhsZzsFsIkoFTGLiUvTXF2ccFHgMKlKxp48cDtkUMx2JR/V
         Eu0N42+42QpMOQINo3EtI9tqZ7rMtYJeCzzOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720033523; x=1720638323;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Kf3K019bVOQK2OWkQy5jBzht4Y9Q+WIcCF0i+S26bo=;
        b=WTw/CV5EfeGJyfxhMLa5PoELJKKru0tBmHwZatqf5mQkCD87OvCX2+shjjVxp449Zq
         qx0UQkPeM33Z/mW0vRDpk+e4mmcDa3rUv8HoqKDph5Y2t7Pro4YjGJ0Wz68oTXrt5CW5
         CuY8tVc+IMKnMHmWMUuj2c2cps0b7Wuk5V6UNPRGuRCBF52tFcxZ2S4ILanwrAU3WmWh
         bBrZpJBFymzCstkA7VZr06um6vQm9F8MdBPm1FsmBTPqCmMSs8GdMLL+lUNXlZSolixn
         LXEAjvmjmHAkiKauY19Y3wiipHgGGA04Z15fw1xiA9bc7CgYcs7BmeXAts//wWfnVnfo
         TmVw==
X-Forwarded-Encrypted: i=1; AJvYcCVDMtd/S1YTUmOvr3A1S1mOT2r6ILu4Gyq7pYlu4yQUTB0snOpr1oLi0peXrdZKbIU6g8joyrEY+73Sd5m8mxlrW4mGIBxyO9E=
X-Gm-Message-State: AOJu0Yw14cUuaB4aLMQ4oFoVgQB+Vc+aaPcSVBSq8rSChAPF2GdVzOEB
	A6xPEsdW6vsXomr6OixU+S2CgfTvB2O+B1UYyErI7javGja3M097WiEZCJoCcR/1FWR2B0v/ZYI
	yVWAL7A==
X-Google-Smtp-Source: AGHT+IFUeYxgKcj5F1LDB/nwrURu+sEo/us0Bo3te8L3YYVwVWmNKdusOh0ckDTKbO1jilCqyapQPg==
X-Received: by 2002:a05:6402:2712:b0:57c:a422:677b with SMTP id 4fb4d7f45d1cf-5879ede2763mr9238536a12.8.1720033522991;
        Wed, 03 Jul 2024 12:05:22 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58613815e1csm7508739a12.44.2024.07.03.12.05.21
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 12:05:22 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a724598cfe3so709276366b.1
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 12:05:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWAVBfONMg3vj0Y3Wjw+fPOnwYKKBkrWx26vzGckU7QbIlVU3CekfAfkSiAZBn/yL9zIB7hNKK1k6RRJuPzOwITkLvjBTHcPw0=
X-Received: by 2002:a17:907:2daa:b0:a6f:6721:b065 with SMTP id
 a640c23a62f3a-a751448a5a1mr1186982066b.32.1720033521063; Wed, 03 Jul 2024
 12:05:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com> <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com> <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
 <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com> <e40b8edeea1d3747fe79a4f9f932ea4a8d891db0.camel@xry111.site>
In-Reply-To: <e40b8edeea1d3747fe79a4f9f932ea4a8d891db0.camel@xry111.site>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jul 2024 12:05:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiJh1egNXJN7AsqpE76D4LCkUQTj+RboO7O=3AFeLGesw@mail.gmail.com>
Message-ID: <CAHk-=wiJh1egNXJN7AsqpE76D4LCkUQTj+RboO7O=3AFeLGesw@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: Christian Brauner <brauner@kernel.org>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 11:48, Xi Ruoyao <xry111@xry111.site> wrote:
>
> Fortunately LoongArch ILP32 ABI is not finalized yet (there's no 32-bit
> kernel and 64-bit kernel does not support 32-bit userspace yet) so we
> can still make it happen to use struct statx as (userspace) struct
> stat...

Oh, no problem then. If there are no existing binaries, then yes,
please do that,

It avoids the compat issues too.

I think 'struct statx' is a horrid bloated thing (clearing those extra
"spare" words is a pain, and yes, the user copy for _regular_ 'stat()'
already shows up in profiles), but for some new 32-bit platform it's
definitely worth the pain just to avoid the compat code or new
structure definitions.

              Linus

