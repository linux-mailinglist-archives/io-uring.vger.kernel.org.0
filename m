Return-Path: <io-uring+bounces-10485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E2EC44942
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBFE63ACD4D
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D65E262D0C;
	Sun,  9 Nov 2025 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/hnEK4y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6940523D28B
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762727599; cv=none; b=WLPbz0GyNnnFgd+D47Bb0BwKOA3hCH9BYVgAd6u5laQBvMdXYQl7El+G0cbP3qk1dIIo0tR2PJ7WFJxBfkgOsceFfJeoZmKwgZsVP2OFg7ELycv3nkaHLsB2XrVlOvx5mJxVRW2m7grsdkFJx1BON+2y56LgufJIUBmeXKJLKh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762727599; c=relaxed/simple;
	bh=Ik91Thopon6Tumoas6ezzkTtn2KBhQovg72ft8rqYCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=esSDm7vXPbz+Sut2/lSte5vA4SUWIWV1DIeqPejoZaykyxGRsIu5jjO5CE9320p+qjuTTvjjrs7mgV8SaUstqGe+rbhGB4PG7AhlguSf5fTujV6A72DBcSobUP5DQ/FOje6BjSvKPF7uCTahhjfHqdG4USxDc6ZFIvxIQfjYFdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P/hnEK4y; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so440106066b.0
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762727596; x=1763332396; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ik91Thopon6Tumoas6ezzkTtn2KBhQovg72ft8rqYCA=;
        b=P/hnEK4yAKLnD+L+jif4sTXmW9R7jYg6C4PmC53R5UN2DGLB36Hyr+c0eEeiru3BWb
         MsTNYFyGdaWQuaus6zUkB+bWVWgDkvwmc5RCmAfjjfvNrBimGhFZjEm8Ag4X7TIH4VnB
         fnL00boLQp5BENHNKobIUQTuHkjK6RTfxR5ZdYVlOe81ZYt3U7NyXPzIJK976SvbrTYt
         zdkMG82OspQUM/k+vdkFnp3UpviRMm9hkiIz8dUI5jDZbpR/mj2PihcTLUySNWIeBK8R
         +cSMKPGR1LX2GjTvGDAw2/AQsC0sxyogKLSBxhkIC38LrBdNmMNnWWLuPQ9akgP2Cr90
         CxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762727596; x=1763332396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ik91Thopon6Tumoas6ezzkTtn2KBhQovg72ft8rqYCA=;
        b=ClNy1fXBrrtVncMi6gFrQIIboOXjC/H1WDrt5VhfSgasgo9axegeKaRgUunFwBofzR
         kouinx8XnELf7VoemFkWoPAHNrSRb0iuiyV477Evlw2MMUmXzJtYJT6FB6we4rDGOtU7
         ITFTaNiLe+nQY5aOO0Ai9b61ns6I3sMJUp8N84bKnqmdUIWDpZ8BYPp/WuEbPTY9iP4H
         qb9jPXWXxTZsslFIjlgShKWOx/Ug4J/bH1fZwOJSOtjac/NwRpLo7l9J09fm0Jvx3aM4
         B+JfNzveLL0UwwMfAGSp55V5asj5tfRitoM2NcLP6vjUd/uYGvqTbuKMnN5pkUlkJpGY
         jAAA==
X-Forwarded-Encrypted: i=1; AJvYcCWMFgE3mJEOIqGq0RHBWk+AHLJCTVwHSuh/nIemntsOM93zhzubLNqEM4tIEPEkYKYY7OZnr2l6eA==@vger.kernel.org
X-Gm-Message-State: AOJu0YznfkYGqj8Gd5rnqfw0S/P1AF+WV0sHCd6oY7WUxbbQN4cE/Vd6
	8NzUZwxAKbuSpOnZ9jkGYhtvJx9FoIEA7c9A5RNyE46MGDou3jrTM7VcS/Tkd4kTapD5rL+MPsP
	YZWrkJXWFSWTlr+bTg1tyIPB+OzD+5Fg=
X-Gm-Gg: ASbGncvuxbQ7kk+5hMrOUlA0GZW+mWFaNtYkClVg1KS13E+V4HAkEYBGyjuGC+B582v
	gcSLWlDgzdCyQbJDCtr3270KMeZKek/rtNN5GIBytBbEHx2mSZZQKDK/cGuGR1vuLtHl7ieIW2+
	TaH7esaqRMKUNXMtG1QjmkYshL7C3UY86aNZrz8yWQyplV2j5gn9vsdxgjIsJKShOR/qdTjvZeO
	JFQMSpuf4f/cVk4Lk1AsqG9MSPoqz/7wNDlZ8/ym6jwz+hVHeUQ4PWXBr9v2drfnk4FBFjzygpv
	FS1OKO8OAkgI4UCYOesuHMasPw==
X-Google-Smtp-Source: AGHT+IGAXuUzCiCr2UlFE5rt4GncenzIFzkwMl5gDlCHYQXhQKZkEvl0yPEuoBu5/WrR+tQ9pqCJjRMiI5J3mz/pJMo=
X-Received: by 2002:a17:907:96ab:b0:b72:588:2976 with SMTP id
 a640c23a62f3a-b72e0623e83mr653813366b.60.1762727595687; Sun, 09 Nov 2025
 14:33:15 -0800 (PST)
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
 <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com> <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com>
In-Reply-To: <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 9 Nov 2025 23:33:03 +0100
X-Gm-Features: AWmQ_blV-P87rGNnE3ChZYuu4mgdUPexUIHqMqYiR-bIQn__LoTAXByyivBDYrw
Message-ID: <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 11:29=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 9 Nov 2025 at 14:18, Mateusz Guzik <mjguzik@gmail.com> wrote:
> >
> > You would need 256 bytes to cover almost all of this.
>
> Why would you care to cover all of that?
>
> Your very numbers show that 128 bytes covers 97+% of all cases (and
> 160 bytes is at 99.8%)
>
> The other cases need to be *correct*, of course, but not necessarily
> optimized for.
>
> If we can do 97% of all filenames with a simple on-stack allocation,
> that would be a huge win.
>
> (In fact, 64 bytes covers 90% of the cases according to your numbers).
>

The programs which pass in these "too long" names just keep doing it,
meaning with a stack-based scheme which forces an extra SMAP trip
means they are permanently shafted. It's not that only a small % of
their lookups is penalized.

However, now that I wrote, I figured one could create a trivial
heuristic: if a given process had too many long names in a row, switch
to go directly to kmem going forward? Reset the flag on exec.

