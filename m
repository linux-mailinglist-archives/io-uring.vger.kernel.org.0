Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7F56BADB
	for <lists+io-uring@lfdr.de>; Fri,  8 Jul 2022 15:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbiGHNad (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jul 2022 09:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiGHNab (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jul 2022 09:30:31 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7852CCA6
        for <io-uring@vger.kernel.org>; Fri,  8 Jul 2022 06:30:28 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 145so22348335pga.12
        for <io-uring@vger.kernel.org>; Fri, 08 Jul 2022 06:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U+Pm72BoNs7qFyEK8/XGIh+wHNtiWeSc9CQOPEH6Ivo=;
        b=F/o7DHxvGWro+p4f10ZCE7f1Drppq2/HAvsuvJ02747maHdvpv8gfNLTT8fd+f3bF6
         QvVH0AXJbECwOv9vSmErXICEJnAD84ENksdKXogfOMUGvYlpAFQC7bvQYf6eJdmczX7l
         RCBs/1EMaMpsLrdfMgtiSQN3JjFaPP7Q8M5Yjjo3Nlu1r+/sZdk0LGrNTbI/Bx+h6eKs
         GOGKW9sPAZS+e7O0BZKTgmG+nW04g/o9CgHPfHa/7gFyzkUFGhG+PXPvu1cPUm1LIqIJ
         5fI9izNgPx9uCAlAMTUR59nXzByMeeZ4NqNxXi1CUekyISeb+Jfy2r6+f0SWNwcLcYCo
         KtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U+Pm72BoNs7qFyEK8/XGIh+wHNtiWeSc9CQOPEH6Ivo=;
        b=SkCB5G4t7OTCtHPaEMAvthb74JIirFrVv/4N6DgXexIn7Fsa7gl8uNUy0l76Lotfrd
         3d1Gz7hF/UtWfZvc/0SN0jrL69AGpl0autMFCL1vjhoDfaz5ojvkIF/Z/zm0LUy+BL+K
         hiBH4wmhygAvQLoVIkrV6XWjCDlM2mna69I2Vo5uB64sQMF/iPK4rvPjDlWKpxj8FrzP
         lP5mjBEdP5jH+WWY6wpqdI3B0CYb4YfzMDnz/FpnBGpbUYgDAadg8VsUJ3jMAyh7YKqo
         fgqna0Q+tTPsyLO3F1EXLOrByLC6R4Eq9XI/kfgGwhSImrZf8clMOwQBHe17FwdvNC/a
         28gQ==
X-Gm-Message-State: AJIora8dg5ZFDNrv7sh/bUpezSJHjr8yiE9yeTyq0tLR3D+ksV0/MGOn
        dHaGNHC5q445xQOG3TIs8+k9f0W1BdgtyQ==
X-Google-Smtp-Source: AGRyM1snM3uhVM4ZpjDrZ7bB6Z5A2dZ7IC/JxxyjGrb/K5T6HhYo/3WmPHdBILo5vncYWfefRSgoCQ==
X-Received: by 2002:a63:730b:0:b0:40c:3a65:537f with SMTP id o11-20020a63730b000000b0040c3a65537fmr3261024pgc.267.1657287027492;
        Fri, 08 Jul 2022 06:30:27 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b0052844157f09sm3800502pfl.51.2022.07.08.06.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 06:30:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, dylany@fb.com
Subject: [PATCHSET v2 for-next] Add alloc cache for sendmsg/recvmsg
Date:   Fri,  8 Jul 2022 07:30:18 -0600
Message-Id: <20220708133022.383961-1-axboe@kernel.dk>
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

This abstracts out the alloc cache we have for apoll entries, and extends
it to be usable for recv/sendmsg as well. During that abstraction, impose
an upper limit for cached entries as well.

This yields a 4-5% performance increase running netbench using
sendmsg/recvmsg rather than plan send and recv.

Post 5.20, I suspect we can get rid of using io_async_msghdr for single
vector sendmsg/recvmsg, which will make this less relevant. But as this
work isn't done yet, and the support for eg ITER_UBUF isn't upstream yet
either, this can help fill the gap.

V2:
- Abstract cache node out as well, so we can have common helpers for
  everything.

-- 
Jens Axboe


