Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BCE370D99
	for <lists+io-uring@lfdr.de>; Sun,  2 May 2021 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhEBPOS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 2 May 2021 11:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhEBPOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 2 May 2021 11:14:16 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848D5C06174A;
        Sun,  2 May 2021 08:13:24 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c3so355627lfs.7;
        Sun, 02 May 2021 08:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BjGFTI5NPDEP/V/gZNGO/RfGyQ9EUrHklE2SG27k8ms=;
        b=MbI+f8SV4l2rtyLowTIuBDbkmtyXrFXveXNXhIdH++s6FOwGHA5WY5h61JZQ+/9fac
         tsk2SqU4g2KDlgSTBgue9mFjHufdXjdU1ImTouYztUKAFVr5cWerV4UJxkvq8HKDsuxm
         hVm3S8J0cOqxsMH7SzKvBfOM7dqTZNd/u5zMamc7bM8+y7MDGXPkSr+uZgrkqHMfaM7a
         E43k5vW+SZRSPSd9a17sRNAekHQ4gZY1MSwFuFVtGI8mo2AnbrccygTLxOFqtIRepkMV
         Rykra+qiYWadejPTXpqUCbbYl9glbOQ9h7S7acsuFVN0MC0AFfw/A1K+HrZ+SihgwaKG
         6UgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjGFTI5NPDEP/V/gZNGO/RfGyQ9EUrHklE2SG27k8ms=;
        b=b5qlYbLzjb2ExI/8Ziaqa1hTAX5yZdQBE8/uEI9Zpe6D7Wv3lg35h/7qJOESzonZmF
         jS5kLhdcd9GPkqpbP2lRe+QzKD9+jdRsfl2GyNQDbJQm4xiZ6XPoMQjD+0Yp+rCWU889
         db0yX5F5Cx1IMKFn4R/ThENKTHA3WQZ++LhvVvZ0+qUbpgQAxY3dCn7RfX/YJn0F329W
         WE9J07Rpwn/CYiusiLrAJHHragMhYXvbmQ1HNw110QHJhBnM8oEuu3e2ue+vPKun6RZq
         e+vKVulOZy8OOx00/nw97AjQkzs1cCqHPGmjhUcJc2RIRGIfgW/CA7acn4P9vZ+qgVqq
         ZkTA==
X-Gm-Message-State: AOAM533UAHM8j2pbMeD2epc+FTOXNhxqSVDGNR3DQ5Nvma5crCBZ4kuW
        f+WKQtyNo+cK+rkH63CjpDTg0sa20SqlCCcFWGo=
X-Google-Smtp-Source: ABdhPJw5PZhw8+M2BEsgIzY4FDfIKC0fcwAZiOIG/vO1sBuEW+xojN3j0M4SbyAJO/Unm4Vm4nplsNEljLcba6K8KzA=
X-Received: by 2002:a05:6512:20d0:: with SMTP id u16mr9988707lfr.391.1619968402903;
 Sun, 02 May 2021 08:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAGyP=7exAVOC0Er5VzmwL=HLih-wpmyDijEPVjGzUEj3SCYENA@mail.gmail.com>
 <4b2c435c-699b-b29f-6893-4beae6d004a9@gmail.com>
In-Reply-To: <4b2c435c-699b-b29f-6893-4beae6d004a9@gmail.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Sun, 2 May 2021 20:43:11 +0530
Message-ID: <CAGyP=7cGLwtw=14JSfOd40x08Xsj3T2GCeWTjDf2z2v0nb8e9Q@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Read in iov_iter_revert
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 2, 2021 at 4:07 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> May be related to
> http://mail.spinics.net/lists/io-uring/msg07874.html
>
> Was it raw bdev I/O, or a normal filesystem?

Normal filesystem.
