Return-Path: <io-uring+bounces-3721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A57129A0963
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:25:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DA641F2534A
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2222207A38;
	Wed, 16 Oct 2024 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="K+fMav0V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6B208218
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729081512; cv=none; b=lO6we2DBGpoY3j5Pfgv2F+OqL7n1t+FDjPt7XSjsATCZgYsYc8HMVrHroRP8ilHu2uNOpvcEu6AqCo/DB6kJlDHgKb2pJzJ4cvMl/LEXzrrXFma3Zp/r5D/dPYYhappYAK88aGP4YH9s16LpOGXMQzJa61t19jhrI8nr6TbDul8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729081512; c=relaxed/simple;
	bh=+v6rG5wSb4dBahr+gquV6YM3va8fUspd6ycAgNTzIwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iqqafyG1JHUOj+HL61zX5f0OEbhep79n8yiHyJa2aoZBjZ33s6sjloa5NQ8DLSbTPdZ8g09lG4u6EjPYdZ3kqCg1Xs+nzcQ4Sqw55gON4hdS/Q8z9E9/ZNcuEHegSs2EjGzDm13ISrdTv4DhrcE0INAWixSg/sI9mSUkfJXmE38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=K+fMav0V; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a99eb8b607aso539047466b.2
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 05:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729081509; x=1729686309; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+v6rG5wSb4dBahr+gquV6YM3va8fUspd6ycAgNTzIwo=;
        b=K+fMav0V+ob4q0v4otQIi1MCAxx4GoF34NrJgGNnVYjdaeejJAtKTft/njGBNDQoZf
         m9s4+IAZ6+aZVjoL56PKzjUPmHZwVZT3rZdHqPZbxyGz9Xsk6/bI9POKo9v/lO/WpLxg
         YsWdKxpddBgULjodW36yz8Jn+Zjgq65Uu7oNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729081509; x=1729686309;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+v6rG5wSb4dBahr+gquV6YM3va8fUspd6ycAgNTzIwo=;
        b=vP7oyns3Bd8ZM1GDoIHMKq+sXK2r3IcSKdxLUF9andROgg8b2Zq+snlnmje8YF0qw0
         nKYXWVVdQ8fjWtLOA9cp9fTr9dzN0wvOlioD1MQMnYM9wuarz9zMCyf7tqHXOT7YPq64
         HdXLZkOcZ3TAs4YcnrccQVgeWyYNndFXunVDdzRhVYIvgx7rZPGfGyq2uGheMBZ+8dC+
         0IibIDyk2DyyYtjZVNFy3P/xPSN5x4u1AareQqhBIABi61s4KANi9d5MM7Q+s2jsxhgR
         Qsmapp0JqKPX5AwXom4M6+zsMTSr3toNwExIi4LIKpp0wVcPFVS47cFvXVqyzh3HVXXP
         vOBA==
X-Forwarded-Encrypted: i=1; AJvYcCXVgwZZ15AKDIX6ZHoepWcGob8d69Tgxzu37a9Rmyly7wGuFHcmQbFg02yokjALH4j0JWvADBCn6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnAoRwOBe08e/L2oZB0C2hvD+8WXR6WruViE7oelkxzPVYJZOn
	VDhqXyAYzkbX/fF49K+cAc+lSHazHu5YNrR1wBxsbkRu8mkPjOOUfivIjbCERfSAlFmhjILzNo0
	rQzHG/dK2iG182cvEvTPElQr7IPgtuqu0OFN2Dw==
X-Google-Smtp-Source: AGHT+IFcGRohMIRRek+8jiWGffqvpNZLg7QzzilyegU9Ui2RrsVY5MHDBsH5yOf7olkwMzj+KKgEs2Kn04m9uTI6IxE=
X-Received: by 2002:a17:907:e2a9:b0:a99:fb10:128e with SMTP id
 a640c23a62f3a-a9a34d0d153mr302830666b.36.1729081509174; Wed, 16 Oct 2024
 05:25:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk> <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
 <ZwyFke6PayyOznP_@fedora> <CAJfpegsta2E=Bfh=_GqKF1N3HQ2+kxMu2hnT5KQvzQptd5JbFQ@mail.gmail.com>
 <b284b6a2-8837-4779-b6a2-f31196aea7b9@fastmail.fm> <ab2d2f5c-0e76-44a2-8a7e-6f9edcfa5a92@gmail.com>
 <24ee0d07-47cc-4dcb-bdca-2123f38d7219@fastmail.fm> <74b0e140-f79d-4a89-a83a-77334f739c92@gmail.com>
 <e30b5268-6958-410f-9647-f7760abdafc3@fastmail.fm> <CAJfpegs1fBX6zDeUbzK-NntwhuPkVdCoE386coODjgHuxsBuJA@mail.gmail.com>
 <c2efdcc9-02c0-4937-b545-d0e6f88ee679@fastmail.fm>
In-Reply-To: <c2efdcc9-02c0-4937-b545-d0e6f88ee679@fastmail.fm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Oct 2024 14:24:57 +0200
Message-ID: <CAJfpegtMXZ7GW+pT5gjYuPWzkvik31CZH__k+Ry+mrf+-QRbOg@mail.gmail.com>
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Oct 2024 at 13:53, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> I don't think that complicated. In the end it is just another pointer
> that needs to be mapped. We don't even need to use mmap.
> At least for zero-copy we will need to the ring non-fuse requests.
> For the DDN use case, we are using another io-uring for tcp requests,
> I would actually like to switch that to the same ring.

Okay, let's try and see how that works.

Thanks,
Miklos

