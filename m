Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D844E8D5E
	for <lists+io-uring@lfdr.de>; Mon, 28 Mar 2022 06:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiC1EqW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Mar 2022 00:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238061AbiC1EqW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Mar 2022 00:46:22 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E86DFCE;
        Sun, 27 Mar 2022 21:44:42 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id b43so13028720ljr.10;
        Sun, 27 Mar 2022 21:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=21sZB0cQIQyT4qQnFzBbbk2zGnmsUzVxHD9eQSWsXSM=;
        b=O+KOuXPC6hePjUcR3JaYu2NtHEyI4LardvYhun3ke3JbEboM/6CkPnkJJDAwFmCcv7
         XlcLW2To4Am+zfpcyU4zlLlZzHZI46nNlJyy1vUsFRXiPN7dcvH/twJeHnkgJPaoyRUh
         fUyarJt5921dZk4m8OTY+6K5lNXhwvJqqSwhJvlJh8/9SPGCe9S/DNJeoaXJuSCxBKO0
         f2vglgLp/NzEks/xBr5ok9jM+Sg6bLyOl24wwxTIneIEdSQPUxJlCwayzQ38atUrtbUF
         hjR0CVFY+f0Vd6gWn+zf607BCtz0MUpVkAzRLoQwN8jIv4Y8mltXT8kuSaiey7EO+gmQ
         AX6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=21sZB0cQIQyT4qQnFzBbbk2zGnmsUzVxHD9eQSWsXSM=;
        b=p7wgUlKc5WOOdMwqLbGJTt0ogCBi/j4H0kFSvJRfHq5DtYzqDjZonWh07Y4z2QHCbr
         TMHdmUsmnkfKnaCCqpWh5Z5q77VhNtSqc2M21VtivGNGNtP4nTczxzUL5ft8q560wwUp
         gxcKdBr3o9ncL5JTB4zIzP6I4JcwktbaZ0WMZ9G81h6XYRDBo1luovAMgcpm0ZSSMngB
         LwX7h1z9IUrVdc4XuTE8NRlee3t7ryPSz0K9flYi0IwtqsAkNrIC+fcvenTFw49QGWmS
         8l0wRn/VtL4a0m/mAxpEx959OXQuRuFeELcKLyeRgomO5kqBA4hsus/PEnqflSs4AdeB
         nNNg==
X-Gm-Message-State: AOAM532hbr3uhcm6okbXEP4lLAEZ5nVB4+Vqsp828vpBzz3Ta56qUWNr
        w/Qv6dW66qTsf1P2+/qUBw8BJRJSGsoXonKOeic=
X-Google-Smtp-Source: ABdhPJxgExojDOUG55D0M4bMrvzsdvV63x26gqkghravOLYEjaWru8kgts2OevmizkhBxwU1zczAKfndxGYVXDqDtk4=
X-Received: by 2002:a2e:302:0:b0:24a:c997:d34c with SMTP id
 2-20020a2e0302000000b0024ac997d34cmr7433761ljd.445.1648442680381; Sun, 27 Mar
 2022 21:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com>
 <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de>
 <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com>
 <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com>
 <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
 <20220324063218.GC12660@lst.de> <20220325133921.GA13818@test-zns>
In-Reply-To: <20220325133921.GA13818@test-zns>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 28 Mar 2022 10:14:13 +0530
Message-ID: <CA+1E3rJW-NyOtnn2B5CbSusEs46X4O3Qzb_RGtoR1x_aXZfXsw@mail.gmail.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
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

> >I disagree.  Reusing the same opcode and/or structure for something
> >fundamentally different creates major confusion.  Don't do it.
>
> Ok. If you are open to take new opcode/struct route, that is all we
> require to pair with big-sqe and have this sorted. How about this -
>
> +/* same as nvme_passthru_cmd64 but expecting result field to be pointer */
> +struct nvme_passthru_cmd64_ind {
> +       __u8    opcode;
> +       __u8    flags;
> +       __u16   rsvd1;
> +       __u32   nsid;
> +       __u32   cdw2;
> +       __u32   cdw3;
> +       __u64   metadata;
> +       __u64   addr;
> +       __u32   metadata_len;
> +       union {
> +               __u32   data_len; /* for non-vectored io */
> +               __u32   vec_cnt; /* for vectored io */
> +       };
> +       __u32   cdw10;
> +       __u32   cdw11;
> +       __u32   cdw12;
> +       __u32   cdw13;
> +       __u32   cdw14;
> +       __u32   cdw15;
> +       __u32   timeout_ms;
> +       __u32   rsvd2;
> +       __u64   presult; /* pointer to result */
> +};
> +
>  #define nvme_admin_cmd nvme_passthru_cmd
>
> +#define NVME_IOCTL_IO64_CMD_IND        _IOWR('N', 0x50, struct nvme_passthru_cmd64_ind)
>
> Not heavy on code-volume too, because only one statement (updating
> result) changes and we reuse everything else.
>
> >> >From all that we discussed, maybe the path forward could be this:
> >> - inline-cmd/big-sqe is useful if paired with big-cqe. Drop big-sqe
> >> for now if we cannot go the big-cqe route.
> >> - use only indirect-cmd as this requires nothing special, just regular
> >> sqe and cqe. We can support all passthru commands with a lot less
> >> code. No new ioctl in nvme, so same semantics. For common commands
> >> (i.e. read/write) we can still avoid updating the result (put_user
> >> cost will go).
> >>
> >> Please suggest if we should approach this any differently in v2.
> >
> >Personally I think larger SQEs and CQEs are the only sensible interface
> >here.  Everything else just fails like a horrible hack I would not want
> >to support in NVMe.
>
> So far we have gathered three choices:
>
> (a) big-sqe + new opcode/struct in nvme
> (b) big-sqe + big-cqe
> (c) regular-sqe + regular-cqe
>
> I can post a RFC on big-cqe work if that is what it takes to evaluate
> clearly what path to take. But really, the code is much more compared
> to choice (a) and (c). Differentiating one CQE with another does not
> seem very maintenance-friendly, particularly in liburing.
>
> For (c), I did not get what part feels like horrible hack.
> It is same as how we do sync passthru - read passthru command from
> user-space memory, and update result into that on completion.
> But yes, (a) seems like the best option to me.

Thinking a bit more on "(b) big-sqe + big-cqe". Will that also require
a new ioctl (other than NVME_IOCTL_IO64_CMD) in nvme? Because
semantics will be slightly different (i.e. not updating the result
inside the passthrough command but sending it out-of-band to
io_uring). Or am I just overthinking it.
