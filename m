Return-Path: <io-uring+bounces-6181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97C95A2246A
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 20:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD9773A2B99
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2025 19:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794F31E2606;
	Wed, 29 Jan 2025 19:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="aO79BLrK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270401E1C1F
	for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 19:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738177893; cv=none; b=RdqfyrXiYGeAfBicrbrqkNA1KWgY/Ik75KYrpzMHpcosiIUs5tlj2T8GwPXjjuLxiawud9xg+P3lMaRginM/aMC+uKd/OU8VRqdr3cFYs0Q1CV1FXbhjrGKjJ7k59o3RsWR1ckyIHJZqUnMk17DC6YcwRDOwwaD4VsBWZAgDORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738177893; c=relaxed/simple;
	bh=GhlIZMqOwR1HkQLXtngsck0tPKlOdv4q2Zj0KZS+n1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FnBZEMhGlAGuKeUSNcrlutRvyNjSiazbHxd0/6N3T8HAXQupQyzeOC8fMl9li+/HJ+hJO5uFjTw67F6gDnLwnte7FDK2ADXamGahXHBk+MXRTrdoarAtcs80AgSakeuw48OO5uJXfliZ7RoABP9mTimEOy04gckZkwu6mg8g6zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=aO79BLrK; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab68a4ab074so8308266b.0
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 11:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738177889; x=1738782689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhlIZMqOwR1HkQLXtngsck0tPKlOdv4q2Zj0KZS+n1w=;
        b=aO79BLrK6bDQp/LUQK8713J+ND8yGLewCXZUowQNDQxa9MSvwRw0IUyHNiNe1EIPch
         pdhlUMsI1lLMJLTPKoqK4nA6HYijYOND+7FqTREnRSajvWiBCC4tVdvZMpokzsAKAJyi
         7KZgUNEekrf4xhbMQzZ8rHEj4fTxLuQMl4lVKZYXKf3tFcSIV/k+pY2wj9d7JxII4sG3
         xc9kEqOkkXehTnihAGXzKrG14pA9/BaxKZiMu8wA+wgRog5X0ntC7RbNKI7BNJGByUb7
         zAB+RY3EtgbznJPJTEYzBL0fH8hNV9udnc+r8uIblBNI+QZjmyfQRTzOoe8q0EzaO0cy
         XxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738177889; x=1738782689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhlIZMqOwR1HkQLXtngsck0tPKlOdv4q2Zj0KZS+n1w=;
        b=QyR54WKULJPZjDbeyN1FQE5Xs37QB/frRLyZgW+3iO2tY4lQ9xZnXsQWkLze9eW6rA
         0trXEL2U0s3MlxLX9NO/rpOVyX9khzmT8D2z8txL6eEWqkNfe6C3fD4O5ygRGt0/pe/U
         PhXcXwGxrrKbuAqY+TZnr614Xqj3wWLe5C/4UA3euuLfneQ0YflzOJVzs78kVRfeZOqk
         POlLdY7MRded9lDySXLNIDiScTmuWi970vHPGlI5C/7wLosRnJUSdLbkkpEGgkU956v5
         l5Bll9bDoXfEI1mArRreECQNhgBQJEnxNPj4mGM8Rt1/+iSeL2I0cyRXGnozV0JM3n3w
         hcVA==
X-Forwarded-Encrypted: i=1; AJvYcCWmEWlTAjYLcCwASRi6OmW6DaohZTPGgn1c2hOioPMqpk/u6fC1UxQ+hb8TysECmXLqTAuCS/HyGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwtkGOi8/Qn4MtKfjm2sE99hRVyieLPZg4y5YASdkeSTuO4KVq
	1vXYJ/u+VqeJjgPY+lD2omilp8nSxSOGT3EopRcM7fYgdt/aEtffPMzn7Tt2/zKacqXP/yVNtkw
	hcK1tHqVcnweaqSe98Lno2gqFDxUV4Fmd7SpPQGFoPvwzx5QZdDek5Q==
X-Gm-Gg: ASbGncuz5QlcBWbYxebPtcfXscFLzhMjXhheDJ98H7AfAT0KcknOKWvTmu4lSAtIbpQ
	9RFPla7wP1gX5coQ2A69Oq28oPKRyyqDh7jBcywiPw/CDGvClomLzrbz4/H5FQHPDZOxOTPFtTU
	tFTvgK9U9Gkfg2y13okYMCIIccWQ==
X-Google-Smtp-Source: AGHT+IE219ZwdyYxwg9UGBTR/PKOr2GHzNh2WNdhnHDSJJCT1n3/BOB/tMcF5dlhHm1Q++2IGQ4hA9rQdGrBzYdnw0w=
X-Received: by 2002:a05:6402:3511:b0:5d0:81f5:a398 with SMTP id
 4fb4d7f45d1cf-5dc5efa8b65mr8934946a12.1.1738177889464; Wed, 29 Jan 2025
 11:11:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com> <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
In-Reply-To: <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 29 Jan 2025 20:11:17 +0100
X-Gm-Features: AWEUYZlW_MDfPCAWAmFfh5_6BXOC71Ep2fITVNb9uw3ezdU1iUJLGAdCwxk2vGA
Message-ID: <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com>
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2025 at 7:56=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
> What architecture are you running? I don't get why the reads
> are expensive while it's relaxed and there shouldn't even be
> any contention. It doesn't even need to be atomics, we still
> should be able to convert int back to plain ints.

I measured on an AMD Epyc 9654P.
As you see in my numbers, around 40% of the CPU time was wasted on
spinlock contention. Dozens of io-wq threads are trampling on each
other's feet all the time.
I don't think this is about memory accesses being exceptionally
expensive; it's just about wringing every cycle from the code section
that's under the heavy-contention spinlock.

