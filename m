Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7655B19CA
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiIHKR6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIHKR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F75B81F0;
        Thu,  8 Sep 2022 03:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E9961BEA;
        Thu,  8 Sep 2022 10:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1E0C433D6;
        Thu,  8 Sep 2022 10:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632276;
        bh=dWyxK9jP2WV93aLxJVYMrcErXjL30EfeKVj61CKAdFM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GeZd2WDQ8IkvfSxKxZc1klqY044eNyEev16jjhgYSFMj/M9BQkCVmCrXLLJUiFU+U
         6htI09gP+6J5p3vxA1iJqJnxRvw8YSKDMhXXp7S1+GtaYS00qIvueZe8ZhaVtjqsID
         RrFLyqqHxVl2YqEdx1KNF8BvdUgGyszY4bvkuqLmRb8Wf5TfOs1GMZuSDrHJjl2hOo
         jI+NlRP4GhNMAnxQGZoaVqkCRqlr8Os43r89ivpM3KiDRvE4C0auONGBoySGXEKd6F
         9O3Qv1sCKQY9RluIapKOAlk54+M0dDqnKdMSUVmO/rCUmdHq5Z16vFOcTgwo6FVJJz
         71X46hsh3hNxA==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-127ba06d03fso19503107fac.3;
        Thu, 08 Sep 2022 03:17:56 -0700 (PDT)
X-Gm-Message-State: ACgBeo3BeMYphl8jLubcJn6bNPP0UhpRFG6ONN1OO7P+YP5ClOPTycno
        xMFK208O6h+G/N3ii0j1VOcsyzWi+S/EWBYW3lE=
X-Google-Smtp-Source: AA6agR4RbXvgp7YDtSufRijhQM8A0B/CkG/zA2VlL/q5Zg1YaFcB1AO+ZcBKrYeL84S6n7DZnNQXruxuH2CFyro3SsQ=
X-Received: by 2002:a05:6870:538c:b0:11b:e64f:ee1b with SMTP id
 h12-20020a056870538c00b0011be64fee1bmr1391001oan.92.1662632275255; Thu, 08
 Sep 2022 03:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-9-shr@fb.com>
In-Reply-To: <20220908002616.3189675-9-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:17:19 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5QnvPNtNq-uvXBsFNT=URXU4pKDaUqZGrf3MPt7VgBSA@mail.gmail.com>
Message-ID: <CAL3q7H5QnvPNtNq-uvXBsFNT=URXU4pKDaUqZGrf3MPt7VgBSA@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] btrfs: make lock_and_cleanup_extent_if_need
 nowait compatible
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
> This adds the nowait parameter to lock_and_cleanup_extent_if_need(). If
> the nowait parameter is specified we try to lock the extent in nowait
> mode.
>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/file.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a154a3cec44b..4e1745e585cb 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1440,7 +1440,7 @@ static noinline int
>  lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
>                                 size_t num_pages, loff_t pos,
>                                 size_t write_bytes,
> -                               u64 *lockstart, u64 *lockend,
> +                               u64 *lockstart, u64 *lockend, bool nowait,
>                                 struct extent_state **cached_state)
>  {
>         struct btrfs_fs_info *fs_info = inode->root->fs_info;
> @@ -1455,8 +1455,20 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
>         if (start_pos < inode->vfs_inode.i_size) {
>                 struct btrfs_ordered_extent *ordered;
>
> -               lock_extent_bits(&inode->io_tree, start_pos, last_pos,
> +               if (nowait) {
> +                       if (!try_lock_extent(&inode->io_tree, start_pos, last_pos)) {
> +                               for (i = 0; i < num_pages; i++) {
> +                                       unlock_page(pages[i]);
> +                                       put_page(pages[i]);

Since this is a non-local array, I'd prefer if we also set pages[i] to NULL.
That may help prevent hard to debug bugs in the future.

Thanks.


> +                               }
> +
> +                               return -EAGAIN;
> +                       }
> +               } else {
> +                       lock_extent_bits(&inode->io_tree, start_pos, last_pos,
>                                 cached_state);
> +               }
> +
>                 ordered = btrfs_lookup_ordered_range(inode, start_pos,
>                                                      last_pos - start_pos + 1);
>                 if (ordered &&
> @@ -1755,7 +1767,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>                 extents_locked = lock_and_cleanup_extent_if_need(
>                                 BTRFS_I(inode), pages,
>                                 num_pages, pos, write_bytes, &lockstart,
> -                               &lockend, &cached_state);
> +                               &lockend, false, &cached_state);
>                 if (extents_locked < 0) {
>                         if (extents_locked == -EAGAIN)
>                                 goto again;
> --
> 2.30.2
>
