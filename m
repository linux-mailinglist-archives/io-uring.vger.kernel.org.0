Return-Path: <io-uring+bounces-1209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E21288A645
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 16:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 547DD284755
	for <lists+io-uring@lfdr.de>; Mon, 25 Mar 2024 15:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F58156C5C;
	Mon, 25 Mar 2024 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbnNwOeU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B660ADDDA
	for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711370509; cv=none; b=pShDNwlg24qdsuKGJY2WOqLqA2QYHvE+fUKqe0iX7BbKXuGPKHmcsf1lNCsRa3VI3xWaULRL/sNTGwg7xRnGLxpAV1F9fNVrJitW4lc6Xh53+DdE7Z6zM3EGtNmZfeYrw6mZfizAj9s/IjPZAxw8rm9YKRJ39n1ABO4QQBcyWGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711370509; c=relaxed/simple;
	bh=RBlSzC6A9RL9t7c5ver4hWr/2FDN6NguFYfET7EJCm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OPS/wSx91+gMyV96UOxJYePHFIe89J/cLy9gpOiacDCrzWLvTwmiXHSjHUQKmB9dt8eSxEjTH4vQ/ou2FC5I7jmRs1BCRid/jxvIFLEod/mYHzL5mOX9gYh1Xj+rHCaA4wU87X0GY/v/LAKUV6J/IrIJZjYPyE45COlseUaM1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CbnNwOeU; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4d43a1f0188so1356762e0c.2
        for <io-uring@vger.kernel.org>; Mon, 25 Mar 2024 05:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711370506; x=1711975306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0CLVA4SR8RPk0hWbAbTjg9eH3YN/dzcOT6Wask3/DwE=;
        b=CbnNwOeUgtydFNvdbHTgWtpN0DZyfJVyNJnI6YtAeelf7OgSNxkLK+LJHwfHXrJ/aj
         ZjhH5icAu7icx9R9NC1mOpz4FH/D5f9oXJSyu2qMAm/rie3+eRYZEOnVJza+whWDNulh
         tyFSRRgStgxB/sHD8kCs9mIaHn7YiiIspCq52yw/2u1OxcxPfH6JpXFltmqLMCQpj2vx
         MNW9eGQ5AKZEFnOyGYPiuP6XrCrNQ/XzGssD1d0jFz6K93/b3BXFBHUzbCRXPAdTnXVv
         SKXeWaWTu+AXpTsTgHXQvabb/sqKTggjeHnPp8T6ye4bLrrB8Wzr20azy2nwPWvvI+Be
         Dvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711370506; x=1711975306;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0CLVA4SR8RPk0hWbAbTjg9eH3YN/dzcOT6Wask3/DwE=;
        b=oAodRJU4nAFRjbVLoG1WG6wTlpjkVk/H9/k7IIjlg/aQ6YbJ33pI3wS7zLInbNvEZ+
         pL5vWPwnzaUN/uNb1NNnObgE0nFl1wrZmQDdE8ccsKwPbIkDDOLkPCVj8mW6Gd3rX/sg
         cm3bkDgikCe954V11eRqnZDyMnwLINgb6uJp4gAR8VeDKoLakXBpDWdj205PbcYKa3SM
         sEHabSs6AfZJ/HgZRDF8XfiM3bAY21GeJCWWkDZnnjV4rMAeEImvLGMBigryyRAmJvrV
         qYAToeYPOSOAciuyF4Wfb3AD0PIXLkT3llM08aJhDZyhx6Ti0Ogkt79+s8WIwEX+AJnw
         NwgA==
X-Gm-Message-State: AOJu0YzjN7hUzKtTVYgoEw+1ARsv9b07NQChyEm+rycrCkkuhzmPWktV
	T3l3SE8BdGXQDmvbySOKWZ6w36Ab2FSh9du1xWHdRqZZKOuljr8CPCtq7/NVjtuyHUKmVgu9S4t
	VIs8xV+VWtNLJ3yY9Ny/m3NEcEJLYBq4zg8AU
X-Google-Smtp-Source: AGHT+IHl/R36jYX8AYbhOpXAQpAS0+D5ObdF5ulpzDAGfPbpMD5Bk7kIRcQ7MQkIM68lPadUKQDkIOo1xsxrkWOObhA=
X-Received: by 2002:a05:6122:1789:b0:4d8:6ae0:36a6 with SMTP id
 o9-20020a056122178900b004d86ae036a6mr4614520vkf.3.1711370506454; Mon, 25 Mar
 2024 05:41:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240320225750.1769647-1-axboe@kernel.dk> <20240320225750.1769647-16-axboe@kernel.dk>
In-Reply-To: <20240320225750.1769647-16-axboe@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 25 Mar 2024 18:11:10 +0530
Message-ID: <CACzX3AukJ8hZhmxuGWC_hqMVv52s=A3u8nFSrhhgPA6arMLacg@mail.gmail.com>
Subject: Re: [PATCH 15/17] io_uring/uring_cmd: defer SQE copying until we need it
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 4:28=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> The previous commit turned on async data for uring_cmd, and did the
> basic conversion of setting everything up on the prep side. However, for
> a lot of use cases, we'll get -EIOCBQUEUED on issue, which means we do
> not need a persistent big SQE copied.
>
> Unless we're going async immediately, defer copying the double SQE until
> we know we have to.
>
> This greatly reduces the overhead of such commands, as evidenced by
> a perf diff from before and after this change:
>
>     10.60%     -8.58%  [kernel.vmlinux]  [k] io_uring_cmd_prep
>
> where the prep side drops from 10.60% to ~2%, which is more expected.
> Performance also rises from ~113M IOPS to ~122M IOPS, bringing us back
> to where it was before the async command prep.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ~# Last command done (1 command done):
> ---
>  io_uring/uring_cmd.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 9bd0ba87553f..92346b5d9f5b 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -182,12 +182,18 @@ static int io_uring_cmd_prep_setup(struct io_kiocb =
*req,
>         struct uring_cache *cache;
>
>         cache =3D io_uring_async_get(req);
> -       if (cache) {
> -               memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
> -               ioucmd->sqe =3D req->async_data;
> +       if (unlikely(!cache))
> +               return -ENOMEM;
> +
> +       if (!(req->flags & REQ_F_FORCE_ASYNC)) {
> +               /* defer memcpy until we need it */
> +               ioucmd->sqe =3D sqe;
>                 return 0;
>         }
> -       return -ENOMEM;
> +
> +       memcpy(req->async_data, sqe, uring_sqe_size(req->ctx));
> +       ioucmd->sqe =3D req->async_data;
> +       return 0;
>  }
>
>  int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe)
> @@ -245,8 +251,15 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int =
issue_flags)
>         }
>
>         ret =3D file->f_op->uring_cmd(ioucmd, issue_flags);
> -       if (ret =3D=3D -EAGAIN || ret =3D=3D -EIOCBQUEUED)
> -               return ret;
> +       if (ret =3D=3D -EAGAIN) {
> +               struct uring_cache *cache =3D req->async_data;
> +
> +               if (ioucmd->sqe !=3D (void *) cache)
> +                       memcpy(cache, ioucmd->sqe, uring_sqe_size(req->ct=
x));
> +               return -EAGAIN;
> +       } else if (ret =3D=3D -EIOCBQUEUED) {
> +               return -EIOCBQUEUED;
> +       }
>
>         if (ret < 0)
>                 req_set_fail(req);
> --
> 2.43.0
>
>

The io_uring_cmd plumbing part of this series looks good to me.
I tested it with io_uring nvme-passthrough on my setup with two
optanes and there is no drop in performance as well [1].
For this and the previous patch,

Tested-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

[1]
# taskset -c 2,5 t/io_uring -b512 -d128 -c32 -s32 -p1 -O0 -F1 -B1 -u1
-n2 -r4 /dev/ng0n1 /dev/ng2n1
submitter=3D1, tid=3D7166, file=3D/dev/ng2n1, nfiles=3D1, node=3D-1
submitter=3D0, tid=3D7165, file=3D/dev/ng0n1, nfiles=3D1, node=3D-1
polled=3D1, fixedbufs=3D1, register_files=3D1, buffered=3D1, QD=3D128
Engine=3Dio_uring, sq_ring=3D128, cq_ring=3D128
IOPS=3D10.02M, BW=3D4.89GiB/s, IOS/call=3D31/31
IOPS=3D10.04M, BW=3D4.90GiB/s, IOS/call=3D31/31
IOPS=3D10.04M, BW=3D4.90GiB/s, IOS/call=3D31/31
Exiting on timeout
Maximum IOPS=3D10.04M
--
Anuj Gupta

