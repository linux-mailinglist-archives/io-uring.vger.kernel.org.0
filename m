Return-Path: <io-uring+bounces-3532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C72C999774E
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 23:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4F8B1C21CBA
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 21:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C541E3760;
	Wed,  9 Oct 2024 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yaTZXXa7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CAD1E32C1
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 21:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728508321; cv=none; b=RwaSSqpTJC4SzhMv1P10oZeniOmq4/YMpTCcOKj8uBZgd6+5KpBTirplsWXAIA1knfmD/ue/hi3Phs5sI+hAEpLrMobg/w2NhMNtTU5lgW0K1oC7DME1E3E+cqo830RMOCf598WCVR3jRWuyc5rcUOtZ/G4MaUJlpSJwHEIxJ1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728508321; c=relaxed/simple;
	bh=tDiQmmnYC8QCBHjTCFKNaYKTLQOcG0YvoNcNUVkKLFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NhiFEHDzItu++m7i3fLs9ibvbsNm8FV/rA556nithnyV0TXIGM97x/UMUQOiIaim6XjITG1132zPQL1nR/FXZzwx2SEGFf4OYnoeOilUhmrn/dHbnLKu7nJexIt3SygcUmpvs7V8NGs0r7+A4hF1Oaiof8JSXxUDdC0sj9whDBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yaTZXXa7; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-460395fb1acso90271cf.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 14:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728508319; x=1729113119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDiQmmnYC8QCBHjTCFKNaYKTLQOcG0YvoNcNUVkKLFI=;
        b=yaTZXXa7plY6DXwuASLh3W590a5yjdWfAqV6EoiBpyQFWCGVHrTbJ2pOyIgpidPE50
         0iGDfKNr/A7E1PiZapbVo6hcLanXnb5yckhca7Vq4JcCz1CooXmoYX/0kEOJ9YSm5TsC
         YqFU3Dt/tH+V60ZQOc5OcBFPM5eXNgSDlaaNVOa0l4nnvUzp5LM0Y06a+q5+68ssyYeC
         u5uZ/wb2oXlKv6DL9IhXdSsOqAca0m9PM0L4Twer2k87vincnpdzL06CCohntJXox4s1
         3KBot3yN7g9V4z3bpMvZjP/WBwNIZsSyc2ytX5Mw/M93VNnxMcw9joRLEdFCbV/yT7b0
         cqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728508319; x=1729113119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tDiQmmnYC8QCBHjTCFKNaYKTLQOcG0YvoNcNUVkKLFI=;
        b=uIPZY4vDWCGvmGJ0XQOabIe43fLoN4q/YCgDd2VwOkyMsCfn/6txzJzIXFKVnVLFsl
         F39dhuWNOG0Ho2nTIsZUI571TQ8cDJg7sgzI4PIuBf3KuB0jEwW0qvDierRXc23x7AQH
         2vgIj87nZzyeGR4LROAqUPO4QkvbjfukLzB83QtRK7p1hUH5KvBOwfJJoCPisvrMFaNh
         SPl0Jwh6YPSScnl3nTj14efoocUpBJcaMmA+PT4dDOXymiaeUY4z3FThjkb/fvys0z1O
         qNbEHa+9zibRFzq92woMVB2SVXJzuIlPUUjzbti3y7JA1fyXGo15iuK7cyDxnJKKMwns
         tiTA==
X-Gm-Message-State: AOJu0Yz8/+G5+SzybWr604DEz0LdwiPyjrc4uDoMG0Su/TvaZarTPUM8
	Cauu4e1BatbSvl5uXsoUg2ooMSVfFZslp7ly5YG7r2STWCaLJAeXHG3i7sh5vzHPeG8t1jGvGKX
	+Y8xR8XeanVLJH9liuOPGrABoZ0VV7s7Odr9t
X-Google-Smtp-Source: AGHT+IG0CkxSS2KNR9g9xFhl+BGJZe4WWWDqAEC6C1Ey/4/z6ysY4E3GxuJTsY9lca7U4j6L4LhiBrbXUTutH2ue/XY=
X-Received: by 2002:a05:622a:5e89:b0:45f:924:6bcd with SMTP id
 d75a77b69052e-46040440db2mr1007721cf.22.1728508318768; Wed, 09 Oct 2024
 14:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007221603.1703699-1-dw@davidwei.uk> <20241007221603.1703699-8-dw@davidwei.uk>
In-Reply-To: <20241007221603.1703699-8-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Oct 2024 14:11:45 -0700
Message-ID: <CAHS8izPuRgGPz9Fg8NcsJzUaX5+8zSvT33XEp=LqdKMdm=KzbA@mail.gmail.com>
Subject: Re: [PATCH v1 07/15] net: page pool: add helper creating area from pages
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 7, 2024 at 3:16=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add a helper that takes an array of pages and initialises passed in
> memory provider's area with them, where each net_iov takes one page.
> It's also responsible for setting up dma mappings.
>
> We keep it in page_pool.c not to leak netmem details to outside
> providers like io_uring, which don't have access to netmem_priv.h
> and other private helpers.
>

Initial feeling is that this belongs somewhere in the provider. The
functions added here don't seem generically useful to the page pool to
be honest.

The challenge seems to be netmem/net_iov dependencies. The only thing
I see you're calling is net_iov_to_netmem() and friends. Are these the
issue? I think these are in netmem.h actually. Consider including that
in the provider implementation, if it makes sense to you.

--=20
Thanks,
Mina

