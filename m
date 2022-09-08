Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCB65B19C8
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiIHKRi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIHKRh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:17:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAE4B2776;
        Thu,  8 Sep 2022 03:17:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CE8061C22;
        Thu,  8 Sep 2022 10:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A90C433B5;
        Thu,  8 Sep 2022 10:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632255;
        bh=WdsPjLSIs54p8FRw+3ahrbrME4jbmeaKHKXaX+FnNbc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TvgNquWipvGtG35REy2yhh75DJVBr5/b/uNHQLXG9AzBR+BBHbXSEPvds96SEyGFC
         6iPUeVaYIS2BCbtzZAHGIgjuHZguqqL22CItKcrtCZ0giuCIfODYnNlwACNueBumgp
         HBqCaayclslZEt3FXOjL02FwcdhJ0VelGrh6sHZEbp2DlNDatN6I9ON1EcNhY1SsAZ
         Tg41MvVv8YPQGxtLiIokrJWbZ0wLpI7zt5SxvAB+5IL9+zbwwLiwKgIa+Tsa95SDcM
         h1GbaiuNEJASg49SohDrkL6qSa6H+KE+mSs4HLYiS2iumytJlJPH5iBbbRThErr/tk
         +oIfPp3S5R/+A==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-127f5411b9cso11715471fac.4;
        Thu, 08 Sep 2022 03:17:35 -0700 (PDT)
X-Gm-Message-State: ACgBeo2ufo8sbg85CvuxMS6mRqgKDgeP0OHTZoUaj86lN322NFBa2kYW
        3Fbsu4mNxmk6Wblu6AW4xlMvoL/BaPhGDnKi2KI=
X-Google-Smtp-Source: AA6agR7qxRxphmI1M+ilHIpHsy5UABKzZMAI4lTnf7LNpXRM08EaqxZLq9+YMWn0SAkT9XoH9nK2aYmVD7WlS9AkpEA=
X-Received: by 2002:a05:6808:308c:b0:343:53c7:fbbb with SMTP id
 bl12-20020a056808308c00b0034353c7fbbbmr1141289oib.98.1662632254943; Thu, 08
 Sep 2022 03:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-10-shr@fb.com>
In-Reply-To: <20220908002616.3189675-10-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:16:58 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5Pij0A5G9vEFHKrgUSQuhUA8U6Eh9oAhKRcjeex19U=Q@mail.gmail.com>
Message-ID: <CAL3q7H5Pij0A5G9vEFHKrgUSQuhUA8U6Eh9oAhKRcjeex19U=Q@mail.gmail.com>
Subject: Re: [PATCH v2 09/12] btrfs: btrfs: plumb NOWAIT through the write path
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 8, 2022 at 1:26 AM Stefan Roesch <shr@fb.com> wrote:
>
> We have everywhere setup for nowait, plumb NOWAIT through the write path.

Note, there's a double "btrfs: " prefix in the subject line.

>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/file.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 4e1745e585cb..6e191e353b22 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1653,8 +1653,9 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>         bool force_page_uptodate = false;
>         loff_t old_isize = i_size_read(inode);
>         unsigned int ilock_flags = 0;
> +       bool nowait = iocb->ki_flags & IOCB_NOWAIT;

Can be made const.

Thanks.

>
> -       if (iocb->ki_flags & IOCB_NOWAIT)
> +       if (nowait)
>                 ilock_flags |= BTRFS_ILOCK_TRY;
>
>         ret = btrfs_inode_lock(inode, ilock_flags);
> @@ -1710,17 +1711,22 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>                 extent_changeset_release(data_reserved);
>                 ret = btrfs_check_data_free_space(BTRFS_I(inode),
>                                                   &data_reserved, pos,
> -                                                 write_bytes, false);
> +                                                 write_bytes, nowait);
>                 if (ret < 0) {
>                         int tmp;
>
> +                       if (nowait && (ret == -ENOSPC || ret == -EAGAIN)) {
> +                               ret = -EAGAIN;
> +                               break;
> +                       }
> +
>                         /*
>                          * If we don't have to COW at the offset, reserve
>                          * metadata only. write_bytes may get smaller than
>                          * requested here.
>                          */
>                         tmp = btrfs_check_nocow_lock(BTRFS_I(inode), pos,
> -                                                    &write_bytes, false);
> +                                                    &write_bytes, nowait);
>                         if (tmp < 0)
>                                 ret = tmp;
>                         if (tmp > 0)
> @@ -1737,7 +1743,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>                 WARN_ON(reserve_bytes == 0);
>                 ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
>                                                       reserve_bytes,
> -                                                     reserve_bytes, false);
> +                                                     reserve_bytes, nowait);
>                 if (ret) {
>                         if (!only_release_metadata)
>                                 btrfs_free_reserved_data_space(BTRFS_I(inode),
> @@ -1767,10 +1773,11 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>                 extents_locked = lock_and_cleanup_extent_if_need(
>                                 BTRFS_I(inode), pages,
>                                 num_pages, pos, write_bytes, &lockstart,
> -                               &lockend, false, &cached_state);
> +                               &lockend, nowait, &cached_state);
>                 if (extents_locked < 0) {
> -                       if (extents_locked == -EAGAIN)
> +                       if (!nowait && extents_locked == -EAGAIN)
>                                 goto again;
> +
>                         btrfs_delalloc_release_extents(BTRFS_I(inode),
>                                                        reserve_bytes);
>                         ret = extents_locked;
> --
> 2.30.2
>
