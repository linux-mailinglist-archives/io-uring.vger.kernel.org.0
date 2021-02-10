Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E463169EB
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 16:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhBJPRM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 10:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbhBJPRI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 10:17:08 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3B8C06178A
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:06 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q7so2244473iob.0
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uTi32Hsqx1DwK1Nv0hSsoqcKWrJlxgz0ET7X2DmtW7o=;
        b=eOzrRwcd6AhimHmE84A1jkGPAuzV/hnvQ+BJbtx5ZptAjBDGOQU3wHEe2IopuC59fL
         MJ/bAuUl5gX/rOkszmO1JIx2VHdGeRnnGbFba3qVVjvcO3DWl1dqsouL+c54tEZPvwmF
         0Bev3Dyuh9M4zoKZLyOoTORc46Su1fv++xHlrEQzH9a1mFIigDgMKe745shjNGeHkQBH
         1VoBvcWMdacwzjW9tODtdeBjGUosKYXG3c+ZB9h2lynaqUK4dOzu/fpMBdckxBZI4xSI
         qqXYl4DdiXms5pbtPr82TDE9Bo0T9AqD0jfiYml2M0YWZoUDi1WawRUQRQcekB/rgX2k
         8sMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uTi32Hsqx1DwK1Nv0hSsoqcKWrJlxgz0ET7X2DmtW7o=;
        b=H8MzT90rlPe5AmkONJG2Dvpg/5XijjF5AA3o3xCHh97PqsXvk743CEVlLLOp5nV3fO
         voC6B1OHtuTt3Kb41MYIDvBp/UixKTZQyoXfYae1SI5TnIeTMfh0KYwp2YCrpYcodB1C
         71LlgGMt44V9aoKfNfbUstSzwDI3kBM5/90OXqAFwUB3qzSUeU9oINe1XZuX0BTlojK3
         aqshCBwHJgi8jkqzr37USMxdcyOTT7jDOqvBTOurRhHucbnkTwy8/Nv7GFmsQXlL4sxh
         HyuDbZMHBaoWpQgKP5pfYhmG0eJ24VcRCGqYd63wjnLG4I22RULJ5IQ9/Vxsng/zS78a
         8R4w==
X-Gm-Message-State: AOAM532Y9rDVtJp3OstCmauPZXvVlmrM7Szw+jFXyHUTtMjpoSHd9mNF
        xI2I6+z0duBMdQqNLDK9fh9YqMSeFlfyoQWC
X-Google-Smtp-Source: ABdhPJxTeWhs6KEJHrHLG8ApuljJfj3sk0wEzaA8PZ9NBAjBYOPayP/0G4NruzXnJut+OP3mwaTlhw==
X-Received: by 2002:a02:6953:: with SMTP id e80mr3793245jac.111.1612970166199;
        Wed, 10 Feb 2021 07:16:06 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm1027952ioc.34.2021.02.10.07.16.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 07:16:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHES 0/3] Mem accounting and IRQ req cache
Date:   Wed, 10 Feb 2021 08:16:01 -0700
Message-Id: <20210210151604.498311-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This builds on the stuff that Pavel and I have been tossing around:

Patch 1: Enable req cache for the last class of requests, those that end
	 up completing from IRQ context. That's regular file/bdev reads
	 and writes.

Patch 2: Enable SLAB_ACCOUNT/memcg accounting for requests

Patch 3: Use memcg for the ring array accounting as well. That moves it
	 outside of rlimit memlock, though we retain memlock accounting
	 for registered buffers.

-- 
Jens Axboe



