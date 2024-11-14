Return-Path: <io-uring+bounces-4706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5232E9C9396
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 21:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D77631F21EA7
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 20:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A9F1AC88A;
	Thu, 14 Nov 2024 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUFGZbOE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B11AC8AE;
	Thu, 14 Nov 2024 20:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731617851; cv=none; b=OEYg1wFr+rMjQk8sk5fvibFnRTqdTtIQPReMMvzhzpwO92EU4Ug6vKu3CSrBIaYw61+7Z3w5Ebhie2KtxkpqENMWUx43wIiyjsLr306Zv/dpbC7iCgfP/K7DycGPvClRvDyRMvvKKDhJapfMkkYKASGcZofZaYzKL7swa83CDIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731617851; c=relaxed/simple;
	bh=p9bMC0p879YFghN5onXOQilzALa9Shb4ihrW0IWC29w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=slfPJJhNS+ob4Po19+YqrOFT6H+YnHHIqAgbCw/j1Whq4pbjl7VRZvpHeakP5eEmeFV8iTrNI6fgOJy1QYrjY6sRv6nnImI5dflKGNBdQLQO77iAzT+PF/QM70vrsAs5d2WI5bjhO0vcgRHFJcsj9Sc6obxRk45f+w97pXJKT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUFGZbOE; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5ebc52deca0so584219eaf.3;
        Thu, 14 Nov 2024 12:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731617846; x=1732222646; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQHS0lf+qFkOml/kvNgt0EsL4ScfqO00EyLbahcUwpo=;
        b=nUFGZbOEQLQ/srnsnDX18B/OnMxYmUhb3Yt1q830d1wumJD28aqYKlSxBG3WbcYzHt
         FpvLQNBqKSF9n8VYqUQCyczXCfxsas66sBSB07a9tpbGjd78QxxnCY3Wqewj3uw3e307
         q8GrsXa/4LJd4eNnD4Md/VuAEyg9emTbzC4TKx5dvDBvEPVPi4qizrR8SmANA0klKdlG
         HaMVannR7TnPNE+++WwflkBb6IUM2a0CrnP3pQdH2ynVRl/APr4QhdglgfPw6Tludubw
         cnoey0dxAiSBG5um0BsFnKSjLxuGZ2anavsNuHEBYOPSw0az0ouGP+NI/GVbS8joZo5d
         beDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731617846; x=1732222646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IQHS0lf+qFkOml/kvNgt0EsL4ScfqO00EyLbahcUwpo=;
        b=Kf+Mfv8H8T/NGLtfQcK+tn440sU2Q+2/GB1l7QJ4vIkVLtaPxZAQqe5JZweZxOhSiM
         Aw7NDijBYG10YpxZI10T2Eu2dlB2FsdTidGHfHaAbrq7OkHH1dDuwsP4PsIpq71Xb7QZ
         nBeJwn1iQ2h2xbDXGgke3vva3fXXNMH8EyxBtt4un1XtlmD4cEYfSlZAJN513QBmt5mg
         SSCiX5HXiijDNQbeZBouHCzPgtlCyTWj1Sxo6luml/Jf5zmmboxmJa2B2XYlsXJdWfBe
         5ZbEWKASUe6S5ewE036UkqD9PNnY4G8vO0wIg9INiDcydj+SBOm8mhOeaTXhvPGplcJk
         dIKg==
X-Forwarded-Encrypted: i=1; AJvYcCWXBWuK9g667cCmty/PBsjNqbqO9h7CFZoy4TG1NPDYvgzG/Zk7dmzGukvKsuDZyaaWn7rgsF/AiSty5/D6sA==@vger.kernel.org, AJvYcCWjqa8ptCOnXvG78uplY18Z3/xpDs721Dqk3j0RxWdbwMvwJPwUW6pGdEJ2Phlvs+G+wo1FMPHNaQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv9TiaIT73HvltA++0R3+u8NdqtNLYXOaSQcRGe//BqADNw78m
	uSVYzwy6Phkf6mjP/cf2yiEYARAvHQnnCgCYv0ZDmWuVHXkGDYQjA8Q7ItFz3wHt7vaaVVsDi0n
	HebqCmhLakzAwscUzx3yoleLrY9k=
X-Google-Smtp-Source: AGHT+IGQ27Ajan4hXiAN0CLsLpdmtFiOPa39yBLAFgoe/d0IQ3N5p86MDMFAYox2GMNXEcDvVNcOQ4Aqd8ZMBPsEs+A=
X-Received: by 2002:a05:6358:e9c4:b0:1c3:39ac:889b with SMTP id
 e5c5f4694b2df-1c6cd15398cmr60108755d.25.1731617845785; Thu, 14 Nov 2024
 12:57:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com> <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 14 Nov 2024 12:57:14 -0800
Message-ID: <CAJnrk1ZsW=EFi2Weh66KPPQTT1TkvsZKMkeSd1JekQKGa0_ZNQ@mail.gmail.com>
Subject: Re: [PATCH RFC v5 05/16] fuse: make args->in_args[0] to be always the header
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 9:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
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
> ---
>  fs/fuse/dax.c    | 13 ++++++++-----
>  fs/fuse/dev.c    | 24 ++++++++++++++++++++----
>  fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
>  fs/fuse/fuse_i.h |  7 +++++++
>  fs/fuse/xattr.c  |  9 ++++++---
>  5 files changed, 68 insertions(+), 26 deletions(-)
>
> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971bebf8d=
a1f7fc5199c1271 100644
> --- a/fs/fuse/dax.c
> +++ b/fs/fuse/dax.c
> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode *in=
ode,
>         struct fuse_inode *fi =3D get_fuse_inode(inode);
>         struct fuse_mount *fm =3D get_fuse_mount(inode);
>         FUSE_ARGS(args);
> +       struct fuse_zero_in zero_arg;
>
>         args.opcode =3D FUSE_REMOVEMAPPING;
>         args.nodeid =3D fi->nodeid;
> -       args.in_numargs =3D 2;
> -       args.in_args[0].size =3D sizeof(*inargp);
> -       args.in_args[0].value =3D inargp;
> -       args.in_args[1].size =3D inargp->count * sizeof(*remove_one);
> -       args.in_args[1].value =3D remove_one;
> +       args.in_numargs =3D 3;
> +       args.in_args[0].size =3D sizeof(zero_arg);
> +       args.in_args[0].value =3D &zero_arg;
> +       args.in_args[1].size =3D sizeof(*inargp);
> +       args.in_args[1].value =3D inargp;
> +       args.in_args[2].size =3D inargp->count * sizeof(*remove_one);
> +       args.in_args[2].value =3D remove_one;
>         return fuse_simple_request(fm, &args);
>  }
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..6effef4073da3dad2f6140761=
eca98147a41d88d 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1007,6 +1007,19 @@ static int fuse_copy_args(struct fuse_copy_state *=
cs, unsigned numargs,
>
>         for (i =3D 0; !err && i < numargs; i++)  {
>                 struct fuse_arg *arg =3D &args[i];
> +
> +               /* zero headers */
> +               if (arg->size =3D=3D 0) {
> +                       if (WARN_ON_ONCE(i !=3D 0)) {
> +                               if (cs->req)
> +                                       pr_err_once(
> +                                               "fuse: zero size header i=
n opcode %d\n",
> +                                               cs->req->in.h.opcode);
> +                               return -EINVAL;
> +                       }
> +                       continue;
> +               }
> +
>                 if (i =3D=3D numargs - 1 && argpages)
>                         err =3D fuse_copy_pages(cs, arg->size, zeroing);
>                 else
> @@ -1662,6 +1675,7 @@ static int fuse_retrieve(struct fuse_mount *fm, str=
uct inode *inode,
>         size_t args_size =3D sizeof(*ra);
>         struct fuse_args_pages *ap;
>         struct fuse_args *args;
> +       struct fuse_zero_in zero_arg;
>
>         offset =3D outarg->offset & ~PAGE_MASK;
>         file_size =3D i_size_read(inode);
> @@ -1688,7 +1702,7 @@ static int fuse_retrieve(struct fuse_mount *fm, str=
uct inode *inode,
>         args =3D &ap->args;
>         args->nodeid =3D outarg->nodeid;
>         args->opcode =3D FUSE_NOTIFY_REPLY;
> -       args->in_numargs =3D 2;
> +       args->in_numargs =3D 3;
>         args->in_pages =3D true;
>         args->end =3D fuse_retrieve_end;
>
> @@ -1715,9 +1729,11 @@ static int fuse_retrieve(struct fuse_mount *fm, st=
ruct inode *inode,
>         }
>         ra->inarg.offset =3D outarg->offset;
>         ra->inarg.size =3D total_len;
> -       args->in_args[0].size =3D sizeof(ra->inarg);
> -       args->in_args[0].value =3D &ra->inarg;
> -       args->in_args[1].size =3D total_len;
> +       args->in_args[0].size =3D sizeof(zero_arg);
> +       args->in_args[0].value =3D &zero_arg;
> +       args->in_args[1].size =3D sizeof(ra->inarg);
> +       args->in_args[1].value =3D &ra->inarg;
> +       args->in_args[2].size =3D total_len;
>
>         err =3D fuse_simple_notify_reply(fm, args, outarg->notify_unique)=
;
>         if (err)

Do we also need to add a zero arg header for FUSE_READLINK,
FUSE_DESTROY, and FUSE_BATCH_FORGET requests as well?


Thanks,
Joanne

> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 2b0d4781f39484d50d1fd7f4f673d8b08c5fd7cf..6d67d7f8e6b4460c759df3fb2=
93e169bcc78a897 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -172,12 +172,16 @@ static void fuse_lookup_init(struct fuse_conn *fc, =
struct fuse_args *args,
>                              u64 nodeid, const struct qstr *name,
>                              struct fuse_entry_out *outarg)
>  {
> +       struct fuse_zero_in zero_arg;
> +
>         memset(outarg, 0, sizeof(struct fuse_entry_out));
>         args->opcode =3D FUSE_LOOKUP;
>         args->nodeid =3D nodeid;
> -       args->in_numargs =3D 1;
> -       args->in_args[0].size =3D name->len + 1;
> -       args->in_args[0].value =3D name->name;
> +       args->in_numargs =3D 2;
> +       args->in_args[0].size =3D sizeof(zero_arg);
> +       args->in_args[0].value =3D &zero_arg;
> +       args->in_args[1].size =3D name->len + 1;
> +       args->in_args[1].value =3D name->name;
>         args->out_numargs =3D 1;
>         args->out_args[0].size =3D sizeof(struct fuse_entry_out);
>         args->out_args[0].value =3D outarg;
> @@ -915,16 +919,19 @@ static int fuse_mkdir(struct mnt_idmap *idmap, stru=
ct inode *dir,
>  static int fuse_symlink(struct mnt_idmap *idmap, struct inode *dir,
>                         struct dentry *entry, const char *link)
>  {
> +       struct fuse_zero_in zero_arg;
>         struct fuse_mount *fm =3D get_fuse_mount(dir);
>         unsigned len =3D strlen(link) + 1;
>         FUSE_ARGS(args);
>
>         args.opcode =3D FUSE_SYMLINK;
> -       args.in_numargs =3D 2;
> -       args.in_args[0].size =3D entry->d_name.len + 1;
> -       args.in_args[0].value =3D entry->d_name.name;
> -       args.in_args[1].size =3D len;
> -       args.in_args[1].value =3D link;
> +       args.in_numargs =3D 3;
> +       args.in_args[0].size =3D sizeof(zero_arg);
> +       args.in_args[0].value =3D &zero_arg;
> +       args.in_args[1].size =3D entry->d_name.len + 1;
> +       args.in_args[1].value =3D entry->d_name.name;
> +       args.in_args[2].size =3D len;
> +       args.in_args[2].value =3D link;
>         return create_new_entry(fm, &args, dir, entry, S_IFLNK);
>  }
>
> @@ -975,6 +982,7 @@ static void fuse_entry_unlinked(struct dentry *entry)
>
>  static int fuse_unlink(struct inode *dir, struct dentry *entry)
>  {
> +       struct fuse_zero_in inarg;
>         int err;
>         struct fuse_mount *fm =3D get_fuse_mount(dir);
>         FUSE_ARGS(args);
> @@ -984,9 +992,11 @@ static int fuse_unlink(struct inode *dir, struct den=
try *entry)
>
>         args.opcode =3D FUSE_UNLINK;
>         args.nodeid =3D get_node_id(dir);
> -       args.in_numargs =3D 1;
> -       args.in_args[0].size =3D entry->d_name.len + 1;
> -       args.in_args[0].value =3D entry->d_name.name;
> +       args.in_numargs =3D 2;
> +       args.in_args[0].size =3D sizeof(inarg);
> +       args.in_args[0].value =3D &inarg;
> +       args.in_args[1].size =3D entry->d_name.len + 1;
> +       args.in_args[1].value =3D entry->d_name.name;
>         err =3D fuse_simple_request(fm, &args);
>         if (!err) {
>                 fuse_dir_changed(dir);
> @@ -998,6 +1008,7 @@ static int fuse_unlink(struct inode *dir, struct den=
try *entry)
>
>  static int fuse_rmdir(struct inode *dir, struct dentry *entry)
>  {
> +       struct fuse_zero_in zero_arg;
>         int err;
>         struct fuse_mount *fm =3D get_fuse_mount(dir);
>         FUSE_ARGS(args);
> @@ -1007,9 +1018,11 @@ static int fuse_rmdir(struct inode *dir, struct de=
ntry *entry)
>
>         args.opcode =3D FUSE_RMDIR;
>         args.nodeid =3D get_node_id(dir);
> -       args.in_numargs =3D 1;
> -       args.in_args[0].size =3D entry->d_name.len + 1;
> -       args.in_args[0].value =3D entry->d_name.name;
> +       args.in_numargs =3D 2;
> +       args.in_args[0].size =3D sizeof(zero_arg);
> +       args.in_args[0].value =3D &zero_arg;
> +       args.in_args[1].size =3D entry->d_name.len + 1;
> +       args.in_args[1].value =3D entry->d_name.name;
>         err =3D fuse_simple_request(fm, &args);
>         if (!err) {
>                 fuse_dir_changed(dir);
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index f2391961031374d8d55916c326c6472f0c03aae6..e2d1d90dfdb13b2c3e7de4789=
501ee45d3bf7794 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -941,6 +941,13 @@ struct fuse_mount {
>         struct rcu_head rcu;
>  };
>
> +/*
> + * Empty header for FUSE opcodes without specific header needs.
> + * Used as a placeholder in args->in_args[0] for consistency
> + * across all FUSE operations, simplifying request handling.
> + */
> +struct fuse_zero_in {};
> +
>  static inline struct fuse_mount *get_fuse_mount_super(struct super_block=
 *sb)
>  {
>         return sb->s_fs_info;
> diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
> index 5b423fdbb13f8f17c3982e96dd0de836662092b0..2df1efd2e9bdb46571148f484=
d7927044f31c184 100644
> --- a/fs/fuse/xattr.c
> +++ b/fs/fuse/xattr.c
> @@ -158,15 +158,18 @@ int fuse_removexattr(struct inode *inode, const cha=
r *name)
>         struct fuse_mount *fm =3D get_fuse_mount(inode);
>         FUSE_ARGS(args);
>         int err;
> +       struct fuse_zero_in zero_arg;
>
>         if (fm->fc->no_removexattr)
>                 return -EOPNOTSUPP;
>
>         args.opcode =3D FUSE_REMOVEXATTR;
>         args.nodeid =3D get_node_id(inode);
> -       args.in_numargs =3D 1;
> -       args.in_args[0].size =3D strlen(name) + 1;
> -       args.in_args[0].value =3D name;
> +       args.in_numargs =3D 2;
> +       args.in_args[0].size =3D sizeof(zero_arg);
> +       args.in_args[0].value =3D &zero_arg;
> +       args.in_args[1].size =3D strlen(name) + 1;
> +       args.in_args[1].value =3D name;
>         err =3D fuse_simple_request(fm, &args);
>         if (err =3D=3D -ENOSYS) {
>                 fm->fc->no_removexattr =3D 1;
>
> --
> 2.43.0
>

