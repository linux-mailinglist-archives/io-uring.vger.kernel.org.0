Return-Path: <io-uring+bounces-11889-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iKjwAXmQcmnSmAAAu9opvQ
	(envelope-from <io-uring+bounces-11889-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:02:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 856EA6D99A
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD9BE300B45B
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 21:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB1D3AA196;
	Thu, 22 Jan 2026 21:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="M5dQvsEj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868338FEF3
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 21:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115766; cv=pass; b=NsK/K4pohees3xPgUcwjmV0ZGGSLiQJq9whLMq3lwhf1wCL18qt5Fw2DVYwUP3VJr9PlaMYvNMYIM7Pg0qStrxbSF4jwrlq4kAU5iGehnxOWSvIhczmO0v6ofPNG+oL9WPU+zGR6oJ84h4EYS4CNNDkLkPS3uAcYafolfL8FRFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115766; c=relaxed/simple;
	bh=e/QVsuEdSwNyET3wwB3q69H2wHyH0tAfoogUFj06q2A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OQ/HhYFYOyPZKLrA5wTxK1U3hyRuryi+o0eZw1DO148prKoZv+zjC7cNEXV09wulvwRIjmoFqYs4UPYjOE/4wrVpI59l7xwC0YevTLajadyUF7lNl78GLIDB1H98tkTtDUoxegKedUAIbeQpKSLZJ1B4ufo3F28DwwyZbkVbq48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=M5dQvsEj; arc=pass smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1233be8d537so87276c88.2
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 13:02:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769115757; cv=none;
        d=google.com; s=arc-20240605;
        b=BdYScccpakOO8lTzmsYDwY3nRNqdF9lnuqQIokX88ggPHo4XONc30BBYRoQokYb+nq
         af5DFJoXjjT2x1gUQrUSNqOHAkmxnqASfTQC6vw+JiZgqCDlU1jbtfRpcWLhdUJd+Dto
         881wXvc0hhlSvmK7cVqKTD8+OuqEzcxBqMdLNBZMXP7ruGybj8pNrHPQltXiFlJg34ak
         zVm2k3049ux0HaAhIuRUh1ji7yDLicRypwrtMZ+eXQ2kHe7+bnsOS44gmqihPR4cpGK9
         ctDzgWbp8gD53hZksbbtInWQnCnapyu1KZlrWhTAX9iFgElqrQnzhEAt1+oOxtLKO/kZ
         3z1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AqQnMCpGuh+PP41KooEigfpzr6TswhXwK3MFMdrApQo=;
        fh=r9ecS3yUPTzXyReZhLnYJa+jcu6thzU9byYQVpuE/HU=;
        b=Q+uI3QhZ9gBrYYLUBHAaISzkEWEXYV5HP8KuOBoJLRFH6B4hLlqSnzv4tC0+tGxNhH
         hbNsLgQl308giVhz4mj+eSvjOlgUH4qRLUyn/A8XTD0QAucweRh/KjCwJAKwPBZ5l5yV
         Opjmgm7CCbDu5h+3pomgGCy2YHizNoZygTkqMZVawMxCquuibAlVQH84UbPCurTqYcmG
         B3f9yQJbR1bN0gq66itrkIbtci1jugizGm5j88IM+zFi98wEnRTn3uC/UedzxdzbjZbm
         bD0Hb++PL1YivmrzsGcIfw0ex+X6/2GwtdMAyVdWEtF3DuzYhW5b07ia7eA9TKE/iFvj
         SAGQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1769115757; x=1769720557; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqQnMCpGuh+PP41KooEigfpzr6TswhXwK3MFMdrApQo=;
        b=M5dQvsEjaGNMCO9pXoWQBui1/Wlca9nJtEhg4QUUlIXaXFGBA+DTShJnE/TnYEllf1
         zyr2GK9Cmqhy8l8S+/v8kA44Qy4TaWNo9HSrERVARcPSDmFCuayaA2wYEPG6NHnfpDYW
         Lx5q3Moxn8L30lSdDvym2Hz8q+sj0inJeNsiZCqA8N0PeFcpbIBkdXPw6sZKGk5pWvS8
         wyBZ3FkIHgQouHgk1gtC8t9DkGh7ShuxssUIC55qwbwUgccT3SbozPuTqaJKNkIAPSy/
         vO6uIzjIbjss1XpKZgRheyXB5fdrATg//fC8CVItLdhJO6zsUaknX0dfIsdtMaJzrgaT
         6aaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769115757; x=1769720557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AqQnMCpGuh+PP41KooEigfpzr6TswhXwK3MFMdrApQo=;
        b=qBhhSt3vxcaieqTUMyBD0gXY882tdfhbNNKHjN5/At0j+iZseWeYiYlioevWL7fl+4
         0nvK2bENFHlHxVDYSMc9MV8fK+6nx8hLbFrybzY4r3+KY+YFzLfvFvyyk1OGg8A0Kf3C
         vg7rld8bWLq1F2d9Hpf72wQjEUrTG+YpI/g065MpvlB0WcUQ5Aw/dEAtS5iASwMyemsB
         zEZInPKbUGzjVQozD6lt2qNoY7IYkaeokJV1vHgJCwK8tD4nTlS/1F6Acj3RT9vaw9qM
         8CGxekfPI9aq5VL9HabMBgzcu5V2zpTRiaqZJvAaiONtw4i3widRgG9yxqLNQweBQ1vF
         OP0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXXQt4Fw3zjme7wcp21sm9jbkdFmi/u0x01I932Y8Rp0yeFUcMKxMtWvLJ05+DSEjxIMMpK5wyI6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5ytvIj8Rg8o+dmRn3Dv0X0KZHOBw3G3a6WNlBcWuG52Nousu7
	08lMBd4DsqnpbH2Y957skYS2cgu3BV8JRnwiRdgs+i3/PcwqF4kLKRXJi2QtQoklGNcLLtJ9V9f
	tD2B1F7JVWBxEOyVO4CC8yr81zqtW29pI5ddKWIzZ8A==
X-Gm-Gg: AZuq6aJ4Ou4FjLNJHFLFfOoS0ZF1xaEXouDSdLGObTC+2jrXEjFgLUcKCoi7d2mDh2J
	3QOvNiHOz8L87yDRWfl8ykY2BQeIKjt4cVnpG8dQpCxW2ET8b2JVj8oaX0aMems11SPJFBYeWqb
	ESkJvfVptTwSqQ3uRmHAPqo7rWBfg7cEYjWnr0aU+FkJ9kIzp88Y95I4c/Vdv6WFJ9MLLHTR0pN
	m7NQHsYVsgjz/xJRc5ECCk+hVTHH3EFtXDhJbqsPMXwLcxo+vVUKWOLFhTiWDOIKk3c/N++wVaZ
	98BXUw==
X-Received: by 2002:a05:7022:2385:b0:123:2d38:929b with SMTP id
 a92af1059eb24-1247dc01168mr190633c88.6.1769115756669; Thu, 22 Jan 2026
 13:02:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com> <20260116233044.1532965-9-joannelkoong@gmail.com>
In-Reply-To: <20260116233044.1532965-9-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 22 Jan 2026 13:02:25 -0800
X-Gm-Features: AZwV_QglS7d7muhiOx01JyBnjM9VKzOJncuZ1lNjPAcn3AtNEhRnbxQyk88GRDo
Message-ID: <CADUfDZruYbRfpftns3a17HHF=ZqayztP-t5uVzSRB3APhree+Q@mail.gmail.com>
Subject: Re: [PATCH v4 08/25] io_uring: add io_uring_fixed_index_get() and io_uring_fixed_index_put()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, bschubert@ddn.com, krisman@suse.de, 
	io-uring@vger.kernel.org, asml.silence@gmail.com, xiaobing.li@samsung.com, 
	safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11889-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,ddn.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,purestorage.com:email,purestorage.com:dkim]
X-Rspamd-Queue-Id: 856EA6D99A
X-Rspamd-Action: no action

On Fri, Jan 16, 2026 at 3:31=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add two new helpers, io_uring_fixed_index_get() and
> io_uring_fixed_index_put(). io_uring_fixed_index_get() constructs an
> iter for a fixed buffer at a given index and acquires a refcount on
> the underlying node. io_uring_fixed_index_put() decrements this
> refcount. The caller is responsible for ensuring
> io_uring_fixed_index_put() is properly called for releasing the refcount
> after it is done using the iter it obtained through
> io_uring_fixed_index_get().
>
> The struct io_rsrc_node pointer needs to be returned in
> io_uring_fixed_index_get() because the buffer at the index may be
> unregistered/replaced in the meantime between this and the
> io_uring_fixed_index_put() call. io_uring_fixed_index_put() takes in the
> struct io_rsrc_node pointer as an arg.
>
> This is a preparatory patch needed for fuse-over-io-uring support, as
> the metadata for fuse requests will be stored at the last index, which
> will be different from the buf index set on the sqe.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 20 ++++++++++++
>  io_uring/rsrc.c              | 59 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index a488e945f883..de3f550598cf 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -44,6 +44,14 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd =
*ioucmd,
>                                   size_t uvec_segs,
>                                   int ddir, struct iov_iter *iter,
>                                   unsigned issue_flags);
> +struct io_rsrc_node *io_uring_fixed_index_get(struct io_uring_cmd *cmd,
> +                                             int buf_index, unsigned int=
 off,
> +                                             size_t len, int ddir,
> +                                             struct iov_iter *iter,
> +                                             unsigned int issue_flags);
> +void io_uring_fixed_index_put(struct io_uring_cmd *cmd,
> +                             struct io_rsrc_node *node,
> +                             unsigned int issue_flags);
>
>  /*
>   * Completes the request, i.e. posts an io_uring CQE and deallocates @io=
ucmd
> @@ -108,6 +116,18 @@ static inline int io_uring_cmd_import_fixed_vec(stru=
ct io_uring_cmd *ioucmd,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline struct io_rsrc_node *
> +io_uring_fixed_index_get(struct io_uring_cmd *cmd, int buf_index,
> +                        unsigned int off, size_t len, int ddir,
> +                        struct iov_iter *iter, unsigned int issue_flags)
> +{
> +       return ERR_PTR(-EOPNOTSUPP);
> +}
> +static inline void io_uring_fixed_index_put(struct io_uring_cmd *cmd,
> +                                           struct io_rsrc_node *node,
> +                                           unsigned int issue_flags)
> +{
> +}
>  static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret=
,
>                 u64 ret2, unsigned issue_flags, bool is_cqe32)
>  {
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 41c89f5c616d..fa41cae5e922 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1152,6 +1152,65 @@ int io_import_reg_buf(struct io_kiocb *req, struct=
 iov_iter *iter,
>         return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
>  }
>
> +struct io_rsrc_node *io_uring_fixed_index_get(struct io_uring_cmd *cmd,
> +                                             int buf_index, unsigned int=
 off,
> +                                             size_t len, int ddir,
> +                                             struct iov_iter *iter,
> +                                             unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       struct io_rsrc_node *node;
> +       struct io_mapped_ubuf *imu;
> +       u64 addr;
> +       int err;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);
> +       if (!node) {
> +               io_ring_submit_unlock(ctx, issue_flags);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       node->refs++;
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +
> +       imu =3D node->buf;
> +       if (!imu) {

How is this possible?

Other than that,
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> +               err =3D -EFAULT;
> +               goto error;
> +       }
> +
> +       if (check_add_overflow(imu->ubuf, off, &addr)) {
> +               err =3D -EINVAL;
> +               goto error;
> +       }
> +
> +       err =3D io_import_fixed(ddir, iter, imu, addr, len);
> +       if (err)
> +               goto error;
> +
> +       return node;
> +
> +error:
> +       io_uring_fixed_index_put(cmd, node, issue_flags);
> +       return ERR_PTR(err);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_fixed_index_get);
> +
> +void io_uring_fixed_index_put(struct io_uring_cmd *cmd,
> +                             struct io_rsrc_node *node,
> +                             unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +       io_put_rsrc_node(ctx, node);
> +       io_ring_submit_unlock(ctx, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_fixed_index_put);
> +
>  /* Lock two rings at once. The rings must be different! */
>  static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx =
*ctx2)
>  {
> --
> 2.47.3
>

