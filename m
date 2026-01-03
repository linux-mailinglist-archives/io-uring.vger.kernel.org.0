Return-Path: <io-uring+bounces-11358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1740DCF06C0
	for <lists+io-uring@lfdr.de>; Sat, 03 Jan 2026 23:46:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97D703010CD8
	for <lists+io-uring@lfdr.de>; Sat,  3 Jan 2026 22:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DAE1990A7;
	Sat,  3 Jan 2026 22:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KShEaLnm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9246B13B293
	for <io-uring@vger.kernel.org>; Sat,  3 Jan 2026 22:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767480364; cv=pass; b=f84C2RcmYs3bohblJLkuB9uWYFErmjHVqeshvZ7UYJpwu0mBSFuf+LrZ72VLr7xfOAmp7BlpqFSKmACDWNCgdtSm0ButYyTzuK5+YfhIcHHg+m3Zne6hvdcBuDQFbsIir4LGXi1uHHNKXBZXKG3Azyo/g8XaFWdjIUZ7fCXIbno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767480364; c=relaxed/simple;
	bh=QvL0IEYlojdzn2+kCqrNQA9sYBsL0NQVJKZC1AUN3Js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z4p4UWq7z/7zuarNutBeTHqxiHFFzVsmGiSXdIhz9w+shkYnO4qTKLqz1MLA9q+xzxHO//yiaBxmfKWXRIyttjNHuRyYUua5KwB32AZP8n7vkCbbzzd6KeNdRTHyvomfsHBrNFgdRBtOyWGZ5qGRNTNlnq929CpUnQThHVKCmt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KShEaLnm; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0a8c2e822so34060855ad.1
        for <io-uring@vger.kernel.org>; Sat, 03 Jan 2026 14:46:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767480362; cv=none;
        d=google.com; s=arc-20240605;
        b=LgSkx5F7FDsL3IPkXTKuJ5lffSjYHoqaFhyPTjVaZyViswC1orlk9j8ALqPMmPPtNs
         eO9uKJdfYhpkGugoGP5nXGu4gAdwDtFeCzd+FMf4yD+pQgywa+qFKfN70SVrjl6WxqMq
         8YHJToPLFUVPD6ENLbL8XkaL1SyNC0yKpUKyIZIBt79IsfaTyw69g+oegquFtMd60ofO
         HyLSNK/iLSkB8WD1x1la1VMO+uHwLr6lq/l2zs8PxVShrlMzNnA/vYAsNvMF61GHCSGX
         z9SsIpAp7eYbNY0DEkHejoRD/p65fIOPzYXcb26s67/GFjh32PcpQ8JrZZyRgKUOP2Cv
         xpCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XGp4slpsd36FtS6nH/SR27JKHN67f5JDPi7Wgd1lzlU=;
        fh=aJWbAPnfPNbzoeMDQauH5ejFu9YuXExbawoxPV2K42Y=;
        b=QAG2mfJLxiAi/Oj465SZULhKalh+jljmB1ZGQ2cEKrP5Qn/GzXv7brO7Hmgr1Leb1m
         c3QdK4xc9wSMv/pFDpBrXpLR1K/AnIHRi/qPZrUlKSZuSxNDftPFDrsWassBPGLBj9wM
         O7h+cprsVFJJyNG55ppmQCydvRRkMpjATfWfCVv8zwcuDbBhhSAq5n1fD6WeI2K8TO/E
         R3y4La/iSJVvv1N4SOeDVA0rVQeQDR5zNhFfIV9yO5vxIpl9JXDur4tdqFZhsy/zHMQR
         UrbX8zw+MhGnlWMkdBNdqZuv7yNvxDSjIneAgjKLllYiU6ULjRHimijf60xujslmkgUN
         jAzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767480362; x=1768085162; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGp4slpsd36FtS6nH/SR27JKHN67f5JDPi7Wgd1lzlU=;
        b=KShEaLnmRtdHuIqJ5pdQc60u6RfXO4JXRBVGhKAtI2BNjehNBlqwO3O1DrnhxoKhkt
         4EIvxDFSOfe4q0CjCJcUG5iEaPwfvDzdI4w09AJR0KLt2wjLY/FP1G61bYhJ9u4LQPsC
         As/ax2PCLvedoT19KPsEjdgcTbK0MuQSggOsHfPjEQTEqIOZpIdmE3R3c9Z0ijf0fNw0
         s0guT1mavWL8aafu8nEurvEKtjhuLXCLGF6ol5fWHNZ9miATN9Yjvfl5/2TlQhrZuEaC
         wDlVu/etUKw0QYG9SEUcT3TAZPlXj/OV9lGQii98Jvhp3x4TiDTwZfEqLudgR1taNjAQ
         PdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767480362; x=1768085162;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XGp4slpsd36FtS6nH/SR27JKHN67f5JDPi7Wgd1lzlU=;
        b=vY0ZdSgwQhTds7XYXSIo20IRQzSevAbt2ONp1Yv7g7UbJR2NL9pjd557AJnU7vheCN
         TqwXOfF/2fkP0pvnAPweY/f/g9Sl6U2QgmZzSicV9O81ky4Z58D9scmLZIW8ibHK/GNX
         1dY+cgD6piIfYa8vbtAkiO4FE1gL/yUFRenKnqrJh+h/8oX6s2h2KerBWAOnyb7ay3/D
         QYup+Gj3/JTvXW4Gavj1xx5k1GbiNzM5tPgiqEUnjLrGWZt2qSfQ8PfQrtJeg5RgY+sp
         AoumMqMNeiNVaRMC/WE4+gWfBA4GIoD6cfpzdfFhqLcsFjBzlDwxo5HBagkn+i1YoqMD
         /J0w==
X-Forwarded-Encrypted: i=1; AJvYcCXgS0GJBVlK9gaZule8U//b2/ppqPZfH2b5MBCUNNeKLtWb3PvupxrtYNBIv4oBJYWA5U57IbITdw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZazHbDLh4TtuCcCLKj/njKIwqcEImYeW6FctVHGXrxcUdyTP4
	GzsVEQXyp3VFQa5i4FG63BZNeMwifAlS2SSHRzT8D+QUt7AwTrTFQTkvlpskJESr2O/Pr7iLyPk
	X/V2FbpkiuN0I7PmqFllu4ougy5VeZrkepBnEInTziQ==
X-Gm-Gg: AY/fxX4OK1kSPAphnkbxjBCVSO1edGm/6Gk6g4ID2m8hrVhHiyb9tuNJi+HnHKfroom
	KhA63FT/yzinDWCXoUE+dbVo8K9qm+rmkGg3ZC7Cvg2Ept/wwK7tjzU7rm36w0apJz+s8dZj0kG
	84Q6/8SF8Ukq2Pf8YkGqSiqTQfo1Y5PAZVkR0oOZ/7cEwVn07WHUcyCD6ut7B/2atO6tO2lb5di
	QshmLmVP2ecByU5Yee5qRY8R4voZSTRSIKMMJELQ6JNQwi/xj/VUi0LZ3jPCWzfCtShoeJa
X-Google-Smtp-Source: AGHT+IHOqMuhJoMhmZ02WaBjabl6IVrpeObki83fCpag55F4Cw31dCSH+4rdvlCjougzCFLVvNpG7EdYoG29oYJ/UV0=
X-Received: by 2002:a05:7022:42b:b0:11a:5cb2:24a0 with SMTP id
 a92af1059eb24-121722b42c1mr23801291c88.1.1767480361568; Sat, 03 Jan 2026
 14:46:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-6-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-6-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sat, 3 Jan 2026 14:45:50 -0800
X-Gm-Features: AQt7F2rR-f8SX-sEp6qwHniHsd1svaEcM35nVb-EkG3DNEcEI9T7X5WNbjorMeg
Message-ID: <CADUfDZqAWCWchX=tqJxy5Hcz1z1s=TO12teuEiz67vXvxATtKQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/25] io_uring/kbuf: support kernel-managed buffer
 rings in buffer selection
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Allow kernel-managed buffers to be selected. This requires modifying the
> io_br_sel struct to separate the fields for address and val, since a
> kernel address cannot be distinguished from a negative val when error
> checking.
>
> Auto-commit any selected kernel-managed buffer.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring_types.h |  8 ++++----
>  io_uring/kbuf.c                | 15 ++++++++++++---
>  2 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index e1adb0d20a0a..36fac08db636 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -93,13 +93,13 @@ struct io_mapped_region {
>   */
>  struct io_br_sel {
>         struct io_buffer_list *buf_list;
> -       /*
> -        * Some selection parts return the user address, others return an=
 error.
> -        */
>         union {
> +               /* for classic/ring provided buffers */
>                 void __user *addr;
> -               ssize_t val;
> +               /* for kernel-managed buffers */
> +               void *kaddr;
>         };
> +       ssize_t val;
>  };
>
>
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 68469efe5552..8f63924bc9f7 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -155,7 +155,8 @@ static int io_provided_buffers_select(struct io_kiocb=
 *req, size_t *len,
>         return 1;
>  }
>
> -static bool io_should_commit(struct io_kiocb *req, unsigned int issue_fl=
ags)
> +static bool io_should_commit(struct io_kiocb *req, struct io_buffer_list=
 *bl,
> +                            unsigned int issue_flags)
>  {
>         /*
>         * If we came in unlocked, we have no choice but to consume the
> @@ -170,7 +171,11 @@ static bool io_should_commit(struct io_kiocb *req, u=
nsigned int issue_flags)
>         if (issue_flags & IO_URING_F_UNLOCKED)
>                 return true;
>
> -       /* uring_cmd commits kbuf upfront, no need to auto-commit */
> +       /* kernel-managed buffers are auto-committed */
> +       if (bl->flags & IOBL_KERNEL_MANAGED)
> +               return true;
> +
> +       /* multishot uring_cmd commits kbuf upfront, no need to auto-comm=
it */
>         if (!io_file_can_poll(req) && req->opcode !=3D IORING_OP_URING_CM=
D)
>                 return true;
>         return false;
> @@ -201,8 +206,12 @@ static struct io_br_sel io_ring_buffer_select(struct=
 io_kiocb *req, size_t *len,
>         req->buf_index =3D READ_ONCE(buf->bid);
>         sel.buf_list =3D bl;
>         sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));

Drop this assignment as it's overwritten by the assignments below?

Best,
Caleb

> +       if (bl->flags & IOBL_KERNEL_MANAGED)
> +               sel.kaddr =3D (void *)(uintptr_t)buf->addr;
> +       else
> +               sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));
>
> -       if (io_should_commit(req, issue_flags)) {
> +       if (io_should_commit(req, bl, issue_flags)) {
>                 io_kbuf_commit(req, sel.buf_list, *len, 1);
>                 sel.buf_list =3D NULL;
>         }
> --
> 2.47.3
>

