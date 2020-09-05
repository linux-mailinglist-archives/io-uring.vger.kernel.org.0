Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB425EB13
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgIEVs3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgIEVsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:48:21 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC318C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:48:19 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gr14so11936065ejb.1
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yTBT3Cdt/ys69Q+rPSShQ3U1narQfmQuayaUENPzSlg=;
        b=oAw7+TFZ86mLerg1EBT/0yVMUsBovuCvbXOURjpzuUUziSd8VsjuERr8CfNEI94nQr
         72u21uCq0HOH1BApGyKGapJJARdGeFhkwaD9iRKFLKr0/wpU3E0mz5i8EBLZUKdnnemi
         IhG1jUFXBXrNJ/oGYiPGHhopRxA804vp/gTfBNXM93U3HcFGFWhn2TNr8/QIU3JF6iGC
         mK5xoC0+e5QUyaBnr+lCz8530p9xAJURgG7h33XxTA0Iatee7lJedj7nIUzecyjqocQ8
         G609NQpIgo6cjfybjK5xXRwfP3x4TYyU8DurjDXBLpY+4dNfkBbnly7qGo7cLOKInhzt
         ByVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yTBT3Cdt/ys69Q+rPSShQ3U1narQfmQuayaUENPzSlg=;
        b=jZtqXELOOk4o1LtwtK5Pl9JWhGHyWicZzJxllDo0HNhfb6ujkuF6fppAStQFoj+Bhs
         hchE6hXdT2rozjnrEqwopz6PtyzbYtmgwt3siteZ8tdott4hsX2idhIzE08pRqlK/wvC
         nJwNIeUeNMHSM0mWg8IjUlv0Bv9CUzqz7Y/4U6dp8OdNGs8CU8i2OIbcqaLjwgjS3t03
         QhZus7VVCyLiW9tHAPTHiHdCHmpkRRdw4mhLSC6CfTKJppLQOUX4aL8VcpnVAwmw5bPT
         3WgO+nhESatC6pblQo+a3cNLgozHF+hH8TA+Rm4/V0sddLVZUWs8U5nN56mIsh89HzKN
         7Bog==
X-Gm-Message-State: AOAM533rlJXh8mg0kXBh5MUmIAk9UvB/piUhhi2IVCZNpsWjP08haWYp
        MpJSUHU+x9NlliO8elT/0wY=
X-Google-Smtp-Source: ABdhPJyA77S+g3V6bqu2oez12hNZjpgpCsCOxiUAdKkCOVme+kmQlBgE7mzq5d3Dm+Jyqwlsqahm4w==
X-Received: by 2002:a17:906:a201:: with SMTP id r1mr13789912ejy.432.1599342497853;
        Sat, 05 Sep 2020 14:48:17 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id g25sm7965603edu.53.2020.09.05.14.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] iov remapping hardening
Date:   Sun,  6 Sep 2020 00:45:44 +0300
Message-Id: <cover.1599341028.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This cleans bits around iov remapping. The patches were initially
for-5.9, but if you want it for 5.10 let me know, I'll rebase.

Pavel Begunkov (4):
  io_uring: simplify io_rw_prep_async()
  io_uring: refactor io_req_map_rw()
  io_uring: fix ovelapped memcpy in io_req_map_rw()
  io_uring: kill extra user_bufs check

 fs/io_uring.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

-- 
2.24.0

