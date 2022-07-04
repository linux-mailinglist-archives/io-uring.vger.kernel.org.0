Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7642565E54
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 22:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiGDUSI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 16:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiGDUSC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 16:18:02 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D8512740
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 13:18:02 -0700 (PDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
        by gnuweeb.org (Postfix) with ESMTPSA id 85BD5804B6
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 20:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656965881;
        bh=AU3YgRQT7Mv7iBYaX4PpiQVcbGNnB7pguInD9Nocv+k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZjRXMJsLYlEnwlGnPFOk2JVnhZSDjB/y3WFOqhQ2pkyxjFjysImRgco3juV1VqW+C
         QmZ0RkW6vV5BbEqQAusd2F/RH0tppi4C6LmmgwMeFwL21rLTAjDfjlZKsgGeK1ulX0
         3h8rxLhGwxGw7DZK7uHbgWuUzPXYU3fadyiNjO0yoO1PQSJKwh4r4ubn7/HkUBu0bV
         duRuMk4lE6EWobXuZgJMD1xl/Wd2XpGZB0C3qAW6Wqae/8XzupFx0u0wRnu37UDVkJ
         dNfV113qV2lK6F9H4uGQ5VdO6r6uohKhpIIXwZAh1AONH6bqOjGeu351jN8/H3r2a5
         nwMrOdZuG2U6A==
Received: by mail-lj1-f176.google.com with SMTP id l7so11451580ljj.4
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 13:18:01 -0700 (PDT)
X-Gm-Message-State: AJIora/Kw3abhSCZqLYk7sCioZxBY4t4jhdrbKrAK7zyyZHO/pFlWlh9
        Fa7jV8U3fuLWxy7Z0rvSWh+u/kK2ykmv/9W4OXE=
X-Google-Smtp-Source: AGRyM1uygxm6OPUk+EmsJ5E/mY9mGI1Kn/0+tMS5vP6YDBvk8N2QN8jfNYYsVsdS1ESAGvGtk27wU2CY9JpXrK9imgw=
X-Received: by 2002:a2e:9f46:0:b0:25b:ad86:e41e with SMTP id
 v6-20020a2e9f46000000b0025bad86e41emr16653372ljk.143.1656965879634; Mon, 04
 Jul 2022 13:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220704192827.338771-1-ammar.faizi@intel.com> <20220704192827.338771-9-ammar.faizi@intel.com>
In-Reply-To: <20220704192827.338771-9-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 5 Jul 2022 03:17:48 +0700
X-Gmail-Original-Message-ID: <CAOG64qMvNFRPLHoCJnAZXEYmvVyw+z3F210=0e5KwcVH-hzGMg@mail.gmail.com>
Message-ID: <CAOG64qMvNFRPLHoCJnAZXEYmvVyw+z3F210=0e5KwcVH-hzGMg@mail.gmail.com>
Subject: Re: [PATCH liburing v4 08/10] test: Add nolibc test
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

On Tue, Jul 5, 2022 at 2:31 AM Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> This test is used to test liburing nolibc functionality. The first use
> case is test get_page_size() function, especially for aarch64 which
> relies on reading /proc/self/auxv. We don't seem to have a test that
> tests that function, so let's do it here.
>
> We may add more nolibc tests in this file in the future.
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
