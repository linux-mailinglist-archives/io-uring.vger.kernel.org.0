Return-Path: <io-uring+bounces-2172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F364904C32
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 09:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 857FFB236EF
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 07:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD5816B752;
	Wed, 12 Jun 2024 07:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyn5Jzs3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E740E16B735;
	Wed, 12 Jun 2024 07:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718175606; cv=none; b=YJEPxN04yUtVgi6qpBeK5PJnAZ0hkP6ek1iGWnvmVE8eIxnm0omxE/5vMsWK8SXpzQ3HDuj0yUcBGAuq6vboPvVM4ofMGI+dPUk1wrS9Nocfh4Rl5tpTQERh1MGDUGmv4xcjMGXQlyn0jda3JAx+4uyU98WXSCtwBv8/8RC06C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718175606; c=relaxed/simple;
	bh=l2FWL3MaYkxGpNjR5SVeqc1ygoLE6HrOrfvSJrnDPZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=KTTaUp+9UUxt4L5GCNcMfh6w0sdYYHcPjd5neskr6VGpsw8+76di7iZYDpjpjkVNvwnmBxcsF9RIM2OyMd2AQQr4n3Pgff9B5VlkZJkCOtiXPF0ZyqjeiMSMirDILF2pXDkZFWIuU33r9463HQ//JKQtObdjzXiXSjNlzlgEbgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gyn5Jzs3; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-62f39fcb010so11676767b3.1;
        Wed, 12 Jun 2024 00:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718175604; x=1718780404; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l2FWL3MaYkxGpNjR5SVeqc1ygoLE6HrOrfvSJrnDPZA=;
        b=gyn5Jzs3KjQgaZ8ZQo2xL3Jgvu9v8j3ZmrmBH9X6MGPFbLIOod81gcOrWBq3L8kAeG
         z53IkFc+cA9SmFCOAM0KoKlMtYGjRU+AgP6mtoLw3Fi1Dl2SVcDMwPpkHDhRFhyKQhTf
         MbFRgJTgMwBOkJ9UA3+FTutuwDDRSqH/9F7NdBLsKZvHOYvOv6VI1KdVLWJ98ayipWGi
         2bavyBYSVzX9d3zW71v8I2ndk+co3vmddJwVYCHa2JulziFLP3b3cr4LoBQ2VqcrzLq3
         YAUvP/dL5wPZn+9+rN3axUzXmatVKAFEKXHEeaXjjVvVl57hgEWRjOME16JP33KxULEk
         z6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718175604; x=1718780404;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2FWL3MaYkxGpNjR5SVeqc1ygoLE6HrOrfvSJrnDPZA=;
        b=rxxwgifvHoA43Uk89+A2xeYBXpgGNxBsrHbVmLf7fMo7A8JuMi8KSXfEoPSdBbytDV
         HLfR42KS5MUMSe/2fJtt/E3ZS3lKEBy7TR9rgtT6dGC57N01/zXR/GcckLzDtURiNYeU
         NyPUhNoQM/AjIHPHtPqJiy8iowRiuC3H3nYhYkPAYQX52OuyMzGIQOzNa/XIeKpMz2p4
         vun+Z34f3emfQDt7TO9Ee0d5VxDN4LR4W5F26TPuiQYM2Q7hAzmPWWivDxy8Lwo/Hnx4
         RD5pm/69emqO7T0jAPvgfh4LIhq69QR2KV6W3KQ/fcrKd4PqrlMYPbdIUUjfUr/gB0OS
         ssCg==
X-Forwarded-Encrypted: i=1; AJvYcCX+oR2O7L+9TlQ6596bEQBhfidzWaYuDzLKeYuzQMl9ZPR6cOxsmihGvA9XLkENxWRt9msI5xT3oA/EuSGjM47ASGG6bmVs7i6x5oFomsVIl5gZywGCBwK626HYLxNX6YBqUuvDKpQ=
X-Gm-Message-State: AOJu0YzAAKHMjhAiAqo7mGUdTbi64h1YYWXTGQJClkKbebxeEu6DQQQA
	cTfcfDfRjhpXsFMo9PUsjzYMRM+xeldCrsEfeE8GEFPiSNxb1AiuDgjx+VE6dN93eWkldQc10uj
	P2QaTmNzt59MTNB1J9bRfvGGREms=
X-Google-Smtp-Source: AGHT+IH0PCdMZtOPs327plhtNOg8Po5yi4NuZcxFq+L5xNI8cUuoAoqhrkeCv0yXRtHtv34xRnq5okoYZehy6aEu55Y=
X-Received: by 2002:a0d:f443:0:b0:61b:3356:d28c with SMTP id
 00721157ae682-62fbb7f673emr9479367b3.2.1718175603741; Wed, 12 Jun 2024
 00:00:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDTYSbyxzo3cXq08Kk4i0-rLOwuCMRTFTett_vTTmLauQA@mail.gmail.com>
 <9baaad14-0639-4780-809a-0548e842556f@gmail.com>
In-Reply-To: <9baaad14-0639-4780-809a-0548e842556f@gmail.com>
From: chase xd <sl1589472800@gmail.com>
Date: Wed, 12 Jun 2024 08:59:54 +0200
Message-ID: <CADZouDRyyPKQyckxQ0SpEO=AJiZuh=r4PfMN6EU4nUJJTaOFbw@mail.gmail.com>
Subject: Re: [io-uring] WARNING in __put_task_struct
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Repro hit the bug with a low probability, so maybe you need to try
more times on the branch I reported. Also, this bug still exists in
branch 6.10.0-rc1-00004-gff802a9f35cf-dirty #7.

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2024=E5=B9=B46=E6=9C=8812=
=E6=97=A5=E5=91=A8=E4=B8=89 03:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On 6/7/24 18:15, chase xd wrote:
> > Dear Linux kernel maintainers,
> >
> > Syzkaller reports this previously unknown bug on Linux
> > 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
> > silently or unintendedly fixed in the latest version.
>
> I can't reproduce it neither with upstream nor a69d20885494,
> it's likely some funkiness of that branch, and sounds like
> you already tested newer kernels with no success. You can
> also try it with a stable kernel to see if you can hit it.
>
> --
> Pavel Begunkov

