Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FBF155B0B
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 16:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgBGPus (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 10:50:48 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46444 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgBGPus (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 10:50:48 -0500
Received: by mail-il1-f196.google.com with SMTP id t17so2055471ilm.13
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 07:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2xzG0bW9NNV8k2Pja5YkKr0aRrwTUB91kApRTaewk8E=;
        b=S17yjpcR6jHBxs+e70FicowS+UANfyuRVcX2PxLpQ5SGbe/MUeAZGIKWBGC2mPuge4
         /S0OVsAURZiDHnqnrr0ZC4ZxhGo1PwvCYdaoFAbgJ9lTGU97xtGgawiOLMMvRvRKWjKr
         owPPpopZ4CREuBp60wzcM73Mr46VLfgIyHCexngNUHrG1fbLbzqY/gBxoaibTAq03Yz+
         sSxqeemHtuyB6bQkdUsjMWPYZJiuuvZLbHJrNSDOtz+VTSv/TeTpQUHiSDTFACL5lbPh
         28G2NYE7w3vjlptkBrY0C6lbL0rJ+8ixyCS9mnqmqF1UoPLta1zIoNrliWK4q/WLq+rq
         UrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2xzG0bW9NNV8k2Pja5YkKr0aRrwTUB91kApRTaewk8E=;
        b=X4LhSAd7aLqsfbKT9jKJjp2M9rs/Fts8yKrdY26vpIl9OtAd1IGCxDXC14Au12DETx
         q3pWvlF8vhCjBkLzk8m5iiIbNpsIHW5JMhAZune3kJKLyADt6gGd1gzj8JJs3H6GngVc
         xHgXGrSBRVLCWgbQru3X3EmRWCooZ3HQ6Z4vfJz99CKo+QE2PyanvRbaQfE5jRubI0uf
         X1+mGlvYnGUC97a5x5dlNAYdGhdmqpP1jXpaHGpi6z9yC6+fQ14fkAAtKUrGEuiKdyDR
         6C5GC7f5myKE5Z1coPZjsNXwGliOd5rMGBiw3blL/6AS92i8OViDKdM/sOejGpqSsya/
         f0zQ==
X-Gm-Message-State: APjAAAUMntzEsnNpRVjviW2UVtbNpV8mWzCpocUYJdDXDDN4iSE9Hkd1
        eC6u9sYImqK/706WtSF8O1p5ceO3ssI=
X-Google-Smtp-Source: APXvYqyAZ5N981lM/xx5/3+AkYGYD3EBq/GOhnuhOKRgNPYEN57Q5ytwicTclvir0ESHSZ44CyYzvA==
X-Received: by 2002:a92:ca8b:: with SMTP id t11mr10511333ilo.227.1581090646907;
        Fri, 07 Feb 2020 07:50:46 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm978493iom.71.2020.02.07.07.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 07:50:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: allow AT_FDCWD for non-file openat/openat2/statx
Date:   Fri,  7 Feb 2020 08:50:39 -0700
Message-Id: <20200207155039.12819-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200207155039.12819-1-axboe@kernel.dk>
References: <20200207155039.12819-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't just check for dirfd == -1, we should allow AT_FDCWD as well for
relative lookups.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 957de0f99bcd..b35703582086 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4467,7 +4467,7 @@ static int io_req_needs_file(struct io_kiocb *req, int fd)
 {
 	if (!io_op_defs[req->opcode].needs_file)
 		return 0;
-	if (fd == -1 && io_op_defs[req->opcode].fd_non_neg)
+	if ((fd == -1 || fd == AT_FDCWD) && io_op_defs[req->opcode].fd_non_neg)
 		return 0;
 	return 1;
 }
-- 
2.25.0

