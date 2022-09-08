Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93A5B19D1
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIHKTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIHKTT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB251C59E0;
        Thu,  8 Sep 2022 03:19:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AD3161BEA;
        Thu,  8 Sep 2022 10:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3BC433D6;
        Thu,  8 Sep 2022 10:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632356;
        bh=TZ4L8QnNNF/+AmlYlp0if1mTsgNobXuva4gjwcTX6Ks=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QEHMEXkVrFGEQqdSTTg3Mkac6I93c0DVRSmnugbPv16fnyLAX39yCKE/t+qGrr62V
         ig1oSF4hWgeEyPLP2YPJPX1bOfByZB8UqaEsbVP+wbIbvxNYJ4lUVa2ziOpQ/+827K
         Ra611rmjbqD9a6C8NxJzMuzgE97SNhKoREHo0xSz0rYXlr/wtawVEscxrP+5a0td/W
         oEx46LduoEsDG8SWWDa7OUSdtf6oa2/+pAJ+SH3OdJAte8i0ZyI6Xa8Pr/s1TdkPGb
         S4fWgkBLi76L4Tb/s6NBWxA/6WuDhS/V5L2zh7W5INTrGADDXr8eFmAuLWEmDlxMKx
         3g1wRi+7AYAEg==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-1280590722dso9606723fac.1;
        Thu, 08 Sep 2022 03:19:16 -0700 (PDT)
X-Gm-Message-State: ACgBeo3nscCk0pd0eh40cM666sXGgEpzEWDMZ1e+Gw+qzP9ZD5fG/CpF
        L0osn6ccrlMwpxm4d31tmgol5CLJ5Uks/cdyEfA=
X-Google-Smtp-Source: AA6agR4gDVC5kkxYGsFYe8wvb81RmXpuQfbHwDbd+74flaujMhKwwASKTVUXHSfXCHpZh7XJ6/xGHClYpZu0tlClM9I=
X-Received: by 2002:a05:6870:538c:b0:11b:e64f:ee1b with SMTP id
 h12-20020a056870538c00b0011be64fee1bmr1393439oan.92.1662632356053; Thu, 08
 Sep 2022 03:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-6-shr@fb.com>
In-Reply-To: <20220908002616.3189675-6-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:18:39 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7pRTH7YFnSmeQ1iZcp2Hr2ddkW-qBEBp31n9a50KJ-9w@mail.gmail.com>
Message-ID: <CAL3q7H7pRTH7YFnSmeQ1iZcp2Hr2ddkW-qBEBp31n9a50KJ-9w@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] btrfs: add btrfs_try_lock_ordered_range
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
> For IOCB_NOWAIT we're going to want to use try lock on the extent lock,
> and simply bail if there's an ordered extent in the range because the
> only choice there is to wait for the ordered extent to complete.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/ordered-data.c | 28 ++++++++++++++++++++++++++++
>  fs/btrfs/ordered-data.h |  1 +
>  2 files changed, 29 insertions(+)
>
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 1952ac85222c..3cdfdcedb088 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -1041,6 +1041,34 @@ void btrfs_lock_and_flush_ordered_range(struct btrfs_inode *inode, u64 start,
>         }
>  }
>
> +/*
> + * btrfs_try_lock_ordered_range - lock the passed range and ensure all pending
> + * ordered extents in it are run to completion in nowait mode.
> + *
> + * @inode:        Inode whose ordered tree is to be searched
> + * @start:        Beginning of range to flush
> + * @end:          Last byte of range to lock
> + *
> + * This function returns 1 if btrfs_lock_ordered_range does not return any
> + * extents, otherwise 0.

Why not a bool, true/false? That's all that is needed, and it's clear.

Thanks.

> + */
> +int btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end)
> +{
> +       struct btrfs_ordered_extent *ordered;
> +
> +       if (!try_lock_extent(&inode->io_tree, start, end))
> +               return 0;
> +
> +       ordered = btrfs_lookup_ordered_range(inode, start, end - start + 1);
> +       if (!ordered)
> +               return 1;
> +
> +       btrfs_put_ordered_extent(ordered);
> +       unlock_extent(&inode->io_tree, start, end);
> +       return 0;
> +}
> +
> +
>  static int clone_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pos,
>                                 u64 len)
>  {
> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> index 87792f85e2c4..ec27ebf0af4b 100644
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -218,6 +218,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, u64 nr,
>  void btrfs_lock_and_flush_ordered_range(struct btrfs_inode *inode, u64 start,
>                                         u64 end,
>                                         struct extent_state **cached_state);
> +int btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end);
>  int btrfs_split_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pre,
>                                u64 post);
>  int __init ordered_data_init(void);
> --
> 2.30.2
>
