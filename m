Return-Path: <io-uring+bounces-6178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCDFA22388
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 19:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 253F51883A43
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 18:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A301DE2DF;
	Wed, 29 Jan 2025 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="D8AC3OMR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE17D18F2DD
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738173721; cv=none; b=nHUsXRxpGy4ahSUkcDoXQSkWtPay8TxI4mFcSX2kjDvnk9Q5/e75RE+dejyG6LFxgRljQv/oBnGilsPcp306KfzrdI6VsB7J+efe/nnAY68t2tF7zrbeKsbjysmbcvsMMOOqL+h56lBNMQYDXF923f3+GC6o/fcgVKoVzy0ffIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738173721; c=relaxed/simple;
	bh=Rsv58VeE5zC0QN8PhuG0t9155fC5Mi9wJwqubDybmzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dR41FrZptiU+bY2y+tC8rdHa0smzxiXR7AGoljbAET+G9SQhGzwZg6BfoP5WnDRw4DkXS0RRMKBRscxQE8EbjuRXNmF8En3mI8SVW1VEiRcJ3KUDFBwfVb1ENkLGoNtG5Y9EsYJ/24ZWLzy0WHjoG5Sxqu2GMgVXfGFYx+KTTwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=D8AC3OMR; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3076262bfc6so72470601fa.3
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 10:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738173717; x=1738778517; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rsv58VeE5zC0QN8PhuG0t9155fC5Mi9wJwqubDybmzs=;
        b=D8AC3OMR/uz/srALS514fcNN8MpnSHJg0CvPJYF7Kp430dFx0FPpc2Lwk2dOTk0aqO
         I4aACkc/HzBO+ZE7dVLVQL2OK5Ml4jQwbd7loXxWpZU5XgrE58dltLqp3+s8Z0eyaPVg
         7J4Qve59BrR5rpKgWwPGYp8ikUDKkepnOeNsX1SjZGmlDeIX9j1hBB2ubCsJDWTRUmxr
         aUYRP62sRVSVsmHEa+0GorFuaJ+iTao6KtEcTQOwvf2Es1qFNb+VUg9eCiSXNxQ21hcO
         MSuwJ3QIbcXYg/xCqiG7e437iar3luFpS2jGRwSVtAlX9z3SECvKEuvGvyIcs5omDiL4
         VIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738173717; x=1738778517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rsv58VeE5zC0QN8PhuG0t9155fC5Mi9wJwqubDybmzs=;
        b=J8eFw6J98hyX9Hcry3DibsUjzgngQKfdfAh10ClhDqzadbRv02K7BQ8th2hQvp+TbA
         0upa6+3O7NGtNsr8YuuYlNl1u81vEnSMZKDlicjkUC4pVl6do/LaXuS8o6B5NmuxnS3z
         i/F119vwph4Iaq/KpcWabQ3o0QD/0K17pIBP6qFaOxhMQ7vt4wO8uYHNnLO5eaonsCOV
         Fj9I90qt6u6byGz7PgjbGXCWiVobJufrJ2VtFahj2jn+eT9vxMprOyvigw9H8Mv8pql9
         sMrJqtG3HShze3qMERCVt41d3nRL8dQf3KbwZQ9HP6xYb6psOokjUWE5nJDaH6ZQ36mQ
         58xw==
X-Forwarded-Encrypted: i=1; AJvYcCX7EM9VzVKdiHJJYMiEkmQ3k1GEAOupgvW17w3ajrOgC/rfOej9Fo+p58UTBgrqerqWly7E4WuOYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFEsxHArQyhIQvQ+gniUSm43FAUWkWH/W3El43G8XlfvOmamXm
	IKbxFGF/PoCUS0zRJamXdIa5XSfyGlvLRTTMXpT4XDK9thH/ezb9/p9JvQxiy2gz2ajnKTzJ6yt
	M2Z8UE/2JffS/g27LNMMp8ws5BcwR4vuTF8k1yQ==
X-Gm-Gg: ASbGncsdFT29CWzDUnszLzAEtRPR5bddGTX/byIjjEdxXQ9pE7/W/0zpj0e6CEGMikv
	h7XDLHc407lzy9ltMS0XE65kBC7mDDdVlU120c2gGaxKrBKoei00QHQusfv8fLZ81chRpwWsX2O
	9nlD137qEYiPGDYF6FaQTAMnGPtw==
X-Google-Smtp-Source: AGHT+IENHbZtfqKdacz2TNrUOowVMg9fJi5BiMkAVvxHm5n/a4zcb2hRxrG4NlKIk0EXIcJAlM1uqL9ui//0I13OXE4=
X-Received: by 2002:a05:651c:1614:b0:2fb:8c9a:fe3f with SMTP id
 38308e7fff4ca-307968a41d3mr18570851fa.22.1738173716252; Wed, 29 Jan 2025
 10:01:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk> <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
 <f76158fc-7dc2-4701-9a61-246656aa4a61@kernel.dk>
In-Reply-To: <f76158fc-7dc2-4701-9a61-246656aa4a61@kernel.dk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 29 Jan 2025 19:01:45 +0100
X-Gm-Features: AWEUYZn6QW-kL4zyjx3r3G-mpQn_W50dNn--yQd1QkzUZM6D5YIUhotanfkgquk
Message-ID: <CAKPOu+-GgXRj-O9K1vdGezTUGZS64w5vpkZg2MM-96vmwqGEnA@mail.gmail.com>
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock contention)
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 6:45=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> Why are you combining it with epoll in the first place? It's a lot more
> efficient to wait on a/multiple events in io_uring_enter() rather than
> go back to a serialize one-event-per-notification by using epoll to wait
> on completions on the io_uring side.

Yes, I wish I could do that, but that works only if everything is
io_uring - all or nothing. Most of the code is built around an
epoll-based loop and will not be ported to io_uring so quickly.

Maybe what's missing is epoll_wait as io_uring opcode. Then I could
wrap it the other way. Or am I supposed to use io_uring
poll_add_multishot for that?

Max

