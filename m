Return-Path: <io-uring+bounces-11538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0714FD062AD
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 21:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D8E05300CA22
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 20:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FE832FA3F;
	Thu,  8 Jan 2026 20:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fUx8Yn6L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41006318B9A
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767905577; cv=pass; b=kK7oAMmK5H/oTao/fTFO813o8HqW9hq6cJmOhDUXdyJVKVR1FQOSyPQsu0cyk51Ef0U+Vsp+30n9rPHfdIlGn5tK+T1tI6WMYTofxN4U1HCA1zZsHjZH7B0Y/t0PqKD4v468YKLTjzZT3hq1POUE9ApOHyVtk1I8TZCgG/KlSn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767905577; c=relaxed/simple;
	bh=rKrSpl9LAH9ZZklMa67d9zjLF83UOFk4ybhSFIatnZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fCej2M7l8TQ9h0ha9E0mtkrUFVYhie2h5869yaIOZZ/rzBydH/booiFvN1S/9CbBozFI4f6sNitAuxQbbw9Tbvp3CqI3eJy4P/OCTHfuSTaVgyJqeOeEOqWF/tdP19cqQ+cBwd6Gqf9bFgqMmBpgRN3ikJy7EnjQo4AzfeMT7hA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fUx8Yn6L; arc=pass smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2ac37f8898eso68976eec.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 12:52:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767905575; cv=none;
        d=google.com; s=arc-20240605;
        b=RtBi9KAa8yvcgPdclGoJnzgFKELffp5OsjeQSnnCMSmw8CsOlE7B7diok/kO7XIUF5
         lTzsswesC7aQoI9qq2L9Op6JB5y4C8n2oyqD1OPyBk1nBr0FinaA8H9TDzDtlTUexx9d
         3ejAC1yHyMKZWt+wXrMPDkNaCqGwID53W7tuXqux1WTXTZKCHQ/O6WC4DWncgyJQ4Oqi
         uFe0K2qMxIe+6WpMRdyuCicfkEb/vR97Md/eEyn91czUIQktv4+7vbnBLTJDrHRMn45t
         CLb1BBCMqstDvfXe/45fbm2/jUZ/yz5rIpsMdaAZ6E0R1o5jIkBgoa+meo/Edo7+vRD4
         0emg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g8GqlkLlvHUVmRjsXcMtDIPMOMBQ9SjcvbbXZ2V3KBA=;
        fh=DKdydbBrNEEQnSErIG1BxDZyoFBtgwwu5Xuo89TlxMg=;
        b=U1S5hbu5CPUvSg1vmeIq9tLJh3XewAb0vs+tu1+jJDXH0+z6oR2RbrHfVaHWrmWQiD
         gdnSbfxHiombh7wjq8LIBkAhgOUvqd583VSFjSpmcBK7xHYfUzg4nEbxZhi1eDbsQBfy
         echKM9L9EsS/BrlQEmoGVGIrj9kxJW0WpbIVxXTk5wjMHR7XO/4V2X9JlqKlbog4NrWl
         bVa96Jpb9SgTSnja+HRF+ALnUw6yQcXM2zvJz7a9W5d8Vw8CVmJ8OjM/uVJzIHXceZbX
         NEEeqilxSVifQhNuG+Gmgg7pG79qE6FUfxhCgF8gDIcjOgjI715FZWZnmdExaEjA/0c4
         SROg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767905575; x=1768510375; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8GqlkLlvHUVmRjsXcMtDIPMOMBQ9SjcvbbXZ2V3KBA=;
        b=fUx8Yn6LFYxdnvkWnYmwwE3JMA9DyG3cASdINtD5+PS69zz+IAUY8tDTkGA0yHvo2o
         LZ4Y/F0Cuy5S7PtdJQsT7/qnMFNjv+aU6ww/PTxjmNnjrOJ/50RmP84+cqf34UHPjHTB
         BJ31AaJOQ4RpRAtwEXtKE8+o6J2WOPe/0OiONsRWL7GliDC4iaZ/qw/hVOry39Vbf8Wz
         EpOuC8K3XRyFNd36qo2BUFWS0gT4HAj+Q4ZE8azJLByjXOei+kFvfgItjmW6EpiMPUCO
         zmg5I8yW25o2zVu9eWGyxP8d+AupJAY7+LdQjfmr5jBSjSdN4/30EBRO1l2G0fRbwTtn
         1GKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767905575; x=1768510375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g8GqlkLlvHUVmRjsXcMtDIPMOMBQ9SjcvbbXZ2V3KBA=;
        b=XcjH3ZncSeMLejrNEdM4pBfe+xiT87brCaaLmsMYM0gFGR3S9v9strj7svbihcDnlN
         wWWhH51duhUVHCJGv3PwZ1a1KEAPBxAlKFSLyLGOzHGmr/otIp5gwOA0FISwfbcWMnkX
         dsjvxBsFotZb+vBHsBI66wNlDcqod2tGCe6WP2srAVi5oSGvmKYZ4acMNcdGmid0vQIr
         sbNoOy6LNhixoJ5lD1qQu6H3UM6oRYKlGH6lFfo7JzYzXuraArcnjd2zmNKn1Wdo/SF/
         ESJeZCrlLfChg+40NhcpAVEeg/DGJmHME8I/T1qsdYNpRazpQaq8iDVpRQWUYXZBl1By
         sGNg==
X-Forwarded-Encrypted: i=1; AJvYcCUlG65SYMhJFhlV0Qer2yMyrA8iVWiDSz4PQKu78YUyNEbgD/g+NVrcPqwGQVDJORJEplhK5QASdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyoXXSirlgDjGTcTP4s0GUmDvW4Z/fGdGYc3Ur0bgcWn4nTfBRp
	qpie5mzzv+qhshOFLsyoStHVaZKX9UlfeVeEEBQPwjYrG0V8ojTxebhjwqqiT2Dm/c5/BIAibyi
	es6fIDeGvoprWxmdQjOVyKYFk6ufRfEb7zJjK4ksXgw==
X-Gm-Gg: AY/fxX4pQ5aE52Su6OeWoh+RYerWoFQiJtuqnawaU+oIlcR4jk6nn6yao7npfTrZSVb
	Q9AeVtFBRUjIoN/eWlpBqtKdGTBzcWZ2zT+9hs9mV+R+ge3pIS245atJbnqBSO4rDX91A4oVN6C
	Ez+E31bMmFHUGMK11tB7iUaj3CFYyJnTqDU5rhttPQVA0NYay9jU6usVF273lINR2Vc0Kk5OvHV
	vJpHLn6loLccxIC8s0C0XUFq3wlxxoygi3KyDc9TuVW3wE2h158w/iony+dYYEhjUO1BZww42Io
	dolYZQ8=
X-Google-Smtp-Source: AGHT+IGK+ZmE1YLBKV7ow8K1sywiguKH3Hpwo7AJXoltexs+nMlRcQE4wJ1fceOIeG8/x/0kSx+jTH25rFOvSs0vPT8=
X-Received: by 2002:a05:7022:60a1:b0:119:e56a:4fff with SMTP id
 a92af1059eb24-121f8b45c34mr3468746c88.4.1767905575129; Thu, 08 Jan 2026
 12:52:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-21-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-21-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 12:52:43 -0800
X-Gm-Features: AQt7F2pVGt7fAlzfKnKbGjpxp8_qDeEj5xXdIGklstJzLgMu9CjYr6zw9d3aX2I
Message-ID: <CADUfDZqr9m8iDZpFehjXndLW75h=T5Su8d=CznpmOaQnKnm9nw@mail.gmail.com>
Subject: Re: [PATCH v3 20/25] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Currently, io_buffer_register_bvec() takes in a request. In preparation
> for supporting kernel-populated buffers in fuse io-uring (which will
> need to register bvecs directly, not through a struct request), rename
> this to io_buffer_register_request().
>
> A subsequent patch will commandeer the "io_buffer_register_bvec()"
> function name to support registering bvecs directly.
>
> Rename io_buffer_unregister_bvec() to a more generic name,
> io_buffer_unregister(), as both io_buffer_register_request() and
> io_buffer_register_bvec() callers will use it for unregistration.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> ---
>  Documentation/block/ublk.rst | 14 +++++++-------
>  drivers/block/ublk_drv.c     | 18 +++++++++---------
>  include/linux/io_uring/cmd.h | 26 ++++++++++++++++++++------
>  io_uring/rsrc.c              | 14 +++++++-------
>  4 files changed, 43 insertions(+), 29 deletions(-)
>
> diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
> index 8c4030bcabb6..aa6e0bf9405b 100644
> --- a/Documentation/block/ublk.rst
> +++ b/Documentation/block/ublk.rst
> @@ -326,17 +326,17 @@ Zero copy
>  ---------
>
>  ublk zero copy relies on io_uring's fixed kernel buffer, which provides
> -two APIs: `io_buffer_register_bvec()` and `io_buffer_unregister_bvec`.
> +two APIs: `io_buffer_register_request()` and `io_buffer_unregister`.
>
>  ublk adds IO command of `UBLK_IO_REGISTER_IO_BUF` to call
> -`io_buffer_register_bvec()` for ublk server to register client request
> +`io_buffer_register_request()` for ublk server to register client reques=
t
>  buffer into io_uring buffer table, then ublk server can submit io_uring
>  IOs with the registered buffer index. IO command of `UBLK_IO_UNREGISTER_=
IO_BUF`
> -calls `io_buffer_unregister_bvec()` to unregister the buffer, which is
> -guaranteed to be live between calling `io_buffer_register_bvec()` and
> -`io_buffer_unregister_bvec()`. Any io_uring operation which supports thi=
s
> -kind of kernel buffer will grab one reference of the buffer until the
> -operation is completed.
> +calls `io_buffer_unregister()` to unregister the buffer, which is guaran=
teed
> +to be live between calling `io_buffer_register_request()` and
> +`io_buffer_unregister()`. Any io_uring operation which supports this kin=
d of
> +kernel buffer will grab one reference of the buffer until the operation =
is
> +completed.
>
>  ublk server implementing zero copy or user copy has to be CAP_SYS_ADMIN =
and
>  be trusted, because it is ublk server's responsibility to make sure IO b=
uffer
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index df9831783a13..0a42f6a75b62 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -1202,8 +1202,8 @@ __ublk_do_auto_buf_reg(const struct ublk_queue *ubq=
, struct request *req,
>  {
>         int ret;
>
> -       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release,
> -                                     io->buf.auto_reg.index, issue_flags=
);
> +       ret =3D io_buffer_register_request(cmd, req, ublk_io_release,
> +                                        io->buf.auto_reg.index, issue_fl=
ags);
>         if (ret) {
>                 if (io->buf.auto_reg.flags & UBLK_AUTO_BUF_REG_FALLBACK) =
{
>                         ublk_auto_buf_reg_fallback(ubq, req->tag);
> @@ -2166,8 +2166,8 @@ static int ublk_register_io_buf(struct io_uring_cmd=
 *cmd,
>         if (!req)
>                 return -EINVAL;
>
> -       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
> -                                     issue_flags);
> +       ret =3D io_buffer_register_request(cmd, req, ublk_io_release, ind=
ex,
> +                                        issue_flags);
>         if (ret) {
>                 ublk_put_req_ref(io, req);
>                 return ret;
> @@ -2198,8 +2198,8 @@ ublk_daemon_register_io_buf(struct io_uring_cmd *cm=
d,
>         if (!ublk_dev_support_zero_copy(ub) || !ublk_rq_has_data(req))
>                 return -EINVAL;
>
> -       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
> -                                     issue_flags);
> +       ret =3D io_buffer_register_request(cmd, req, ublk_io_release, ind=
ex,
> +                                        issue_flags);
>         if (ret)
>                 return ret;
>
> @@ -2214,7 +2214,7 @@ static int ublk_unregister_io_buf(struct io_uring_c=
md *cmd,
>         if (!(ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY))
>                 return -EINVAL;
>
> -       return io_buffer_unregister_bvec(cmd, index, issue_flags);
> +       return io_buffer_unregister(cmd, index, issue_flags);
>  }
>
>  static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_=
addr)
> @@ -2350,7 +2350,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_=
cmd *cmd,
>                 goto out;
>
>         /*
> -        * io_buffer_unregister_bvec() doesn't access the ubq or io,
> +        * io_buffer_unregister() doesn't access the ubq or io,
>          * so no need to validate the q_id, tag, or task
>          */
>         if (_IOC_NR(cmd_op) =3D=3D UBLK_IO_UNREGISTER_IO_BUF)
> @@ -2420,7 +2420,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_=
cmd *cmd,
>
>                 /* can't touch 'ublk_io' any more */
>                 if (buf_idx !=3D UBLK_INVALID_BUF_IDX)
> -                       io_buffer_unregister_bvec(cmd, buf_idx, issue_fla=
gs);
> +                       io_buffer_unregister(cmd, buf_idx, issue_flags);
>                 if (req_op(req) =3D=3D REQ_OP_ZONE_APPEND)
>                         req->__sector =3D addr;
>                 if (compl)
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 61c4ca863ef6..06e4cfadb344 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -102,6 +102,12 @@ int io_uring_cmd_kmbuffer_recycle(struct io_uring_cm=
d *cmd,
>
>  int io_uring_cmd_is_kmbuf_ring(struct io_uring_cmd *ioucmd,
>                                unsigned int buf_group, unsigned int issue=
_flags);
> +
> +int io_buffer_register_request(struct io_uring_cmd *cmd, struct request =
*rq,
> +                              void (*release)(void *), unsigned int inde=
x,
> +                              unsigned int issue_flags);
> +int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
> +                        unsigned int issue_flags);
>  #else
>  static inline int
>  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> @@ -185,6 +191,20 @@ static inline int io_uring_cmd_is_kmbuf_ring(struct =
io_uring_cmd *ioucmd,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int io_buffer_register_request(struct io_uring_cmd *cmd,
> +                                            struct request *rq,
> +                                            void (*release)(void *),
> +                                            unsigned int index,
> +                                            unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
> +static inline int io_buffer_unregister(struct io_uring_cmd *cmd,
> +                                      unsigned int index,
> +                                      unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
>  #endif
>
>  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_req=
 tw_req)
> @@ -234,10 +254,4 @@ static inline void io_uring_cmd_done32(struct io_uri=
ng_cmd *ioucmd, s32 ret,
>         return __io_uring_cmd_done(ioucmd, ret, res2, issue_flags, true);
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
> -                           void (*release)(void *), unsigned int index,
> -                           unsigned int issue_flags);
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int ind=
ex,
> -                             unsigned int issue_flags);
> -
>  #endif /* _LINUX_IO_URING_CMD_H */
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a141aaeb099d..b25b418e5c11 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -936,9 +936,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
>         return ret;
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
> -                           void (*release)(void *), unsigned int index,
> -                           unsigned int issue_flags)
> +int io_buffer_register_request(struct io_uring_cmd *cmd, struct request =
*rq,
> +                              void (*release)(void *), unsigned int inde=
x,
> +                              unsigned int issue_flags)
>  {
>         struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
> @@ -998,10 +998,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
d, struct request *rq,
>         io_ring_submit_unlock(ctx, issue_flags);
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +EXPORT_SYMBOL_GPL(io_buffer_register_request);
>
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int ind=
ex,
> -                             unsigned int issue_flags)
> +int io_buffer_unregister(struct io_uring_cmd *cmd, unsigned int index,
> +                        unsigned int issue_flags)
>  {
>         struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
> @@ -1031,7 +1031,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *=
cmd, unsigned int index,
>         io_ring_submit_unlock(ctx, issue_flags);
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
> +EXPORT_SYMBOL_GPL(io_buffer_unregister);
>
>  static int validate_fixed_range(u64 buf_addr, size_t len,
>                                 const struct io_mapped_ubuf *imu)
> --
> 2.47.3
>

