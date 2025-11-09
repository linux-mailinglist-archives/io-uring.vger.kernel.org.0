Return-Path: <io-uring+bounces-10481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E2CC446B7
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 21:22:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E3587345FB6
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 20:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64C7223DFF;
	Sun,  9 Nov 2025 20:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euAEvstC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9121D5146
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762719753; cv=none; b=GzGuu/lynI7JY0yFrNETOsKJSYw4L+Uys0Eu4IsOdf+uDu9iClDIHv5YL10j+S5Qo2a2/nkT3MKQAWDQaULd7Z9jRS9tGP0BntJo5EPVYbIl1onHOmevGXIaeVYYu9yvVvGBELg5pskmlvfZlhUx5KEPEJOrA1IsUqshAxsFPQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762719753; c=relaxed/simple;
	bh=gMM3i9EQws9r0erlhwqEHGf1p4xwZQaG6fRH9k5nI/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWut79ZMsnIid2zymauHjyQx0N2boQKJBpEoYvtEGH8OgJiBzMbiwM3/xGdnpIT1DcXaXxlWjwJGvl5N8+vr0ERngqKXltF/BrftjdfPe7Y0ydhiM2BfMC4uD0UuTBmuOTKKSzo3F38ZHlbmYTY2zghCYOixYqATtX/Ttmcm+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euAEvstC; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7277324204so398161066b.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 12:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762719750; x=1763324550; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cb0PYNykYCL7Bou9jPgLMIeh7nnGaWAzoWBWhkWIpmo=;
        b=euAEvstCThowZ5cg7UPyK9sDwn11PFtcX5ZBQTpizq2KoKuI0/7Rxc3+oHLJR7DLQH
         YH/PZpFlGI3CGtKEn1/kXNWvW0eCr5BmYV7HTV+S/ri2boLdRdJCPCkwYBqcHZ+Lv6cm
         ylJ1yi1NQ8Yyv7kQv7Vz1P1in+bQGOWl8caLg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762719750; x=1763324550;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cb0PYNykYCL7Bou9jPgLMIeh7nnGaWAzoWBWhkWIpmo=;
        b=OpK3OkdPv+3LnQSxiQ7LNz24q0nmsgNz3IYdY+4SVU9e+jM/A5fcfcKdCmh2DyzNlW
         yi46cy1jGNUaDy8e+0N7wri+IlAL2lDIv2dcZ5VpQujpiHToFpME08IpiQJBA+gWjz5m
         9Ug/laWSkmZbXN4nlfjByCOrzRIGHMHigYgBD6WcDrNxWGxquf7UhUS/fw0G8OUQIQ7q
         czfjY2hhBpEgb5FzwKwpF7/w2k0ceHEwKTsNGzOhORSv4/Zx4RvjnXjX4HXFjYPWFEzZ
         997UYWsqHhTaS8vv2fQjzDUVti543r/SnLvGocShv5MK5f091cS+LsAdAXyt0zY3toyA
         JhDw==
X-Forwarded-Encrypted: i=1; AJvYcCUi6I9AfNdo/Y6imGiO6uUXAhdS3ESEIlmPcNfHKCXUoi++lYIwfpd91DZmT11+OmEl1gyIdFWP+w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/eIPuDLk+uJFogf182zD3SgUAeHABuxN3jlQVAFThRbMvT1Hk
	LeOAYP8YC0NPGYmz8k0L0cnwO2vkxyo5yo4a9f0gCykKpWW2fiNqJH+pBORCjgt88YWDTzCQc+E
	bH656JH8=
X-Gm-Gg: ASbGncsIaRAQjiR5u3A9AHC9U2w4OYih3mZ15icsKQT1wlHCgChBjcNsPWSnT00qUEZ
	/T47v9eQv93CiUowQVWz1Zz77FTQTVL3pkadOXalYbbbQK9UpVRZUSbOVMUtGmSW3JIQFW9ffKS
	6/nOOoKGi67ybZETgwg5EjaGEAktxL2GqWYjfPKu9V1vscV4RdCut8JQwm7Ws5kxqNz0bS79vQH
	qkdsxUs9JI5zaW8wmpHi9KK+jR3AhlARuYxmsXskPuO2Zyu99iUB9Nth4/+X9FjbWdh5NoMQRaZ
	hj/fSUI+UI72XS6k/G4JXVPrPIplJQaWkjm16s3lUgRq1orkSscJ2awQVI8dg5Y6UP9E3/rwXm3
	tXcGOXwfx90SC2blvxmDRBGxFnesV6gh5BOxffb1bOWPX4XX2uk1gZUfU39h/TQJii3XNghRXPq
	/qnfZDy7XSK5tI118gXSklFM4yzgX/4AjemUJAO1uBLEwBA2GSewq65wkvaO6Q
X-Google-Smtp-Source: AGHT+IH2plSIRDRGUkV3BnPiHtbuLVdK7uh9dZDYxFXWdZglUalGbESxDDpMz4lQDcpIYMOSX0Pdcw==
X-Received: by 2002:a17:907:1c21:b0:b70:a9fd:1170 with SMTP id a640c23a62f3a-b72e05725a4mr517783366b.65.1762719749699;
        Sun, 09 Nov 2025 12:22:29 -0800 (PST)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf97d456sm907564366b.39.2025.11.09.12.22.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 12:22:28 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7277324204so398159966b.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 12:22:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVLnPveLeeeSKUoA1Be05c5PQL8cIssb4rxr6mDihkNMgq3i4A+M/bL4O9hGrwFg7bq0dLsY/p5yA==@vger.kernel.org
X-Received: by 2002:a17:907:60cf:b0:b6d:51f1:beee with SMTP id
 a640c23a62f3a-b72e001b360mr489809966b.0.1762719748467; Sun, 09 Nov 2025
 12:22:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
In-Reply-To: <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Nov 2025 12:22:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
X-Gm-Features: AWmQ_bkC_Y91-ng6JwGWrLQYnTWxwwp_oTGnNI2FkdTnLtXofrxPbxBR3HUVCm8
Message-ID: <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 11:55, Mateusz Guzik <mjguzik@gmail.com> wrote:
>
> I looked into this in the past, 64 definitely does not cut it.

We could easily make it be 128 bytes, I just picked 64 at random.

> Anyhow, given that the intent is to damage-control allocation cost, I
> have to point out there is a patchset to replace the current kmem
> alloc/free code with sheaves for everyone which promises better
> performance:

Oh, I'm sure sheaves will improve on the allocation path, but it's not
going to be even remotely near what a simple stack allocation will be.
Not just from an allocation cost standpoint, but just from D$ density.

But numbers talk, BS walks.

That said, I partly like my patch just because the current code in
getname_flags() is simply disgusting for all those historical reasons.
So even if we kept the allocation big - and didn't put it on the stack
- I think actually using a proper 'struct filename' allocation would
be a good change.

(That patch also avoids the double strncpy_from_user() for the long
path case, because once you don't play those odd allocation games with
"sometimes it's a 'struct filename', sometimes it's just the path
string", it's just simpler to do a fixed-size memcpy followed by a
"copy the rest of the filename from user space". Admittedly you can do
that with an overlapping 'memmove()' even with the current code, but
the code is just conceptually unnecessarily complicated for those
legacy reasons).

           Linus

