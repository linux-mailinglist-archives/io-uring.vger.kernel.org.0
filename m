Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22E6E5B19C2
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiIHKQb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiIHKQ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7A5B6566;
        Thu,  8 Sep 2022 03:16:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 662ECB81E80;
        Thu,  8 Sep 2022 10:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE3EC433C1;
        Thu,  8 Sep 2022 10:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632181;
        bh=j4Q4LwmhEo/x9jzNYVfCpPx/5TZ3N2+Au/UnimeW2bI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tT3FC1AaUVbP/AIF+YLMuOf/VIVmnmtxW6/imbNvS20Fvn/EF64b/O8Mq0xSa7/SN
         Z1tCihK3RLIXUCqhqy2ZpA37KnFYt28yANvM4R+yCshTdMwAUrLpv+J6b8i731w3xw
         iX8R2kUgCDgS4y4/mSK9v02XRHg8IroFczWXUitNdPgWNkPxn9mbMe4DInSmAPGyt8
         E8CBu9gvqjf4FUzp2BWNwH1xg9uuQV80VvEyy4VpzQJq7oWKcqTDO9yeRyKTD8U3H6
         E7vX73EDEqNvT2tyhOee7vi8ANuH4MAtz9An7E0inhLyT9ymjXlWS0TzEfF6wWXqXb
         V4GCSz0XviWDA==
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-12803ac8113so9776094fac.8;
        Thu, 08 Sep 2022 03:16:21 -0700 (PDT)
X-Gm-Message-State: ACgBeo1Szdp2vOd4N7Wv4ygqnCb4j/mZqR8ScbN8/8McFJHsD4dPvPu1
        7sbJoBd9eQTYDcgrBrcO2pWx6sAG7Suc8P3Eezg=
X-Google-Smtp-Source: AA6agR5FcWw6bO0z6Q0Bh9LfQac06LtkkxRHD1eJO7/rFRXlO9DsMTAdiRHtxotXdQwZ0uEDmHdTD2hFcTD9vEj5mp0=
X-Received: by 2002:a05:6870:ea83:b0:fe:365f:cb9d with SMTP id
 s3-20020a056870ea8300b000fe365fcb9dmr1494894oap.98.1662632180235; Thu, 08 Sep
 2022 03:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-12-shr@fb.com>
In-Reply-To: <20220908002616.3189675-12-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:15:44 +0100
X-Gmail-Original-Message-ID: <CAL3q7H56dfcQP+vMK0T22nJwZQ=Qq217wT=idkHZdW4J4ar9fQ@mail.gmail.com>
Message-ID: <CAL3q7H56dfcQP+vMK0T22nJwZQ=Qq217wT=idkHZdW4J4ar9fQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] btrfs: add assert to search functions
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
> This adds warnings to search functions, which should not have the nowait
> flag set when called.

This could be more clear, by saying btree search functions which are
not used for the buffered IO
and direct IO paths, which are the only users of nowait btree searches.

Also the subject: "btrfs: add assert to search functions"

Mentions assert, but the code adds warnings, which are not the same.
It could also be more clear like:   "btrfs: assert nowait mode is not
used for some btree search functions''


>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/ctree.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 71b238364939..9caf0f87cbcb 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2165,6 +2165,9 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
>         lowest_level = p->lowest_level;
>         WARN_ON(p->nodes[0] != NULL);
>
> +       if (WARN_ON_ONCE(p->nowait == 1))

This doesn't follow the existing code style, which is to treat path
members as booleans, and just do:

WARN_ON_ONCE(p->nowait)

I.e., no explicit " == 1"

As this is a developer thing, I would use ASSERT() instead.

For release builds that typically have CONFIG_BTRFS_ASSERT not set
(like Ubuntu and Debian), it would
still allow the search to continue, which is fine from a functional
perspective, since not respecting nowait
semantics is just a performance thing.

Thanks.


> +               return -EINVAL;
> +
>         if (p->search_commit_root) {
>                 BUG_ON(time_seq);
>                 return btrfs_search_slot(NULL, root, key, p, 0, 0);
> @@ -4465,6 +4468,9 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
>         int ret = 1;
>         int keep_locks = path->keep_locks;
>
> +       if (WARN_ON_ONCE(path->nowait == 1))
> +               return -EINVAL;
> +
>         path->keep_locks = 1;
>  again:
>         cur = btrfs_read_lock_root_node(root);
> @@ -4645,6 +4651,9 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>         int ret;
>         int i;
>
> +       if (WARN_ON_ONCE(path->nowait == 1))
> +               return -EINVAL;
> +
>         nritems = btrfs_header_nritems(path->nodes[0]);
>         if (nritems == 0)
>                 return 1;
> --
> 2.30.2
>
