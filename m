Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63715B19C6
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIHKRH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiIHKRG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:17:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3841EB655A;
        Thu,  8 Sep 2022 03:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69A9AB8202D;
        Thu,  8 Sep 2022 10:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21601C433C1;
        Thu,  8 Sep 2022 10:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632221;
        bh=kk/5P5ROJUorBgv/h8aQCrqW0jLADiXy2bTmIJ/vpRI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SVXl1AB/040dMPwWIK7LAxmY7P1LjfV+zLIqyrIScWqUkdCTDP7dutguIA6yyW+bF
         Y0JOz3tcQuv//UQ3Mpt/wySD63raJRLn3oG6N75P5tvHVrO86IhRDoqCyTUBLCRDSl
         SPELHtKfu/iY27AnRWacYIor9R3ory8it8yqENcVuAGr+ylZ2Dh7fxb4nBuM+qJyCa
         wSx/a6gJUoXNP1syafAEylyIP8cr7TgvWAvq/uaL7J5CFmeFIm0zjpFMvqknEDmoOr
         0qgeN/y5yWQ5SthjaAp4BomG8x9pS2xq5CXu6INywiRPDephUkT83pYaCZMX8/5sLT
         hHjKF1YZC6khg==
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-127ba06d03fso19497965fac.3;
        Thu, 08 Sep 2022 03:17:01 -0700 (PDT)
X-Gm-Message-State: ACgBeo0qUECXYoDK6EU46amSXW5iJCKxO4qMNWlmkEpqrNjC3OY3V0rj
        11Nh1WdWrEuVF8VTW2kH7w9M0XC+byjMK14TDWc=
X-Google-Smtp-Source: AA6agR7caALn4zm8e/g0PWFqNsX/S6cN7tVNOcDNmX+XRItZULW2L0mYjNKAodif9FkJION82zLkeEHee5/yKtmSkXI=
X-Received: by 2002:a05:6808:f14:b0:343:5f65:a540 with SMTP id
 m20-20020a0568080f1400b003435f65a540mr1060813oiw.92.1662632220342; Thu, 08
 Sep 2022 03:17:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-11-shr@fb.com>
In-Reply-To: <20220908002616.3189675-11-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:16:24 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7Zh0VzPG_F2cM5e37QzpOEkRNaCjPrzicKtm=muidR9A@mail.gmail.com>
Message-ID: <CAL3q7H7Zh0VzPG_F2cM5e37QzpOEkRNaCjPrzicKtm=muidR9A@mail.gmail.com>
Subject: Re: [PATCH v2 10/12] btrfs: make balance_dirty_pages nowait compatible
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
> This replaces the call to function balance_dirty_pages_ratelimited() in
> the function btrfs_buffered_write() with a call to
> balance_dirty_pages_ratelimited_flags().
>
> It also moves the function after the again label. This can cause the
> function to be called a bit later, but this should have no impact in the
> real world.
>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/file.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 6e191e353b22..fd42ba9de7a7 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1654,6 +1654,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>         loff_t old_isize = i_size_read(inode);
>         unsigned int ilock_flags = 0;
>         bool nowait = iocb->ki_flags & IOCB_NOWAIT;
> +       unsigned int bdp_flags = nowait ? BDP_ASYNC : 0;
>
>         if (nowait)
>                 ilock_flags |= BTRFS_ILOCK_TRY;
> @@ -1756,6 +1757,10 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>
>                 release_bytes = reserve_bytes;
>  again:
> +               ret = balance_dirty_pages_ratelimited_flags(inode->i_mapping, bdp_flags);
> +               if (unlikely(ret))

We normally only use likely or unlikely in contextes where we observe
that it makes a significant difference.
What's the motivation here, have you verified that in this case it has
a significant impact?

Thanks.

> +                       break;
> +
>                 /*
>                  * This is going to setup the pages array with the number of
>                  * pages we want, so we don't really need to worry about the
> @@ -1860,8 +1865,6 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>
>                 cond_resched();
>
> -               balance_dirty_pages_ratelimited(inode->i_mapping);
> -
>                 pos += copied;
>                 num_written += copied;
>         }
> --
> 2.30.2
>
