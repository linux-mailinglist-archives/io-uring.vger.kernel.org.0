Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B745A702D
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiH3VzM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiH3Vxi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:53:38 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28F6985AD
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33dbe61eed8so188505257b3.1
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=q3DJ62FdAkc75G5f5TC1WQpGOVt3l/MJJCNdx5cTnOk=;
        b=C8JONxxXVlTpftHaAGAIlpLkK3JbLire6Nmp7rtyqKkA8STqUN7GtKHqgck9OnhnK6
         JLmVEdOBtO4UgVT+rqGSVVb8el9/E2EzKFM8T34Szjzm3zJ0p5kFz3mCYcxw5G4J1WvF
         QMb4GTQ/yzzPPSsO8n/bi291Hq8qngpZB5y0K7P/GbpAFTCQEKZCNPr9wH/IKiRw2v40
         589a1BB4hctRlz5v1afevUX177R+LYQq/8EEHO7YXqeqRF8HSNYDOdN7xFassnCgRext
         TnhJSTiUhrw0wYWDFlFWpRGy66tj1fz8fdmGodc46WuVd0A4xLZ7WpBC/QBvDzjQGrdA
         SEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=q3DJ62FdAkc75G5f5TC1WQpGOVt3l/MJJCNdx5cTnOk=;
        b=ZMJPUV+3QIlZnBbH7sKbYmSfLYhm2829g4UbOWWuIAsD3OIgTp3rt04YiQtjNGsAlW
         jxYX0/jv1Z/YB8AnqXvXTp2eaBE48xzBX0sI0kk3T5wcrh8lVmdQSHnPiEUs+4ygP96Z
         3/r3SFvKrDY5LgRPBfOVajyXCQGNE/nUZucXOhmEF53ISm832nxYL7rjRcZ0ciKSjrwh
         I8sVPw7p8TfAoAxxTeRxuGTQoC4ydYS0oTQ4HTRnKBEkgxixILgl6t9xFwGlQ9rAJ56i
         DcR2ecZ63jjMh6UEVRhDna9n9y+QiXCstq3rFvsfV2lwMwSNobBzInfkXwkNlQwUXgcF
         B2gg==
X-Gm-Message-State: ACgBeo3M1tt9rJNzsWWhJm11MoEiMDRD+C+UoemyfR5K8iyiw95BuQuq
        RNLy9pjYjR0EKgyUCE+uRgdGqSSRK0E=
X-Google-Smtp-Source: AA6agR6mRIYh/Ugh76Z9OGxiRjbQrZ+9wpxKxcSIOnClnh/ne0QVaaMxuz4y8WxW9UVOyJ1glmO9CKBYbzs=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a25:8a85:0:b0:671:715e:a1b0 with SMTP id
 h5-20020a258a85000000b00671715ea1b0mr12680068ybl.98.1661896243785; Tue, 30
 Aug 2022 14:50:43 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:49:19 -0700
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
Mime-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-31-surenb@google.com>
Subject: [RFC PATCH 30/30] MAINTAINERS: Add entries for code tagging & related
From:   Suren Baghdasaryan <surenb@google.com>
To:     akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        surenb@google.com, kernel-team@android.com, linux-mm@kvack.org,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Kent Overstreet <kent.overstreet@linux.dev>

The new code & libraries added are being maintained - mark them as such.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 MAINTAINERS | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 589517372408..902c96744bcb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5111,6 +5111,19 @@ S:	Supported
 F:	Documentation/process/code-of-conduct-interpretation.rst
 F:	Documentation/process/code-of-conduct.rst
 
+CODE TAGGING
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	lib/codetag.c
+F:	include/linux/codetag.h
+
+CODE TAGGING TIME STATS
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	lib/codetag_time_stats.c
+F:	include/linux/codetag_time_stats.h
+
 COMEDI DRIVERS
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	H Hartley Sweeten <hsweeten@visionengravers.com>
@@ -11405,6 +11418,12 @@ M:	John Hawley <warthog9@eaglescrag.net>
 S:	Maintained
 F:	tools/testing/ktest
 
+LAZY PERCPU COUNTERS
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	lib/lazy-percpu-counter.c
+F:	include/linux/lazy-percpu-counter.h
+
 L3MDEV
 M:	David Ahern <dsahern@kernel.org>
 L:	netdev@vger.kernel.org
@@ -13124,6 +13143,15 @@ F:	include/linux/memblock.h
 F:	mm/memblock.c
 F:	tools/testing/memblock/
 
+MEMORY ALLOCATION TRACKING
+M:	Suren Baghdasaryan <surenb@google.com>
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	lib/alloc_tag.c
+F:	lib/pgalloc_tag.c
+F:	include/linux/alloc_tag.h
+F:	include/linux/codetag_ctx.h
+
 MEMORY CONTROLLER DRIVERS
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
 L:	linux-kernel@vger.kernel.org
@@ -20421,6 +20449,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
 F:	drivers/net/wireless/ti/
 F:	include/linux/wl12xx.h
 
+TIME STATS
+M:	Kent Overstreet <kent.overstreet@linux.dev>
+S:	Maintained
+F:	lib/time_stats.c
+F:	include/linux/time_stats.h
+
 TIMEKEEPING, CLOCKSOURCE CORE, NTP, ALARMTIMER
 M:	John Stultz <jstultz@google.com>
 M:	Thomas Gleixner <tglx@linutronix.de>
-- 
2.37.2.672.g94769d06f0-goog

