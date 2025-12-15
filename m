Return-Path: <io-uring+bounces-11039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE725CBC522
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 04:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3810301A1E4
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 03:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74283318136;
	Mon, 15 Dec 2025 03:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8xW8ZYr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8881BC2A
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 03:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768739; cv=none; b=RQ9jUHCrCB0GeOb4wqlPYsXrt0Kxfa5zUk3KZ+EL7P2bB4F6RHhmF8tmMDzYcrAL56Jrc2Kd5peKxTd8N7mzXoxihmkIcfQoSTKJpPOcyEHUWQG0DMylyJD6kFsFLvbTDb5ramFqJF7y6sXyb3uaYCMbJy1pJVI87vWE1MRWIzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768739; c=relaxed/simple;
	bh=uQBvnW/e6bbqaVO7iqZ0fDQ4cn61AnSQcTqOWDg6TPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QykocQ5AxlfUwQMAzSPZ6be87JcFqRzTnOj4mk18rLmEzCmwEM64gOw389XszqkKgHDm8ogQrdfxbxLzw9EMI2McWTHtzHitggG8IvA2S/9JBoFMWgAUmhg9EzevQK54RDx7cEQTVkZy5GV+2ucsO8mPvie0LMXLhQWtMvHvatc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W8xW8ZYr; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed82ee9e57so39785851cf.0
        for <io-uring@vger.kernel.org>; Sun, 14 Dec 2025 19:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765768737; x=1766373537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lz1IfhnqETSI9t44L00u+n6oS7ndXcJbN+DBXOaew6I=;
        b=W8xW8ZYrncfh0oS0DVyhllacB4mgMUnEBEFsFYAi2VyRig8plRVMlAfFZvBBRfi57c
         0gJ69tRQ7CK8TmiOz0pMBr+eXAOLVewkIHD0ljsxRX1E1bBqMVkS5hpIFCyAW6lBu+1+
         X5m/nRZtzYRCaw+INierQ2meprcPn7Ydslr4Qq/2JGRH4VyR/zGwZu41wuQcDfcF0ssK
         yshQkF9qENLf/6iqRgTNV0CR8h9ogPk+rSFiaJayaiq42zjVxwskhRjLGxM+RpdYCguP
         y2NjV4XnQV9MbCL+hsNRY6tXn1I1/2lqr9PzsJfqKXENuk+xmvWvUkwmTxcIJSPrXr3j
         zTEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765768737; x=1766373537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lz1IfhnqETSI9t44L00u+n6oS7ndXcJbN+DBXOaew6I=;
        b=RXxkreq3x6MBJfe+I9m1s7saqdWkqN2/NySvI1ac0N7Z0+sbx/UOd84zzHfyW5Lh5M
         GV8DUSDl4b05XL9zeEWsF7PoZw2eeFs6FScLuG1IEehTAe4v6tadf8g0wymAicy8sjTb
         la969h5/3WISmtfk0C/2dMa7Yps8fOvjImOxG3CVJodUpWm9obZ+e9WQ00mQII7aj7CC
         i6JK250uhqnO1Jr09uBPV5TszBzpD5dhwmVKhJWKs0W6tCS9PvFPIhP7xljIMKU+rlP/
         pMYRckuy2AgSqNhJj0tgva8ZwrVi1ot/c/9EXLZSt1SNVkMy8Q/RBPmGn6BIk4iSfBE6
         d8NA==
X-Forwarded-Encrypted: i=1; AJvYcCUTm13jCLw9iUUldniTkx1AZkyKHH3A8Zzop68VHB2Lnrar2b5EcfjxFnLkf3LuZmEPki8IqTJM7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLS04GrLIAZ+L4KHV7V4shy0WevN6XlHCttEFNvu1PuBEh2ymB
	BS9tGwImugFFduVsy3IO2yp7jJW0O+1lkapIm7iH//KmqhH3ASHzP1g1oQru9f7zcE0B9lWiVOQ
	+yJMVO/mrVdyPJVh0m6Pmy4+YNpugBVU=
X-Gm-Gg: AY/fxX4UF/I9/2cHHZSE4vzRVwLguB+fwtRsshBl7vr8G5W9mrfeBZVCh7cRfJeWTW7
	FOyxBlh9ud4JbdwTLqP8fr6kucXuk8si2byHY9b8NPHrsDka5lg+MPsXRPwTZaRqT6EID9HXJ6y
	CPHlZGls2gKAAxhxmrZ3LAaW4d7dunkxxfrt9JxE9QD+xk5jJrJgqpGR5vUTFS9wOH5Wosq2nc/
	LclgM/Xc5x8hSDvz1d3zkDNshkXpuPPbTphc9QzmF8mdRLn3GgD5bqSvii+wQQA6x1NVfIcDPBb
	yig7GhXGYSA=
X-Google-Smtp-Source: AGHT+IGoVrRl3sXBpIihQZVFt/5QT+og+7sqL30wUo0wjTzi+bBIZMoXz/xdHPYRZZ5/yMN6wjVve1XPeLHy/pjudSU=
X-Received: by 2002:a05:622a:2588:b0:4f1:ccea:6744 with SMTP id
 d75a77b69052e-4f1d05e086amr126789811cf.58.1765768736849; Sun, 14 Dec 2025
 19:18:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-31-joannelkoong@gmail.com> <20251213075246.164290-1-safinaskar@gmail.com>
In-Reply-To: <20251213075246.164290-1-safinaskar@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 15 Dec 2025 12:18:45 +0900
X-Gm-Features: AQt7F2ryNYoQq9IP4N326aDp9Dc5rncP19wsPjSPJuCs4hAuELjcRUrZbrFo13w
Message-ID: <CAJnrk1YAyk_T81FTFgT2a7bM9-vEtvV_-htbd=DJ-oBtoyn=Xw@mail.gmail.com>
Subject: Re: [PATCH v1 30/30] docs: fuse: add io-uring bufring and zero-copy documentation
To: Askar Safin <safinaskar@gmail.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, bschubert@ddn.com, 
	csander@purestorage.com, io-uring@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, xiaobing.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 13, 2025 at 3:52=E2=80=AFPM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> Joanne Koong <joannelkoong@gmail.com>:
> > +  virtual addresses for evey server-kernel interaction
>
> I think you meant "every"

Yes you're right, this should be "every". I'll fix this in v2.

Thanks,
Joanne
>
> --
> Askar Safin

