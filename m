Return-Path: <io-uring+bounces-10489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CE6C449B7
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 00:08:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4D9194E4E61
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 23:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4DF426FA6F;
	Sun,  9 Nov 2025 23:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZmcOuLFZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992FE1CAA79
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 23:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762729693; cv=none; b=ZAMqW9/l645qfMY6gux2tYjeuzr1gMgOZfgx6Me+jk/YHmCqepiI6m0HFVO6d7SLHryz7ashzly0dj4tMpxDfEY+SBBPSE+uCL/INKF5Y4cEmHECWCkklFUXAaTxaBX8fTF8vL6/szJweTgpzRxV9RWeXXg1Uf9nECufOkigKvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762729693; c=relaxed/simple;
	bh=iACxoHcoDxLWZj3kolEGP9nbhxUet6TkNrDdT2g6g6A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cZFvGB65EwxgTmEmR9Jub/9UHZzV3+IGbi8n/7J9mVYljBjPPjq0lhOuIROLSkiEwziieZFrdi7eWDfEK7iu6sGJpFL3AUOxSBsJJXz8EjnrlxIWtkpt5drKTUl8U2DrMvHIsGXFrWYLfCt13opcIDt3FdvlWXxeD0FeF6tQRbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZmcOuLFZ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6407e617ad4so4127674a12.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 15:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762729689; x=1763334489; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gAZXs3XadTTrsCvx/VeK6Nga0Xvd+txMXgtt9i6bijA=;
        b=ZmcOuLFZceHb71iFe7EbCUnGZvf1GBccZl7skKMvy+hQwpdvuoln+JUEo2i5So0W8W
         TzLlE6Eo9IqgsAuPDM4dFyqCbkvWZe8RoR+qIPn4IrtfpFoUavnEpkrdK2TsLCU7GlH2
         q+ZoKfsy9DKsJEL6WG5gc/R5pn7h/Brnlccvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762729689; x=1763334489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAZXs3XadTTrsCvx/VeK6Nga0Xvd+txMXgtt9i6bijA=;
        b=dOzpd+8JZQumyLI0syoLRctqISwKNRiK//SIO7Xg8AaeNbminAjtXeBBDyNg+NeFVt
         1+Bc6IG63QfaoYEri/xz4VxwVJH4Kj/mz1BTlyaymUmANRmqG1lhrfFoFADWiJSHcyTn
         MiIPsO6VwCiIDOaWM38GynaaqNDOmMi/rVMRi8+Blx+z8q8GSIFdQR2NZuJHxiir39K5
         LgPE7AJdB+hNszO7UIq98jG8J+RRObftCpl1oXGv31AudVrH/JRWqTh5b8uOxxzX1fp9
         XahBHkiGdKKrGfijiIf9CBw7nZkG7wtq8uQpHOZ4vWlTlceBQ7JngkNKUbOVo5RKo3Dk
         c/sA==
X-Forwarded-Encrypted: i=1; AJvYcCWMdP2PwiZtNLAJ117kT7swSiBxmuy6n2zNa7KTmD7R/qCQXJVscleXSBSIb2eQtBuy3S/tLTj5vA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPksHLgB8K839VNncJgsR0Rjn1gD267trg2pnpXeguxOPlp04o
	fk0+8k0nnKPYDG54y0FeCJRuqXxQYm56lc2W4DxPtuo612ULjdEf+ioZYb+s/L9da1qxB7q7NyR
	2oAtvLSQ=
X-Gm-Gg: ASbGncuxUw4pPZ+BG7MaijJuzSDikUigEOjpNy/VRSDOT7o4kICEThXw+nECDZi7vyP
	P2DEqizPTyN0ffvVqgUtdsGiuaSUDs2Oj91itJYsnTXFT83xpFdAGdVxWeWR/BoK0L7EiLW4+a4
	jyr9QYxW8bOTpyVOWc+Q4edW2vgEsjINcMI2XQIg3RzqwI0u8DGIZUU9YSgetjPvpmisuis8uWX
	VDTfnVhIR/DvPimGtO0+Xls45ZEPQA7O2Z9xzoSUSdDqg7vRLyQwC/VX4eEkw6+YcsOfQUWrV1j
	ORhB+xCFPFzREE3uawhxBMCDTZtZKOEwB3s+2KTXLTt8kKxqlhHP2WSxHQPy/3emppDA4aaoN5f
	BsLQTe0fz5scVZKHXWvTEhdxqH88oolDm21nC2DpxChysVPLDzMlEbngZE1efz78eYvoSfwppcG
	01F/zpbjNtEuGtOL+vuTun72KYRJ6/cXey0emST5genKGuY8GlrYwQrMYnVyaI
X-Google-Smtp-Source: AGHT+IFfcclujccGeoyz9w0LlYg/GMyOoCHeQOEHGsqDz0SmskG8zbGpRmCVN8ryI2WwJbOy81pvzw==
X-Received: by 2002:aa7:cccf:0:b0:641:57e9:c426 with SMTP id 4fb4d7f45d1cf-64157e9c51bmr4572802a12.19.1762729689541;
        Sun, 09 Nov 2025 15:08:09 -0800 (PST)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f862697sm9949427a12.25.2025.11.09.15.08.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 15:08:08 -0800 (PST)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b3e9d633b78so426000366b.1
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 15:08:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXq8LLJxFwS5xpaoTZe/eNvvH/nGP0wHBl1GI6PWZv8VSBVNFHg+PjWRy+cTP/+QxxRk79bJULXxg==@vger.kernel.org
X-Received: by 2002:a17:907:7f13:b0:b07:87f1:fc42 with SMTP id
 a640c23a62f3a-b72dfd9b02cmr669689266b.16.1762729688139; Sun, 09 Nov 2025
 15:08:08 -0800 (PST)
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
 <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com>
 <CAHk-=wj5GSLaqf+rVE6u-4-rzdUK+OM_oUnPLQoqVY4J_F0uRw@mail.gmail.com> <CAHk-=wgbn+6pGaPw1k6LsMyaPQqz4PxOqF_kN+drQvNudF_1XA@mail.gmail.com>
In-Reply-To: <CAHk-=wgbn+6pGaPw1k6LsMyaPQqz4PxOqF_kN+drQvNudF_1XA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Nov 2025 15:07:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghq+wJrgrDy=-S5TmVNkaJS5RWsQ3kFfCCwv0juoKG4w@mail.gmail.com>
X-Gm-Features: AWmQ_bnxTScKA_GtJGPpI3hrR3y54KxE0TmLEXSfNmQBESKxwdZdKzo52akvKlY
Message-ID: <CAHk-=wghq+wJrgrDy=-S5TmVNkaJS5RWsQ3kFfCCwv0juoKG4w@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 14:44, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And again: that patch will slow things down [..]

Having done a profile just to see, the regular allocation path
(getname_flags -> kmem_cache_alloc_noprof) certainly shows up.

But on that test set (kernel build), I never hit the 128-byte limit,
and interestingly putname() shows up a tiny bit more than
getname_flags().

At least one reason seems to be that the

        if (refcnt != 1) {

thing in putname() is mispredicted, and without the auditing code, the
"refcnt == 1" case is obviously the common case.

Anyway. Not a great test, and this is all the "good behavior", and all
the *real* costs in that particular path are in strncpy_from_user(),
kmem_cache_free() and kmem_cache_alloc_noprof().

And yeah, STAC/CLAC is expensive on my old Zen 2 machine, as are the
cmpxchg16b in the slab alloc/free paths.

And in the end, the actual path walking is more expensive than all of
this, as is selinux_inode_permission(). So the actual filename copying
isn't *really* all that noticeable - you have to look for it.

              Linus

