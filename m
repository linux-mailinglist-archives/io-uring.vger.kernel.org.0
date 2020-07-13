Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A89021E3C6
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 01:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgGMXn7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 19:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgGMXn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 19:43:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4C8C061755;
        Mon, 13 Jul 2020 16:43:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so19475477ejc.3;
        Mon, 13 Jul 2020 16:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5WX6L7s9zCJbAz4+63goRJTZCABfCH31DReSSw3KGQQ=;
        b=tu8y3iLZhI46qYmfddtRluE6aL11TMyvuYevBslMBOaBKPGJHQSPZj4OMY9OleecPX
         fxAbOE8nEoo5GvbyrDbXHVkxTrnws6Tb66sT9xhVazdqQHlV4RXzHl7XUGH8OCZGgDnK
         RNpNTWj18lzfRpMg3ixElf9OovtHqJ8uWwASmV0unpw5CZDIYQ2zLEQhiiFIViGcTyRM
         s0yun8k/VZHVFE0NkgrdqrIL6oF4YQPa7RMnR7vWaKGE7nobGGFLM5a0s8UHFzlzIUEr
         guiPsTWY0ANVtZwKBj6WJD7C+RRoqXgFBJKhW+Nt1litqGvrAa74FnGo0ALDP4uexR6q
         /mlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WX6L7s9zCJbAz4+63goRJTZCABfCH31DReSSw3KGQQ=;
        b=oYLa8i2pAufqVfluElAZHE+XeUBiNAcJSnwvMORIfa1vy56kPXkJEtPRG93FV3NJfp
         puX3R0qZAmN9tZcJHPrQf9Kdb74I45bhpsuv2MqD/ehoYtEzd0nrF8UlP//LDbIHr1SA
         beTB0HTA8DttL+/7UpPPGS1CTwuLhUaLD5jDY/gsyUnIAN9nSuAjpajZ11gV+G1DAtHz
         qjl18/EQ11QsuRQnEVl3Gd6fHfOdqvRrufk/da2TVgtlg5lhceVS54oV2lcOWfNmb2xy
         GerfZvkemCRTXG87/5YLiehBwlh4wVV/icqRtvuZENK7Wl1r85/rpeCxDtacCbTEYNzW
         fCUg==
X-Gm-Message-State: AOAM530PMVkG+rDhE/VzYSprC/6EPFms7geRASVsDplT6djDzt7n6EHJ
        Vc05LTaHebht97zHknx1n5U=
X-Google-Smtp-Source: ABdhPJw5Ws5ld6m6hMQ3NQksGZjVbB9yauq8NGAr/TPbmcBYX+dH1G0krl8CKtYCcLJb44cYj1uHuA==
X-Received: by 2002:a17:906:328d:: with SMTP id 13mr2009905ejw.71.1594683836475;
        Mon, 13 Jul 2020 16:43:56 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a13sm12964712edk.58.2020.07.13.16.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 16:43:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] tasks: add put_task_struct_many()
Date:   Tue, 14 Jul 2020 02:41:55 +0300
Message-Id: <97d4ccff189d1df7e0a7656af40ced2642caef99.1594683622.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594683622.git.asml.silence@gmail.com>
References: <cover.1594683622.git.asml.silence@gmail.com>
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

