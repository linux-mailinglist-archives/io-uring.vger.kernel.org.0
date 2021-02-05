Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62893310202
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 02:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhBEBCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 20:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbhBEBCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 20:02:33 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28266C0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 17:01:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id z6so5703058wrq.10
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 17:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtffqKsebUbk0XJjMOXbTRXjI2CzFlr7I1M4mWzQYzs=;
        b=Ba2fxFy1Q3bpSfKqWdcnrrpyY0e+IPio39O8E7zBydkV1BQKVPpr9BNy1x4rhWAKz/
         61JUc3EiC1SLHgVRqVX3uu4VXSHgCMGRqHzWxj9SXyrLuD90zskuEXgpqzE+PoZvHApz
         JPfegmpv23ttWT0KmRuzd266NvoA18HHYgofEKgon0L7DWWDNOm3KelmBmbjKgNCnjFk
         OAouUrFpodeArr1sqhJb1hrh3dM9BzkYrUqcZ9QUIwYhphBjpZFUGkD8PT+RbMNoc0gg
         GQUDyww927rcpAdoyQkAS1yvNmPH+nbCCD5nI2X95MfvKRUWLPSLq3uz497bU4pYUkhf
         ELSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HtffqKsebUbk0XJjMOXbTRXjI2CzFlr7I1M4mWzQYzs=;
        b=WD+bf8XgsuiKrT+65Vlj0qce2CknXIqLTYOqdFeQWgREqp095ADGvWoojEabPo93Nd
         +4hee4KeJpTUMhSafFNW/YyKEdXl3mZy0zHSiiIB0vF6SC2zt2P6om/ASyr6HO+Xq0Af
         hU4fkbCBgtmh1KfJZOL8hqbrVnNX1kTs0fuSNZKQSEr2AF3Hzl/5ahsKadNG6e4CHcfD
         yiTujYWelkV5gEeJA7ogYRRLxAENHsrf002D3xKVxS8s+exsLYwNNaqU7AkQoore6vpv
         lLykMSuZe4DJPKMyidzbWPhNnNeIMuA5IJtOnZkHPNzvsN+l3qYRig6M/JvfdHwveUoJ
         V4lw==
X-Gm-Message-State: AOAM531ZQLNe23d2Ez7ovpMXjhkucW3+ODZjhmToH8WXP1Ja530ZiJ7V
        feYAENtrvM2Za3SsNxpNl563CMyqAfNQhg==
X-Google-Smtp-Source: ABdhPJxalbDds1Dpowq88pU3wrLTUGzyP5zPtbdKNGKOitPlX2vuHGbKN8xqt5nI8SUuEyBrKSsH1Q==
X-Received: by 2002:a05:6000:1082:: with SMTP id y2mr1965370wrw.27.1612486911909;
        Thu, 04 Feb 2021 17:01:51 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id i18sm10853199wrn.29.2021.02.04.17.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 17:01:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/3] sendmsg/recvmsg cleanup
Date:   Fri,  5 Feb 2021 00:57:57 +0000
Message-Id: <cover.1612486458.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Reincarnated cleanups of sendmsg/recvmsg managing and copying of iov.

Pavel Begunkov (3):
  io_uring: set msg_name on msg fixup
  io_uring: clean iov usage for recvmsg buf select
  io_uring: refactor sendmsg/recvmsg iov managing

 fs/io_uring.c | 68 +++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

-- 
2.24.0

