Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716C1475D6C
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244816AbhLOQaN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244812AbhLOQaM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:30:12 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BCBC06173E
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:30:12 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e128so31088789iof.1
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PRUFk3fWt0Ep26l0AkSGsM9K8KN1VGOIRrLKhZsbHAc=;
        b=bnhBmWd3xzAyUBjUlomDtKS28RoDzLYZBTWhiq5+S54U7tm6GSQzYe2q21m3NTCMDl
         jsC4wsnWltBC+JqHKC6EP2mBFnTrK3I51uXPVgQA5M7eDqQYbaHPZz5bmEZGszHHD8IL
         6IQ52UEDrcPg6FwAZqr1ahRqpRR2LdA0f+tOIfGYvut9z0Oui9RTRnPzmbRvAVeNRzPK
         Dzw8hzn/zgs6IPkH9vJ0jtdBtvA1WPcJhFF/Antc3GdjiTZ3RM8WvkDYescLq3rMmhjH
         FT/8nxbCDvcSf59bjprIW/aDwaTY+/7MSRTDeq2QI/5taReRxKLAivhtgHuC3zGCOYp6
         qVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PRUFk3fWt0Ep26l0AkSGsM9K8KN1VGOIRrLKhZsbHAc=;
        b=vvoQfQLxlQdm4JDtIrudQzcW/KFEfG6VR99CZNHCpy4D07UqDnxOdn2OrKtA7XoSbV
         g3fqj7cDt0aiDGWWz3nqDyBOYzKwGu1alh4ppXciSNc52CgjuEGjpCsPeCSx6VMD/eWz
         jK1wNmN3ZK5F0ya9n2u5cucPX0sbnY3wB7tGH5lB9uyg5MAJWQB7nkR6UNVGDq9RVzKd
         8laoozzh8gTjLIAiJ/H5xJanRTi5O1VoWtVkgMDyoqemLoHlPim4o9hRR2fQFuMnSzJC
         cRc3gq2KF4mR48lwL/IqfmdsMOJZN4ymqh/4z5GReWqyGlk1I50ghVbmMS/kSKU6TGmV
         o6Qg==
X-Gm-Message-State: AOAM530j1CCjdjCCFdyne0ZV5oY8ZBG2LNF7voW6yxAoVPd4tPgqn3oy
        Ott/oyjRgjmBBJ39v/+fXy+3u3cCMkjmyA==
X-Google-Smtp-Source: ABdhPJzjJl+mcuCe4HqqX1bIcJJEhock+/RceyvJbzgM+E22030zN0Eh7Z4Co0CYZIJ6gkheG6lF9g==
X-Received: by 2002:a6b:440f:: with SMTP id r15mr6751126ioa.128.1639585811665;
        Wed, 15 Dec 2021 08:30:11 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d12sm1338528ilg.85.2021.12.15.08.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:30:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCHSET 0/3] Improve IRQ driven performance
Date:   Wed, 15 Dec 2021 09:30:06 -0700
Message-Id: <20211215163009.15269-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

1/2 are really just optimizations, but were done with the support for
using cached bio allocations with IRQ driven IO. The bio recycling is an
even bigger win on IRQ driven IO than it was on polling, around a 13%
improvement for me.

A caller that is prepared to get a bio passed back at completion time may
set IOCB_BIO_PASSBACK in the iocb, and then the completion side may notice
this and assign iocb->private and set IOCB_PRIV_IS_BIO and have
->ki_complete() handle the freeing. This works for io_uring as IRQ
completions are processed in task context.

-- 
Jens Axboe


