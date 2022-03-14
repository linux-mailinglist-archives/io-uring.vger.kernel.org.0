Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CA64D8B24
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 18:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiCNRzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 13:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243487AbiCNRzs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 13:55:48 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4665A2715C;
        Mon, 14 Mar 2022 10:54:37 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id z26so23073284lji.8;
        Mon, 14 Mar 2022 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vQGT4uZiYJ10uuigdD5nlSKxhUgslUyBNqrMBHchbnk=;
        b=EHb+XodK5msez3q4MFWq9nUAeL42BEtNrogXwN4aoDcT13qXy5MrB+OeNyW5goZ4f/
         GZ3nvRdlbunCmOSpAoUw4dSyD8hZBqKM3MWFWp9RtO4OxCttgy/jz51DmtQNk7dEeNHY
         9c6PHgpGdRDa6P68+UMgG7s/y3qwsk7DEARadMEV25tSII3B6WfoneOa5xZBBGFyDks4
         OrbBUmdyV6PFEh8vlhpG5SKIECFn0MnKN1PQpXPLm6GvFJ6SmEsBqbLztjKS9Bdd/3Ui
         36mFvlw3A/+ltOCz62relAxoWVLk9vmV1il6FeGXaqeY9+nZgfOVbITH0CtcI7ecpgcV
         kXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vQGT4uZiYJ10uuigdD5nlSKxhUgslUyBNqrMBHchbnk=;
        b=dDURrJWKWQa+7wE3CvluMKp6QRgm5ufRbKBwkCLsFC2vioYu6N91UfmotocMhOAIvo
         ypiKm8Q4TvOUCjEJXeNAtqVt/MYoAQUnTdqstcnN9Ag8rizDndaXRqPUqW1aVsPYfiZU
         Vt3rjEmrpj1jNGVsU/dNKDhqH5XwyAaG4O1i+urgyTPi2gJNHfMX9QpPrzVTQCIsML+G
         vV7CzET7ED8fUG6ijarqZLrlVrlwSs6njvtCZnkTXq44NjQYCSJFS53ZmTvkBVF2Lpja
         IFFwYZhpQHQM5LAUNa9C647QO7PWve0jp/DFnSOO+tgWU1kElES5EVfp5lj7uupZAWwT
         lTAg==
X-Gm-Message-State: AOAM530cE2LOa2K0iPB/x3gNTOIdlvcuSb8ED+Kc2cKL3kKed6VjCaim
        ET9Xg2hxgk+chxE+XP3444O2Jwl4CZcnOjucXb8=
X-Google-Smtp-Source: ABdhPJw4whtNTcMTfHNtOrsGMruBnT4ZTg9hV4nQOM0a5ZhTl2J/DUQDmQU0wgabSW6pwqkZ4uSyCzg1NhKd2G108nk=
X-Received: by 2002:a2e:90d6:0:b0:246:e44:bcf6 with SMTP id
 o22-20020a2e90d6000000b002460e44bcf6mr15195799ljg.501.1647280472957; Mon, 14
 Mar 2022 10:54:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com> <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
In-Reply-To: <7a123895-1102-4b36-2d6e-1e00e978d03d@grimberg.me>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 14 Mar 2022 23:24:06 +0530
Message-ID: <CA+1E3rK8wnABptQLQrEo8XRdsbua9t_88e3ZP-Ass3CnxHv+oA@mail.gmail.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on char-device.
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
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

On Mon, Mar 14, 2022 at 3:23 AM Sagi Grimberg <sagi@grimberg.me> wrote:
>
>
> > +int nvme_ns_head_chr_async_cmd(struct io_uring_cmd *ioucmd)
> > +{
> > +     struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> > +     struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
> > +     int srcu_idx = srcu_read_lock(&head->srcu);
> > +     struct nvme_ns *ns = nvme_find_path(head);
> > +     int ret = -EWOULDBLOCK;
> > +
> > +     if (ns)
> > +             ret = nvme_ns_async_ioctl(ns, ioucmd);
> > +     srcu_read_unlock(&head->srcu, srcu_idx);
> > +     return ret;
> > +}
>
> No one cares that this has no multipathing capabilities what-so-ever?
> despite being issued on the mpath device node?
>
> I know we are not doing multipathing for userspace today, but this
> feels like an alternative I/O interface for nvme, seems a bit cripled
> with zero multipathing capabilities...

Multipathing is on the radar. Either in the first cut or in
subsequent. Thanks for bringing this up.
So the char-node (/dev/ngX) will be exposed to the host if we enable
controller passthru on the target side. And then the host can send
commands using uring-passthru in the same way.

May I know what are the other requirements here.
Bit of a shame that I missed adding that in the LSF proposal, but it's
correctible.

-- 
Kanchan
