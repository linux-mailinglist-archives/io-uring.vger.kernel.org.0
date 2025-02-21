Return-Path: <io-uring+bounces-6606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A88BA3FB69
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8738880872
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFA51CCEE0;
	Fri, 21 Feb 2025 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knyxOZ3I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18DC286298;
	Fri, 21 Feb 2025 16:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740155086; cv=none; b=ULhRWceNWUs+kCQFT7CdnZ1uXL0qhxybSBwJz+QMNey0TFTibPD+ftwD7GiBAIxRG1ugfxorMO0WFW5v1LIfry7jauqaiU1u0l4COwEhG54xIzhZHaDZ+bh+1IF3LF8TZZXNNMrvETQqcWgV0eT9Ps4jZFFrUOcYrQdi9eYvlug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740155086; c=relaxed/simple;
	bh=Dp/fcJLtdSGhXa9dQRAR9mBpDX7HBvUKXgBwaJ+JQqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lSrD6bQb+lP097IZa7FF9GNVPCz1Ol/6UJetCTIPUFjYuRFkg+w+Rw567RR+0yIZSAz+yy6uY529SGq4IVg2cv2lSZvG8mdbBZlFjTteFdEx02TjSFv/gobaDx6t+3XwaFWILhQ9pz5hBPQkyoIIZaunQnvjeiao+qJZlD0AYnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knyxOZ3I; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso390489066b.1;
        Fri, 21 Feb 2025 08:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740155083; x=1740759883; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPzDaZzpRQ7/HMYQGXfpHxcDpofOX3IFsTztgdcSTss=;
        b=knyxOZ3IXgaFdAzN3S9hmBoQNvVPg0LPdHejrhOuK6H3J4/l/HReGfPEWr7IxdcgLq
         OyVPrfaMugGJV0YbI6iGvbIi00mjqIWhMlDyejekOVICGQYTITLAWgVswdXso9xVHJOI
         OU97V5yUWH8tdnSdEuKwo1s4AIH1yf1tNNz2YXvLRlvX+C7Y8C0Fkk7RpAMSVXoppDcS
         5X5go+dfjmBY2uB9qjhYeTIlWZ1QiYUNRHJJZHdQ76iIT4rXu21QOljidF98zht4P3tA
         nsQEiwrd6BAngQ9dT9+vhx8EAcXwi2L7weZ5bZSqXLHK0aNGU6Bkty22V2rXEhOTtWmK
         7QZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740155083; x=1740759883;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPzDaZzpRQ7/HMYQGXfpHxcDpofOX3IFsTztgdcSTss=;
        b=uNLAhTOCW8iskqu5Xy1IOM5uQwhRpSzXDVHXdXj0HDxdDxYkYDNSg9gtQIGhmq8wxu
         il+Fl91zphdKni5/jxJoH4RHzPzqm8ke+UkxaTZQ2HXMyBZkBQOb3NkNTsPZPLpn329E
         J/4uNCR0RakGDOBzqjd2grc5jBDKlRqRbkr9DD2V1Uab0sLJGgd+VeTkXRUZOoHju90j
         z40mTuuTmFRg+KW/u+f7zVIvPRKkY5myXSwwB2MiycCoN3D9miR+TI7aHzYMRuoe+LLf
         fBydEluHzCCr/dgHuV1NRreYs8rFIK9aP0bYsxVoZcuRJfLGXAcs+6YOE4CpgEoR3hhn
         upxg==
X-Forwarded-Encrypted: i=1; AJvYcCUyqPbWdNVBMzC1HciEKEIE4LMf7/0Dm/W55rZwvL8GvbSxs2WSeQhwvU930xhtstZw8DmQH6aB9R+nmhOQvg==@vger.kernel.org, AJvYcCV3N1HTdOy2HkcnQPfaEuOcKuwWvfGQgzb0WKt62CZntGNxcViFABAVdzK/eubSWOkcxLPtoOEBxw==@vger.kernel.org, AJvYcCV5GYZN3hk4849JYO+Gzus+3zcXd1suo/4kNzDOOTamlicIuM8+r1Hs6EbJr5lf4/SjCn0B6gTCaryAOm3b@vger.kernel.org
X-Gm-Message-State: AOJu0YzM1bkoc6lxgZKhsGl/nRQxMmeFnXCsvabDvCXClra9RZ/+xGOg
	WUQirhGS9AlRfFZrx/QUfVPzsJr5AnIy29rb9r398NA8huL3b+zG26EyT78/bySGcdpXW0iZ1md
	gCtpOdJC6l7IBB61rvIbG5+OSDNc=
X-Gm-Gg: ASbGncuODO7yTAIRGn0WKKEeYa8M/Av2R/lzo/Og7RXVKdAsk6McxmuvywXLYqr5XJM
	yp4Guxv/L/LBT5o40x40vvfVF0/KaXXWkrVtLaSUBJtOk0Xou8T9VvUHklGdJgogvGrk3mPY8QP
	+cQ4ISA50=
X-Google-Smtp-Source: AGHT+IHxAHmA0/IYbZFCwi6GGkFhZ5TUvIRv/rb38RgOtgzfDvS3PRkeWkd6r4LMJhqTOiZEf2/QI9fR0l+bjFUyEMw=
X-Received: by 2002:a17:907:96a0:b0:aba:5f44:8822 with SMTP id
 a640c23a62f3a-abc099b838amr436759166b.11.1740155082787; Fri, 21 Feb 2025
 08:24:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com> <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
In-Reply-To: <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 21 Feb 2025 17:24:31 +0100
X-Gm-Features: AWEUYZk82-E1nugiwOLCFv6a1lThbUGEVFbwWR8Sh8-INRRVV2JSoQLZ-iiaOvI
Message-ID: <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Moinak Bhattacharyya <moinakb001@gmail.com>
Cc: Bernd Schubert <bernd@bsbernd.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 4:36=E2=80=AFPM Moinak Bhattacharyya
<moinakb001@gmail.com> wrote:
>
> Sorry about that. Correctly-formatted patch follows. Should I send out a
> V2 instead?
>
> Add support for opening and closing backing files in the fuse_uring_cmd
> callback. Store backing_map (for open) and backing_id (for close) in the
> uring_cmd data.
> ---
>   fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/fuse.h |  6 +++++
>   2 files changed, 56 insertions(+)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index ebd2931b4f2a..df73d9d7e686 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cm=
d,
>       return ent;
>   }
>
> +/*
> + * Register new backing file for passthrough, getting backing map from
> URING_CMD data
> + */
> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
> +    unsigned int issue_flags, struct fuse_conn *fc)
> +{
> +    const struct fuse_backing_map *map =3D io_uring_sqe_cmd(cmd->sqe);
> +    int ret =3D fuse_backing_open(fc, map);
> +

I am not that familiar with io_uring, so I need to ask -
fuse_backing_open() does
fb->cred =3D prepare_creds();
to record server credentials
what are the credentials that will be recorded in the context of this
io_uring command?


> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +    return 0;
> +}
> +
> +/*
> + * Remove file from passthrough tracking, getting backing_id from
> URING_CMD data
> + */
> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
> +    unsigned int issue_flags, struct fuse_conn *fc)
> +{
> +    const int *backing_id =3D io_uring_sqe_cmd(cmd->sqe);
> +    int ret =3D fuse_backing_close(fc, *backing_id);
> +
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> +    return 0;
> +}
> +
>   /*
>    * Register header and payload buffer with the kernel and puts the
>    * entry as "ready to get fuse requests" on the queue
> @@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
> unsigned int issue_flags)
>               return err;
>           }
>           break;
> +    case FUSE_IO_URING_CMD_BACKING_OPEN:
> +        err =3D fuse_uring_backing_open(cmd, issue_flags, fc);
> +        if (err) {
> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=3D%d=
\n",
> +                    err);
> +            return err;
> +        }
> +        break;
> +    case FUSE_IO_URING_CMD_BACKING_CLOSE:
> +        err =3D fuse_uring_backing_close(cmd, issue_flags, fc);
> +        if (err) {
> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=3D%=
d\n",
> +                    err);
> +            return err;
> +        }
> +        break;
>       default:
>           return -EINVAL;
>       }
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5e0eb41d967e..634265da1328 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {
>
>       /* commit fuse request result and fetch next request */
>       FUSE_IO_URING_CMD_COMMIT_AND_FETCH =3D 2,
> +
> +    /* add new backing file for passthrough */
> +    FUSE_IO_URING_CMD_BACKING_OPEN =3D 3,
> +
> +    /* remove passthrough file by backing_id */
> +    FUSE_IO_URING_CMD_BACKING_CLOSE =3D 4,
>   };
>

An anecdote:
Why are we using FUSE_DEV_IOC_BACKING_OPEN
and not passing the backing fd directly in OPEN response?

The reason for that was security related - there was a concern that
an adversary would be able to trick some process into writing some fd
to /dev/fuse, whereas tricking some proces into doing an ioctl is not
so realistic.

AFAICT this concern does not exist when OPEN response is via
io_uring(?), so the backing_id indirection is not strictly needed,
but for the sake of uniformity with standard fuse protocol,
I guess we should maintain those commands in io_uring as well.

Thanks,
Amir.

