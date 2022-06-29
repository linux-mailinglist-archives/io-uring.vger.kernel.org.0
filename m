Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87DB55F285
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiF2AvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiF2AvJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:51:09 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42B632064
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:51:07 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        by gnuweeb.org (Postfix) with ESMTPSA id 7B73E800BD
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 00:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656463867;
        bh=j4bgt2Nap7QsxlIx7gCY31nLYxfnSRev6A9CMuOHaKA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IHmnFlHMp6L1MoO3bVYrLF3sftfmL9xs2m1ltHS/PotIHFUkkdyy7g5p0PWD6nI08
         OXzfDI8ewbZ2uxr6pPvd/bSsjnogROR+sPL8F+3ybk8FOMnPc+uFI0xK0XX8KzvUyD
         EyIrWZygNF+tW27bi82tZNYAZ2NANi6UO1nPBUJRHTDFTVwaKS/CJ4AAPe41KG+Xf3
         oWhdRrk6R2TZxrNe2WIG10ae8Lz61K2/KnwwGDYp3edFbY/AEWLipm3MYfvAGrXk1X
         AdMlfgl2l+KZk0xnJ9lRFOWfEJ5MMPpjNUozMiiVRts9Mz1zbBTWmps9rBv1dsXe0X
         6Rvt+3VbvgJyg==
Received: by mail-lf1-f45.google.com with SMTP id z13so25116596lfj.13
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:51:07 -0700 (PDT)
X-Gm-Message-State: AJIora9oUzSUW6rcdBf3C7kuxLUYHNJLsfmrnUC/1NIGIRzsLvz6Mf6w
        IzI+1jZfKDkl3vMPwEQUPsyaWu0NHeaNTJIW6Qc=
X-Google-Smtp-Source: AGRyM1tWtFYYO1i4vS2amTwAM54ARtXuazRlV3bc1V/IVS85e09CLUeF5IRI23beFJaNoLhDvt/IG6209cGnPFV/pXU=
X-Received: by 2002:a05:6512:3a88:b0:481:4bb:3246 with SMTP id
 q8-20020a0565123a8800b0048104bb3246mr405098lfu.292.1656463865648; Tue, 28 Jun
 2022 17:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220629002028.1232579-1-ammar.faizi@intel.com> <20220629002028.1232579-3-ammar.faizi@intel.com>
In-Reply-To: <20220629002028.1232579-3-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Wed, 29 Jun 2022 07:50:54 +0700
X-Gmail-Original-Message-ID: <CAOG64qOpHNUO3WP6ve98P3zGEAaykpZP_quo6nce-7=H63s8-w@mail.gmail.com>
Message-ID: <CAOG64qOpHNUO3WP6ve98P3zGEAaykpZP_quo6nce-7=H63s8-w@mail.gmail.com>
Subject: Re: [PATCH liburing v1 2/9] setup: Handle `get_page_size()` failure
 (for aarch64 nolibc support)
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Fernanda Ma'rouf" <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 29, 2022 at 7:28 AM Ammar Faizi wrote:
>         page_size = get_page_size();
> +       if (page_size < 0)
> +               return page_size;
> +
>         return rings_size(p, entries, cq_entries, page_size);
>  }

the current error handling fallback to 4K if fail on sysconf(_SC_PAGESIZE):
https://github.com/axboe/liburing/blob/68103b731c34a9f83c181cb33eb424f46f3dcb94/src/arch/generic/lib.h#L10-L19
with this patch, get_page_size() is only possible to return negative
value on aarch64.

i don't understand why the current master branch code fallback to 4K when fail?

tq

-- Viro
