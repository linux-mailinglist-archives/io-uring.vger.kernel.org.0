Return-Path: <io-uring+bounces-1138-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E900B87FD91
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 13:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18F3CB21334
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 12:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D6A58AC3;
	Tue, 19 Mar 2024 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcT3I3I7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5921E500
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 12:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710851438; cv=none; b=KjNjpWlVPzXGMm10B/iD8Mr5Pe7ilG1KyqrSLFGS03a0egBrFuYw1COgj4zbbcUw+NKvMQMW7RWT3YN2M0Fcmqvd/TVftVUiAhSeoLNKns9FpDIUMLXAfAja4vfbGkKSJq9poYZq74XnKalDR9wlLwy5kQLfs+/CzxTEldcZ4VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710851438; c=relaxed/simple;
	bh=NuYxhdluYleWL4hPUjiEYWiMglYwHi6VwlRckDkov7o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zc8STgctcFauM2Bd0OFFBW/aBNo0oa5rn8FMePZ5GBoMmzOvMJtVNl0wFxYx8cSbcLBRU9LfH2v/ONDpkM7fm8qtgeMgeH6HLkbJE1MN/69F+sgEz/N1wzRAgyB3lOsx1b0xuWFpNO1FecMVTdZ3mU7VKWk5nImByDl2s9JSNgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcT3I3I7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710851435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hk6fXodssFp8pxdmo3yTVAFcI2aHv/hJ/chEAC3UfVc=;
	b=OcT3I3I7r3FKYfLkT8eie0KQgoj0Jvb7S+Qe6go/ZtL73vDohwHDb1IUMu06Pveeoi3I9s
	I5JE0TwyBNZDySKyEzfg9bS/236zCC4Y7Q6ZOCpvow9u7E/imB1VFiiHQlBu5LWcaAbdmv
	q/zM3aS/AbCf6JIygmkX4gAVH5KgvcM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-rBBJb4AqMVaQuYoyO2FUyA-1; Tue, 19 Mar 2024 08:30:30 -0400
X-MC-Unique: rBBJb4AqMVaQuYoyO2FUyA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-789ef1b84a7so20342985a.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 05:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710851430; x=1711456230;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hk6fXodssFp8pxdmo3yTVAFcI2aHv/hJ/chEAC3UfVc=;
        b=iKLgddmoAnzLyzAJ1qEad0mNqyaOvaXb80ZOcxwW/oU4S21pb2TMfK4wJmJ46NTTIU
         92FUSxA5JmZ6ZTr3AAoAulBQcN16EVKiocbaNAh4jlAy8tgDZ/AElRt3+81qPF1mMkYp
         Qn+C1JxlOALvo17wE8zvSgid7CHCl0TPyxNflJ2XpbLSd+J6Y7ernRe7obn4K9M7Uy/V
         +zavJHkQqwKv8KgxoIdXMGTnLtsPYBxjZDWuquBVupKztoiqEy7UwTKbzftAalDVbi5M
         IAoPwiIXoYaU0fv6Bk2ZRyVUDFhPzWgV+5GCJcjQXCcQhPWC925tUpmCgsxuaquMe/l5
         s7dg==
X-Forwarded-Encrypted: i=1; AJvYcCUbbETfH1S6y6acX8e8rFkxB+H05g2YUKaqxm90aPYDh7d1xMeeUWOmfm7fJnWgp4Fihc7JviUgRD4o0u3ktTxqkbv2ipbBGxE=
X-Gm-Message-State: AOJu0YwUYKyPNU87E/u4i1FctTha20QqRfnZfNR3RuGf615i2uLWqfog
	B8pGUuIclPAd0aS+dQe4P3C4YyaSG4pL6s/tPLYoz88enyb/ng1IMOmJNkItUhZ7G53d7al9D5X
	cvjdDIHd6xE1TQloihY3ICv4Ej1Fn7WIiT0DKHlwOYh7+PlihuxD1QKWWFX2o2aK2
X-Received: by 2002:a05:620a:198c:b0:788:3a16:d8b5 with SMTP id bm12-20020a05620a198c00b007883a16d8b5mr14337953qkb.4.1710851430038;
        Tue, 19 Mar 2024 05:30:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHd9RalBe1bNJtEB8MezogsCo3Vhxoc3LhemnSbnzLQ6LMNhvFa5LLiu3OB+VRxEYhPu6tgxA==
X-Received: by 2002:a05:620a:198c:b0:788:3a16:d8b5 with SMTP id bm12-20020a05620a198c00b007883a16d8b5mr14337925qkb.4.1710851429706;
        Tue, 19 Mar 2024 05:30:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-224-202.dyn.eolo.it. [146.241.224.202])
        by smtp.gmail.com with ESMTPSA id y1-20020ae9f401000000b00789ed16d039sm3045072qkl.54.2024.03.19.05.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 05:30:29 -0700 (PDT)
Message-ID: <9c63cf0c31792270026fc673334aa76f855eae35.camel@redhat.com>
Subject: Re: [PATCH] net: Do not break out of sk_stream_wait_memory() with
 TIF_NOTIFY_SIGNAL
From: Paolo Abeni <pabeni@redhat.com>
To: Sascha Hauer <s.hauer@pengutronix.de>, netdev@vger.kernel.org
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org, Jens Axboe
	 <axboe@kernel.dk>, io-uring@vger.kernel.org
Date: Tue, 19 Mar 2024 13:30:26 +0100
In-Reply-To: <ZfgtgwEM69VPJGs7@pengutronix.de>
References: <20240315100159.3898944-1-s.hauer@pengutronix.de>
	 <ZfgtgwEM69VPJGs7@pengutronix.de>
Autocrypt: addr=pabeni@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-03-18 at 13:03 +0100, Sascha Hauer wrote:
> Apologies, I have sent the wrong mail. Here is the mail I really wanted
> to send, with answers to some of the questions Paolo raised the last
> time I sent it.
>=20
> -----------------------------------8<------------------------------
>=20
> > From 566bb198546423c024cdebc50d0aade7ed638a40 Mon Sep 17 00:00:00 2001
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Date: Mon, 23 Oct 2023 14:13:46 +0200
> Subject: [PATCH v2] net: Do not break out of sk_stream_wait_memory() with=
 TIF_NOTIFY_SIGNAL
>=20
> It can happen that a socket sends the remaining data at close() time.
> With io_uring and KTLS it can happen that sk_stream_wait_memory() bails
> out with -512 (-ERESTARTSYS) because TIF_NOTIFY_SIGNAL is set for the
> current task. This flag has been set in io_req_normal_work_add() by
> calling task_work_add().
>=20
> It seems signal_pending() is too broad, so this patch replaces it with
> task_sigpending(), thus ignoring the TIF_NOTIFY_SIGNAL flag.
>=20
> A discussion of this issue can be found at
> https://lore.kernel.org/20231010141932.GD3114228@pengutronix.de
>=20
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
> Link: https://lore.kernel.org/r/20231023121346.4098160-1-s.hauer@pengutro=
nix.de
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>=20
> Changes since v1:
> - only replace signal_pending() with task_sigpending() where we need it,
>   in sk_stream_wait_memory()
>=20
> I'd like to pick up the discussion on this patch as it is still needed fo=
r our
> usecase. Paolo Abeni raised some concerns about this patch for which I di=
dn't have
> good answers. I am referencing them here again with an attempts to answer=
 them.
> Jens, maybe you also have a few words here.
>=20
> Paolo raised some concerns in
> https://lore.kernel.org/all/e1e15554bfa5cfc8048d6074eedbc83c4d912c98.came=
l@redhat.com/:
>=20
> > To be more explicit: why this will not cause user-space driven
> > connect() from missing relevant events?
>=20
> Note I dropped the hunk in sk_stream_wait_connect() and
> sk_stream_wait_close() in this version.
> Userspace driven signals are still catched with task_sigpending() which
> tests for TIF_SIGPENDING. signal_pending() will additionally check for
> TIF_NOTIFY_SIGNAL which is exclusively used by task_work_add() to add
> work to a task.

It looks like even e.g. livepatch would set TIF_NOTIFY_SIGNAL, and
ignoring it could break livepatch for any code waiting e.g. in
tcp_sendmsg()?!?

This change looks scary to me.

I think what Pavel is suggesting is to refactor the KTLS code to ensure
all the writes are completed before releasing the last socket
reference.

I would second such suggestion.

If really nothing else works, and this change is the only option, try
to obtain an ack from kernel/signal.c maintainers.

Thanks,

Paolo


