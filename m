Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338A1675A21
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjATQjF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjATQjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:39:04 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A560559C7
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:01 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y11so7346003edd.6
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k18pWfb0K8AHcOPoWAT4nfCxzzM48zlZ1wPMXIrb51Q=;
        b=M6kT3AkQYVSxYLqwG/FUtQnQY+20Ry0ReKNhQ1y9XjO1CswptmjUK6bkaHzQVOANRd
         CeGf/yEkjyOWVt9pYjR42hzkedoX0A+FRnMvRuNSxZEzoDn7AmuE4lTSZu1nVNQA2phd
         O+ShhjI3Vi2WXmJ9dqssufqzl34qj8dU6Lv8Co2APR54PxJysQpU2MGWFa4bOiXZ3lXj
         0n2lIsO38tF0fkm0PVpvLH6uLyrjjD1A5kuTq+qIRzh0ZeAL12jcDU7QFEt68o8De2kC
         WezCrbdhuiA2er/zwiksbLapCuKteRkychTQEUUxoGUAj4UdBP7ySnAwSt/AFGGTkwtn
         hKUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k18pWfb0K8AHcOPoWAT4nfCxzzM48zlZ1wPMXIrb51Q=;
        b=qzPIJAbP7Shd7raAh8N1el4ojKM39TeE0G6u7KPoF1E1FW7BeIkAWMayKKtXmBeVvu
         u05xUp16onYcX1AGqWnfJlYMnUkQ6hlj6bMmli7TDtcZmGDVh057foAeaJ7W1BrJYSeI
         ZXO9bxXaNSOSQQ+XwVXj/U7pfwO8VWqOm9WacNgDaaB9tt7kqJCu4BffY0L8XbaAh8mp
         U0raNS3HYkQhSVS4j/x+eFCkDhl6orleCLk+3FlB+xKRV3WBZpTsNgtcZLZOb/EMmljp
         GKGzqWOzlBVZxcVqXoXf8JjjDodg25Qbh49kPDrq1igkrjTpWXIJRnBvn+SSISlmh+py
         cv8w==
X-Gm-Message-State: AFqh2kqZKWFxqO/NCgcJmrziOBvc5SEWdRpV+WHwtINSLuF15Ah24ahE
        fr0Je+floQOjAFNLcX40wdhn3NcgzHk=
X-Google-Smtp-Source: AMrXdXsRN6AZlIgY4Xc7922n/cLp42QLUMIZKG9zasWcRr3uPUb2FaU3d82u1XA4qq18Mv6QPdQ8mQ==
X-Received: by 2002:a05:6402:448d:b0:498:2f9f:3442 with SMTP id er13-20020a056402448d00b004982f9f3442mr16745400edb.2.1674232739877;
        Fri, 20 Jan 2023 08:38:59 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id t27-20020a170906179b00b008762e2b7004sm4702124eje.208.2023.01.20.08.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:38:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 v2 0/3] msg_ring fixes
Date:   Fri, 20 Jan 2023 16:38:04 +0000
Message-Id: <cover.1674232514.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First two patches are msg_ring fixes. 3/3 can go 6.3

v2: fail msg_ring'ing to disabled rings

Pavel Begunkov (3):
  io_uring/msg_ring: fix flagging remote execution
  io_uring/msg_ring: fix remote queue to disabled ring
  io_uring/msg_ring: optimise with correct tw notify method

 io_uring/io_uring.c |  4 ++--
 io_uring/msg_ring.c | 55 +++++++++++++++++++++++++++++++--------------
 2 files changed, 40 insertions(+), 19 deletions(-)

-- 
2.38.1

