Return-Path: <io-uring+bounces-6176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CF5A22335
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 18:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0F77168069
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 17:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1738190696;
	Wed, 29 Jan 2025 17:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="O8Teh5Rj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2351E990A
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172386; cv=none; b=sLlzWj5jV/HpBLyS3z/dBks5/3Ism1xs1i8nowS8xs0XFvIT1ZtB/OkVRp1ILEhmlKoptZeqMj8EZRv92oF6YgXt87gVk158UPWE2//iPOFWQ15j7c1FEhbImhXCQDfUDt+EvjqPsdCJe/CJPdITmdprMK2UNimgNPiuUeV87gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172386; c=relaxed/simple;
	bh=UBdGCfQYNjbeReCCIGBY3+vyhJpfUfknXZDt6yUN3gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O5QeCzeHPDXi53fxybjqnvWfYA363H8Yzf1hJxIyk6Dw2LEWhrwA8BW8IfCzJ2JaKzQ9gB+/j3j2m1RQVXNybXJqDh8fKA5Gn3gThitkunMLdfA0eJdUZiZalsqj5zuvWfB+3vPqk3ScM3/8L6y4NZHZzK0dG43Y7yb80V49zRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=O8Teh5Rj; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa6a92f863cso1417832566b.1
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 09:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738172382; x=1738777182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBdGCfQYNjbeReCCIGBY3+vyhJpfUfknXZDt6yUN3gw=;
        b=O8Teh5RjfaseQLnKyCkv9p4KKOwWjSdH9x3bL8VVP8D7jMGTKGhcSbDxNgg0rl+ZiL
         nDv+r5Ds/yIF3oKrL5p5tQ27c6bFyLwWrMSG7FvW6G4T17GbO7nQjbQRNTAVBnUNOvOm
         32rrxsZd/L1PK2Oovjgo04C0up6qvnx3i6hHfsDrf86DsPIw6t8YtBM9nfvtDvW8v8hm
         qHsucebqaj7VsubsQvsvmVV/0EpaO18tm9DT9xcaKJCI3hf94YN98khK1r7DmM30Sr1C
         giEJLcxtuZ4/XA6kn7MokC9WV46xQ/0plAOsYeNT1zOkxtB3ZbcS8ymb03NtsSdhEabH
         6tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738172382; x=1738777182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UBdGCfQYNjbeReCCIGBY3+vyhJpfUfknXZDt6yUN3gw=;
        b=Xl5sPi+7G3Jcd8pCEXbt3/V/rbbWBpNZWETHMBIKv2vxJmsEEtgQLGltS8BnfitGOK
         VZ+VL2gnUuYVludbd8/YLRuaX697gSWgQxypg/W8muKXEM5U21TZFBA88fu118LXMABO
         GZyMG/eGdM97gG7Z+r9Y0yzp/9ck9m37ypC9dzAwg9Zrg2m6kXm8ciDwFcfmw/U2Z0r5
         WDmdENkOqku1xm1DyLks4hf0O6W5TKLOikNS+v6R/GqVgvOizbTnkQLZBtmYsGJAGCWN
         f4nAHp1LF8kWoqLupCFUPfos7oNkKluaXzm+hVDUhalTGruStNXNSh2ymCjEMvnDQZ1x
         Z5sA==
X-Forwarded-Encrypted: i=1; AJvYcCUstDCgzCqGLgFd9XkfYlxpYlHPzQxFVTUxKVhizYl73ckkBWYMcm36QRZ7XDrkwhrLaFyMrs9Mvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWP4uBdldwGvuJYE1cLGKM6EpE20AoHBR6Ilr/IFL2k3oZYd7X
	bToX4Je2MwFlXqkR6o30EfUzMEyacQuNQ8OnQ1xuC9WD/aLWzaEzrChIg4/jPbyzYxnB9YNOnUn
	7k8DlLqrLqd2xeg8tk12T1Ofvw35floxN7ZBoa3Fq40j2gaSkRJw=
X-Gm-Gg: ASbGnctNo0pA8CW9jbdyPEk8rOoMDgJ4SwZWKY5G+NLTq3apGwazvtWMJqYOLRn1AZt
	HDxEKlQoUMmRF8QquY1RDLFm7wH7BFLRX0EJtXwqyr4B/YI7bjgsvnWSDhWLoCBw9JTP0ym4RZc
	fQ/kw6yUm6CENtRyWipE1aYTBL+A==
X-Google-Smtp-Source: AGHT+IHd41LqzrFe6rrWaoIOKOkhlbA6IZpq3yA2hjLO25P6OBd3KAxO9whQswzND6LGB+E5GzADPuAWBooGEjQNkak=
X-Received: by 2002:a17:907:9726:b0:ab6:cdc4:e825 with SMTP id
 a640c23a62f3a-ab6cfda40e6mr425691666b.40.1738172382124; Wed, 29 Jan 2025
 09:39:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com> <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk>
In-Reply-To: <7f046e6e-bb9d-4e72-9683-2cdfeabf51bc@kernel.dk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 29 Jan 2025 18:39:30 +0100
X-Gm-Features: AWEUYZl-yFRIZtTC47qKoZH5cKcXkDdSNc_iUAKaG44Ij9zY-rTqTW9UbLk7bjM
Message-ID: <CAKPOu+90YT8KSbadN8jsag+3OnwPKWUDABv+RUFdBgj73yzgWQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock contention)
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 6:19=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> The other patches look pretty straight forward to me. Only thing that
> has me puzzled a bit is why you have so much io-wq activity with your
> application, in general I'd expect 0 activity there. But Then I saw the
> forced ASYNC flag, and it makes sense. In general, forcing that isn't a
> great idea, but for a benchmark for io-wq it certainly makes sense.

I was experimenting with io_uring and wanted to see how much
performance I can squeeze out of my web server running
single-threaded. The overhead of io_uring_submit() grew very large,
because the "send" operation would do a lot of synchronous work in the
kernel. I tried SQPOLL but it was actually a big performance
regression; this just shifted my CPU usage to epoll_wait(). Forcing
ASYNC gave me large throughput improvements (moving the submission
overhead to iowq), but then the iowq lock contention was the next
limit, thus this patch series.

I'm still experimenting, and I will certainly revisit SQPOLL to learn
more about why it didn't help and how to fix it.

> I'll apply 1-7 once 6.14-rc1 is out and I can kick off a
> for-6.15/io_uring branch. Thanks!

Thanks Jens, and please let me know when you're ready to discuss the
last patch. It's a big improvement for those who combine io_uring with
epoll, it's worth it.

Max

