Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACB4AA721
	for <lists+io-uring@lfdr.de>; Sat,  5 Feb 2022 07:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346922AbiBEGdD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Feb 2022 01:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiBEGdC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Feb 2022 01:33:02 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851ACC061346
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 22:33:01 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id n8so16725168lfq.4
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 22:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/I4uenCSy6lKFDX+vozXBZPrlb1lnpOy6352DMFUA8c=;
        b=rq24Q2AFZ5EoKbcKKkftdHvOqnaftuHw87PzEuO4Mjmi1KqZOJK69ovDu1K371qjBa
         DDXJPDZ5iX4ThIye9JZjA2NYYesaKh5lmhtCUGiaiPvTBSGYOHsfEDC7tWjBLd5UMeH6
         aXnz2Zsy56u1y56TWSMCmsF7fdOuvjRD7VnTOQ/3O7r9FkAo/Wgn2dO/rw7JyRF+qMVi
         Y16QISg8FsYxTHzUdTSgWMBIIeCFS1VUMWekJa2tm+xEjI2i5VVGl1QFlgpqm/WWipFc
         dXw/5OF4N74vt8K7liy4FV/Ft+nh9VV0VjvUzwmEIkzWBGVdm/CYbNPjpL9xlOI8KcgU
         4e8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/I4uenCSy6lKFDX+vozXBZPrlb1lnpOy6352DMFUA8c=;
        b=KGus50jYm2m19gjwlgsrPU8pfkinWzgK32UoKMyrE1vLah8/zxYIeBn20W1LPVES0Z
         pFig6SfHI39dVosfEY9mKy/TR0DOImhgl3l/M1fgzBY1RN4251B6oD8LHUUH+GH2A29u
         KpC4E9K5MVGxmtCsCOa/XJhSQqbvybZKYAYLUsnO03iWAkqXr5vUV3ZRV/oVyQ5cCuof
         nlTsNEi+XdmeC5r+T5NrNwhMFIf8WcVVEwV5VjpF7s6X7bje6ji2gc+HaYaOdxsnwzVU
         vy8GSrc6QegPA3nKi/xTNU1wsr+ib8nWRD4uEqL5J8RAhmRSSl3bDPzGsBBqgzS+HmvE
         hAkA==
X-Gm-Message-State: AOAM531oQXMb4za0ZWzBIFAgd3zKDazQytNoPYhTK12KYTcpUe58CuhS
        KIUUTN2y/3bOJ4m5e6uDYi6ebqKwCkJmvkPU5ZNmJA==
X-Google-Smtp-Source: ABdhPJzBS0ATlNIJS0wbnbUmcCt1uFbSET2zzNCr5rG+3DvrfqXNdkPOzH/OnKXNo0LNwTjK2rMAXmYqafs8B4rB57A=
X-Received: by 2002:a05:6512:10ce:: with SMTP id k14mr1651918lfg.210.1644042778863;
 Fri, 04 Feb 2022 22:32:58 -0800 (PST)
MIME-Version: 1.0
References: <20220125051736.2981459-1-shakeelb@google.com>
In-Reply-To: <20220125051736.2981459-1-shakeelb@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 4 Feb 2022 22:32:47 -0800
Message-ID: <CALvZod6Tdb76hvg+GA+5mvFWrkHi2nNXJ64TLmhUisZVxbLsiQ@mail.gmail.com>
Subject: Re: [PATCH] mm: io_uring: allow oom-killer from io_uring_setup
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 24, 2022 at 9:17 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On an overcommitted system which is running multiple workloads of
> varying priorities, it is preferred to trigger an oom-killer to kill a
> low priority workload than to let the high priority workload receiving
> ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
> ENOMEMs instead of oom-kills because io_uring_setup callchain is using
> __GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
> allow the oom-killer to kill a lower priority job.
>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Jens, any comments or concerns on this patch?

> ---
>  fs/io_uring.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e54c4127422e..d9eeb202363c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8928,10 +8928,9 @@ static void io_mem_free(void *ptr)
>
>  static void *io_mem_alloc(size_t size)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
> -                               __GFP_NORETRY | __GFP_ACCOUNT;
> +       gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
>
> -       return (void *) __get_free_pages(gfp_flags, get_order(size));
> +       return (void *) __get_free_pages(gfp, get_order(size));
>  }
>
>  static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>
