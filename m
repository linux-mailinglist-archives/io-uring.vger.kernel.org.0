Return-Path: <io-uring+bounces-1614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77A568AE5CB
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 14:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A98DC1C232E5
	for <lists+io-uring@lfdr.de>; Tue, 23 Apr 2024 12:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85C7384FB9;
	Tue, 23 Apr 2024 12:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSYknlkw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7428405D
	for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 12:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713874561; cv=none; b=pFowDC/D3yxYGZVbJg3cj1jhvPXW4FuvHM4Ww6hwFpolRJGzvL5eJLd+ksgaVs6zu3TdQ7Xd34dHzfQ+bgCNSsv1qbk3aSyNg+mDpIDRX0dr28MzPhSwRTiJV/0YLf9Y3F+8j0EZJ48mSlLg43ivNYpzwyYjeeWuNdRMRntRSJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713874561; c=relaxed/simple;
	bh=QC2ouizcJ9dYUrONicKYHEJkHE0MxCOhqth2084tqMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqQlbLlMRiXKvR8f3c2DmMyRvloSijsB+haTsDs/1X8aeRzoM10pri2G8zAmQ+4OxG1qaFY/1gOT2o1Ic1PaC/MCh1mfKdm5dSgoCYSDJcZW/BjlD+ytA9fOW+MxmHFZXSgxM3iE6zwYQJYbTeGMBEecZ7WZIf3gJ69MNvTdK/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DSYknlkw; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4dac5a3fbeaso1639951e0c.3
        for <io-uring@vger.kernel.org>; Tue, 23 Apr 2024 05:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713874559; x=1714479359; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kNQFAreKBrq7fsko6MzRtIE4Sxr1BvmMry6ptQlAFo=;
        b=DSYknlkwHKLq9rJwjKk0AJsAlBhC/P6jM+zRHMHfnq4KeXAx0QP9iiD+AO97K7bJv7
         jZ4xNZ/XpHIqPGcHanrIISrDBYO9Vh6nnR0tJqr1p1KQir7uSETPxSmKZ7slbiaKhYha
         Crwol5us0IkxQwOUJZ2cC+D+zLhd1PE5wd6jJLvx/XImMBy+X6ENp8QK0FGuVocWI9jK
         Hjz7XlqZSJqKkzniXM8pNEU3h2xFLKUu3req5oYqrWM9N3Ahdcfc/vS6l19gV3xPXZGX
         IBPTAGSLvjT38XUdpe/yhsOJjoFCKOyHHUpeI6H6ATV+ItpjowjvSVUfSHozkR2y1Ezt
         CPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713874559; x=1714479359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kNQFAreKBrq7fsko6MzRtIE4Sxr1BvmMry6ptQlAFo=;
        b=kC0bpsnEfnderee5FMGV1khq7xdIz8RoD1WeEuFz24MhmaDQ6FENtPL11EanGF9aOQ
         oLqstRDmnuvoS3MRUD+oMxavc2AyrXJOI9jVfmglnmFwKHfOHmHiCUkCnoX4UgyTAMPG
         OZY4C4PppVjhvLKdQW5Ot/3Ov5WjnoighpGhxW0PFxbtJHFbOjdT258vqgesBUY/epgT
         jPX1qtXT1BE3wQpmk17V/mckIO6iNJ3Ox6l+dEdPfBb8dRjAflQ5ywg2kId3G35sqFHz
         emFMkR+EI4P95K2dZFfVUPhLj0daPouzyncIl8s26nBSw55SgfritwYIdcXWLuRzHdxJ
         vxhg==
X-Forwarded-Encrypted: i=1; AJvYcCUYnGEdBFa8EIuk5YWeI1OfwRFZepESOO0/euJZz4Och0JDPsFXYtvsA+T+8Fs6hDMK31RalBCuVjq+wfL+Zmnvyol/0yhO39g=
X-Gm-Message-State: AOJu0YzKKYNLJB7hEcjguM/8dzc+z9sg4PZqFj3vltgSj4un1ztZ3BrK
	5uN7Q+z8U8JW8j5+fPA0US/7vv7lLXzKGMI1lnlzBH3dz05JBqsuwb6895ZoQexwsPPOFCFgpoE
	q0zFQGlzNZCFiA48X8YQ3xUhQCQ==
X-Google-Smtp-Source: AGHT+IHPxvcP+Rxasm8LgccQis6OvxQcyzALW6yOgk85rGtHMf1L6V4SmohHPVFVjBlI+UzMiOUcT+2tqbPEelxZki8=
X-Received: by 2002:a05:6122:3115:b0:4d4:32e1:e7b4 with SMTP id
 cg21-20020a056122311500b004d432e1e7b4mr10143569vkb.4.1713874558597; Tue, 23
 Apr 2024 05:15:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947@epcas5p4.samsung.com>
 <20240422133517.2588-1-anuj20.g@samsung.com>
In-Reply-To: <20240422133517.2588-1-anuj20.g@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 23 Apr 2024 17:45:20 +0530
Message-ID: <CACzX3Au4soZos3cHwW1zJNsBB8D7c5VQ-1fGmMCYuQPwV_UV7g@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rw: ensure retry isn't lost for write
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 11:19=E2=80=AFPM Anuj Gupta <anuj20.g@samsung.com> =
wrote:
>
> In case of write, the iov_iter gets updated before retry kicks in.
> Restore the iov_iter before retrying. It can be reproduced by issuing
> a write greater than device limit.
>
> Fixes: df604d2ad480 (io_uring/rw: ensure retry condition isn't lost)
>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  io_uring/rw.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 4fed829fe97c..9fadb29ec34f 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1035,8 +1035,10 @@ int io_write(struct io_kiocb *req, unsigned int is=
sue_flags)
>         else
>                 ret2 =3D -EINVAL;
>
> -       if (req->flags & REQ_F_REISSUE)
> +       if (req->flags & REQ_F_REISSUE) {
> +               iov_iter_restore(&io->iter, &io->iter_state);
>                 return IOU_ISSUE_SKIP_COMPLETE;
> +       }
>
>         /*
>          * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
> --
> 2.25.1
>

Looking more into it, no write happens incase of retry. This is because
the first call to blkdev_direct_write advances the iter and updates the
count to 0. Since the I/O needs to be split, retry handling gets triggered.
We don't restore the iter, and the retry happens with count=3D0. Hence NO I=
/O.
This doesn't happen incase of read, as blkdev_read_iter reverts the iter,
and restores the right count value back[3].

NVMe device limit [1]
Fio command used[2]

[1]
#cat /sys/block/nvme0n1/queue/max_hw_sectors_kb
512

[2]
fio -iodepth=3D1 -rw=3Dwrite -direct=3D1 -ioengine=3Dio_uring -bs=3D1M -num=
jobs=3D1 \
-offset=3D0 -size=3D1M -group_reporting -filename=3D/dev/nvme0n1 -name=3Dio=
_uring

[3]
static ssize_t blkdev_read_iter(struct kiocb iocb, struct iov_iterto)
{
        if (iocb->ki_flags & IOCB_DIRECT) {
                ret =3D blkdev_direct_IO(iocb, to);
                if (ret >=3D 0) {
                        iocb->ki_pos +=3D ret;
                        count -=3D ret;
                }
                iov_iter_revert(to, count - iov_iter_count(to));
                if (ret < 0 || !count)
                        goto reexpand;

