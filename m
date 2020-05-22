Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E451DF094
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbgEVUX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 May 2020 16:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgEVUX0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 May 2020 16:23:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C79CC08C5C3
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m7so4827895plt.5
        for <io-uring@vger.kernel.org>; Fri, 22 May 2020 13:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VWs0Nj9WGghWnCOq/fSx5SIRlxQxiE9MXDVdkqYQzM=;
        b=jrTkj5mNE8rkwflBEeAmIyb8Qnj27z1yhUum3fkVIs00PTWv5KrHY1A5uxtAVi65oK
         sOFOAmMe4Gijz004PQKYcIsCxcGM8MEtjGr0pk5W7S5Os5B7IeWfCmo12ZhXpV02UTQ8
         NMWc32YYKiWXGBAXH68HZNtHCu+Opp2BtHSGYWjZOKcBXiW9cHxFRzCOMyky4/0vjdMn
         5y35f5bHYq9Jg1W8nnVsoOeuzdArBHrHCpynV8TZM5GAjCe8erOkISRTfBQRsoiIsbpk
         A9dSOn4joSJzn6Jw8G+n53yZzeJQBQPsAlw9IQ8Jvjm9ct8cpyOb8gJwVVUsi/r/HQXI
         cDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VWs0Nj9WGghWnCOq/fSx5SIRlxQxiE9MXDVdkqYQzM=;
        b=OuUogN0l1tjDUO01H0sTZjcw6WdeWWbgqIpGoLiqxadjo0q/ZdffmSaINOErmJnFxV
         UEw38qp822TpwxxwatN3czV5hmPiWZMFoP0qrVCXA1PCwfTRzexy81t6RLZTedMBz6+0
         J/xD4FI9LBp1Bw1NmvgzmWn1k+s8IxJgEoQucaIB0X+qyXEGCK6LM6YTVgla6AZQc2zl
         8CN8ns64OXThGo/BaoSPsupvVhPBhSUghfK+HjHpdvCNzpZ3I9L7WOXugKI31U3GrKcn
         bs4VsB4NziGC5S11xJ2+jYt1PgpVffZjUN6YdvEtfHLuHEZU2/JgRdmleyKTCUVF5fW7
         9pjw==
X-Gm-Message-State: AOAM531iq4gkaULhQXKcYnNQ/MzyR863mnwHQ/SMhechqLgPmpaCHHw9
        IVNI2/QgYLlaoRF1JGzhRhYipljhJkc=
X-Google-Smtp-Source: ABdhPJyfk1Fi4CeJavhhm5jD+udLfDiANFaIVbhg/UeDmfEmwZxENiHETpIQtctD6WObNUCaWgH+4A==
X-Received: by 2002:a17:90b:1082:: with SMTP id gj2mr6812346pjb.225.1590179004516;
        Fri, 22 May 2020 13:23:24 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:e0db:da55:b0a4:601])
        by smtp.gmail.com with ESMTPSA id e19sm7295561pfn.17.2020.05.22.13.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 13:23:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/11] fs: add FMODE_BUF_RASYNC
Date:   Fri, 22 May 2020 14:23:05 -0600
Message-Id: <20200522202311.10959-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522202311.10959-1-axboe@kernel.dk>
References: <20200522202311.10959-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If set, this indicates that the file system supports IOCB_WAITQ for
buffered reads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 82b989695ab9..0ef5f5973b1c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -175,6 +175,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT		((__force fmode_t)0x20000000)
 
+/* File supports async buffered reads */
+#define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
-- 
2.26.2

