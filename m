Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370AD5B19CC
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIHKS2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiIHKS1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:18:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F87C0BF6;
        Thu,  8 Sep 2022 03:18:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73AEA61C39;
        Thu,  8 Sep 2022 10:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF0EC433D6;
        Thu,  8 Sep 2022 10:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632304;
        bh=cGU3ZhRsnrpBj9RrqcP1OAYGhP7ba7hfeGBp9XoY8yM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BSR4z8LUxjpHZYQQ4wcwdi2bUzhjsmwGKhjDB6x+q4gYELkryGFaWIreUvfTANaw4
         psOtQpGMy/RiHclaGTp9aBL2tfDxpNKBmkpiMTIEjM0w3SjkBmyg0npzMFzfoL9toi
         XKkgLXBf/Cl6k+B3rAnZdgWV0dNUF3GwK6uP58eULFLGMGa43AyyMvcSwN1UMysH5Z
         znX6OOijOpfsmaQNJKcTcR+wG6fJLR9hAS+eTHdP9sd1kQrQghSxTcmN5VKTFzFdgk
         2b28VttTE7YmaYl2roxSC4lEmTBW14k9MGQIeuRSY2prYxKgL+dGwu/uVpUyx4X1Ui
         LMFJTrVp8FqPw==
Received: by mail-ot1-f53.google.com with SMTP id h9-20020a9d5549000000b0063727299bb4so12039583oti.9;
        Thu, 08 Sep 2022 03:18:24 -0700 (PDT)
X-Gm-Message-State: ACgBeo2xGqqECQjYbV6qAZ16awVcQTno2BWUuJETuywWni30dUSA4yPE
        GhbkusEg9T8a0f92Wz5JFXZiEEoJXELUp8nbr0c=
X-Google-Smtp-Source: AA6agR5zS/pLw5Iq8wd+0iIDAhgdLVQQNbG9tuBugvelYCxRLRYVrpnSQwgdLwsjN6suJD/S6ZrsPzfLf+nx7fGX1Z0=
X-Received: by 2002:a05:6830:120f:b0:639:1a06:d09d with SMTP id
 r15-20020a056830120f00b006391a06d09dmr2961632otp.345.1662632304060; Thu, 08
 Sep 2022 03:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-8-shr@fb.com>
In-Reply-To: <20220908002616.3189675-8-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:17:47 +0100
X-Gmail-Original-Message-ID: <CAL3q7H77thY5_1zMiwVZ8oBk3b4KwFUsff=DojUSgJdAMP-2DQ@mail.gmail.com>
Message-ID: <CAL3q7H77thY5_1zMiwVZ8oBk3b4KwFUsff=DojUSgJdAMP-2DQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] btrfs: make prepare_pages nowait compatible
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
> Add nowait parameter to the prepare_pages function. In case nowait is
> specified for an async buffered write request, do a nowait allocation or
> return -EAGAIN.
>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/file.c | 43 ++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 36 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index cf19d381ead6..a154a3cec44b 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1339,26 +1339,55 @@ static int prepare_uptodate_page(struct inode *inode,
>         return 0;
>  }
>
> +static int get_prepare_fgp_flags(bool nowait)
> +{
> +       int fgp_flags;
> +
> +       fgp_flags = FGP_LOCK|FGP_ACCESSED|FGP_CREAT;

Please follow the existing code style and add a space before and after
each bitwise or operator.
Not only does it conform to the btrfs style, it's also easier to read.

The assignment could also be done when declaring the variable, since
it's short and simple.

Thanks.

> +       if (nowait)
> +               fgp_flags |= FGP_NOWAIT;
> +
> +       return fgp_flags;
> +}
> +
> +static gfp_t get_prepare_gfp_flags(struct inode *inode, bool nowait)
> +{
> +       gfp_t gfp;
> +
> +       gfp = btrfs_alloc_write_mask(inode->i_mapping);
> +       if (nowait) {
> +               gfp &= ~__GFP_DIRECT_RECLAIM;
> +               gfp |= GFP_NOWAIT;
> +       }
> +
> +       return gfp;
> +}
> +
>  /*
>   * this just gets pages into the page cache and locks them down.
>   */
>  static noinline int prepare_pages(struct inode *inode, struct page **pages,
>                                   size_t num_pages, loff_t pos,
> -                                 size_t write_bytes, bool force_uptodate)
> +                                 size_t write_bytes, bool force_uptodate,
> +                                 bool nowait)
>  {
>         int i;
>         unsigned long index = pos >> PAGE_SHIFT;
> -       gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
> +       gfp_t mask = get_prepare_gfp_flags(inode, nowait);
> +       int fgp_flags = get_prepare_fgp_flags(nowait);
>         int err = 0;
>         int faili;
>
>         for (i = 0; i < num_pages; i++) {
>  again:
> -               pages[i] = find_or_create_page(inode->i_mapping, index + i,
> -                                              mask | __GFP_WRITE);
> +               pages[i] = pagecache_get_page(inode->i_mapping, index + i,
> +                                       fgp_flags, mask | __GFP_WRITE);
>                 if (!pages[i]) {
>                         faili = i - 1;
> -                       err = -ENOMEM;
> +                       if (nowait)
> +                               err = -EAGAIN;
> +                       else
> +                               err = -ENOMEM;
>                         goto fail;
>                 }
>
> @@ -1376,7 +1405,7 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
>                                                     pos + write_bytes, false);
>                 if (err) {
>                         put_page(pages[i]);
> -                       if (err == -EAGAIN) {
> +                       if (!nowait && err == -EAGAIN) {
>                                 err = 0;
>                                 goto again;
>                         }
> @@ -1716,7 +1745,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
>                  */
>                 ret = prepare_pages(inode, pages, num_pages,
>                                     pos, write_bytes,
> -                                   force_page_uptodate);
> +                                   force_page_uptodate, false);
>                 if (ret) {
>                         btrfs_delalloc_release_extents(BTRFS_I(inode),
>                                                        reserve_bytes);
> --
> 2.30.2
>
