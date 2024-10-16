Return-Path: <io-uring+bounces-3719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 605D79A07DD
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:55:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22187287617
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 10:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE311CC14C;
	Wed, 16 Oct 2024 10:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bRZZufkp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A5206940
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 10:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729076113; cv=none; b=n7AXyqcLiIyjB/ss+zMmkNX0Tsm8u47EAzHeq6B07RFByBvCHPpirR5KA5hbjisvSu28RWtmz5TteiptKQpMSczpMtx09uN6Iz33jyNltF6XAn5bh7oQR96P35lx2qhdJHBkp//2atb5VXH9AnmDkRFLBH6En8pPeEtKVl7NX4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729076113; c=relaxed/simple;
	bh=ERGioYh8/tqLmwLXbTNCliLtzv5IPBh+7i9QlKlCSyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E16XB7IvaY0XAeOQf18bLJPOwWt2Ch6bAISeHL0KRNAeCcy18HNJ7wbeBWmYhONEILxEvD49VOzBSemTbbZNwoUpePNhCnFn1MfYvfUrsOWvjiNow/lnGdApZ6M2XaimVZUrswkIOEhanB/5/JOdKbCvawm4ecO32++kGJp4FsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=bRZZufkp; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c9709c9b0cso5162015a12.1
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 03:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729076110; x=1729680910; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T5vEX2LhqaCTsjOGjWgiPLEcZwTOrc7s/RPxfVpw+tw=;
        b=bRZZufkpgWdlX0q4+YZgGBKZYBxBDgJKj6gE/0RAQrLB7Yhl+i3XRgDkBM5qvPAVDu
         9vtfHa0KcRMyxoaChbFN8IzCp+8kZaD5i6KU53GJI2T1gLYtM4cj2tLLWK8/Vx52ueI5
         EdHZ/jtUDnFQn/F+a3z1Z2EfRjmZ+tML5jCgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729076110; x=1729680910;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T5vEX2LhqaCTsjOGjWgiPLEcZwTOrc7s/RPxfVpw+tw=;
        b=iPyuEbu7x6pKvObZJVcTBkLHIRyP/Qxj20aINulshR6k93m3fU5sC7l/hQWIDy9H9A
         A1K0RjZb3nlGH0EEuNjZg8yQBrKlC8L4lYP3yZTiekMEJwSvVwd8IWSTzTco3FOEVdA1
         08q7iTBNXlp8ZNFr9tGrKV7ge0e0mFyKuutFqFswtvlBmKnr01lznJ93qPE1Ab+bbMO3
         B55PWa3HvN4okwxjJZgOM59hT7KEWeZeAvTwKYlUAW4pX9hums1k5CPpYuJLjoC5aAoK
         TRk1fNsWmR1HsZqu6kzZLNXKUi3aXKmAU3MnEgWESnhd3NmTxfqaWoFrOaWJ+o/b3zFy
         mzOw==
X-Forwarded-Encrypted: i=1; AJvYcCXFlb2hTDNgYB//JLCg2kcZJ6C4Z+oYoIsQDGasmZPHONwYXtAE4EpO9yYHJTJ7+aDtnCjNBAFCmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxswgP00UI5RJEeCzg2DlV/oMagLcU5RKpio6yfsJnosCrzHtb7
	Mkh1a1HN5pV+2+59svMuMvG6yW6M6NasvVUBrF8ZVcDaX7A91Y8ebBuahQWcqUMrk/GZMBUcxPJ
	08m/1j555Elg/Cb4lh5Nwnd8zIEM7i1A8xdCa3Q==
X-Google-Smtp-Source: AGHT+IFeSLkPzx9t9/jRUd3ylF3WwuVeH5Yik//yNa43ieh4r+vAG1F46Lgy7p4q+5C+MWLcXqMFOZz5b9VhvdiD2iI=
X-Received: by 2002:a17:907:9288:b0:a9a:1585:dd6a with SMTP id
 a640c23a62f3a-a9a1585f6fcmr885898366b.36.1729076110078; Wed, 16 Oct 2024
 03:55:10 -0700 (PDT)
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
 <e30b5268-6958-410f-9647-f7760abdafc3@fastmail.fm>
In-Reply-To: <e30b5268-6958-410f-9647-f7760abdafc3@fastmail.fm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Oct 2024 12:54:57 +0200
Message-ID: <CAJfpegs1fBX6zDeUbzK-NntwhuPkVdCoE386coODjgHuxsBuJA@mail.gmail.com>
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Oct 2024 at 23:27, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> With only libfuse as ring user it is more like
>
> prep_requests(nr=N);
> wait_cq(1); ==> we must not wait for more than 1 as more might never arrive
> io_uring_for_each_cqe {
> }

Right.

I think the point Pavel is trying to make is that  io_uring queue
sizes don't have to match fuse queue size.  So we could have
sq_entries=4, cq_entries=4 and have the server queue 64
FUSE_URING_REQ_FETCH commands, it just has to do that in batches of 4
max.

> @Miklos maybe we avoid using large CQEs/SQEs and instead set up our own
> separate buffer for FUSE headers?

The only gain from this would be in the case where the uring is used
for non-fuse requests as well, in which case the extra space in the
queue entries would be unused (i.e. 48 unused bytes in the cacheline).
I don't know if this is a realistic use case or not.  It's definitely
a challenge to create a library API that allows this.

The disadvantage would be a more complex interface.

Thanks,
Miklos

