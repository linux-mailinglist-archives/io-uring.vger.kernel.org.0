Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBBE3B30FF
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 16:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhFXOMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 10:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFXOMr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 10:12:47 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98757C061756
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:27 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a13so6824364wrf.10
        for <io-uring@vger.kernel.org>; Thu, 24 Jun 2021 07:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pHlERM/Y3Ixqu99eHkQK3d0Ho3rmHzww2+3fTaKtMcU=;
        b=sAx2Eezrqo7LrEhJ1IpdSV89kfurkwptnjG++6su7lAudMCKGvH4J7jznAs0buaQ+X
         Qn5e4tawsNaarIUjp2my5Mzisew7KCsro19pf/EfxLghEsMCIhPXUMSoWc6AW9fmsOkc
         SrnLqZvi4+Uje8LusshNKipvN8sbaIV50nEGF+AGwkvgCUthMrGu99mdAxMAqmjaS+41
         TNfLupMdphwF3FZRgxf1FX2VgjdBEkGLGLS71JKDeXzVbmSzp48ZQYbp2yqDrIkjH/V1
         hoHrY4NZtqA+a9xq9E6os/jmXYEzGq1q+6YdL+M4DyQBRhq1Kp0/T7FTxBbPGodYMIRj
         nZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pHlERM/Y3Ixqu99eHkQK3d0Ho3rmHzww2+3fTaKtMcU=;
        b=VK80Ry5pVRR2rmjbvJeJNzeoyztVu19/0hH/obc66ZTw9ISQmxTlu6scPBMsEjk3LJ
         WsvC6gDhDqlA5tP7OFM8X7PU90fmYSMRwggXhfKMNJUuF50vhCNRWp3okY9B9hjIWHz+
         flDlxjahpvMZn90E1dxW8fAGOJr+c2/1ynFx6qywlrWE/edElx6VEhTdX+duvC/sMx9F
         cLx1j2ATK6b3Hudy9DxmMJ//KWCIA6uelhOYLB4Om79jt9ZJBc3Jr8fzQ5QWeDGHUh2G
         8DynPyZDu44RM/EOz6M4nBrh8Vh8AvAg3tXtFb2tPEIS5/WXc2tUHZDc1wComyY7vLmR
         vZFg==
X-Gm-Message-State: AOAM533iAlMJKeMFHmkiUkc3uSGBU30S1G1eC4jy6HofYhhUg5K6ulv6
        4M4hyMaLBCxe5sYAjagMzxo=
X-Google-Smtp-Source: ABdhPJzmOwJquPEheIUI/iQpt+R93/Bc4dZ/5EaYLb2vIaVvi0hg3k0DXfONGWqft3hVorKH98h+ow==
X-Received: by 2002:adf:9031:: with SMTP id h46mr4770072wrh.125.1624543826229;
        Thu, 24 Jun 2021 07:10:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id w2sm3408428wrp.14.2021.06.24.07.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:10:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/6] io_uring: update sqe layout build checks
Date:   Thu, 24 Jun 2021 15:09:58 +0100
Message-Id: <1f9d21bd74599b856b3a632be4c23ffa184a3ef0.1624543113.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1624543113.git.asml.silence@gmail.com>
References: <cover.1624543113.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add missing BUILD_BUG_SQE_ELEM() for ->buf_group verifying that SQE
layout doesn't change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 669d1b48e4cb..c382182573d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10463,6 +10463,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
 	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
+	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 
@@ -10475,6 +10476,7 @@ static int __init io_uring_init(void)
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
+
 	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
 				SLAB_ACCOUNT);
 	return 0;
-- 
2.32.0

