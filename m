Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE714C4742
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiBYORT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 09:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240671AbiBYORS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 09:17:18 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8662934B89
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 06:16:44 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d187so4781636pfa.10
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 06:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=4HKJXFsqbCU8ZlJrUHK2ZfxHsjnNJeIKGbdPC5wBnjw=;
        b=mZFiO8V9kniKYq13DoQl3dADEHw8FSbWEhVRDjG9QTd6vqn73DZEEfe45rZmQ4snlS
         LHo4nGO5tZVwaUu//jsUwcSRifvgzCrxRDHXys+SfjoQ2TsBS4IS3j460wht37d4EA9J
         9iyyK9Md+jjCp0xmUc4lziltSfy3z3ACrbOe8RLBmuL+dVDmgQUL9E1ycMMJHpWIM4Pu
         6VQWRhi8FYFE3i7IV6u3HlEMYOyjgeckCc4GEZdAR6mTDtpDbtInB4lklcQ10PwSbGo0
         Sw7xUFDMCVz1e/9Oz43gUBf/aCYaYtBql1kiFQ+tl98FLEjOzCtHoZRz6kqqUa6hSrmm
         gPfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=4HKJXFsqbCU8ZlJrUHK2ZfxHsjnNJeIKGbdPC5wBnjw=;
        b=LxzF456gkjE0w3VpW4TU2n9/Jjy9/JWS+Gfv0kUFW06Q4HA4h4zEQeYECIsUmVs2RS
         bRFbsOsS1K6GjlCBgdfBnELDidI4nYC/AAVGiul+xvSj5x24V+eirzom7Dabx+OrWEro
         mWlKUN5noKMM7OJ8XphPixIQRUgdLD69QKH3tDycjk7iI34Wg/BN196Ly8GEpcdwFYR1
         lkodYHOccX6nF8+hrxih1xBGEY09f6Z6yguo7q5kskJlKaRMxo/27P5WQTqzIiNtC+Y3
         fmOlETeGVEOzkTPYtkrilRHes7LwFj/+zUc2RBDj1g44usRHcVDN4BQsTMAK/gCte30S
         p/BA==
X-Gm-Message-State: AOAM530BrlQx9LgWKCqasHxIp8Wpaml2xHawEcRVDeACwAG5tE6TTsIA
        T3XjdcMXxEyCG6P/jOZs/W8ebg==
X-Google-Smtp-Source: ABdhPJyjAU5MM8RYlzaVTzTp+k531UMo32vBtLZfrHF2F/Fa/86qHD2IEB/lqZdRvJWEI7taNPieGQ==
X-Received: by 2002:a63:5004:0:b0:373:e921:c0ca with SMTP id e4-20020a635004000000b00373e921c0camr6311293pgb.154.1645798604161;
        Fri, 25 Feb 2022 06:16:44 -0800 (PST)
Received: from [127.0.1.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id e7-20020aa78c47000000b004de8f900716sm3255717pfd.127.2022.02.25.06.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 06:16:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Nugra <richiisei@gmail.com>
In-Reply-To: <20220225005814.146492-1-ammarfaizi2@gnuweeb.org>
References: <20220225005814.146492-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v2] queue, liburing.h: Avoid `io_uring_get_sqe()` code duplication
Message-Id: <164579860316.5714.11586792942122127124.b4-ty@kernel.dk>
Date:   Fri, 25 Feb 2022 07:16:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 25 Feb 2022 07:58:14 +0700, Ammar Faizi wrote:
> Since commit 8be8af4afcb4909104c ("queue: provide io_uring_get_sqe()
> symbol again"), we have the same definition of `io_uring_get_sqe()` in
> queue.c and liburing.h.
> 
> Make it simpler, maintain it in a single place, create a new static
> inline function wrapper with name `_io_uring_get_sqe()`. Then tail
> call both `io_uring_get_sqe()` functions to `_io_uring_get_sqe()`.
> 
> [...]

Applied, thanks!

[1/1] queue, liburing.h: Avoid `io_uring_get_sqe()` code duplication
      commit: 15c01fcd1b0d37a12d945ab8dcdf96b3e055a4fd

Best regards,
-- 
Jens Axboe


