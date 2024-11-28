Return-Path: <io-uring+bounces-5106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE9A9DB03D
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 01:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41B441640DE
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 00:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828A74A35;
	Thu, 28 Nov 2024 00:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kb0slVCG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F4D9460;
	Thu, 28 Nov 2024 00:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732753235; cv=none; b=dCGyMMBZpx6RbcdWm4Y8ds4ymOwmi7tH/5HrreaL77kz12TkDtlB3isUmaGB+BTm+bUU8IGB6jxK0VQM1V3lYnYT+4sCcVBEaU37jL4DMEkVsIQg4pkKuwjCIri9bfFKmsqMec0gKoHdxRFsITTt4DUKIb+cC9ijLwyZGIAitpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732753235; c=relaxed/simple;
	bh=LRB7NifOJCuHjK2KwNwz0khx3r8SHEonp9IWHqPrRo4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlBgMq8uSUnQWmBLVolm0KlGszNlMd6RumJ7GwENfVHOeuO/IRp6vaqREX11D80qqQte0432AOxBe+VpACiRJzMx9L9EAei2vtP2rHqGPl4lag/k7kSGhmrNKh9/gGqPQNj9j7vZKlf0qKacOB/z3gq5tJJUDlwcfMXRYCBUqik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kb0slVCG; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4669eecd88dso2705911cf.0;
        Wed, 27 Nov 2024 16:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732753233; x=1733358033; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86lKbn68ps+Pt3RflpT231XwDcaXIyZ97JwTcu7024M=;
        b=Kb0slVCGyXA6pQTpEMqY/SjBNShYacd9DzNbSvL5iBgAvrkoMQRVhDnsMoQ/Qwxyh6
         2XlR0474TdyJHsPRdoVyOgoWcSfP7yX+u17UBgRgJTaNDHzfwYBmNFhGpSEFnxtJj3z4
         KgqDxEc/aOYmcsEYWzphK4E6mWV0JZQsYI0rHVqiG+ShaPhWKU2UqSdZPZitiEDu+KbV
         95xb5vcjAYeSKMOa+oWG290U9ZRSiidqMaldOUVr31AD5lvN52iOO7fvPV0OuL9/h15L
         sQglnKOdKsm24zI2nwV0r2HVYRCzzO0I55UM6V6zROriVvS+1yuBLyIPFRWQ/2LBrfKX
         kyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732753233; x=1733358033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=86lKbn68ps+Pt3RflpT231XwDcaXIyZ97JwTcu7024M=;
        b=UZ9BbetrKlD/NkzmdzT9C0GwsFu3OcVtm6fuhqXpeKZLb4EFDYIqPzCPmiZLzONjJR
         6NZZizrkaZ4zdvBolUZcvPFr5H/MTXvERPpJrQxtZNKh5ZxMhCJuwjRcGMAm3S1AVfQN
         Ks/RjGTgWQTqiOJPd5F3JiL+tv9hdBvRFaAE2OcZLxqlPUYkllhnLM7WKxTfPJ3l/BJV
         dPRfZ4HIOqID39gp7e6pK0N3B6SnE8uzRP1KdrY48s6GYNC35P49FZjOkSZ4wiuH8joS
         r+ZD0Y0FfDuXDFIVkqH2DxNYRQExCwwg0KrjSVw924khcVtFT4SlIuZ9q+nfzUsEJDhB
         Q4hA==
X-Forwarded-Encrypted: i=1; AJvYcCUuULlLzrnXw71VsQCfkn7bbjPWsC3qgb1cvNgk/Q8ZjooA7t2uHvGi1YuGGsRCS00WfSLNU77e4xEHSff/Ag==@vger.kernel.org, AJvYcCXoW0kb0bIVMIOuBv0bBJpfR/r7u5ATqgLF6XHtWYbEZ3XgNvTjdQW5p8McyzUgZDytHztUwja4TA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhF5sZI4x+VZYe9a7XGgxI09nZ0FjaoGBFOeWTy+ppeFcJ5/Uz
	Gfbcd7sCsSwv2S8X4mBNRW1jT8iFT73694NMrkaZ9iUXGCnICCfSmF4TUdsGKBVjflRKbCpQjXU
	T+ws7MXcG/vefkTfC7LBREYexKwE=
X-Gm-Gg: ASbGncsYiQRcgRl5Sm60Q+/VRD8BcjIniiQeyPglWfu6XSYHwzRgmJK2lXcHykdRVk0
	w81NA9QVlR6eMa7JkeD+a3IqUrGmNSN2cGaE4jmEVry6zsfs=
X-Google-Smtp-Source: AGHT+IHM3HDM6mtvhRC4wNnLcEVixA3cQORDP9vLa+CvNqvCs8JziHqAy1hihfYU09urmpZn69ouW3Pjt9pwoQpoWLk=
X-Received: by 2002:ac8:5ace:0:b0:466:8c76:6826 with SMTP id
 d75a77b69052e-466b35489d1mr62650341cf.32.1732753232817; Wed, 27 Nov 2024
 16:20:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com> <20241127-fuse-uring-for-6-10-rfc4-v7-2-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-2-934b3a69baca@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Nov 2024 16:20:22 -0800
Message-ID: <CAJnrk1ba_gsYWSnd5SfxA7NwwhDGvB4KRDJ=chtBrfp3WZaDhQ@mail.gmail.com>
Subject: Re: [PATCH RFC v7 02/16] fuse: Move fuse_get_dev to header file
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
> Another preparation patch, as this function will be needed by
> fuse/dev.c and fuse/dev_uring.c.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  fs/fuse/dev.c        | 9 ---------
>  fs/fuse/fuse_dev_i.h | 9 +++++++++
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 09b73044a9b6748767d2479dda0a09a97b8b4c0f..649513b55906d2aef99f79a94=
2c2c63113796b5a 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -35,15 +35,6 @@ MODULE_ALIAS("devname:fuse");
>
>  static struct kmem_cache *fuse_req_cachep;
>
> -static struct fuse_dev *fuse_get_dev(struct file *file)
> -{
> -       /*
> -        * Lockless access is OK, because file->private data is set
> -        * once during mount and is valid until the file is released.
> -        */
> -       return READ_ONCE(file->private_data);
> -}
> -
>  static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *re=
q)
>  {
>         INIT_LIST_HEAD(&req->list);
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 4fcff2223fa60fbfb844a3f8e1252a523c4c01af..e7ea1b21c18204335c52406de=
5291f0c47d654f5 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -8,6 +8,15 @@
>
>  #include <linux/types.h>
>
> +static inline struct fuse_dev *fuse_get_dev(struct file *file)
> +{
> +       /*
> +        * Lockless access is OK, because file->private data is set
> +        * once during mount and is valid until the file is released.
> +        */
> +       return READ_ONCE(file->private_data);
> +}
> +
>  void fuse_dev_end_requests(struct list_head *head);
>
>  #endif
>
> --
> 2.43.0
>

