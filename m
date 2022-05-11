Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E6A5233C4
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 15:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbiEKNPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 09:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242882AbiEKNPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 09:15:15 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366C66B7C5
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:15:14 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-deb9295679so2745427fac.6
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/YiN+4De7KbvFLtBNApX/wO1HMLqf85/WU1oFiw5GP4=;
        b=j1Mwh9FDWbws2uMSn0V+sBqtnKqxUFYuxoYQjC/6dy58BprpoxLZZDvVXK2b5q0R4h
         hOiGyGOTpgkSObpKRKQYxqhGBRwuZSVTmGG6zw0BKcM5e6jdmJgE2onimfJxLY7gq2Eu
         GkWAHaOKWmLTerbDGvAd6cEGRuyLBSNq+V+cvSU4dGEk0V60VRvGR+sXNkvhpTwPaWTL
         HxhbbQQMJan9QHe4KMhNpVBUy0Uz7Ds8OXDUwUxG2aEhqMQZjBMWcHjEWqSxdmDlBLkV
         dBtpPonhzq49MSsA5XFxVDBYYRYux2VdouchKgAbgj8Dpaeyfu95lFNE0KhqzOS3dlGA
         rHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/YiN+4De7KbvFLtBNApX/wO1HMLqf85/WU1oFiw5GP4=;
        b=Xmkb6TSYoJxedRuleeZynou89XC3AmRgLYBLps9k1XDX9EyaKgVnrP2p+QGQepvSwk
         ESVxjUYdJCwbr9/qq8CnEKzpT8f9xOoofPAjSbcKfUiDTdlmelAH3RJ3OcbuYBeOYaqE
         cSHGrmyaPw5VzYIXRt6Pf08HDIXCAxRK+a9NwfKjFyomv81Z8o615HnpmsI6Ao8b3AXb
         Kh77JAyvAcCVh5MlcBq2Gkk21GXyAWFNPu3NQIKRn4vVRuMSGb9Mnyp+IsvdU380sE3k
         S5iOc6KNPgpy5EiOSoIK3gbmIB9V8e9sQBP6R2bN90/FVqe7pGYQtGzoDl/rC07o3TEH
         kITA==
X-Gm-Message-State: AOAM530kIP4UdNCWGfJFFPpIcPxNNg116BWz4wLUAlTzfdV2rYzv7nYC
        F/nAlmVd5gkOFBkBGGWcdUp56vPPzaOMFXDo5dI=
X-Google-Smtp-Source: ABdhPJzBzN+cZ6x717t2j99xK2JBS7sD7mQ4UCSCSdWINjK+8VegDUh6mQneTC60tLZgCEpXeViwN0QYOVZnnNuDQ6A=
X-Received: by 2002:a05:6870:6006:b0:e5:e6f1:5f2a with SMTP id
 t6-20020a056870600600b000e5e6f15f2amr2650016oaa.160.1652274913458; Wed, 11
 May 2022 06:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da@epcas5p3.samsung.com>
 <20220511054750.20432-1-joshi.k@samsung.com> <b7f8258a-8a63-3e5c-7a1a-d2a0eedf7b00@kernel.dk>
In-Reply-To: <b7f8258a-8a63-3e5c-7a1a-d2a0eedf7b00@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 11 May 2022 18:44:48 +0530
Message-ID: <CA+1E3rLe0QASNQFMwSjOe-xn_JMzrtG416cAKBTdore+hYYk5g@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] io_uring passthrough for nvme
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, Anuj Gupta <anuj20.g@samsung.com>,
        gost.dev@samsung.com
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

On Wed, May 11, 2022 at 6:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Which patches had changes in this series? I'm assuming it's just patch
> 1, but the changelog doesn't actually say. Would save me from comparing
> to what's in-tree already.

Compared to in-tree, it is Patch 1 and Patch 4.
This part in patch 4:
+int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+               unsigned int issue_flags)
+{
+       struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
+       struct nvme_ns_head *head = container_of(cdev, struct
nvme_ns_head, cdev);
+       int srcu_idx = srcu_read_lock(&head->srcu);
+       struct nvme_ns *ns = nvme_find_path(head);
+       int ret = -EINVAL;
+
+       if (ns)
+               ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+       srcu_read_unlock(&head->srcu, srcu_idx);
+       return ret;
+}
Initializing ret to -EINVAL rather than 0.
We do not support admin commands yet, so ns can be null only if
something goes wrong with multipath.
So if at all anything goes wrong and ns is null, it is better to
return failure than success.

And I removed the lore links from commit-messages, thinking those will
be refreshed too.
