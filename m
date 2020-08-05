Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1296223CED2
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 21:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgHETGq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Aug 2020 15:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgHETEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Aug 2020 15:04:47 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71558C0617A3
        for <io-uring@vger.kernel.org>; Wed,  5 Aug 2020 12:04:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t10so20570368plz.10
        for <io-uring@vger.kernel.org>; Wed, 05 Aug 2020 12:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fKWjZ5BtbhMHOhQ0I7iPtI61Wg+c1D+aKSmLPn5xY/U=;
        b=Jh8OfJOiR4zDnJqZ5xlfwu+E6T/xHH2Lbu8XidLSiMxbTgBBr3nyELr9E/fn7yMf0g
         dnQKr9mA1GFLkLrDqX4ipzBPolUaSPx7izuyBmaBrvL0d7uFqrblhXlDwdVb99VEwJu7
         4rcbXVfcmxJ/yNm5ZKcUor2p8K99ZQ/1PLPI3wuTMPO4jhEGsPDiZL0Q5/C4buPzdUsr
         gYsyD3uROGS3g0ovThXhnO64HOOTFuEGuZlAcNxiSuI7Ca9wdlXUfnJ0lLhz0vUE7K5j
         nTKjT39R01gyyU5C8zkVWu5tJ0Bv8XFsI3cxb4I0MtAQ50c8v1jVMEUfZbyWaYbxDd6S
         uBJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fKWjZ5BtbhMHOhQ0I7iPtI61Wg+c1D+aKSmLPn5xY/U=;
        b=Ijirr5zndEa6XJ8dhRYC/XdSMo8Rm4OOBp9Wd1CrlwY6bMmLGvfB8dzbFBwIZR3tge
         hNlykxzDScinv6yvixI8mxWhBE0jYc0T7Aemq0ijw4DE8V9AVYYR9zJYBhhBZgSRMJRz
         1XRV2oktJ28CHPKjm0mkfFwqYeUZT6fm4T3qJ3QjwB5muyvfalbI6dBXFhC6qfBeCo8o
         /T+OocYtteVvRWN7GNOpt1zmV/dK7L9ADsybHLWAFCZ++H+/GSjH4ITEWooiVcFQknEc
         hpTqBDlFTJohqv1It7QZsFaFU2FMNlHozz4BOAZP8Hn/PNoGCak7u4MaTHWmYfzSPw9h
         uUmw==
X-Gm-Message-State: AOAM531Q/aO+A374Ho7QcZJdSOuWCaxr8wMVIZNRTBLlyS65B4GeSALz
        cIQrQJxW+QRn/wRqZePFiKtmLOVJzz0=
X-Google-Smtp-Source: ABdhPJwZtJ8mZKq1Pfa2I6507Aj8mWUzON4cQI4EFh1RDexfelcSqka264e3FEyCrbu5DYz9IRs/1A==
X-Received: by 2002:a17:902:b943:: with SMTP id h3mr4558433pls.38.1596654267654;
        Wed, 05 Aug 2020 12:04:27 -0700 (PDT)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b15sm4071881pgk.14.2020.08.05.12.04.26
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 12:04:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH 0/2] io_uring memory accounting fixes
Date:   Wed,  5 Aug 2020 13:02:22 -0600
Message-Id: <20200805190224.401962-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First one is something that should go into stable, to avoid
discrepancies between accounted and unaccounted memory. The second one
is just for 5.9.

-- 
Jens Axboe


