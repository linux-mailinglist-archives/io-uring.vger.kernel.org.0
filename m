Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F9D56AEF9
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 01:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiGGXYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 19:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiGGXYU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 19:24:20 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7492313B0
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 16:24:18 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id z1so9165980plb.1
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 16:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dmo8X72/JNQ5LF6nWpBtMQYgexG0PROO0COFtluTV90=;
        b=EY7lJvN2P5ViJL1ox4lcQTaH4yUMoeB/69Tc/FSN7iG5wwW8qwD20bN8VDCWV6tJxB
         0L5TiAYATWmcdOd0GCz7qMr5nuSZTFZ3qEl+51SiG7zPDuUa+yQaMi2EZ0IURP08mQTr
         nxuoqnaVmKJQzGIKQNldR7YrPZCuaXtvAv+Kla+OcQtYzZxkMlqa7+bQ0MPFQBvkPOA8
         jUvE+luQZLemwprvNqFTeIs7ei0MA6QZHwnB/IkpoHWA3NK9xUjamdYYkz9FxMEnzu7c
         XSFgxAaFCffhciidQl5ypdsEb8qQL17ETQwHGW+8uNvZOAFdjzaoaCYPMNauuB+crttx
         ATmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Dmo8X72/JNQ5LF6nWpBtMQYgexG0PROO0COFtluTV90=;
        b=rPBP8+EG56vFe2NTfOYlr4q7pA767+jXPxBlpVjpCHSDkYfEvzNpWBNuaoF4Fm/bfq
         vRUf/lX1/FrLJZN0tLArvbGjkJtcCJ2AMYAwdI2op9qUj/3YUzdgg4F81da07B8EK1nE
         phKGB8F4pPd2n1iTDQv7Am+jLMyr/15SIcmVUC7OhqLF4KF/qGrz4HDvsLwySuEBkNHS
         NSbMtYIvrJ5y4o4UweSTHAumBDc4D0ldkGtJYsxn4mWM5fxTPDMJkNhvh47XoNNiNb+N
         /aEbLLZUjPIvj4ZgSsQXE08I4UkfHvlVd5nnABQk1xJNUXWz62cSDrNvtpqF5pl6MK//
         5KNw==
X-Gm-Message-State: AJIora+3HorBoLy5bnS1YvNNkr98GGCFjyMqnKo6I7CL1UzAeUnda+7L
        j73XxjwMYrytMSn7CLUpF3GST2Ms8vRdsw==
X-Google-Smtp-Source: AGRyM1sjFV6TqFreRnAmL0uQs3ukaHDtXDZNKRuDK3abPbbAAdYXNBlNKpn2RLuMIcOdrxiS7W/hxw==
X-Received: by 2002:a17:903:2d1:b0:168:e83e:dab0 with SMTP id s17-20020a17090302d100b00168e83edab0mr365853plk.118.1657236258142;
        Thu, 07 Jul 2022 16:24:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s65-20020a17090a69c700b001efeb4c813csm94014pjj.13.2022.07.07.16.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 16:24:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET for-next] Add alloc cache for sendmsg/recvmsg
Date:   Thu,  7 Jul 2022 17:23:42 -0600
Message-Id: <20220707232345.54424-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This abstracts out the alloc cache we have for apoll entries, and extends
it to be usable for recv/sendmsg as well. During that abstraction, impose
an upper limit for cached entries as well.

This yields a 4-5% performance increase running netbench using
sendmsg/recvmsg rather than plan send and recv.

Post 5.20, I suspect we can get rid of using io_async_msghdr for single
vector sendmsg/recvmsg, which will make this less relevant. But as this
work isn't done yet, and the support for eg ITER_UBUF isn't upstream yet
either, this can help fill the gap.

-- 
Jens Axboe


