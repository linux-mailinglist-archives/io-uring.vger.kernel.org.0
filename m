Return-Path: <io-uring+bounces-4562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4079C1362
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 01:59:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85FAA1F232A3
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 00:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2A71C36;
	Fri,  8 Nov 2024 00:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkGALXav"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B62101DE
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 00:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731027591; cv=none; b=Zzuo2nSwDvxmsuqQAigVQcgqMCEoGlwmXSLDsYbRVAWLJhCCLjSGzIsGhZFmJ9GpBH6Nf1vEDkG5jI55z4bzOfSecsZfAqmaNFxIcN+Nj1RiJnoKv7Yasz+MnEmvZ30Rg9yh0SE3P7hpFkZ1dljoVvrmbmKvIVWkUCSQ6KRP6YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731027591; c=relaxed/simple;
	bh=W4hReRp2Mnbvh0WIskrdIeFbIogt3Hkskf8ms8EAoOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uWB/DzpAIHZwCNj5L+bUODrn8BJUl36HSIXfxky0tDi0MLrUVzvlXyNBeBCRhDqpRhl5r3fsPjlCVSqLaZ9C+A7V5YJ9UwbCK8qtTF0XWGPz7tmVg7qzZJ1ncdoOckuL66f0IFWFisOoNj8DGl5Kd5kP6IOH94YESoze1+6Y0yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dkGALXav; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731027587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mrxY8mthm3WC9EQoiDbhDZtH2molPeBe5KI5KQp4nCM=;
	b=dkGALXavodkUjBi/V/0GhbyQorR4muj2WKiVG28rCGLJU0vcl29ngo6lvIIDm1i2ckqF/W
	T7fTb0jS7JDMRr24pXmU7Pg4OtJFKfy3Gidpobokycb7WSQlIZ03di9lEqK/Its+TVAXLf
	CaAtHtoEB1Xt7GCqo8tCJ1kb0cwn8GA=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-acL0CMo-MQOZC8OkIrrfFw-1; Thu, 07 Nov 2024 19:59:46 -0500
X-MC-Unique: acL0CMo-MQOZC8OkIrrfFw-1
X-Mimecast-MFC-AGG-ID: acL0CMo-MQOZC8OkIrrfFw
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-850470fc8bfso1682493241.1
        for <io-uring@vger.kernel.org>; Thu, 07 Nov 2024 16:59:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731027586; x=1731632386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrxY8mthm3WC9EQoiDbhDZtH2molPeBe5KI5KQp4nCM=;
        b=nFAnMBfrvpMjPR14ikWpHs0Jvdqa5hHK3EdzNLzclYoedWRu1Cc4zXl5d5KHgFuQUK
         4FU3H2bc2b23pAcHIMJ6x9/WOSi9jZ6/WqA8VYBT6QAH3AVRVh5JeUF5U6404W5G79NL
         81kPcTtFTn8vW+5t2Ga4T6vNiKayM62dep2gCcr4r0HM+U1pIvltgVNer/b8x53lKPkd
         +phWjFMtZ9wSEQOm7qRAWGLfMp0c4mK/vKUq5HNcVY8t4bxCE9bGbjGLoMpKY2dNhcr9
         q4tgAo2rWNUhdhrvplEIWnPtf2vwzwopMPJBASTP9LfkUkwr3y08WMHdRzvnW0hdShEu
         qpFw==
X-Forwarded-Encrypted: i=1; AJvYcCWzx2Izx25mSu36jfpmx75cilY7vcUpJyn9CCKKrb7HZ1tnS6yBvwpatctcoDV/MrB+SUHnzCvuOw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUND62HRLvJj/wLE5IfW0VvNBQOX/9gm5BLJyA15CJV4HMjn7Q
	CDliClJPJmM2xkyhfSicMaJNNB5eElb9GRnXQ+ULtd9z+NBLA0rpnyL8ri/0JrWrfPyC2baW8aK
	4BHdr3jP3WY4Lmcctd7c367Hiv/d50dKow3skROZul59jlnpwwZLASJn3J8GCwW7wXrRDDSGlTQ
	GAM1rnhrogGXAsytOlbZ6pjjCQyaIaWvs=
X-Received: by 2002:a05:6102:f09:b0:4a4:4868:cfd9 with SMTP id ada2fe7eead31-4aae2155d07mr1001991137.1.1731027585791;
        Thu, 07 Nov 2024 16:59:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGV2g7efsraeLBtXSmAhHbiS1EPg9TvsBp4gAzEj57wDFhMq4wrH7lpK+/pHfyImoFhI9XQ4HQC46BD6cztxeI=
X-Received: by 2002:a05:6102:f09:b0:4a4:4868:cfd9 with SMTP id
 ada2fe7eead31-4aae2155d07mr1001987137.1.1731027585541; Thu, 07 Nov 2024
 16:59:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107110149.890530-1-ming.lei@redhat.com> <20241107110149.890530-12-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-12-ming.lei@redhat.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Fri, 8 Nov 2024 08:59:34 +0800
Message-ID: <CAFj5m9+wyUzA2WDN4YA1Q=YwnwVZ48g5=q1HSMaXbs7-oHgPYA@mail.gmail.com>
Subject: Re: [PATCH V10 11/12] io_uring/uring_cmd: support leasing device
 kernel buffer to io_uring
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>, 
	Akilesh Kailash <akailash@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 7:02=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrote=
:
>
> Add API of io_uring_cmd_lease_kbuf() for driver to lease its kernel
> buffer to io_uring.
>
> The leased buffer can only be consumed by io_uring OPs in group wide,
> and the uring_cmd has to be one group leader.
>
> This way can support generic device zero copy over device buffer in
> userspace:
>
> - create one sqe group
> - lease one device buffer to io_uring by the group leader of uring_cmd
> - io_uring member OPs consume this kernel buffer by passing IOSQE_IO_DRAI=
N
>   which isn't used for group member, and mapped to GROUP_BUF.
> - the kernel buffer is returned back after all member OPs are completed
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  include/linux/io_uring/cmd.h |  7 +++++++
>  io_uring/uring_cmd.c         | 10 ++++++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 578a3fdf5c71..0997ea247188 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -60,6 +60,8 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *=
cmd,
>  /* Execute the request from a blocking context */
>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd);
>
> +int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
> +                           struct io_rsrc_node *node);
>  #else
>  static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,=
 int rw,
>                               struct iov_iter *iter, void *ioucmd)
> @@ -82,6 +84,11 @@ static inline void io_uring_cmd_mark_cancelable(struct=
 io_uring_cmd *cmd,
>  static inline void io_uring_cmd_issue_blocking(struct io_uring_cmd *iouc=
md)
>  {
>  }
> +static inline int io_uring_cmd_lease_kbuf(struct io_uring_cmd *ioucmd,
> +                                         struct io_rsrc_node *node);

ops, the above ";" needs to be removed, :-(

> +{
> +       return -EOPNOTSUPP;
> +}
>  #endif


