Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECED5B19BF
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiIHKPA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiIHKO7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:14:59 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6B2220DF;
        Thu,  8 Sep 2022 03:14:57 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1274ec87ad5so28154024fac.0;
        Thu, 08 Sep 2022 03:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date;
        bh=As/kg0zWR0hyURQdFDAJ9z39WKwycUQL+ZOB/bkcic8=;
        b=n1OjXkaUH8Cq3ga7utl3wLG+60ssXM0gJ6f+OguBnIFEnlqWIMYYnQwaMzOd6JpZUS
         33wZxVzNht+vct3Xjv+o+ZNnlwGjvYjgGb0Tkp/NB5E1gKfaRfCrvbyPY0I/3S9cczXW
         86/7XqBRV87bcBYU+ZJUZlzqQmmAK3iG2hvvDayBUzAeNhvfLF8xPjU6Hz99Dmqg/r3R
         YpJZ52cF9GsMFdyPY6+gvxeyE1l041j9rsPHVFDSioRsHLwm5pFrgqG5/EUP9i90cdhG
         nxwH9npx/d6X2njFLTE8CMIayGxAvwVaT1gN+MlwvpgUgu96kt9oDlGW8+IzeGuI0+TQ
         5eGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=As/kg0zWR0hyURQdFDAJ9z39WKwycUQL+ZOB/bkcic8=;
        b=Q03s2KcR35NvIVsQOSLwZTxgbZU8U2m6dVaXeRrLAsjyLr/7Hbq0M4tjZH2V/saRD3
         YY37zmv2lMOgVrah4prZuigaabmvjRQwkKr0vgtA875ksiBmxFCmQEEW4o2jWhIoxLun
         Y5z48L4CxlT5dE1zp/xr3qsSZsti+IPjGxCPgBpIIUdfJnMRw1T0otpqtSVmm3UyYbAS
         vgNB68nk4xE4zp3z43WElEMYXWoOwG+zRLj1NuJEZZHF2dpKq4ZsWbOnEY7gBA3lDHm4
         entix5qaZkZnGj0UsxSbkZwy6L+tFggbrzEjMSG2HRGNuvka6dnhH0uWiOqNv91rB7FF
         +08Q==
X-Gm-Message-State: ACgBeo3QmbOanIB2OUQ18Pu2RQpaFEHEwnbzxPPOu4yoXDdhyFJJ4MD/
        AOnrAbf6MHKKyhn/e2NUW3elbgmhqxB6yIQRxrQ=
X-Google-Smtp-Source: AA6agR7qZsOs+LB6x5FuTdMEyKH400ILN+ShF0296FZ1+36MfqXuPGWJlGrC57Y99yABhgF9V+2aiPtR8ClS85TzhjM=
X-Received: by 2002:a05:6870:ea83:b0:fe:365f:cb9d with SMTP id
 s3-20020a056870ea8300b000fe365fcb9dmr1492168oap.98.1662632097244; Thu, 08 Sep
 2022 03:14:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-13-shr@fb.com>
In-Reply-To: <20220908002616.3189675-13-shr@fb.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 8 Sep 2022 11:14:21 +0100
Message-ID: <CAL3q7H7dM3tdbnLReyrX1Vm=43NdjTPXmRrhJF7nO=Uy3fyKDA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] btrfs: enable nowait async buffered writes
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 8, 2022 at 1:29 AM Stefan Roesch <shr@fb.com> wrote:
>
> Enable nowait async buffered writes in btrfs_do_write_iter() and
> btrfs_file_open().

This is too terse, see below.

>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/file.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index fd42ba9de7a7..887497fd524f 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2107,13 +2107,13 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, s=
truct iov_iter *from,
>         if (BTRFS_FS_ERROR(inode->root->fs_info))
>                 return -EROFS;
>
> -       if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIR=
ECT))
> -               return -EOPNOTSUPP;
> -
>         if (sync)
>                 atomic_inc(&inode->sync_writers);
>
>         if (encoded) {
> +               if (iocb->ki_flags & IOCB_NOWAIT)
> +                       return -EOPNOTSUPP;

The changelog should provide some rationale about why encoded writes
are not supported.

Thanks.

> +
>                 num_written =3D btrfs_encoded_write(iocb, from, encoded);
>                 num_sync =3D encoded->len;
>         } else if (iocb->ki_flags & IOCB_DIRECT) {
> @@ -3755,7 +3755,7 @@ static int btrfs_file_open(struct inode *inode, str=
uct file *filp)
>  {
>         int ret;
>
> -       filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC;
> +       filp->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WAS=
YNC;
>
>         ret =3D fsverity_file_open(inode, filp);
>         if (ret)
> --
> 2.30.2
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
