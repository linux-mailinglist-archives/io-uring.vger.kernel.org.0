Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD46A564742
	for <lists+io-uring@lfdr.de>; Sun,  3 Jul 2022 14:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiGCMU7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jul 2022 08:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMU7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jul 2022 08:20:59 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B85C108A
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 05:20:58 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        by gnuweeb.org (Postfix) with ESMTPSA id 3AB7880216
        for <io-uring@vger.kernel.org>; Sun,  3 Jul 2022 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656850858;
        bh=xNxUqldcFr/uAxKSfstI26xy2nn7BvNK5PL1Tz18qdI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=imv9jMySdWQtYGHaXQ00F3gHUeWH4tK7/sVp3qgDF4oXLAt3Q5BJZBjoKmIvBOvMx
         45mghysqObS5QlL4gUXQgbATu/MZB3Ndi07KXsRiQvM/9P1Bzqyj0sdNGumtU6yQod
         ep+P5lwQUeKkXUyomlBW5/xRI7xsjrU1ycorcjMvLgF18GhxvK7srU0Ev3fqyTzAR3
         /Oc4tWe8jI7crVm/b96NKMhUjv61npA54DA7OCnhhIJ17M6ru7kUb+18mzGwcCWFAZ
         2NSmm1Xjliye/eawjUBxeqz/eHblRR3VlaWOQ+d9QQg+5FilKttPGsjZA0cH7ExE88
         iNgCRiOoHUhlw==
Received: by mail-lf1-f51.google.com with SMTP id a13so11264654lfr.10
        for <io-uring@vger.kernel.org>; Sun, 03 Jul 2022 05:20:58 -0700 (PDT)
X-Gm-Message-State: AJIora//MFHB5VOwl15UDk1i8evz16gAk2NHAsmvncNIRuWU37WVB7jW
        fQc17nJRP+DnzO0iKrEfN1oEYLWwZe8RC3oIAHo=
X-Google-Smtp-Source: AGRyM1tw3jgSG5Wb8dWVD18EQQX1apIqZeDA3Eq1SSnHTyRS1IkjrPL9PQKYwAgmOKlCs5MDyC/YX0rtwGnPYO7x8AQ=
X-Received: by 2002:a05:6512:2609:b0:481:c42:4279 with SMTP id
 bt9-20020a056512260900b004810c424279mr16262284lfb.165.1656850856355; Sun, 03
 Jul 2022 05:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220703115240.215695-1-ammar.faizi@intel.com> <20220703115240.215695-2-ammar.faizi@intel.com>
In-Reply-To: <20220703115240.215695-2-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Sun, 3 Jul 2022 19:20:45 +0700
X-Gmail-Original-Message-ID: <CAOG64qPF5UNQcPRUNzD4_To0iVg9tEmyWGo-ojhuoqOYsVN6rg@mail.gmail.com>
Message-ID: <CAOG64qPF5UNQcPRUNzD4_To0iVg9tEmyWGo-ojhuoqOYsVN6rg@mail.gmail.com>
Subject: Re: [PATCH liburing v1 1/2] lib: Add __hot and __cold macros
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jul 3, 2022 at 6:59 PM Ammar Faizi wrote:
>
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> A prep patch. These macros will be used to annotate hot and cold
> functions. Currently, the __hot macro is not used, we will only use
> the __cold macro at the moment.
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
