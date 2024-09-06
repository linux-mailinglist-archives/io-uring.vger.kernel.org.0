Return-Path: <io-uring+bounces-3073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AA9096FC16
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 21:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9285F1F24773
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 19:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1751C86FB;
	Fri,  6 Sep 2024 19:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIp6jb8q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BC1B85D5;
	Fri,  6 Sep 2024 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725650627; cv=none; b=K+1nCHQ3ZzIEaG6dwhA7Ub82W/nHioDl6w+Fm9kqwzm/IBEyc20ZO67Di1g3nw0bI0gwZ1WC6yqlO6UsQNAyjm9ZwIFUDJTLKgk2luqKCE3L7HEErMjpygVTCaGy9yX5vbovTCWoAYcDgAbqir6R10a66gbbZ6n8wIxe4cgGU9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725650627; c=relaxed/simple;
	bh=nxAr7Ei1WYwKengUI4zeD4NH55sooGUwgYSIlh7xkHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ubdYgiR+89xbGoKTg+uA6tk/87UnfHHaSzIeKV5hG8qyd2+UwjuiIVqCESGeFpraM0eB0YOHJD4xwvNfN8rM2S/cesjathQXWJ2MZ7aeRsRLA9DNRW+y/vxLb/oDKSDeyhvJZcXiUdjH6BeGAM4mJasJwerOCpniU3o7ceovGro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TIp6jb8q; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-70941cb73e9so1321388a34.2;
        Fri, 06 Sep 2024 12:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725650625; x=1726255425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCQTDySUr/h//BFALqT2v4C/WCXPyTterg1sfGPAVlc=;
        b=TIp6jb8qWILX/dBFb9TNUAugL7/Icg/E0DcMQBN3Qzren8a6ddhigvBPK7tn70PVlC
         0JusJcS57ZbNwlKgh6TdliklWmH+dqm5WCuE8tDcyzM5GU7WJe75Dpq9FoFICRMYfzMV
         4jMpWTYgtL2o8Jce/F+LVorjAfvU0AorngmBj8LrfqiX1JVw5lFufQBFDAzXwLvtjtCp
         znV+sxVZ8P5+5sM1OYvf1dtn4y6sUIZ1NYQs+j9T0LLgUud23//rH9OY4Me/WHGwBoGV
         QaurlpBdmCwH44NYM78O/rBnjFPyr6emd38AI5thIbXW5odvoE20/96WSg5LHj/zOB01
         Q75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725650625; x=1726255425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CCQTDySUr/h//BFALqT2v4C/WCXPyTterg1sfGPAVlc=;
        b=RJypdOBhBiPR4h96QVOqOfaGAqi9IDV5adqarmHDU+He0qNBQL/v63ggTEhqcz4b/v
         HFgowxc2sQbl5KunA1WYHA3AkSX9j9YSo8LfQxwwqLTbFmG7xXZkixC/D/6OBB5XWb6+
         1xPAfNz3bCq4IkzCAzuCKoXC+gkzva8XGCUrHKawRM05bFkMAiP2Le/jcuB/NrURlxEz
         8xd0VSCiTzMZ2nRxPw4hppzKM1uCJnEBSP9RIFIvRZS244AvzdvrZAJDHZWHOsWNBAZu
         QJku8Fpcr2gAQBSIfHaEx1gwxMiwmSrC0TWbOy8yjwQIk9dEAaed9QJBm51YYkZTF4Fy
         CkQg==
X-Forwarded-Encrypted: i=1; AJvYcCVCZNGnQ7zftaKuvz31WmmtxJp78Skn3ah4CsKT/BiSsbNSKgjj3cKt34FJpnlqMkk/jM4+YxRlvSidjF0uwA==@vger.kernel.org, AJvYcCWKdpkTRwBK41Siv0iEwZD2pSDle44QfdLxoFzJsIISX+ukRvmuSw4Ei1l94L6zTLRA06agr2mlcA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/1Y1acJofPXiGRdv9mwbvPc+BKqLWM2oxrdXih0tZ9ehYVAot
	3wVp2t3J7jBVYseFDWwQVgJwMvzKFkEkBFYPCwJGTOi7Tf0fnw38zOlXdxq2XwXIKpweCTzvHBK
	m3iX8x3qipaXX+K3auJUxdH1Gm6dp4A==
X-Google-Smtp-Source: AGHT+IG5raLeH6/DSrLHLG4mXHFBnQ809c/rzp6ulmATVYQpIyYWV3pgFYipnMQaMWVWkSdJq/2PlTIBMGhYJw2wMpc=
X-Received: by 2002:a05:6830:7102:b0:709:4882:d001 with SMTP id
 46e09a7af769-710cc21cc90mr4869209a34.9.1725650625265; Fri, 06 Sep 2024
 12:23:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-0-9207f7391444@ddn.com>
 <20240901-b4-fuse-uring-rfcv3-without-mmap-v3-5-9207f7391444@ddn.com>
 <CAJnrk1am+s=z2iDcdQ9vXrTvo3wAXH9UE57BpXAovOqdNdYKHg@mail.gmail.com> <4a0ac578-48fd-4c46-88c1-713f1720e771@fastmail.fm>
In-Reply-To: <4a0ac578-48fd-4c46-88c1-713f1720e771@fastmail.fm>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 6 Sep 2024 12:23:34 -0700
Message-ID: <CAJnrk1ZNZh1xT9dOkCMhJ2Np9BB8knPuKofruy5dFiovzfrhRQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 05/17] fuse: Add a uring config ioctl
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, bernd@fastmail.fm, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 3:24=E2=80=AFPM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
> On 9/4/24 02:43, Joanne Koong wrote:
> > On Sun, Sep 1, 2024 at 6:37=E2=80=AFAM Bernd Schubert <bschubert@ddn.co=
m> wrote:
> >>
> >> This only adds the initial ioctl for basic fuse-uring initialization.
> >> More ioctl types will be added later to initialize queues.
...
> >
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       if (rcfg->nr_queues > 1 && rcfg->nr_queues !=3D num_present_cp=
us()) {
> >
> > Will it always be that nr_queues must be the number of CPUs on the
> > system or will that constraint be relaxed in the future?
>
> In all my testing performance rather suffered when any kind of cpu switch=
ing was involved. I guess we should first find a good reason to relax it an=
d then need to think about which queue to use, when a request comes on a di=
fferent core. Do you have a use case?

Ah, gotcha. I don't have a use case in mind, just thought it'd be
common for some users to want more than 1 queue but not as many queues
as they have cores. This could always be added later in the future
though if this use case actually comes up.

>
> >> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> >> index 6c506f040d5f..e6289bafb788 100644
> >> --- a/fs/fuse/fuse_dev_i.h
> >> +++ b/fs/fuse/fuse_dev_i.h
> >> @@ -7,6 +7,7 @@
> >>  #define _FS_FUSE_DEV_I_H
> >>
> >>  #include <linux/types.h>
> >> +#include <linux/fs.h>
> >
> > I think you accidentally included this.
> >
>
> When I remove it:
>
> bschubert2@imesrv6 linux.git>make M=3Dfs/fuse/
>   CC [M]  fs/fuse/dev_uring.o
> In file included from fs/fuse/dev_uring.c:7:
> fs/fuse/fuse_dev_i.h:15:52: warning: declaration of 'struct file' will no=
t be visible outside of this function [-Wvisibility]
> static inline struct fuse_dev *fuse_get_dev(struct file *file)
>                                                    ^
> fs/fuse/fuse_dev_i.h:21:9: error: call to undeclared function 'READ_ONCE'=
; ISO C99 and later do not support implicit function declarations [-Wimplic=
it-function-declaration]
>         return READ_ONCE(file->private_data);
>                ^
> fs/fuse/fuse_dev_i.h:21:23: error: incomplete definition of type 'struct =
file'
>         return READ_ONCE(file->private_data);
>                          ~~~~^
>
>
> I could also include <linux/fs.h> in dev_uring.c, but isn't it cleaner
> to have the include in fuse_dev_i.h as it is that file that
> adds dependencies?
>

You're totally right, I had missed that this patch adds in a new
caller of this header (dev_uring.c) - sorry for the noise!

> >>
...
> >> +
> >>  #endif /* _LINUX_FUSE_H */
> >>
> >> --
> >> 2.43.0
> >>
>
> I will get it all fixed later this week! I will also review my own
> patches before v4, I just wanted to get v3 out asap as it was already
> taking so much time after v2.
>

Gotcha, I'll wait until v4 to review the other patches in this set then.

Excited to follow all the progress on this!


Thanks,
Joanne

>
> Thanks,
> Bernd
>

