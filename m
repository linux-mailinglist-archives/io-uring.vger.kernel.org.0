Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4180D565E86
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 22:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiGDUeM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 16:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiGDUeL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 16:34:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428BBBE1F
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 13:34:11 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        by gnuweeb.org (Postfix) with ESMTPSA id D2C33804B8
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656966850;
        bh=werHVDjhyXXA+efNPlTQ32shex9oWxqJ8hfMEp2KKj8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fhJIz0ma7nmEUdj5Ct5/qIqyo5MlE2L73gFBu55Gd4008H60tSUxn7L+0z4LEfT8v
         Mz9oEkfaP3JETLw0cTtu/GLd5o2SMzVJGaTYH2DK50+zPPh4Jw+1MpP8NJoRHAskPa
         p7S4IXy8kqIKFrFZe7TM/SfflnKJsBIm0VG06/mn3z78S+oc3mxe/MJqvQPpbbkaA8
         Fegvuy2cEJis0gzVOny9aa6ukYAEUP+YGzW7DxCBkyu/3s/z4yn2szKneL80oZbGyJ
         lgld6xvcRIKymjQY0CfnX/1F3kygtVtIBh2QjJ32AjaFQIjfrLsmTlgxIBlMLfQ2CG
         QvXeuZPLYxoeQ==
Received: by mail-lf1-f43.google.com with SMTP id f39so17405205lfv.3
        for <io-uring@vger.kernel.org>; Mon, 04 Jul 2022 13:34:10 -0700 (PDT)
X-Gm-Message-State: AJIora9GEcyj4nbXiq8fkjgbinjDNhaHXpOFUxSbQ7GXsFIwmzR7sSXw
        +KT4PBYyU0lAngPqx9WjLMSR+pHjIwVSav2EvTI=
X-Google-Smtp-Source: AGRyM1tfFUUzMWdJJtHPpOjbo0JC/e8cV8cFQXWx2l/N0MAZnCLVf9qfJ7C7HZRE4GoK2Vx04bcxQoSBcgkg0Ywb6mE=
X-Received: by 2002:ac2:5ec9:0:b0:481:16ae:5a55 with SMTP id
 d9-20020ac25ec9000000b0048116ae5a55mr20886082lfq.678.1656966848908; Mon, 04
 Jul 2022 13:34:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220704192827.338771-1-ammar.faizi@intel.com> <20220704192827.338771-5-ammar.faizi@intel.com>
In-Reply-To: <20220704192827.338771-5-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Tue, 5 Jul 2022 03:33:57 +0700
X-Gmail-Original-Message-ID: <CAOG64qN-a8UM3Of621WPX9gcMyVc321MQbu8GS+ARN_F1FZ95g@mail.gmail.com>
Message-ID: <CAOG64qN-a8UM3Of621WPX9gcMyVc321MQbu8GS+ARN_F1FZ95g@mail.gmail.com>
Subject: Re: [PATCH liburing v4 04/10] arch: Remove `__INTERNAL__LIBURING_LIB_H`
 checks
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
> We will include the syscall.h from another place as well. This check
> was added by me when adding the x86 syscalls. For aarch64 we will
> include this header from lib.h but we are restricted by this check.
> Let's just remove it for all archs. User shouldn't touch this code
> directly anyway.
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
