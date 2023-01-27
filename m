Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF9767EBA6
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjA0Qxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 11:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbjA0Qxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 11:53:53 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39D01C5B1
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 08:53:39 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id j1so2137763iob.6
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 08:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbQ8rp5TPLHCAmrogV9J/Dd7MJFZT/87PZY4pmOXopA=;
        b=uIF9G4gERIlCYFJn0uWQs+ckFCTi7jddP6+99kRaCoRNxsKoNGPYZx6nGz3RNmXU0i
         j4rKVYdF2zdyLuNsLh0VqcayQT/c7Y8aIWQX/s+pRM68ZF6Wt43NV0Ay+UWO+IqOdyj/
         LL6IoHGgaMlDhhzfsV9NTTpy8gi8ORgV+sGn9Q5xUUqxUrOzKvrhsMNiKEIX7m5ljW1m
         H0GcuDDsrAkzRyieqTCc3OnmRQC9vRn6mB9fkObNir/KYkDpITMCHIaZCszNdF+rWFCd
         coXusWlEi95Lnj6GC7CFMk2zdOWVnqCtZjNXjRJUztV49lw8z8+DiYxtDSGkX0vcMgp9
         R1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbQ8rp5TPLHCAmrogV9J/Dd7MJFZT/87PZY4pmOXopA=;
        b=mtIgr3hVVcLOl+9MQv12xKGVjPWwEmMsvzRZWvw6fe6u+X0M0yixcRznXfCJn5NTev
         Yi0LgWLPHHu6OCmibx4bq8/ZDDniXZKlK+79zhG3Bp+Es8QgQYWqRJKThRcjKl0T8T48
         0A5Du28b8LVM+klUP8bNnHRNBzWBKuv5NLJVw+h6Wp/wdHW7wevMtYVLxkeaFHO3JJ4P
         6eSHWTy96i4tBayu9YHqLTi6nEoJnpjF/+hyGJoT7WeXuAxqUjsX6V6DXTmzVoF7vBZ2
         lnA7Sas+c31Y2krfEx35ySCIBZNE1V/0Xql+xfB0BQnrN55Th1wcUCZjz3tiPLE4WyNt
         F2bg==
X-Gm-Message-State: AO0yUKUxSo8rbsO6r0xc2aCwuDBwkG7H0qJutvi6JWAOZJcoJRow+ooN
        K48oKtgjwYIL2ILhw4KI68xx62K/CrfjROdS
X-Google-Smtp-Source: AK7set/YMdF0UEqcYKZ2WsCpmIrexjDoUs3gtql3d9nzMWVnDDEng/aOg106LjNScAQAU9eMR0WHHg==
X-Received: by 2002:a6b:b796:0:b0:713:9f31:9c02 with SMTP id h144-20020a6bb796000000b007139f319c02mr231887iof.2.1674838418867;
        Fri, 27 Jan 2023 08:53:38 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u4-20020a02cb84000000b0039db6cffcbasm1620587jap.71.2023.01.27.08.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:53:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: add reschedule point to handle_tw_list()
Date:   Fri, 27 Jan 2023 09:53:32 -0700
Message-Id: <20230127165332.71970-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230127165332.71970-1-axboe@kernel.dk>
References: <20230127165332.71970-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If CONFIG_PREEMPT_NONE is set and the task_work chains are long, we
could be running into issues blocking others for too long. Add a
reschedule check in handle_tw_list(), and flush the ctx if we need to
reschedule.

Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bb8a532b051e..bc8845de2829 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1179,10 +1179,16 @@ static unsigned int handle_tw_list(struct llist_node *node,
 			/* if not contended, grab and improve batching */
 			*locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
-		}
+		} else if (!*locked)
+			*locked = mutex_trylock(&(*ctx)->uring_lock);
 		req->io_task_work.func(req, locked);
 		node = next;
 		count++;
+		if (unlikely(need_resched())) {
+			ctx_flush_and_put(*ctx, locked);
+			*ctx = NULL;
+			cond_resched();
+		}
 	}
 
 	return count;
-- 
2.39.0

