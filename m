Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D513A5ACE26
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 10:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbiIEInK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 04:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbiIEInJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 04:43:09 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35C5B69
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 01:43:08 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        by gnuweeb.org (Postfix) with ESMTPSA id 2C029804FD
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 08:43:08 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662367388;
        bh=6J96x3mW8M3bkDSdhFwYDfhmT16/00u3mv7/kedunFc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Kc293hZy4Y3yPAKz6KVIm04i4hfQQV7NKk10Swd5AW2N5vGTFIX2D4uLKpq3u6c5g
         W9AnAUioIO3MfMVx/WmckSC2b1Bc+znTds2NxhPnfRjDgXa3SNtDo/HK8hw/XIiKBR
         C0sBWkn1K+BGaTfKaYp8w069c8wWjnMNOZ7iojj2xA0fd8UcN6Nvq8u5m/ppOQD8pF
         kZx4tedYQNA8NIKgND5DkktnZleAyHKIx+j+g+KJzZ2WooQM7VdDcDcv4ioaVUH3yQ
         FCWpkpYHp2KdZTQSmvVYEsL2d/8+7FljLE4c+sf8UrGnFj/GGWFbQ7aYAsfWVawaca
         FyrTGSUKl4ZUg==
Received: by mail-lf1-f47.google.com with SMTP id j14so12138857lfu.4
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 01:43:08 -0700 (PDT)
X-Gm-Message-State: ACgBeo2W3Y8TJUjqgEGl/nHdRwdlW8g2gjsLxgnsFH88i6iCdo0WVJyP
        rhnFQ+RgbzD/RP68wqYleL73/vJc0jBIj2gbyBc=
X-Google-Smtp-Source: AA6agR6SH5wlNLo07rYuPlJLs7Y7paovRou6JTU/UoJDNYmMO1lFfSBmTmtBBDM6xRhXq9Bq91v+lWj8cI7YdBg33pI=
X-Received: by 2002:ac2:544d:0:b0:494:7842:23c6 with SMTP id
 d13-20020ac2544d000000b00494784223c6mr10264001lfn.641.1662367386056; Mon, 05
 Sep 2022 01:43:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220905070633.187725-1-ammar.faizi@intel.com>
In-Reply-To: <20220905070633.187725-1-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Mon, 5 Sep 2022 15:42:54 +0700
X-Gmail-Original-Message-ID: <CAOG64qOUeGV1ZY8-Lu01+X=a-sGkxgag7tx3g+pQ_gF8=BGjKQ@mail.gmail.com>
Message-ID: <CAOG64qOUeGV1ZY8-Lu01+X=a-sGkxgag7tx3g+pQ_gF8=BGjKQ@mail.gmail.com>
Subject: Re: [PATCH liburing v1] test/ringbuf-read: Delete `.ringbuf-read.%d`
 before exit
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
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

On Mon, Sep 5, 2022 at 2:12 PM Ammar Faizi wrote:
>         fd = open(fname, O_WRONLY);
>         if (fd < 0) {
>                 perror("open");
> -               goto err;
> +               ret = 1;
> +               goto out;
>         }
>         for (i = 0; i < NR_BUFS; i++) {
>                 memset(buf, i + 1, BUF_SIZE);
>                 ret = write(fd, buf, BUF_SIZE);
>                 if (ret != BUF_SIZE) {
>                         fprintf(stderr, "bad file prep write\n");
> -                       goto err;
> +                       ret = 1;
> +                       close(fd);
> +                       goto out;
>                 }
>         }

should use T_EXIT_* for ret?

-- Viro
