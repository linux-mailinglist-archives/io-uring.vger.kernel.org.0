Return-Path: <io-uring+bounces-2184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8928A9054C3
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 16:08:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21CC328388D
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 14:08:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE84117D8AC;
	Wed, 12 Jun 2024 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ceTTbxmL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DB817D8BC
	for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 14:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718201288; cv=none; b=I5413XmgaNPgp5vFxSno9bfFoF4kfC7zFkGZ4UYewpXf60r7yROT9QMLjPSbbY+9qnWh7UZNH9bnaPFvQsdettv5haT6EE3//CEHovAliMclj7bUewbWfdWvxwpUKEgu6pRt/tmX19wi2tgA7HS/K10fWcCkm5xmzxJrxUiV8hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718201288; c=relaxed/simple;
	bh=p3g/ty314Nf+I7Xa+6k/f/Xx2IiNpTdk4WIG/Zbz84Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V6aMbrEW8DLLWDdAVsDCT5ErzTypbbZ73gHF3iqidWIgjmquGOn9rYfVMc6t/AvV+XbvTwo7YHdBsGJ9IFWyDbbDVhu2m9qbbBHroQW6WrPtjJLpFL9vSmLzTM8blUmepJ/1xScFxgJ062KK1PPxVu1zfSSLj5CdYV4+3JA8F0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ceTTbxmL; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a6efae34c83so539188766b.0
        for <io-uring@vger.kernel.org>; Wed, 12 Jun 2024 07:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1718201284; x=1718806084; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OAEju+oU4oJS914s12UkkuOt+Kxik+e/JCB3W7SXu9I=;
        b=ceTTbxmLPdZ0bD1l7Col9eABDwIlA5lQq0Cdpk0dbMKdxKD3LFHIkqvyerV0iPDBCe
         5M7S/JBp0aF0GR2SVEHhsr0YJG+5n4UKumPfHwHTT0s8dSC6TLpvVY777ScK3xtuc5XP
         GWGzZBV2J13p0BAg7EmuQSJHHu1UkQZiz+10M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718201284; x=1718806084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OAEju+oU4oJS914s12UkkuOt+Kxik+e/JCB3W7SXu9I=;
        b=DhPMdTJ1zyFEsZcPs0fxtVkaIXTmy5oPii2QrAz5k926kyEhYkhPZoTW3RGKagMN35
         hYC7C7EE7QtP1hDRuRXPyTXeXx4ikOLYkdCPby+3fLv24PpCS/Z691YAmBofGcdrRtb7
         9Ytdm5C3ATt/fg+ZMRbqcSSlYAzM/EmB6yIePVNfN0FuJT0+d39IJSHAV8Brm6fUKGLz
         sRFbpaOVNDN5nJBjCxBm6GxC4oVhocUIPYoovb2CGKzPJBZmjAMMKAPIBZQ1CmDSECjU
         mGmXxS8KEFO1dfM76jL72Llt6l6irqw33b0p9y1kvDXQkScaqP76nGkJa7DM9NESw65q
         ItVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnB+zAOavJt5KG8D/seIlZKKPWGgyvMtGIi/fCvLE5PJ3L0Pp7sxgAO6/JSaOIOxkXpjqTno/jf9t900jI2cSiMOWUxK/jlqA=
X-Gm-Message-State: AOJu0YylxlLBmnz/4zDrDttPpFERiVdAzDQhXa7KVU9EdkgUPkwwC/22
	UsLOPDNTWJ4ycu6LoheQotIe4RyZxMtgy3QO0n+uw7QXLWloRZyVO6ae10wanClXp3ugg1KmRkY
	Py1s6ESQXt5AU1K1n1eAYnunml4WhLDOoakKJkA==
X-Google-Smtp-Source: AGHT+IGqsCZ9bqtgdaDlwUjOi0Qif148/T68bKEYe319TQA//L+jBiTtEEq73ZO2bn/yzaH50ALZThEfEoy90yAxV0w=
X-Received: by 2002:a17:906:2745:b0:a6f:33d6:2d4b with SMTP id
 a640c23a62f3a-a6f47ff3b97mr104559266b.75.1718201284331; Wed, 12 Jun 2024
 07:08:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm> <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm> <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
In-Reply-To: <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 12 Jun 2024 16:07:52 +0200
Message-ID: <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Amir Goldstein <amir73il@gmail.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrei Vagin <avagin@google.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Jun 2024 at 15:33, Bernd Schubert <bschubert@ddn.com> wrote:

> I didn't do that yet, as we are going to use the ring buffer for requests,
> i.e. the ring buffer immediately gets all the data from network, there is
> no copy. Even if the ring buffer would get data from local disk - there
> is no need to use a separate application buffer anymore. And with that
> there is just no extra copy

Let's just tackle this shared request buffer, as it seems to be a
central part of your design.

You say the shared buffer is used to immediately get the data from the
network (or various other sources), which is completely viable.

And then the kernel will do the copy from the shared buffer.  Single copy, fine.

But if the buffer wasn't shared?  What would be the difference?
Single copy also.

Why is the shared buffer better?  I mean it may even be worse due to
cache aliasing issues on certain architectures.  copy_to_user() /
copy_from_user() are pretty darn efficient.

Why is it better to have that buffer managed by kernel?  Being locked
in memory (being unswappable) is probably a disadvantage as well.  And
if locking is required, it can be done on the user buffer.

And there are all the setup and teardown complexities...

Note: the ring buffer used by io_uring is different.  It literally
allows communication without invoking any system calls in certain
cases.  That shared buffer doesn't add anything like that.  At least I
don't see what it actually adds.

Hmm?

Thanks,
Miklos

