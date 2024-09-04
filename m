Return-Path: <io-uring+bounces-3042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 221D496CA91
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 00:42:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC8B2856E0
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 22:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C87B1547D8;
	Wed,  4 Sep 2024 22:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmZCB/GL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8439B146D7F;
	Wed,  4 Sep 2024 22:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725489763; cv=none; b=rejoWBuIUIjUXqgP0wSxk2jrnFHAg4D49HpLEfmsJaOtWixXULarJMYt0FEMfo895J19g63P77UXX/OqT7ZS4wNCQw3cj6jnQIbCr3pK2TJovwBcAilLiaGv/v7hQi8ouAxSb3aG/dmfetmU1xG+T3Xzdd0NI8X9Af4KkViwpkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725489763; c=relaxed/simple;
	bh=BaQB16NB/k9Tiie9stwiXzFIzg7qOr3xb+0kCHiNJSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=THFnubVvCV/U54Dv3na6YrdL2UcFAuaCucqPKyPG7idgpNY2blhg+dLGCNqPUAcQZu/sRwNfwQfRPbTN8IO/9ckcEu2bWXmASEehnTvOtDqI3P3yn5nNeZSahhsRsTtijGRDPjG2jffn6F/YihX+f3aMMIRI8D0QGuK4ndNDatE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dmZCB/GL; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-70f660d2250so113637a34.2;
        Wed, 04 Sep 2024 15:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725489760; x=1726094560; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+mektUzQBdm6uPClAx253nsA9fFydOLeVVxOQq508B0=;
        b=dmZCB/GLbfWzeySuVgFSPys8eJoxka1kOolnl+MGa7F6EvBkAJDJbnxZ8CYoODu52Z
         P3G3Z9sVbtA/2M0cqZ2BVlB/G4s3SDvdimm03UHwM4fjTdzQAGEBphgyfRWkpG9TrA0V
         P2nQRvV1PXxl1oI3XfOiyNr73LU2N3AR+MRxP4fjmBATtdWoJE8OFwQrWNMQE/rdUnB4
         lkJR+/mVWH4XoCL/Lr58ORmkBU8ARamo6birBrtWTa3O8qDnxF1Lpfc9vNPKCFpg0pmi
         +K9CNJg2CkramaNJKg05jyont2AMJn7m7FRyvCQGzLgHidoiYRBelYUZruSbRl92h1o2
         2cGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725489760; x=1726094560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+mektUzQBdm6uPClAx253nsA9fFydOLeVVxOQq508B0=;
        b=A8PloCFmVVw9DpiVD3lwjxLztT240qiD6OMczQpiKKY4P48mWP48u5V2T9YGNyNw6h
         3WpoE71NLPWgpswcp+4C3g4BsljuGDRUJ6udEuwPWUWLRQvpdqp7jYjj+Czi/KbXfz8d
         qIrTdvYrFyCAqIN4w3z5ifoHWS2UbEudO6UvCWEWyO2uSLJYQgt6Xcn5rmuMBcA1DEI0
         KsuJm8Km4WiMjtsWj/7WYNVRTu0JbxjBCPAJ/tH0BcoWYtsNviD6+KWoXY/TOXqc71G/
         tWdQDmsXIwxDsjZCabLwHodJTG6rGQHAs5/S0cOQXyU1skJPNsfxw8Hxr7M0sUVxleOn
         nGAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPWpWTiz+cVvmMDD2ltrW4SYAKsejUS3k0XO7gfKKFI5yUrm4WZri1+c+zy+go2SE9GL91Uig9zB511vDA/w==@vger.kernel.org, AJvYcCWCIAftR5qDpeRUCGEX08UStueV6BJOnhhHLHpdYwXe7hcq3mnzQ64Svtc2Q7MC5lKdNydkRq/IRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjxoTNC/Yrja6tnphQbhatVGu4wEmVevvy6ngfnvxNdDG7uEAY
	hv3FgGBjDnliVdOXm+bE1UVB0j3/KPNUoZn5yuUWFswYZXou6v2121aKG53r65Sn37Uy7zNOdiw
	QzVYktlX7+4K1OHsQc7ESXx2FIqU=
X-Google-Smtp-Source: AGHT+IHAlsNxdiNNIyhc2IMbBF4c9+XJ4kSYdKYkM8KfJRsXlT+I04Rh1bNA7mq0Uao3qEeUlPcvMUVsfsxFzKa41po=
X-Received: by 2002:a05:6830:919:b0:710:a5e7:7ed7 with SMTP id
 46e09a7af769-710a5e78162mr10807452a34.32.1725489760595; Wed, 04 Sep 2024
 15:42:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-6-9207f7391444@ddn.com>
 <CAJnrk1aFcDyJJ5rP1LFkpyUPHkzDv_bcOMPW2m28ZBS8T+WmUA@mail.gmail.com> <b1e2d60b-477a-4320-acea-df83eec21b77@fastmail.fm>
In-Reply-To: <b1e2d60b-477a-4320-acea-df83eec21b77@fastmail.fm>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 4 Sep 2024 15:42:29 -0700
Message-ID: <CAJnrk1b8dSf3RagLZ3NnKRs6CJTB1zr0ZdAPwJLkKnQ_qPU+TA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 06/17] fuse: Add the queue configuration ioctl
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 3:38=E2=80=AFPM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
> On 9/5/24 00:23, Joanne Koong wrote:
> > On Sun, Sep 1, 2024 at 6:37=E2=80=AFAM Bernd Schubert <bschubert@ddn.co=
m> wrote:
> >>
> >> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> >> ---
> >>  fs/fuse/dev.c             | 30 ++++++++++++++++++++++++++++++
> >>  fs/fuse/dev_uring.c       |  2 ++
> >>  fs/fuse/dev_uring_i.h     | 13 +++++++++++++
> >>  fs/fuse/fuse_i.h          |  4 ++++
> >>  include/uapi/linux/fuse.h | 39 ++++++++++++++++++++++++++++++++++++++=
+
> >>  5 files changed, 88 insertions(+)
> >>
> >> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> >> index 6489179e7260..06ea4dc5ffe1 100644
> >> --- a/fs/fuse/dev.c
> >> +++ b/fs/fuse/dev.c
> >> @@ -2379,6 +2379,33 @@ static long fuse_dev_ioctl_backing_close(struct=
 file *file, __u32 __user *argp)
> >>         return fuse_backing_close(fud->fc, backing_id);
> >>  }
> >>
> >> +#ifdef CONFIG_FUSE_IO_URING
> >> +static long fuse_uring_queue_ioc(struct file *file, __u32 __user *arg=
p)
> >> +{
> >> +       int res =3D 0;
> >> +       struct fuse_dev *fud;
> >> +       struct fuse_conn *fc;
> >> +       struct fuse_ring_queue_config qcfg;
> >> +
> >> +       res =3D copy_from_user(&qcfg, (void *)argp, sizeof(qcfg));
> >> +       if (res !=3D 0)
> >> +               return -EFAULT;
> >> +
> >> +       res =3D _fuse_dev_ioctl_clone(file, qcfg.control_fd);
> >
> > I'm confused how this works for > 1 queues. If I'm understanding this
> > correctly, if a system has multiple cores and the server would like
> > multi-queues, then the server needs to call the ioctl
> > FUSE_DEV_IOC_URING_QUEUE_CFG multiple times (each with a different
> > qid).
> >
> > In this handler, when we get to _fuse_dev_ioctl_clone() ->
> > fuse_device_clone(), it allocates and installs a new fud and then sets
> > file->private_data to fud, but isn't this underlying file the same for
> > all of the queues since they are using the same fd for the ioctl
> > calls? It seems like every queue after the 1st would fail with -EINVAL
> > from the "if (new->private_data)" check in fuse_device_clone()?
>
> Each queue is using it's own fd - this works exactly the same as
> a existing FUSE_DEV_IOC_CLONE - each clone has to open /dev/fuse on its

Ah gotcha, this is the part I was missing. I didn't realize the
expectation is that the server needs to open a new /dev/fuse for each
queue. This makes more sense to me now, thanks.

> own. A bit a pity that dup() isn't sufficient. Only difference to
> FUSE_DEV_IOC_CLONE is the additional qid.
>
> >
> > Not sure if I'm missing something or if this intentionally doesn't
> > support multi-queue yet. If the latter, then I'm curious how you're
> > planning to get the fud for a specific queue given that
> > file->private_data and fuse_get_dev() only can support the single
> > queue case.
>
>
> Strictly in the current patch set, the clone is only needed in the
> next patch
> "07/17] fuse: {uring} Add a dev_release exception for fuse-over-io-uring"
> Though, since we have the fud anyway and link to the ring-queue, it makes
> use of it in
> 08/17] fuse: {uring} Handle SQEs - register commands
>
> in fuse_uring_cmd().
>
>
> I hope I understood your question right.
>
>
> Thanks,
> Bernd

