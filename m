Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B792A7A9A45
	for <lists+io-uring@lfdr.de>; Thu, 21 Sep 2023 20:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjIUShr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 14:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjIUShZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 14:37:25 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95BBD8684
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:21 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-797ea09af91so18715739f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 11:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695320960; x=1695925760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v/TGT+v2onwhR3DWI/C2XC90jEj/DLLYrXKmnR2IfXs=;
        b=OkyarrJghc8lGO3QyBOffqxkuM6y4VS1FNrUywgbd6eLH2gBeuptfipWNb37WvyKRl
         69hRMuQOTTrrBPt4/pHvw6Hkw9+Spqdcw7S2Nmy84ielPmjMsUmO7fzrvam2kz45Utwj
         PEaxUZzV8Rir9QoJYcxCYRP2RIYfoff6GZkeexm33xiWiqUYfo3T4n8JqQeg1PYWpB6g
         pE8fjNTk3k/VxvzSB+AzWlQ3uKEaa1kxp5MVxuZHOLcHuJcopOWRbORGw/TL+zouKcsV
         laQdtc5JHhG33+uJxwrLblO1S8aikB2D0Z1ld4VLhaAUJmehbJgGUPW1G2nNYz0hTmGH
         I5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695320960; x=1695925760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/TGT+v2onwhR3DWI/C2XC90jEj/DLLYrXKmnR2IfXs=;
        b=eMg5qDLLqGdyYEOfNih3qEbhqQFNn4ZTiNBzqGoI4l0AVJNbr45Oaq+5EV+qcmCXEd
         Y/Aqx0Y3ikdeHJeUt3I0hooLF+9UbiGOTWLAamrjwfzZ0mLawjYB1I338Rik/ub6C/vY
         INrS3BnXTLUZGlOq/H/De63F9UIm773S66hf1Qr0sRZBsEL1NDxxd6P8qABwjhL9Sqt3
         joEe9i2bdQRrSPHgc6mN93FO7F0mGiitjCPAlUBp87CAAVzA9bVTLuGOzan1yUuvMIiN
         pYT+e7WZOyNlmHSUWh+45H2k5rBiRog7XTKIPAjGiD7azgWaofadC3nKxlSOo/kDsmde
         l6/w==
X-Gm-Message-State: AOJu0Yy2syhiAaOo/o0TECH+nwR/ktb9BXzCyI9ClLsfz91864JyRlJ0
        +8zLg7pggfZ+sNOcco/vGQxDfkF/y9mgidaA3KddeQ==
X-Google-Smtp-Source: AGHT+IGEmDLrknCJWhtuHHjd+XxE0eC63PZU4o+EXvbeYFQhG7p6PVTG6rxtLvReKvtC4CGfhbJKLQ==
X-Received: by 2002:a6b:c885:0:b0:79f:8cd3:fd0e with SMTP id y127-20020a6bc885000000b0079f8cd3fd0emr2093182iof.1.1695320960509;
        Thu, 21 Sep 2023 11:29:20 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o25-20020a02c6b9000000b0042b227eb1ddsm500441jan.55.2023.09.21.11.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 11:29:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, andres@anarazel.de, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] futex: add wake_data to struct futex_q
Date:   Thu, 21 Sep 2023 12:29:05 -0600
Message-Id: <20230921182908.160080-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921182908.160080-1-axboe@kernel.dk>
References: <20230921182908.160080-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With handling multiple futex_q for waitv, we cannot easily go from the
futex_q to data related to that request or queue. Add a wake_data
argument that belongs to the wake handler assigned.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/futex/futex.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 33835b81e0c3..76f6c2e0f539 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -148,6 +148,7 @@ typedef void (futex_wake_fn)(struct wake_q_head *wake_q, struct futex_q *q);
  * @task:		the task waiting on the futex
  * @lock_ptr:		the hash bucket lock
  * @wake:		the wake handler for this queue
+ * @wake_data:		data associated with the wake handler
  * @key:		the key the futex is hashed on
  * @pi_state:		optional priority inheritance state
  * @rt_waiter:		rt_waiter storage for use with requeue_pi
@@ -173,6 +174,7 @@ struct futex_q {
 	struct task_struct *task;
 	spinlock_t *lock_ptr;
 	futex_wake_fn *wake;
+	void *wake_data;
 	union futex_key key;
 	struct futex_pi_state *pi_state;
 	struct rt_mutex_waiter *rt_waiter;
-- 
2.40.1

