Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B0C5B22EA
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiIHP7C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIHP7B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:01 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D651C9CCCC
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:00 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so39153183ejc.1
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=U9BriFKhKE5ggRDDm0DxFVjluotXSeBGiHrf+VjhK60=;
        b=mGf7V7RnbO9lTuChVL/hvG8w8bOfWtmB3BKyBh21aR/oEWkpEInhLx83poIajHFctB
         mgwjtP+8HA6ENQnTZISkB8hmMeai7IPvAXhMEyH1HqsXhjoYEKPcp4Wo/AEn1YY2tlen
         jMQA7xSPNjHU7F/PcodRyiRWdTVZso9mdqVjtX2BSN/iU+QYK31xxtmL/2AUCUoUOLER
         SkBUvAm+2DwsPOZGIV/JhqvqmLx07EcNKDqspUp/uwiwnLiv0D+pqL1XubTG2XIiSPcu
         zNDcJvpTcrLSn+Jy1r55IiMpf5ZisepJMYA2ZBepjARpyQbLfUJtZCkVG9QfAC+e4YIA
         /JMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=U9BriFKhKE5ggRDDm0DxFVjluotXSeBGiHrf+VjhK60=;
        b=A61QdaBpr5FyGit0AZiihtHF78Y0ip/clVtmSDZ0jK/dDAawa4BNv9tWBrq3oRugTd
         SGapTRoLEBSOQwGTsY7s8qvoQlJ828HtIC/9wgBZH34o8tF4Wn5jzmbXCYu/o9ulrIho
         JhNlzqL+qAlPAHzMMMXDG1j8bA192Gij84PiTi0lkm5tzxogyJHoc3SC04jncQt58+cd
         uFJ7zPm9WKM3ce7CG9MqfjLZ0SncNR0PE32pUylW11217CUgv/aa6ZknPdFoNh308jfD
         x8+84UUInn8h+0Urco0QJnN52+S6ulmhH39IUOBUBA1Klp4QRkOvuBT7/60c6aaRPo05
         DDEg==
X-Gm-Message-State: ACgBeo11iUdJflwiI9UEhCDSjSIHOU9wzt4nVolYfbvcj/QLNb8FGfwC
        puWh05xPZXu3oAz4JcTBAKtbsI9BBU0=
X-Google-Smtp-Source: AA6agR6iA0dniCEYO1SIGaSTxGn6omt65dmbB9lzJdEH/IwddA8beY2Uc50x5CUUJ+4x5zVRBCGZiw==
X-Received: by 2002:a17:907:3e08:b0:774:3e36:f019 with SMTP id hp8-20020a1709073e0800b007743e36f019mr2659522ejc.226.1662652739027;
        Thu, 08 Sep 2022 08:58:59 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:58:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 0/6] defer tw fixes and other cleanups
Date:   Thu,  8 Sep 2022 16:56:51 +0100
Message-Id: <cover.1662652536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-4 fix some defer tw problems, 5-6 are just dropped into the pile.

note: we intentionally break defer-taskrun test here.

Pavel Begunkov (6):
  io_uring: further limit non-owner defer-tw cq waiting
  io_uring: disallow defer-tw run w/ no submitters
  io_uring/iopoll: fix unexpected returns
  io_uring/iopoll: unify tw breaking logic
  io_uring: add fast path for io_run_local_work()
  io_uring: remove unused return from io_disarm_next

 io_uring/io_uring.c | 35 ++++++++++++++++++-----------------
 io_uring/io_uring.h |  6 ++++++
 io_uring/timeout.c  | 13 +++----------
 io_uring/timeout.h  |  2 +-
 4 files changed, 28 insertions(+), 28 deletions(-)

-- 
2.37.2

