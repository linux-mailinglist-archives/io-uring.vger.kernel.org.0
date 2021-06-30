Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF553B89EC
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhF3U47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhF3U46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:56:58 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8D7C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t15so1923709wry.11
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y8CWecbh5rDjtGaaWCGZDXEz4C5IzRvPHZs2xWlWL7U=;
        b=OJ+lym07t1lbiWevrC5pQaNmZ/0nTIFCX5oiSW1GuhRR9IHiD1d5DoRq0e7MXbgVop
         94cgaUYz/1x5hXxADkcPpVJBbwfYEnrLF3hAbDQbCQJ+tfjQPvVo9BhiBHGUgPY3/dpI
         wNTGkGo5gLBjS5AaMpMPhdh/ERYWB8w766yPNy58/tIG+QAZ+S1ofc0hspmTcoL7uolb
         4Kf704I4YG6lxXdiD/ez9j/v2laAnsmc36RPcr0LDrfPBxQ4CLXAV0f3ObmxLcwCfWPv
         YNOv/WG/nsOPWa6B26FHcBYmAAMZh5yfuavmrvHYynBo3xFBc6ylPbyGZXpGUPqMm2Zh
         J4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y8CWecbh5rDjtGaaWCGZDXEz4C5IzRvPHZs2xWlWL7U=;
        b=qM2Wz9rv+VwCSlQ0JZcsZYiRaUbscSF/C52EBaEU7ZaxOYy/1fBc86uNQl5hqu9SaF
         GqxBk6L+ovb6+7zxkfom2mtlaAcPgkejAorytUSRfuo+8KUY1ODBQXpyO8HSl8PQjL/A
         blv2BUcQgb5pz/e7bDMavHp235dsb16YAxqkFR5VWSlhv8jJRw+PUfOKEAfLCq4aGoDJ
         kRp+SYCIhegjLl1VyrbUt8Qj675HjPsNPuxjBNVCokpm/RoqzQlgVJ6Fv9/jUYCRk37G
         Rv7EkBHkVt9G9IV4XmzJAbFmWXuLEZT9SQ+AJy5muDMlET1c1bL6uAfBBYb1W/6XV8ZI
         McqQ==
X-Gm-Message-State: AOAM533EUe6hiWAkqOnJnXWKVgvmJUX7pMi9H9bH2ZEQkrasbTqFH3tu
        VALvJ4UZ1jRA+UR4GnkXi3uVGHVFrHVFe1kJ
X-Google-Smtp-Source: ABdhPJxj2gCoZ+Jm+8MNqfN26Hps08q4jTYgZg7aWMcKbexwvMOfpn3PSNSw9bNwvyej2m9QK76PlA==
X-Received: by 2002:a5d:69c9:: with SMTP id s9mr19228082wrw.155.1625086467166;
        Wed, 30 Jun 2021 13:54:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.26])
        by smtp.gmail.com with ESMTPSA id p2sm22099087wro.16.2021.06.30.13.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 13:54:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.14 0/3] fallback fix and task_work cleanup
Date:   Wed, 30 Jun 2021 21:54:02 +0100
Message-Id: <cover.1625086418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Haven't see the bug in 1/3 in the wild, but should be possible, and so
I'd like it for 5.14. Should it be stable? Perhaps, others may go 5.14
as well.

Pavel Begunkov (3):
  io_uring: fix stuck fallback reqs
  io_uring: simplify task_work func
  io_uring: tweak io_req_task_work_add

 fs/io_uring.c | 131 +++++++++++++++++---------------------------------
 1 file changed, 45 insertions(+), 86 deletions(-)

-- 
2.32.0

