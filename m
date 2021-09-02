Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2343FF41B
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243832AbhIBT0Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243515AbhIBT0X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:26:23 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3668C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 12:25:24 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y18so3960088ioc.1
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJYsBL5vu9C9t+jIacYLConDE1fyqhDqj93H4V7TFLM=;
        b=ch5yBMWfvYMze1YYU013eeYZNb2ql2ogg96KXO+RbRY21NRSbISD1BgoHX192Qrb8n
         5uTRWmZ2b6LUTRJbiFUhnshSBc8P6nBHigomYrq+u33KUMpCHZg5cMakXkXEzoQuOAtI
         oMJ0rwRE1XCdjuIAOEa9G6yKvNvqCL/ugDlPlhrwnxMHwP9vHTxYjdNVmeD08OW3CvFE
         guDxMFXQz4jIb8zgXUE1kM7aRnWOfMeHuarHLqQdMxDoxFn2OOOuNC9QBVtxP1dTitrH
         0VkDtYeIskEOeFVs1p8YBQuXEK/UsjDnIXAFTR3KTC4zyuWPQXTBei3PaBo3jsNS/Rxk
         4Myg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QJYsBL5vu9C9t+jIacYLConDE1fyqhDqj93H4V7TFLM=;
        b=PrOzWl/nHJc44tvIzbuc7OjaO5aFKj7YrJeV1ZXWFQ3SoQdR7EYGZ6GZ6Eb7E3EQmP
         bu1/zOrivEL0WphYxKrl/B7cOvDxmMVFmuaxuupyeJmxQBmspDwfPTF8xuRNhnIrbubY
         6pQRTdXqYMChuRRiGzQPn/AmkdiZPvaDVjYWQiZdqzH7Dj1Kz3Y4Al70IDU1Yo+509R1
         6NML+hpnXRw5ztef80YwoIDOMHu6xrMta9LCC2t1p8AoLOMk8VKVhVBNY4omjk5t7wPn
         Vk+0dRno75Q+Ixz5LhpCM0sc0enEBUYWzL7NwTTvMww59gRY1PxL8ChA+bPu6RJMOnpM
         c+RQ==
X-Gm-Message-State: AOAM530rUyTWspDlfBeNxSQvYnV9Z/GQm/mjzXBkg+zHAiZzQxZi2FaI
        pJhtACPc5t0i4pdbVzAVLiGe6/nFT04RqQ==
X-Google-Smtp-Source: ABdhPJxRqrTM0Uuod8qyu26O8GpgoQy6gVoSXJhva3U8iY06JBHWc+C404ksQrhh5zIhsapDFwatgw==
X-Received: by 2002:a02:878e:: with SMTP id t14mr4220693jai.4.1630610724198;
        Thu, 02 Sep 2021 12:25:24 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1399406iok.32.2021.09.02.12.25.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:25:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/5] io-wq fixes
Date:   Thu,  2 Sep 2021 13:25:15 -0600
Message-Id: <20210902192520.326283-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Got a report on io-wq stalls, and it turned into quite the rabbit hole
of fixes. There are two main things fixed by this series:

1) Single ring that has a lot of bounded vs unbounded traffic. The fix
   is mainly just splitting the bounded and unbounded lists, so that we
   never stall bounded unnecessarily. There are further cleanups possible
   on top of this, but that should be deferred to 5.16.

2) Workloads that have io-wq work and rely heavily on signaling to
   communicate between processes/threads. This can interfere with worker
   creation, and this is particularly troublesome if it just happens to
   occur with the first worker creation.

In general, harden the worker creation and ensure we handle failures in
terms of allocations and worker creations.

-- 
Jens Axboe


