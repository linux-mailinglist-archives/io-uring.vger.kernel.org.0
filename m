Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28564E6802
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 18:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345707AbiCXRrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 13:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236793AbiCXRrN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 13:47:13 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BDCB246E;
        Thu, 24 Mar 2022 10:45:40 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id p15so9317258lfk.8;
        Thu, 24 Mar 2022 10:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/C6Wi8+apkAa+z6xDNWFQEkIKBR1nPVWir8FvzltVcE=;
        b=I7bHlwMO0+f0zK0CXx5nTJxPc40eEjCuRLHcKBBftFa39fYh5SyIT6X82M8exBfiQJ
         ZkFEmdDs2nmuxd++MxGwF0+xsZ6f9syPSL3/A9HV/XUeDpbDXt1uvpP3gQnZKKb6Hoev
         I5R78+QLii543xhcz2fndbWH26D0v4PcJgQDt/5KCaFRmPXzY2MdVAmLGmTH+pDb5ux3
         yTZTMY6RYtCbPQNeie4eExtqxpcupb6ilqamE78pQPV6ECflFjDKMBYfpy46uiHFsBqc
         2rVAdR/QaYIh1CUQSp709+f7ZVqx+KNbNxyQX5dIkJjvUp2zJaffqa3xf5x/yRfDIKow
         NS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/C6Wi8+apkAa+z6xDNWFQEkIKBR1nPVWir8FvzltVcE=;
        b=qQ0KJQul/w8VsQlSi0MbfExaexD/CBAnf052Q7y8QFBZZ7TVIHxBx52ZQXA5tC5vHR
         aSUqdWqbJtOD32OhuWGZ0ntCaOwG1xwZAhe/Ip4JOeRplJ7cCGYqSNc744Ub19j+Pn/e
         LklH6nL58L4JiJq/1+51vwRll/tuV8UVrVDBsr8UTLlGNiwuZq8ZveVTX3nMsb9bMV7s
         xC24np87VDu8xa7uif5nERO0jOixNNXU2CQ4Oy2qqCRqY4p5Dp6yrsxuc+AaTpzvcYzg
         M1N3yST6IJgBkWfdOLa/XaieNL1zv9LCUHeEY//u4TcHOTNnWMG1GsjID85fPpIzjmZn
         A9yw==
X-Gm-Message-State: AOAM532CNXR0aZjI0ZYuKPJccuZMPy+DybS+mYlqfW7QIJQX+aiYp8D1
        SQekx3csCYa9x1orVtm0CAzAYNxyuqMiPPvyLW0=
X-Google-Smtp-Source: ABdhPJw3jE5bSMu2B/HgrDHj58EGXBtoUdyv0j3Jg45FwJ4h7wj3tyj6OLthkCoZbG/3dwSMNRXVSitCwaW7deOA0N4=
X-Received: by 2002:a05:6512:3a95:b0:44a:6189:dad1 with SMTP id
 q21-20020a0565123a9500b0044a6189dad1mr2991299lfu.334.1648143938391; Thu, 24
 Mar 2022 10:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com> <20220311070148.GA17881@lst.de>
 <20220314162356.GA13902@test-zns> <20220315085410.GA4132@lst.de>
 <20220316072727.GA2104@test-zns> <20220324062246.GB12519@lst.de>
In-Reply-To: <20220324062246.GB12519@lst.de>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 24 Mar 2022 23:15:12 +0530
Message-ID: <CA+1E3rJ6=t3DfcqMvpMpTM9jOk=LMq3qnspbcPXkmqbTGVOc_A@mail.gmail.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on char-device.
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
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

On Thu, Mar 24, 2022 at 11:52 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Mar 16, 2022 at 12:57:27PM +0530, Kanchan Joshi wrote:
> > So what is the picture that you have in mind for struct io_uring_cmd?
> > Moving meta fields out makes it look like this -
>
>
> > @@ -28,7 +28,10 @@ struct io_uring_cmd {
> >        u32             cmd_op;
> >        u16             cmd_len;
> >        u16             unused;
> > -       u8              pdu[28]; /* available inline for free use */
> > +       void __user     *meta_buffer; /* nvme pt specific */
> > +       u32             meta_len; /* nvme pt specific */
> > +       u8              pdu[16]; /* available inline for free use */
> > +
> > };
> > And corresponding nvme 16 byte pdu - struct nvme_uring_cmd_pdu {
> > -       u32 meta_len;
> >        union {
> >                struct bio *bio;
> >                struct request *req;
> >        };
> >        void *meta; /* kernel-resident buffer */
> > -       void __user *meta_buffer;
> > } __packed;
>
> No, I'd also move the meta field (and call it meta_buffer) to
> struct io_uring_cmd, and replace the pdu array with a simple
>
>         void *private;

That clears up. Can go that route, but the tradeoff is -
while we clean up one casting in nvme, we end up making async-cmd way
too nvme-passthrough specific.
People have talked about using async-cmd for other use cases; Darrick
mentioned using for xfs-scrub, and Luis had some ideas (other than
nvme) too.

The pdu array of 28 bytes is being used to avoid fast path
allocations. It got reduced to 8 bytes, and that is fine for one
nvme-ioctl as we moved other fields out.
But for other use-cases, 8 bytes of generic space may not be enough to
help with fast-path allocations.
