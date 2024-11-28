Return-Path: <io-uring+bounces-5108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 241999DB044
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 01:28:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0FC6166EF8
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 00:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9BC8F64;
	Thu, 28 Nov 2024 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XDBBf+S1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2B84C7C;
	Thu, 28 Nov 2024 00:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732753692; cv=none; b=UqUXVJ9337dr3FJoKn9E5BlcVeZrRCdeR+deITVp+O92EbFIMCGCHVi1cmF0QRtXPpU2TbNZf7ISlPKS4oNdEupGsWHGHv8VTDE8iXMtf+9EvVQJaDAHkhvJm1iqZE0du2ImIVAZc473gnBtQmNsrJ7+YEfKMfXgJNCJFy5xE/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732753692; c=relaxed/simple;
	bh=x0eMG4LIXHerbne+qG5Jm24cUuGZEFHowSaMcmqOYHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gB0OL0w8ubdW4ZhE4RHA7BeGp9/Ek4+1Gji3Q8tViw54WhAewZAykjRRSWVry0X/ay3biTngz/DfOYUWEJw5MImuCxrPIlkmQAcw3JTUY3RFI6EkNin6Aa9+rCL4DW4hsS34Bh3FH8qQWDcTOgfZFfbNqnUcc2bnuOYjx53khb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XDBBf+S1; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-466966d8dbaso2203851cf.3;
        Wed, 27 Nov 2024 16:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732753690; x=1733358490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u1SEnNsPvfBOThstASbR2S7tQu/PChLrhatOJdvDYJk=;
        b=XDBBf+S1EU6RMVQkOZwqv+NPR4sjL2k0eE2YmiDjizDXPCKsLow9sd+V1xRYzeM1wE
         kXCC6wHX6576xwXP+isKtl2bq0Wwnkk95WLvq8zfPT+nc6MuPCKFb3W4i0yizLP61jcN
         3HNdgC37VqfiZOQkD+mpUcSW3PRb71nFWTb31JakMDUVJXdCqvmslXc/pCMI9lQfvsEj
         vYxkhEiNQxp6GtaoFydto9w5nXge+2eMk49aN1UINOqntcgr9SW8+0cCl8yJT8Kdcy1m
         v94R0e/ppPjwjry3qVSDe+sCDdRjmGp78It9EuLbsn0yxt5VCAefOWrAdV7t+FDUaiqU
         BXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732753690; x=1733358490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1SEnNsPvfBOThstASbR2S7tQu/PChLrhatOJdvDYJk=;
        b=CH6gET8NKkbkM509DPVxpEOO7U3JgCyYoqlnCRDn96UuepQYnlnfMm9oR5oD+HhSDL
         4uXmX1zXrLU8uuprZrI9uxkPV/PUWODCrGqXtOsVUOo81Oba8CfleetRg18qdlVe0Nl9
         MnZzaVV5dvaK1lBl1f5ra9nBdDuz8d2PbCtWYm8pgkKrE+fvur5C2xpfO0mRpwcO4D9r
         wECgJZnuHkdEAIIN1yMtIibUhcg/9osKVtMX56dMpmxJTlGkS6UbiF1+QXQZAMGMvHax
         ZzBJig8hXy9upSJWWHOw23+qhOmI/+hrEhVqNv8DO8JNfo5c0wKU+MQf68Nmo28Xi2l1
         oz1A==
X-Forwarded-Encrypted: i=1; AJvYcCUAWdy6S4zPpQ/TUc+U+WkCd/MEN7b2s1O0TILzZugGZZBbWdh2Hihjtrhzh0z2u0yUlB0Md/KHpQ==@vger.kernel.org, AJvYcCV1CUtHqhkTFSUJRtnGqU8aqJr41Xa73Sd5/J/1m7ruc+AKvUkiROtmS5S/kcK6vKh4Yu4G1yqguGPsojxkpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCopl2Nj1M+b+06BLMXqxkohOs0+6Um92rOONBBA4Ew6nrZ+HA
	wCtBbKCYizBPOa/T4nGLR1FiJTxEOuE4z9vmy07VkZaTWxEdomkDfotW2I3Wafzl4n4C2i397FF
	Eec3sm1x5eCyDHlvyH2mhbz31vdU=
X-Gm-Gg: ASbGnctWWPww9bzTzHcxzOO8Yg9gO4UFu19gEfxKnIJs9E5LF8Ze3Dq50nq8tne+LMG
	b1DmNbGQOCOs7kq7RkVhEMVyZ1Zij2Cnu3iKG6QDbdasaebo=
X-Google-Smtp-Source: AGHT+IFnxz1cXNNku9o8DhaIhBXtSFbV1HSGmlOGhBPe4fCWjKIP8gZfK+KySJy+PIY81QvL0UilTkMdSe3lKrLjXy4=
X-Received: by 2002:a05:622a:1985:b0:466:a254:733b with SMTP id
 d75a77b69052e-466b3508f8dmr77843691cf.13.1732753689556; Wed, 27 Nov 2024
 16:28:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com> <20241127-fuse-uring-for-6-10-rfc4-v7-5-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-5-934b3a69baca@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Nov 2024 16:27:58 -0800
Message-ID: <CAJnrk1Y0sehm4G9Lku+TrWkP-LB83Xs6ZW=5M5iL=Lw9hgwLdA@mail.gmail.com>
Subject: Re: [PATCH RFC v7 05/16] fuse: make args->in_args[0] to be always the header
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 5:41=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> This change sets up FUSE operations to have headers in args.in_args[0],
> even for opcodes without an actual header. We do this to prepare for
> cleanly separating payload from headers in the future.
>
> For opcodes without a header, we use a zero-sized struct as a
> placeholder. This approach:
> - Keeps things consistent across all FUSE operations
> - Will help with payload alignment later
> - Avoids future issues when header sizes change
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

This LGTM. It might be worth mentioning in the commit message that
this won't add zero-sized arg headers to request types that don't take
in any in args.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dax.c    | 11 ++++++-----
>  fs/fuse/dev.c    |  9 +++++----
>  fs/fuse/dir.c    | 32 ++++++++++++++++++--------------
>  fs/fuse/fuse_i.h | 13 +++++++++++++
>  fs/fuse/xattr.c  |  7 ++++---
>  5 files changed, 46 insertions(+), 26 deletions(-)
>
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..44bd30d448e4e8c1d8c6b0499=
e50564fa0828efc 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -240,11 +240,12 @@ static int fuse_send_removemapping(struct inode *in=
ode,
>
>         args.opcode =3D FUSE_REMOVEMAPPING;
>         args.nodeid =3D fi->nodeid;
> -       args.in_numargs =3D 2;
> -       args.in_args[0].size =3D sizeof(*inargp);
> -       args.in_args[0].value =3D inargp;
> -       args.in_args[1].size =3D inargp->count * sizeof(*remove_one);
> -       args.in_args[1].value =3D remove_one;
> +       args.in_numargs =3D 3;
> +       fuse_set_zero_arg0(&args);
> +       args.in_args[1].size =3D sizeof(*inargp);
> +       args.in_args[1].value =3D inargp;
> +       args.in_args[2].size =3D inargp->count * sizeof(*remove_one);
> +       args.in_args[2].value =3D remove_one;
>         return fuse_simple_request(fm, &args);
>  }
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index fd8898b0c1cca4d117982d5208d78078472b0dfb..63c3865aebb7811fdf4a5729b=
2181ee8321421dc 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1735,7 +1735,7 @@ static int fuse_retrieve(struct fuse_mount *fm, str=
uct inode *inode,
>         args =3D &ap->args;
>         args->nodeid =3D outarg->nodeid;
>         args->opcode =3D FUSE_NOTIFY_REPLY;
> -       args->in_numargs =3D 2;
> +       args->in_numargs =3D 3;
>         args->in_pages =3D true;
>         args->end =3D fuse_retrieve_end;
>
> @@ -1762,9 +1762,10 @@ static int fuse_retrieve(struct fuse_mount *fm, st=
ruct inode *inode,
>         }
>         ra->inarg.offset =3D outarg->offset;
>         ra->inarg.size =3D total_len;
> -       args->in_args[0].size =3D sizeof(ra->inarg);
> -       args->in_args[0].value =3D &ra->inarg;
> -       args->in_args[1].size =3D total_len;
> +       fuse_set_zero_arg0(args);
> +       args->in_args[1].size =3D sizeof(ra->inarg);
> +       args->in_args[1].value =3D &ra->inarg;
> +       args->in_args[2].size =3D total_len;
>
>         err =3D fuse_simple_notify_reply(fm, args, outarg->notify_unique)=
;
>         if (err)
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 54104dd48af7c94b312f1a8671c8905542d456c4..ccb240d4262f9399c9c90434a=
aeaf76b50f223ad 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -175,9 +175,10 @@ static void fuse_lookup_init(struct fuse_conn *fc, s=
truct fuse_args *args,
>         memset(outarg, 0, sizeof(struct fuse_entry_out));
>         args->opcode =3D FUSE_LOOKUP;
>         args->nodeid =3D nodeid;
> -       args->in_numargs =3D 1;
> -       args->in_args[0].size =3D name->len + 1;
> -       args->in_args[0].value =3D name->name;
> +       args->in_numargs =3D 2;
> +       fuse_set_zero_arg0(args);
> +       args->in_args[1].size =3D name->len + 1;
> +       args->in_args[1].value =3D name->name;
>         args->out_numargs =3D 1;
>         args->out_args[0].size =3D sizeof(struct fuse_entry_out);
>         args->out_args[0].value =3D outarg;
> @@ -927,11 +928,12 @@ static int fuse_symlink(struct mnt_idmap *idmap, st=
ruct inode *dir,
>         FUSE_ARGS(args);
>
>         args.opcode =3D FUSE_SYMLINK;
> -       args.in_numargs =3D 2;
> -       args.in_args[0].size =3D entry->d_name.len + 1;
> -       args.in_args[0].value =3D entry->d_name.name;
> -       args.in_args[1].size =3D len;
> -       args.in_args[1].value =3D link;
> +       args.in_numargs =3D 3;
> +       fuse_set_zero_arg0(&args);
> +       args.in_args[1].size =3D entry->d_name.len + 1;
> +       args.in_args[1].value =3D entry->d_name.name;
> +       args.in_args[2].size =3D len;
> +       args.in_args[2].value =3D link;
>         return create_new_entry(idmap, fm, &args, dir, entry, S_IFLNK);
>  }
>
> @@ -991,9 +993,10 @@ static int fuse_unlink(struct inode *dir, struct den=
try *entry)
>
>         args.opcode =3D FUSE_UNLINK;
>         args.nodeid =3D get_node_id(dir);
> -       args.in_numargs =3D 1;
> -       args.in_args[0].size =3D entry->d_name.len + 1;
> -       args.in_args[0].value =3D entry->d_name.name;
> +       args.in_numargs =3D 2;
> +       fuse_set_zero_arg0(&args);
> +       args.in_args[1].size =3D entry->d_name.len + 1;
> +       args.in_args[1].value =3D entry->d_name.name;
>         err =3D fuse_simple_request(fm, &args);
>         if (!err) {
>                 fuse_dir_changed(dir);
> @@ -1014,9 +1017,10 @@ static int fuse_rmdir(struct inode *dir, struct de=
ntry *entry)
>
>         args.opcode =3D FUSE_RMDIR;
>         args.nodeid =3D get_node_id(dir);
> -       args.in_numargs =3D 1;
> -       args.in_args[0].size =3D entry->d_name.len + 1;
> -       args.in_args[0].value =3D entry->d_name.name;
> +       args.in_numargs =3D 2;
> +       fuse_set_zero_arg0(&args);
> +       args.in_args[1].size =3D entry->d_name.len + 1;
> +       args.in_args[1].value =3D entry->d_name.name;
>         err =3D fuse_simple_request(fm, &args);
>         if (!err) {
>                 fuse_dir_changed(dir);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e6cc3d552b1382fc43bfe5191efc46e956ca268c..e3748751e231d0991c050b31b=
dd84db0b8016f9f 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -938,6 +938,19 @@ struct fuse_mount {
>         struct rcu_head rcu;
>  };
>
> +/*
> + * Empty header for FUSE opcodes without specific header needs.
> + * Used as a placeholder in args->in_args[0] for consistency
> + * across all FUSE operations, simplifying request handling.
> + */
> +struct fuse_zero_header {};
> +
> +static inline void fuse_set_zero_arg0(struct fuse_args *args)
> +{
> +       args->in_args[0].size =3D sizeof(struct fuse_zero_header);
> +       args->in_args[0].value =3D NULL;
> +}
> +
>  static inline struct fuse_mount *get_fuse_mount_super(struct super_block=
 *sb)
>  {
>         return sb->s_fs_info;
> diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
> index 9f568d345c51236ddd421b162820a4ea9b0734f4..93dfb06b6cea045d6df90c61c=
900680968bda39f 100644
> --- a/fs/fuse/xattr.c
> +++ b/fs/fuse/xattr.c
> @@ -164,9 +164,10 @@ int fuse_removexattr(struct inode *inode, const char=
 *name)
>
>         args.opcode =3D FUSE_REMOVEXATTR;
>         args.nodeid =3D get_node_id(inode);
> -       args.in_numargs =3D 1;
> -       args.in_args[0].size =3D strlen(name) + 1;
> -       args.in_args[0].value =3D name;
> +       args.in_numargs =3D 2;
> +       fuse_set_zero_arg0(&args);
> +       args.in_args[1].size =3D strlen(name) + 1;
> +       args.in_args[1].value =3D name;
>         err =3D fuse_simple_request(fm, &args);
>         if (err =3D=3D -ENOSYS) {
>                 fm->fc->no_removexattr =3D 1;
>
> --
> 2.43.0
>

