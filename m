Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472744FF9C9
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbiDMPNd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Apr 2022 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbiDMPNc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Apr 2022 11:13:32 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F28387A3
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 08:11:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r13so4609785ejd.5
        for <io-uring@vger.kernel.org>; Wed, 13 Apr 2022 08:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWDewBpDE1KYAxb3NfLeZRySWq3f2wjiojxIH9wKu/U=;
        b=OE6Q7Wk+F+8QFBDCPOeS5lPqMFbLmlDwZwiajqdmJ1qV8bNQRSjj1nNfBG7E/WFawP
         /DFh2eU2nljL1gpHx9UGhOd0kX/gOFFZofQVbmLoOQFcKuvHN3SgtovidHEESMbfHYdF
         fsSpg6AVh/gp5W7YU7q2yDO4ZCqWXnpIfZgY/OxTDV5P+XA8f7Pph8Ql5IgadVUocxAQ
         tj2HWnCqdYZM7wFxSJp4JwMYIwi50qNbHm2JUubnSrCXmWfAv3uAys9WBj+dHu1L/jY/
         yKtpPCb/XWhaUAMUElpzGVv4d5KkG0/UxgIGxFnS09DI1CZx60EQ9e/ZaZOhczsrQutW
         lTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VWDewBpDE1KYAxb3NfLeZRySWq3f2wjiojxIH9wKu/U=;
        b=aUh4zG5TIzecy9fwuekEI5chzKgg+PqEB3Kn7+kTpTWMgTvTn2K5I6CnoPZB2TArxG
         JWG4rs3l+bsu7YuAwrVMisYB7ohWsw0DqC0LbH3DJLw/dZO6PXLCHi4fKqOTasJ8kJaE
         Qg6TOKUGf+rTFksGnZ+Yzv3XQeDeKXt3A3fuB+HqrLjjgkHg+dCF+xjM7lSD8ELFDkDY
         RHFaF4EU1fKX9gVaV5WsOyqNf8xaEEbu+I9LtUzFjUr5CmzoOgXbJILIXuTZTNy6ysrc
         0K4GhcVXiKs7WM2B6tgpQj3IgTs/WczYikP47Yw3HF/hKGSazlCNZBMjiF9jCrwrMoZ/
         VeKg==
X-Gm-Message-State: AOAM533BueC9IX12rs4L+qgT03nEvFgiDtwVv6XaznhBn1Ax6GJojba/
        heXElbZkhNDnyzn8YrlX1zekkPF6Qjk=
X-Google-Smtp-Source: ABdhPJwQmr9TOWclIspAqxnAYgDcwHmilL5loEyA1kyCzKt26I+v3+FdK9Bf/ipVz04H5OLXls45uw==
X-Received: by 2002:a17:906:6a1e:b0:6e8:aa9d:d8b8 with SMTP id qw30-20020a1709066a1e00b006e8aa9dd8b8mr9498387ejc.269.1649862669408;
        Wed, 13 Apr 2022 08:11:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.65])
        by smtp.gmail.com with ESMTPSA id j2-20020a056402238200b0041f351a8b83sm1037152eda.43.2022.04.13.08.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 08:11:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.18 0/3] file assignment issues
Date:   Wed, 13 Apr 2022 16:10:32 +0100
Message-Id: <cover.1649862516.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

small fixes for deferred file assignment

Pavel Begunkov (3):
  io_uring: use right issue_flags for splice/tee
  io_uring: fix poll file assign deadlock
  io_uring: fix poll error reporting

 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.35.1

