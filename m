Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3121950A071
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiDUNNO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiDUNNJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:13:09 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B1A5F9A
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:10:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g20so6470226edw.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QgfaApU1zmc5wlIgQLB9ywgq8b4pf5HwlrWKwCw8ixM=;
        b=I/qZQ7ATXA2OABe9IO049hHFOjxLVIX6ccXnb1hmkO4i/5xZQ6Q+ehabHd2aNV+Nmr
         q5Iucoa+6iM2OCojmHd6YHz2CsttmNkt4nDSfrJj+5Ay0m548W6B1es4lZ+e6jvojPuk
         XTv9KTv5sQajBDo+jXmMqpkoA8hqwFcB3Xdjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QgfaApU1zmc5wlIgQLB9ywgq8b4pf5HwlrWKwCw8ixM=;
        b=58SaiEv1uaXafqsDlf/1aJZtjRxjziRCeOd9SdLBm/zCA6/bjkwjUFTNgAyPHvttYM
         f9fYJLIfsSTJzBCYQ4N4Kk5SSDNaEMNN1DgOFJUtC++qGUfe8c3Whl0bt9X3V/15J/Hm
         I8xWHmFaUITMPQBlY04YAyI075wqoH3f9qXviE+kH03XYyDplRdH2TpFciicxZGNImcL
         kfc0aRs71nQFmyodg1raUG29Kee0hhiKrNGbP4qKHHNPBPy1SEqPFa/N2hCuo6lYO9Ks
         B2e2oKTP4/yvVOOJfR2SC5OjqRLafadIH2RNnWw2YBBZpLK+oO+s/pk2+t/FbEmtCqnK
         Zodg==
X-Gm-Message-State: AOAM530WxaeRgNPZ7NJdFFZyByxrzU8bLVy3boyjx7IkDDbg3MRcOQ5q
        o2OglZG/GehSDfCcGd33hFyqOA7ybYOz6XoCj/cu1rLOnbI=
X-Google-Smtp-Source: ABdhPJxVfkzuD+SWa5zIwHLLlvgPGydtysTs4D54IpWZBiYMWzDezHN0DuFq29zxfmAAmg4Asc5yFjMdIHC9BVBz22s=
X-Received: by 2002:a05:6402:274b:b0:423:fe73:95a0 with SMTP id
 z11-20020a056402274b00b00423fe7395a0mr15087694edd.224.1650546616246; Thu, 21
 Apr 2022 06:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk> <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk> <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk> <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk> <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
 <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk> <47912c4c-ccc2-0678-6c2f-3e3c0dd1f04b@kernel.dk>
 <CAJfpeguWv7kJn2RReTp0Hfv8hCoAbGSjGmRyNGQnPcU2exrewQ@mail.gmail.com>
 <ca3e4b7e-e9df-5988-5dc1-6d20ce27bdbf@kernel.dk> <CAJfpegsa8uza8bc1aMD7hLzrD6n1=wbxAmQH2KEOnrw7Rxkz2A@mail.gmail.com>
 <05c068ed-4af1-f12e-623f-6a9dde73d1c0@kernel.dk> <CAJfpegvTPc0DR5z80kB6uq=-nMa=+4uxGUqbxiGcOTUiVrR+wg@mail.gmail.com>
 <cc642b7f-5845-41a6-a8c7-a2f3a07e0ea0@kernel.dk>
In-Reply-To: <cc642b7f-5845-41a6-a8c7-a2f3a07e0ea0@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 21 Apr 2022 15:10:04 +0200
Message-ID: <CAJfpegsJwSxQDpBELgw0cCx5dGCW9AaKh_jH25K-BtvRAz1zRQ@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 21 Apr 2022 at 14:41, Jens Axboe <axboe@kernel.dk> wrote:

> Gotcha, ok then this makes sense. The ordering issues were sorted out
> for 5.18-rc3, but the direct descriptor optimization is only in the 5.19
> branch.

Okay, can you please point me to the branch that I could test.

Thanks,
Miklos
