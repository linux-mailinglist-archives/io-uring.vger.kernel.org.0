Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEF475D52
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 17:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244773AbhLOQYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 11:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244772AbhLOQYY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 11:24:24 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B91C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:23 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p23so31055630iod.7
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 08:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+S76o+lU5f8Y6L550JpPm+xHI7UPiFEDOIxOuBfHgB0=;
        b=eeoTCD/lXC4ZHgBvmLhuznfU5045cTL3rZBg0aucp9SwMeHfDr4LaOd6y7iDeiZGUv
         psVwuGV1538JFC9lVJJEFmIQVpQ/jWQko5AFv+GII/Vbr1DsSlG1QHMhnm1A7kpTa5ya
         uSZsePJed0yFhPR1AfQopDFeU+iVtafKjDFcQ2ZlW89tBQT1C3CEadtFwtZwqM956aSE
         tzzlzlq5OngmA+MEc0YZUfKnD6H6cwcy253tRlPjfxhUSxlpVy6RMeq8on+KbfM+gBj4
         cgPhBTu6N+pMyxqy6RTEWqVGPIrBhAZxH2whW101yMpTYJx/KJe3Ktq3UWjfz0CbltrO
         TEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+S76o+lU5f8Y6L550JpPm+xHI7UPiFEDOIxOuBfHgB0=;
        b=m8ghj5ZQ/iindA1PLKFB3Hc0YjU2cvZCkI8MefD9zgIf5PXKkw4CFtuDVsvXdXHRIM
         snXthu3t2iX+to+MxSY9RaiUBVQ+6rfUpIZ+2LIQuqOWdfNqVwZvSBF9M8dVO0/GxlV/
         b8z3nEgOE3kZfx65bAqpcugP1TQiT9JlgFFDxyes0w8ir8/BZkDGcsGjU2sVKWupKC1x
         itfh482l1XN9VMiTMmFt4dN/8EfmscP7GJXz9BhEELcLH0fMQp3CVldK38dYb/PEZj/C
         l3o8K6F/0a9Pqa9SAABJZevlqKgPS9EqoKgc7MPM0panUuA6sTgrZqLkI2Rwcb4f/NOR
         UzsA==
X-Gm-Message-State: AOAM531bJCZXNyYCp6KCxipYkwMd2U/Zg9hV3LHtAMponXCUvW7gx7ZJ
        UFpBL1QfzoetqR5EoupOeYxmQsmp4Egx4g==
X-Google-Smtp-Source: ABdhPJxFcatts9sLXYdkAle2BfEi6ILJixpQxLDbxTgbcDO9VpviBfTNuiW4VHa7ldCY9PKRGgFbmg==
X-Received: by 2002:a05:6638:140d:: with SMTP id k13mr5935052jad.37.1639585463015;
        Wed, 15 Dec 2021 08:24:23 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g1sm1153170ild.52.2021.12.15.08.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 08:24:22 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [PATCHSET v3 0/4] Add support for list issue
Date:   Wed, 15 Dec 2021 09:24:17 -0700
Message-Id: <20211215162421.14896-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

With the support in 5.16-rc1 for allocating and completing batches of
IO, the one missing piece is passing down a list of requests for issue.
Drivers can take advantage of this by defining an mq_ops->queue_rqs()
hook.

This implements it for NVMe, allowing copy of multiple commands in one
swoop.

This is good for around a 500K IOPS/core improvement in my testing,
which is around a 5-6% improvement in efficiency.

No changes since v3 outside of a comment addition.

Changes since v2:
- Add comment on why shared tags are currently bypassed
- Add reviewed-by's

-- 
Jens Axboe


