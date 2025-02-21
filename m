Return-Path: <io-uring+bounces-6622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B319A3FED8
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 19:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AE4F188D23A
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3808B252913;
	Fri, 21 Feb 2025 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUqLKcrs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299E92528F5;
	Fri, 21 Feb 2025 18:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740162694; cv=none; b=RtUyeDRHw3Pvyy62qldgDJZQAsnQE/DS0wYsVPsLL83ybN9v6Yr/qkSW6Uybma2R6KXC+kkaC/S399Z4CeEm6ZcrVXrk0TcvzF1wqIRDxVCqhxvFIWCvsPZn2uDHcAbxPZT0gOd+PZW3Nh1ISTLTqhx2njCZrUDHURXEpeIbDDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740162694; c=relaxed/simple;
	bh=5Lzy/H1XaXwajuMH+wJ3+SG5TIRo8jFE8cuoxBA4lho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K212aJvx/8QV3IlZBAqIF1M5IGQO1BswDw7jSR4juNgQ9t2okl2sNo/msCB3HoQjPu5IrwMi/GoURAtHDV5pfdwFDGOXSsxKvb4MwVz2g4oGbSex8WQ/Jb4hoEByjQjECh/pwbEV2KtMi9fXqAtROaKXXWLZQfnibVwquN5WuiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUqLKcrs; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abb79af88afso451469766b.1;
        Fri, 21 Feb 2025 10:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740162690; x=1740767490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bv/ctmOg/WO6WdxNQg13mLX7Es860GtrBsegugm/SCg=;
        b=aUqLKcrsQZWtZ/awuKwcvA+XU81wSMRb2xGgH6LgLiXz4ybxT1G800QFkz+kllXRBu
         2bUgkKGCNGnLx+xZluHg7JtalEzZ+hqsr9vd4s7T7AiOh9yG4YZgUxi3UB4nKCpL4sJ5
         PjHI06WeTxq2JJ0uISokq5AfRsApctdgTpDkpgz4FcThu/KqSYV7OUnt2qGXxK6tdpr/
         RJiZxZPiDzv2YXC+LV2kR7vXL7BM3Pw10DrRSfdQshqS+KQj3DupCqbU0YZDOw0mXx2m
         wwfzW4Z20orwOCZSkysournGci8MI70KygvAtv4/PAu1GYp9ipgD/9L/guTH8U8SvPhp
         VE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740162690; x=1740767490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bv/ctmOg/WO6WdxNQg13mLX7Es860GtrBsegugm/SCg=;
        b=w7+RwSe8PJnRBPZUE+IzZe9gUZ4in+LXnGII9352wonQxC6iE52+my9c9t4pJcTbG8
         VoezXr0jfADejmt2p27Ka0/jeaNVMKCPGeIS4eGJ8uy8XU/U90/awpNpM6TPEB/awz1J
         V+5vvCZq0bmlRjbnu4MYIxg3YkTegDXjuwjGQU8o+0UsRyWdt4SvXgLLJclDZ+VfcaNk
         WfXwLda6M64LP0ddS3ccyToIxl3xXFwvLWnzY6J/Ya7AU57pkyqRI9TkemUU6r4gjpjU
         2QHmtXwtpkJmySONL1WL0RskJUtL4af4atfBSh6s7TeEaIE6GjyxuS+AZjrhOljQAYie
         gCow==
X-Forwarded-Encrypted: i=1; AJvYcCVzVGCxko4VFCClcqXfYMWpjKSNchHi0SO/jZKiA4TxlRtzNW7QA+P5XT1TmSnBtOS96fhnHZx/i3bj9K2Z@vger.kernel.org, AJvYcCWCwnsW/A1qbFWL6IqIoVo8Id+RmNnyT1fUIiRMcf3gqyBJidKNfQpdo1fv4TqLuwhI+xhvk4R6Yw==@vger.kernel.org, AJvYcCXf6SOG2MUQz2bNFTieQTYsY2WGXJ245x+0X4qNDOLezG3mReWzNDGsrWYsGpLOLXcEKcqPpcoqSxJrn1zAtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM2p4r9l3vMH9huXo27F/S1ujMVIQQ/BSInmv+PWx9wQQBGaLc
	JwlVfsmNlkvFV52+PMUrnhWHlDAs56QPVZ8A2x+n8RGIu3H+LElbrhxJm9Ousfjnj/nl4S/c9h8
	RazswyW8RqLJ7sXYmiEFdt/vlApg=
X-Gm-Gg: ASbGncs5/DACGwEQm+B9ok18lPZTBK+tMDKqzS5/okJnjVZ3HhqrApp/RNlwgcP2okn
	aiyF2TO04XXwhmEJUbkiqFbS2QajL18fIMdO04z5pyyzSXHgHwIrQXDKI0QdUKZn8GsgoIyIR58
	VMI/8jNPo=
X-Google-Smtp-Source: AGHT+IHNlid9PLXps2+NF//N1KMEdA/eFX88QE2RUKtFJXIfT9YLuJ1TKK4fQFR5mi1iJcFj2NijmJsY7Efvx8vWMgQ=
X-Received: by 2002:a17:907:1b26:b0:aaf:1183:e9be with SMTP id
 a640c23a62f3a-abc099b881cmr479117666b.2.1740162689764; Fri, 21 Feb 2025
 10:31:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com> <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com>
 <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com> <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
 <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
In-Reply-To: <2d9f56ae-7344-4f82-b5da-61522543ef4f@bsbernd.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 21 Feb 2025 19:31:17 +0100
X-Gm-Features: AWEUYZkCD0-FFo8zUveTbb9T9lUAxqsq6Ci4Iv5yd7WFwZO-1N7NvuN_eWSHJEk
Message-ID: <CAOQ4uxjhi_0f4y5DgrQr+H01j4N7d4VRv3vNidfNYy-cP8TS4g@mail.gmail.com>
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Moinak Bhattacharyya <moinakb001@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 6:51=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 2/21/25 18:25, Amir Goldstein wrote:
> > On Fri, Feb 21, 2025 at 6:13=E2=80=AFPM Bernd Schubert <bernd@bsbernd.c=
om> wrote:
> >>
> >>
> >>
> >> On 2/21/25 17:24, Amir Goldstein wrote:
> >>> On Fri, Feb 21, 2025 at 4:36=E2=80=AFPM Moinak Bhattacharyya
> >>> <moinakb001@gmail.com> wrote:
> >>>>
> >>>> Sorry about that. Correctly-formatted patch follows. Should I send o=
ut a
> >>>> V2 instead?
> >>>>
> >>>> Add support for opening and closing backing files in the fuse_uring_=
cmd
> >>>> callback. Store backing_map (for open) and backing_id (for close) in=
 the
> >>>> uring_cmd data.
> >>>> ---
> >>>>   fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++=
++++
> >>>>   include/uapi/linux/fuse.h |  6 +++++
> >>>>   2 files changed, 56 insertions(+)
> >>>>
> >>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >>>> index ebd2931b4f2a..df73d9d7e686 100644
> >>>> --- a/fs/fuse/dev_uring.c
> >>>> +++ b/fs/fuse/dev_uring.c
> >>>> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cm=
d *cmd,
> >>>>       return ent;
> >>>>   }
> >>>>
> >>>> +/*
> >>>> + * Register new backing file for passthrough, getting backing map f=
rom
> >>>> URING_CMD data
> >>>> + */
> >>>> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
> >>>> +    unsigned int issue_flags, struct fuse_conn *fc)
> >>>> +{
> >>>> +    const struct fuse_backing_map *map =3D io_uring_sqe_cmd(cmd->sq=
e);
> >>>> +    int ret =3D fuse_backing_open(fc, map);
> >>>> +
> >>>
> >>> I am not that familiar with io_uring, so I need to ask -
> >>> fuse_backing_open() does
> >>> fb->cred =3D prepare_creds();
> >>> to record server credentials
> >>> what are the credentials that will be recorded in the context of this
> >>> io_uring command?
> >>
> >> This is run from the io_uring_enter() syscall - it should not make
> >> a difference to an ioctl, AFAIK. Someone from @io-uring please
> >> correct me if I'm wrong.
> >>
> >>>
> >>>
> >>>> +    if (ret < 0) {
> >>>> +        return ret;
> >>>> +    }
> >>>> +
> >>>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> >>>> +    return 0;
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * Remove file from passthrough tracking, getting backing_id from
> >>>> URING_CMD data
> >>>> + */
> >>>> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
> >>>> +    unsigned int issue_flags, struct fuse_conn *fc)
> >>>> +{
> >>>> +    const int *backing_id =3D io_uring_sqe_cmd(cmd->sqe);
> >>>> +    int ret =3D fuse_backing_close(fc, *backing_id);
> >>>> +
> >>>> +    if (ret < 0) {
> >>>> +        return ret;
> >>>> +    }
> >>>> +
> >>>> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> >>>> +    return 0;
> >>>> +}
> >>>> +
> >>>>   /*
> >>>>    * Register header and payload buffer with the kernel and puts the
> >>>>    * entry as "ready to get fuse requests" on the queue
> >>>> @@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
> >>>> unsigned int issue_flags)
> >>>>               return err;
> >>>>           }
> >>>>           break;
> >>>> +    case FUSE_IO_URING_CMD_BACKING_OPEN:
> >>>> +        err =3D fuse_uring_backing_open(cmd, issue_flags, fc);
> >>>> +        if (err) {
> >>>> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=
=3D%d\n",
> >>>> +                    err);
> >>>> +            return err;
> >>>> +        }
> >>>> +        break;
> >>>> +    case FUSE_IO_URING_CMD_BACKING_CLOSE:
> >>>> +        err =3D fuse_uring_backing_close(cmd, issue_flags, fc);
> >>>> +        if (err) {
> >>>> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed er=
r=3D%d\n",
> >>>> +                    err);
> >>>> +            return err;
> >>>> +        }
> >>>> +        break;
> >>>>       default:
> >>>>           return -EINVAL;
> >>>>       }
> >>>> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> >>>> index 5e0eb41d967e..634265da1328 100644
> >>>> --- a/include/uapi/linux/fuse.h
> >>>> +++ b/include/uapi/linux/fuse.h
> >>>> @@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {
> >>>>
> >>>>       /* commit fuse request result and fetch next request */
> >>>>       FUSE_IO_URING_CMD_COMMIT_AND_FETCH =3D 2,
> >>>> +
> >>>> +    /* add new backing file for passthrough */
> >>>> +    FUSE_IO_URING_CMD_BACKING_OPEN =3D 3,
> >>>> +
> >>>> +    /* remove passthrough file by backing_id */
> >>>> +    FUSE_IO_URING_CMD_BACKING_CLOSE =3D 4,
> >>>>   };
> >>>>
> >>>
> >>> An anecdote:
> >>> Why are we using FUSE_DEV_IOC_BACKING_OPEN
> >>> and not passing the backing fd directly in OPEN response?
> >>>
> >>> The reason for that was security related - there was a concern that
> >>> an adversary would be able to trick some process into writing some fd
> >>> to /dev/fuse, whereas tricking some proces into doing an ioctl is not
> >>> so realistic.
> >>>
> >>> AFAICT this concern does not exist when OPEN response is via
> >>> io_uring(?), so the backing_id indirection is not strictly needed,
> >>> but for the sake of uniformity with standard fuse protocol,
> >>> I guess we should maintain those commands in io_uring as well.
> >>
> >> Yeah, the way it is done is not ideal
> >>
> >> fi->backing_id =3D do_passthrough_open(); /* blocking */
> >> fuse_reply_create()
> >>     fill_open()
> >>       arg->backing_id =3D f->backing_id; /* f is fi */
> >>
> >>
> >> I.e. there are still two operations that depend on each other.
> >> Maybe we could find a way to link the SQEs.
> >
> > If we can utilize io_uring infrastructure to link the two
> > commands it would be best IMO, to keep protocol uniform.
> >
> >> Or maybe easier, if the security concern is gone with IO-URING,
> >> just set FOPEN_PASSTHROUGH for requests over io-uring and then
> >> let the client/kernel side do the passthrough open internally?
> >
> > It is possible, for example set FOPEN_PASSTHROUGH_FD to
> > interpret backing_id as backing_fd, but note that in the current
> > implementation of passthrough_hp, not every open does
> > fuse_passthrough_open().
> > The non-first open of an inode uses a backing_id stashed in inode,
> > from the first open so we'd need different server logic depending on
> > the commands channel, which is not nice.
>
> Probably, but I especially added fuse_req_is_uring() to the API
> to be able to do that. For example to avoid another memcpy when passing
> buffers to another thread.
>

I understand sometimes the server will need to have slightly different logi=
c
depending on the channel, but in this case I think that should be avoided.
If there is an option to link the CMD_BACKING_OPEN with the commit of
OPEN result and back the backing_id for the server, that would be best.

BTW, I am now trying to work out the API for setting up a backing file
for an inode at LOOKUP time for passthrough of inode operations.
For this mode of operation, I was considering to support OPEN
response with FOPEN_PASSTHROUGH and zero backing_id to mean
"the backing file that is associated with the inode".
I've actually reserved backing_id 0 for this purpose.
In this mode of operations the problem at hand will become moot.

One way to deal with the API of FOPEN_PASSTHROUGH in
io_uring is to only use this mode of operation.
IOW, LOOKUP response could have a backing fd and not
a backing id and then the backing ids are not even exposed to
server because the server does not care - for all practical purposes
the nodeid is the backing id.

I personally don't mind if inode operations passthrough
that are setup via LOOKUP response, will require io_uring.
Both features are about metadata operations performance,
so it kind of makes sense to bundle them together, does it not?

Thanks,
Amir.

