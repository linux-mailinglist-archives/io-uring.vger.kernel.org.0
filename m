Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE7C565D57
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 20:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiGDSIC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 14:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiGDSIB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 14:08:01 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA91510FE1
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 11:07:59 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
        by gnuweeb.org (Postfix) with ESMTPSA id 66B0A80272
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 18:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656958079;
        bh=Le4QWudZMqf7rKwP2pUajyaaOPW5dzshZ5+2NfiMUQc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ePOHBjAVAO2ajEVgUvXU0/EK6GPn2dH8CkCvRAIn7zYmGqo5zDh4YUivvnCAv0mVK
         XdzFBzW/qoxsY7V0ToFXJiVnrlfCO5f1P3ub7a3xTb+QeRULhG/rSAgnX33exKT0ys
         D2MLDO1ELTwcVAxba89hFQEK1v5h/uPRFxhRxOC/61vbp/Dx7qrnRxagyZKhXL+HMQ
         L880/uxq8R6A5o1iEnX4pwZhdQ501+eqho2DbnwrVPn2lJlRwpjcVM9/k+gQ4ORiTC
         BHTIRIofD6Ma7JU11aXlFVA8ddTPP1207qYUs7P6v7hHgbVF0egxJ4tZ1tV2h2gkLW
         bYvdiyOPYIIbg==
Received: by mail-lj1-f174.google.com with SMTP id a39so11885547ljq.11
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 11:07:59 -0700 (PDT)
X-Gm-Message-State: AJIora+2HW02i9OtJNR3h5OnCoHqaaUjN064s/0aFAyP98+rAXCbxaaP
        yQTs0DHNTYmfGcyAIgSg6kvAJi/11Ub2XQmcoNg=
X-Google-Smtp-Source: AGRyM1unO21TRw+wAyQz8SDgGJTAAAJyRMC1gfJLDLI+pGHH2jpbi3LSFglV3CBNgASPMjXBT/ciLUWQKyCpWGktM4c=
X-Received: by 2002:a2e:9f46:0:b0:25b:ad86:e41e with SMTP id
 v6-20020a2e9f46000000b0025bad86e41emr16383827ljk.143.1656958077428; Mon, 04
 Jul 2022 11:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220704174858.329326-1-ammar.faizi@intel.com> <20220704174858.329326-3-ammar.faizi@intel.com>
In-Reply-To: <20220704174858.329326-3-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 5 Jul 2022 01:07:46 +0700
X-Gmail-Original-Message-ID: <CAOG64qNmhpyk2GzsqH6FM_NXKeNncnrn78863GTde3E-qeuqPA@mail.gmail.com>
Message-ID: <CAOG64qNmhpyk2GzsqH6FM_NXKeNncnrn78863GTde3E-qeuqPA@mail.gmail.com>
Subject: Re: [PATCH liburing v3 02/10] arch: syscall: Add `__sys_open()` syscall
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

On Tue, Jul 5, 2022 at 12:54 AM Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> A prep patch to support aarch64 nolibc. We will use this to get the
> page size by reading /proc/self/auxv. For some reason __NR_open is
> not defined, so also define it in aarch64 syscall specific file.
>
> v3:
>   - Use __NR_openat if __NR_open is not defined.
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
