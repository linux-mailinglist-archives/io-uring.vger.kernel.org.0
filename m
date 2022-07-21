Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3905957D070
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiGUP7Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGUP7P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:59:15 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA8C7FE5F
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:59:14 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id y13so913352ilv.5
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=/HGdaWckrj5B5XknGFaVj7Qmf9IYpIh8aCrhXSfkzv8=;
        b=qY7okS6LkwURxljqn4PRbakvJTpyxYKtGMeA2DOoJQTQ+27sGgSaWje+z+L3MSuRpN
         cDG/lUtImYIPJwBqvQLTecOXrFQkPWE5PU2lcouYEfBXefFJBWyxojw7g+N4za/sXeDX
         ipcAman9/fuvaDI5YVw7SSWx8YAUWNLhx+4eaeOn0VJxCCzB4hGANUWX4vynsGBrKQaQ
         Lw9XpgseacfJRxFyWGVLQtMNB7WoyAse4cmMo1wW5sL3QuNxfPE5MPvFqjNRPR/tFvBc
         WordA2e7a01faOmATXCkHidIRirXtrPxxq1O/hAp3/5sxS7oW3F1yjgza1JKTr7pTBtE
         c13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=/HGdaWckrj5B5XknGFaVj7Qmf9IYpIh8aCrhXSfkzv8=;
        b=PGL/HODGUgYYt/PlYrAGc/cEe6P3oec4AfQu5tWVZLwST4sK9Yf68oAsEuQJyPMSMg
         XIHHt6L3U7DxyTlT42kF2RnqjWfieAr70pnJM49sR042Eeww7fayXA0UgiivkUtEuJRg
         ir9Y5pTQs5HiIABohTZXtqFq1/oCYTlOKIbXNKTtFQqjiiZtmYzbx+h1F1zoFb+1I/6W
         8gBRS3GihTxgbewmR9hwJEpDeqKI6Hoi+mO9dqo4TWXPhEuoPMR+jHWGbq9KrdQg8nHd
         G0VrZCB8/spNQ2SyewIYDn8AZ0oWu5agrFPRkHY3jGn2sEKZZMvy90YuPDSbzswqPeLK
         sMjg==
X-Gm-Message-State: AJIora8NjiObkGLcMThVn01+zN3ATR6cp/Y8B/BvVSqiP8nYit9GHj7G
        R56Cj1zlutLIkYVzKWFhViY2HA==
X-Google-Smtp-Source: AGRyM1us0ZdTdWur1k6+jZyBqfb7BJVriO18djEN1uYMybka4R+DZAX8m4v7RFCOqMDQhmgRf2RBOQ==
X-Received: by 2002:a92:c911:0:b0:2dd:815:3ff with SMTP id t17-20020a92c911000000b002dd081503ffmr5200879ilp.33.1658419153891;
        Thu, 21 Jul 2022 08:59:13 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t17-20020a056e02061100b002dce4cc849bsm827150ils.60.2022.07.21.08.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:59:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     asml.silence@gmail.com, howeyxu@tencent.com,
        io-uring@vger.kernel.org, fernandafmr12@gnuweeb.org,
        gwml@vger.gnuweeb.org
In-Reply-To: <20220721155139.760436-1-ammarfaizi2@gnuweeb.org>
References: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org> <165841756488.96243.3609313686511469611.b4-ty@kernel.dk> <aa364933-4113-3e69-eed9-8fe6a8197f42@gnuweeb.org> <2a1a1e2d-6c9c-acc8-ac46-78d30ba35a6a@kernel.dk> <20220721155139.760436-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH] arch/generic: Rename `____sys_io_uring*` to `__sys_io_uring*`
Message-Id: <165841915229.7243.10328931073655872301.b4-ty@kernel.dk>
Date:   Thu, 21 Jul 2022 09:59:12 -0600
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

On Thu, 21 Jul 2022 22:51:38 +0700, Ammar Faizi wrote:
> In commit:
> 
>   4aa1a8aefc3dc3875621c64cef0087968e57181d ("Delete src/syscall.c and get back to use __sys_io_uring* functions")
> 
> I forgot to rename `____sys_io_uring*` to `__sys_io_uring*` in
> arch/generic. This results in build error on archs other than
> aarch64 and x86-64:
> 
> [...]

Applied, thanks!

[1/1] arch/generic: Rename `____sys_io_uring*` to `__sys_io_uring*`
      commit: 441d376c3c1abccd92d1ba6a5ceb343a4683a434

Best regards,
-- 
Jens Axboe


