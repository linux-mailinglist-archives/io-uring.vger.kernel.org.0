Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308261E022B
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbgEXTWw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388208AbgEXTWX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:23 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B1FC08C5C1
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u22so6676235plq.12
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=NPeCR6emidz98WZUlUAJQJvu8yY4olakxpRVboFdYQ9gU2zAwBFJJgv8zDi2J9Q1YM
         Z/b4UhpnuDwQvV3ZhmPICnBIzrHFiyxbMWvdinwCY6jB6sMRYGOoel9XhNrjtee5mnQ5
         rBuzYQwJFLAAE0y5sLi2JUrEug9+S+fE/nHUGUOdY7CfJCpAReJHQGMuN8qtMuJc7GsX
         go5TMWjy5nn8UQ5E/W9nuRIRQOaqHEr941b8sqWjEJA1JUGIPQCwN0jiwlzb5NeZnKm/
         jEuNrO65+baf53dmU14kvWGMw+xqGw0WJypQDbPZWcbwZjTmK/SktWhKYi5H26vCKl7V
         k3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7SUIxRwptQ6YWj2W/l7Dp7FzKmS+sjQ+qLVh2r/v7CQ=;
        b=iv4v98ogV+gT+3NJDQWtO7501FxkvY2CCUtwHqF4Mzlcg0KEEcjWqd1rRTPoRhJ8va
         2+2RapHk0E9fKprNi9srigBc7q+S+CwaJUwyu0FHIBDgaGZ2OmVjDShhIFJ/w6RQj9zI
         +JwPLjn1N/LmiltyEARPaZC98ym1zLmR1H4bHHd44gD2o4NvpLIMju2EHzdYLl+zhDYB
         L9kPPTv9X2kwLAQPinBpYo/ZTRW3YitKyepu5r/1m1dy/eRGDzjLNsWEluA1re/0j2MF
         +doUrw0YkEc45CExtSldQmHUTH91vDwoKrErfGBgfZywsq5zdqZ4hiR5shs2JijNPcpz
         MUIw==
X-Gm-Message-State: AOAM533sGiQ+9iLSiQmbmEe3SB5IFV/2jDTJjGUGIbr9YGDX2IeyQ2HJ
        NMRWpt0q5PtasWhiuhF41wAKcqrnrpE7tA==
X-Google-Smtp-Source: ABdhPJyVkJr3aVXSWL6AsAVEub8xJtYv78/J0qU/nA6EVR06VnyscVr47TXcn5OopxXRfYsxyeWx2w==
X-Received: by 2002:a17:90a:d191:: with SMTP id fu17mr17281565pjb.228.1590348142170;
        Sun, 24 May 2020 12:22:22 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/12] ext4: flag as supporting buffered async reads
Date:   Sun, 24 May 2020 13:22:01 -0600
Message-Id: <20200524192206.4093-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524192206.4093-1-axboe@kernel.dk>
References: <20200524192206.4093-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d624250a62b..9f7d9bf427b4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -826,7 +826,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 			return ret;
 	}
 
-	filp->f_mode |= FMODE_NOWAIT;
+	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
 	return dquot_file_open(inode, filp);
 }
 
-- 
2.26.2

