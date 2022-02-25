Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF024C3A74
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 01:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiBYArW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 19:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiBYArW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 19:47:22 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0238B0D30
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 16:46:49 -0800 (PST)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        by gnuweeb.org (Postfix) with ESMTPSA id 3EF417E2A3
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 00:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1645750009;
        bh=ylxb9aXNgXNBH+uyWNT1OFQXhShEQMh/op4b+jhmMWc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GsltgnT7pQ0ULZ7xObE9qfYWRtEy/JuSUYmp6bzbOLA3/Mk77SROwCHztQd1Ge9pm
         cMMes4XRkMyYr0kmt7wvd12X2J+4UUHbnCnVnC6P8O6Fewjqb8br9sqqH75eGQDI9Z
         Nl39MXfxpOqJ7pOj1IRurioh/WFSM3Fd2aLZYJQizEABMGK/v1lUO95T8nmwsaWIv5
         kYV4LHyVE1Ym9jsTRwI5koelYi+A1DI05HRrhCBdQHthA2XGt4Hu1drGgD/Dc0a4ef
         GW0ISs8D5AUruVq1xuUzwAg5JEu+nUviU0mN5Ufua99MvB/Y1V6W0/pWXXXL4Luhxc
         gmDDHVLAENuWw==
Received: by mail-lj1-f171.google.com with SMTP id e2so5248205ljq.12
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 16:46:49 -0800 (PST)
X-Gm-Message-State: AOAM531V+cMiLEi4icipp8UMJK5LhqqJTa9HfzTlOI6/Y2Kv6639dA4N
        vDeND1Mt2msgN3gzgnatwfZaWu/XVsjoaLPzjZc=
X-Google-Smtp-Source: ABdhPJyDJQo/mw0jBatf8hhDL/kzbG0K9E28iURiqmaCUJnLtxO7M+5FOfFydkvK5aiE7P1NDQM1cLD5oK9n3kUYlcs=
X-Received: by 2002:a2e:a37a:0:b0:22d:7f2b:23c with SMTP id
 i26-20020a2ea37a000000b0022d7f2b023cmr3734359ljn.81.1645750007267; Thu, 24
 Feb 2022 16:46:47 -0800 (PST)
MIME-Version: 1.0
References: <20220225002852.111521-1-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220225002852.111521-1-ammarfaizi2@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 25 Feb 2022 07:46:36 +0700
X-Gmail-Original-Message-ID: <CAOG64qORUFkWjO3e6paDrG9NhykTvd+RCfwFgjADHjxn+N2rSA@mail.gmail.com>
Message-ID: <CAOG64qORUFkWjO3e6paDrG9NhykTvd+RCfwFgjADHjxn+N2rSA@mail.gmail.com>
Subject: Re: [PATCH liburing v1] queue, liburing.h: Avoid `io_uring_get_sqe()`
 code duplication
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Nugra <richiisei@gmail.com>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 25, 2022 at 7:29 AM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
>
> Since commit 8be8af4afcb4909104c ("queue: provide io_uring_get_sqe()
> symbol again"), we have the same defintion of `io_uring_get_sqe()` in

Typo
/s/defintion/definition/

with that fixed

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

> queue.c and liburing.h.
>
> Make it simpler, maintain it in a single place, create a new static
> inline function wrapper with name `_io_uring_get_sqe()`. Then tail
> call both `io_uring_get_sqe()` functions to `_io_uring_get_sqe()`.
>

Also, I tested this, the fpos test failed. Maybe it needs the recent
kernel fixes? So I assume everything is fine.

  Tests timed out:  <rsrc_tags>
  Tests failed:  <fpos>

  [viro@freezing ~/liburing]$ test/fpos
  inconsistent reads, got 0s:8192 1s:6144
  f_pos incorrect, expected 14336 have 7
  failed read async=0 blocksize=7

Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

-- Viro
