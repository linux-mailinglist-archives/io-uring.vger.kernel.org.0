Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D885AA772
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 07:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbiIBF4V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 01:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiIBF4S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 01:56:18 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BF72ED4E
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 22:56:15 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by gnuweeb.org (Postfix) with ESMTPSA id 0126980C38
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 05:56:14 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662098175;
        bh=sKw3GRvrlHKJ2AAFXTeJoXo+AEZOe311xdW9+JeN4xs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NUv8jU8zoOFGP/RnM0pyeS2xn4143kVOL+9NNOdzjLPHpjlaokyH1BklbByoGCkii
         qKV7d87lu29Nl3dVVVoLQ856Kfx/xVO2Akd4qy1REFTP7MOrjNmakYyqz1TO1sjcOm
         kFVYApQLuGw/iMKq72aZmgBNcU9qDmFw5xooS65h3XDzTKq0ow1RKT5kqFWRwQBitf
         dXW+YeVIBAZmcrHhd3ekyWwqdkvTkPp2EvZtcpdqjaOr+qL7Lmb4opMOAum4SBiCEE
         Xa3hKRTCRmlnYyZysAtlrcbeK55M2TFNxw5wsZySne6gJ/ZUZCSYu+HHgMKCt6RBRc
         d9SX+lXEeb2Rg==
Received: by mail-lf1-f46.google.com with SMTP id g7so1753356lfe.11
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 22:56:14 -0700 (PDT)
X-Gm-Message-State: ACgBeo03LM5yTxmFEEgEPdsDrxP57p0xKp1ea+WXG3h6EXX32oa8IXwj
        Z/2agaebBOLLfj6GjkAg6gVYaosiI48QencSzD8=
X-Google-Smtp-Source: AA6agR5PN7WtPmQ+JVEoFx3G/75dRt+jUx81WnoR0nDTjg1SHBaWwcAxBPBxPZ1OiwlxA9gRJUTgIBZUy3ctcebHWuc=
X-Received: by 2002:a05:6512:a8c:b0:48b:3e1c:c3ad with SMTP id
 m12-20020a0565120a8c00b0048b3e1cc3admr12289675lfu.678.1662098173023; Thu, 01
 Sep 2022 22:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com> <20220902011548.2506938-2-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-2-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 12:56:01 +0700
X-Gmail-Original-Message-ID: <CAOG64qM=Q_fe1-3+DU672p4HbkLa=7=vGVUoPc8BfSCFm3+dwA@mail.gmail.com>
Message-ID: <CAOG64qM=Q_fe1-3+DU672p4HbkLa=7=vGVUoPc8BfSCFm3+dwA@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 01/12] test/helpers: Add
 `t_bind_ephemeral_port()` function
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
> This is a prep patch to fix an intermittent issue with the port number.
>
> We have many places where we need to bind() a socket to any unused port
> number. To achieve that, the current approach does one of the following
> mechanisms:
>
>   1) Randomly brute force the port number until the bind() syscall
>      succeeds.
>
>   2) Use a static port at compile time (randomly chosen too).
>
> This is not reliable and it results in an intermittent issue (test
> fails when the selected port is in use).
>
> Setting @addr->sin_port to zero on a bind() syscall lets the kernel
> choose a port number that is not in use. The caller then can know the
> port number to be bound by invoking a getsockname() syscall after
> bind() succeeds.
>
> Wrap this procedure in a new function called t_bind_ephemeral_port().
> The selected port will be returned into @addr->sin_port, the caller
> can use it later to connect() or whatever they need.
>
> Link: https://lore.kernel.org/r/918facd1-78ba-2de7-693a-5f8c65ea2fcd@gnuweeb.org
> Cc: Dylan Yudaken <dylany@fb.com>
> Cc: Facebook Kernel Team <kernel-team@fb.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
