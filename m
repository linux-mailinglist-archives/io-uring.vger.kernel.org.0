Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952AD2249DD
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 10:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgGRIew (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jul 2020 04:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgGRIeu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jul 2020 04:34:50 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEA8C0619D2;
        Sat, 18 Jul 2020 01:34:49 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id e4so15269199ljn.4;
        Sat, 18 Jul 2020 01:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5WX6L7s9zCJbAz4+63goRJTZCABfCH31DReSSw3KGQQ=;
        b=CS9t+3U7zLDb7C+kKVnZZJbJ89NsHWkgXyIwRDqdyFg3ZOMPyj8aT6GvcqIquZGu67
         6rUVGuIpuntH3F4N1YYBmTyNvczxNZI9sgZ1uDIDRfw62cJNR0O7ao16lPNPjdMTYHgW
         7ac2edUrXluW6TzRo0e2Y1TziagV19dUnF/rGoQ95uuwFx/8sL31q1IbNH+BJTBeF1NM
         z7UcABP2Gy+9wP7AdmBYQjT1BKirpgPi5FhG/cKIASDH0hPyy/MHppoHaQDxHoHI1/lO
         pjI4nPsleNM3baR5GSZj0sESmw4m3cgvJsoI80Os+nBG/hDGfqiy1Iri2AElI+ADLS69
         8Cyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WX6L7s9zCJbAz4+63goRJTZCABfCH31DReSSw3KGQQ=;
        b=ODpEVT42uwFFyZd1htdZosHLalWn+3OsN9RgwubdROL+Uy2csFBqJmHvKwLjI2tVz9
         LsvLv6nfOiKZyf6iguiZA5Mk9314xw208Z1Kcbglr3rA03AAKH0r4UXLouTeIfM2xlVw
         W2MqTO4pjV20MKFVptLP40Aj8uOmPiwZUbxrfBCYgztGLvHBFqapATiSdm/4kbjSMOg4
         jrZZnw1tH+ujxm87jo9UsmU/W7HTZ2Hdi1dgySV2PH8qf+hJSoYQu38HLzOj6fUcKmZY
         u5XZNXPn/cknivsIk7c+VNVWZYjCDKeSiUyfgvBwg+Wz4Rhc49byQd2UMYOhf4OzKpYL
         cbcA==
X-Gm-Message-State: AOAM532DBswvce18/SsbgmepAtpyXrVSsxPkfeDn8OToW+3a/l9DTbkh
        lxm4prONX4pRe8NgYiII4hA=
X-Google-Smtp-Source: ABdhPJwG02o6OxVM6O2i0fH3COJulBcOVOB2FMpBsZHsg8vwHHvCWos1REcNKFl3t1qrwyuSKmLJNQ==
X-Received: by 2002:a05:651c:c5:: with SMTP id 5mr6664386ljr.9.1595061288418;
        Sat, 18 Jul 2020 01:34:48 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id u26sm2789226lfq.72.2020.07.18.01.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 01:34:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tasks: add put_task_struct_many()
Date:   Sat, 18 Jul 2020 11:32:51 +0300
Message-Id: <320e500c71a4c10e34e0513d31c74919035e42d1.1595021626.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1595021626.git.asml.silence@gmail.com>
References: <cover.1595021626.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

put_task_struct_many() is as put_task_struct() but puts several
references at once. Useful to batching it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/sched/task.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 38359071236a..1301077f9c24 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -126,6 +126,12 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
+static inline void put_task_struct_many(struct task_struct *t, int nr)
+{
+	if (refcount_sub_and_test(nr, &t->usage))
+		__put_task_struct(t);
+}
+
 void put_task_struct_rcu_user(struct task_struct *task);
 
 #ifdef CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT
-- 
2.24.0

