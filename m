Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D33E98EA
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhHKTlV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKTlU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:41:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCE9C061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f3so4075275plg.3
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=liF4dEwdnHuNB+WXFNY8M9rnSTmZKQ1FmEujE7LGLZc=;
        b=x0fJcEbXPI+uT4caAl8yAw7X7iimxLcZ04+85w6yZgqyk0NIuw/T8lHxDN0Zyay7cq
         sLBUDB10BHMpm+XTyYut2BM2Phns708MjsURQJZH1aKMN4uze0LKQmD0rIBU1gNgFv1B
         0bNxJnposzasPbtIi4K/Pmh3LYIrhjxU2Pm7uprYNP6THIX9Rx1Uv7Mh7XM9YTwrWK48
         QRV8y4r3bD/EnqoOZ4Peox8KXDxlk92g5pr34Y/jmewy+iPSAm/i9cNgSYBeGRgrg2Cs
         yrim6qBeSfGLhN1np0W0fsXNykQZKwO0mDklH22Ku5ndzJ3wjbfwMNxf95BS06dwruFQ
         2ozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=liF4dEwdnHuNB+WXFNY8M9rnSTmZKQ1FmEujE7LGLZc=;
        b=KERInygwMa0I/pZwAMeppUqNg3hHTSa52iEsFwXWSCT+WvATKEpgnQv4kSCMm0wgsr
         wwIQBLw+DXWkNAKXJguPZ2QhSNzier6rjAea0Wm8kLOR7HW+bX1q1fROXA4XyZFZvo9T
         PWlIHBdRu6sys9/UsLC4uSJwdLG2vArOokgrllHNGrDVqDxHulY8+YVnuGXXjVIFfI9D
         4cpY2Iib5KRYJduj/PUk+5qJlMEsSE/MpKtQt97900EwE43hRTYsK3WhAY/czsCLsen4
         X1Kw+uXJYJyi86edQgMQjzayE7YYYMNo2OyTwASQdmLo59E9zjO7zMkr4yYgZh1mRvIy
         iLTA==
X-Gm-Message-State: AOAM533SAS4Alk6lxXVWHzCvP1suLgzqHLQFmub+rXI37HNk2tEP/Mzp
        qOvmVpEDYIIP38JlD7RtbpGsFeApEEulcrt9
X-Google-Smtp-Source: ABdhPJw4VRUx0OmIXx/P0nukRuQ5SS7xSxyJgzMd2GQRVQXmBkPRt3o7h2Icgjve7ckLBhg2qAjUUQ==
X-Received: by 2002:aa7:8503:0:b029:3bb:6253:345d with SMTP id v3-20020aa785030000b02903bb6253345dmr375139pfn.35.1628710856013;
        Wed, 11 Aug 2021 12:40:56 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm336118pfe.146.2021.08.11.12.40.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:40:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/4] Remove IRQ safety of completion_lock
Date:   Wed, 11 Aug 2021 13:40:49 -0600
Message-Id: <20210811194053.767588-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Out of all the request types we support, we only really have a few
that complete from interrupt context. Yet due to those, we end up needing
to make the completion_lock IRQ safe. If we move those completions
through our task_work infastructure, then we can get rid of the need
to have the completion_lock be IRQ safe. That has benefits for all
users.

-- 
Jens Axboe



