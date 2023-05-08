Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54236FA0A2
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 09:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbjEHHJp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 May 2023 03:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjEHHJ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 May 2023 03:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304DA1A492;
        Mon,  8 May 2023 00:09:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B75561E9A;
        Mon,  8 May 2023 07:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5E0C433EF;
        Mon,  8 May 2023 07:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683529710;
        bh=+3W5Mv5xX/kx/ta/ix62WAEEVv/SvGa7b/nAH0LLghM=;
        h=From:To:Cc:Subject:Date:From;
        b=HBc8kLKoeZxm0sVitUx8Nt7ML5tEi2FZvBm7xEMaj0xk0+QmkvGjrd4yXORCvwi2m
         eG/ds4BvGYXhaYxMiJYjeVtUr8ppfkiKnWSGu3rQqp1UfGdNVq+qoYBcTrhn5ZBaeU
         zeSVzpJSHsbpMSroGk+tKjsX1LhBNFy0YLZG+bomQ71KIeYD1rgLiFsyO46+Ki2sWk
         6aAwdN1LPHKfISUM9YQi538NVnSFcu1GbSMd/aNSj4R3sY0/tdkWomoG6y9lamgPEi
         dJeWB3TNzVCUYLdccHbtoUJKFDsBCi7e5rr5rkogOKq7KQsiQu88txeojb/KTRWvwm
         YxsTUAO4eH+vg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Breno Leitao <leitao@debian.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: add dummy io_uring_sqe_cmd() helper
Date:   Mon,  8 May 2023 09:08:18 +0200
Message-Id: <20230508070825.3659621-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When CONFIG_IO_URING is disabled, the NVMe host support fails to build:

drivers/nvme/host/ioctl.c: In function 'nvme_uring_cmd_io':
drivers/nvme/host/ioctl.c:555:44: error: implicit declaration of function 'io_uring_sqe_cmd'; did you mean 'io_uring_free'? [-Werror=implicit-function-declaration]
  555 |         const struct nvme_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
      |                                            ^~~~~~~~~~~~~~~~
      |                                            io_uring_free

Add a dummy function like the other interfaces for this configuration.

Fixes: fd9b8547bc5c ("io_uring: Pass whole sqe to commands")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/io_uring.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 3399d979ee1c..ec1dbd9e2599 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -102,6 +102,10 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
+{
+	return NULL;
+}
 #endif
 
 #endif
-- 
2.39.2

