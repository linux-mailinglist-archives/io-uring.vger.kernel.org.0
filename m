Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B033E305161
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbhA0Ep0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405384AbhA0BqB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 20:46:01 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F1CC061788
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:45:00 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id kg20so423084ejc.4
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 17:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ATq6aIljGA0KItlm6hgolHqO3IbhZnBIOX1SZqRjII=;
        b=UjVjqVoXAfERM7HQ2IoJbIQBrqYfiIHcXjHblfZKxNb31nlvo1Uq6Lw70ESi7f9fFC
         EE7kt0J7sok7LvVVO8ia9d/jPFmmyU0Hx23nPW2346cJ9wjaFGvcY19FEmp3Qpd/a8BQ
         OkKrOI78ao3zasPe7RTZ1wX+xyDDuL2WRYeSq2MXoojAdH9RHrCcYSnJqMswn6RQee2b
         /imfcmpTJZGITeIWzlRkg/GLWG6LMj+k2uhSfl4toCw6c7Q4sTzxh6jwxB8fDKU6T0YR
         wShqhdfONWJGkMmi820bsRE6RIX0O1rYWAM17DzJa6sKP5ghRW9bLiYFmBMKNhGC+S9G
         JyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ATq6aIljGA0KItlm6hgolHqO3IbhZnBIOX1SZqRjII=;
        b=okcXsCoHN10kzBRbhYeieA/HyAknUl1A4HKnYON2gX7KyPNaclqgmaaoHVoato9h1r
         dMowmUWfIl7kNxyu13KHw8fWU7g2gi3JHLiqsVrnUAI0GYZM4+jCfvFuab/VsKRJH3XQ
         8ivhFUj/6uU9fQhr8XlCq8XdmEhfG+6t4OUyTScBgyQc+pswtEGZincRQgZaSiRT3qvi
         tYRYlSf5yTQut4XwIQ1Bu2Iin6IaTfkhDofr06UBuHCA/pt5JDtcOTScIHnkJR6JJBe1
         ifrQiozDb0XmFiOgKuQjUE/1XwjRWhTbp6Iv17KRygd3F2NG0B3QlpIaDVUgktoG1bN8
         NYFg==
X-Gm-Message-State: AOAM531KCMCBv0RnhlfuUyfqexzAZeQKsk2R2+gVZT9YfMt5HlVSJi8E
        6njTEDA7xp+v7KD81jWU1Uk=
X-Google-Smtp-Source: ABdhPJzVnH/FZ+RhDQpLulxhL1/nFbmdlfc0J8MjG/PHIOPpLVzPPAWvZzRCQRElHoTRpgLxLAz6sA==
X-Received: by 2002:a17:906:259a:: with SMTP id m26mr5222630ejb.399.1611711899663;
        Tue, 26 Jan 2021 17:44:59 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id u2sm139235ejb.65.2021.01.26.17.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:44:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2] test/drain: test draining linked timeouts
Date:   Wed, 27 Jan 2021 01:41:11 +0000
Message-Id: <bea8a84405fa2b68a4c18ecae7b80cc2c983002f.1611711577.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make sure references are accounted well when we defer reqs with linked
timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: mark with IOSQE_IO_DRAIN all

 test/defer.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/test/defer.c b/test/defer.c
index 05833d4..98abfba 100644
--- a/test/defer.c
+++ b/test/defer.c
@@ -148,6 +148,38 @@ err:
 	return 1;
 }
 
+static int test_drain_with_linked_timeout(struct io_uring *ring)
+{
+	const int nr = 3;
+	struct __kernel_timespec ts = { .tv_sec = 1, .tv_nsec = 0, };
+	struct test_context ctx;
+	int ret, i;
+
+	if (init_context(&ctx, ring, nr * 2))
+		return 1;
+
+	for (i = 0; i < nr; i++) {
+		io_uring_prep_timeout(ctx.sqes[2 * i], &ts, 0, 0);
+		ctx.sqes[2 * i]->flags |= IOSQE_IO_LINK | IOSQE_IO_DRAIN;
+		io_uring_prep_link_timeout(ctx.sqes[2 * i + 1], &ts, 0);
+	}
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	if (wait_cqes(&ctx))
+		goto err;
+
+	free_context(&ctx);
+	return 0;
+err:
+	free_context(&ctx);
+	return 1;
+}
+
 static int run_drained(struct io_uring *ring, int nr)
 {
 	struct test_context ctx;
@@ -269,5 +301,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_drain_with_linked_timeout(&ring);
+	if (ret) {
+		printf("test_drain_with_linked_timeout failed\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.24.0

