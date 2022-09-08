Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F97C5B19CF
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiIHKTI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIHKTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:19:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9FEC652B;
        Thu,  8 Sep 2022 03:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECF8BB81F7E;
        Thu,  8 Sep 2022 10:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85C8C43470;
        Thu,  8 Sep 2022 10:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632343;
        bh=MkhfUcM9hU6OJxV0FCySLY20o80C1zt1uk+JGv+GfDE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JZMbsAlxi9nTrOFrMJvUT+VMbc3H1SIqrC8DNfhXvBkdLUIg6EDD12rs3QO7Sx5Ti
         vswjenfu4gnymoE/TMGWHMbXbc4gBqSwD4eveA2e3wHNCqaN51TgIu2uotAUT+Tsg0
         lXYUpaRgSCrUDHNXqLAwQdrhK9uDFRqUkrzxYDVtvxlDiP5Bo9p2ZYAFBRMFiiBWIu
         qcF6hqA1HQC/ez1eXRfcZG+y057T03wHE4JEOFlZOLx11cAYJ4sdYmBnCtm+m8MubY
         TyQasIeeCXhuQclO6F84zptPWkMViITGDAv+eeKA8Q7Mh4fDDFBzkjq5/RlRLiyi45
         Dq6DiYtXNre9g==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-11eab59db71so42979829fac.11;
        Thu, 08 Sep 2022 03:19:03 -0700 (PDT)
X-Gm-Message-State: ACgBeo2R4HsOjm0gk5IWyk0FSH/vtP3/zoRiRHwCDMWnFbtds1FQvW5A
        vsKLgjNY0WoSt/xpVfmvMkthgliz3Om/8T6hqOs=
X-Google-Smtp-Source: AA6agR6l0tX0LYfuj1LgHtEHgwHx05c5xfwNbdURKi+C9QrZ8zSNhlgSgY0unUBuc554uU0iO2HlHIfHqMmrawN7f7k=
X-Received: by 2002:a05:6870:ea83:b0:fe:365f:cb9d with SMTP id
 s3-20020a056870ea8300b000fe365fcb9dmr1500051oap.98.1662632342789; Thu, 08 Sep
 2022 03:19:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-7-shr@fb.com>
In-Reply-To: <20220908002616.3189675-7-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:18:26 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6mJEK=T78DF6o=xYmZht=x0jPVgDw3eVoHOKLyxfvdOA@mail.gmail.com>
Message-ID: <CAL3q7H6mJEK=T78DF6o=xYmZht=x0jPVgDw3eVoHOKLyxfvdOA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] btrfs: make btrfs_check_nocow_lock nowait compatible
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
> From: Josef Bacik <josef@toxicpanda.com>
>
> Now all the helpers that btrfs_check_nocow_lock uses handle nowait, add
> a nowait flag to btrfs_check_nocow_lock so it can be used by the write
> path.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/ctree.h |  2 +-
>  fs/btrfs/file.c  | 33 ++++++++++++++++++++++-----------
>  fs/btrfs/inode.c |  2 +-
>  3 files changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 536bbc8551fc..06cb25f2d3bd 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3482,7 +3482,7 @@ int btrfs_dirty_pages(struct btrfs_inode *inode, struct page **pages,
>                       struct extent_state **cached, bool noreserve);
>  int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
>  int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
> -                          size_t *write_bytes);
> +                          size_t *write_bytes, bool nowait);
>  void btrfs_check_nocow_unlock(struct btrfs_inode *inode);
>
>  /* tree-defrag.c */
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 0f257205c63d..cf19d381ead6 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1481,7 +1481,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
>   * NOTE: Callers need to call btrfs_check_nocow_unlock() if we return > 0.
>   */
>  int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
> -                          size_t *write_bytes)
> +                          size_t *write_bytes, bool nowait)
>  {
>         struct btrfs_fs_info *fs_info = inode->root->fs_info;
>         struct btrfs_root *root = inode->root;
> @@ -1500,16 +1500,21 @@ int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
>                            fs_info->sectorsize) - 1;
>         num_bytes = lockend - lockstart + 1;
>
> -       btrfs_lock_and_flush_ordered_range(inode, lockstart, lockend, NULL);
> +       if (nowait) {
> +               if (!btrfs_try_lock_ordered_range(inode, lockstart, lockend)) {
> +                       btrfs_drew_write_unlock(&root->snapshot_lock);
> +                       return -EAGAIN;
> +               }
> +       } else {
> +               btrfs_lock_and_flush_ordered_range(inode, lockstart, lockend, NULL);
> +       }
>         ret = can_nocow_extent(&inode->vfs_inode, lockstart, &num_bytes,
> -                       NULL, NULL, NULL, false, false);
> -       if (ret <= 0) {
> -               ret = 0;
> +                       NULL, NULL, NULL, nowait, false);
> +       if (ret <= 0)
>                 btrfs_drew_write_unlock(&root->snapshot_lock);
> -       } else {
> +       else
>                 *write_bytes = min_t(size_t, *write_bytes ,
>                                      num_bytes - pos + lockstart);
> -       }
>         unlock_extent(&inode->io_tree, lockstart, lockend);
>
>         return ret;
> @@ -1666,16 +1671,22 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>                                                   &data_reserved, pos,
>                                                   write_bytes, false);
>                 if (ret < 0) {
> +                       int tmp;
> +
>                         /*
>                          * If we don't have to COW at the offset, reserve
>                          * metadata only. write_bytes may get smaller than
>                          * requested here.
>                          */
> -                       if (btrfs_check_nocow_lock(BTRFS_I(inode), pos,
> -                                                  &write_bytes) > 0)
> -                               only_release_metadata = true;
> -                       else
> +                       tmp = btrfs_check_nocow_lock(BTRFS_I(inode), pos,
> +                                                    &write_bytes, false);
> +                       if (tmp < 0)
> +                               ret = tmp;
> +                       if (tmp > 0)
> +                               ret = 0;
> +                       if (ret)

A variable named tmp is not a great name, something like "can_nocow'
would be a lot more clear.

Thanks.


>                                 break;
> +                       only_release_metadata = true;
>                 }
>
>                 num_pages = DIV_ROUND_UP(write_bytes + offset, PAGE_SIZE);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 36e755f73764..5426d4f4ac23 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -4884,7 +4884,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode, loff_t from, loff_t len,
>         ret = btrfs_check_data_free_space(inode, &data_reserved, block_start,
>                                           blocksize, false);
>         if (ret < 0) {
> -               if (btrfs_check_nocow_lock(inode, block_start, &write_bytes) > 0) {
> +               if (btrfs_check_nocow_lock(inode, block_start, &write_bytes, false) > 0) {
>                         /* For nocow case, no need to reserve data space */
>                         only_release_metadata = true;
>                 } else {
> --
> 2.30.2
>
