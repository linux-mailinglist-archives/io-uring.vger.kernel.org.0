Return-Path: <io-uring+bounces-9782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9653EB55635
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 20:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED52E3B4FD2
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 18:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8055432ED38;
	Fri, 12 Sep 2025 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uWmgwAtq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4162334702
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701828; cv=none; b=km3iqIplsBeTFfdcreFD7YvKnUxess69QEnjNqeBRGNr3yLszrtaCJwXsFPqN/u2GlM7gP3AbORxPkBa/Q/KO3UZstYOgH7QUCJQHPuKwVEKW1Jj8ce42acdTWRRqGXG3Pb3hBlc6Uayubnflaj2CBhCr40JuxiRszBk/COm948=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701828; c=relaxed/simple;
	bh=ZBK6INSF8abS5w/Gb94TA30BsU7/QHkDz9+MKFLMT/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VKIgE6FsE5OmB5KpXHiyR0EGOQZ2PEVCKPc+ctkWPYEgjLkHD2IW1fPM6tg/fXzUzjA4bMvGxIpHk7k5HiPTf3mgZ0cPEbGx/2UQ46DcxGQKYgdTENc9RNouhOl7q/VqoW6xU6UaDw0KhPnKWFtTE0EmFh1WZrHYTWyh/FpSZ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uWmgwAtq; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5702b63d72bso1332e87.0
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 11:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757701825; x=1758306625; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBK6INSF8abS5w/Gb94TA30BsU7/QHkDz9+MKFLMT/o=;
        b=uWmgwAtqIbhe4x8XzC7JUvswbAulUb8HiDCAkYjWOzBgEbTWiU3JwVMv9StJEG0Zi5
         kCRdZd1WbYuZYC1Pv5If93s/O7+Fv/02LWNc2ygLfmDYDovSfLzM/7PjdyC/lIn2g5i4
         Q+UKTidWv9GJXBfdk9N/PznLD1i/vEargBV4ioiBdQIACtTTtJpwFop9cjUe2qu9wYR6
         YsyKVasFBc5MdGI0HnP+yQWXFteC/4kdODT+ckKs7EU4VboKmFTxYTuH+/YY1Diawzxr
         +F2v1f/k3ANolwfPs96wRrt8vJ/1X7D82hSxjXwChMqEMQlpUYJWUmWyHjohjE0j8HuC
         nT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757701825; x=1758306625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZBK6INSF8abS5w/Gb94TA30BsU7/QHkDz9+MKFLMT/o=;
        b=fdbqI2SCd8SoI7UL6yURPaL+w0wb2ZoIxmr/mQxrWDYX9Opsc2wIgDooM5gjMMqh9t
         GdeGSPj6QdzxnAF9iRhPkMNF03cL3PZpxn9/YcowUxWqVenV+DeNZggV+iflD176w+Q2
         GnDb1NHK2uNtTFzgUgM79eURrqU7/RpqcMKUMJr0mvOB6uYRm+3goPKJm06kvspeS8IA
         4dqYcMvvNS4pf8MFMrzAWqEPLN750itP6CPc6ky0jbbN7Lsy4QMRMDitDIroPn5n00nz
         xqtz17MAcW0XBS44TWlo0Dcg38TfQyO0V/8Hih8kaLI2IB74YJ4HUdEmBKqSw4MlS1He
         paSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWicr6z7qoEAKOZ3rWXWn/72NqJTCmA8UbJNInYFaSfTkkkvMkOSX2AKi6l48/aEwimOL4cH78Jaw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw38Z0oISHpU38l/9rR+cqxZUhA1Z5iKR2UD6OJb2E+569W1Ige
	QyZKQgdL3bfnUUy5dt0m2q5z9RGH9U/m46TZ2hg9XiWbjuSCroiUAt5CiTtrhiopB8iUXWmO+/T
	FUjjyAI6xvdeM3dNxGXi3EeilY1rPh19g+fODzInx
X-Gm-Gg: ASbGnctbxqvEzKQTStFyKsAt9aKwOPxZfGgN7977HNA6o67FaqPmGPGQGr7CGw3+CTU
	8BxVRgSWhnQKDD+gbxXQjj2QanjO2oBiZVz3HwjWLQdNzN9cqV79HOIejerPFE+NpOJ1an9TR4m
	eqWud3xaYFuVjGhsmWhCigFCK1scMuHG1+UJHEgCVs1iIEQp/N+pi7zEG8hivgHA6ghGEuY2472
	gWqVXfoBo2gvslEblEiTNqVAXpfXSJkCgDInsxzX32EbeRw5g5XB0c=
X-Google-Smtp-Source: AGHT+IEueAM5ZvPlNpUmbSAWOcXOSzuSYZGsc9dYT5EAGBdPP7lLvMMPzZwm/ASZ2J9qXzs9PYNF72nMbByIJuEiG+g=
X-Received: by 2002:a05:6512:3d16:b0:55f:6a35:dd47 with SMTP id
 2adb3069b0e04-571d0fcfcdfmr17413e87.4.1757701824277; Fri, 12 Sep 2025
 11:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
 <58ca289c-749f-4540-be15-7376d926d507@gmail.com> <20250912072232.5019e894@kernel.org>
In-Reply-To: <20250912072232.5019e894@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 12 Sep 2025 11:30:11 -0700
X-Gm-Features: Ac12FXzOnZNg9pH6OLjiPOEStlyr4LYxuJeCcrCbZRJNmgkdxO7NqDSHI7y1rOU
Message-ID: <CAHS8izOCc9-MydM6xDO8SsVs1bAZWuKcCWSJv_t0AsJznGnipA@mail.gmail.com>
Subject: Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get
 dma_dev is NULL
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Feng zhou <zhoufeng.zf@bytedance.com>, axboe@kernel.dk, 
	dtatulea@nvidia.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 7:22=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 12 Sep 2025 13:40:06 +0100 Pavel Begunkov wrote:
> > On 9/12/25 09:39, Feng zhou wrote:
> > > From: Feng Zhou <zhoufeng.zf@bytedance.com>
> > >
> > > ifq->if_rxq has not been assigned, is -1, the correct value is
> > > in reg.if_rxq.
> >
> > Good catch. Note that the blamed patch was merged via the net tree
> > this time around to avoid conflicts, and the io_uring tree doesn't
> > have it yet. You can repost it adding netdev@vger.kernel.org and
> > the net maintainers to be merged via the net tree. Otherwise it'll
> > have to wait until 6.18-rc1 is out
>
> If only we had a maintainers entry that makes people automatically
> CC both lists, eh? :\

FWIW that was the intention behind this patch I sent:

https://lore.kernel.org/netdev/20250821025620.552728-1-almasrymina@google.c=
om/

I didn't get any feedback on it; I assumed people are not interested
(enough). Let me know if you want me to press the issue and send a
non-RFC version.

Although that one made sure that the changes are sent to net, only. I
guess I could add the io_uring list to the L entries.


--
Thanks,
Mina

