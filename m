Return-Path: <io-uring+bounces-5233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86B609E438A
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 19:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AD99166012
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CF717E8F7;
	Wed,  4 Dec 2024 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vm+5Npo0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84A13D561;
	Wed,  4 Dec 2024 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733337617; cv=none; b=jdWbNNptHJ73YrRk1wkwUQqR/7ea+smIR7oedmn2YxVAkPGs23zv2ZxVJL9HOoi0TtNNzyQgpDwVTzIraa3//HpUWzOML8GqZUeaJLKiPdAzB2muyffMCOBkhYwHQhZZbIeiGEn8SemVI1U0+MddjPXNbB+zreElnJEj2wHIK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733337617; c=relaxed/simple;
	bh=W5eUH4+xjdTLDb2VHEFa0WbFUVbXITQxDDl27zH/7aY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IdG3cPf1kCTxoviSbYK3cyMK5Wl3bpuWV0S7NnrvcnOiqx3zWJIVT5gxYHeOFQdJJ3OM098KdmZbA71abc8jbhcuLS9D8k9aybLHPUw109UkVA2qG5LX77pT+5LPjYTc53ILohFpKQjjirNhfl/x2Z+Z8xopYBHsSJr4mIIps88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vm+5Npo0; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ffc81cee68so235821fa.0;
        Wed, 04 Dec 2024 10:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733337614; x=1733942414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GpCZc2GVw/94uKYmnrLTCfoIaeHDL5tsZvnPc5rjRPo=;
        b=Vm+5Npo0i9NAhfH5nJAFKy/3FiZEfMGD7MX6xXI/s0VltjI6zFhgAnnKPk2I37jiyJ
         ojnFmnEMf+v0bmIDZ2Rwb1j/ek+1Ew+2r8BZJHsLJM3h8G8wAIQWv/T1VDK2JCjE6FYl
         bDELxwRX2YeRjBfDoHVmLnhiVfXTQsZr5noRqa0GU51fg6Yo3Xl13BGBtWq5wyxZUhf5
         z7b+X68ex9b8UqU+5vBtuZu2GbiljRDW/V0FOLPHd8L4r4fvLLSQ9eJ5fT18hENn6b6b
         aKP8R5mdjndMLfyaZnZ2diHnGHzJ8prv8TxIK5VC2nzcTqpNAlG0+VIH2zfBZ3TrTHbR
         APFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733337614; x=1733942414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GpCZc2GVw/94uKYmnrLTCfoIaeHDL5tsZvnPc5rjRPo=;
        b=s69kexiUKnUSKBKfCcWUz0I1JKc/RV9Frb/ZZ/AiQ1H7fsvWUIM6JpVhhAc2uDpvHu
         8ERSGkaowwSMg7gT/SP1fNZFbQvNo99uGQlbdHEKZmiYFqGeGjJ408NUgPkyv96RZYr+
         0h9RHTYTlOBZIUEYGREEkYj+yWg3er8etJdW3atN8j+JrKhcnqILbXfvDrg2p9FvXURy
         shOCr8qbOgWJwys/LofkVxk+G0tsdP+n3UH3zrAx4xGB74B5taQeVUVVbO72sFfZLNh9
         oJSjieDmclFD2CjyHfbNQJoswg0vdc5Spx0YVie6z8Zq6pkim2XwwAxBPBKbA0e1ToEh
         OhSA==
X-Forwarded-Encrypted: i=1; AJvYcCW0aolmQwKFwC+J/2KV1rRVQrRjWsZC2stu7tpEYoFt6mUJE+bAAVK0UhT9t9rwx7BV6wvB7Enabyu0w6JG@vger.kernel.org, AJvYcCWjeh3RS8HpJE8YP6fH+Xp9WXDDKqW2bj1MceDDtlCOROBZVhV5EirqCt19wLAgMphYNN5Qdxyjxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqjkD+RvDygvcWm0XXnOlr9o/iGR8GUO13FIMs1g9ulAg4u1O9
	Tt3p42+o5IgTgqENC4t27hDADA6e/JciKSAFCFWt2AE9G8h+dWxsbT2+XoFqhQCC1Zod08s70J0
	EbBjR0ug2mDyIArFpT5PypsucRrI=
X-Gm-Gg: ASbGncvf7yq6L8Q/fuwlw2zx1VYQToW0xJCrIYpPEfeXFh2ArXyMAVAlmTcknZaarcV
	oCr2baNW3cmKlEWEEaE9gopbJqX7JDmOrAFjcc6hUaiYZUgc8sJyAJArlCtvD2tVA/A==
X-Google-Smtp-Source: AGHT+IE2qxtanxrWVIp5IMZwwS5oaHm8P5sx2BpY5dJAs5ENwAdvqFN0kvG/ov+nLgJT57iKEzexuTJ/Wm2/m303j7k=
X-Received: by 2002:a05:651c:160f:b0:2ff:a7c1:8c2e with SMTP id
 38308e7fff4ca-30009cab404mr54533391fa.28.1733337613626; Wed, 04 Dec 2024
 10:40:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67505f88.050a0220.17bd51.0069.GAE@google.com> <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk> <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
 <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk> <Z1CCbyZVOXQRDz_2@casper.infradead.org>
 <CAJ-ks9k5BZ1eSezMZX2oRT8JbNDra1-PoFa+dWnboW_kT4d11A@mail.gmail.com>
In-Reply-To: <CAJ-ks9k5BZ1eSezMZX2oRT8JbNDra1-PoFa+dWnboW_kT4d11A@mail.gmail.com>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 4 Dec 2024 13:39:37 -0500
Message-ID: <CAJ-ks9mfswrDNPjbakUsEtCTY-GbEoOGkOCrfAymDbDvUFgz5g@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in sys_io_uring_register
To: Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, 
	syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 11:30=E2=80=AFAM Tamir Duberstein <tamird@gmail.com>=
 wrote:
>
> On Wed, Dec 4, 2024 at 11:25=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Wed, Dec 04, 2024 at 09:17:27AM -0700, Jens Axboe wrote:
> > > >   XA_STATE(xas, xa, index);
> > > > - return xas_result(&xas, xas_store(&xas, NULL));
> > > > + return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
> > > >  }
> > > >  EXPORT_SYMBOL(__xa_erase);
> > > >
> > > > This would explain deletion of a reserved entry returning
> > > > `XA_ZERO_ENTRY` rather than `NULL`.
> > >
> > > Yep this works.
> > >
> > > > My apologies for this breakage. Should I send a new version? A new
> > > > "fixes" patch?
> > >
> > > Since it seems quite drastically broken, and since it looks like Andr=
ew
> > > is holding it, seems like the best course of action would be to have =
it
> > > folded with the existing patch.

Is there anything I can do to help with this?

> > ... and please include an addition to the test-suite that would catch
> > this bug.
> >
> > Wait, why doesn't this one catch it?  You did run the test-suite, right=
?
> >
> >         /* xa_insert treats it as busy */
> >         XA_BUG_ON(xa, xa_reserve(xa, 12345678, GFP_KERNEL) !=3D 0);
> >         XA_BUG_ON(xa, xa_insert(xa, 12345678, xa_mk_value(12345678), 0)=
 !=3D
> >                         -EBUSY);
> >         XA_BUG_ON(xa, xa_empty(xa));
> >         XA_BUG_ON(xa, xa_erase(xa, 12345678) !=3D NULL);
> >         XA_BUG_ON(xa, !xa_empty(xa));
>
> I thought I did, but when I ran it again just now, this test did catch
> it. So there is coverage.

Matthew, would you consider a patch that migrates the xarray tests to kunit=
?

