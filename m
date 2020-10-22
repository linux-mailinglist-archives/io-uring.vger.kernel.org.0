Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4685296714
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 00:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372762AbgJVWYx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 18:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372761AbgJVWYw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 18:24:52 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F93C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o3so1884147pgr.11
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EHWh+JCK1d2B14UgroxkEvDL8hqZDC/Um2uDpIH0qhQ=;
        b=KW6TBv55kddGuhn1SuaiU9iZbXmr4UYtdAvTf4rxTbHnsczgHp83xj3rcsEkLdol73
         KSEKifIGcHuCFz1EaekqGclu5VdWk+plYiO5Lv962RpDcOx+fChu0jjKC6E+rBrvnYR0
         s4g2QIepy7HThFlR5eTt7/w9MauFHl50d6nqWKN2ZL2N7tUN+GpmNb/DcQl3hO5pqD9A
         x6AGBDek27p3Bwco96pLnU2PqO+Hcep1AyOwUZpsOAdJegUdvV0AXpxu+DCTheou3g70
         0DeF0bKMMBsBdSmeHpoWja+prE7x/q5rIVDfxBJIjCluN8OzLWRuS4L5N1V1EnWsq1Cu
         y9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EHWh+JCK1d2B14UgroxkEvDL8hqZDC/Um2uDpIH0qhQ=;
        b=rucDj0ItbChkaHUAGaELCs2c1Qqthnq3ylwIiw3LlpAsVP/LIvbYs/wnGrg8xvEGcK
         mPPe9VPFtGsgTIQZIfc8HpMqYI3uL2GXDsXumFvve59LTPSRFzE6pwt6KznsD8i6gLNH
         8NcJeW8tjU/9EChvT7mtgH5kS/dmCfPaVH1RRo31cg0wh3f4N4amXDVr9iYdbx7ezmcl
         rk5YPe+qZrcFlmbdl2MBvIGTlyHXp2DFeJ+tH7JzgpUPfJkIeq9J68R2G24MreBXVssr
         EQNjAwOQ73GJTGBfpqSM4oTKxJMW1nteoyuIaR1gvQrpdNOE7BkMp2qjxF/RVfhqKI2b
         HGPw==
X-Gm-Message-State: AOAM531JeqJywXwCCVKU5VW3ooOL5q+AxYGfQ2hsbeXbPmkuNYLAsEwt
        dcWgYskA60CCEuy7qZHgFnDcZrt/eGNg9Q==
X-Google-Smtp-Source: ABdhPJy2gu0aY8gtyn2r5yodLLJQ6TZoAVUlzn1AAaIPun+RGN0KvXqHnVjx7Lldmg2IyknSqkv4fA==
X-Received: by 2002:a63:4546:: with SMTP id u6mr4049856pgk.311.1603405490441;
        Thu, 22 Oct 2020 15:24:50 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e5sm3516437pfl.216.2020.10.22.15.24.49
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 15:24:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: Fixes for 5.10 v2
Date:   Thu, 22 Oct 2020 16:24:43 -0600
Message-Id: <20201022222447.62020-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Resending, as git send-email aborted on me...

- fsize unification with the flags based setup
- NUMA affinity fix for hotplug/unplug
- loop_rw_iter() fix for the set_fs changes
- splice fix for the set_fs changes

-- 
Jens Axboe


