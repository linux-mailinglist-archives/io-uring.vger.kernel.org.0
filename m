Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D584F16E7
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiDDO1b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 10:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377107AbiDDO13 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 10:27:29 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943C63EA8F
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 07:25:32 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id r8so10240063oib.5
        for <io-uring@vger.kernel.org>; Mon, 04 Apr 2022 07:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=njxZPwbhAy5VvluMx0avgyplL5X6yHJpvmwh0qPXIEo=;
        b=q2he80X0zGS1evsZqXWx+wzbOKzrfYMLHWb7xxMfnhQ30Tg6L6jI6sJk6JSowibR/6
         jYUXblvyxiq9GFulOLp9fu8gee2j0n8BuAukJV27A9ZfntSop1W6ejay1lyHOpH7Fuf/
         hfj8UyB1pIG6GjHt+fO3ZR3iIYHBKaU2zXzU4CruF0ZaYpE/7XS1ZNMTYhmgnea1caLF
         lYWKuolP4y4y3s0EpLJzZ2L4Tvh8ysaXjcqeWAifRZxweMYud2CalU7Nfc0MMdiaYs2V
         oXPCJ7Cu5ylLBSuBOX9yCMmEeOuH2Tqc7yVGo/kLIp6/WXLL8dQK0pXm212JM03iIh9P
         shSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=njxZPwbhAy5VvluMx0avgyplL5X6yHJpvmwh0qPXIEo=;
        b=2P7UEGGcA3Lwwud34kmvgo9Dq/h2GWVQ2OtXFAoef6lrHNGqiC4+j3oCXgm7SyiHdE
         5a11VetWWSL3zzBnHupAw6UwPODW5bVqtAAeioSZ0cl/mpkZ/AvrqQqBkQMaIZLEj/GR
         TfeZ7NSXA7rZEJsTFXtrxTCvwGPZUh7WGUzyb+kVEWKYnTQJk8AsJJxBCrBKloTC7sRd
         izy5Tem/kJrLZM3gHXK3EOtPXSjJgdr0sPk8M+/1ksylsissDQFzp8himeWSoo2s5+ft
         JUomutvH7gTvS9sLMRJ1q1Zahs8J+TtMGS77ai93s+vcosrpKlOEMb5NW084Bgj/QvjO
         /kKw==
X-Gm-Message-State: AOAM531ppFkn0V5VOPXcVgcw6g942O/igYNQnvVMc0yPo48qGeOHMi4B
        5QtdDpoFgdXUuWjv553YEB9HklVx+fUM8DL/eAvmXf+uSDRQIw==
X-Google-Smtp-Source: ABdhPJz5vnt/nUrGIypGkIxs9O9318XjCxougjFruCavALiumxradW4Rc752HuwOXqlwprtw9iCFuHl5xNqrfo+UITU=
X-Received: by 2002:aca:2407:0:b0:2ef:5c86:5a09 with SMTP id
 n7-20020aca2407000000b002ef5c865a09mr51580oic.160.1649082331780; Mon, 04 Apr
 2022 07:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com>
 <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de>
In-Reply-To: <20220404072016.GD444@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 4 Apr 2022 19:55:05 +0530
Message-ID: <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com>
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on char-device.
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 4, 2022 at 12:50 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Apr 01, 2022 at 04:33:10PM +0530, Kanchan Joshi wrote:
> > Introduce handler for fops->async_cmd(), implementing async passthru
> > on char device (/dev/ngX). The handler supports NVME_IOCTL_IO64_CMD.
>
> I really don't like how this still mixes up ioctls and uring cmds,
> as mentioned close to half a dozend times we really should not mix
> them up.

Sorry, I too had the plans to use a different opcode eventually (i.e.
for the full series). Just wanted to focus on big-cqe this time.

> Something like this (untested) patch should help to separate
> the much better:

It does, thanks. But the only thing is - it would be good to support
vectored-passthru too (i.e. NVME_IOCTL_IO64_CMD_VEC) for this path.
For the new opcode "NVME_URING_CMD_IO" , either we can change the
cmd-structure or flag-based handling so that vectored-io is supported.
Or we introduce NVME_URING_CMD_IO_VEC also for that.
Which one do you prefer?

> +static int nvme_ioctl_finish_metadata(struct bio *bio, int ret,
> +               void __user *meta_ubuf)
> +{
> +       struct bio_integrity_payload *bip = bio_integrity(bio);
> +
> +       if (bip) {
> +               void *meta = bvec_virt(bip->bip_vec);
> +
> +               if (!ret && bio_op(bio) == REQ_OP_DRV_IN &&
> +                   copy_to_user(meta_ubuf, meta, bip->bip_vec->bv_len))
> +                       ret = -EFAULT;

Maybe it is better to move the check "bio_op(bio) != REQ_OP_DRV_IN" outside.
Because this can be common, and for that we can avoid entering into
the function call itself (i.e. nvme_ioctl_finish_metadata).
