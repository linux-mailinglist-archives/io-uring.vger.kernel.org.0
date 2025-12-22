Return-Path: <io-uring+bounces-11247-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 08573CD7049
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 20:56:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01F463010CE3
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 19:56:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F011F2F746D;
	Mon, 22 Dec 2025 19:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="X7aI3Ycr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C1A2206AC
	for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 19:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766433376; cv=none; b=WpKcmCgiZc+H6zemTkMRpaSfqlapjw0YqAWw48EmadeQvTJ3yFCmkI60gLTWUDwwFqfVC4ZGTdGiNKcIAqW6vTEmzVM+d0sum0IvzZZadNqXqJ/6F1JVIDF44J8uZSfa7i9k3mow2J4+uzMWyKVC4k1295IM5stvXZ2bczhDr2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766433376; c=relaxed/simple;
	bh=coeM56MvAV3xd4OVuyn6Pdje9dyxK9CQLPC8ESkp4sQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=POMOEPYWAitpuDEevwoxg9RCtLnnm6tiPd44JbQVlXKuZAIhTufrgVimSaxx9lLe9qtIZMS4xNASJpLIK0vLPK3jjtwQkuq7hZ7ckaWYHygEqL0KKZtdWRElp2lMuMK+uACQLm070aUB3n7QMNBMyGJhAU/zNudscTkR6p+dXvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=X7aI3Ycr; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b8c7a4f214so208795b3a.2
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 11:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766433374; x=1767038174; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MaDcuLi/tpu2666EuwogFxqTZlhpjDdi6l89hgFe2w0=;
        b=X7aI3Ycrleh7t5t1nzAOi/fMTSBUGV+5qmv7LCbAf70jesxkCkUze+j34wHibAdvEM
         IF1CaRhTtRtpLD4d7LHarRyp2XiH5uOg60kb+Py2A4Tx/AUJ0vCSbFAtk+GUaaaZ6TVW
         c/WsP9pVRwuMUxPeL0kVlL4Q3wrpSev9red7ZWdtogAY2GCb1BuOqv0a0FTmqxgGpLc9
         JnOlCW29KFNWkTef2THjZqUaEJ3Ex4DU+FGZ65plTKdHFsFF38L44XBK2Y3LVpZGSzHo
         Mh7bziR5JRiByZKvYTmN1GKWYKMiqaNYZm00RaSGFcoSKIKBSUX838qD4JGCDIpudMnz
         6cHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766433374; x=1767038174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MaDcuLi/tpu2666EuwogFxqTZlhpjDdi6l89hgFe2w0=;
        b=JJqLUqfjxdkLD+igOW3lLHc15mhMcGdA+5e/wy2fAVausFvuMsORSRapy6nASzSByD
         G7H1R/JTgdwD2AjYH13TyMsTGutqDGC+0Bxxmsr+8TOX4p5ooPhervFG4GiX5XU8VMVA
         ofRitUMYzDKO1x+xMRKV7/6BpufiAa0rxhg09hx2N5hRjnglNBcqxMFV9kw6vlNbpaXu
         YAHxiUe2kyIxXpWxuqIRjld1RUWpc91BPAtHe3i1wNUf6rkvDZ4kflrlJeO8JbuQr6Ri
         zUNRziqsjAw0iodFll/p5Fhq1ZRX3RkSrXOqOlgDvN2IVdyzkX4nJPm7EofPt5uHk1HH
         9H0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1POj4fcN9Ut3m6LNAXPnQdVV0Q+nzE+FG1+v8cmQaVuXLSx36H+8Zd9MlFmB5qJdN360dCo3goA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfBUav2PMrYnspmEKEIWLB2hFuG50Q9uhQhchBfNCT/j/GXbmd
	VOx2MZMj+NTG4RQDuQsiJH1FfYwYqXNz0aE8mNOQLoBxHCRlc4r6ADWtWnn/lbVyjyAgpsSy+R/
	aJcTElq1os/rATwQmyE5qK/eylVu9vussJPvbr6qhf4RRrfYGskw5soA=
X-Gm-Gg: AY/fxX7b5yGmJIWXS8LJDlxu9n2Gc4iQoBSDec+Ys8BV105NLsB+GsHHKXbGHe87IAa
	nJJC2Xryhb5AugMm/5sWyPmk1Z3DvBUZ0RS4p5UR/y4RY1nTYf/YGXe/M3Wg0tXvFJ6l+Ii0uTl
	21DpmjciuUm87Otwqdn4/jhZVfcpuW8gSRJVd4uw6q5PyrCwKl+yx74Tbf3cv2+hXlcqR9Bqz5B
	9iehwB6Zp8rODJkvYMSdU0uLcd/9dnBfLt6gTyaJhT8gr4YnPnib+AV5UEYYZy/qMWC0pE=
X-Google-Smtp-Source: AGHT+IEQP8PVq3a7ntT0fDuOD6hdhdt2j3hTz6EPZJMb+SGzpqWEzuVT4WO84QRaeFaC1hC+oUyfk5A4DuQJQiRlgb8=
X-Received: by 2002:a05:7022:42a4:b0:11a:2020:ac85 with SMTP id
 a92af1059eb24-121722ecd23mr7558908c88.4.1766433373701; Mon, 22 Dec 2025
 11:56:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217123156.1100620-1-ming.lei@redhat.com> <20251217151647.193815-1-huang-jl@deepseek.com>
 <aUNcE48RnCy_rFQj@fedora> <aUNmrSVkZEMk7xmF@fedora>
In-Reply-To: <aUNmrSVkZEMk7xmF@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 22 Dec 2025 14:56:02 -0500
X-Gm-Features: AQt7F2pm2T9u8z-qcjyn3y6XrKQt2KP4_UTTF1Sv_obAzpld5A8TB7myYk_QuIk
Message-ID: <CADUfDZr8vQ9AQSONNmQVyS-BwV1T_MxfGcAWWHwQ=Ci15gMYFg@mail.gmail.com>
Subject: Re: [PATCH v6.20] io_uring/rsrc: refactor io_import_kbuf() to use
 single loop
To: Ming Lei <ming.lei@redhat.com>
Cc: huang-jl <huang-jl@deepseek.com>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	nj.shetty@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 9:28=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Thu, Dec 18, 2025 at 09:42:43AM +0800, Ming Lei wrote:
> > On Wed, Dec 17, 2025 at 11:16:47PM +0800, huang-jl wrote:
> > > The code looks correct to me.
> > >
> > > > This simplifies the logic
> > >
> > > I'm not an expert in Linux development, but from my perspective, the
> > > original version seems simpler and more readable. The semantics of
> > > iov_iter_advance() are clear and well-understood.
> > >
> > > That said, I understand the appeal of merging them into a single loop=
.
> > >
> > > > and avoids the overhead of iov_iter_advance()
> > >
> > > Could you clarify what overhead you mean? If it's the function call
> > > overhead, I think the compiler would inline it anyway. The actual
> > > iteration work seems equivalent between both approaches.
> >
> > iov_iter_advance() is global function, and it can't be inline.
> >
> > Also single loop is more readable, cause ->iov_offset can be ignored ea=
sily.
> >
> > In theory, re-calculating nr_segs isn't necessary, it is just for avoid=
ing
> > potential split, however not get idea how it is triggered. Nitesh didn'=
t
> > mention the exact reason:
> >
> > https://lkml.org/lkml/2025/4/16/351
> >
> > I will look at the reason and see if it can be avoided.
>
> The reason is in both bio_iov_bvec_set() and bio_may_need_split().

nr_segs is not just a performance optimization, it's part of the
struct iov_iter API and used by iov_iter_extract_bvec_pages(), as
huang-jl pointed out. I don't think it's a good idea to assume that
nr_segs isn't going to be used and doesn't need to be calculated
correctly.

I think this patch is a definite improvement as it reduces the number
of assumptions about the internal structure of a bvec iov_iter. The
remaining assignment to iter->iov_offset is unfortunate, but I don't
see a great way around it.

My only suggestion would be to separate out a "find first bvec" loop
and a "find last bvec" loop to make the loop body less branchy.
Something like this:
const struct bio_vec *bvec =3D imu->bvec, bvec_start;
size_t remaining;
unsigned bvec_avail;

while (offset >=3D bvec->bv_len) {
        offset -=3D bvec->bv_len;
        bvec++;
}

bvec_avail =3D bvec->bv_len - offset;
bvec_start =3D bvec;
remaining =3D len;
while (remaining > bvec_avail) {
        remaining -=3D bvec_avail;
        bvec++;
        bvec_avail =3D bvec->bv_len;
}

iov_iter_bvec(iter, ddir, start_bvec, bvec - start_bvec + 1, len);
iter->iov_offset =3D offset;

Best,
Caleb

>
> ->bi_vcnt doesn't make sense for cloned bio, and shouldn't be used as mul=
tiple
> segment hint.
>
> However, it also shows bio_split_rw() is too heavy.
>
>
> Thanks,
> Ming
>

