Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7661E5AA7BF
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiIBGHZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiIBGHY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:07:24 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812FAB9590
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:07:23 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        by gnuweeb.org (Postfix) with ESMTPSA id 0A92280C4A
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 06:07:23 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662098843;
        bh=PiaEYF9V4R1/VV1YtAFSzk79pFqLN+y5TIiv+FSE56s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z7Rh/808MC1d295cYONfwratc/40JzY46xWBTRIAYRA891Vd2eJrK0pCkpeTz90Bf
         74N9GpilRiOSDo4aOcBOkxY2M1nPd/9Skv4vqdze5Oznh6HVLRzdKaqEKR6uSXXbIc
         bOrc3KPWQHN51+v7wXGnd9XBeGarDa0lIQx1rOgjfzCbqPb/yCFjdkw7ZLPJHtFoab
         8ySXspYn0OpHgBAMQhlm2aXYn8PwWWGR76ockLVPKH3n8FoffpwTRRiwct6nOiA+8/
         0asADNae00sYuTkIzW/W/y3cf5qCb80g0D9povcVCRR7FZPnyBP0HfECkAhjjLdVXF
         qoK5SioPst+BA==
Received: by mail-lf1-f43.google.com with SMTP id g7so1783578lfe.11
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 23:07:22 -0700 (PDT)
X-Gm-Message-State: ACgBeo2b92AMAe1NHpUf/bEns2lDtxl9/ZyF2VHgL98i9WBJQNciWPVZ
        JE+vY9zOtTIdRnHaT9F3JMlLs8HhlPG7vXqhLwM=
X-Google-Smtp-Source: AA6agR7zqAsNA+aX2F4bX+1NP6kq6bzXPrNhUcfyFtj/mY5Hk6EztOTtUT+BnxMoMJgMUdv+WSSOFuldDEcqwbEogxY=
X-Received: by 2002:ac2:544d:0:b0:494:7842:23c6 with SMTP id
 d13-20020ac2544d000000b00494784223c6mr5630346lfn.641.1662098841108; Thu, 01
 Sep 2022 23:07:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com> <20220902011548.2506938-4-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-4-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:07:09 +0700
X-Gmail-Original-Message-ID: <CAOG64qNRX7DwcJHX_VMTMODXygxZTc-ciKtM7rcFfNLvGD_Ujg@mail.gmail.com>
Message-ID: <CAOG64qNRX7DwcJHX_VMTMODXygxZTc-ciKtM7rcFfNLvGD_Ujg@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 03/12] t/socket-rw: Don't brute force
 the port number
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
> Don't brute force the port number, use `t_bind_ephemeral_port()`,
> much simpler and reliable for choosing a port number that is not
> in use.
>
> Cc: Dylan Yudaken <dylany@fb.com>
> Cc: Facebook Kernel Team <kernel-team@fb.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
