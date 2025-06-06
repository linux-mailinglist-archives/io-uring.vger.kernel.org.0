Return-Path: <io-uring+bounces-8275-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D6AAD09F2
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 00:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A219F174A73
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 22:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F9C821767B;
	Fri,  6 Jun 2025 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Z5x2iyAt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B80B1A9B3D
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 22:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247807; cv=none; b=qgavQ5Q3bPUHnDnBNG417JSxVJ6XhR4NsDDiCe6fFgVbn5/TyoMkegkAmHIcmgKh+I2q+W4aPrgoM1bRKibq1AU1EAdI3nr1dPy0ExeSWqlJ6Nh0H2QeY1BStJiUViCMoqF2y9Zjht2pCdPYvtqzP+CoAe21pYVVpWVn8Og9gVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247807; c=relaxed/simple;
	bh=GAnR29dmpk8LzSrJvHpQPD6eaKyT0czgYL+r9DG9v7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ee2L4OCej5E8Pzt5R+mhO4RXyyU+Zi7u27A5RdQTuYwZ3P/tUVM09u6XKipTDzE0Rv2nYm/fOSMYejruJkbJFONs47sRgLAl4RKtQQqoeX5QCWlJdutk4D6B1A2Z4y204d9BXl8g6bEHCuaqIoHJWbT37+AdeU3VM5EI517SA7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Z5x2iyAt; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-311f6be42f1so395422a91.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 15:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749247805; x=1749852605; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAnR29dmpk8LzSrJvHpQPD6eaKyT0czgYL+r9DG9v7M=;
        b=Z5x2iyAtuP10n14DnHPMQ+wwGtg0r2ch7Qk5Q47fCSNYtIkQPcjQlJoCoDddMLZ21p
         0fE9P8d2cYxkv8Q7mTgFvuPLQWZRVH7EZweo1ysqPhEfwq7GcwQPT08nmS5n4laweZq0
         dDfV6WJLNx2KdoFKtFXHsWDsqVSZZHqruf6GFq5Su02Lz0D62IrLbAO2vy5dNqD1kmwc
         i06E/i3RznqRjUCZALndJsJAvWzEBzaaOBoKLtNWXxewj/gQBstj7h+D0O2mKDhjStqb
         Qn8yJG7hG0SsY8qx+28ZIESaw+JowBYTjAmX+XbAL/CRftljyTG+V3Yf/0eu7oPdY43i
         tw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749247805; x=1749852605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAnR29dmpk8LzSrJvHpQPD6eaKyT0czgYL+r9DG9v7M=;
        b=lCiEkBbXDVcU7UZOKofdG+CJKvVVU7cyAYsICZIE1nOTh875A2tvA/JyPlW3kBakIt
         tHED7ss1ip2ath72P2ndwn8y7Zh9izRSXt8QpsS+Gu36ZNF3qxsy8cw4Uq0UlKmblfWG
         +FZ1OG9UScDWFFs5N1OSsPKGmcBEGsKw3qeyUDpfQWphC+/yzYAi33lYG8YL44l/31Cc
         6IrSBICufQr9Uw5f+3YPYQFcp8FoSlRaaAkJ+eIts/3sAb7pnRHBLkPfRjDYGjxozGi8
         XPwx187VB1UjmYdpt8xq59yLS7BP32D9HJKVRoPwXkDxcYbI/X++8pm8UhNQRwk2zP6o
         +p7Q==
X-Gm-Message-State: AOJu0YyZbOVUZUb4OSMF3ZH8bHdjLcXURCYWN/MxWyvfOa/DSgBaCH1l
	2yHzeQ35lFVsHIzLWaz3gI8WcJWGw8c002L1ZZ3cuteXuoMnj2tvD3uyE52FUGIfCPbDEXHESoJ
	tYJU1qojLsMAe3WDxO4ALEJ7BIY6O233N0YbOxy99YG9L6QJ0MVFS
X-Gm-Gg: ASbGncvW2yKvxWGaQy9cvrhYsugiqt5fyjt3DKkWth6IkDNKONnik0XF3rBF/p7KHDx
	KF7MlM889lGAVn9P91X9C924gEuiRC210PHmWMtnHQaqzjkmWNFZaokgy4+NWCrVVjmVCxvVYBC
	mHNHwKHRjRRrqA+Pz9/LBT1OVjtI8lA04y9rPu1Zy0j50=
X-Google-Smtp-Source: AGHT+IE8Yjkq+zktIywEq2zWlAjvBu7xfrJ5gWHs5wdFgijp/VdAtmvvuS3/AtaprIP9dZYsiSnW+sQlMtD/iwMttnM=
X-Received: by 2002:a17:90b:2247:b0:30a:80bc:ad4 with SMTP id
 98e67ed59e1d1-31346af79bdmr2933756a91.0.1749247804734; Fri, 06 Jun 2025
 15:10:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605194728.145287-1-axboe@kernel.dk> <20250605194728.145287-5-axboe@kernel.dk>
 <CADUfDZrXup5LN250NS9BbSCC5Mq5ek82zJ89W2KyqUKaWNwpTw@mail.gmail.com>
 <98a6907f-b9e7-4331-83cc-855a64bb1eaf@kernel.dk> <16075197-2561-4eef-bf4a-c50734021267@kernel.dk>
In-Reply-To: <16075197-2561-4eef-bf4a-c50734021267@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 15:09:53 -0700
X-Gm-Features: AX0GCFtGNXeH49RdKUytzcFDqcfEkskzPNFgodNKMFLSHeWTtNVu38PR7abzHvI
Message-ID: <CADUfDZrzsUAVEmEYGFbO7fOy3F07SyyVeXj80p+tPgZKUnTKMw@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 6, 2025 at 3:08=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/6/25 3:05 PM, Jens Axboe wrote:
> >> Is it necessary to pass the sqe? Wouldn't it always be ioucmd->sqe?
> >> Presumably any other opcode that implements ->sqe_copy() would also
> >> have the sqe pointer stashed somewhere. Seems like it would simplify
> >> the core io_uring code a bit not to have to thread the sqe through
> >> several function calls.
> >
> > It's not necessary, but I would rather get rid of needing to store an
> > SQE since that is a bit iffy than get rid of passing the SQE. When it
> > comes from the core, you _know_ it's going to be valid. I feel like you
> > need a fairly intimate understanding of io_uring issue flow to make any
> > judgement on this, if you were adding an opcode and defining this type
> > of handler.
>
> Actually did go that route anyway, because we still need to stash it.
> And if we do go that route, then we can keep all the checking in the
> core and leave the handler just a basic copy with a void return. Which
> is pretty nice.
>
> Anyway, checkout v3 and see what you thing.

From a quick glance it looks good to me. Let me give it a more
detailed look with a fresh pair of eyes.

Best,
Caleb

