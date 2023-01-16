Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA53566C297
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 15:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjAPOrN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 09:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjAPOq5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 09:46:57 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D6028849
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 06:28:43 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 589318186D;
        Mon, 16 Jan 2023 14:28:40 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673879322;
        bh=eMgPEobJ+iOdYuBVXszZ+2T3kqV6W8qLDjLfVTOS2HQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Hx7fi6IfvAOCLuVy4Cc+ZbGhZKhcf9QEi14afLY+OLBbJWrLNzp/gIQaxODJZ3l4+
         JWYa6HRNzTb8xyRCLy45HE+bw6N04QoffuFkSc8rn/460fKbhUONqdVFdObmp9Gtc1
         cKXPlhG7Na3hdO33tIpJP9V7y8LeU6ku6A854NzHfaggnClIHInZfEIFm/m3GyfPMV
         HB3slJyh263Ahx8ZnGtePks0m0uDp/EYJOHHsUhLyvJN8bh4pRCZPxdLsydq2Lh5f7
         ZHIuA15XN0Sd+nO9NyhqftN5asvjzMyP++AG/abk6EXWg8GZoW7atz1g4RRfpUFe+5
         XhAlcis9U35bw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v2 0/2] Explain about FFI support and how to build liburing
Date:   Mon, 16 Jan 2023 21:28:20 +0700
Message-Id: <20230116142822.717320-1-ammar.faizi@intel.com>
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

v
v

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  README: Explain how to build liburing
  README: Explain about FFI support

 README | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)


base-commit: 19424b0baa5999918701e1972b901b0937331581
-- 
Ammar Faizi

