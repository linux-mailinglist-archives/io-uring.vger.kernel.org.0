Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D7728E3D
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 05:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbjFIDCV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jun 2023 23:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbjFIDCT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jun 2023 23:02:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C49930F1
        for <io-uring@vger.kernel.org>; Thu,  8 Jun 2023 20:02:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2565c66f73fso213745a91.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jun 2023 20:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686279736; x=1688871736;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EE3DCAhezkDxz5vIdXbfcFIbXdDrZcSNl8SsaCm92RM=;
        b=JbXYANjlm9TVIqjkjB0E1B2F4ITp4Ry0RYZfFmm/xNpsjReVVd5NTrdx32LQdnLbxw
         BXznJMtAhTUfcW4zNLga6oOd6Tn3s61MceiKMniH+WdWG9mwdgtYkeKciLw5tCSos0ua
         lvwCiKmNQZz9w+Mbsv/0sxVdvY8+J/Z3umoz8YukD4A2Sp/w1vni/iG1/ZBZp8LtzQF5
         sX68mGw7w9YOVU77hXLdgAK1+seHWwKnUq/fYOTdQX4s/O9pcXr0ROxaPTdxWwHyOein
         cd6k9WAHJBdIMKb3AHkGyO2fTCTcSB6ao1V+Oi82ZA1QOYXis2cgvTM0SJ8sDY2IacO2
         g/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686279736; x=1688871736;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EE3DCAhezkDxz5vIdXbfcFIbXdDrZcSNl8SsaCm92RM=;
        b=bZ07XEiMWOG/G0oMh6pTK22EffKOVGby38B/wvSnPeDg4G7YbLmTWALu2f4/pKPKJl
         N1oqgRUKAeH0EzhElA8A+bzTWl2NIWU633OVKmsZfWuJsLekfzDDj9V3p93KT5joRCU9
         7G+/H2YmXG6/cb5REixVRaqQywB0KbdXTBOYXWtYt5hAWrjG8D0Z5LQd/PFG7tghT/Q9
         BHMY0xeFIbup08x2rV7yVh2CxZk9wkb3jqmLPFBNKP1YnHG+MWLI9BU3+42a3cyZfwoj
         J3VWCGtH7La8pk58dKvOEj4mZJ1G6YuNus+UMt34tmZQNQymnSqE81VfMo3nw3nr1L1g
         XCIA==
X-Gm-Message-State: AC+VfDyeuMXU76vc7ovL/TRAjHkIglnJcDJgLhG535AYlLMpETqIWGkr
        urmr3S+hDR4cgF/pZx3W/wR3ugWj+s/NEDljXVM=
X-Google-Smtp-Source: ACHHUZ5lZx2YCvaNmBBfnEToX7VOG1Agyyp37Lb2WnJQZY/tIT4W0txlkLU5n5DbL2v/DIlZAl4Kxw==
X-Received: by 2002:a17:902:e807:b0:1ae:8595:14b with SMTP id u7-20020a170902e80700b001ae8595014bmr242592plg.6.1686279736459;
        Thu, 08 Jun 2023 20:02:16 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090282c700b001ac5b0a959bsm2088769plz.24.2023.06.08.20.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 20:02:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
References: <20230609015403.3523811-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v1 0/2] Fixes for io_uring_for_each_cqe
Message-Id: <168627973530.474576.3838052998706625567.b4-ty@kernel.dk>
Date:   Thu, 08 Jun 2023 21:02:15 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-c6835
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 09 Jun 2023 08:54:01 +0700, Ammar Faizi wrote:
> Please consider taking these last-minute fixes for liburing-2.4
> release. There are two patches in this series:
> 
> ## 1. man/io_uring_for_each_cqe: Fix return value, title, and typo
> 
>   - Fix the return value. io_uring_for_each_cqe() doesn't return an int.
> 
> [...]

Applied, thanks!

[1/2] man/io_uring_for_each_cqe: Fix return value, title, and typo
      commit: c8d06ed9bcbf2ae294242f9caacecfa01bf138b2
[2/2] man/io_uring_for_each_cqe: Explicitly tell it's a macro and add an example
      commit: 298c083d75ecde5a8833366167b3b6abff0c8d39

Best regards,
-- 
Jens Axboe



