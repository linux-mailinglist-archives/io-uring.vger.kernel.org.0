Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A2E331BD2
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 01:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCIAma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 19:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhCIAmD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 19:42:03 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FEEC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 16:42:03 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id b18so13363215wrn.6
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 16:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=61FhKwhde2ACkLwXH3Am/csbS+igWFb2tDjiCJ0DiXw=;
        b=LLipbbGO/+I+tyLS0gF4EAvJMdDV9gG+kRlhHg8kj7SqcyHY1B6jEqI4Ydoj0HzhbG
         at2d1A0gCAaEX3pDDpJigiKEaScMCcJXxSM3G/9Zgt70nuC66y/E5+pyxRqwxqI0j2u1
         1kpIJI2buGKszW1Ca/XMh/xNlGzT6LH1se8axpgLPS+pJM7H+BBfIpTa1ICpqO8Xf9n1
         AjCbVPNzC/29nl5qgd1vcFjN1UAqKa7oavjTuHbOjSKTnuLOjk7YqnpkW1ccmg+lRMae
         W3M5MhrKHwmC7ce7el1N1qnSD94a6hVzQoyhgV386YbxSsuysi6/wKQ7tl+oD3wP00e8
         g/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=61FhKwhde2ACkLwXH3Am/csbS+igWFb2tDjiCJ0DiXw=;
        b=XNz2Y5RvBV2+1Dajp7ZMZ82oNT/xjs6fbPtrPpAu+U3jXMwcywtzVOu49dn8sqHmS/
         ggxTmWvZrkkXG0rRuz4c7Xuxb52qbl6y81IunrFvRPFE/Uw+96/JFKRUfXkHLTHbibHj
         CuIp6/VTR2X0kBfVr+LLfD7RGCXv2yNcxttEHPdJOag+IvfoYNURsMR7zqNH0mCUU7r6
         R8DPZjA+jmLjo+eV5A1byYATE9NTvHXMpBcri7Wp265ajx2vQ5TGG8HMXxgze/L8cN7o
         2Zdgf3BHUfe2j/iwV35WqlJ6Ng9/2bJHqD8jk/44qSTNu5yByhXW51414oft3c+avIcs
         Y4vw==
X-Gm-Message-State: AOAM531Eh5x2VjADGN4MUqTeW2k4TcTKSgHwninvbC9LzT1XDtISWPsg
        2q4JIW+lF4FKxg+G8Z5cL904ErrrJhCfdQ==
X-Google-Smtp-Source: ABdhPJwoFSX/4wepeVu58yV1iH3939yJSIdy/nh+JMbWycs3Hn3arv2x6tPNShMUl6UVVJv7AEGeaw==
X-Received: by 2002:a5d:4e83:: with SMTP id e3mr25683387wru.82.1615250522356;
        Mon, 08 Mar 2021 16:42:02 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id 3sm23918131wry.72.2021.03.08.16.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 16:42:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] io_req_complete_post() fix
Date:   Tue,  9 Mar 2021 00:37:57 +0000
Message-Id: <cover.1615250156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

May use more gazing by someone to avoid obvious/stupid mistakes

Pavel Begunkov (2):
  io_uring: add io_disarm_next() helper
  io_uring: fix complete_post races for linked req

 fs/io_uring.c | 89 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 40 deletions(-)

-- 
2.24.0

