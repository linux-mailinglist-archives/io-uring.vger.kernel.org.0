Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16670635F06
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 14:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiKWNMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 08:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiKWNL5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 08:11:57 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB3FF1DA5
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 04:54:13 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id BA70681696;
        Wed, 23 Nov 2022 12:53:50 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669208035;
        bh=HIlgi8T5KiU/QHcc6+YrhbuQ1ePlcPuPGCHJF086bv4=;
        h=From:To:Cc:Subject:Date:From;
        b=NfrQ4tdyyTh4uHeA2nA+OUKt3ojEtim8QoBWf5eGbuERnLdPGnxF01wa5cgX/olJS
         3rQcmwGSvWmSul8J50uBMFB/ofoFbTg7ACaNDzBEel1hGneUzvzIjSXLA7vSYmRwAr
         iwBSMAsK0ixGPN3WqCLVTnvYwCXMk4wRuAkbb7xFh2sGQoOS5/62mXQX06gjpK88+X
         F/EFjxHTg3hinLpo7BQGkzbj6ePhkmHs+y4RClbW7b1myznwBuAMtMKpAYLaLXAnfS
         0C77gUH0aNNNywNrE5m0wxQD8R3Sd76W1xZnrwTdywhLNEdw5dnwfRiCdFedzX+FIp
         ujLEU6EoJTKZw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v1 0/5] Remove useless brances in register functions
Date:   Wed, 23 Nov 2022 19:53:12 +0700
Message-Id: <20221123124922.3612798-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hi Jens,

This series removes useless branches in register functions:
  - io_uring_register_eventfd()
  - io_uring_unregister_eventfd()
  - io_uring_register_eventfd_async()
  - io_uring_register_buffers()
  - io_uring_unregister_buffers()
  - io_uring_unregister_files()
  - io_uring_register_probe()
  - io_uring_register_restrictions()

There are 5 patches in this series.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (5):
  register: Remove useless branches in {un,}register eventfd
  register: Remove useless branches in {un,}register buffers
  register: Remove useless branch in unregister files
  register: Remove useless branch in register probe
  register: Remove useless branch in register restrictions

 src/register.c | 60 +++++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 42 deletions(-)


base-commit: 8fc22e3b3348c0a6384ec926e0b19b6707622e58
-- 
Ammar Faizi

