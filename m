Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A520D255
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2020 20:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgF2Ssb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgF2Sro (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 14:47:44 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2DBC030F0B
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:27 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z13so17135738wrw.5
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 09:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZHnHq4hykPVVdmIh95AgHLkhLHIXX+5/hZ5gflCJOac=;
        b=Pjpkzd16MkUqJPI+jbFsnwT16rwWw3nPvLR3BbAO/PsAajjxbz9bqXRqNd34vuwvxO
         He5wbkaOWINSGoZrX7SoeBBuvUMkRlygZM7F4yzAZu8y99eagH3/fTNMBdxeHkDWpjr9
         T9oEg8gEDK+1sJmkepIw/glQ16pp+D56snoBR0xgtb+6XTi3jwnnJQiJxp1mbhctH/Jr
         Y++tWJ5kaA+/Irmbs8cjAAl7dS1WxAK/DOgfKtL/fasZfi6/00fCYW8YJl4G8iX5xj1N
         b21nXKB0lpGCTbDYyijjkVXTUnKqTIQwbKNUXx6sknxfLl2r1Rbd0Yi95gQDZuvVdoPS
         QjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZHnHq4hykPVVdmIh95AgHLkhLHIXX+5/hZ5gflCJOac=;
        b=CPs6tqjA9zx7vXIEoZV+qKTwdbeG+pPmCAoM+76lDNzA5Fuq5kMyw0z3veAhurXGYs
         4TmidVeI9XGkl4SmVysUB+uheFBVsXEMxqgbiYWBOKdzLDcBk/u0XQQMbpoMzM8bxITb
         /MOWBnAq01qXs5jbFvR39pA6lLkFLpbAbQnpKCEdGT/Em0fWp+Wb1Gkxzgs/yTraZL7D
         S+aenGiVVxxcqA6bOX/bXgRVpsr3Ik02yyColtxbOpohD7m9dIhG197qeBLPLlLyK5XI
         rWLxhZH8WKKqF09wWWjE1u/vDKsQjWbj8N7lHrTnr8mRKiGV5mjQPLfvMLW/ZDw+8TuJ
         e0uw==
X-Gm-Message-State: AOAM533ppwn5wasjL8mDQZezC4WVjV7zsiUEfVFEs71Vr9otMaWbuPkS
        zkrKomAapkJNwgNg6wxQ6zt/Tqlb
X-Google-Smtp-Source: ABdhPJxg8hWvQA/K7okLd6jnPiWEHG2YAOPN7dygetSIWVwPk+ALheU/LjlUdFZwriTf5L+NFg+rlw==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr17691947wrp.412.1593447625689;
        Mon, 29 Jun 2020 09:20:25 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id 2sm282333wmo.44.2020.06.29.09.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 09:20:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.9 0/4] moving grab_env() later before punt
Date:   Mon, 29 Jun 2020 19:18:39 +0300
Message-Id: <cover.1593446892.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a first part of patches cleaning up after recent link/tast_work
quick fixes. The main idea intention here is to make io_steal_work()
functional again. That's done in [4/4], others are preps.

[4/4] may have its dragons, and even though I tested it
long enough, would love someone to take a closer look / test as well.

note: on top of "cleanup for req_free/find_next"

Pavel Begunkov (4):
  io_uring: don't pass def into io_req_work_grab_env
  io_uring: do init work in grab_env()
  io_uring: factor out grab_env() from defer_prep()
  io_uring: do grab_env() just before punting

 fs/io_uring.c | 73 +++++++++++++++++++++++++++------------------------
 1 file changed, 38 insertions(+), 35 deletions(-)

-- 
2.24.0

