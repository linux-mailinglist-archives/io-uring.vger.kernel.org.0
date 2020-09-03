Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7860E25B8B0
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgICCVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgICCVA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:00 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7958C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:20:59 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b124so935261pfg.13
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gMXMD7+kCcpHa2UdViC8FYbIFxqIpQtE7YDZzolnWo=;
        b=EUYKhqyj9ku1aWCoeGslPeoBq8PphacpYhVwa8JzPNfT1ZoedLYptIAHNPnsw5KJYw
         /wWeR8+qhKOLqupFo4o2WJ8uIckJMZSeRQTzEwfux8H2DTCECsS1IWoQA2VGnCcPFOq9
         xQPOSRehrmayI8nuwDuLBm87Fbw8N2NC6knb9UncE7e5YKwaXrmVAXhmPjPehRZAhA9P
         JNe24n19BiRj5201RSfw+V60KFZ0ABfy9tMUd0iHABlM64I8ZKdJNp8qH7mYiTpg5FBY
         ViYKBW/K5qBCfB22aGPEZEbf/wC8crWyzVFAuS/eMrtcz43+RBFLH8YCtFIjxFg55SPe
         FsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0gMXMD7+kCcpHa2UdViC8FYbIFxqIpQtE7YDZzolnWo=;
        b=K+OiYIyoYfObMQvjwp5JrEt4B4bgq2eGo9vCSforvFt6XHOv7Bd8LMYH9KPJka2kMe
         g8heExGY8foPVaxYljENSNx4hFjcXjyzqXgZ3tPuzLfOKfrA1FabB3HVjhZbMP2ILjgf
         5IpV8XWH9/sDBoDyJSO8Dj8uEU86JRDCg6kCith3Vpu9GehGb5h6Wn04sd2Lci0C2L9F
         GbgTVMhbPpCzQdbyOPF9z0aallD61XfkvMpaIH6Gvge8huRWIbFIxLXdQmzUiXgUISoc
         E1/pxQjQ0Oe1HebV5B/7pWJPVkiG4pvNmtel64ddnoYezvzk89klNVE81/5x3Y0hfS2X
         X/0w==
X-Gm-Message-State: AOAM530nTJomT1ei+Jt3G8D+6KetyaqUEBLNxY9NtFeDWhqfIM+oYtYD
        whK/YNtqOUmp0jFfnoesbD4sswnFqp9EMp56
X-Google-Smtp-Source: ABdhPJz3rbfqWfv0Ma2xZK3bXWcNq4hrCDFgClW+SeCofFGtAs5XfglgMxyqKmBIDKG61CNTK3oUAQ==
X-Received: by 2002:aa7:83cf:: with SMTP id j15mr1378405pfn.251.1599099657968;
        Wed, 02 Sep 2020 19:20:57 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.20.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:20:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/8] io_uring SQPOLL improvements
Date:   Wed,  2 Sep 2020 20:20:45 -0600
Message-Id: <20200903022053.912968-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The SQPOLL support is useful as it stands, but for various use cases
it's less useful than it could be. In no particular order:

- We currently require root. I'd like to "relax" that to CAP_SYS_NICE
  instead, which I think fits quite nicely with it.

- You get one poll thread per ring. For cases that use multiple rings,
  this isn't necessary and is also quite wasteful.

Patch 1 is a cleanup, patch 2 allows CAP_SYS_NICE for SQPOLL, and the
remaining patches gradually work our way to be able to support
shared SQPOLL threads. The latter works exactly like
IORING_SETUP_ATTACH_WQ, where we currently support just sharing the
io-wq backend between threads. With this added, we also support the
SQPOLL thread.

I'm sure there are some quirks and issues to iron out in the SQPOLL
series, but some initial testing shows it working for me and it passes
the test suite. I'll run some more testing, reviews would be more than
welcome.

 fs/io_uring.c | 385 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 268 insertions(+), 117 deletions(-)

-- 
Jens Axboe


