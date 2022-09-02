Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DA15AA7F6
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 08:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiIBGSN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 02:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiIBGSL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 02:18:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5605DBA17D
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 23:18:10 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        by gnuweeb.org (Postfix) with ESMTPSA id EAA3180C4E
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 06:18:09 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662099489;
        bh=PiaEYF9V4R1/VV1YtAFSzk79pFqLN+y5TIiv+FSE56s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=No1Dmn90RulE759qPJz3aXb5367RvQSgqT48aYECAQh5F78OHlDt/cehJB7Kl1wsJ
         aa2ecKxlKdmOncucH+FE0M2RP3IbwCuKZqnHxbMxpziAQyss4KwFo/vxm+KDuGwTpW
         jZnluJ8ejCEVR3UFXQCogvo4Ml+gF2tUbk0soXjCAIBEjiECQh+zmHejWY7Q+nSgIk
         PIWVMx/A1Mh5fo/KgZQTwBNZGweDeVY548qLdFTrDMjw/yvLI5xJ2w9OLtfMBNLabp
         VjeR5huZyhXbfK0tHUp1UTH8kLOSk8kF4FtyhTzrM7Ed8EzLYZYk2x9MF3hP5qwHT+
         lOXemzL0UTHhg==
Received: by mail-lj1-f180.google.com with SMTP id z23so1272205ljk.1
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 23:18:09 -0700 (PDT)
X-Gm-Message-State: ACgBeo2OUAhxFrj3mMdq7e+NbqohpqAzJPDRyn0A5URvlW5XH5WFyQ7N
        tlj5nOmP0IeYpS/72oigPDYiQGGkZM+Up7YHva8=
X-Google-Smtp-Source: AA6agR6zfCQP/9HHkYOrM55z0/zgdQAjMm37PIgcnfNBqEnUpQbQG+HwWgRQyIeWdD5dHICA/1z2EcoZfERLOBkaDvQ=
X-Received: by 2002:a05:651c:238d:b0:268:b732:6b63 with SMTP id
 bk13-20020a05651c238d00b00268b7326b63mr1870738ljb.75.1662099488049; Thu, 01
 Sep 2022 23:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220902011548.2506938-1-ammar.faizi@intel.com> <20220902011548.2506938-6-ammar.faizi@intel.com>
In-Reply-To: <20220902011548.2506938-6-ammar.faizi@intel.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Fri, 2 Sep 2022 13:17:56 +0700
X-Gmail-Original-Message-ID: <CAOG64qOqE7YiHMJ5gfq3A3zPFyQwhJLPehQTYeiHnkRoE-L1Sw@mail.gmail.com>
Message-ID: <CAOG64qOqE7YiHMJ5gfq3A3zPFyQwhJLPehQTYeiHnkRoE-L1Sw@mail.gmail.com>
Subject: Re: [RESEND PATCH liburing v1 05/12] t/socket-rw-offset: Don't brute
 force the port number
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
