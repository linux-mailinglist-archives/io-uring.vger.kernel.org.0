Return-Path: <io-uring+bounces-4708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D2B9C948D
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 22:29:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D74CC285239
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 21:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6DA1AF0C2;
	Thu, 14 Nov 2024 21:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WR9snSIF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C01AF0A9;
	Thu, 14 Nov 2024 21:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731619766; cv=none; b=alMm6n48DNYuDGOG3tJ/CpocxZfuWN5R/iB+ZDt0BUs7PLrOXLYF7tSy/KmsCx6ooBxPpV+wjSMwOx/ljM3FnYEmmUOdE8sKa12xz+osNn7P39LbNg2Dop15H56dGNaY8gH/KpSSsyKyyuLCr4r605TJ8grZB6gY+dyQIM0bwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731619766; c=relaxed/simple;
	bh=WoEAWbvLHrurWUoRiR9bh9W6MBdb/SvPQyj4ttK2brU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MpiG9KBdbkaK52o56v8GFyMqNzl7NTbz/UV0GLpeRsakednG/tUZt926cWtKrg3xARvZP1KTB9GNEcVolVLD4CgSa+QwWbQxb1MtxQZlhTCvnALjrpCKu4aEiG2pJY1ZN5J43QDGOzjwpDBfn+5ntFl7UIod2LjGSk/Z2ySSSY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WR9snSIF; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-460c0f9c13eso9403001cf.0;
        Thu, 14 Nov 2024 13:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731619764; x=1732224564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2jYkWEdT6qNujKhAkLrZ0ryMKDY6QfMRulcc8LOfwo=;
        b=WR9snSIFzRGO26VgkVVHd98C9ly5gcMcDbvTw6qL2VrUta3yYD8n/JUhAx4e8iAEtt
         qLQZG27NZSnx/Qq+nUDtEiEDyqMWz9vjpdv2+ig8XgS4wbV8x+WZP38Q5lCKWYTnV6jw
         TaIOoFzcRydiSZPa3eA1PFiTYlQHkkv7BOT02ApjDX/vxzzOP8Y3WS+bqAoZ3QHBhCJn
         6cNh7XhmsyWrSte9X1JhCiVhZYjV57KcTZBlo+hE5IFA+mSJndBB/AJemJ9M8eScdXa3
         shphM2Qr7ES9QG3DYlGZQh/04eFF35EgmTwpgFmsvhNduJ1HVJFJ/3xBa+bdJCTc3ig9
         oEzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731619764; x=1732224564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2jYkWEdT6qNujKhAkLrZ0ryMKDY6QfMRulcc8LOfwo=;
        b=xRg0JY8JDQsUvUTfpM47DMk4Yk74DWnKO04FcKF54bmCNgh/JTcq/1OnYnpPzxYB8O
         ZKpLPc08eRtr1fNw/peVbOh1fUJVte4o6wj6wNr7UTiVa+MySIbJKZd0LpXIfv2J233z
         gx4cgUqZzi6tFpo/8j3DvdSizMKfmUxywiAS4Ti9yj2/meRBC0R0qNijLjbqrpovnqsJ
         J+4lYFprpAUZ4P2b2d1G9g/RZbKY/FRPNR3N1wtbg4B8GxthErDBBfexhH13l5oKmKX1
         lIuNqT6MaOKomw2LY4VA0M28GNIUE0pkCi5Rb9LnK9WbDiQSd2Wj+pOxxfuErhe7WXbd
         TpWA==
X-Forwarded-Encrypted: i=1; AJvYcCVi/ThljGfXhca/cRXpfFmwDZpInHI2V8broSdJQG8zMyszYJoJ2kPMXQ5DEWH3eJi5bBhS/UQYdPFPPWmZcw==@vger.kernel.org, AJvYcCXaBGs5kq7VhsQZE3rBtOtL9bqRBKKV/nacO+bvWLKs9DJv1UqAfnYGYnAfugE07dSirAHjJ6mTAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzPR/adRNxUcsJZbRqNjxoOiY6ElB0hsBxqUDuUMuw5sej5TQ8n
	LcTCgYuC18gDRQ6MGJ9ZHwS9Qb1Sw4mc64nS7UYUcIDx1ss/VgzGgL0DIMfGegMRTzplb4osjMG
	SUzLW5e11Cys562oM5gIVoCetDu0wy+nA
X-Google-Smtp-Source: AGHT+IHuWBZdfSDwe2S2mQ5XgAZZP2ly6XSqFElass0m27/PJwpFTjiQqvgX6PckTSIyADQCz0Sy7BbYlIEFX1x/dAs=
X-Received: by 2002:a05:622a:5b86:b0:461:22fc:73da with SMTP id
 d75a77b69052e-463635462dcmr11342721cf.16.1731619763766; Thu, 14 Nov 2024
 13:29:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
 <CAJnrk1ZsW=EFi2Weh66KPPQTT1TkvsZKMkeSd1JekQKGa0_ZNQ@mail.gmail.com> <cd5c17fd-8127-42f8-bd20-a693ce66bddc@fastmail.fm>
In-Reply-To: <cd5c17fd-8127-42f8-bd20-a693ce66bddc@fastmail.fm>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 14 Nov 2024 13:29:12 -0800
Message-ID: <CAJnrk1aBvndZ9o3n9dRbjHxTzJiffWQqYBJRtNgwk=PWO_FW3Q@mail.gmail.com>
Subject: Re: [PATCH RFC v5 05/16] fuse: make args->in_args[0] to be always the header
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 1:05=E2=80=AFPM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
>
>
> On 11/14/24 21:57, Joanne Koong wrote:
> > On Thu, Nov 7, 2024 at 9:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.co=
m> wrote:
> >>
> >> This change sets up FUSE operations to have headers in args.in_args[0]=
,
> >> even for opcodes without an actual header. We do this to prepare for
> >> cleanly separating payload from headers in the future.
> >>
> >> For opcodes without a header, we use a zero-sized struct as a
> >> placeholder. This approach:
> >> - Keeps things consistent across all FUSE operations
> >> - Will help with payload alignment later
> >> - Avoids future issues when header sizes change
> >>
> >> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> >> ---
> >>  fs/fuse/dax.c    | 13 ++++++++-----
> >>  fs/fuse/dev.c    | 24 ++++++++++++++++++++----
> >>  fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
> >>  fs/fuse/fuse_i.h |  7 +++++++
> >>  fs/fuse/xattr.c  |  9 ++++++---
> >>  5 files changed, 68 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> >> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971beb=
f8da1f7fc5199c1271 100644
> >> --- a/fs/fuse/dax.c
> >> +++ b/fs/fuse/dax.c
> >> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inode =
*inode,
> >>         struct fuse_inode *fi =3D get_fuse_inode(inode);
> >>         struct fuse_mount *fm =3D get_fuse_mount(inode);
> >>         FUSE_ARGS(args);
> >> +       struct fuse_zero_in zero_arg;
> >>
> >>         args.opcode =3D FUSE_REMOVEMAPPING;
> >>         args.nodeid =3D fi->nodeid;
> >> -       args.in_numargs =3D 2;
> >> -       args.in_args[0].size =3D sizeof(*inargp);
> >> -       args.in_args[0].value =3D inargp;
> >> -       args.in_args[1].size =3D inargp->count * sizeof(*remove_one);
> >> -       args.in_args[1].value =3D remove_one;
> >> +       args.in_numargs =3D 3;
> >> +       args.in_args[0].size =3D sizeof(zero_arg);
> >> +       args.in_args[0].value =3D &zero_arg;
> >> +       args.in_args[1].size =3D sizeof(*inargp);
> >> +       args.in_args[1].value =3D inargp;
> >> +       args.in_args[2].size =3D inargp->count * sizeof(*remove_one);
> >> +       args.in_args[2].value =3D remove_one;
> >>         return fuse_simple_request(fm, &args);
> >>  }
> >>
> >> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> >> index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..6effef4073da3dad2f6140=
761eca98147a41d88d 100644
> >> --- a/fs/fuse/dev.c
> >> +++ b/fs/fuse/dev.c
> >> @@ -1007,6 +1007,19 @@ static int fuse_copy_args(struct fuse_copy_stat=
e *cs, unsigned numargs,
> >>
> >>         for (i =3D 0; !err && i < numargs; i++)  {
> >>                 struct fuse_arg *arg =3D &args[i];
> >> +
> >> +               /* zero headers */
> >> +               if (arg->size =3D=3D 0) {
> >> +                       if (WARN_ON_ONCE(i !=3D 0)) {
> >> +                               if (cs->req)
> >> +                                       pr_err_once(
> >> +                                               "fuse: zero size heade=
r in opcode %d\n",
> >> +                                               cs->req->in.h.opcode);
> >> +                               return -EINVAL;
> >> +                       }
> >> +                       continue;
> >> +               }
> >> +
> >>                 if (i =3D=3D numargs - 1 && argpages)
> >>                         err =3D fuse_copy_pages(cs, arg->size, zeroing=
);
> >>                 else
> >> @@ -1662,6 +1675,7 @@ static int fuse_retrieve(struct fuse_mount *fm, =
struct inode *inode,
> >>         size_t args_size =3D sizeof(*ra);
> >>         struct fuse_args_pages *ap;
> >>         struct fuse_args *args;
> >> +       struct fuse_zero_in zero_arg;
> >>
> >>         offset =3D outarg->offset & ~PAGE_MASK;
> >>         file_size =3D i_size_read(inode);
> >> @@ -1688,7 +1702,7 @@ static int fuse_retrieve(struct fuse_mount *fm, =
struct inode *inode,
> >>         args =3D &ap->args;
> >>         args->nodeid =3D outarg->nodeid;
> >>         args->opcode =3D FUSE_NOTIFY_REPLY;
> >> -       args->in_numargs =3D 2;
> >> +       args->in_numargs =3D 3;
> >>         args->in_pages =3D true;
> >>         args->end =3D fuse_retrieve_end;
> >>
> >> @@ -1715,9 +1729,11 @@ static int fuse_retrieve(struct fuse_mount *fm,=
 struct inode *inode,
> >>         }
> >>         ra->inarg.offset =3D outarg->offset;
> >>         ra->inarg.size =3D total_len;
> >> -       args->in_args[0].size =3D sizeof(ra->inarg);
> >> -       args->in_args[0].value =3D &ra->inarg;
> >> -       args->in_args[1].size =3D total_len;
> >> +       args->in_args[0].size =3D sizeof(zero_arg);
> >> +       args->in_args[0].value =3D &zero_arg;
> >> +       args->in_args[1].size =3D sizeof(ra->inarg);
> >> +       args->in_args[1].value =3D &ra->inarg;
> >> +       args->in_args[2].size =3D total_len;
> >>
> >>         err =3D fuse_simple_notify_reply(fm, args, outarg->notify_uniq=
ue);
> >>         if (err)
> >
> > Do we also need to add a zero arg header for FUSE_READLINK,
> > FUSE_DESTROY, and FUSE_BATCH_FORGET requests as well?
> >
>
> Thanks for looking at the patch! I should have added to the commit messag=
e
> that I didn't modify these, as they don't have an in argument at all.
>

Thanks for clarifying! (and apologies for the late review. I haven't
been keeping up with these patches since RFC v3 but I'm planning to
get up to speed and take a deeper look at these tomorrow + next week).

I think the FUSE_BATCH_FORGET request does use in args, depending on
the number of forget requests.


Thanks,
Joanne
>
> Thanks,
> Bernd

