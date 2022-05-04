Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344CC519A5A
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 10:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346495AbiEDIwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346435AbiEDIwh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 04:52:37 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DECF24BE5
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 01:49:01 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-e5e433d66dso542779fac.5
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 01:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFIh1CyhYoOEEs8kbWR5yCunmbCgcWGITL6fTjmMnQw=;
        b=g3ePdZbj07z/SQtZ3q6Rvxl3hsnUQAUpl5+QnU/2JrBT5r6FbJnGqMdBolz8IJYg/a
         MnPEplvJnmewM04s9hF7speIY4qJveoHobQV4IiZQ3BPczLXKnYohQHLx5mxO7+cqyB2
         FTkJSbHIOs64B5/Dq2JQwiyYBt9EWvy3GEEA7JM0EwcvsYHrrUYbsTdrUESd4T0+77It
         g8SYWDsbdnQX3zKUVrmHv6EUWSDWU7GzP9lmDfebbBYw0oGgUxJeuAwCSVA9KR+mXFTk
         /AMqtYj4N0RR6o6yQCPoYXrNsYt6JlLNYN2lSOqRFSMWpD/LhNLsqGKXTJxY30nWaYwj
         pcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFIh1CyhYoOEEs8kbWR5yCunmbCgcWGITL6fTjmMnQw=;
        b=e8SqjlcK0qUpz73EKs7HPsCAbLGzvFH+s8KXugLnDSweVAAiDuetaL/xdbhf17O588
         is57al6jhFWfSsXiMuQu+uZxYzNHJsfXv6uso/zM0qmVG7LRxzzZNGSVVNbqtpcGIR5b
         O2stgQgDCdjpFudCSrhoScxKw6Fp08JjC9b2z8EuEu8pzVFEh9HxUiIIYjWVoR5Nd3kE
         AzZJG65kfEcSxFoCkWdRMxXS0Gmf/S9YcY5sYsSF3FZ5lZ6usYktZFGtginIJYRl1eb6
         UL9C95V61Tb7y5wpzEQxO82XcWDGV6ByZbKmO0TECIqR9wHVfl/YHQw9O81272FAt2SQ
         Eq/Q==
X-Gm-Message-State: AOAM533Iv2K7ftWBo59W+8e8G6XIc+qzuPw2pe7ePLdl328IrFK+6Onj
        +G/7gFgKBY/cyMqeVAf7f/aJgXYmB31v17+0JCR6iOiZ8M3qIYM2
X-Google-Smtp-Source: ABdhPJwEx0kAfrKjWjHXKJcaJcRGuuwzouzNqXc0CoN/T++pLVvZwPv9SFOZUZ531V61Al+1pH/gUzwuBPJSvDTlur0=
X-Received: by 2002:a05:6870:c392:b0:e9:f20:fa8a with SMTP id
 g18-20020a056870c39200b000e90f20fa8amr3234278oao.15.1651654140641; Wed, 04
 May 2022 01:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220503184831.78705-1-p.raghav@samsung.com> <CGME20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32@eucas1p1.samsung.com>
 <20220503184831.78705-2-p.raghav@samsung.com> <20220503205202.GA9567@lst.de> <CA+1E3rKe6G8UC9Pzkm4Wbu50X=TT5tise8g6umduhj1eTbN0+w@mail.gmail.com>
In-Reply-To: <CA+1E3rKe6G8UC9Pzkm4Wbu50X=TT5tise8g6umduhj1eTbN0+w@mail.gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 4 May 2022 08:48:35 -0700
Message-ID: <CA+1E3rKdAWAKbEGugpWGNrxVQ7FzPLEPsCyT63nhqWTWTum5oQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] fs,io_uring: add infrastructure for uring-cmd
To:     Christoph Hellwig <hch@lst.de>
Cc:     Pankaj Raghav <p.raghav@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> > @@ -27,7 +27,6 @@ struct io_uring_sqe {
> >         union {
> >                 __u64   addr;   /* pointer to buffer or iovecs */
> >                 __u64   splice_off_in;
> > -               __u16   cmd_len;
> >         };
> >         __u32   len;            /* buffer size or number of iovecs */
> >         union {
> > @@ -64,16 +63,19 @@ struct io_uring_sqe {
> >                 __u32   file_index;
> >         };
> >         union {
> > -               __u64   addr3;
> > -               __u64   cmd;
> > +               struct {
> > +                       __u64   addr3;
> > +                       __u64   __pad2[1];
> > +               } small;
>
> Thinking if this can cause any issue for existing users of addr3, i.e.
> in the userspace side? Since it needs to access this field with
> small.addr3.
> Jens - is xattr infra already frozen?

If this breaks anything, we can avoid that by not touching addr3 at all.
And instead keep "__u64   __pad2[1]" and  "__u8    cmd[0]" in the union.
That means 72 bytes of space, but it is enough for the new nvme struct
(nvme_uring_cmd) which is also 72 bytes.
Does this sound fine?
