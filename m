Return-Path: <io-uring+bounces-6882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 084F7A4A7D2
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0857617703B
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F42214A0BC;
	Sat,  1 Mar 2025 02:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SasezqDh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B0F25760
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740794675; cv=none; b=WRh57QinBm9yKpXVnSXMRtCBABal2TqXHtBapNff2v7dNeHYTNE17r+7/7pfT/NI2V1RzmfNw3DMi9vpOyWMCjh5IfS6PZ/mpvX4h35qL4OrAaDGAwm7UhIfsCEz6P8h40kvhDGH4NsywMP656Hl22ZojyApXbZYe2diBoLaEkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740794675; c=relaxed/simple;
	bh=9xsg0YcftDg7nvIpff5lygFDIzDA5lfF057ozLxjCcM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fKyKYSX+V6psg2XtXQyhEFp5z/9YAS/0Kmou+rshM9cK74IDmUD8y2kDftwcXINrfaZsKQwduVGpHJadlS2HExR+WHVNIeal5BZxkuPDNQpje3w+tHiNx4A5ySur5TquLVjwGeKHGUXP4rC4Tuvfe+VPOMe4kdT8lQ25IWRb08Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SasezqDh; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2fe9fd5e7f8so756102a91.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740794672; x=1741399472; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMRMpyLGkuXKFKe3vNfVg0nl7bqc/JfSPYacGN4zRuI=;
        b=SasezqDhI/1+7OVbXArHIagiutFVqnTlVM1wgwsF8XGukrguj9N7Y4ohEBnCdXMmxK
         hJ0K1PGoGngXfGIWSKLjEmXur0JZR2F14yrl9HruDXmC2cJ5ArEhAUlPCSvIU2fnJTnN
         8DgJpT+moFfbxdRkEaWhRfUzPYUVyKJ4IRCglpbKWulP4HPfjCmgTIetGL3Bc4JblgX9
         W946zchQOQx4EIDbcsuHbY9K/i0b6qwRMsGugW2fWNC35WBtgbJw5TRpv5jiX543h5Y1
         H1I5wy6C+s+EC6GmYg0EQfR0VxyWy2a8uDsvXFVo0m6AsT+854aiFoP/SU2cl7dEOpwg
         RxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740794672; x=1741399472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMRMpyLGkuXKFKe3vNfVg0nl7bqc/JfSPYacGN4zRuI=;
        b=M/TGLZ46UtkWj1lhH/xL+8D8c5jX/wCjIQcCuKEhZjIgEwd7/XsIVcXqFsj7EAiExU
         Rctg9BToeSjKikvhpZrXaCbUO4GtaVyCjM20ruCQ9c+VnH0tnQS++GBRINRugB6BoPTa
         SXl/RXbtrps16Q/Uj8UKA4MtvLCT+J6/VJv6CSQIxwXGhPy6a3OPMIHiof/Q8J+yItQQ
         Az/Y3wdYtcYqL/qdctZvzahu9OPA6phfluXqsTkQJo5DIUP47vY5kETL4ep2NIKuhnvt
         fxNbHuUZz3LzFO5JSLhJLBmOnRIvRUikfr/mKNosEC+39T8mYBoj6WxCRKYMF8LiJqcB
         Mx3A==
X-Forwarded-Encrypted: i=1; AJvYcCXNZgAAcHZtYPCw5jP3UwWYofdrG7LQE42/PoSPEKsLCIZrO4puD7T+X4dPDVf1N2cPZAERLHXBGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXc8zvv6jypT+6R7ZeoB51vokypRQM/5hk9348UG9bAeqGw219
	hW3xefYB0XuG/ACgo1iHj+DVH4xhldQGB0lcycLPmVHArfS/5W+4xmmJJCMwvFH+2IbSYxelLwS
	UNG4u+9kp5FjVqC+bx0G3kC2wow7VpaGEQSKNcs2uU1nHywX6/Q0=
X-Gm-Gg: ASbGncvGutNsM69Z3ExV3zwQ8sL1lCZh/FRLfnbQVtVTx4b6d2pbFgpsO1iY6nwQeXA
	mixDEgCXPrlbiPEyrGG7VtRP04sUm2v/HFt1u0MMp/a7SKfK6lP2/QWe2V+ZsQXHdF21H2aas8S
	xD+2KYhUvrP4w8TLdLPJOA9k0Z
X-Google-Smtp-Source: AGHT+IG9yG3AscvIs7xF7jEOslIjGL3EISGyHSJ7WZ2CphR9x7QlnnKI9aWzs32OZBuYiwh401z6I5rO7eg54sU/IcY=
X-Received: by 2002:a17:90b:2251:b0:2fb:f9de:9497 with SMTP id
 98e67ed59e1d1-2febabf4096mr3585651a91.5.1740794671827; Fri, 28 Feb 2025
 18:04:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250301001610.678223-1-csander@purestorage.com> <86d5f210-d70f-4854-8ecf-eb771f26685a@gmail.com>
In-Reply-To: <86d5f210-d70f-4854-8ecf-eb771f26685a@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 28 Feb 2025 18:04:20 -0800
X-Gm-Features: AQ5f1JogyzdDhsSU4u6-6ldO8cFm2tSqWRRE6OcEpmlX-dpUU4jWdczXcSu4XKE
Message-ID: <CADUfDZrOoSgT5n51N5=UFSum96mj2MAytQbJNbBVC1BJrmNVtA@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/rsrc: declare io_find_buf_node() in header file
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 5:45=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/1/25 00:16, Caleb Sander Mateos wrote:
> > Declare io_find_buf_node() in io_uring/rsrc.h so it can be called from
> > other files.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >   io_uring/rsrc.c | 4 ++--
> >   io_uring/rsrc.h | 2 ++
> >   2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 45bfb37bca1e..4c4f57cd77f9 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1066,12 +1066,12 @@ static int io_import_fixed(int ddir, struct iov=
_iter *iter,
> >       }
> >
> >       return 0;
> >   }
> >
> > -static inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *r=
eq,
> > -                                                 unsigned issue_flags)
>
> That's a hot path, an extra function call wouldn't be great,
> and it's an internal detail as well. Let's better see what we
> can do with the nop situation.

I can add back inline. With that, there shouldn't be any difference to
the generated instructions for io_import_reg_buf().

>
> btw, don't forget cover letters for series.

Okay, I didn't have much else to add to the brief commit messages. But
sure, I'll add a cover letter in the future.

Best,
Caleb

