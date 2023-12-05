Return-Path: <io-uring+bounces-236-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE70805887
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 16:24:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A457B20FE9
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 15:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F7668EAA;
	Tue,  5 Dec 2023 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Btdsm94c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A431705
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 07:24:07 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-50c0f6b1015so282453e87.3
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 07:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701789846; x=1702394646; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=je/vg8f82xCfwDvxT7gCSUQJp1afzamAFLgk+nn4sZY=;
        b=Btdsm94c1C48hoGUQXjKJpOvNcWB6GrfH9vxwgXAl5zQm4goBk1vWo45xLr/8YW4Fi
         +nHGBIn8YRpj886P/e7vlOV27ywGZ9NEDPxruLMdAiN0Cu8htRcVFtVdoi6bXLyVduuk
         zXCQhhDL/ohxAq2D8OO35wosjSEu08nZabFOcEqu5SoBgL2wYwtriVg5O7b5mW9XiFg9
         tWFvAHFFRygQDODDDuU+/FK5vMzrl29ZzjGls6h/h9zFxeK+wZYmjbToMSGfzANlBk7w
         gkif+EtwA/71bkQyG3pLWzgDuoVWqEWQNmjzX8eZLA1F5AqvVJRf7i3/XWfjBpYHV2wf
         C4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701789846; x=1702394646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=je/vg8f82xCfwDvxT7gCSUQJp1afzamAFLgk+nn4sZY=;
        b=X5RfY15KqhpcQZ0hVn6o7+x+TgSURO5ddILWYvXmNDqYQCKTO7X7H6cPHp1o6NYOEX
         2Ij+IsJ6+SzKpaQect2XpbTwN80pnzTj2B4J0dgY8uSLBbbu+txS+QRJYKRKwQFe8kkp
         2BfhKSJKxVp9jqtMdzJ8Nrwg/OWojcQjoRDGST+3BfJNxfTBWfSl6OW14tvszRV1MJGJ
         QMFGZBCNy7PLacEinolLpHzsCAhlhGyjTNZZuS2WQQO7e3ARdgV+VoELVzVL5kx/7HKq
         P5hEcnH0Ep7aaBhfp5uKgZOCfhlCNa/DptojpIu1A8stsykJaAST6llWGca4N6NFlnN6
         cC8w==
X-Gm-Message-State: AOJu0YwkAg+OhUqSUjINvFILRo6m/nQaxWH6ZWsjE6uZpWaowoW/kFc0
	xqLvSCmXlQZbkYIKfzgXExHSPJxgpts=
X-Google-Smtp-Source: AGHT+IE+6S72aDzKqtwXOIsg77tdvCg9w/hfTv4YdDK7jDzXSk3DWjTJgZpcQB+NFNu6gHDScHfueQ==
X-Received: by 2002:ac2:5fad:0:b0:50b:e195:d38b with SMTP id s13-20020ac25fad000000b0050be195d38bmr2403119lfe.25.1701789845694;
        Tue, 05 Dec 2023 07:24:05 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:ebcf])
        by smtp.gmail.com with ESMTPSA id s24-20020aa7d798000000b0054c9211021csm1221591edq.69.2023.12.05.07.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 07:24:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 4/5] examples/sendzc: try to print stats on SIGINT
Date: Tue,  5 Dec 2023 15:22:23 +0000
Message-ID: <08d8d03b0f4e17afb8643996b8d8f55a730d1a4f.1701789563.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1701789563.git.asml.silence@gmail.com>
References: <cover.1701789563.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If interrupted in the middle of a long run, instead of silently
crashing, as we currently do, we can try to print intermediate stats.
That's a good use case, and it's always annoying loosing results when
you forget about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 9725d0b..84d2323 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -39,6 +39,7 @@
 #include <sys/wait.h>
 #include <sys/mman.h>
 #include <linux/mman.h>
+#include <signal.h>
 
 #include "liburing.h"
 
@@ -82,6 +83,16 @@ static char *payload;
 static struct thread_data threads[MAX_THREADS];
 static pthread_barrier_t barrier;
 
+static bool should_stop = false;
+
+static void sigint_handler(int sig)
+{
+	/* kill if should_stop can't unblock threads fast enough */
+	if (should_stop)
+		_exit(-1);
+	should_stop = true;
+}
+
 /*
  * Implementation of error(3), prints an error message and exits.
  */
@@ -421,6 +432,8 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 			}
 			io_uring_cqe_seen(&ring, cqe);
 		}
+		if (should_stop)
+			break;
 	} while ((++loop % 16 != 0) || gettimeofday_ms() < tstart + cfg_runtime_ms);
 
 	td->dt_ms = gettimeofday_ms() - tstart;
@@ -582,6 +595,9 @@ int main(int argc, char **argv)
 	if (cfg_rx)
 		do_setup_rx(cfg_family, cfg_type, 0);
 
+	if (!cfg_rx)
+		signal(SIGINT, sigint_handler);
+
 	for (i = 0; i < cfg_nr_threads; i++)
 		pthread_create(&threads[i].thread, NULL,
 				!cfg_rx ? do_test : do_rx, &threads[i]);
-- 
2.43.0


