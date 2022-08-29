Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1F5A5511
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 21:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiH2T5H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 15:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiH2T4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 15:56:41 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A87C8FD48
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 12:56:39 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id og21so17872515ejc.2
        for <io-uring@vger.kernel.org>; Mon, 29 Aug 2022 12:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=OZtQcxDcF+QJnwZreYS90MKUZehnViyLLZnnAfp7iKs=;
        b=Jo+jRyct0JadtTzkSOhUx7jwb4EYB6forxbsGELDWVNkBd1q9xLcdkmTUn+j5y0lzz
         Y7vKb84KPkahFmZ/EETT5udumcw2fZN5sQuV9h3P0HESObG58G0PVVZtQjw+HuDlm8/R
         hbSpZxa/BrEAuzOF/uTE+3x4PBDG6PP0gDdIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OZtQcxDcF+QJnwZreYS90MKUZehnViyLLZnnAfp7iKs=;
        b=kLutD3goeeVO58lh+6zTIwMxS51OvEEz0/JQ/piKt8JsfN3Qu63kDGlzQImkMgHNjZ
         H7r6ndhyqTJ0dX1rHRf+CB65R0Xmkad5VGBo1Dc7LD7Xw/L1rp0ci58uz7DtGw1zjD4+
         OYP6eCPI0Mcm+tkr7J8B2aIzemUC8ZWoJfmL7fISVyNtsfY6V9TzezycumpeKjqsXJri
         ci/Qrzjv4UhotgznAPmAeiGxBiWa2hyzbAlnJGU+0660FCIIsCXXzIaN/Yb+aWK4jWh4
         OMZ+hezKAbHkIke5PCxFvXGhHDl6rCQquGA7xUfEeT0Akz6Xrlp6ZSu3ME7YAdExXadZ
         +jbA==
X-Gm-Message-State: ACgBeo1vlXtQ0Opsfd65xJl+pQh6lCdNuDlnJ0oJbQGTYudy5fOUzoK3
        dtG1/ISevOePDu1jernsjftjZDMeftUeJcD3R73wBg==
X-Google-Smtp-Source: AA6agR7IIJCfR7Bw1y9Skcq/ysLsnHHHysKPUZQNxA+37xB2N1tL1nMt7iA++i2bDU2nDJNpzArXYHWJeu2COCEvdws=
X-Received: by 2002:a17:906:7315:b0:741:5b1b:920d with SMTP id
 di21-20020a170906731500b007415b1b920dmr6989272ejc.484.1661802997838; Mon, 29
 Aug 2022 12:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220829030521.3373516-1-ammar.faizi@intel.com> <20220829030521.3373516-4-ammar.faizi@intel.com>
In-Reply-To: <20220829030521.3373516-4-ammar.faizi@intel.com>
From:   Caleb Sander <csander@purestorage.com>
Date:   Mon, 29 Aug 2022 12:56:27 -0700
Message-ID: <CADUfDZrEANpxTZ4y0F7sY2XW-9Arnix=M_xt132eBLs6NFwFCQ@mail.gmail.com>
Subject: Re: [RFC PATCH liburing v1 3/4] man: Alias `io_uring_enter2()` to `io_uring_enter()`
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reference to "io_uring_enter2()" in this man page, only to
the updated signature of "io_uring_enter()". Can we make it clearer
that this is "io_uring_enter2()"? I would suggest adding the signature
for io_uring_enter2() to the top of the man page and renaming
"io_uring_enter()" to "io_uring_enter2()" in the "Since kernel 5.11"
section.

On Sun, Aug 28, 2022 at 8:08 PM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
>
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> We have a new function io_uring_enter2(), add the man page entry for it
> by aliasing it to io_uring_enter(). This aliased man entry has already
> explained it.
>
> Cc: Caleb Sander <csander@purestorage.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  man/io_uring_enter2.2 | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 120000 man/io_uring_enter2.2
>
> diff --git a/man/io_uring_enter2.2 b/man/io_uring_enter2.2
> new file mode 120000
> index 0000000..5566c09
> --- /dev/null
> +++ b/man/io_uring_enter2.2
> @@ -0,0 +1 @@
> +io_uring_enter.2
> \ No newline at end of file
> --
> Ammar Faizi
>
