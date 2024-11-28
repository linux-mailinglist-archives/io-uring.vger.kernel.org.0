Return-Path: <io-uring+bounces-5107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F4F9DB03F
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 01:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67601B22002
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 00:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DD94A35;
	Thu, 28 Nov 2024 00:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auDdwG6h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2519E9460;
	Thu, 28 Nov 2024 00:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732753293; cv=none; b=V4FqafVaKpfly8Su/BHuq0wB8oTWZP3Ed05R+20BPUaKyIwBjNjtClUoaAh39FS11apjyI1o6wJqDCK1XQXrgsNRa5qwWId6EHHVCWTXSG8T+LWW8w409LWXuEyi8Mx3gpl1TIhBK56QqtF//1N3ni9Nq4z9hLHrdeT7VEu8wvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732753293; c=relaxed/simple;
	bh=bH1U1uEMFN1WyG7vRRYaWqu2ssjZ041waHVoP/sFaeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pz9lon5/WINT9kwZDZe1CK1S4EuMJLjDIfHSv4hDXMplrGG63rkw6n1p7PCwnV65U+WdtUYkC5SSztp263xVU7DHRqQ0VpUPYnw+Ojh+I/u7qrSjaSUl1Yjt/v9sfxHl8oXSIirI+bV82KQDIlAmCI8qZuZI+K84ICrBBS5HP2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=auDdwG6h; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4668486dec2so2465061cf.3;
        Wed, 27 Nov 2024 16:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732753291; x=1733358091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBHdT1dD7/+ViK2OjtzvBm1YhmFrEexM+bG6MSBHiJw=;
        b=auDdwG6hKSueAWhTa/ULBXqeldMCogCwvyX+xQd3IQngZEWskxg4WVfarAR0wON+bf
         OUGrNroVTXnKdDtK6PXaZRWksOtFdvyC5piW41ESy4a+jWwVQSerTtTciHMaJqHcl/vb
         P/ewEkurc1i6lSKiDwzXqJRO3vN+zLKRo6JeOxToKrIPiziwR7JmdltdJa1ZbvbWdIie
         6ITHnJkgK1U8Ti46A7/VDLhASMJFDn5TdzFN7ef2vokg+hIZRVpwPpBTJNWdqOMbL2c3
         OviaDtfLbUrWCe6pOYT9pK1is9b/wcpu+r6qIzyfcooeHR9wCPv72yV9j5oMt6urZYXb
         vK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732753291; x=1733358091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBHdT1dD7/+ViK2OjtzvBm1YhmFrEexM+bG6MSBHiJw=;
        b=oMCZBcxELQ8x4oPJdy9aWWzVC4xVQuFj/zLJEY96OH+FycPEXBNRtPdTXd5py6HWR0
         Azf0SdrYoUrTE0vU4I+daYeoQJRrvdr8IA3wSb4RoAyyfattfTaoikto5gRSYJVfM+DV
         7LBPz7Z/6tZJgf2yvmmtctCJltpwvg8FD3DNujMMIQZREBQPeMp7vcOT1c6N1mKjUuEf
         C+OmbuHkrn1XdH3hA7EaZaPcJAphsKRvQUsLm/eacbwDauvZyLfppOamtE3NoQHdHsgw
         jkvf9KJfaOCqk9P5Mg2DHI9lnMxdFYFtU5pW0HcfUmC97igLyDxUkiLiSmc1c+t9fEub
         W6Dg==
X-Forwarded-Encrypted: i=1; AJvYcCVfJuMVkdh+NG7UXU86fd3lXKSrj7+klDZZ4ZSeY7Y1hK20gDVePv6NGLJJGc/a6MqfSfih1twm/m4VswY1mA==@vger.kernel.org, AJvYcCWM+DMYFAGwv4hveb1Kklc8kPyqbh+O0YFR4Ol8+fLV1QEItNodFYIvpdFy1sL8RwyiWDlir8POtg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxQQf0CFxr54f/hd0ZtMkIcV+Y7pyIb0mamqedUxArsLnABe/F
	95iel32hGykPNlsnDWZvS4W64Ka30eR7l1ZRBZzAut51SPu2e5IUXpo8qMGhZZpBPfl1asRIgN+
	xGuI6n47JC4hGrBJ4VRQy7U4cN5E=
X-Gm-Gg: ASbGncuXlvBk/jfcy/1Zkx4sljxUZZB+jxf52HvM6ZLBwy9jXQpXtz8mO9en96ybnKZ
	R5lzJ55HG/y7a1sGoPSof2YQy9CcPbm1il3Z4yDT8YIpJrj0=
X-Google-Smtp-Source: AGHT+IH/8tGtjla7QZeZBAcj3XwnX6SXD3AjP1bA1C50dru5yrWRTjkQgADozhlkcb+vfaXEzZbzeOv/A/IZKJGVg1Q=
X-Received: by 2002:ac8:5f96:0:b0:466:9824:16e8 with SMTP id
 d75a77b69052e-466b3490ef6mr71588441cf.10.1732753291002; Wed, 27 Nov 2024
 16:21:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com> <20241127-fuse-uring-for-6-10-rfc4-v7-3-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-3-934b3a69baca@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Nov 2024 16:21:19 -0800
Message-ID: <CAJnrk1bW+V+tfdnaBqRUXCwK6DhcSk=K-kus-P66k4dy6beLKw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 03/16] fuse: Move request bits
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 5:41=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> These are needed by dev_uring functions as well
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  fs/fuse/dev.c        | 4 ----
>  fs/fuse/fuse_dev_i.h | 4 ++++
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 649513b55906d2aef99f79a942c2c63113796b5a..fd8898b0c1cca4d117982d520=
8d78078472b0dfb 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -29,10 +29,6 @@
>  MODULE_ALIAS_MISCDEV(FUSE_MINOR);
>  MODULE_ALIAS("devname:fuse");
>
> -/* Ordinary requests have even IDs, while interrupts IDs are odd */
> -#define FUSE_INT_REQ_BIT (1ULL << 0)
> -#define FUSE_REQ_ID_STEP (1ULL << 1)
> -
>  static struct kmem_cache *fuse_req_cachep;
>
>  static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *re=
q)
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index e7ea1b21c18204335c52406de5291f0c47d654f5..08a7e88e002773fcd18c25a22=
9c7aa6450831401 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -8,6 +8,10 @@
>
>  #include <linux/types.h>
>
> +/* Ordinary requests have even IDs, while interrupts IDs are odd */
> +#define FUSE_INT_REQ_BIT (1ULL << 0)
> +#define FUSE_REQ_ID_STEP (1ULL << 1)
> +
>  static inline struct fuse_dev *fuse_get_dev(struct file *file)
>  {
>         /*
>
> --
> 2.43.0
>

