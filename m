Return-Path: <io-uring+bounces-7012-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B6194A56DC0
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:32:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2CAF1893899
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53C623E32B;
	Fri,  7 Mar 2025 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfmNgOyK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D0223E25B;
	Fri,  7 Mar 2025 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365157; cv=none; b=Wayb4FZEn0xJwv/GeSMPO9NbycRjbGC2FTLtktloNwBskuLwzIFG4IYZEX+bsiv5bnB3vy6IE/3dx0SJSsHfKKTriBcRAGj+LJuCjonJBimBd3tT3EZF0E125D8z17YP7p/z8YdFK4RqOWmaPhsyf28MeMM24AyBetwrO6NRGGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365157; c=relaxed/simple;
	bh=oQf5jVqULeByozILfTBc0wkSCRMZsErZmwi6C6inhbc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OQ6IBcnY+IVUBUUUr/WXZK8SfAMHiWjLYaL8I6vqDlTBnLyi5ITxVaO370GE3RJruxVd2n6YtQGWo0vfuUgc9EpiymM3cYmWf+VuaCLRNyEJIGxH1CX5iuYY6MUrM4s4XOn3DPccYhB2lLCX1q5YPQ8HKZeo+EbDZIi9sYPF/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfmNgOyK; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac25520a289so160738266b.3;
        Fri, 07 Mar 2025 08:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741365154; x=1741969954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaMpg896xolYxOCXjW3J4K6eo5SI4eXQ21NSkDFdFAU=;
        b=OfmNgOyKKTDbmjGi8EGzN5NP50Jx8AoD0qeq1G5E+eT9U2QLOTD3OifFucuoqIN2+D
         CQv9gAZSNQkFfczR1YMvMRc1U8V5CBr2SxFjMRxNC5ptxodFlDQS+Drm0UPi2HHC3cL5
         DcZf5VH2WtK3FufO8Umd46XDkhMCG3N7xLn74JRaTs9d5WF+5tq9LisTGiZMMHnXAlYI
         nn77KIjjuQzS6L/Hb5pKNf+gtTqHt1uGoe+QkiuKsohOqOBDGey3Sau8V7Klkub+2Hbj
         WnQmdER04wQb4vo7V6FFPJqWAAJCH1SCNQAXpWoK7W1pk9kKhMlxYKE7NBpSHLZrRMRm
         c2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365154; x=1741969954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QaMpg896xolYxOCXjW3J4K6eo5SI4eXQ21NSkDFdFAU=;
        b=qfTIDDFk/F9Y94/qB3SQncJYF5cfu1+sjjVlM54rBNhzaxVVSa2OiFuaMXkS9qnOCA
         jm3+t8nQhkEwlT6adl/HX5qJj5aD2J6lCOWfD1wjbXSAKc8FmdTZImUbmPM5gXVnPb68
         NZ6INhtg9+nbz+VSpVX/cQIO3TrEtdjb6D5sxgls9rsSpHufuM1SHhgo8yi5/ukLheb4
         UEZJCHWfqZPD31rMNTfofY7Rzoei+imvaWHxUxu7Z5gkiTZDf3d6DLcwtHDXqp43smWH
         yUJDc/PP3bblmg3UPxH/9pWwTRKGAWME1VCurgaOfv+2wFt6vkNdefL5e9nk8mz1CIPe
         If5A==
X-Forwarded-Encrypted: i=1; AJvYcCUhV5BjIUEllPIMWCFTtst/BihB9RVB47QjvsnnHtEx7czcvmZFvmHVeFG9Ei8zNIGJKmOJSA==@vger.kernel.org, AJvYcCV/WKC5VOzsGJjHxdcnmU4QwU5+KxiyHUUjLvB5wYTITUFoGE/1qI8m7TYXH2bF9+cyClXbNXv2GhOxjcjA@vger.kernel.org, AJvYcCVzn+XF7X8KJvllaSV7cjovbTdKm0SQ2rs9yXxwaT6ZELhErdclUvU1t3+aOwkGf8vLn0kg4uw6rrCeOc3yCw==@vger.kernel.org, AJvYcCW4ClMe+blPt0+Z62oO5cWILZg1xPJN06Pf2vR+Vx4GfxW8PYsJQfEKG9n9ya/bRXAOs218UzT25c0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjWDhRwWXXOTvJNj3UEY3ANv5OM3pyv5UGmC+bWOscdNt5fpCV
	IEBcm4KY6BP2gJuH0TijseKRPq2tOX3ulIduB7GqYkusaP2ANiM2vs6FufGlLFlCkzWWej7bgqq
	cbBZ+oZpKsqeHL/EDPP+FWSorlos=
X-Gm-Gg: ASbGnctqe9WQLrCB0GAzotJIf96TkZW+fF9IqADsVxdISAbfdNMndIDXTa9OmDZM1h8
	+D6YJ8StzZUZf+nKOdyXPeUPAqEFf43N/r1R604YkWWxhEA71sLCRgjZwFaFU16SE8oWdZG/50t
	E1z54a8DoFL2rbMheJH4he5NCpPQ==
X-Google-Smtp-Source: AGHT+IEHF8ni2+GI59nqC7YZiklr3ZSmmj0M7EPFXeng83dy0fR9Zzo0YlX3UxQorkhiNsBZUWZ2EFCCu6lhgvLvZrI=
X-Received: by 2002:a17:907:1c97:b0:ac1:f7a6:fba9 with SMTP id
 a640c23a62f3a-ac253028efamr502883166b.53.1741365153902; Fri, 07 Mar 2025
 08:32:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161155.760949-1-mjguzik@gmail.com> <Z8seJ5QV4nxGMf-T@casper.infradead.org>
In-Reply-To: <Z8seJ5QV4nxGMf-T@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Mar 2025 17:32:20 +0100
X-Gm-Features: AQ5f1Jpjtkjmkg2E6JvEe2DIUoMG9AJrN4aWXHPE6hV4Kiokr3u8E0cnnXKhXeI
Message-ID: <CAGudoHG1VZ8eE_MmD9CPV7TEOg_ozqfHi1r_84Oqf3Ny0XNd9Q@mail.gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Matthew Wilcox <willy@infradead.org>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, audit@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:26=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Fri, Mar 07, 2025 at 05:11:55PM +0100, Mateusz Guzik wrote:
> > +++ b/include/linux/fs.h
> > @@ -2765,11 +2765,19 @@ struct audit_names;
> >  struct filename {
> >       const char              *name;  /* pointer to actual string */
> >       const __user char       *uptr;  /* original userland pointer */
> > -     atomic_t                refcnt;
> > +     union {
> > +             atomic_t        refcnt_atomic;
> > +             int             refcnt;
> > +     };
> > +#ifdef CONFIG_DEBUG_VFS
> > +     struct task_struct      *owner;
> > +#endif
> > +     bool                    is_atomic;
> >       struct audit_names      *aname;
> >       const char              iname[];
> >  };
>
> 7 (or 3) byte hole; try to pad.
>
> Would it make more sense to put the bool between aname and iname where
> it will only take one byte instead of 8?

On the stock kernel there is already a 4 byte hole between the
refcount and aname, which is where is_atomic lands with debug
disabled. I.e. no size changes in production kernels with and without
the change.

However, now that you mention it the debug owner field is misplaced --
it should have landed *after* is_atomic. Maybe Christian will be happy
to just move it, otherwise I'm going to include this in a v2.

The iname field is expected to be aligned, so I don't believe
shuffling the is_atomic flag helps anyone:
static_assert(offsetof(struct filename, iname) % sizeof(long) =3D=3D 0);

--=20
Mateusz Guzik <mjguzik gmail.com>

