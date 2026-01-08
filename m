Return-Path: <io-uring+bounces-11535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DB778D061CC
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 21:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 917333032A8B
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 20:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E4A2F2905;
	Thu,  8 Jan 2026 20:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="e6UNd7dQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A95328AAEB
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 20:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767904493; cv=none; b=ahaHf5Uikx4hYQLbSBC2SX7oLW9W2VkbO3E0Wr6jpsFlm+YnybX1lYxQy4gLI6BMycN88CRa24ZSijc+9/UDOybZineceM1fe7geEK0E7ZjJwNOQU7NL0PgcYBy7bRwthg1lV2u4YqTmRoBCcMMEduChqdMwRfYNOXMRD1o9jJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767904493; c=relaxed/simple;
	bh=CrKlDG2xbsxKf3a4y7GyC24tTUg87XGt74e27eJikzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=br87v4xsZCD8J3ysgZnwBLFIn7uN1y7sGe/1IXL58oykPyH//fUUd383dehiciHnG+CgJLlNI+PawNV1kqfpnEt3sJ5WfpTNHhuSVG3Y9kEPBrBfyglLzurN0RJ/QKV0KDEjUd9FO4g0eAAK1d5NjDgA7ypKACu4LLV1vAz2UWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=e6UNd7dQ; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-11bba84006dso338424c88.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 12:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767904492; x=1768509292; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fnvW4WKmangsNuW7eKuI0hTk1XwSAzpyTyaGA3dt4So=;
        b=e6UNd7dQ4sVfMFx9/m4PSz9aVlfNG0XjoaQjMlXexXQ2AyKS9ELMYpXC1py66uI993
         9GutBCPPzJawlFWQqdHCI4Ozw0M9M841eK3MSuXwvTvBJGz17MLZ16x8FNOdvz3Q/LZk
         JnrqW5bD6TOKj9FElfP0Ak4ukimYypCBeN4R3TjYjsIJOiTcE06jKEb60uvwZs39unHh
         PJLTP/KGH59RY+ch6SyJ6nBDCKsvI7a2UBCEcN9wgN436Kx+JglkiO1H8H614+jrfyvJ
         C1bOiPr/lUTarfgsZJQul2qoI87UztYterHji847DvEC/VMvTzHbWGvWi3dBacF9jpS6
         h57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904492; x=1768509292;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fnvW4WKmangsNuW7eKuI0hTk1XwSAzpyTyaGA3dt4So=;
        b=PxChEe5Sc+EtLgE7rOYqs+I0su4o9CbfViwvp1l0jnqN6CPtTQgUzi7iJ/Uq1jBZzE
         uoM9yb7bdh2Db4G7evuIzJV5nOKl4Fu1VL2bfeKeLrfEU0wu+itQ5M0Wx57c/0InLyHE
         B1nfGGUAlOW0Qtr9vzUIkw5thFePUAcCMqDWKQfnZmiNOpOrr/fm0/AC14S2lYcxsd3n
         mPDJ4iS//wMhOh03PdeP6xxmjsUNbOtFyOyWbkF8ldGscXsSJZoq+van8LhG41/bLmqY
         5kIpC6xXPx5YktiSgZjTyRNMiGzzgCiRhzmAyedgQgENsf6WR1xRChs+7ovLLhZl2Qrh
         CJyg==
X-Forwarded-Encrypted: i=1; AJvYcCV5BAa6nBIwB+M6+Ws9tJyxyXtmUStd5CqEREJR7XVvNqlxga02jx9wx2Tm58tMT9QN6Wesd/uDrw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4nePSFbXCJJ+oeG8QUQe3XYGrW6CufFR17HA32cDsr5eVt49a
	31Fww1V2KAXH/7UBCSj5yFCsaH5SGFXQNG3OrLkcwhl2AnZ+euX1iZmb7t5ePfPI7aAxuYlMYKc
	/rsFX2r1R+0j3aemegd/tVSw/Blx+RJsw/6JwdUHjhA==
X-Gm-Gg: AY/fxX6Yk0ihrSfAf8blmRNn1tdBd/B04S7uGPPZmijOIBKoa9cTNApUxxedQIIRBwl
	K6ADdFCuLazgq9gJ30vYshQOPsBfweWCHo0DCyEyZwF8I6gxwGxWWTpOLXJx9JH3+391lDkpAT3
	zapKyzu0Etn2oIxJjh0T5sqHGROLNfvyy/pJ3KCewL3vXTFstWGbQUslFgFAYlBltc5k6iiCDiK
	xGgcwxjw/n7++4Om78RizRjo9dzahGa1X28wOe3aYi18ql4OpAorl0IbgD1dgnDPWwTFO+D
X-Google-Smtp-Source: AGHT+IE/LI4BedIHNVzwwnWv3XeKEAv4clZYkrvUqTaySrNctmMY+MTE2JmVrYjiviwxSSiLeLnGBHeMs9FaK31koHE=
X-Received: by 2002:a05:7022:41a7:b0:11b:ad6a:6e39 with SMTP id
 a92af1059eb24-121f8b6063cmr3542848c88.5.1767904491511; Thu, 08 Jan 2026
 12:34:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-11-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-11-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 12:34:39 -0800
X-Gm-Features: AQt7F2p-Qcq3-Jkt49SWMqafpZtOjR1Z2rts-3pvXcHnzz1shnWSnfp0JcixX6U
Message-ID: <CADUfDZqHhVi1RY71dvEFbWsHmrzLbTSgev5o8yRXxExV5=XY2g@mail.gmail.com>
Subject: Re: [PATCH v3 10/25] io_uring/kbuf: export io_ring_buffer_select()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Export io_ring_buffer_select() so that it may be used by callers who
> pass in a pinned bufring without needing to grab the io_uring mutex.
>
> This is a preparatory patch that will be needed by fuse io-uring, which
> will need to select a buffer from a kernel-managed bufring while the
> uring mutex may already be held by in-progress commits, and may need to
> select a buffer in atomic contexts.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/buf.h | 25 +++++++++++++++++++++++++
>  io_uring/kbuf.c              |  8 +++++---
>  2 files changed, 30 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/io_uring/buf.h
>
> diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
> new file mode 100644
> index 000000000000..3f7426ced3eb
> --- /dev/null
> +++ b/include/linux/io_uring/buf.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +#ifndef _LINUX_IO_URING_BUF_H
> +#define _LINUX_IO_URING_BUF_H
> +
> +#include <linux/io_uring_types.h>
> +
> +#if defined(CONFIG_IO_URING)
> +struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len=
,

I think struct io_kiocb isn't intended to be exposed outside of
io_uring internal code. Is there a reason not to instead expose a
wrapper function that takes struct io_uring_cmd * instead?

Best,
Caleb

> +                                      struct io_buffer_list *bl,
> +                                      unsigned int issue_flags);
> +#else
> +static inline struct io_br_sel io_ring_buffer_select(struct io_kiocb *re=
q,
> +                                                    size_t *len,
> +                                                    struct io_buffer_lis=
t *bl,
> +                                                    unsigned int issue_f=
lags)
> +{
> +       struct io_br_sel sel =3D {
> +               .val =3D -EOPNOTSUPP,
> +       };
> +
> +       return sel;
> +}
> +#endif /* CONFIG_IO_URING */
> +
> +#endif /* _LINUX_IO_URING_BUF_H */
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 0524b22e60a5..3b9907f0a78e 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -9,6 +9,7 @@
>  #include <linux/poll.h>
>  #include <linux/vmalloc.h>
>  #include <linux/io_uring.h>
> +#include <linux/io_uring/buf.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -223,9 +224,9 @@ static bool io_should_commit(struct io_kiocb *req, st=
ruct io_buffer_list *bl,
>         return false;
>  }
>
> -static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size=
_t *len,
> -                                             struct io_buffer_list *bl,
> -                                             unsigned int issue_flags)
> +struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len=
,
> +                                      struct io_buffer_list *bl,
> +                                      unsigned int issue_flags)
>  {
>         struct io_uring_buf_ring *br =3D bl->buf_ring;
>         __u16 tail, head =3D bl->head;
> @@ -259,6 +260,7 @@ static struct io_br_sel io_ring_buffer_select(struct =
io_kiocb *req, size_t *len,
>         }
>         return sel;
>  }
> +EXPORT_SYMBOL_GPL(io_ring_buffer_select);
>
>  struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
>                                   unsigned buf_group, unsigned int issue_=
flags)
> --
> 2.47.3
>

