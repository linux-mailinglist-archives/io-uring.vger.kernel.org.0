Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DAA70D902
	for <lists+io-uring@lfdr.de>; Tue, 23 May 2023 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjEWJ3S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 05:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjEWJ3R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 05:29:17 -0400
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDDE194;
        Tue, 23 May 2023 02:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
        Content-Type; bh=T9XFrPgIOEE3z4UkMA7mpWU3DHfciBVqdtZrptN6t1Q=;
        b=H5oDEmCHE2HO7xLFiVbELyazzf7htlEKkv5cqqfqOXWOVgFzFDRYDcRT3a5tGH
        O21lLahNht0Ho2v2v+m8LZk0XNKZtchfizKzxaBwX2Ydm5cNUjY7OOJZTrgHBg4g
        5yOWVCWYZs+48uT571jZ0vaiHNJluVKORc9yQchW+yxVQ=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by zwqz-smtp-mta-g0-1 (Coremail) with SMTP id _____wDnJT7LhmxkKE__AA--.2945S2;
        Tue, 23 May 2023 17:26:35 +0800 (CST)
From:   lingfuyi <lingfuyi@126.com>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        lingfuyi <lingfuyi@126.com>, k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] io_uring: fix compile error when CONFIG_IO_URING not set
Date:   Tue, 23 May 2023 17:26:29 +0800
Message-Id: <20230523092629.3402710-1-lingfuyi@126.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDnJT7LhmxkKE__AA--.2945S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jw4xGryfJryUKF1xJry7Jrb_yoWDXwc_u3
        Z3tw1j9r4fZryIvw18Gr1IqryYgw1xZFy7Wr93Kw15ZFnrua1kG3ykZFykJrySgrs7urnr
        Ca95G3s7JF129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRRTa0JUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: polqwwxx1lqiyswou0bp/1tbiuQtzR1pEAp1ACwABsN
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

when compile with ARCH=mips CROSS_COMPILE=mips-linux-gnu- , and CONFIG_IO_URING
is not set , compile will case some error like this:
drivers/nvme/host/ioctl.c:555:37: error: initialization of
‘const struct nvme_uring_cmd *’ from ‘int’ makes pointer from
integer without a cast [-Werror=int-conversion]

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: lingfuyi <lingfuyi@126.com>
---
 include/linux/io_uring.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7fe31b2cd02f..c76809f59617 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -98,6 +98,10 @@ static inline void io_uring_files_cancel(void)
 static inline void io_uring_free(struct task_struct *tsk)
 {
 }
+static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
+{
+       return NULL;
+}
 static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
-- 
2.20.1

