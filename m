Return-Path: <io-uring+bounces-7207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC47DA6CBC3
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 19:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4430C3AC3DB
	for <lists+io-uring@lfdr.de>; Sat, 22 Mar 2025 18:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E521624CC;
	Sat, 22 Mar 2025 18:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WjNZNrr1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03272E3384
	for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742667037; cv=none; b=J3opMCkL8p4kgLAgMQjm1MXw+7wGm0K8byuRBG3Z7w3IrckwX5Zk9O4yKzCwLQXvR5ViwHml594LVV8nw+V/VYwOJuN9potP18JnGRHjTMRp10SreT3hynblmXE5MbzzOgz+0vUSSTa+6z5q90tttoGXO4GIysjw6sfbAFXsnpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742667037; c=relaxed/simple;
	bh=EYnXy0DHNCqHfLyTUO+kbs9g+S2qNLMUeBy8sa4Q1BA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mj0DymAmwZOmhQ9hZLw/qpwgjHxNFwir5XoIp3JTD3+/nwmhhlvSUIBgmOpFLfBLzDiHkxXQ+JfxBMO4vGsqQ3loNFLHa5KRJpw2+YMGlz4UbDqRNe9EiHrGN1DWQbixpAXg3rwwN6TJ7F9JsK7Jw6EtsEKqahH9oynQkfb1cxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WjNZNrr1; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3032a9c7cfeso186639a91.1
        for <io-uring@vger.kernel.org>; Sat, 22 Mar 2025 11:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742667035; x=1743271835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYnXy0DHNCqHfLyTUO+kbs9g+S2qNLMUeBy8sa4Q1BA=;
        b=WjNZNrr1QKUPQd6zK8QPXWvQwFX7Fyx+BmAju0zqiPLXfNGizQtR1aVZ0KEAVd6H32
         4NtfEHJaVPeU/49EJZyB5q/vv3frLtT+PTrcUsHqDquknsEKKunLmIvo5U5WoxDNUaDd
         eYj+1/mIe5bEh0NnRfTpFlewvHfnw6hqt1Z6pVBoCrLo0ZhMpYp6nYUL/pL/RPz6H3t6
         39qtQB3qh0vWleedXzh5Iyy/Im02Rg3rqXKs1BqSEX48FPi+bGvZJnj3q3UbNopV3KJl
         g6g80y25Y8kok4yXLv7ZDNAMh2mEfjiKQvZ6mAXLs8HNnijU9YfF+s5J6TyyHrHx6pV2
         x/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742667035; x=1743271835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYnXy0DHNCqHfLyTUO+kbs9g+S2qNLMUeBy8sa4Q1BA=;
        b=Y9dk4RZg5RAmKtG+NCBrWM4mmfYNFyJvw+ED/YDQo0w++Or6H/FPmQAqdoUsqv8xSN
         vgOtQWl46fkgoAYHOhPfa3JvuqgssqXBAHIqkgyOBLQ2MpZQR/bbgNNu4pcVn5JD0G32
         EakI/Yrc5Y86AZhxlhDrDY7Vnm5FEOR4XxAdyU91mkEMRisnX5P4x1o/mZ/lYYvHZj11
         H8xkGBFmdE28qjcaIO+4h1mIB+9PGmr+8iS0Dx8Uwv/IwUhO6moI4gO5U8maYaFPQHLF
         WlbOvUSGH0wl5XQpt+NZGyu6+EPqrEAqt8OOn/F4lMBpuGH94YEBrdd0eMS5gMPfRIUw
         QPAg==
X-Forwarded-Encrypted: i=1; AJvYcCV7rXnu8Qo/97BLyFgm8oPog2o2BUgqgFXd1pRrbrF8bdATgMI3/OAT1dEHbvDUaGMMAfx29H+8Cw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdwaOD0MBBMZ3gOoejm8ILhWnA54b9dni7sk//q78CJbZRn5fS
	IrzM9xrt0EaWOrm6TpfjrroTixwwSkqqZ6iLekarbjOmryFpjckcQBW9qO0TD984LjLpDahcBVC
	QZvf+LKmDsXbn2t++aScjskiyqZpSfC3kQmJ1wQ==
X-Gm-Gg: ASbGncshTN78KPx26arZrHzJA76qKyx9L4eGmqcLwtehMyF6WMAGkfaxHCKWcY9ammO
	Av1RSCWRYWzIn7mM05VCvuo8arogFwgluFlrOEUbAlA5ZcuUv0momOCsSJgWpGxHtjuFv1rdk8F
	iYkz1BRB1/0W7p5zCtCzURYm/U
X-Google-Smtp-Source: AGHT+IGMzf3g3N9wClWrw7Xv3sRc1fQBBlEqH4ihuv3ChmZHgzHySDBwp284mpZhIPwvxO0vMcGRvMljoDZmqXZS/Sg=
X-Received: by 2002:a17:90b:1b07:b0:2ff:6941:9b6a with SMTP id
 98e67ed59e1d1-3031f4c1040mr2810270a91.3.1742667034778; Sat, 22 Mar 2025
 11:10:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250322075625.414708-1-ming.lei@redhat.com>
In-Reply-To: <20250322075625.414708-1-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sat, 22 Mar 2025 11:10:23 -0700
X-Gm-Features: AQ5f1Jp08L2vZEVmDltPdh3Iuu8RJxuvv1ODQInQC6ThUvkGij7GVfBxSLgorxc
Message-ID: <CADUfDZp2TwVuLW+s+WEPOy=gHE8R7-JWEtxZhbmVeRy6CrGh6g@mail.gmail.com>
Subject: Re: [PATCH] io_uring: zero remained bytes when reading to fixed
 kernel buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 22, 2025 at 12:56=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wro=
te:
>
> So far fixed kernel buffer is only used for FS read/write, in which
> the remained bytes need to be zeroed in case of short read, otherwise
> kernel data may be leaked to userspace.

I'm not sure I have all the background to understand whether kernel
data can be leaked through ublk requests, but I share Pavel and
Keith's questions about whether this scenario is even possible. If it
is possible, I don't think this patch would cover all the affected
cases:
- Registered ublk buffers can be used with any io_uring operation, not
just read/write. Wouldn't the same issue apply when using the ublk
buffer with, say, a socket recv or an NVMe passthru operation?
- Wouldn't the same issue apply if the ublk server completes a ublk
read request without performing any I/O (zero-copy or not) to read
data into its buffer?

Best,
Caleb

