Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CD151E7CE
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 16:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347497AbiEGOeX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 10:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbiEGOeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 10:34:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559A31580B
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 07:30:35 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id r9so9441062pjo.5
        for <io-uring@vger.kernel.org>; Sat, 07 May 2022 07:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=swogEftYbB//HtbyOUiayttUVH7FQVSVOm4pHfz0h7o=;
        b=D9Zs+1PovKCax4clUheneg+mBtal57nEBUuRiYiimUHG9OlJo2qIGHpHLWcMrE8GlV
         xmmE5dvbus1g0mQhH/LUUuVBDw2qswQtI447EGrM5kAiMui6xPTgAlE1wv4vtDHnqpyC
         yoRM7WF2JtAuLY/CtEy3RBwpTKK6aVGb371cc3id0yoq/PY4g+0YWbFe16BWG4s/EANL
         kobzJyFWW1R0ptl7ZXEtXuQS8qRtQ7gXIdtU5UyR6gmeTRmILDVqKaHqZh1+9RpZKLsm
         5ltMWF4OSr9hQfhuI8ZfGRol4Gq/pFMW5hb1xGmLYdYpgq6QnX2SE5hYj+YyIANRi4Rc
         eABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=swogEftYbB//HtbyOUiayttUVH7FQVSVOm4pHfz0h7o=;
        b=Ofpzjs2aaqFGA1lwvWAB4XfCoSWIwqLW0pxC22/CnDq8xyjRftTjfDgHtwAlduxYdR
         FwgL/pNoyigZ7js7qsUpZC0y+ZliNruTKIUa7SC64RKuQb91lGKhMq+jDcNG3wUhFsqE
         BHWhgwPoghD2zgzlqAf7fAEC8Dv0KOSSN6Cid/qJpk+1yx77ut3VzD4eOQDLbF9y8y2v
         g8hTs+BCSetgkgdXP/K8nwThTpCjxfo6EzLYIjXxrC9JC/Qwvb4g/onNpojZkdUzN/oI
         GI8rCXgxVOoRK6OXLoA3ZkvnAX3rJgMLVNr7ii0KmlZLR/RnPBVafuaWQWLKZMeiOGSo
         nt6g==
X-Gm-Message-State: AOAM533Ho8g+DX/exxHqex37++QN0DqxpZDwhCGMSwL/PQl2c/x0XWBA
        BD3/CkW70OF0oN2HBi4r4n+vB8+RB0+TMg==
X-Google-Smtp-Source: ABdhPJw04mJ8r6FLY6vvWYM0f5lGFQD44aYL56QqJnrZMS68tYNq65+nms2c31osJvAnQ5dj45yTIA==
X-Received: by 2002:a17:902:e542:b0:15e:8c75:e251 with SMTP id n2-20020a170902e54200b0015e8c75e251mr8232926plf.76.1651933834581;
        Sat, 07 May 2022 07:30:34 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h7-20020aa796c7000000b0050dc76281e3sm5332936pfq.189.2022.05.07.07.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 07:30:33 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET v5 0/3] Add support for ring mapped provided buffers
Date:   Sat,  7 May 2022 08:30:28 -0600
Message-Id: <20220507143031.48321-1-axboe@kernel.dk>
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

This series builds to adding support for a different way of doing
provided buffers. The interesting bits here are patch 3, which also has
some performance numbers an an explanation of it.

Patch 1 adds NOP support for provided buffers, just so that we can
benchmark the last change.

Patch 2 just abstracts out the pinning code.

Patch 3 finally adds the feature.

This passes the full liburing suite, and various test cases I adopted
to use ring provided buffers.

v5:	- Minor cleanups
	- Rebase on current branch with prep patches folded in

Can also be found in my git repo, for-5.19/io_uring-pbuf branch:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf

 fs/io_uring.c                 | 324 +++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  28 +++
 2 files changed, 312 insertions(+), 40 deletions(-)

-- 
Jens Axboe


