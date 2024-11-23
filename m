Return-Path: <io-uring+bounces-5001-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8235A9D6847
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 10:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B09E1612D9
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 09:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFAEE17BEBF;
	Sat, 23 Nov 2024 09:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Krh3un5w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2570638DD3
	for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 09:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732352496; cv=none; b=l/kIDdOr2X1fJLreE8lGhcE+Kh3sfQS5MtjrJE6Tt6iaWBMqKIw/vt5o9Yg37nD+hbPTaDeFpVnziqBJ3egVc/i6C1pP2CP/ZujGJ6bUyex8PLCl4eVweA0PPldcoYNPhrlBYX+8DQtjKXPVMjF8G3k2dU0w84TlG/IwCSmaEqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732352496; c=relaxed/simple;
	bh=jn3jBILo+uDYc8/UF9FILhwsx3ELCEnKu2+O4+G1BA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLF8OJL+fhUpyZPKbdnLY1PfICNp2zjby/TyIraoUpLqR769L2hBj8Hna+3e0XVwhgltgjn8tfNq3HbeqGuXxnn/shJVER9faElMTXqWkLg8xbG40zdyV71JqMEqrgaAxdw4+a0LhTcrNz3YVvJkuPi+YirUzTIb6B/otNPBOnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Krh3un5w; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-46098928354so19872751cf.1
        for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 01:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1732352492; x=1732957292; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DFiXzXBKT2EId4oxO52uRUCqeKRX7R+7nWgLka8QQYU=;
        b=Krh3un5wS9/WiWRQ+PsgWFeBPBvSVOxUpL0P+Gzj88Li8neGW7MHgkEbTfRJhZeV7/
         JzK0Jta/pkHZXKQRZFYFtMey9gzliZuXFpv3aeTPmjrdp/jbSioc4bM2w5LmvknqKpFY
         Cxx9c6R8m+qYDeLArdhEiPUp0963UpO+v4bbs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732352492; x=1732957292;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFiXzXBKT2EId4oxO52uRUCqeKRX7R+7nWgLka8QQYU=;
        b=AZSiEmvrQtt4+nzzpd2dW6a9ECs/l/dzRnCx3+R3e7FT/bMmMmtfxmosgApb+5duYT
         WOempywgtzNOqkcaSxzJYSBKE5aznc0bSyO3RKWKyCbJ21Vum/+69LxVN/ywg6m/Pl9m
         da6kIQpmjd+2nl0o/LXQstE3OE8bjUkoHQHL4FNMV7qiMRsGT2DWswoJ+dQvZMUXQ3ez
         NS89vHpzUHlFt40s2cVlsudQ9q3RlsHo4PTT+9u/P7O/6nt2KRqravxJf1K/o4UUnT78
         vk7D2e6UC61g0zbss4saGjbcEC3W5RZvg97Qti0Xkf/9Am5DGVGw/G7cVZN1JXMlfcN7
         5Zaw==
X-Forwarded-Encrypted: i=1; AJvYcCVIP4PS284b0lwSOyttHiPQii0tumdA5zVVualqZFWYUUhIwAv4v0i1v8cp3ImS3oDkJgjqScY/tg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfs0lKWZU2I4KctL3mRrueibRC/EwqvxjFXCoT5JCjKTqm2C8+
	0w8rJIycD4sjOcXFnG7fYp3WZnBWinskY5mw/CSTgSG/dE4RDkjRVYNUSQE139jGPM8r0yLgjiq
	O0xaomGKThGW0akkzfcL1Mnb2Vn0Vd/2NWufIMg==
X-Gm-Gg: ASbGncufZs+N+JD3MFtez8N2aTXsKOiwGXRKsVYAUj1xK3w+4DbQ6zTaKbW1Gz/soZR
	Pp7lBvzU4xbuKS651fbRRclrIbGcMn9iSeQ==
X-Google-Smtp-Source: AGHT+IF85E/yXEC4k+4bx41PiOx4JBk4RgLR089oIqv0TSCWg27hIBqkf+JsWUUQwo2HY7/suEoxPtLxQChNoQWC0QE=
X-Received: by 2002:a05:622a:188f:b0:461:22e9:5c54 with SMTP id
 d75a77b69052e-4653d5c30e6mr72458871cf.26.1732352491772; Sat, 23 Nov 2024
 01:01:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com> <20241122-fuse-uring-for-6-10-rfc4-v6-5-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-5-28e6cdd0e914@ddn.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Nov 2024 10:01:21 +0100
Message-ID: <CAJfpeguPCUajx=LX-M2GFO4hzi6A2uc-8tijHEFVSipK7xFU5A@mail.gmail.com>
Subject: Re: [PATCH RFC v6 05/16] fuse: make args->in_args[0] to be always the header
To: Bernd Schubert <bschubert@ddn.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 00:44, Bernd Schubert <bschubert@ddn.com> wrote:

> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8da1f7fc5199c1271 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *inode,
>         struct fuse_inode *fi = get_fuse_inode(inode);
>         struct fuse_mount *fm = get_fuse_mount(inode);
>         FUSE_ARGS(args);
> +       struct fuse_zero_in zero_arg;

I'd move this to global scope (i.e. just a single instance for all
uses) and rename to zero_header.

> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index fd8898b0c1cca4d117982d5208d78078472b0dfb..6cb45b5332c45f322e9163469ffd114cbc07dc4f 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1053,6 +1053,19 @@ static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
>
>         for (i = 0; !err && i < numargs; i++)  {
>                 struct fuse_arg *arg = &args[i];
> +
> +               /* zero headers */
> +               if (arg->size == 0) {
> +                       if (WARN_ON_ONCE(i != 0)) {
> +                               if (cs->req)
> +                                       pr_err_once(
> +                                               "fuse: zero size header in opcode %d\n",
> +                                               cs->req->in.h.opcode);
> +                               return -EINVAL;
> +                       }

Just keep the WARN_ON_ONCE() and drop everything else, including
return -EINVAL.  The same thing should happen without the arg->size ==
0 check.

Thanks,
Miklos

