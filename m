Return-Path: <io-uring+bounces-7184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4BDA6C46D
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 21:44:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6103A188A1C8
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F82230985;
	Fri, 21 Mar 2025 20:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Df7G/70S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE661D7E57
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 20:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742589872; cv=none; b=TPEKuccsMdbXaBT0seOvgIAWiVgJaVD9bOPwCmR1ulQidTAcVzQelBztK4uR23u5fcHzUq+2eGA0i1YDaDj1WiWsKXOGylqE4QwHp10URWTR5lgZEnmT9ivgrqQOKSrff2D1oHMwT9073jzBOJai+WW5A1NCmWsDeWfZEGXVy/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742589872; c=relaxed/simple;
	bh=IzHqaB1xXtn1biQiH6+BombSZ4qjcO3Cqq4ZsPGl3l8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dO63oSxTt03ozNzwuNcRkYSuTJXx/emSebCx7cN6Wy5xKHM+gorBdAnx/SlEXgp2j3XqyPOwwRUM2y+OCHIZ2GiWjLV8rEIfbkVg+kdyOMbEXPauVAP8RPnIeETHh0tsyCwbLvu0SepAlOhLOzRsCcmWZzVtyPgRWPzPgLXSG5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Df7G/70S; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ff53b26af2so643189a91.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 13:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742589870; x=1743194670; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzHqaB1xXtn1biQiH6+BombSZ4qjcO3Cqq4ZsPGl3l8=;
        b=Df7G/70S6OrIfrYMdFD/IF050RU2QpVYEdF+ukbmw/l6vBikGlCg5wr6/q1u+QApgT
         pu8o1mIOZK0jpPAYA2Dj5sqHe7cILgWH4Xo/XGcylI95zlOfdmELN7RcQnfnUv/ESBde
         2y3tzLf4QayuyOfptORABC+0vvyjh+aGT91++ZxWgCKnw6C4tm91pn1/0ML1BJsD48f7
         x8j74+zdHeKZnqtANBVpkOFF8NSCgfmML2Gn3FqCTpQmZUGpWtguGUj9YNRcAlPFJt8E
         z4C40Ie+oBR9dyhWlLB/ytYh2MrWyd3pSopUnwXbIt5IABJadIju+aRBtR4VGoeJz3KR
         krKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742589870; x=1743194670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IzHqaB1xXtn1biQiH6+BombSZ4qjcO3Cqq4ZsPGl3l8=;
        b=adhwcgYlrEOkxFCtgDwI9vWUS2/RWa7qQrZ5Cj7BFIppH+td4jnCv+Lxf969RkOT7E
         iytZN8MWDRtKXik/mkmy8geGkhFrz8CyjIXWXzedYPhLt83utmfHA9RObfJvzlIKaUxa
         SvdufTGztWdDYTF6a2x9HRAFK6e5V3JQaSY7xtKS9AzmPQgxz7ByX6ls+05UPCYuACno
         zxccG4xDL+jAd9jymavJIGr/AV6A+JRe9l3t3O1bLulXlPD2R2rfxOkdBc4/bLi4lqAw
         4Od6NwwvNbDpoUzD93USvkjSQjIODNo+pzu4+Xqdxt+GIwaBPOACjM3MPuNG2wTzlR2I
         7/TA==
X-Forwarded-Encrypted: i=1; AJvYcCUt0E7T9PeAxs3/CilG1lt0TDAMrl5NjvWjxbA+yCvRPECg/uJkeYvT5YoGwdQkna4SY/GD81/yqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJLBzeW22u5L/6qNwZ7ptYrU/7kcJGE1CrUGTljBttriF9JOoO
	1OOwABKAGQUD6jqhhx90d/pORNTAEKMzICJV+TFpR/5ziMcdwNCrl5e/q9iQOGSt5m1bOKVpnsB
	/z3zib1WQVBwe6SfZltXI8EcJMLTQ4cFsMOao1w==
X-Gm-Gg: ASbGncslKelUMEefaYXkurJgB/o1STa49qaqEa2BQ1Ei+GE8/g1qfZgXMoQJUX5weWU
	JiIGnLPMI4/Cnr9co3Hdr9y/5IVpU+x7aCI83iU5z/crZGSUVwnwPA9SIlq2WSuqVBuSUdYkE2e
	wTj7InjI0cAF+5K0oGrgYj+M5P
X-Google-Smtp-Source: AGHT+IHb7qNZVc4dbo1EN1WvdXjQ6zVnZ8qtjLzzTA7S1AqgBNosamOSmdEMbw5hYcAX2F+qzbprqzxMQiDGSU0T5QI=
X-Received: by 2002:a17:90b:1c08:b0:2ff:7970:d2bd with SMTP id
 98e67ed59e1d1-3030fef77bfmr2814564a91.5.1742589869879; Fri, 21 Mar 2025
 13:44:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250321184819.3847386-1-csander@purestorage.com>
 <20250321184819.3847386-2-csander@purestorage.com> <ee6c175c-d5b7-4a1f-97b3-4ff6166c5c73@gmail.com>
In-Reply-To: <ee6c175c-d5b7-4a1f-97b3-4ff6166c5c73@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 21 Mar 2025 13:44:17 -0700
X-Gm-Features: AQ5f1JqsMWeWHDB8wb1B7Zchq6sPKT-24dX-m8MSW4wk0vEJnpusemPKRi6lxhQ
Message-ID: <CADUfDZq=UMw+tm8YdnttVSL=wvF_fnBSvixbfj=KZ1inOLZHug@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring/net: only import send_zc buffer once
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Xinyu Zhang <xizhang@purestorage.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2025 at 1:37=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 3/21/25 18:48, Caleb Sander Mateos wrote:
> > io_send_zc() guards its call to io_send_zc_import() with if (!done_io)
> > in an attempt to avoid calling it redundantly on the same req. However,
> > if the initial non-blocking issue returns -EAGAIN, done_io will stay 0.
> > This causes the subsequent issue to unnecessarily re-import the buffer.
> >
> > Add an explicit flag "imported" to io_sr_msg to track if its buffer has
> > already been imported. Clear the flag in io_send_zc_prep(). Call
> > io_send_zc_import() and set the flag in io_send_zc() if it is unset.
>
> lgtm. Maybe there is a way to put it into req->flags and combine
> with REQ_F_IMPORT_BUFFER, but likely just an idea for the future.

Yes, I considered making it a bitflag. But since there was an existing
hole in io_sr_msg, I figured it wasn't worth optimizing. Certainly if
we want to shrink io_sr_msg in the future, this is low-hanging fruit.
I'm a bit hesitant to reserve a bit in the generic req->flags that's
only used for one opcode.

Best,
Caleb

