Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06406FCA15
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 17:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbjEIPTP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 May 2023 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjEIPTP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 May 2023 11:19:15 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682CC40CE
        for <io-uring@vger.kernel.org>; Tue,  9 May 2023 08:19:14 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-760dff4b701so37603139f.0
        for <io-uring@vger.kernel.org>; Tue, 09 May 2023 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683645553; x=1686237553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TebCNsWY1oOe1A4v/EX3fzXDM+hx5vSkZZ0FDkc4CsM=;
        b=ENoL3zmNhKVUM0Q6A+zMsI/qxvPTtPlGWVjje2aZ4WDro9CCeSWPXIwEmkvXZgRRW+
         Xtsro2JnkZ1fT7pMvFklN/p++knUZXzmxg6rjLuCmt/hswUG4565yGVpBQivOKcSKwkP
         1Qo2Tx850SyaUUpSg3pG8IfzxDNtGlD4mtGgFFBEzfViGPlJQm48X3ys2I2qZ6pb8Y+V
         924RzTSSzZWblfiH9w0S9RPiFSa0S1FDs9BBpsogBlSAGjtiHdlTThc8rxO/Q+K71D/Z
         GnnxIz7N0b+R8WW8i0m1TAt9c1F95a9lPkMLNyQMq1FWhgeMpOQVKyVlR+/cYbSMZOAI
         2Nig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645553; x=1686237553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TebCNsWY1oOe1A4v/EX3fzXDM+hx5vSkZZ0FDkc4CsM=;
        b=cddL76BZ55tm4kfRY4/MlxOrofz9fK8ky3rK+/yN29kzdG27LF0zIeafSuYlch8atv
         DB5ZAvJu/aty8IGpPxwMH9Ejnk/UgR0T+s47N0zX9tFE/SDWNZMKJARQpkcD8GWwldXn
         DbrNF/WtFyW7QKAMHvduzh2XLqBg9xlRKyxUq7eZFYGKnQwu4wxUj6Pye+7sUknoOr2J
         7Dnbr6YklpZqKx8Zp8dE1AGa90iwdrkBZDHtEsbFP26MONOCxcmbEudKK1gzb7xpozpS
         V7oATHxf2sQtMnHRbQAqoMy5RBnGa+LfKiMWtPKD+9EeN4DfQFbHKoNR/xLebSTenyKO
         3few==
X-Gm-Message-State: AC+VfDxQIAoxKoED1JO6MBYg0mOmy/mhCkIwpFGGfg6hO+ZmUpYMnlJt
        5OBB1vl8NV7GmEm3J6XKjeuaXBUvspGRqK8+0n4=
X-Google-Smtp-Source: ACHHUZ6uFMpMfZI38k1C+nqsoxxQrBz7Xaka3BTETSW6Ogozst2d8j47rcQbXWKpyUtsYYhc0hiMgQ==
X-Received: by 2002:a05:6602:2d51:b0:763:6aab:9f3e with SMTP id d17-20020a0566022d5100b007636aab9f3emr11367638iow.1.1683645553297;
        Tue, 09 May 2023 08:19:13 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z1-20020a056638240100b0041659b1e2afsm677390jat.14.2023.05.09.08.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:19:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org
Subject: [PATCHSET 0/3] Improve FMODE_NOWAIT coverage
Date:   Tue,  9 May 2023 09:19:07 -0600
Message-Id: <20230509151910.183637-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
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

io_uring jumps through some hoops to check block devices and sockets
for sanity wrt nonblocking read/write attempts. We can get rid of that
if we just flag sockets and block devices as being sane in that regard.
Patches 1-2 do that for sockets and block devices, and then patch 3 can
remove some cruft on the io_uring side that is pretty ugly.

-- 
Jens Axboe


