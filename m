Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E2B70B727
	for <lists+io-uring@lfdr.de>; Mon, 22 May 2023 09:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjEVH47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 May 2023 03:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjEVH4N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 May 2023 03:56:13 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF0EE4F
        for <io-uring@vger.kernel.org>; Mon, 22 May 2023 00:55:49 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-76c657dab03so63560039f.3
        for <io-uring@vger.kernel.org>; Mon, 22 May 2023 00:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684742148; x=1687334148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d8GH0gzPnlofl5Yp+yhE6MY8RcdxL32UyGKyoQOMYMk=;
        b=iHWdak2VkbCFQA1pi6rmWt2IVFE0g9ePjkMcUiRwYr7TECZeZtqzBmiGFHmLljeSte
         b/1dm/rRu6sL7QEAxVeTIl0UrhsdwVL8hlWNvE71Tc9rMoycC3CnsAdTU3JwLGBkve8r
         LtvtaTWSgTp9+W5jMOjSYmb1DDiTZNZIqfRSVNjHxrQR9D5Mcfn+uemwyjHvUF+0dE4a
         R8LdjoSqWlhv4X9JXLpS7RuOBx40tpBUKYkuJMZsq/wiGiR5jZ7N177g+/wHrQsfiy53
         6NOahhyGt6u4yEhetYOyOKClSQq/1+AvCV+caCi+HlSX/wzhdQ2TocNOv4Yb2tk/2rPB
         6uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684742148; x=1687334148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d8GH0gzPnlofl5Yp+yhE6MY8RcdxL32UyGKyoQOMYMk=;
        b=SR195a+DhwCA1WaHn5XiLfzm8n3FsO0VHQtGUIu4e++S1+N8CkU8yExeZPXKbi7ZRu
         NnM0IXlsh7Jrh424OPpENic1efApyEzFCWtO3RWGrrHdx7NBcG5+DfQae+tSxpWulIxU
         pcAEeC+GFSWviQTkfRQVy4K0JESHtIamFC/6iBLLwr2TA9DJj2APsY4RLVITBLzacfyC
         w7E9E6g2d2oiF9yf/cRc5QjgWrR8/bg5y1c20RXvDSqPblHf3nl7kNhN/A5qGMBi1mmO
         aNfLBP9tBqsW11mN2olP0xTE1fQPQwnFIqK+qKmZS0upuO/9LJcnhymBk8RNS8UmkErv
         L6QQ==
X-Gm-Message-State: AC+VfDwaippxWcrS8QSGGW5rYac5zVn8i3WRccJa2UwIuNFiovLaWNsX
        8zMQmAH08kGPZoPNN9SksW/JZYO1mJFafoSM5FWcendL6Sc=
X-Google-Smtp-Source: ACHHUZ4/8WTb5HyaFKoZFVXP01Xagt+KOKMK2TUpETendA/cvfNHSueaHFuAtwW7vhFMEGPpniYztfueIShPpr+Q+CE=
X-Received: by 2002:a6b:7b01:0:b0:76f:e3fb:a2c0 with SMTP id
 l1-20020a6b7b01000000b0076fe3fba2c0mr6491579iop.15.1684742148517; Mon, 22 May
 2023 00:55:48 -0700 (PDT)
MIME-Version: 1.0
References: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
 <CAAehj2nmnN98ZYzcFMR0DsKXqEM7L8DH8SM4NusPqzoHu_VNPw@mail.gmail.com> <4ec09942-2855-8be4-3f51-d1fedea8d2f3@gmail.com>
In-Reply-To: <4ec09942-2855-8be4-3f51-d1fedea8d2f3@gmail.com>
From:   yang lan <lanyang0908@gmail.com>
Date:   Mon, 22 May 2023 15:55:36 +0800
Message-ID: <CAAehj2kOScdWU6_N+gs-Zo+yCx2Q2_x5vdX3U=Cc8R2=ruJb9Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring: more graceful request alloc OOM
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Thanks. I'm also analyzing the root cause of this bug.

By the way, can I apply for a CVE? And should I submit a request to
some official organizations, such as Openwall, etc?

Regards,

Yang

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2023=E5=B9=B45=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=80 08:45=E5=86=99=E9=81=93=EF=BC=9A
>
> On 5/20/23 10:38, yang lan wrote:
> > Hi,
> >
> > Thanks for your response.
> >
> > But I applied this patch to LTS kernel 5.10.180, it can still trigger t=
his bug.
> >
> > --- io_uring/io_uring.c.back    2023-05-20 17:11:25.870550438 +0800
> > +++ io_uring/io_uring.c 2023-05-20 16:35:24.265846283 +0800
> > @@ -1970,7 +1970,7 @@
> > static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
> >          __must_hold(&ctx->uring_lock)
> >   {
> >          struct io_submit_state *state =3D &ctx->submit_state;
> > -       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
> > +       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
> >          int ret, i;
> >
> >          BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
> >
> > The io_uring.c.back is the original file.
> > Do I apply this patch wrong?
>
> The patch looks fine. I run a self-written test before
> sending with 6.4, worked as expected. I need to run the syz
> test, maybe it shifted to another spot, e.g. in provided
> buffers.
>
> --
> Pavel Begunkov
