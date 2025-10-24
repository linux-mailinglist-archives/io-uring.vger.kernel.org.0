Return-Path: <io-uring+bounces-10184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 546CAC04488
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 05:50:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6BB9A34B118
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 03:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A83226E158;
	Fri, 24 Oct 2025 03:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IA6iWw6y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0D9273D7B
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 03:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761277796; cv=none; b=uwWDYYEXy5OebNSwzMpGc9g3EPbR8nfnzTwI2kFOUhXrtXE9PJZc3stF2+6iyXLIm5ZH2ivhFLX+BR7WnyecFSWVUjnlcYxngNlh66oL12Jd1dx+3021ZKr2mMECdJI83GPog99sEmTA3sp4TGRkBZfu5ZD39dFH4sbnTcAKxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761277796; c=relaxed/simple;
	bh=qmaB1CXtUY1e+C/t58DgmOYZlR8DAdBz6UTk8GaUBVY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cDPUlFPDC3WbreygzXtS3ajcNxttpPOV0RIjE1CAgwEWuIArJnWxa9adGpDmoKD42p0NmSWtkdieNqTxhEIEd45S7m6k/bjHoV16NQxi6fHi1fhzCa0VL69wpdPMaeyfcUKY7HLjV3A6W/k8cfc5P/0i7DC/OPH0A5lLlZxn5LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IA6iWw6y; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-26816246a0aso2210495ad.2
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 20:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761277792; x=1761882592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvoYolrDujURIIQNBp29WK1/vhNin2pPqJIBDrWNzE4=;
        b=IA6iWw6yVIbRiWEyNoiqiwosgLZ/KcAJtTQvoa+GTfyECyAZA2wF9FPTt66NyPMdEw
         QMqrT9zbQbFt1kKO4MW69O+AwuXp8d3lDCbz1HVqLa5Pp3Dm+jun9AK4g60iUm8hZlik
         KbIaiPuKp6aCFfLZ1GKBuw8gnGdp5BdpEBhrncin9Pj1AfijMkUnbM/Qmx0xUTeq7qMo
         Ul5zBINgV/n0pm9YtyCsxjqb9HwHy2NR9e0oA8WqpFSU4dexTIzk949K5GlGboqHEZ50
         WVZc/UU6VjgdMJfmXb3KfH11N0kzEN1ITmTluW1NJDTOhCfJx3Cdn6ZUrOGp2gy+tqCH
         Ptag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761277792; x=1761882592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvoYolrDujURIIQNBp29WK1/vhNin2pPqJIBDrWNzE4=;
        b=o0qT7OJhJ7VPXCCfSTRefI99jpgZP8V1dGGBcGHfAcVGl4XnjDwbqcK44SRJ2salM9
         Di6vLqr/PkA+gURTy5rTkg7P8JJOUzg7stgUwZlTp2uxf15KhS9vgHvd5H/29MzHlWk1
         L/WbXxwZFF9HIN0IRKkLPwkNbEfph93n0ofUFPAZQLQ9bTOBMJfQ6fNcLjyXox90uonj
         N1TzMEhxLJBN3TeApw2I+NP0flnH76Vk0fKkYTs1G8zGj4BQ+7RMVaNFOQw1z4paLO1w
         L5PzOODIHgo6g+6zFIF5ck1bNOpvZrV59Fz12Bewv0HF3Rl/6P2Qpj3kxGUhk/lIZVoj
         9xNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu4nKvhpR1SRmxdSGy7LF/XcBWpSzS1R1wYs3VGp6CAAy7fq9mIcPbbpRSd8SHz1Zx3PfrgcWOJA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5YRPSUN/XHS4kl69s5POmUK0SseySsDiJFwDyktxKwxOk3A0c
	kEslCpCgBEjLKfrAt8sDjhTGJI2r7ALFVsDl/eUIDqHdz2BZ1Eb52zEVH+2wrd29ewrYeuM8sr9
	qNq2BvJcwObgYlAwosZRJfhsJrTTd6RsY+3Ns9WzaNg==
X-Gm-Gg: ASbGncvP73XiM50RHIFhi2y6fsO7YtVJ4Wpj2VCp9Gl1wxCDoU6E5f6e4CV99FExYao
	NFT0fsldYbUCt2C0FYqlUZ0M9qYgzNF3C0d1tyzA2FfR23eNSSZttrajk6kG+6+6IFVFo1rvMkp
	MQWvJoc2wJa4qLn6qg4/puwS3kTO1rt8mj+70Ak1QEJkJAYlIhVMeLGVwg/ma4MeHmGllOfBRZN
	A6v5Sa/c5aBcb5YS4TAYL+G+wFZr5FK39tmRu2jRzq4MhrNODGP0+ESB7o7L0+PIfDMKFgjOH4/
	WNX23pHMXdhGLsd7rrzMy2tO6G9X
X-Google-Smtp-Source: AGHT+IGVLYN9Qj6K5Oe/DW7c2O9tXpDx7qrMeaGk8fBmXzVZ28GOkgKOMdnoBQ6ElA4mEZO6qJsf1CoAlmZoTYuCH80=
X-Received: by 2002:a17:903:2a8d:b0:27e:eee6:6df2 with SMTP id
 d9443c01a7336-292d3fb7f47mr85578795ad.7.1761277792499; Thu, 23 Oct 2025
 20:49:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251023201830.3109805-1-csander@purestorage.com>
 <20251023201830.3109805-4-csander@purestorage.com> <aPr1i-k0byzYjv8G@fedora>
In-Reply-To: <aPr1i-k0byzYjv8G@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 23 Oct 2025 20:49:40 -0700
X-Gm-Features: AS18NWDTISZzm2iqXdmRxUGBIwGGbwvM87S0nOqV0xhWOuEGVlx6sx6Z4Yq4U7g
Message-ID: <CADUfDZp21icTKrWHcgRTfmsxtdab85b6R75wAYXW2dA+dzXmoA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] io_uring/uring_cmd: avoid double indirect call in
 task work dispatch
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>, Keith Busch <kbusch@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 23, 2025 at 8:42=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Thu, Oct 23, 2025 at 02:18:30PM -0600, Caleb Sander Mateos wrote:
> > io_uring task work dispatch makes an indirect call to struct io_kiocb's
> > io_task_work.func field to allow running arbitrary task work functions.
> > In the uring_cmd case, this calls io_uring_cmd_work(), which immediatel=
y
> > makes another indirect call to struct io_uring_cmd's task_work_cb field=
.
> > Define the uring_cmd task work callbacks as functions whose signatures
> > match io_req_tw_func_t. Define a IO_URING_CMD_TASK_WORK_ISSUE_FLAGS
> > constant in io_uring/cmd.h to avoid manufacturing issue_flags in the
> > uring_cmd task work callbacks. Now uring_cmd task work dispatch makes a
> > single indirect call to the uring_cmd implementation's callback. This
> > also allows removing the task_work_cb field from struct io_uring_cmd,
> > freeing up some additional storage space.
>
> The idea looks good.
>
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >  block/ioctl.c                |  4 +++-
> >  drivers/block/ublk_drv.c     | 15 +++++++++------
> >  drivers/nvme/host/ioctl.c    |  5 +++--
> >  fs/btrfs/ioctl.c             |  4 +++-
> >  fs/fuse/dev_uring.c          |  5 +++--
> >  include/linux/io_uring/cmd.h | 16 +++++++---------
> >  io_uring/uring_cmd.c         | 13 ++-----------
> >  7 files changed, 30 insertions(+), 32 deletions(-)
> >
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index d7489a56b33c..5c10d48fab27 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -767,13 +767,15 @@ long compat_blkdev_ioctl(struct file *file, unsig=
ned cmd, unsigned long arg)
> >  struct blk_iou_cmd {
> >       int res;
> >       bool nowait;
> >  };
> >
> > -static void blk_cmd_complete(struct io_uring_cmd *cmd, unsigned int is=
sue_flags)
> > +static void blk_cmd_complete(struct io_kiocb *req, io_tw_token_t tw)
> >  {
> > +     struct io_uring_cmd *cmd =3D io_kiocb_to_cmd(req, struct io_uring=
_cmd);
> >       struct blk_iou_cmd *bic =3D io_uring_cmd_to_pdu(cmd, struct blk_i=
ou_cmd);
> > +     unsigned int issue_flags =3D IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;
>
> Now `io_kiocb` is exposed to driver, it could be perfect if 'io_uring_cmd=
'
> is kept in kernel API interface, IMO.

You mean change the io_req_tw_func_t signature to pass struct
io_uring_cmd * instead of struct io_kiocb *? I don't think that would
make sense because task work is a more general concept, not just for
uring_cmd. I agree it's a bit ugly exposing struct io_kiocb * outside
of the io_uring core, but I don't see a way to encapsulate it without
other downsides (the additional indirect call or the gross macro from
v1). Treating it as an opaque pointer type seems like the least bad
option...

>
> ...
>
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index b84b97c21b43..3efad93404f9 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -9,18 +9,13 @@
> >  /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
> >  #define IORING_URING_CMD_CANCELABLE  (1U << 30)
> >  /* io_uring_cmd is being issued again */
> >  #define IORING_URING_CMD_REISSUE     (1U << 31)
> >
> > -typedef void (*io_uring_cmd_tw_t)(struct io_uring_cmd *cmd,
> > -                               unsigned issue_flags);
> > -
> >  struct io_uring_cmd {
> >       struct file     *file;
> >       const struct io_uring_sqe *sqe;
> > -     /* callback to defer completions to task context */
> > -     io_uring_cmd_tw_t task_work_cb;
> >       u32             cmd_op;
> >       u32             flags;
> >       u8              pdu[32]; /* available inline for free use */
>
> pdu[40]

I considered that, but wondered if we might want to reuse the 8 bytes
for something internal to uring_cmd rather than providing it to the
driver's uring_cmd implementation. If we increase pdu and a driver
starts using more than 32 bytes, it will be difficult to claw back. It
seems reasonable to reserve half the space for the io_uring/uring_cmd
layer and half for the driver.

Best,
Caleb

>
>
>
> Thanks,
> Ming
>

