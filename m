Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A03202A8
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 02:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbhBTBob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 20:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhBTBoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 20:44:30 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2BBC061574
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 17:43:50 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id m1so9190786wml.2
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 17:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2gmT8o5uWuByRsBgaqh/64/L4u8MjA5Bckrlwo9yiew=;
        b=bTCkfXni52uAUUkPMi62d+li+NFSuLHcn6dKYkaqcHMgUBeN42S1ofvctORrXe/ql6
         ITmvsfCbrJDmp5iv2coqpSw/r1vzDaBRFCptl3gmie11Ht6njfDiMNtqjxLjrvjx7EDz
         G3nyz+p1fJ3rSo/al1hLljyEJ1TrKF2MQGheFvcqf6fPl4s6l01srszbGh/5BhT/fERJ
         2Xb/bi4/IAakZY74ZBisERi2kiWBjemXLoqI4mHe9XqqNk8Fr8X7fwGJeM2SBKKfTvWQ
         0/6Z35CqAkdRJTD/p20n/UT9zqWsrfcDq4d+x4vnRH98tdchyYmlxmCJ9LrOJlqbA0xH
         Vk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2gmT8o5uWuByRsBgaqh/64/L4u8MjA5Bckrlwo9yiew=;
        b=QJ10Zx6u6j5IylUwCwWGVOx++cjdiom5Bvd/ETan+gX/i1hI4d+ir+hEPreFM5jSnj
         ytEALLjvVHd4R3UWEu1BggKTHKVfqJ/cv+XbcB8MdML5bcWT1xLg+Iu3EgbJFzQmS9ok
         28QVT6CHkyw7CPKYbquBe4XL9KtwjuLcgubXTcolFAaB63jtMwvoqRCLS+hOotFWiaJS
         C74WswI8YZjyWp44QAPIakpzaZDBOK+rPqq88Jg/ZHYvmK2NYep/2Nm49moWBUOOhRUV
         72ep6sA09xzYHEl9ZW76WF/HDbUpm+CVwLKivst+0G29GtylDM5wyxcSFmnNMskQ6Ui0
         Ovgg==
X-Gm-Message-State: AOAM531ROW8HPZHlQJ6oDW3XGHvxYzBbU/Qc5vYJO/pyxKrA2xiItfEa
        0RDEios1xuXaY4dIwSP9RKekspOKCSzBug==
X-Google-Smtp-Source: ABdhPJz/eJ9lFeR28tqf4gzQCNpn2wATYSharnGD3B8Pd2i4Bfd5DfHNlX134wEugsjSKqm2J1MgTA==
X-Received: by 2002:a05:600c:2301:: with SMTP id 1mr8176879wmo.166.1613785429193;
        Fri, 19 Feb 2021 17:43:49 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id f7sm16056595wrm.92.2021.02.19.17.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 17:43:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] random fixes
Date:   Sat, 20 Feb 2021 01:39:51 +0000
Message-Id: <cover.1613785076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just two unrelated fixes batched together.

Pavel Begunkov (2):
  io_uring: wait potential ->release() on resurrect
  io_uring: fix leaving invalid req->flags

 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.24.0

