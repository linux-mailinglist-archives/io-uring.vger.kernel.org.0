Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB866A909
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 04:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjAND5t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 22:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjAND5t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 22:57:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728411145E
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 19:57:48 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q23-20020a17090a065700b002290913a521so6596499pje.5
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 19:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdNN+dobdIRHeQn5R/3Kx3xiG0jdhFycvsS2DJTk/XE=;
        b=h4sQ6DJza58g1wD4N+3H2xJha/CdktmXuby34dRRda2IwdQuCyg6ZJ+ob6yUvyy5Y1
         J7OWre8YIPhdN8Eonat+YWIJPnPjfO5ov4jFzl3fKIP+RR8FrOltesZ2AQ8+RVCj804D
         eVhrjD87RF4xZvyx454Iw5nk0sgP1fx9Qn8JovMlWT6wXFbC/qxPrRLd1YRYKNFPWy3T
         ZyCGBKk52/Rxj1u3ZpnGYuYoiIojlOz9Wk4lWuMK0HajB3aKrclrLfpsDdQ37UF3JbzE
         SgT4GcZBC7GF7RKGnBIoMtTqOuTezVG0XP6VDb7T9vSMJONlW7I4XQCRNGIfvC0FLa+w
         N/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jdNN+dobdIRHeQn5R/3Kx3xiG0jdhFycvsS2DJTk/XE=;
        b=oM1DPr2TzQiyZrHF7sY7v2lqEuWVtyve3ecoA/wTxSwNAMoGJeAYth9utJV8/dgNTM
         tqLV6qxvkmmmphe+D9nCnE74ThZyK29UHb/gXaYD4mjKu77xKZRYIFmK256v3TFygXVs
         0I1oAHEF6uWyQhaOaFigE/dZ0+XYnC/g0OJ+VpuDwZagz9vcSgTf29uJgJvzSgGQ5gCW
         nIvhqV1PzzN3zPBfF/zGOg1EK3r+4Fl7kAuIniw5pBfjVIs96IaeuLnf6L8YKZlTbGQO
         6jRuwrEER3GEPtZDm8eFOfQ1cJyzvyDXBeyxnbTXnIbIJcwQ7vXjE6CIXh1e204y8cK2
         6Dbw==
X-Gm-Message-State: AFqh2koz38zUiE8Emn/j0mpx7IpFadTS7PgL9QCx43pSK7sEtdizIxaA
        /iz2hw7x93tYh+uyNeDu7YmR3g==
X-Google-Smtp-Source: AMrXdXt/C/LEFBMnXTyr/zLqZjjFoy8rtByIhu6f9zzeqnbCRqeRIbDGiah9zC8CCx7tPiAavdKlDA==
X-Received: by 2002:a05:6a20:54a1:b0:a5:170:9acf with SMTP id i33-20020a056a2054a100b000a501709acfmr28919444pzk.3.1673668667915;
        Fri, 13 Jan 2023 19:57:47 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h9-20020a63f909000000b00439c6a4e1ccsm12116913pgi.62.2023.01.13.19.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:57:47 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        "io-uring Mailing List" <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Stefano Garzarella <sgarzare@redhat.com>
In-Reply-To: <20230114035405.429608-1-ammar.faizi@intel.com>
References: <20230114035405.429608-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1] liburing.map: Export
 `io_uring_{enable_rings,register_restrictions}`
Message-Id: <167366866699.6195.12346503736898169528.b4-ty@kernel.dk>
Date:   Fri, 13 Jan 2023 20:57:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Sat, 14 Jan 2023 10:54:05 +0700, Ammar Faizi wrote:
> When adding these two functions, Stefano didn't add
> io_uring_enable_rings() and io_uring_register_restrictions() to
> liburing.map. It causes a linking problem. Add them to liburing.map.
> 
> This issue hits liburing 2.0 to 2.3.
> 
> 
> [...]

Applied, thanks!

[1/1] liburing.map: Export `io_uring_{enable_rings,register_restrictions}`
      commit: 19424b0baa5999918701e1972b901b0937331581

Best regards,
-- 
Jens Axboe



