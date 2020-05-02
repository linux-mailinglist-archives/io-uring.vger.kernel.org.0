Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7813C1C2518
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgEBMMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgEBMMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:12:46 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE7AC061A0C
        for <io-uring@vger.kernel.org>; Sat,  2 May 2020 05:12:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s8so4717507wrt.9
        for <io-uring@vger.kernel.org>; Sat, 02 May 2020 05:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U4pDZtqz4vx4F6YwZweRWKy3LfYaTcC2bzi1XwjDZ48=;
        b=CBfAFd8jaD/J6YfxLwINbVTF0XhPgTQTySWJm+wwuEA/mmqsLvkeEbo2phX/mRGd2e
         gBCEhG01Dip0TwWzEmOym7fRKGn0xhsq/4Vm2nw4b6+E8AX3hCfvimZSDPab5y+7AM5L
         KqEFc6j1b2sp61jiTEHjDRq6TgPVW3q/He+XndpjWcx1gvhgryC1nxrE8qpdVFxFnIwL
         T8SIdTCi2dC6Kt/slgA1uVq/Bb6YuieC4/aoumHbvDZPMg9h7bb8KKUKKJJAs1f3Gdre
         1zY8qoVJWPiAZ1vmaKmMrJURXQ54+/YuUvtTAVd3TD0Hed0pYvMgoDHMutoPG5skTEJU
         BI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U4pDZtqz4vx4F6YwZweRWKy3LfYaTcC2bzi1XwjDZ48=;
        b=D4+gIyMATRIsU5AyN2A7sa6MktiIaVer9TUXTF/wyrVN45zk3UfTOfw7vt1GUZpfqb
         o2Xr6qH0auVWqOkGHorCPs8c+SrnFc5dVdi+cKa0L3f+5F4lylP4XcUgFj1GHlSB9V1m
         mqLdPOulj6yEkjmgwfW4wdkA8GVGe53KBh0/NvkK1y09E/NblUQ3J0Px7oFh1kMNYmaY
         5Geg26c5oxwWwdez+5MsBmzAzRLerclFXqTerN8m2Tm5y7dgG489ZqtiqjfOQo30qUe+
         z8Bq5Z9Sg561yCA4tkInWh3s7nJhltq0Hm4/eQUQ8W4ESMjeDOYFyVBCVbhqmtxUWtcB
         rrhA==
X-Gm-Message-State: AGi0PubH59BmHtTHVEtqUCnPuibuaSSyZWVPEdpvp0AMvYszKDXeZhwR
        1+OkDtSxqU0c/eAP++ZjRr4=
X-Google-Smtp-Source: APiQypJiELNmLA0d2l55uh892i2FVDUNmozeE4O+bXGr5tuDtOS1mnpCjHMTTY/olp2NNPQ6gOFdAw==
X-Received: by 2002:a5d:634d:: with SMTP id b13mr8891059wrw.353.1588421562698;
        Sat, 02 May 2020 05:12:42 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id m188sm3993913wme.47.2020.05.02.05.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:12:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Clay Harris <bugs@claycon.org>
Subject: [PATCH liburing 0/3] test tee
Date:   Sat,  2 May 2020 15:11:26 +0300
Message-Id: <cover.1588421430.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tee + tests

Pavel Begunkov (3):
  splice/test: improve splice tests
  update io_uring.h with tee()
  tee/test: add test for tee(2)

 src/include/liburing/io_uring.h |   1 +
 test/splice.c                   | 530 ++++++++++++++++++++++++++------
 2 files changed, 438 insertions(+), 93 deletions(-)

-- 
2.24.0

