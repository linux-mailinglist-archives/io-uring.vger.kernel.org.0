Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706C0346143
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhCWOR5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhCWORZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:25 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334BC061765
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:24 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso13088725wmi.3
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2UwGLzq27knLTrFtcS/DmuBq4lge3A0IsdCtSTW+DuQ=;
        b=sLKtmzENeMwGQ/+ePgoH/k03NhApiyOzaM3gRFpudahqm+4CY+lAxwrt/4AuhSBpjX
         zCPTgIAcGpJaPxJW57R2b8nkkwmFM1dpw9VudkPPwO0sBafn6ExeDI4qGpSWz8p4BR3A
         yrEHZiz8D8LR9Vg4pRwJkv0UVbw/F9nekN5IfF2wxaXXCHpNiPcCMWHMPpsa2SYamGIq
         D/XWzvxdLZ2Cnx5S7kUaRjgPuWzsl/HmvRQgdmEPBLBj7BRCp0rKZhnDn9bkvPvK+O9A
         gmZ8j5sAeLvzN82jDY41L89F6gRhu2azFliAKTEQ+gdfS+45dZDDFAaK9BeGCBmQW+NK
         6Tkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2UwGLzq27knLTrFtcS/DmuBq4lge3A0IsdCtSTW+DuQ=;
        b=rUsNapK3gLK1dvx2khCMVaamAG6Bwf69+02b5cfMSaUezgCDWfY+ku1O7A8as63iyc
         SoSswYKTaNVZAsv5xJnvts+9aT1/dL9BPlTkWkSlmdGHixAfGS4wIW2+UQeuU5eJOc2U
         bE0ED3lkiXeS76HMruw7l48lmvu1DGsBWsDVMljrMorXs+TTQFWooIpV46tBxmMjJyk8
         4VpAamsuwMwug6/wLDlcOj7YcvFhvWJqBgTwAhJWmJkBzGE5ySFbAOjyNF/seD6wg9RN
         9qk1tB2LViN3oKGwg5VGPS2eCgEF7RYHEWyuJeHoQ9tzqyMZAqCG7QuKMp42q4bcyPxS
         xEog==
X-Gm-Message-State: AOAM532l1xj5AX/0glnwFyXpnduUt5fbT3KDXoJeQCw8Jb7EXWAfZatN
        YrTiRKPazZnjcS4xBQdIMCo=
X-Google-Smtp-Source: ABdhPJyPHfEXKnkHC3+CIsHAYymBP5P1p3q9W90GmBxPWnO0xbXJRoIxFPn3tp98zBXKLKncrGHdIQ==
X-Received: by 2002:a05:600c:1550:: with SMTP id f16mr3592248wmg.97.1616509043005;
        Tue, 23 Mar 2021 07:17:23 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.13 0/7] ctx wide rsrc nodes
Date:   Tue, 23 Mar 2021 14:13:10 +0000
Message-Id: <cover.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main idea here is to make make rsrc nodes (aka ref nodes) to be per
ctx rather than per rsrc_data, that is a requirement for having multiple
resource types. All the meat to it in 7/7.

Also rsrc API is complicated and too misuse. 1-6 may be considered to
be preps but also together with 7/7 gradually make the API simpler and
so more resilient.

The only nuisance is additional handling in ctx_free in 7/7, and added
for that struct io_rsrc_node::completion, because now we always retain a
valid node in ctx after first files_register, and so we need to kill it
in the end. Ideas how to make it better?

Pavel Begunkov (7):
  io_uring: name rsrc bits consistently
  io_uring: simplify io_rsrc_node_ref_zero
  io_uring: use rsrc prealloc infra for files reg
  io_uring: encapsulate rsrc node manipulations
  io_uring: move rsrc_put callback into io_rsrc_data
  io_uring: refactor io_queue_rsrc_removal()
  io_uring: ctx-wide rsrc nodes

 fs/io_uring.c | 253 +++++++++++++++++++++++---------------------------
 1 file changed, 115 insertions(+), 138 deletions(-)

-- 
2.24.0

