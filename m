Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F4832C9AD
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbhCDBJ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383823AbhCDAby (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:31:54 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDF5C0613B8
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:13 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j6so1488131plx.6
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j661bsdEzw+WWj5Yixd5Ei+KT/sF7hcqps5bfMiMY0A=;
        b=nyIgZblcsPHUGlUfeOcE2rdIKUwzNIy8WK7N8paNpAZDEott030ISZAdgpKOb66s13
         mLLuC7EjzSh0E3GyszNsemcIy9T5LVqbGQCUcDnVrYMIoctUJMPH9rDxYyhZxNCRKqFc
         LOXE9l6mVnUL2dbBrKztjb3PolfxUJQw4ubambCRC0L99aXUV3IutjhGATUyx6KXXEQQ
         SccYtYDYuFhaSQoK0rdxIuWfU06olvlOIbnraD/x5ot8Ssr2WfYJC4dVnY6nfwKRaQRQ
         K+roiTgix0LcyThZqMwSSz7mZq/gzGuMm85kZNk3Y/APwk0YC7u54nWKONRa4HEPyrT/
         EiDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j661bsdEzw+WWj5Yixd5Ei+KT/sF7hcqps5bfMiMY0A=;
        b=e2daRKqcuAwhrioguvSzjV+i5yjbc0Dx/ZT8aM4ApAPgkjJvB+8Z85xZvD+MQO9xTk
         Stx6l3Ez1kaUUHkzRZtOsL8UuL+u5CyAmZAHxtj+G4OO63t2ikFPpSimuEsJQobLZ2bz
         dYUq0lypQgwvrz5P71c1xkEAjOcqCmyBmTPTiiUymswJaa0vv8jV/Rcu1KGbVvYt9+u1
         mEU83xZv3zVcDVSptMv0lffuBHV0L8IoqZI7DXexlBlnu06/eCYsvPeojUr9SrSQBBod
         NPCC+J6zWgKRxtcmizuj7GBu2/yvt6LD/fIrVzT3UdkdvnQ4KwlK14wVuQpIwyE05d1l
         /PKg==
X-Gm-Message-State: AOAM530iqZLtZOuTZVw0Z5lmeuuLj3ayBnAKvsUM8Qm2FXd4SDHGdgYx
        8oK5DQsNQuk9yZvdAPi6MfTBVDYmvdw8EXOW
X-Google-Smtp-Source: ABdhPJxfYKLjfi+Dp37wPmKR9dphcOK+4+11eC/RitJOHSsobk7MydfaCU8ou09xACplA1XyUWh93w==
X-Received: by 2002:a17:90a:7309:: with SMTP id m9mr1667897pjk.23.1614817632866;
        Wed, 03 Mar 2021 16:27:12 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:12 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+7bf785eedca35ca05501@syzkaller.appspotmail.com
Subject: [PATCH 06/33] io-wq: fix double put of 'wq' in error path
Date:   Wed,  3 Mar 2021 17:26:33 -0700
Message-Id: <20210304002700.374417-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We are already freeing the wq struct in both spots, so don't put it and
get it freed twice.

Reported-by: syzbot+7bf785eedca35ca05501@syzkaller.appspotmail.com
Fixes: 4fb6ac326204 ("io-wq: improve manager/worker handling over exec")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 9e52a9877905..23f431747cd2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -819,7 +819,6 @@ static int io_wq_fork_manager(struct io_wq *wq)
 		return 0;
 	}
 
-	io_wq_put(wq);
 	return ret;
 }
 
@@ -1071,7 +1070,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	if (!ret)
 		return wq;
 
-	io_wq_put(wq);
 	io_wq_put_hash(data->hash);
 err:
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-- 
2.30.1

