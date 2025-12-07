Return-Path: <io-uring+bounces-10985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB242CAB2C1
	for <lists+io-uring@lfdr.de>; Sun, 07 Dec 2025 09:33:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5BCA0305F332
	for <lists+io-uring@lfdr.de>; Sun,  7 Dec 2025 08:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8202586C8;
	Sun,  7 Dec 2025 08:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HZpBVIgR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BD424EF8C
	for <io-uring@vger.kernel.org>; Sun,  7 Dec 2025 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765096401; cv=none; b=n2uGn4moFQnmz6lwGiTacWel5fQ7lfHYe9ezhPywhiOoixHP8BTarQ7ihPUTWzbz+Ej6zB4a2hUTqQ60zLhfRLmfzUQiN0SPhECfQEzrs+F3h4JtC61+Xnl/GVAi2FBtkjROFWpX3q47Q7Nst2YBZbm2NpIsDhGVUkKmY2RWluo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765096401; c=relaxed/simple;
	bh=gOzNzgXpRTSLdKSBDidNVXiIUCbeT+qiE0MWs3tTRfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLXKgZOTffPgLSDsl2TkXi3Rb3Q03U1ML4UihdMF2tKwqY7n2CjXI74vh+l696DLz1lmeFVFYwNyaYO05DNophRUIpgc2DNwO9QXyW2bmPZAlPGm1VqF99bIbFVfiWFvMz9hL/RQibZDhz6nuFFlZFENJK/odAhJLZ80ncfLTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HZpBVIgR; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3436b2dbfb9so554955a91.0
        for <io-uring@vger.kernel.org>; Sun, 07 Dec 2025 00:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765096399; x=1765701199; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frrtB4aAb7NsShg++hYbQm0IHS3+62tzOY/Lj8ulfr4=;
        b=HZpBVIgRScVuvoo7CQoX8UGP/1z82a/TW+4U44IrqVH5ZHK03QPkTqCSdhT7HgDGz3
         LRe+a/zeZ8xnBlfhoCBwC7UBuf5P1QFSAE6byIeT9EoDHxJIcUX3TuwQG7xMAd01T+nb
         WDDyaJ43bS63NF5ct2hXvvgGAo6whDylh3oj0RBqz+G7V4rJgySokCKRKXb7mSbc1Aa3
         WOQ+51hUbtkMU+F0Oon9yCgE5/58jUL4MP+k9RVFV5DszFVwH5sAd0d1Z5Faq6+iVthC
         /z9ed/JafJOUuSlmNrbctODHJoqPQEdlad5K7X0XM8v5lMgAU1tDBLAhDuyBtnmIALWG
         Q1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765096399; x=1765701199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=frrtB4aAb7NsShg++hYbQm0IHS3+62tzOY/Lj8ulfr4=;
        b=LqAFCv4R3lTqb7ql0Y4EZ0SFU6Wz9CPMFNK5g/x/2AvtX6/2y2GSdj6/5ZnKG4Hs5/
         9I8kv5n2dqDTN6RhQVvREOpootzZDuoM18gSfDOUgUYq0XNWho8KqxJgYZ5ng6Pyujy5
         oKTj8lc0bonTcc1PiKXKXq6QEa73SM5MHJ3PftdVzD6N0sz3BMHhPYZ54M9krv3PvuyH
         GT96SirqLkenGNcttR77a1xNCpAG1sleSolFe4AMxeYxyaMTyx4hsR5GMiNPmYxjvlVY
         Zl7Yj8yWPlpfQ6z82g6MpmdQsSivsJX50vehqyUfubMj3tIgXfA6KMGa86XXLhp2ls9K
         MvBQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS1vvgVfmPU7wlWrG8ZKgaNQfwZ3PeDd/laEweTtlsYYrdZ9ADc0vS4qV28tpTtbMukADfw+Jutg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxywLWhXSJ4lf/t+YWUnz50VSq4Z8KqezMGDt85zK0EA++po1uA
	0FkKE/z9d5wM5+9kF+m8UH9LDWHeTt3fIifH8pZChxqNisXlbl31JgzR4Y9mb6WqyKqQl6yhqx6
	HQ+4TkhuTpqQE4/sXKG1n5/6Y1hyIG1p00gjWblKooXAPrhLIt4QfBEk=
X-Gm-Gg: ASbGncuEEQ4fGGbP5epYZ3ii6w4nmTLOiEI8NQTtW7DgYp4gjT0J50kJXKX8q1wGppz
	m2ZnnrISSUjPdSGgbsD7EIfG4cK6ETh5RFqGGPAPnAWCxVq2kdW0mkuZNZFFToQnRaQYlpN3SuP
	pfqXUOppuKKWDEsjsvAoj6lhltG/kCQblPoup5/43vmGDoZ77y1v9EDuwMGeOY27tncjaIrAIX9
	WBYpZ8QKckgEVq3hFpbN11t7OohHaQKFtA1R1ll5rZR9QySDVS/YZOwQkSJ89Gi9S855rks
X-Google-Smtp-Source: AGHT+IHsaQZEE2CSOfYk3wTRc0UH4MN1vjMMncEKesFnLiaWCCy9aB3sjAxcnWJCMPLu6rbSGzQwZdpYjPnY+7zTXkc=
X-Received: by 2002:a05:7022:6624:b0:119:e55a:95a0 with SMTP id
 a92af1059eb24-11e0326c0bdmr2132371c88.2.1765096398680; Sun, 07 Dec 2025
 00:33:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com> <20251203003526.2889477-23-joannelkoong@gmail.com>
In-Reply-To: <20251203003526.2889477-23-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 7 Dec 2025 00:33:07 -0800
X-Gm-Features: AQt7F2qDn8yX6VwGKjZ5m7Y1OFJcgshRl5DLIIJ4JqieP8mvptUQOBYa3TBR0Hw
Message-ID: <CADUfDZp3NCnJ7-dAmFo2VbApez9ni+zR7Z-iGsudDrTN4qw1Xg@mail.gmail.com>
Subject: Re: [PATCH v1 22/30] io_uring/rsrc: refactor io_buffer_register_bvec()/io_buffer_unregister_bvec()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Changes:
> - Rename io_buffer_register_bvec() to io_buffer_register_request()
> - Rename io_buffer_unregister_bvec() to io_buffer_unregister()
> - Add cmd wrappers for io_buffer_register_request() and
>   io_buffer_unregister() for ublk to use

I agree these names seem clearer.

>
> This is in preparation for supporting kernel-populated buffers in fuse
> io-uring, which will need to register bvecs directly (not through a
> block-based request) and will need to do unregistration through an
> io_ring_ctx directly.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  Documentation/block/ublk.rst | 15 ++++++++-------
>  drivers/block/ublk_drv.c     | 20 +++++++++++---------
>  include/linux/io_uring/cmd.h | 13 ++++++++-----
>  io_uring/rsrc.c              | 14 +++++---------
>  io_uring/rsrc.h              |  7 +++++++
>  io_uring/uring_cmd.c         | 21 +++++++++++++++++++++
>  6 files changed, 60 insertions(+), 30 deletions(-)
>
> diff --git a/Documentation/block/ublk.rst b/Documentation/block/ublk.rst
> index 8c4030bcabb6..1546477e768b 100644
> --- a/Documentation/block/ublk.rst
> +++ b/Documentation/block/ublk.rst
> @@ -326,16 +326,17 @@ Zero copy
>  ---------
>
>  ublk zero copy relies on io_uring's fixed kernel buffer, which provides
> -two APIs: `io_buffer_register_bvec()` and `io_buffer_unregister_bvec`.
> +two APIs: `io_uring_cmd_buffer_register_request()` and
> +`io_uring_cmd_buffer_unregister`.
>
>  ublk adds IO command of `UBLK_IO_REGISTER_IO_BUF` to call
> -`io_buffer_register_bvec()` for ublk server to register client request
> -buffer into io_uring buffer table, then ublk server can submit io_uring
> +`io_uring_cmd_buffer_register_request()` for ublk server to register cli=
ent
> +request buffer into io_uring buffer table, then ublk server can submit i=
o_uring
>  IOs with the registered buffer index. IO command of `UBLK_IO_UNREGISTER_=
IO_BUF`
> -calls `io_buffer_unregister_bvec()` to unregister the buffer, which is
> -guaranteed to be live between calling `io_buffer_register_bvec()` and
> -`io_buffer_unregister_bvec()`. Any io_uring operation which supports thi=
s
> -kind of kernel buffer will grab one reference of the buffer until the
> +calls `io_uring_cmd_buffer_unregister()` to unregister the buffer, which=
 is
> +guaranteed to be live between calling `io_uring_cmd_buffer_register_requ=
est()`
> +and `io_uring_cmd_buffer_unregister()`. Any io_uring operation which sup=
ports
> +this kind of kernel buffer will grab one reference of the buffer until t=
he
>  operation is completed.
>
>  ublk server implementing zero copy or user copy has to be CAP_SYS_ADMIN =
and
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index e0c601128efa..d671d08533c9 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -1246,8 +1246,9 @@ static bool ublk_auto_buf_reg(const struct ublk_que=
ue *ubq, struct request *req,
>  {
>         int ret;
>
> -       ret =3D io_buffer_register_bvec(io->cmd, req, ublk_io_release,
> -                                     io->buf.index, issue_flags);
> +       ret =3D io_uring_cmd_buffer_register_request(io->cmd, req,
> +                                                  ublk_io_release,
> +                                                  io->buf.index, issue_f=
lags);
>         if (ret) {
>                 if (io->buf.flags & UBLK_AUTO_BUF_REG_FALLBACK) {
>                         ublk_auto_buf_reg_fallback(ubq, io);
> @@ -2204,8 +2205,8 @@ static int ublk_register_io_buf(struct io_uring_cmd=
 *cmd,
>         if (!req)
>                 return -EINVAL;
>
> -       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
> -                                     issue_flags);
> +       ret =3D io_uring_cmd_buffer_register_request(cmd, req, ublk_io_re=
lease,
> +                                                  index, issue_flags);
>         if (ret) {
>                 ublk_put_req_ref(io, req);
>                 return ret;
> @@ -2236,8 +2237,8 @@ ublk_daemon_register_io_buf(struct io_uring_cmd *cm=
d,
>         if (!ublk_dev_support_zero_copy(ub) || !ublk_rq_has_data(req))
>                 return -EINVAL;
>
> -       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
> -                                     issue_flags);
> +       ret =3D io_uring_cmd_buffer_register_request(cmd, req, ublk_io_re=
lease,
> +                                                  index, issue_flags);
>         if (ret)
>                 return ret;
>
> @@ -2252,7 +2253,7 @@ static int ublk_unregister_io_buf(struct io_uring_c=
md *cmd,
>         if (!(ub->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY))
>                 return -EINVAL;
>
> -       return io_buffer_unregister_bvec(cmd, index, issue_flags);
> +       return io_uring_cmd_buffer_unregister(cmd, index, issue_flags);
>  }
>
>  static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_=
addr)
> @@ -2386,7 +2387,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_=
cmd *cmd,
>                 goto out;
>
>         /*
> -        * io_buffer_unregister_bvec() doesn't access the ubq or io,
> +        * io_uring_cmd_buffer_unregister() doesn't access the ubq or io,
>          * so no need to validate the q_id, tag, or task
>          */
>         if (_IOC_NR(cmd_op) =3D=3D UBLK_IO_UNREGISTER_IO_BUF)
> @@ -2456,7 +2457,8 @@ static int ublk_ch_uring_cmd_local(struct io_uring_=
cmd *cmd,
>
>                 /* can't touch 'ublk_io' any more */
>                 if (buf_idx !=3D UBLK_INVALID_BUF_IDX)
> -                       io_buffer_unregister_bvec(cmd, buf_idx, issue_fla=
gs);
> +                       io_uring_cmd_buffer_unregister(cmd, buf_idx,
> +                                                      issue_flags);
>                 if (req_op(req) =3D=3D REQ_OP_ZONE_APPEND)
>                         req->__sector =3D addr;
>                 if (compl)
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 795b846d1e11..fc956f8f7ed2 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -185,10 +185,13 @@ static inline void io_uring_cmd_done32(struct io_ur=
ing_cmd *ioucmd, s32 ret,
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
> +int io_uring_cmd_buffer_register_request(struct io_uring_cmd *cmd,
> +                                        struct request *rq,
> +                                        void (*release)(void *),
> +                                        unsigned int index,
> +                                        unsigned int issue_flags);
> +
> +int io_uring_cmd_buffer_unregister(struct io_uring_cmd *cmd, unsigned in=
t index,
> +                                  unsigned int issue_flags);
>
>  #endif /* _LINUX_IO_URING_CMD_H */
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index b6dd62118311..59cafe63d187 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -941,11 +941,10 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
>         return ret;
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
> -                           void (*release)(void *), unsigned int index,
> -                           unsigned int issue_flags)
> +int io_buffer_register_request(struct io_ring_ctx *ctx, struct request *=
rq,
> +                              void (*release)(void *), unsigned int inde=
x,
> +                              unsigned int issue_flags)
>  {
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
>         struct req_iterator rq_iter;
>         struct io_mapped_ubuf *imu;
> @@ -1003,12 +1002,10 @@ int io_buffer_register_bvec(struct io_uring_cmd *=
cmd, struct request *rq,
>         io_ring_submit_unlock(ctx, issue_flags);
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
>
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int ind=
ex,
> -                             unsigned int issue_flags)
> +int io_buffer_unregister(struct io_ring_ctx *ctx, unsigned int index,
> +                        unsigned int issue_flags)
>  {
> -       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
>         struct io_rsrc_node *node;
>         int ret =3D 0;
> @@ -1036,7 +1033,6 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *=
cmd, unsigned int index,
>         io_ring_submit_unlock(ctx, issue_flags);
>         return ret;
>  }
> -EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
>
>  static int validate_fixed_range(u64 buf_addr, size_t len,
>                                 const struct io_mapped_ubuf *imu)
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 658934f4d3ff..d1ca33f3319a 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -91,6 +91,13 @@ int io_validate_user_buf_range(u64 uaddr, u64 ulen);
>  bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>                               struct io_imu_folio_data *data);
>
> +int io_buffer_register_request(struct io_ring_ctx *ctx, struct request *=
rq,
> +                              void (*release)(void *), unsigned int inde=
x,
> +                              unsigned int issue_flags);
> +
> +int io_buffer_unregister(struct io_ring_ctx *ctx, unsigned int index,
> +                        unsigned int issue_flags);
> +
>  static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_da=
ta *data,
>                                                        int index)
>  {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 3eb10bbba177..3922ac86b481 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -383,6 +383,27 @@ struct io_br_sel io_uring_cmd_buffer_select(struct i=
o_uring_cmd *ioucmd,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_select);
>
> +int io_uring_cmd_buffer_register_request(struct io_uring_cmd *cmd,
> +                                        struct request *rq,
> +                                        void (*release)(void *),
> +                                        unsigned int index,
> +                                        unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +
> +       return io_buffer_register_request(ctx, rq, release, index, issue_=
flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_register_request);
> +
> +int io_uring_cmd_buffer_unregister(struct io_uring_cmd *cmd, unsigned in=
t index,
> +                                  unsigned int issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +
> +       return io_buffer_unregister(ctx, index, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_buffer_unregister);

It would be nice to avoid these additional function calls that can't
be inlined. I guess we probably don't want to include the
io_uring-internal header io_uring/rsrc.h in the external header
linux/io_uring/cmd.h, which is probably why the functions were
declared in linux/io_uring/cmd.h but defined in io_uring/rsrc.c
previously. Maybe it would make sense to move the definitions of
io_uring_cmd_buffer_register_request() and
io_uring_cmd_buffer_unregister() to io_uring/rsrc.c so
io_buffer_register_request()/io_buffer_unregister() can be inlined
into them?

Best,
Caleb

> +
>  /*
>   * Return true if this multishot uring_cmd needs to be completed, otherw=
ise
>   * the event CQE is posted successfully.
> --
> 2.47.3
>

