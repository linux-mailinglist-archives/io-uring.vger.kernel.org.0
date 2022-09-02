Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672325AA7FB
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiIBGUX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiIBGUW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:20:22 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78763AE53
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:20:18 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        by gnuweeb.org (Postfix) with ESMTPSA id 6275080C53
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 06:20:18 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662099618;
        bh=PiaEYF9V4R1/VV1YtAFSzk79pFqLN+y5TIiv+FSE56s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mnNkN92uJXdo3xqbEP36Sw3HyUsy03SKZfGbzIFp0w+ynPaUGxLe3ORP9gajbYLYH
         GuiUesPOYaerWmLQSY/MwHFTGf75+ZJSEIQVcSbpZ7KEbRip1mSceQeYwq5gDqp/UN
         K8vLEF5p1dDeQJI++aCSZ/RIPnc3p2C2I8ZHi4DgSySYPSPDgdNuKVe0sYbZ4VdPoC
         9f+OfKAOnYRPhMSno3dbnANVNsMIFhOQBSPvsVd/jVgMICdbiF9wt/zu4Q4qtTqSot
         kyMIlMWtaG2CpXvIWAah9H3gPMY4zAovCeZBwOmBFILBqnMSkZti7p4LlieDL8b1Zb
         aWhuy0RBBkZMg==
Received: by mail-lj1-f170.google.com with SMTP id b19so1238576ljf.8
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 23:20:18 -0700 (PDT)
X-Gm-Message-State: ACgBeo1+y2Vxu7RTMZ3yJ+zSa0ZPKrp1NR9fNxUhvuhREj/m4eiBIqip
        71wGAnLV7n6CivcKxMdosaGHm5PDBD5jiMOjqj8=
X-Google-Smtp-Source: AA6agR7GW23Xy3Ac1fkxma7INLS6VSFes+RjSQ46zy8JJSkGpawwqWwAoHocdoi3b8NJFhvzqMnwbce2b9+qdL2kQtg=
X-Received: by 2002:a2e:b8ce:0:b0:261:ada1:d803 with SMTP id
 s14-20020a2eb8ce000000b00261ada1d803mr10016692ljp.143.1662099616566; Thu, 01
 Sep 2022 23:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com> <20220902011548.2506938-7-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-7-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:20:05 +0700
X-Gmail-Original-Message-ID: <CAOG64qPRXCgZNpLivB+2ZbTm5WQm+ip5=mLb6+xZizouCdRKEQ@mail.gmail.com>
Message-ID: <CAOG64qPRXCgZNpLivB+2ZbTm5WQm+ip5=mLb6+xZizouCdRKEQ@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 06/12] t/files-exit-hang-poll: Don't
 brute force the port number
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 2, 2022 at 8:18 AM Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> Don't brute force the port number, use `t_bind_ephemeral_port()`,
> much simpler and reliable for choosing a port number that is not
> in use.
>
> Cc: Dylan Yudaken <dylany@fb.com>
> Cc: Facebook Kernel Team <kernel-team@fb.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
