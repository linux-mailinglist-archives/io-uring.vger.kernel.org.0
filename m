Return-Path: <io-uring+bounces-5086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 046139DAE16
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 20:45:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAED5166368
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 19:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A609202F72;
	Wed, 27 Nov 2024 19:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1D8+9cL5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490A202F6F
	for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 19:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732736675; cv=none; b=L9N3fvrP5FEiy4AtFSaajl+AgIGJsrYmvRfEqv4EIT04DCYXOZ+z6+0eGtqvJMzBHO2tAycJJ57zdG2Bjh5MbvQVT5PrZaz9U9lfn67q3LNTp9CtEtHsiGma3AyNDf+laIKm2pZICVwVdKkSJln6/ZusJRBVil7KySrthHVkHJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732736675; c=relaxed/simple;
	bh=RM+XcEDlaulXmf6Ae4T+/BtpyHJhEChbGBi8TeWGhWg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mm5y6S2JrPCHiyH1Ba4WjDYrtocZv/ddyAqhrcCx5vJhMcGRQUVO8iR3v1/Q4n0dw4g59x6rP7JHX506Zf/vyrKKs1jca8E6cFx/mIMOB2063xLMZeZsB6RCykb/2QsIxPFDCD4ZWZsIYujGXflygRAG5kELjBEB8fl8WX41WQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1D8+9cL5; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-211eb2be4a8so6965ad.1
        for <io-uring@vger.kernel.org>; Wed, 27 Nov 2024 11:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732736673; x=1733341473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RM+XcEDlaulXmf6Ae4T+/BtpyHJhEChbGBi8TeWGhWg=;
        b=1D8+9cL537GQia7Y1vxyiJxLh/2ffrornYNRxBgqRax45NqSlsmPIC1C2e2q8rf5st
         RHNfxyCFTT5VxoVKImywtzCufryWYXtYE1iMdnBytuj2GlxmdXRZZSBGEQfK7UvsAV9R
         tFQcPS+heLFcAo5IhO+Ue4O7tXfwxu7vmvs9y5Z4WZwQL5AkEDTGUHfrgfeznUYfSVJ4
         TYuqdT0TO60QMSJGSfcDC+7Ef0czCOf9oME31UlucZtbtZJuCSwBChe8EWzG0y4WCAAQ
         lP80mQjq03Tsi/Sn8cOIKhGAfEcBDxaZhIclGghSqi3kF9XvecwmPnPrwo8XMb/LISe2
         V08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732736673; x=1733341473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RM+XcEDlaulXmf6Ae4T+/BtpyHJhEChbGBi8TeWGhWg=;
        b=nvqDlvet1aShCXwyvLb11L1buYj0VN0W6IuuvTz0ZuYkzrjzz5mmmpNohSHUsiAShN
         uTBdw+0jM6M+wlsAqX+8P5cdE1YeKon4YjoRlav9YepVD0TbGUKPARWdgXR4ot5UhFEt
         G+fIVvwj46FXz/Mgig6+al1HGTmOwzai0af8IyTDn0Ciqn474N05zgxlaFQwcsIqe9a5
         v0wuWt23+yMUEjtQlQ7IfJLTqnE2NU/OvWfaqvHykYxI99Ke6FMzv2/+mZoiqkN3SvjU
         Q642Lay7W60zGEE0khmicwK/4quOgMGDHH1mZY6XU/nGkNdPzrg1XpScaR9OkmU2oxIm
         5b3A==
X-Forwarded-Encrypted: i=1; AJvYcCWZyIOpgh+HZ8L3KI2pxXwOAWio7/nJgDVtK9Pp2SFpHaRfaZjJvQFyeE2JRhvKdZZvpVjH3Y8mag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAJHvRsRmBmY3yKPINGWFFhyiOhlBusGCRueFJ/m5AqzjGxv+q
	0kiyaaRQ5VZFG0QY5P9Az0xeiAmY9o5wZj61qxCzs02JQ1SvKZDdz/bNiVHHeS8EfwnKLOjW2Hl
	6pYlV0fQTNvC3HCjqpVXdhT/Ala0zyEIrm/jP
X-Gm-Gg: ASbGncv0gnCBpIQs/bVLi3zA8v7b46j52XXBnocEPTTSWMQ+mIyrsAmDxbjPBEsh5wp
	v1KkZvDOlwMSZ9Rwa4Tl28vxRBCeh1Daz8M3b9LVI/l9HBa1r4Z9SwnbUpRs=
X-Google-Smtp-Source: AGHT+IFtyQYRshrM5u+HXvUiRw4FYBGSFJku+93YIfswxV69/nOHH3wa18GZc0KaZ3hQyV8/86fX4kBzxP3+Ak5fT3g=
X-Received: by 2002:a17:903:2b0f:b0:20b:bc5e:d736 with SMTP id
 d9443c01a7336-215205d19c2mr144495ad.11.1732736672714; Wed, 27 Nov 2024
 11:44:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
In-Reply-To: <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Wed, 27 Nov 2024 20:43:49 +0100
Message-ID: <CAG48ez1ZCBPriyFo-cjhoNMi56WdV7O+HPifFSgbR+U35gmMzA@mail.gmail.com>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 7:09=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 11/27/24 9:57 AM, Jann Horn wrote:
> > Hi!
> >
> > In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> > to an mm_struct. This pointer is grabbed in bch2_direct_write()
> > (without any kind of refcount increment), and used in
> > bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> > which are used to enable userspace memory access from kthread context.
> > I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> > guarantees that the MM hasn't gone through exit_mmap() yet (normally
> > by holding an mmget() reference).
> >
> > If we reach this codepath via io_uring, do we have a guarantee that
> > the mm_struct that called bch2_direct_write() is still alive and
> > hasn't yet gone through exit_mmap() when it is accessed from
> > bch2_dio_write_continue()?
> >
> > I don't know the async direct I/O codepath particularly well, so I
> > cc'ed the uring maintainers, who probably know this better than me.
>
> I _think_ this is fine as-is, even if it does look dubious and bcachefs
> arguably should grab an mm ref for this just for safety to avoid future
> problems. The reason is that bcachefs doesn't set FMODE_NOWAIT, which
> means that on the io_uring side it cannot do non-blocking issue of
> requests. This is slower as it always punts to an io-wq thread, which
> shares the same mm. Hence if the request is alive, there's always a
> thread with the same mm alive as well.
>
> Now if FMODE_NOWAIT was set, then the original task could exit. I'd need
> to dig a bit deeper to verify that would always be safe and there's not
> a of time today with a few days off in the US looming, so I'll defer
> that to next week. It certainly would be fine with an mm ref grabbed.

Ah, thanks for looking into it! I missed this implication of not
setting FMODE_NOWAIT.

Anyway, what you said sounds like it would be cleaner for bcachefs to
grab its own extra reference, maybe by initially grabbing an mm
reference with mmgrab() in bch2_direct_write(), and then use
mmget_not_zero() in bch2_dio_write_continue() to ensure the MM is
stable.

What do other file systems do for this? I think they normally grab
page references so that they don't need the MM anymore when
asynchronously fulfilling the request, right? Like in
iomap_dio_bio_iter(), which uses bio_iov_iter_get_pages() to grab
references to the pages corresponding to the userspace regions in
dio->submit.iter?

