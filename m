Return-Path: <io-uring+bounces-4711-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B30A29CD4CD
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 01:49:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 326C21F219BF
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 00:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464221E53A;
	Fri, 15 Nov 2024 00:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0bckgFu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E68F1F95A;
	Fri, 15 Nov 2024 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731631772; cv=none; b=a3kFhx0ImGAEOWZHJBAqvSmWXU1sZoHmodHNna9fZAagR1kzm1M7evoDLYvs1tBJ4liZzee0aLKU2YDGRNN7lFjjJwnyu0MPuqpdow5ypTt0yonHVFJViYdMW4b15fabQDPK49i/v6QRrywh/UL2W0vDQw1BYQvkGpk2Lnp2L3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731631772; c=relaxed/simple;
	bh=NRxkGLxopgH1TNZh/tOWC99JBjOWHBe/7EvNSWSW8yo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cUEBwxGiH+xKOdV9/st5TZOFYQ6TMiPmLpX41IWkLLyaFjaCTD5uXITNL08UEkyGNQD+1ma2hA06twQ4w7s4cVQC1LkaAaTH40Wi+UInTrNWIB2VtBrlihoCcWlB9Gm9NpdHpaVG8xWm9rvVdne8Mb0wi18Cn3i6KGJJLKgaark=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i0bckgFu; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7b14df8f821so89396585a.2;
        Thu, 14 Nov 2024 16:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731631769; x=1732236569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I44ZORGtMctJwRVjTZkLeJha4AmaYQqBFgxt4OBLrx8=;
        b=i0bckgFu8AxzMWSytoBWYXVfQufzk0V+ewgS5OuNQ5VNzfgBl50UMXwJp8VQY8lF0p
         842PBHidbXJITqLtjTCP/YS8ujKBY99E08xegzL0w3sUOVMZKeMwS/s4BaMTXR9Dy1Zq
         sXBWRmucmW+9pARS29fYz+fugg0Ie2tFZZT+/5MJGbIDJvUHHG1JerSNVHNWxxqw1zch
         Q1YsgGdjqvKVvzwZ07e6SAKegLB9VxlrOvrfQUZ7c1l3TNSi9Kf+r0abXjH0+ua5ELIv
         f8TzJR3JJ8jSQsBtpVuX4rbR5wwteu3FVLRSAPWYq/T+ckzdHVCOaMRrgqGbKsPu0LcS
         etYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731631769; x=1732236569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I44ZORGtMctJwRVjTZkLeJha4AmaYQqBFgxt4OBLrx8=;
        b=n97qrDHlCSdjSBPwmbL4HM/6FRfyvAIxVfM2HfQm0av62zT0k7PMrIFjIGgCrX8ih9
         fDGp7AjunOfKbbY9+tlCfUDZ69k+T7/s+ha3NdX1AXZ/XntATlvfSJcitS4mjn/Ifbsc
         qhF4AIurEirnfCv2xu8GhVA5aOJJOqjuzuuXDCBzxxAj6loGqgNvR2fYWLUdMR+O/W4M
         KyUncPzWDKAOBN3xu2bOpZ9E4wc1qQ1xqIk4CuvXNyXIUNBGunhnU0XGIopXaBnvocq2
         V1fjgtbFyG1DbgjJsc/tf+pNkuwTODmj9RDUYwVGpnVT/66t1lpusz5cMlXz0JlMZYm2
         3qkw==
X-Forwarded-Encrypted: i=1; AJvYcCU94/lrTrlUIyEFDGrSPR9NF5YTczi0tRrYD5XuT5M5sVG2gJ3IW5Y9Gmrei+c/kVznhRB8SP+H4yPIGRnUEQ==@vger.kernel.org, AJvYcCWt5Fy25o1vs/OJ4RNbRz0MldvN2UMRz1NcdLtH6O3mjPYLRArvEbI0gAq1KgVw8aDkHzPTJtnZGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWUF0I+8wxZHnh25HQisDr1dOBoW/AM/S7kUEtJ7XxC2xyo3/2
	/qbdT/9u8izv3C0B4AkHVgD4qTc38vFfzXvI4GiON4fOmm+H43Sy9dJXehWORJlEyjA/3txCHpF
	Qh0bsU9XXTYKlF4r15KIQp3Hcuf0=
X-Google-Smtp-Source: AGHT+IE2dyqyppj9Ib1cw9VXPCuoLGDAlKRR2Sz8gbRFUfK+zO3WeFtRZ6ToWmxeKhk8XZ1w1tSul333hoimo14CTLY=
X-Received: by 2002:a05:620a:1a0a:b0:7b1:45ac:86b6 with SMTP id
 af79cd13be357-7b362362721mr100316385a.39.1731631769253; Thu, 14 Nov 2024
 16:49:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-5-e8660a991499@ddn.com>
 <CAJnrk1ZsW=EFi2Weh66KPPQTT1TkvsZKMkeSd1JekQKGa0_ZNQ@mail.gmail.com>
 <cd5c17fd-8127-42f8-bd20-a693ce66bddc@fastmail.fm> <CAJnrk1aBvndZ9o3n9dRbjHxTzJiffWQqYBJRtNgwk=PWO_FW3Q@mail.gmail.com>
 <7cb814e8-38ec-468c-9bd8-1cc5d0664686@fastmail.fm>
In-Reply-To: <7cb814e8-38ec-468c-9bd8-1cc5d0664686@fastmail.fm>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 14 Nov 2024 16:49:18 -0800
Message-ID: <CAJnrk1YBiyT8PWGnpqmUmqEq8TypXMqCpPgy-tdjh1ixG5yEvQ@mail.gmail.com>
Subject: Re: [PATCH RFC v5 05/16] fuse: make args->in_args[0] to be always the header
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 14, 2024 at 2:06=E2=80=AFPM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
>
>
> On 11/14/24 22:29, Joanne Koong wrote:
> > On Thu, Nov 14, 2024 at 1:05=E2=80=AFPM Bernd Schubert
> > <bernd.schubert@fastmail.fm> wrote:
> >>
> >>
> >>
> >> On 11/14/24 21:57, Joanne Koong wrote:
> >>> On Thu, Nov 7, 2024 at 9:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.=
com> wrote:
> >>>>
> >>>> This change sets up FUSE operations to have headers in args.in_args[=
0],
> >>>> even for opcodes without an actual header. We do this to prepare for
> >>>> cleanly separating payload from headers in the future.
> >>>>
> >>>> For opcodes without a header, we use a zero-sized struct as a
> >>>> placeholder. This approach:
> >>>> - Keeps things consistent across all FUSE operations
> >>>> - Will help with payload alignment later
> >>>> - Avoids future issues when header sizes change
> >>>>
> >>>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> >>>> ---
> >>>>  fs/fuse/dax.c    | 13 ++++++++-----
> >>>>  fs/fuse/dev.c    | 24 ++++++++++++++++++++----
> >>>>  fs/fuse/dir.c    | 41 +++++++++++++++++++++++++++--------------
> >>>>  fs/fuse/fuse_i.h |  7 +++++++
> >>>>  fs/fuse/xattr.c  |  9 ++++++---
> >>>>  5 files changed, 68 insertions(+), 26 deletions(-)
> >>>>
> >>>> diff --git a/fs/fuse/dax.c b/fs/fuse/dax.c
> >>>> index 12ef91d170bb3091ac35a33d2b9dc38330b00948..e459b8134ccb089f971b=
ebf8da1f7fc5199c1271 100644
> >>>> --- a/fs/fuse/dax.c
> >>>> +++ b/fs/fuse/dax.c
> >>>> @@ -237,14 +237,17 @@ static int fuse_send_removemapping(struct inod=
e *inode,
> >>>>         struct fuse_inode *fi =3D get_fuse_inode(inode);
> >>>>         struct fuse_mount *fm =3D get_fuse_mount(inode);
> >>>>         FUSE_ARGS(args);
> >>>> +       struct fuse_zero_in zero_arg;
> >>>>
> >>>>         args.opcode =3D FUSE_REMOVEMAPPING;
> >>>>         args.nodeid =3D fi->nodeid;
> >>>> -       args.in_numargs =3D 2;
> >>>> -       args.in_args[0].size =3D sizeof(*inargp);
> >>>> -       args.in_args[0].value =3D inargp;
> >>>> -       args.in_args[1].size =3D inargp->count * sizeof(*remove_one)=
;
> >>>> -       args.in_args[1].value =3D remove_one;
> >>>> +       args.in_numargs =3D 3;
> >>>> +       args.in_args[0].size =3D sizeof(zero_arg);
> >>>> +       args.in_args[0].value =3D &zero_arg;
> >>>> +       args.in_args[1].size =3D sizeof(*inargp);
> >>>> +       args.in_args[1].value =3D inargp;
> >>>> +       args.in_args[2].size =3D inargp->count * sizeof(*remove_one)=
;
> >>>> +       args.in_args[2].value =3D remove_one;
> >>>>         return fuse_simple_request(fm, &args);
> >>>>  }
> >>>>
> >>>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> >>>> index dbc222f9b0f0e590ce3ef83077e6b4cff03cff65..6effef4073da3dad2f61=
40761eca98147a41d88d 100644
> >>>> --- a/fs/fuse/dev.c
> >>>> +++ b/fs/fuse/dev.c
> >>>> @@ -1007,6 +1007,19 @@ static int fuse_copy_args(struct fuse_copy_st=
ate *cs, unsigned numargs,
> >>>>
> >>>>         for (i =3D 0; !err && i < numargs; i++)  {
> >>>>                 struct fuse_arg *arg =3D &args[i];
> >>>> +
> >>>> +               /* zero headers */
> >>>> +               if (arg->size =3D=3D 0) {
> >>>> +                       if (WARN_ON_ONCE(i !=3D 0)) {
> >>>> +                               if (cs->req)
> >>>> +                                       pr_err_once(
> >>>> +                                               "fuse: zero size hea=
der in opcode %d\n",
> >>>> +                                               cs->req->in.h.opcode=
);
> >>>> +                               return -EINVAL;
> >>>> +                       }
> >>>> +                       continue;
> >>>> +               }
> >>>> +
> >>>>                 if (i =3D=3D numargs - 1 && argpages)
> >>>>                         err =3D fuse_copy_pages(cs, arg->size, zeroi=
ng);
> >>>>                 else
> >>>> @@ -1662,6 +1675,7 @@ static int fuse_retrieve(struct fuse_mount *fm=
, struct inode *inode,
> >>>>         size_t args_size =3D sizeof(*ra);
> >>>>         struct fuse_args_pages *ap;
> >>>>         struct fuse_args *args;
> >>>> +       struct fuse_zero_in zero_arg;
> >>>>
> >>>>         offset =3D outarg->offset & ~PAGE_MASK;
> >>>>         file_size =3D i_size_read(inode);
> >>>> @@ -1688,7 +1702,7 @@ static int fuse_retrieve(struct fuse_mount *fm=
, struct inode *inode,
> >>>>         args =3D &ap->args;
> >>>>         args->nodeid =3D outarg->nodeid;
> >>>>         args->opcode =3D FUSE_NOTIFY_REPLY;
> >>>> -       args->in_numargs =3D 2;
> >>>> +       args->in_numargs =3D 3;
> >>>>         args->in_pages =3D true;
> >>>>         args->end =3D fuse_retrieve_end;
> >>>>
> >>>> @@ -1715,9 +1729,11 @@ static int fuse_retrieve(struct fuse_mount *f=
m, struct inode *inode,
> >>>>         }
> >>>>         ra->inarg.offset =3D outarg->offset;
> >>>>         ra->inarg.size =3D total_len;
> >>>> -       args->in_args[0].size =3D sizeof(ra->inarg);
> >>>> -       args->in_args[0].value =3D &ra->inarg;
> >>>> -       args->in_args[1].size =3D total_len;
> >>>> +       args->in_args[0].size =3D sizeof(zero_arg);
> >>>> +       args->in_args[0].value =3D &zero_arg;
> >>>> +       args->in_args[1].size =3D sizeof(ra->inarg);
> >>>> +       args->in_args[1].value =3D &ra->inarg;
> >>>> +       args->in_args[2].size =3D total_len;
> >>>>
> >>>>         err =3D fuse_simple_notify_reply(fm, args, outarg->notify_un=
ique);
> >>>>         if (err)
> >>>
> >>> Do we also need to add a zero arg header for FUSE_READLINK,
> >>> FUSE_DESTROY, and FUSE_BATCH_FORGET requests as well?
> >>>
> >>
> >> Thanks for looking at the patch! I should have added to the commit mes=
sage
> >> that I didn't modify these, as they don't have an in argument at all.
> >>
> >
> > Thanks for clarifying! (and apologies for the late review. I haven't
> > been keeping up with these patches since RFC v3 but I'm planning to
> > get up to speed and take a deeper look at these tomorrow + next week).
>
> No worries at all... I'm also very late with reviewing your patches.
> I'm close for the next fuse-io-version, just fixing some bg accounting
> issues that had been in all rfc versions so far.
>

Awesome, I'll wait until your next fuse io version to review then.
Thanks for trucking along on this - I'm very excited to use this.

> >
> > I think the FUSE_BATCH_FORGET request does use in args, depending on
> > the number of forget requests.
>
> Ah right, but it does not use fuse_copy_args and args->in_args[idx] -
> is very special. And just looking it up again, the header is in the
> right place. Issue would be more for over-io-uring to copy into the
> payload. However, current over-io-uring patches don't handle forgets
> at all - it goes over /dev/fuse. Unless you disagree, I think we can
> do forgets later on over io-uring as optimization.
>

Not important at all - was just noting it in case you had meant to
include it as part of this patch.


Thanks,
Joanne
>
> Thanks,
> Bernd
>
>

