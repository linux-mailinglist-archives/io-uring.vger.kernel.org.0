Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3BE50AD7C
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 03:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443177AbiDVByc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 21:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443193AbiDVByb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 21:54:31 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C734A3F6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 18:51:39 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id i11-20020a9d4a8b000000b005cda3b9754aso4483987otf.12
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 18:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RbPgAJpwyTltewryTCHRP6PSiXTnCpNjZf2qNCYCqfY=;
        b=p3Fv2EOaj3weUFQdv3g6o9SEjVGXmpWeBh/1UVOGAk5N1TkAdtRpOnC10EC1tFFnhX
         pwI/J3C36eK7DaQoO1ZLQTR2sTh3CmV6n0CCyfuMBSZDnRtQjhtNxqAkpMUEG/Dw29pA
         zR9+fnGklSKu1OOLLTvwhoRyMcs5OUYqTTIJTa+l2J48ZiaulF1jVIboSIA+cyfqI/B8
         dbTqiFVQXwqCBukgl6EV12VWhplGYO4wzK1/fzI1KKg9mgvXb2OcqPtuKmdD8QqEe1EE
         fOavFTA6mZq0FdVk9uurr9BGH/UKgFqqP6aN8t7AuqCI1pgj4JpWDZsbRtUFH7UGzmt6
         9K8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RbPgAJpwyTltewryTCHRP6PSiXTnCpNjZf2qNCYCqfY=;
        b=adfv7WkfYeIRNTMw0FIFH9E8o+d3FinUTOpfc4YIE4M0uyQdKD8k9T+qqGC06dMyMs
         /hFYDoyTVjW1AUrL4BohrpCa+FEkst7NNM5vHpgeetn7ofyAgG3kEQjZ/sGRmmzWLrvi
         3tkJg/MM+aeAbKo2eeftyeHvmlfkGnntAtWITOLiYWJJlpVkkArY0DUP/clPQngYb4hq
         85M8HmsmA3slZIKbePYHKCDU+SsHnNFZTK1QPHwK78gar9C3MpJah6pVwLxUa5r0NaVu
         jKskJ6/vL1hq2y0n5kPq4Q83D0DEBXDpK4poQ8XjcQxf/aJEF39F98fGASgQRX9wvix+
         pqlg==
X-Gm-Message-State: AOAM532idrCNR7zIXJgys7v0/Kdp7+2RCz8cX43eYnifEKJOBc7B7Fa9
        yThr12zbkvlz/SZTk873hD9cmJVwa9Ma74Qy0Qc=
X-Google-Smtp-Source: ABdhPJzlaXuWv9VEjq3u07yR1jGIzKFFv/8RHNPRpNpXad//dPrrslsyVgYQ4n41jhGvRwvIdC1LKTB7b04Wpu5T+gA=
X-Received: by 2002:a05:6830:142:b0:601:a01e:95c1 with SMTP id
 j2-20020a056830014200b00601a01e95c1mr980796otp.86.1650592298646; Thu, 21 Apr
 2022 18:51:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220419205624.1546079-1-shr@fb.com> <20220419205624.1546079-2-shr@fb.com>
In-Reply-To: <20220419205624.1546079-2-shr@fb.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 22 Apr 2022 07:21:12 +0530
Message-ID: <CA+1E3rLem2p+FMhni3DLek5Bcwt_HtYRFmfuQirdRhBEz=Qabg@mail.gmail.com>
Subject: Re: [PATCH v1 01/11] io_uring: support CQE32 in io_uring_cqe
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 21, 2022 at 12:02 PM Stefan Roesch <shr@fb.com> wrote:
>
> This adds the struct io_uring_cqe_extra in the structure io_uring_cqe to
> support large CQE's.
>
> Co-developed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/uapi/linux/io_uring.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ee677dbd6a6d..6f9f9b6a9d15 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -111,6 +111,7 @@ enum {
>  #define IORING_SETUP_R_DISABLED        (1U << 6)       /* start with ring disabled */
>  #define IORING_SETUP_SUBMIT_ALL        (1U << 7)       /* continue submit on error */
>  #define IORING_SETUP_SQE128    (1U << 8)       /* SQEs are 128b */
> +#define IORING_SETUP_CQE32     (1U << 9)       /* CQEs are 32b */
>
>  enum {
>         IORING_OP_NOP,
> @@ -201,6 +202,11 @@ enum {
>  #define IORING_POLL_UPDATE_EVENTS      (1U << 1)
>  #define IORING_POLL_UPDATE_USER_DATA   (1U << 2)
>
> +struct io_uring_cqe_extra {
> +       __u64   extra1;
> +       __u64   extra2;
> +};
> +
>  /*
>   * IO completion data structure (Completion Queue Entry)
>   */
> @@ -208,6 +214,12 @@ struct io_uring_cqe {
>         __u64   user_data;      /* sqe->data submission passed back */
>         __s32   res;            /* result code for this event */
>         __u32   flags;
> +
> +       /*
> +        * If the ring is initialized with IORING_SETUP_CQE32, then this field
> +        * contains 16-bytes of padding, doubling the size of the CQE.
> +        */
> +       struct io_uring_cqe_extra       b[0];
>  };
Will it be any better to replace struct b[0]  with "u64 extra[ ]" ?
With that new fields will be referred as cqe->extra[0] and cqe->extra[1].

And if we go that route, maybe "aux" sounds better than "extra".
