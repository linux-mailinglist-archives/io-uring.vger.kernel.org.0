Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA76582936
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbiG0PBg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiG0PBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:01:32 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D0645F7A
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:01:30 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id x64so13765883iof.1
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 08:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=3chdemHJJf2DxuwzuZVOOS2RqOY32nLqTJq3mM9Yxgk=;
        b=ub54IfEO2lWcl7SkorQZ882U35icrBkcwbIZHFp+XtgFFLDHYPjMJty3HlBWVNJ+LP
         CDC29WIcITTDmihwNtL6Df9iorGI8+IHuGKCpDUjApWkLSG5plPsXAhji0Gnw8cKuIGl
         Ygofc5rwYKZ3jbPL9NCCSkFIiR8XxO6bu0De+tmVvK3YhYC7xX8iyXQNQ7M0Tu5jCbox
         mYPKIaFewUVT1yI4YXUWSe3tVV5vlqFAbQ7Pljnqqwd1OsusqGk+N0wpUmtRMEh+1uv/
         /NsemCTGMgGkH5tQ3+SPLZMeAr3rIuu/lItr2F9qeRmF4Agaeh8YobRICcpd2gBLu/mc
         uj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=3chdemHJJf2DxuwzuZVOOS2RqOY32nLqTJq3mM9Yxgk=;
        b=GKpv/bZIQVWeUShWMaQit/Wib0i9MH/30M362zHvDCj50Xmd8ibqQ7ab7bN9x7bn5y
         Pau/VX32iQkUXuCcIPX8bDVMU+svpplWIu5k4oNvlEwk1/6el+jMOeRIhnXMFq5K+IfJ
         8oyGpxF3NExN8PLUnmjDaym+SZppPcx81W3RV/6EATj0Iq6ooPYLcU09r7zJeOq7KXmF
         rWLfzPQAQvQYqWQnJblIaGnC4aRK72bUZntCmzx2/mX+Lwg6t3pqz/USsb7yhGvr1rpJ
         Ajd1F1z0XfQzm4SDycpprbktX+ILClzJBsD5NUEajyo/6XBzQyLPleBDw0tMOm/1s/73
         /ADw==
X-Gm-Message-State: AJIora+5aEXgAHnqKZydtPk9toZcmcKNKhK3nKF8VeRCzRbjMJCXsxT9
        wXyYC0W7dZEVgCMtLwJeucy4JjcoLA5Zmg==
X-Google-Smtp-Source: AGRyM1sAKxJ8VBS0A7SI0GfquJXVIuTvYyrBw7lnW4b3rqhZQNermbAz9PJDtDgqNmwaZrbvcQz/Tw==
X-Received: by 2002:a05:6602:2d92:b0:67c:b00:422 with SMTP id k18-20020a0566022d9200b0067c0b000422mr7896827iow.187.1658934089395;
        Wed, 27 Jul 2022 08:01:29 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id bp14-20020a056638440e00b00339ef592279sm7913218jab.127.2022.07.27.08.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 08:01:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1658913593.git.asml.silence@gmail.com>
References: <cover.1658913593.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next v2 0/2] notification optimisation
Message-Id: <165893408881.1575345.16179131735370544476.b4-ty@kernel.dk>
Date:   Wed, 27 Jul 2022 09:01:28 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 27 Jul 2022 10:30:39 +0100, Pavel Begunkov wrote:
> Reuse request infra for zc notifications for optimisation and also
> a nice line count reduction.
> 
> v2:
>     add missing patch exporting io_alloc_req()
> 
> Pavel Begunkov (2):
>   io_uring: export req alloc from core
>   io_uring: notification completion optimisation
> 
> [...]

Applied, thanks!

[1/2] io_uring: export req alloc from core
      commit: bd1a3783dd749012134b142b52e5704f7c142897
[2/2] io_uring: notification completion optimisation
      commit: 14b146b688ad9593f5eee93d51a34d09a47e50b5

Best regards,
-- 
Jens Axboe


