Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBDF5B19D3
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 12:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiIHKTk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 06:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIHKTj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 06:19:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C860A1E3D2;
        Thu,  8 Sep 2022 03:19:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8210EB81E80;
        Thu,  8 Sep 2022 10:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48936C433C1;
        Thu,  8 Sep 2022 10:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662632375;
        bh=DDvumvMuoY52duEMPQmq3aa1zu1YyA33ZAQCwJDZyPc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=K7UOX7fGGrpioUfS0dCu/NlHdodXOsQksSPiF+hcFP7iNfNgjlDTC/xksapvXDm9w
         NrIObr17if3Kozz1h+tKlssKg2gnyrmkuRbP1XIfsLlhyfO98gNGV+9hIoZw74gPZ2
         f1z+Ves6ma+TRpR0ewDhaqBQHaxRE3t1z7JWCDvwH9yWj8RciymAzLVAsoUcGlmCmV
         iV/YidyH4gW6Vii0OulZgRSvnm+4UkjjlLc9uAhTOIOsOBi04zur/2KmzJPcwfmrKn
         SZxlW6+UCYJp6pmHcxfiEtBp7TrHltjshwY6fmF5ifGVmoY6ksNQSncee4PFyKst4D
         5te5EBq0n8l4w==
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-127ba06d03fso19512025fac.3;
        Thu, 08 Sep 2022 03:19:35 -0700 (PDT)
X-Gm-Message-State: ACgBeo2Ful1AZYZvLqYUPS2xcg5if85ivdxSP0qdDJIj5VHb2j0i9dgk
        YzyRJRd0Y4viMookEmQ0ByOy5XYVvKQGmkChPeA=
X-Google-Smtp-Source: AA6agR6VLfHR1xOfGKPPzL+CVKHwjGnMRAYZ+z/scNXlV0jBqEgYXnL3Yg+79UkgylG5L8PKwTjq4JSeSd9NghLJD4E=
X-Received: by 2002:a05:6870:ea83:b0:fe:365f:cb9d with SMTP id
 s3-20020a056870ea8300b000fe365fcb9dmr1501036oap.98.1662632374484; Thu, 08 Sep
 2022 03:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220908002616.3189675-1-shr@fb.com> <20220908002616.3189675-2-shr@fb.com>
In-Reply-To: <20220908002616.3189675-2-shr@fb.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 8 Sep 2022 11:18:58 +0100
X-Gmail-Original-Message-ID: <CAL3q7H57eV35bi_mS8JJiM0GHBGs6qSRHaz=FHNwZs_SE5rfQw@mail.gmail.com>
Message-ID: <CAL3q7H57eV35bi_mS8JJiM0GHBGs6qSRHaz=FHNwZs_SE5rfQw@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] mm: export balance_dirty_pages_ratelimited_flags()
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com,
        kernel test robot <lkp@intel.com>
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
> Export the function balance_dirty_pages_ratelimited_flags(). It is now
> also called from btrfs.
>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  mm/page-writeback.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 032a7bf8d259..7e9d8d857ecc 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1933,6 +1933,7 @@ int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
>         wb_put(wb);
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(balance_dirty_pages_ratelimited_flags);

Even though it's a trivial change, the linux-mm list should be CC'ed.

Thanks.

>
>  /**
>   * balance_dirty_pages_ratelimited - balance dirty memory state.
> --
> 2.30.2
>
