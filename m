Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B422136172A
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 03:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236038AbhDPBZz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Apr 2021 21:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbhDPBZx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Apr 2021 21:25:53 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAA1C061574
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so5600678pjb.1
        for <io-uring@vger.kernel.org>; Thu, 15 Apr 2021 18:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCXm8dnTwrfclTw1fD1HvPNhBW9vsTyYQCS49YVXMco=;
        b=xXAwda8Jkp/yvHnVeYYJas9MWyncr9Hnb0otZ75DAj5Ix8g0SmOuBYvFH6GNle3PnA
         6yjxd2JxJFDA1gTnwoL5/YQqjVDnmYgxWf/UxkA9EHAPjA1LZeo1WJWqCar3WvXwoSmn
         2D+r69PCe1ueAw9SU8rPeTrdFwx7VcpW6xMe9txvYNXdKFCXGOrVgIAHXtDDYY+MExvy
         OCi6Gt7KsnvSS3T+wQo2/qs73nbSNWgrA2mw8i+7Lh+3pmlcuVX2qHiS3XlW3/YiUN+K
         mTaPWLeElRVZfHYbXVHid7kEUyJKLLW2TLoGDNA9rMlC0zLq+TcnxoMaOFR1mdmmnwEH
         v/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCXm8dnTwrfclTw1fD1HvPNhBW9vsTyYQCS49YVXMco=;
        b=UsqKPtopc/JHgqsGUV2XRGO3O1ZM+qasoRdxC7rxJcLTe0z7AeABuJzL0kMVHShE30
         V70lFCw76yCNYiaYR8GZlNbHYaXMYxlV6zzNAyshCUOilytfbEb2IQJKwFX57ae4hdWw
         PpUj/vOHdwMBNwLLdC6ACvCYvVJhewIFSK8SFVF/OaR7c3dngMeTbjBlzoBRCqLRkn3h
         f9mdVMIXTm17s66Bnhi5i9JwAEsCdJv1EnKR63WsBiMBVXl0e/kRZQJzWxNJJGml24KA
         oERyuS4rsVw21qqqiNYCM5BKqTKwR7BFEdcqDOUVr6fA1b68OdPCtjdw88KLR/pVOt8f
         0nsA==
X-Gm-Message-State: AOAM531h1SdtIKXamcXmPj7zbdocHybftZoxXPsGgIqgPQjNCez/KvEJ
        yJXou1L/8CkINE5OKMVXYYWkudq4sIIJTw==
X-Google-Smtp-Source: ABdhPJyAoLl+WoIpAnQKplLj3PTa6+elC95JICH/JSa96byL5sQH5FbMXxGq7cigETgIDIipBvW+Pw==
X-Received: by 2002:a17:902:e04f:b029:eb:66b0:6d08 with SMTP id x15-20020a170902e04fb02900eb66b06d08mr6953808plx.50.1618536327678;
        Thu, 15 Apr 2021 18:25:27 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g17sm3502039pji.40.2021.04.15.18.25.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 18:25:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH 0/3] Misc 5.13 fixes
Date:   Thu, 15 Apr 2021 19:25:20 -0600
Message-Id: <20210416012523.724073-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

#1 disables multishot requests for double waitqueue users for now, it's
got a few corner cases that need hashing out.

#2 is a prep patch for #3, which ties the ->apoll lifetime with that of
the request instead of keeping it seperate. That's more logical and makes
it handled more like other dynamically allocated items.

 fs/io_uring.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

-- 
Jens Axboe


