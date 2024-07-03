Return-Path: <io-uring+bounces-2432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9F892677D
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:55:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F10E1C216D7
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 17:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC28185E4F;
	Wed,  3 Jul 2024 17:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRFkz+PV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41C51836CB
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720029314; cv=none; b=mxroFrY0ZtdC2AbDn7swIOvmqa5NvmpAXMavZIshAluhI/8y4uufoZcaYYIWWst5m3wR8bgLaMcXB9KrLgQkZlFlYcx8mqU8WJBNm3sFgCzXd/oFQv4VjLPslwqR7vXVFjcR0UQ/MTPpaOnb+xuB5MnjIGK9BvSncGwb7CpmnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720029314; c=relaxed/simple;
	bh=7f1Jw4HvKMPAz77zJdFLUyAdloZi7jiFu3rAdtPOMZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YI73nuvzLaY1H1pxiDiS+6lBSllyn1hv7G/Gl+Lm/OzsLBPmRdpQ5bOKkyCGm+YG0RXyGAM8m6e96yoYpLtGase3N4atc9NnePfdB1aWn3XslvjdLTLPo0gpp5qodgRzCHuuEbv8CcHjbp2nvGFgXhoaLQchj1rvaHx1qxyHqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dRFkz+PV; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a72988749f0so846670766b.0
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 10:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720029311; x=1720634111; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jBLAgZolniuYLkImL+HV9eymQn/u6hu6ZNMnsLo1ncg=;
        b=dRFkz+PVNNxOiWhMAVJ9mtzjL02jXuLf9B2nWBsrLdLnZS+tEw0kK665dewopzR5B/
         CbeUi8LtlcnnEDWRBX2MO9N3yHMgWmj8EsoL7rYgtbRbblaaxK0urKfy7rJi6v4BtSxV
         2WO/uKUjq2flvMTlh7q9iZXJ4QWCd5SG56DTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720029311; x=1720634111;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jBLAgZolniuYLkImL+HV9eymQn/u6hu6ZNMnsLo1ncg=;
        b=rOehYZI1Fe5eNnXopMjKzHejKNmc9sNBbx02OHkGQBTBtReAoOHzDPxDnTjMfcySP8
         pTaqmNoXHgEfUU15w2BbyluEr2mKoegLZl25ZO3H5q01j4K4LyXeDCEgI84tMFyaKIzy
         fY3u2V0W8Vwed8EflOSC9h7EGf8H7csILImNMJMQ4c1Eu42heN6z8KgPfO6ITEoXG5c8
         fmaz7LvDgxiJJmNWg2PBKJIgsvwQY53K1+vPPvZof484G8L+YaaDUKns1Fo9bMA0EOfe
         48Pq3AZ7pDkZPSACkFCgWGtWzsZsDAUtG+7kjXVd3pq3FNcJQWXb+FWsrl2m0NGV0yEH
         okEg==
X-Forwarded-Encrypted: i=1; AJvYcCW3FEna9g47lTtyxabX7BifpcPi+SB+ngO1FHhmd+spe4zNZI6QRnrZf3RrvQG9TMGry5o3iWWMaOnRTPAhbkaZxIyVYgR0VzQ=
X-Gm-Message-State: AOJu0Yz153zankOGe4GeWVgxfSg45XI4qjsAixnUO7Z4OmH+CxvdMq5U
	Zw5se2B0yE0ZN9voXJnIzgEviOxmISUB4PiaXnjvbgnVuyQCCWmn+8vZhQqSfqJfYu0CHtOayNe
	IW8iD/w==
X-Google-Smtp-Source: AGHT+IHN7yp5B5aItoSA72lBiGCDU4yldIzE6X3YWAKd4/ymQe8IKjNeUbUe39/qNZqZBxRzCYSAZA==
X-Received: by 2002:a17:907:971d:b0:a72:a05a:6600 with SMTP id a640c23a62f3a-a75144630d2mr937262866b.7.1720029311293;
        Wed, 03 Jul 2024 10:55:11 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72aaf63360sm529141866b.64.2024.07.03.10.55.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 10:55:10 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a724b3a32d2so672036066b.2
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 10:55:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXqBVX6k6QZbDcVzl/OSmXQVXFajPpKtO4HCL9J/XqdsHayxP+V3MY+SrQE0YZjgTCY17CG6rEIeBteqh671hAACcPLId7Mpk=
X-Received: by 2002:a17:906:7d2:b0:a72:4b31:13b5 with SMTP id
 a640c23a62f3a-a75144f61a2mr779219566b.54.1720029309600; Wed, 03 Jul 2024
 10:55:09 -0700 (PDT)
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
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site> <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
In-Reply-To: <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jul 2024 10:54:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
Message-ID: <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: Christian Brauner <brauner@kernel.org>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 10:40, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh wow. Shows just *how* long ago that was - and how long ago I looked
> at 32-bit code. Because clearly, I was wrong.

Ok, so clearly any *new* 32-bit architecture should use 'struct statx'
as 'struct stat', and at least avoid the conversion pain.

Of course, if using <asm-generic/stat.h> like loongarch does, that is
very much not what happens. You get those old models with just 'long'.

So any architecture that didn't do that 'stat == statx' and has
binaries with old stat models should just continue to have them.

It's not like we can get rid of the kernel side code for that all _anyway_.

             Linus

