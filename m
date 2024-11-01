Return-Path: <io-uring+bounces-4295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A2C9B89BE
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 04:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EE24282CD6
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 03:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF9913D897;
	Fri,  1 Nov 2024 03:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cafcejSz"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FC6136338
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 03:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730430883; cv=none; b=uBiMmFXp1+ZFsCwPt0X72o1ubE0e+cH8VquFX3vvcEOj+N2joVEH94rf1IXNhXEHp3jzZwCNZtDyluOQj6Z2+6v3WFTKHF/SSFUDnaTWuck5TG7ZoQ6LcNHeKI36YOwQ59/oOr9+TJHdcPdKgF8PwcHg1uKZcggOU6Hi661oqMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730430883; c=relaxed/simple;
	bh=oJADQyT41cgDG+Httm4CpIwqTTPYTI5B/RlituotPkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AotcIZ6HfrtwQGU6cvVCLNjqg/Wc5tP9s7NWafonOeEOixoovOxXb21kNdXUa0SPse/zkFdRNbX9Sgt+AxYSwhoN4hoy3wEGS8BXfp2jk8B2VmesQYy6gbDeuL0cAhgyYLGv9nU68fFL8J8d586n2R/BktIbxfJHtGddcnB5cvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cafcejSz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730430880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xUNsVE8/tr5g8xke4lHMsKbEdjO/nnTnT+u8kvQk1cA=;
	b=cafcejSzEBugXymEDvB8X0dap/GM7z46P+AS9k1fMDlIpYipMBl7T3wqpq23wSAVdH6zLo
	ZTQ6vMVKfCidrRieJey7P3WRs26fiolMGwB/E1PQSgCBayNtW++k9+IAjX1b3/7+LjnqmC
	L1hkYHfrng/mDxYJKAjLeyZVTXbYSDw=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-EjFcK7fnPna5iFCO3h0uNQ-1; Thu, 31 Oct 2024 23:14:38 -0400
X-MC-Unique: EjFcK7fnPna5iFCO3h0uNQ-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-50d5352c757so563089e0c.2
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 20:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730430878; x=1731035678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xUNsVE8/tr5g8xke4lHMsKbEdjO/nnTnT+u8kvQk1cA=;
        b=dMKe98TSENAtrinbd25pFBO4J4fO4W9R/RidLDkL8FF0FJceHeG7u1EzNjNf9h35At
         O/4qjIBb0Jm7nDL4EHCooEOpiTgmkfMXJGxdRCJGxaE7eNOYL1AKQrT9rEr7vbHRI3BN
         MBNq1Y2hd8p7f8rX1QInxJiu302xRHwDrUcBYzpcXslXiUNaQDF8jwjJQu1s3ej8IE7D
         nHF4G56K2fbY9qzM5w8p5Q0KUzc1DRK2Edlj6WRg9PP6BLm4Vh89LSopfUpIRDAdw8EV
         M/SRWxIV7HCI1SShiSW+AZu1p6glo6bAj0ZT//ClwcvHWdNNwQ9ece5rJ97vOabevHwD
         mkNA==
X-Forwarded-Encrypted: i=1; AJvYcCWIlNHmySDZBcfRFYnQcGIyXCm5CvLhpE/E2x0jExEg/8Nevs6o3eY1BNKQqH2b7097g+r80b2lfg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy2j/3AmK8PCi6sEYajQp7mDHguAY+Le5gEeZhP/ieU4IcQswC
	WYPPxkvH5ocXQOQk3IsHVk/GrVWV4BefuJ1mIhwl8nlk2Ip9tyCciedrX8956UEmLgJ2qu4lL09
	5/KPHmOSI1fH9DXVfzf9/je/hBjCQfTfRd1dVTPGfrF3YoTsBCrI9b7R5IM6Nw5NGan7yBlhPwl
	egIGghPF/AILSvQy5N63YP3TAKxAgUKRg=
X-Received: by 2002:a05:6102:3046:b0:4a4:8a29:a8ff with SMTP id ada2fe7eead31-4a954305f97mr6147491137.17.1730430878193;
        Thu, 31 Oct 2024 20:14:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnNZrFrJlLcR97lRnzjQMxmyfGvoTqh6eerFNfkVie4XmhlfrmsgL3EqoUexT6N2x6AOG1HoyJUYwjxTugqS4=
X-Received: by 2002:a05:6102:3046:b0:4a4:8a29:a8ff with SMTP id
 ada2fe7eead31-4a954305f97mr6147485137.17.1730430877866; Thu, 31 Oct 2024
 20:14:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031163257.3616106-1-maharmstone@fb.com>
In-Reply-To: <20241031163257.3616106-1-maharmstone@fb.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Fri, 1 Nov 2024 11:14:07 +0800
Message-ID: <CAFj5m9+Gta6BQLUXf76PaCXCKSPj-uNL8CDKuAEm2bpwzd3Vnw@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/cmd: let cmds to know about dying task
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 12:33=E2=80=AFAM Mark Harmstone <maharmstone@fb.com>=
 wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> When the taks that submitted a request is dying, a task work for that
> request might get run by a kernel thread or even worse by a half
> dismantled task. We can't just cancel the task work without running the
> callback as the cmd might need to do some clean up, so pass a flag
> instead. If set, it's not safe to access any task resources and the
> callback is expected to cancel the cmd ASAP.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h | 1 +
>  io_uring/uring_cmd.c           | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 4b9ba523978d..2ee5dc105b58 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -37,6 +37,7 @@ enum io_uring_cmd_flags {
>         /* set when uring wants to cancel a previously issued command */
>         IO_URING_F_CANCEL               =3D (1 << 11),
>         IO_URING_F_COMPAT               =3D (1 << 12),
> +       IO_URING_F_TASK_DEAD            =3D (1 << 13),
>  };
>
>  struct io_wq_work_node {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 39c3c816ec78..78a8ba5d39ae 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -119,9 +119,13 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
>  static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *=
ts)
>  {
>         struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> +       unsigned int flags =3D IO_URING_F_COMPLETE_DEFER;
> +
> +       if (req->task !=3D current)
> +               flags |=3D IO_URING_F_TASK_DEAD;

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

BTW,  uring_cmd can get notified when the ring/task is dying if
io_uring_cmd_mark_cancelable() is called on the command.


Thanks,
Ming


