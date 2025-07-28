Return-Path: <io-uring+bounces-8850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8A3B1446B
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 00:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A38D16EE1F
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 22:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E24229B15;
	Mon, 28 Jul 2025 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0LTMk3mw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438E212B2F
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 22:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742053; cv=none; b=JKYV8AT8tcMhAmAMGtaslrMaMIOy18iocjFsLNkSk12AyXu6RI1jlYbsKn+WSfSV1xfIHiuQlx9fiOS0xZkZhF8138HvxAvhEe3wCpdATywGWTDarGCbNjKOTJfKXQ3PvC9zYFZ5hHTFBrEmOBJSpMGlIdxIFbvXYp+1VD7tUJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742053; c=relaxed/simple;
	bh=3UCrbmM4TUe5jNsd3OB7q3gxg7zx3lB2FyqhXts2q4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TOKci+DpEM+6guS3sbNPx09pxxdoSpqvQ0PZYsybV/s24tmchUkQ/jp01UZm86o+DjjCNHschnjyu2MeLKrKoh0/pG4VMNbvp/2I9I9HOGn3ImgfVrj0SdbROqBDnALW1BFuJ6KRtKH35GAae1R3Xo+iMkSoOIyQDogjEWlKV5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0LTMk3mw; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23dd9ae5aacso30635ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 15:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753742051; x=1754346851; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3UCrbmM4TUe5jNsd3OB7q3gxg7zx3lB2FyqhXts2q4A=;
        b=0LTMk3mwc8OZ3txTRkz8FJYGIXPW1dDwnfr8XrGeIQ/IpYF+zQumoGK9aAsptY2Mgq
         yNXM4I/AiN1G/iuAfFrFxHNZxC0rCM2UQ2me3FSeiOnceawmwud0h3d6z6n0F5OZt6CN
         cqaBzKV4HfUcihFo1pXPYmHx0VzWfs4hON+LHLisIpz0Bz/4AZxO8h8Vcqwokc4q/mB+
         DVBNi+rlxjhQAdUMNcJ5UMqmdS9U24/Rw1LxRFXMiY4RXKre0POtVmXyvt1niZkbh6E1
         0mV5L1UbHGD463PX+sp/HTNurSrtS9PhHjvbrpjs/Wc9hplZKJIcdb3MnL5tt0DL9IZv
         I6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753742051; x=1754346851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3UCrbmM4TUe5jNsd3OB7q3gxg7zx3lB2FyqhXts2q4A=;
        b=ID0h8Am7Hj+swWaPtIIwKVu1Jn5fcL4S2IAfeopo/tHPlanmOTqo8XNIfCL4zFo+L1
         YhhUZ9xbnmnTmv6ppzuBRIDOc08wQbrrnfqu3btZ3eNwvauck9T8BbgffQvPrRwzVPIh
         32xHAzShpg+I7AdohYK9kxsv7fyKE872QbO/ykCe8IQswYXaTzxr6U4JNw/mFbZ2OAVx
         Pnc+472cCXBDPHSHFuhdlHrdve32Vb1n1VLQeHi7fckubO8mLI0Q9s3KlZZo91RbzZQA
         UHIS4bOSCKJA2VuONiF1ozQfAzXo6A0nQMwXiLio4ol+2EZiIu5TlAY22QGZkGWwPuPH
         YZNw==
X-Forwarded-Encrypted: i=1; AJvYcCXlOXty74mRX/bsIT855MNm0G88WUA0jnoZBvgRo4PiePpvNKN/bYTeaI9oKIqg2ZrNjL95gxOMZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBvFn95Q6C2VyM427B9P+Urij+b5aW/7gm/f+Dcpy13FcHxFyI
	4Pokeuw+d546TRPDpsTxdAnDwZHsfnxePDPtJpF6COB5uDb64pDyEchEWhOHodZ9FNKph74XytJ
	RhE9UyqhvemglCt0yw6/OlD5wYazuLl/HCD2OTkQg
X-Gm-Gg: ASbGncsHj2nMBSQDCXAR2SxB4paft917ex2PY2i0T3kgZ0397NgaP6HbOjZ+3TXehIN
	j0qs9dlVwL0wfntpbpZw15TuNR0FFJ9/gu0bXRg3WPRqnc/rQBeHe3fafCX4DChP9R2nOH3pCYK
	4cRG3Deuj5nrEZMLIx2KkN2zGU1ConvTUFS74doYV8smR0KM0b7mjvZv0i0qecPpbNgTcLMwS9z
	ZBklhbx3KN+T4cNp0ziFEdnU0AFGFd6qQbRRA==
X-Google-Smtp-Source: AGHT+IEAXAUwoTkzWcguXCPpeCJknoeSxf6WSVJcrpemivAZuZn2dLYX+Id7YooQkRji8cvKSzxfT2H6Go7mECX9ow4=
X-Received: by 2002:a17:902:e890:b0:240:3c64:8638 with SMTP id
 d9443c01a7336-2406789b433mr1218905ad.6.1753742050476; Mon, 28 Jul 2025
 15:34:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <be233e78a68e67e5dac6124788e1738eae692407.1753694914.git.asml.silence@gmail.com>
In-Reply-To: <be233e78a68e67e5dac6124788e1738eae692407.1753694914.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 15:33:55 -0700
X-Gm-Features: Ac12FXytRXnslMV_ruTnL6but-O-GUrAFJf66XeC7Rn8cCz4NROrnnjw16MuHEc
Message-ID: <CAHS8izPZE752dfZVD6OzGJ7z_tmh2n2tvJK_0yd5mP51FCSKmw@mail.gmail.com>
Subject: Re: [RFC v1 15/22] eth: bnxt: store the rx buf size per queue
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> In normal operation only a subset of queues is configured for
> zero-copy. Since zero-copy is the main use for larger buffer
> sizes we need to configure the sizes per queue.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

I wonder if this is necessary for some reason, or is it better to
expect the driver to refer to the netdev->qcfgs directly?

By my count the configs can now live in 4 places: the core netdev
config, the core per-queue config, the driver netdev config, and the
driver per-queue config.

I honestly I'm not sure about duplicating settings between the netdev
configs and the per-queue configs in the first place (seems like
configs should be either driver wide or per-queue to me, and not
both), and I'm less sure about again duplicating the settings between
core structs and in-driver structs. Seems like the same information
duplicated in many places and a nightmare to keep it all in sync.
--=20
Thanks,
Mina

