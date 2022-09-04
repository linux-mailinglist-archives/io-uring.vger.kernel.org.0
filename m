Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1790D5AC446
	for <lists+io-uring@lfdr.de>; Sun,  4 Sep 2022 14:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiIDMe6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Sep 2022 08:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiIDMe5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Sep 2022 08:34:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26AA24F09
        for <io-uring@vger.kernel.org>; Sun,  4 Sep 2022 05:34:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q3so6060093pjg.3
        for <io-uring@vger.kernel.org>; Sun, 04 Sep 2022 05:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=5raRr6ZZDe6Jj1qSRnjV+9YGFLZagh0QtMJdnm3GuVU=;
        b=AP+j1B0OvPMmZPQ4Hn4xI+h/eWCDFnSFadyLOZykpk+jpvxwmSm14JhoadRlY/XtFc
         XwLvTmybm1vWSJ+0qj1+7HPqhvgTZ4YLsGfHTxhChNNVsXLr3OfR025SVQ4s0zx3djTe
         bYppjx5417mr84jgmO35DFFhoXiy06OuDXN91ujvud7SoF1jPakV8oTZ5y+SPYJ5OaIi
         cbmQzIDBUsaNkMkbt9UVKqHGvp3qvkeRTl4ncTK/SCSr+rzMv0wEqrGyna+NB5ESeWWD
         c/+TxVk4pjRnvQmmEjfnHtY0FFb4TgmXXQ5ssjuG0/yTCdfHI5z778bphDhH8SnxOH8z
         pv6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=5raRr6ZZDe6Jj1qSRnjV+9YGFLZagh0QtMJdnm3GuVU=;
        b=N/ghkCfcQJ8r7Xe9gf9F9OF5M2DiLknHEBcSKfXV3xw5Q6+rCDFQNxKB9fgMGllCZn
         OiVAEhZ8Iflih/mDgnBrqLzvePO7yQezLeV90047O0BRf6BwsRaY4lVlPh5JcQ/zf121
         kRdAqjaO+mrmqX0wtinXdc5rVImzSyDLzz9BukIuHuf0XXLcSw4a4IAOMOoB10GK0OVV
         fFFMw5MGFc60D4fmu0p9j07JfhqndS9j81RVSD9MVpNn4E04i9H048FZ34bUOkX1+yHn
         CaazUs4oiu2GPgRyn7i1HpFiA3jUaRxSV2NtuLPk4If+mOs+HjEC/jWGO63h5O4HztYi
         zN+w==
X-Gm-Message-State: ACgBeo08Xc+MxtlE5EcBT2TIQ4XO/0QBR1tuCpq9Nxpl27nMl+B6pqir
        E/P0ETnL4eQ5w92WFwfK+DO4ydZ3hHUyBQ==
X-Google-Smtp-Source: AA6agR6x9vSa3cjogS76861VY+yicXS/vf+b0K8A+P1ub9Vy5m7tAGogXvssI3BWPeiUOpcdaDMa1Q==
X-Received: by 2002:a17:90a:d343:b0:1fd:b437:7ae9 with SMTP id i3-20020a17090ad34300b001fdb4377ae9mr14969424pjx.73.1662294895036;
        Sun, 04 Sep 2022 05:34:55 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y78-20020a626451000000b0053baf3e155esm956411pfb.74.2022.09.04.05.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 05:34:54 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20220904073817.1950991-1-ammar.faizi@intel.com>
References: <20220904073817.1950991-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v2] liburing: Export `__NR_io_uring_{setup,enter,register}` to user
Message-Id: <166229489367.550813.666494611721983097.b4-ty@kernel.dk>
Date:   Sun, 04 Sep 2022 06:34:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 4 Sep 2022 14:38:45 +0700, Ammar Faizi wrote:
> These macros are not defined in an old <sys/syscall.h> file. Allow
> liburing users to get io_uring syscall numbers by including
> <liburing.h>.
> 
> 

Applied, thanks!

[1/1] liburing: Export `__NR_io_uring_{setup,enter,register}` to user
      commit: 3bd7d6b27e6b7d7950bba1491bc9c385378fe4dd

Best regards,
-- 
Jens Axboe


