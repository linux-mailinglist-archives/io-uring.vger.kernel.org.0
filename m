Return-Path: <io-uring+bounces-11761-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4C0D38949
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:34:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 657C630181AB
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A27288530;
	Fri, 16 Jan 2026 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DYRiQWww"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADE43043D5
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768602851; cv=pass; b=mUjntcIhaXa7qqmuc3YduJFleaQlzhfi6IiRjyq+k+GFu1hP20h6nqq7cRkWRwyYZq2CeAqla5FGAtfCExEU/KntPoGHzWoL1qcxKeQmZQvaMzqxj+HhXrw3coJkn0ow4c67UHTG1LpggN0A6NpoMXB5QPHqDOdU5f3wtr+jJC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768602851; c=relaxed/simple;
	bh=ngnRdojsz7sahJ6vKMtNpNK25ocBKdo7RbojSLoUvsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TZJr4EtoPzQkyiB/i72yGRjEKULCkT1DwC46PiBG2+rhCj8KyUe7IOdxYym+jGc1NOk4f4EP19j0U3sN1Yd05d9alawBdynxlKZ2pzm0iD2Ia5uf5W6yJtnAj+NsPmCfslig305VolXDePayjULRhj7D7xVx10rvuwR3LNRAA0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DYRiQWww; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5014e8b1615so25624191cf.3
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:34:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768602849; cv=none;
        d=google.com; s=arc-20240605;
        b=DRutrFNwuB0EQp6hZFzziL3wizspPZ0BJ6VIu1up3j5w5iTzmrvvkXUkeoqRyKLFVi
         f1lWsC6FdxZOMZr+iq8U8sacVHFuzdoPKzh6W1cA+2ph9Ci5uQYjNx1Xt+EWC2Qda/p6
         HgswcUUisnidBKQ465h9y1VfTe1ryaQvPHaVcYWJ6FwpxHHSDJacO0L730ms82J70B4G
         Fq53LyO2h4IWElEZhS6w/JF4gPg85RCokHjKVUq0JkrYYreuMZv3ss4Zexe2cBoPsUiD
         DuaIZ6TBU8j4DUzlVBY8KQ5jrFPm+xGQr2CBPms/bfV6aNEZY0StBiYsLNdQR3L6QN82
         1JUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=75/NrbCEScTtCn7V32nBbQG9kbGh2kWAqzhzkaDKKF4=;
        fh=YqeM83XokxQvo1anAaMkWEXPJ1xk+pihIYA0BgscqJI=;
        b=RKQ8CFvkbB9/boS58YDxGq2ehNaVFxjUSLhsXx18wb2yvFIZOrxU7o2BOEVrKx9Dyf
         sJ13YHnWqZKcFrXb3qwmZu81hVCGsajCt+tAqiGB1VmmwhDNyiaGsOJd/MX4U7yaMTMb
         wa0vQJVqwvYZktYElKREJZKEEMfAm4/gT2gZQmz/T1MnXVeizlQ3VZbCya5dVcUt4qkT
         lHRrqSRfYqM9qfodS2U3gSOpyLTzVJBXWrdeCs/Ak0+Oa+fnL/fNIeUFpw4V8LmOZlgr
         h/TcwMla/vBMNlkPmhClhk4tV+l2RcIxLJcVq73Ar/MGxkwT5wDhhm+I6DhkjWCKEayp
         B9og==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768602849; x=1769207649; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=75/NrbCEScTtCn7V32nBbQG9kbGh2kWAqzhzkaDKKF4=;
        b=DYRiQWwwpUDKjPV1/tHPIPaKUPxxaV62kfC+XJe/BevWcdykQWJ7hEaqiLcpowCJtJ
         6V6Nu33gw0RnrGGWuYt4Ns0WBLHOkeM3IJH1vqrRHQPQlsni/X+QOg+z5SH9FusbMfOd
         0U7Xz6iIT4O4neA5siOifN3KIOfzjuk6KFgsT0etaldNeHESHZkUNixDQKm2zwCQOOnK
         wDCGtujhYS4KqKXvYAb/3x1pkb9XTaLV7ra+0GtnmCxUvYrD5RsESoyAw7ShqgRKIWCe
         CHMRMkvbPjWKO3ML/SyjDQW5AcPMUieK2zld6VswgqA7RHVayyCTrL/gB8lUcHgcnkSq
         06FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768602849; x=1769207649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=75/NrbCEScTtCn7V32nBbQG9kbGh2kWAqzhzkaDKKF4=;
        b=GeasAcE1TZ9/IQOSHXHwXt12dS6Gro1X9B9/mb5THtitZAA2hPg+FE11i/jkgfLxho
         hEio+fJOOKgO7NvVYA0KtQbgZHANIwsQHJWfBIq1pDwhZXUD0FQV15o362d0BHRFxwNi
         MA/OWwi0fAE5Euw7YSd6Hvl9VwVBG3VGZUg+e6bXTGKmflRwXM9BlR/6InoNizzS4po9
         DpMcjSl41q027mbZkP5/UvHhQRaYAcOsxBtcq0+oDqFtrpbTLxv7u7gNezM0OyuhvuEg
         /UzUtCX/F7xuoGRnI54wo/3ddshXOBF9RQQ4KdeQXhi5GobnseKfyvFVUg41bNCDXZlr
         yXjg==
X-Forwarded-Encrypted: i=1; AJvYcCWP7OSAyO0zwOhKTri75g45O5JiN02rW/6ia/2t/t1hsYOBMy62naQ9yGPVZH7UVorjsxCHrlxYFw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxdhob11BjCfIkn20QvM/NC97o0nbC7Jg5uQJSZmCqDZMwlzj06
	KSE1D/+eGmYonqlXEkjRsx+9pn+388lGlxCgdGCRcJ67bpOHrHwkoBP/vUM5yLEEaU3OBpRlx3H
	M2eS78ojZ/yVJoVlWVwZXaIrm6Vauwyg=
X-Gm-Gg: AY/fxX5McJnNQ0ySpgNtWQCiMJ0DYV7uWJ5MxjFBCEf4FC19rbckkJwP3HldHzxX6t6
	5Qc3qMJK4+WrSe0JgdRloe1JIFWjAToMBv+LBo1z3KCbaEOPQhWILU/4bfxUaA8JMeoq451gSY3
	r9/4hIAcITfaS879/fuh8kDyhZOyuSDo+zzzxDSNIEONfkD8IdAiFDhl4HfHk0+JSt5sWWE+MtY
	gcYjpPx3+h97Zx+0D+OF05jGI1sxmTlFnyZkAyUqavAhIaq8FQT/kCpvDLOnOInBodhjw==
X-Received: by 2002:a05:622a:11d6:b0:501:19f9:3267 with SMTP id
 d75a77b69052e-502a1e1d28bmr63451541cf.6.1768602848961; Fri, 16 Jan 2026
 14:34:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-15-joannelkoong@gmail.com> <a27b24fe-659e-4aa1-830c-7096a3c293b8@ddn.com>
In-Reply-To: <a27b24fe-659e-4aa1-830c-7096a3c293b8@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 16 Jan 2026 14:33:58 -0800
X-Gm-Features: AZwV_QiiMEB70mjQQtE-ONSiuvMpiyLjC7vn_qltG5J3j8DN9QJHbzP9RyC58ds
Message-ID: <CAJnrk1ZC0x14Oub=_Ah0zdEo6Rhy7Q5c4DkY-bNbeae+Tdb52Q@mail.gmail.com>
Subject: Re: [PATCH v3 14/25] fuse: refactor io-uring header copying to ring
To: Bernd Schubert <bschubert@ddn.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"asml.silence@gmail.com" <asml.silence@gmail.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"csander@purestorage.com" <csander@purestorage.com>, 
	"xiaobing.li@samsung.com" <xiaobing.li@samsung.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 8:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> On 12/23/25 01:35, Joanne Koong wrote:
> > Move header copying to ring logic into a new copy_header_to_ring()
> > function. This consolidates error handling.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev_uring.c | 39 +++++++++++++++++++++------------------
> >  1 file changed, 21 insertions(+), 18 deletions(-)
> >
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index 1efee4391af5..7962a9876031 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c
> > @@ -575,6 +575,18 @@ static int fuse_uring_out_header_has_err(struct fu=
se_out_header *oh,
> >       return err;
> >  }
> >
> > +static __always_inline int copy_header_to_ring(void __user *ring,
> > +                                            const void *header,
> > +                                            size_t header_size)
>
> Minor nit: The only part I don't like too much is the __always_inline. I
> had at least two times a debug issue where I didn't get much out of the
> trace and then used for fuse.ko

Unfortunately the __always_inline here is necessary else builds with
CONFIG_HARDENED_USERCOPY will complain because there's no metadata
visibility into the header object which means __builtin_object_size()
can't correctly determine the header size.

Thanks,
Joanne

>
> +ccflags-y +=3D -g -O1\
> +             -fno-inline-functions \
> +             -fno-omit-frame-pointer \
> +             -fno-optimize-sibling-calls \
> +             -fno-strict-aliasing \
> +             -fno-delete-null-pointer-checks \
> +             -fno-common \
>
> After that the trace became very clear within 5min, before that I
> couldn't decode the trace.
>
> > +{
> > +     if (copy_to_user(ring, header, header_size)) {
> > +             pr_info_ratelimited("Copying header to ring failed.\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     return 0;
> > +}

