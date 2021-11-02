Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726474434A1
	for <lists+io-uring@lfdr.de>; Tue,  2 Nov 2021 18:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhKBRjY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Nov 2021 13:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhKBRjX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Nov 2021 13:39:23 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2F3C061714
        for <io-uring@vger.kernel.org>; Tue,  2 Nov 2021 10:36:48 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v64so218969ybi.5
        for <io-uring@vger.kernel.org>; Tue, 02 Nov 2021 10:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=pe2MTo3IfB/qkA+auMThUnzp/9t22Jh5FrGC9uzrOws=;
        b=Gb97JCPhgbeeGd6yvoU05frN718SSy7MV616Dyla0YPRubbkXv+fJA0PGy6qER+h27
         sRj4s+L+xTJdDNHrn2LnuTxmjRZhVmQhZlUVSUYdYchCTY8g6W2WgTPvFgGo5M/bbRN9
         dGAvV5nbiPPzbY1ZsybDq5wSiv5ZwMN0oIyE/HehRukkMeaNfXviHvUZm8VCmGp0GEtw
         yUCqEZAXL4U+ap306QX3sA68wjbmGHo3FeOvQaGNQsSRWY/YUgEW8qYZoCNB1A/iDtMB
         vNVC15BYL6AlGzSgcK1GF287uhjCcVZS/EMx3wVwljNrhFUVO1oMo9r+/0YGb8MeWJui
         fjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pe2MTo3IfB/qkA+auMThUnzp/9t22Jh5FrGC9uzrOws=;
        b=T1/P6fZVQ1Wki0IguT1weTdYvZ0vZ1pZo71i9QwQDWOhPuTcU+sDNUgZrytkS3LHxO
         LZbRPfkeGUfyagAqIsw2HocaFw6sqkCZWzaG2zs0ch4x6zh6N1Hycv+iabH5EB5paZyU
         bKwBQUCZ6YGh9qNT31nUSGnX6uarUm40VRM9KdsWoCmV4yKwsphaakagcMZGUzChDODL
         piDKf4mxvw5Uip1uKL5MrgzshnatTVioYnnpSZP48D9YRAZ1iFdnbCm/wLYltxnQQEXg
         l+rS1he01FEI7qVPoPu54zL7cXxPmN45DKupCfuhWb332OOh5q0+fKAToTlSdZjukJvz
         llZg==
X-Gm-Message-State: AOAM532H55p7UJOrMYk5W2BHlHa+DaEOhnHbi0RYadAEnRBZjEbfTbJx
        KeTuNW2RSuTXZKZZX+onIJK08ymhkpKYs0ixZ934f6H8tS4=
X-Google-Smtp-Source: ABdhPJwrxup3233jk/XCRvgLedgx4OonsewKUbultOS+5Frnep/iVWF0Is+sVV5g4K9Ebdm4BCh0yY+8qCMeYUOs2xk=
X-Received: by 2002:a25:8746:: with SMTP id e6mr32676069ybn.138.1635874607940;
 Tue, 02 Nov 2021 10:36:47 -0700 (PDT)
MIME-Version: 1.0
From:   beld zhang <beldzhang@gmail.com>
Date:   Tue, 2 Nov 2021 13:36:37 -0400
Message-ID: <CAG7aomWpq3Gt9z9uqAQ5VCA_6pXgvVrL47yVx88xzX6bbotUXw@mail.gmail.com>
Subject: fix max-workers not correctly set on multi-node system
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

in io-wq.c: io_wq_max_workers(), new_count[] was changed right after
each node's value was set.
this cause the next node got the setting of the previous one,
following patch fixed it.

returned values are copied from node 0.

Signed-off-by: Beld Zhang <beldzhang@gmail.com>
---
diff --git a/fs/io-wq.c b/fs/io-wq.c
index c51691262208..b6f903fa41bd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1308,7 +1308,8 @@ int io_wq_cpu_affinity(struct io_wq *wq,
cpumask_var_t mask)
  */
 int io_wq_max_workers(struct io_wq *wq, int *new_count)
 {
-    int i, node, prev = 0;
+    int i, node;
+    int prev[IO_WQ_ACCT_NR];

     BUILD_BUG_ON((int) IO_WQ_ACCT_BOUND   != (int) IO_WQ_BOUND);
     BUILD_BUG_ON((int) IO_WQ_ACCT_UNBOUND != (int) IO_WQ_UNBOUND);
@@ -1319,6 +1320,9 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
             new_count[i] = task_rlimit(current, RLIMIT_NPROC);
     }

+    for (i = 0; i < IO_WQ_ACCT_NR; i++)
+        prev[i] = 0;
+
     rcu_read_lock();
     for_each_node(node) {
         struct io_wqe *wqe = wq->wqes[node];
@@ -1327,13 +1331,16 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
         raw_spin_lock(&wqe->lock);
         for (i = 0; i < IO_WQ_ACCT_NR; i++) {
             acct = &wqe->acct[i];
-            prev = max_t(int, acct->max_workers, prev);
+            if (node == 0)
+                prev[i] = max_t(int, acct->max_workers, prev[i]);
             if (new_count[i])
                 acct->max_workers = new_count[i];
-            new_count[i] = prev;
         }
         raw_spin_unlock(&wqe->lock);
     }
+    for (i = 0; i < IO_WQ_ACCT_NR; i++)
+        new_count[i] = prev[i];
+
     rcu_read_unlock();
     return 0;
 }
