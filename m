Return-Path: <io-uring+bounces-8309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44604AD65A7
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 04:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02DA51758A9
	for <lists+io-uring@lfdr.de>; Thu, 12 Jun 2025 02:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A65F1BC099;
	Thu, 12 Jun 2025 02:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KXMGfPat"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B61145A05;
	Thu, 12 Jun 2025 02:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695346; cv=none; b=UWwmeDVYjjaGTNHqqsIxwv5ROHle6O99Pa/0HIJH5LJkpRpKQDoqLV2ku1+e1D/ShIPo/RhGbqSKuuxQB6P1KV5IBQA96TUNq16LqoXEUAz0rUM08jGKrBmO4YbQFsLmB5ZGzM1hwyXlfgwHEJ04h6mvI1/5aCfi6KtZggeO2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695346; c=relaxed/simple;
	bh=1yx/CtYYMkIYLlBitWl2jga21GCJ3Qcpst09DXhUHkU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FIRjQwsJ5bAQC6yZVBd7i0RJHZ59l/cbw8Tj+f8DMAu2aLhXRe1QKG5FFFZkzSZFEehW0YKV3aFwl1TLNykZ77Cjbr14tUU7BfmVh11BcFymkVluG0qetHYKGJI/QsqWMnTL1sYmy26OPVwpMZJ9XSI66711fHlrRFoB6S6LSH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KXMGfPat; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-450cfb6a794so2030845e9.1;
        Wed, 11 Jun 2025 19:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749695343; x=1750300143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3x8R7ufLmteVH4OA1UzHwd2KXuYEyzj47Ro+nITLM4=;
        b=KXMGfPatcKHQbmueCMyqPHAM2vmiRIpwMEN84yCsGm+OolVpU2Siv4Acq5eCurYrxr
         /eDOvNtD/u/N9guaqG+A37v5A+zRtMb+K0tubdwByKGq0H9ew/vAoUIu5EnDnm4paBAp
         Q+1wm6ppIYNVtVz4p5jJnJGuh+ksYwG+9sUaSLatmInUltFXr9rIkBeS5yF10MAthg2u
         b/Xx07DkudUos1icAEPwV4Kyh5+CNq2diP+xVcKcF+n5SDD6TEBUQn+hmnUmJkGJQH5H
         nZOqRgho1F7AGUulrBTcnoeAOGSyjjgkuvcoz1UqJrsUf6PKsyPbXtwQs8SUyAa6K5r8
         VjTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749695343; x=1750300143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3x8R7ufLmteVH4OA1UzHwd2KXuYEyzj47Ro+nITLM4=;
        b=g0qL1q6IsV48gj10bQom1zDUYQnzJnMgyI+aT+aurFAi1I492FQqtbJmZiUzsiB3iS
         ybToJgqiKWzmDzbN4fXrIGS4DoUNRP9izeDfMlcRp9oaKei8IZfvWowtXkQI9hgRJDyv
         Eo9wSVkmz9jP7WU2OrkNgn9cTkl7sYBSnuvwzHIJV2G6YlnjavyiykcJr9bErChDF9iA
         +BRj0tZney1vUZVrk7m86TLiTWS6HFPO+pGYqO5y87Wxg2oGNEYRvrChnL7CRP50kva8
         gsEkp4SjZ8x0O1QsyXpDccpUSTHBusGdizABqgV2x5JqcaratJXmR7zRJSl8CN8rgdyE
         t6ow==
X-Forwarded-Encrypted: i=1; AJvYcCULCQs+GHFsgHuBf8stwuYl7RRBqvZRmgTQm9S2GqtmBW7ZEmQU2MrnObG2VanxKERpu2KRYVbmG2IXRda8@vger.kernel.org, AJvYcCUXAeiEyE34wc5ig2Bxg01qS5DXoBH2o91XnUl/i36BXOHOnQLTtkvGA/ZMYQsPsflWqe0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBy1mgXZg7+/2J90bXkT90pus41W2Ker7F3d4EpD+U+A0+GB38
	iZg2gryvygureRPgwYrmHTNY9NNMsjBc9lBC2Huz6zAtY2642zhcYcT4Udv2hFYrAjsxQZRtclY
	wZiCx+2Yi5ZrlqMvgfszgvZBUW8ksU+k=
X-Gm-Gg: ASbGncsxAOv795McWVU465ojeiYm8St0dZ0cl/gD1DRu5LwpvOidYKhDbkc9At8lrtg
	UX9DbV43jADFxqdfpe0mLLZsS2cm7rOMNMvJTRJw5iCs0+hfTGYL1UIh4B8EnNt9yNcaSHV5sBA
	mE0c9cDKsQPrOw0KBVXH3iOPWVbja38I7cueiJOQ5B9jY+atw+EdMkCDeBs8BxaJi0ivu7ULg2
X-Google-Smtp-Source: AGHT+IEZB2wxVHINVKq4iRUQtbIomagqoERsY8hxYiTuXGjbCJonhldKnS0F9vORggm5x5uWXGyk4UrwdKyRGEThAv0=
X-Received: by 2002:a05:6000:2301:b0:3a5:42:b17b with SMTP id
 ffacd0b85a97d-3a5586cac26mr4006697f8f.29.1749695342735; Wed, 11 Jun 2025
 19:29:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1749214572.git.asml.silence@gmail.com> <1c8fcadfb605269011618e285a4d9e066542dba2.1749214572.git.asml.silence@gmail.com>
In-Reply-To: <1c8fcadfb605269011618e285a4d9e066542dba2.1749214572.git.asml.silence@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 11 Jun 2025 19:28:50 -0700
X-Gm-Features: AX0GCFshDLU67Oa0IBrUdbtHw-aZ6NmsI162Jz2TbY3PO1lWW5160SW5P3V808M
Message-ID: <CAADnVQKOmYmFZwMZJmtAc5v9v1gBJqO-FyGeBZDZe1tT5qPKWA@mail.gmail.com>
Subject: Re: [RFC v2 4/5] io_uring/bpf: add handle events callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 6:58=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> +static inline int io_run_bpf(struct io_ring_ctx *ctx, struct iou_loop_st=
ate *state)
> +{
> +       scoped_guard(mutex, &ctx->uring_lock) {
> +               if (!ctx->bpf_ops)
> +                       return IOU_EVENTS_STOP;
> +               return ctx->bpf_ops->handle_events(ctx, state);
> +       }
> +}

you're grabbing the mutex before calling bpf prog and doing
it in a loop million times a second?
Looks like massive overhead for program invocation.
I'm surprised it's fast.

