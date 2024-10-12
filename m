Return-Path: <io-uring+bounces-3615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C7E499AFEB
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 03:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E91C31F2285F
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 01:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3DCFBA4A;
	Sat, 12 Oct 2024 01:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IoigjXJH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF3B8C1F
	for <io-uring@vger.kernel.org>; Sat, 12 Oct 2024 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728698137; cv=none; b=d4ulK+evU5vzkrC9/T6kiS0Y0/Y53qxPU6PRE1pj92nt+pnVx182HTuE2+YeGo2pda4DpZEW7DpfhCQG3iIxLE4uMlewY5UBQNinXYlBe+g6ghfpaXwX118gp8tOg+Z3L1FhwJNmUus9Vdj+d4RS+6wfSj09mVnoyGQm5iE9EHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728698137; c=relaxed/simple;
	bh=WrpCUHBqqRYvkvVrVQYVRAjgSHH8xeRzkpUzBvZgfxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dtkB1D710AkowboMw5m1gL+Th7vDmfLMj9Cs+/eAhhyLMQwSUPDyIg+h2VxvIJXuTMWDG4/Db/qRnuG09pwkr7e1+yJ6TzaxEMMOitEwOhCijC5bK7SvGQ5lzXQzY+1PQ5VZCMyS1OecvS0DeHIZcLeKv3sAGCwX0aUwR7jKtTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IoigjXJH; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e290333a62cso2345089276.2
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 18:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728698135; x=1729302935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYZ9W9Dyk+4JS0lEeSzYdZsOI/hfDogAvz7VZ4lm04Q=;
        b=IoigjXJHhIrUwegoAZ0LwgAWOHjpfeFw8pvN7mdesCdacNh3g5PAvk+HgdjJHiov+g
         ccPP/1OV+0pxue9hjDl5WApkOt9By6NlItSU9v2I1SnHlXTc6HETflO8McSPMvB7xbOX
         lgjoStNpm/o78OzTAVEXn7hi+0PGUZ4pptEfbWJleCzP6LbnOKbmrDkmQKHihe4N38Yz
         4x5f0wgBCkIiD9KNIjIRk9eGeEC+sHLdxLy63c+Lk3XxmpKGmEd8NnWg3wtWnXHHYYFb
         2j2ClUsb/jNPLnsH936W8beDp/cZ3kaSRYiAHibILkSnstXzTDM+RsZk7lMXyD5L3DWB
         MzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728698135; x=1729302935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYZ9W9Dyk+4JS0lEeSzYdZsOI/hfDogAvz7VZ4lm04Q=;
        b=sH2jsAhhmhixuj9WygsoZvroI9Z5SH+lKf3orY2NQQN4btudgV/+B/tUaOzsW/a6ny
         pi/hC1XyE2PmwR2MARhNidGUsyyN2BS776XWt6NYa86aw+rSPYdn3bCJnAiS2jdRJPrW
         Tlze5WAiGb6dJ+yYTRkoAAdXXvOE+3tYhplmkcwW46sUbV3NGvi86TKud/V81kyOcVbG
         xCWSSRbh6YPJavJVj+w+aqYaXTuHQd47ddzzRy1CsoZ56yViAo87urk4ZWsvLyOI11LW
         uNxoRgH0RuZ3BB+PZbF+Fp8ZjE4Vpgv9VPRjaIOpasMuY7OsI0ejCki2bBi9WzMYjiPm
         WYjQ==
X-Gm-Message-State: AOJu0YxtFR0yUsUaVM3urco4NGkCXXawjb4ExzWN7t3yjpMOgUz9dZNf
	ulnnwKnFC6BH8Y9RT+XWTnKyHnVGg2ZHZFV6lTvEWlyKNIy7K0SzXE2V5XRQ7d+jibq4fwXxFfr
	VUdxWWN2hW5InmamFjqfzB+7TomU=
X-Google-Smtp-Source: AGHT+IEI646QESngtcabTt+DRgBRspBbeaFY0hTN3yI5jCEso6VCYNKz3yiWpA0BvO6t/O2VGRXy2gpYQRjzwNGNMTM=
X-Received: by 2002:a25:acdc:0:b0:e29:2ab8:f3b4 with SMTP id
 3f1490d57ef6-e292ab8f4e3mr2331738276.52.1728698135355; Fri, 11 Oct 2024
 18:55:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
In-Reply-To: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
From: Ming Lei <tom.leiming@gmail.com>
Date: Sat, 12 Oct 2024 09:55:23 +0800
Message-ID: <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2024 at 4:56=E2=80=AFAM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
> Hello,
>
> as discussed during LPC, we would like to have large CQE sizes, at least
> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
>
> Pavel said that this should be ok, but it would be better to have the CQE
> size as function argument.
> Could you give me some hints how this should look like and especially how
> we are going to communicate the CQE size to the kernel? I guess just addi=
ng
> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
>
> I'm basically through with other changes Miklos had been asking for and
> moving fuse headers into the CQE is next.

Big CQE may not be efficient,  there are copy from kernel to CQE and
from CQE to userspace. And not flexible, it is one ring-wide property,
if it is big,
any CQE from this ring has to be big.

If you are saying uring_cmd,  another way is to mapped one area for
this purpose,
the fuse driver can write fuse headers to this indexed mmap buffer,
and userspace read it,
which is just efficient, without io_uring core changes. ublk uses this way =
to
fill IO request header.  But it requires each command to have a unique tag.


thanks,
Ming Lei

