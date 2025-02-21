Return-Path: <io-uring+bounces-6614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F06EA3FD5E
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 18:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A52B61891E13
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FE82500CC;
	Fri, 21 Feb 2025 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P06Dfi0p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C2D2500B1;
	Fri, 21 Feb 2025 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740158739; cv=none; b=UCN6i3DIH3ivNp+azE5eg8YFq8JS7uQOg3O+wkat6v/f5eJ6n85QaSiZGQx/ll0i9wo9gKqDrkBrcDwOgRjZ/wZ9paBXsf/OVSSHtEyvthP9oZR28Yp1FYsPtrgMAJapRUyBOlZImSH7haniPMZwXZpnV51pKTTHJBgXd8nQA0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740158739; c=relaxed/simple;
	bh=DTLCcsRH2tYUJKtQ6O0fhalRJ4POnY88Ayew7fIXRes=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nAd3W/lBub2NkMZuoZT1koUs5wGW79QZQVrZ9jz1As1UWM2ADeDQOsDyB1t5Kfu9Vx/qlLivPXEghYRBlbm0KtjHccXecAhLDBfGjZNuXmJcRYJuKN5YIqjzOMQiYbugZAoxv162C7Zl+9phk6QCoDOcJ4vXp1FLA9W7gjhDKPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P06Dfi0p; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5dee1626093so6309307a12.1;
        Fri, 21 Feb 2025 09:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740158736; x=1740763536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mt6xfWZKFzy6o/w7cptGQJi/Nd1+VlAbNwsQ3sQVT6o=;
        b=P06Dfi0pd4r1xGm4HCSpPLRV7td1i+olmsdrQULFe051Bg2xdtdaJ6F1JljqzZB0Ju
         0bhh12OntPrJreqDDXL9vn5witcddQX0mLP/DMILua4Jj6qdcMvAp5xhkQkPlvC7X+8q
         96jUnMg0r9jZkjqRpeG8Nn2CTBF1Ajo/XENDx9eyI0fK2VKIU9+EKDxfKPeyrwSzHklL
         /7SPhS0I3esOlX2RIm+zbM3ahQl0sq9tzpdkHV7BSkCYgisEU/wX1BqcwAj1+Zv2Mml/
         wZqlWcAMjeqRgE1V3bAIbim6X9MnuDHj4ZiP2qAaO9YvMJbsrWfH1ap/4ngTLZ2ohsNg
         7vaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740158736; x=1740763536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mt6xfWZKFzy6o/w7cptGQJi/Nd1+VlAbNwsQ3sQVT6o=;
        b=I4xLpbllKM3WHA2h1m2OGuP34x4czRgLD+uUAEsS4uq+Y7jS5Bu8DZCUj3244gGcqn
         HMcYAQG7Xj1+4Hoe+Q1/wbOnP0DlpRkmV4khLr3leYCBSMZ7LRTLzdt52VXuuWzPWg1Y
         sTTzC0SlU+0TtntO5Fmc3JuI5whjtkDgHpiqFil02219zLzsZ/hKWHGEuP1Lb1IPAouf
         KIGgb1xsdLKHP6E6XWH4+xy9W/nRONx7NNhp/xtxZeSf83ecjwfIqfg3z61KfcyO0nhL
         H0D7XsV2AHCeqVFgMJDEEHjKN5U7LFO3OqY7Z6zPN+d3W4a0cGxJDXeJV9QqHQ3O2mfw
         bKpA==
X-Forwarded-Encrypted: i=1; AJvYcCUSWRUFtcgSN9GBQ3bZyXWstT30Swz7z+20U3x1FzlPgy7cw5dRisN52q29P9Gdsg+uyQEB3yGwhQ==@vger.kernel.org, AJvYcCVWZeom6qKq/2EeJicl6FU/5/oN1w0hp0f+PWuhVR+lCKK/yQQqjbWGWSXYqlpCK1J4uJnZ+DeTKpR4jcfxjw==@vger.kernel.org, AJvYcCWw6qfZis2hn50tiCiyFzmQcUg1km4rlcr3Iqb7m6/QVF6msOToWSmNXptCSU8AB5xb4KOZNhMcVWSWeuDq@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/SyOBynVntsLIlQAGVqBRvPDW7aloj+hNX2u8q7BVox84ZOG8
	SCofjyJnMQtM8mTmc7PWTXgBSrcFzQIKOqMBPGPNwyzemvJ5dbbSpjylG8huNHEsBnbfHo3QOx8
	GUmgrIEuF4irTY8hXxU85YywbQDrGvZSiRB4=
X-Gm-Gg: ASbGncvQ6nsj0WzCLSwa2yoRyCAkO/W+64OrH2YlkMrytf9cngTYC49T6Ye8YuY29iP
	u+yvx+l0d9mCI3lkrOawoh6vn8kIw9zQPGWhuWAQrISru2e6V3yda1g2esCEhQnVZsCr3o+hMqZ
	mdUJ1Y/pc=
X-Google-Smtp-Source: AGHT+IFoCWue0lioXG2ZyM8FG1Dpra6vwKZlw29QaoND/rP/jXqNXcr5SZt1dhKumSX57ytDqEnMlW0+uuJLY5Q+d64=
X-Received: by 2002:a17:906:380d:b0:abc:2aca:e5e1 with SMTP id
 a640c23a62f3a-abc2acae668mr27789166b.8.1740158735577; Fri, 21 Feb 2025
 09:25:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
 <db432e5b-fc90-487e-b261-7771766c56cb@bsbernd.com> <e0019be0-1167-4024-8268-e320fee4bc50@gmail.com>
 <CAOQ4uxiVvc6i+5bV1PDMcvS8bALFdp86i==+ZQAAfxKY6AjGiQ@mail.gmail.com> <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
In-Reply-To: <a8af0bfc-d739-49aa-ac3f-4f928741fb7a@bsbernd.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 21 Feb 2025 18:25:24 +0100
X-Gm-Features: AWEUYZmT2L1W8ibOnlZGVriYXu5FQq2RB5SjuEBMap_MwiVMS4ecV0w52p2KF4g
Message-ID: <CAOQ4uxiSkLwPL3YLqmYHMqBStGFm7xxVLjD2+NwyyyzFpj3hFQ@mail.gmail.com>
Subject: Re: [PATCH] Fuse: Add backing file support for uring_cmd
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Moinak Bhattacharyya <moinakb001@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2025 at 6:13=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 2/21/25 17:24, Amir Goldstein wrote:
> > On Fri, Feb 21, 2025 at 4:36=E2=80=AFPM Moinak Bhattacharyya
> > <moinakb001@gmail.com> wrote:
> >>
> >> Sorry about that. Correctly-formatted patch follows. Should I send out=
 a
> >> V2 instead?
> >>
> >> Add support for opening and closing backing files in the fuse_uring_cm=
d
> >> callback. Store backing_map (for open) and backing_id (for close) in t=
he
> >> uring_cmd data.
> >> ---
> >>   fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++=
++
> >>   include/uapi/linux/fuse.h |  6 +++++
> >>   2 files changed, 56 insertions(+)
> >>
> >> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >> index ebd2931b4f2a..df73d9d7e686 100644
> >> --- a/fs/fuse/dev_uring.c
> >> +++ b/fs/fuse/dev_uring.c
> >> @@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd =
*cmd,
> >>       return ent;
> >>   }
> >>
> >> +/*
> >> + * Register new backing file for passthrough, getting backing map fro=
m
> >> URING_CMD data
> >> + */
> >> +static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
> >> +    unsigned int issue_flags, struct fuse_conn *fc)
> >> +{
> >> +    const struct fuse_backing_map *map =3D io_uring_sqe_cmd(cmd->sqe)=
;
> >> +    int ret =3D fuse_backing_open(fc, map);
> >> +
> >
> > I am not that familiar with io_uring, so I need to ask -
> > fuse_backing_open() does
> > fb->cred =3D prepare_creds();
> > to record server credentials
> > what are the credentials that will be recorded in the context of this
> > io_uring command?
>
> This is run from the io_uring_enter() syscall - it should not make
> a difference to an ioctl, AFAIK. Someone from @io-uring please
> correct me if I'm wrong.
>
> >
> >
> >> +    if (ret < 0) {
> >> +        return ret;
> >> +    }
> >> +
> >> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> >> +    return 0;
> >> +}
> >> +
> >> +/*
> >> + * Remove file from passthrough tracking, getting backing_id from
> >> URING_CMD data
> >> + */
> >> +static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
> >> +    unsigned int issue_flags, struct fuse_conn *fc)
> >> +{
> >> +    const int *backing_id =3D io_uring_sqe_cmd(cmd->sqe);
> >> +    int ret =3D fuse_backing_close(fc, *backing_id);
> >> +
> >> +    if (ret < 0) {
> >> +        return ret;
> >> +    }
> >> +
> >> +    io_uring_cmd_done(cmd, ret, 0, issue_flags);
> >> +    return 0;
> >> +}
> >> +
> >>   /*
> >>    * Register header and payload buffer with the kernel and puts the
> >>    * entry as "ready to get fuse requests" on the queue
> >> @@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
> >> unsigned int issue_flags)
> >>               return err;
> >>           }
> >>           break;
> >> +    case FUSE_IO_URING_CMD_BACKING_OPEN:
> >> +        err =3D fuse_uring_backing_open(cmd, issue_flags, fc);
> >> +        if (err) {
> >> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=
=3D%d\n",
> >> +                    err);
> >> +            return err;
> >> +        }
> >> +        break;
> >> +    case FUSE_IO_URING_CMD_BACKING_CLOSE:
> >> +        err =3D fuse_uring_backing_close(cmd, issue_flags, fc);
> >> +        if (err) {
> >> +            pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=
=3D%d\n",
> >> +                    err);
> >> +            return err;
> >> +        }
> >> +        break;
> >>       default:
> >>           return -EINVAL;
> >>       }
> >> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> >> index 5e0eb41d967e..634265da1328 100644
> >> --- a/include/uapi/linux/fuse.h
> >> +++ b/include/uapi/linux/fuse.h
> >> @@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {
> >>
> >>       /* commit fuse request result and fetch next request */
> >>       FUSE_IO_URING_CMD_COMMIT_AND_FETCH =3D 2,
> >> +
> >> +    /* add new backing file for passthrough */
> >> +    FUSE_IO_URING_CMD_BACKING_OPEN =3D 3,
> >> +
> >> +    /* remove passthrough file by backing_id */
> >> +    FUSE_IO_URING_CMD_BACKING_CLOSE =3D 4,
> >>   };
> >>
> >
> > An anecdote:
> > Why are we using FUSE_DEV_IOC_BACKING_OPEN
> > and not passing the backing fd directly in OPEN response?
> >
> > The reason for that was security related - there was a concern that
> > an adversary would be able to trick some process into writing some fd
> > to /dev/fuse, whereas tricking some proces into doing an ioctl is not
> > so realistic.
> >
> > AFAICT this concern does not exist when OPEN response is via
> > io_uring(?), so the backing_id indirection is not strictly needed,
> > but for the sake of uniformity with standard fuse protocol,
> > I guess we should maintain those commands in io_uring as well.
>
> Yeah, the way it is done is not ideal
>
> fi->backing_id =3D do_passthrough_open(); /* blocking */
> fuse_reply_create()
>     fill_open()
>       arg->backing_id =3D f->backing_id; /* f is fi */
>
>
> I.e. there are still two operations that depend on each other.
> Maybe we could find a way to link the SQEs.

If we can utilize io_uring infrastructure to link the two
commands it would be best IMO, to keep protocol uniform.

> Or maybe easier, if the security concern is gone with IO-URING,
> just set FOPEN_PASSTHROUGH for requests over io-uring and then
> let the client/kernel side do the passthrough open internally?

It is possible, for example set FOPEN_PASSTHROUGH_FD to
interpret backing_id as backing_fd, but note that in the current
implementation of passthrough_hp, not every open does
fuse_passthrough_open().
The non-first open of an inode uses a backing_id stashed in inode,
from the first open so we'd need different server logic depending on
the commands channel, which is not nice.

Thanks,
Amir.

