Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C323056190E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 13:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbiF3LZQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 07:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiF3LZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 07:25:15 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFC74F64E
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 04:25:15 -0700 (PDT)
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by gnuweeb.org (Postfix) with ESMTPSA id 101CD80110
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 11:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656588315;
        bh=CXi9KOrrdX6L2FzQIwPuELoE9m2FoSnMGLqKvm+tOmY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GWa9IZKtYVv6n9UyK+Mu/eX5mItYqAIe07wPGHYk8pvVJqkr4yVAHq65tfpk5aOAQ
         p9t1MS4E0NjdHaPoVVmAdSCokOv9E+WWLsmShih0TasTgSf7xUCZo1oXQEVMtmAiE1
         SAV5rwEGjySyt016Fu9YXmFUlXNUXDhKHXpYDd6M5h4+4UYvpNnztcZCLFdFi1DNrU
         waGB2wugNjqKj+H/NGLNvdLViYBm2mqD7k39hFFaq6EwB7eVfqIiA59+kcMmXif+HL
         zg2kWi4vXr6j4at5DfT4FZBjIlJ6tjMliiE2md5ZV7zRW1o0NuDYbtgFiKk7Tc1hbl
         KBDY6WkDG23Hw==
Received: by mail-pl1-f177.google.com with SMTP id m14so16778084plg.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 04:25:15 -0700 (PDT)
X-Gm-Message-State: AJIora/s/5KxXYX4MB2IZK+JDLIOza+09T8LWza0DCBT4+C7s2XT99XV
        eRhLnPPYu1IHe4QjHj7fKNSpGVsloNBaOFmdOeQ=
X-Google-Smtp-Source: AGRyM1seMtDUg3Z50P0vPFHbPt792uaU9P5yNUSIcIZK4IwzApBKEgpYsJmDQ1je1VBm+wR+gz9Pwkd8wNbj66qzznY=
X-Received: by 2002:a17:90b:3141:b0:1ed:4ffb:f911 with SMTP id
 ip1-20020a17090b314100b001ed4ffbf911mr11754294pjb.80.1656588314724; Thu, 30
 Jun 2022 04:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220630091422.1463570-1-dylany@fb.com> <20220630091422.1463570-6-dylany@fb.com>
In-Reply-To: <20220630091422.1463570-6-dylany@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Thu, 30 Jun 2022 18:24:58 +0700
X-Gmail-Original-Message-ID: <CAFBCWQJqVZNQw8rxU1LihhVj5jkfTPqhHbHiPjh=Z6WiF+vODg@mail.gmail.com>
Message-ID: <CAFBCWQJqVZNQw8rxU1LihhVj5jkfTPqhHbHiPjh=Z6WiF+vODg@mail.gmail.com>
Subject: Re: [PATCH v2 liburing 5/7] add recv-multishot test
To:     Dylan Yudaken <dylany@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Dylan,

On Thu, Jun 30, 2022 at 4:19 PM Dylan Yudaken wrote:
> add a test for multishot receive functionality
>
> Signed-off-by: Dylan Yudaken <dylany@fb.com>

Since commit 68103b731c34a9f83c181cb33eb424f46f3dcb94 ("Merge branch
'exitcode-protocol' of ...."), we have a new rule for exit code.

The exit code protocol we have here is:
- Use T_EXIT_SKIP when you skip the test.
- Use T_EXIT_PASS when the test passes.
- Use T_EXIT_FAIL when the test fails.

-- 
Ammar Faizi
