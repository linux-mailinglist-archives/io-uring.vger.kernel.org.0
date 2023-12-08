Return-Path: <io-uring+bounces-261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C19980A6EF
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 16:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E7441C2012B
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 15:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8CE2375D;
	Fri,  8 Dec 2023 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GnasSYe/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12F11BD7
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 07:10:20 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-54c77d011acso8433a12.1
        for <io-uring@vger.kernel.org>; Fri, 08 Dec 2023 07:10:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702048219; x=1702653019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/ovJzIDDuWgrQ/HVOjtz6EPYlWedb8VEkgscV37NZs=;
        b=GnasSYe/JH3MfgthHxzKpVDyvMrC3kfV/AG2kQecBcuGFuh4XSluYAQNNSlVLHZVNo
         RMPDE4K/wK60dlVLtj0942m/pPAuXNatv3yD3ALsnGWYv8IZeK3ewz4nq2LUZwGXDNQ9
         Hf6Xq5e/1Tg7eZRuMQBIE08cSuj6AQImWwDJ34K2G6mZfF7ApPBwwehAWQ3x+VBJW11L
         GH2xTiUiG/QV1PwCykhAWAAEm1sEpFyEwr4ldhoi5jcgcbnsjV3zxpa3y+5Qj999r58d
         lp0BqpFdXHz1BTuvisEJxskGRhTIs1W45//Vm/zhr4ijm7doosozuV7H+dmDshx5Kenm
         ImsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702048219; x=1702653019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/ovJzIDDuWgrQ/HVOjtz6EPYlWedb8VEkgscV37NZs=;
        b=dUFwoyCqrYqTnjt+e0sISn8vOIEmR7dKzbTvTICyEjBL/ySWYfursDgH+HkpkoT/t+
         63wr+WLRFKS+BgTLEUqSW1GjO7/RQrtkjkJxwLD9UnDck+QWTSu8gxWDUuUxGqty6YNZ
         7IhUnKgvmzbS9TzbNq3UdsCeiGG/wIGuxA9h9/tcuy7poRe7VkWkPTOwCqR85qiJvnA2
         sJNkcusoYgXN8kMIZhnxvukUMKmZRms7lYpc9RLq8+5VbaCXFfLFCEnTXuFQG8EM8/4A
         rM1Q3j14eVoLg7gEA7sTvVsyAc52ubziiT2PZyG2iFUGwjeDd1JL3YeIyYD+sJkNvyf6
         vICA==
X-Gm-Message-State: AOJu0YxRrI/1NdDjiRWd55UXXQ/5Higaj73bpFVC7hyqXyAuuAydvWk2
	uakcfSDecvVv1I/kBq6NY4FTivj4nz1bPXgCaowv7w==
X-Google-Smtp-Source: AGHT+IHvmZ2K29qhJs4qRHQOgrEhQXYkJsjlFomXkAo7CucLY1sDTVgEQvdNTmb1qCGf6PISl29xlon3aB/bnsWXHd8=
X-Received: by 2002:a50:bacf:0:b0:545:279:d075 with SMTP id
 x73-20020a50bacf000000b005450279d075mr58541ede.1.1702048219171; Fri, 08 Dec
 2023 07:10:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
 <170198118655.1944107.5078206606631700639.b4-ty@kernel.dk> <x49sf4c91ub.fsf@segfault.usersys.redhat.com>
In-Reply-To: <x49sf4c91ub.fsf@segfault.usersys.redhat.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 8 Dec 2023 16:09:41 +0100
Message-ID: <CAG48ez2R0AWjsWMh+cHepvpbYWB5te_n1PFtgCaSFQuX51m0Aw@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over sockets
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 4:00=E2=80=AFPM Jeff Moyer <jmoyer@redhat.com> wrote=
:
> Jens Axboe <axboe@kernel.dk> writes:
>
> > On Wed, 06 Dec 2023 13:26:47 +0000, Pavel Begunkov wrote:
> >> File reference cycles have caused lots of problems for io_uring
> >> in the past, and it still doesn't work exactly right and races with
> >> unix_stream_read_generic(). The safest fix would be to completely
> >> disallow sending io_uring files via sockets via SCM_RIGHT, so there
> >> are no possible cycles invloving registered files and thus rendering
> >> SCM accounting on the io_uring side unnecessary.
> >>
> >> [...]
> >
> > Applied, thanks!
>
> So, this will break existing users, right?

Do you know of anyone actually sending io_uring FDs over unix domain
sockets? That seems to me like a fairly weird thing to do.

Thinking again about who might possibly do such a thing, the only
usecase I can think of is CRIU; and from what I can tell, CRIU doesn't
yet support io_uring anyway.

