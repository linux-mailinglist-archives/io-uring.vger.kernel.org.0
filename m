Return-Path: <io-uring+bounces-11529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8AFED05B42
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 19:58:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C25AC30B2C3B
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 18:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F414322B71;
	Thu,  8 Jan 2026 18:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MbKNLD40"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F749322A13
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 18:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767897639; cv=none; b=l9RVhC94zJo/IfazHI9VEUOckStw56TrCS2rqYRWi7FgCRl4nOmZ3X/1ixOKj36SkbaspV1wLqfL5HnZq8SkZoljhGsp6x9r6ZbzHZNHVkDSqw6re+v8UL21rOS8w89oztim77w0dPD26PEnoQcSvMm47T3SOIHh+iw6iLOSz24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767897639; c=relaxed/simple;
	bh=ooqLxmotW+G7tfKKh3TGgq3X/H5IySKMnqGMs0oJPbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ciuvpNqKM3DGlGnPT8GHsEvr++9MlixwRt7mimiSpmAunVS3twVs9APJkq7RuSzI/asp0+4eVHDY3FGfdHGQOPKxfuuMaKcyT9VCGG2F9XIzAtfiI+DGQchKmkkTGDKsnpc2Gg9WLzbxYABCMyDQV4pb8zmonY7tRpqqtpH77rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=MbKNLD40; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-11bba84006dso325114c88.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 10:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767897624; x=1768502424; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PGX+LMvYyhz3zylLZxMiON1h+i4VkAFL78U+9WSJLg=;
        b=MbKNLD40iq31YVR5U2qNRmzq6qQqoxgpHejEIb5tgY+gM9q0fZQzfYvNZvsOGT3CDm
         dP7B322zNS6pob8AjrYuHUavQVvhlvY3esFXl9ZComKUzIeK27x0JBnPWWxbIITxIeI2
         M+2QWWw+udXbRMcxe3E/2sQWkNNsSwK3ByLDPByh3HbablZk+4HyrPncHzoTYkOrshmU
         Di0YJecuZ2zYmItf8tEiZSOI8Jm49AMTwh0Y2GcpVHATT0veI+bM4D8xHNA7aQFdzEsS
         8BmJYQ1eM5IjqZsulc/4jNOisFXtnR38QMRTzUAz23o6oJn4oltY92ltnJKEnkxN7Ahc
         dkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767897624; x=1768502424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0PGX+LMvYyhz3zylLZxMiON1h+i4VkAFL78U+9WSJLg=;
        b=h5zyJ0eRIE8MNBs9WUrx8I55CC9bGLZeR3dX+PO5ncdAWb42xKeoOnpfPsfLIds1Th
         wArBxsxinTqm7cmw+pMCqofI98wNG9xow6WwusibwhD8iE6uSigoIc3geiSfiHr1BPFk
         P494Zmf1OdNwBt5mCn/U/uX7L8unWtyoULZKlirkIIkTPOMazJFg0YphcGKikrasjj63
         nmYSa7brIgXir8pj2zBUtNEkozI43m6zYuWHyceQ6oTQSjhm7jzM1ZuDnpyAIVpKve8X
         HgbapIMR5m+JmXUGwgE51pDOzV5z4nVahKGxOxzwUokMIQu6R6VFABv1KBlvF3zFP8CK
         eaOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUW2WfMhs8CKVajnmmFR59ZaOuCROYvzMsjq4SLT9mBCvFdajxCW0MxEpHULoWDgfdIpcZYHhjv6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YynRhNNoYFSF5/dkFtrvDUDddmHunpJg3C2/SwYd5Y+EGxk5HCQ
	794Ok7ZELS6NVt+VaSwWFt5YSrhXXaiWHIyUr+rnPJb5P7fuicShsukUrVYJKzDHyDOnwQmVHim
	UFOyBVxCOAdoHq57KXhzSMZoMVeafwHuXHzz7Q1IGbw==
X-Gm-Gg: AY/fxX5d7N8G+HKvj3UTS399VMgtwFeunGG5KZkfg2Hi131Kd902SbMmGRL/OneErzb
	retEo6d4UkuVkWjDmrlDA6G+S2JIUhcbZOpXPcZCLTlpiXJGZ9ggEBQhrNaQseRu9aY8JkXyTSN
	XA8d4putKh7JlV4GfPcb1ouG0aofJ1JyCdzMWH3S+Ebf2vZBCxRdUEz/5VHKUoPJmkALQWrLksi
	Z1pEscyXWAtOT6KIbAZgPXy954NonHkhDsYDtPYruAJdOCWhvk1EM0pFSkyca+ihvAxz4Of
X-Google-Smtp-Source: AGHT+IH2T58GqwNDj7fa77obaAt+xTIUdv2EKDBAD5wniWy+KkYgCi6YyRbxEKWAU5J3Rp+P1Ajt7uT+j3BdVyXtsTY=
X-Received: by 2002:a05:7022:238b:b0:119:e56b:46ba with SMTP id
 a92af1059eb24-121f8b45a84mr3493011c88.4.1767897624231; Thu, 08 Jan 2026
 10:40:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-7-joannelkoong@gmail.com> <87y0mlyp31.fsf@mailhost.krisman.be>
 <CAJnrk1a_qDe22E5WYN+yxJ3SrPCLp=uFKYQ6NU2WPf-wCiZOtg@mail.gmail.com> <87ikdnzwgo.fsf@mailhost.krisman.be>
In-Reply-To: <87ikdnzwgo.fsf@mailhost.krisman.be>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 10:40:13 -0800
X-Gm-Features: AQt7F2oLCADJqW9nMFr4IyujBgodH4wp0tgVDEDonHOYfDgK480giva21DkFSZo
Message-ID: <CADUfDZrqQVRsXPbPwNNxi-WqWO5xFiTQnnhhX+0LL7c=1O-R0A@mail.gmail.com>
Subject: Re: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu, axboe@kernel.dk, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025 at 9:54=E2=80=AFAM Gabriel Krisman Bertazi <krisman@su=
se.de> wrote:
>
> Joanne Koong <joannelkoong@gmail.com> writes:
>
> > On Mon, Dec 29, 2025 at 1:07=E2=80=AFPM Gabriel Krisman Bertazi <krisma=
n@suse.de> wrote:
> >
> >>
> >> Joanne Koong <joannelkoong@gmail.com> writes:
> >>
> >> > +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
> >> > +                  unsigned issue_flags, struct io_buffer_list **bl)
> >> > +{
> >> > +     struct io_buffer_list *buffer_list;
> >> > +     struct io_ring_ctx *ctx =3D req->ctx;
> >> > +     int ret =3D -EINVAL;
> >> > +
> >> > +     io_ring_submit_lock(ctx, issue_flags);
> >> > +
> >> > +     buffer_list =3D io_buffer_get_list(ctx, buf_group);
> >> > +     if (likely(buffer_list) && likely(buffer_list->flags & IOBL_BU=
F_RING)) {
> >>
> >> FWIW, the likely construct is unnecessary here. At least, it should
> >> encompass the entire expression:
> >>
> >>     if (likely(buffer_list && buffer_list->flags & IOBL_BUF_RING))
> >>
> >> But you can just drop it.
> >
> > I see, thanks. Could you explain when likelys/unlikelys should be used
> > vs not? It's unclear to me when they need to be included vs can be
> > dropped. I see some other io-uring code use likely() for similar-ish
> > logic, but is the idea that it's unnecessary because the compiler
> > already infers it?
>
> likely/unlikely help the compiler decide whether it should reverse the
> jump to optimize branch prediction and code spacial locality for icache.
> The compiler is usually great in figuring it out by itself and, in
> general, these should only be used after profilings shows the specific
> jump is problematic, or when you know the jump will or will not be taken
> almost every time.  The compiler decision depends on heuristics (which I
> guess considers the leg size and favors the if leg), but it usually gets
> it right.

Yeah, the compiler can make a guess at the likely branch direction,
but it's not magic. Anecdotally, early return paths generally seem to
be inferred to be unlikely and if branches seemed to be inferred as
likely (and else branches therefore as unlikely). That's a good
starting point, but a programmer may well have more context to know
which direction branches are likely to go. Additionally, explicit
likely()/unlikely() annotations seem to encourage compilers to
optimize more aggressively for the likely path (e.g. splitting the
unlikely path into a separate function). I guess compilers want to
hedge their bets if they're relying on heuristics to predict the
branch direction.
The performance benefit of each likely()/unlikely() is generally
small, so I tend to agree adding them is usually a premature
optimization. But it can certainly be helpful to improve the code
generation of a hot path. And it's used widely throughout io_uring due
to the focus on maximizing performance.

>
> One obvious case where *unlikely* is useful is to handle error paths.
> The logic behind it is that the error path is obviously not the
> hot-path, so a branch misprediction or a cache miss in that path is
> just fine.

And that's the case here; the if condition is only false in the error
case where buffer_group doesn't specify a valid kernel buf ring.

>
> The usage of likely is more rare, and some usages are just cargo-cult.
> Here you could use it, as the hot path is definitely the if leg.  But
> if you look at the generated code, it most likely doesn't make any
> difference, because gcc is smart enough to handle it.

Not sure I agree about this distinction between likely() and
unlikely() in general. For example, it can make sense to annotate an
early return path with likely() to override the compiler's heuristic
that early returns are unlikely.

>
> A problem arises when likely/unlikely are used improperly, or the code
> changes and the frequency when each leg is taken changes.  Now the
> likely/unlikely is introducing mispredictions the compiler could have
> avoided and harming performance.

Yes, this is probably the biggest pitfall of likely()/unlikely(). The
additional macro call also makes the code a bit harder for a human to
parse. Commit 4ec703ec0c38 ("io_uring: fix incorrect unlikely() usage
in io_waitid_prep()") is a good example of both these problems.

>
> I wasn't gonna comment in the review, since the likely() seems harmless
> in your patch.  But what got my attention was that each separate
> expression was under a single likely() expression.  I don't think that
> makes much sense, since the hint is useful for the placement of the
> if/else legs, it should encompass the whole condition.  That's how it is
> used almost anywhere else in the kernel (there are a few occurrences
> drivers/scsi/ that also look a bit fishy, IMO).

It can absolutely make sense to use likely()/unlikely() to annotate
individual components of an && or || expression, not just a full
if/while/for/ternary condition. Since && and || are short-circuiting
operators, the compiler will often emit a branch after each boolean
operand. (For example, absent optimizations, if (a && b) ... is
translated into if (a) { if (b) ... }.)
But you're totally correct that likely(A && B) implies likely(A) &&
likely(B), so there's no need to separately annotate each of the
operands to the &&s here.

Best,
Caleb

