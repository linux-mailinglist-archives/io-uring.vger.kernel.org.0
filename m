Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53F93EC86E
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 11:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhHOJpA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 05:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbhHOJpA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 05:45:00 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B4C061764
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:44:30 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so9704113wmi.1
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 02:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EhCNxAiXoz6qiOD14YM5jyx8gf/WTUGj5DtBaAjNC2o=;
        b=RTMdmnjEpBzyrV9ENxNIAciF8RX4iJZWGHoPsOxj5w2CpRKUkEFcLviTXcaVh1gUVk
         kfQlTU/E39oAEHfHGO05ibD85UaKb0AlMhoOOKsOWQH4nRURnRGdPH2gbJ23lTEAx44d
         8v1f6EhWHSOLFfTMaGiUjfuKvi7gORSL9O95g61VpygVqXSyhDfXj4jB7ji/jLZC31jN
         jTeTX7VWX3WPpmcr7wfMwNbjYeyU5qB4A4AAUmzCz/sQiPA6jmCpi2monZdZXQcRCxzC
         xSaQYJoRstPSgKbKaM3NCbvkAH3hJofzHObGLm2RT10DS2wIQ9IpebE6iIE19ysG5OlH
         G3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EhCNxAiXoz6qiOD14YM5jyx8gf/WTUGj5DtBaAjNC2o=;
        b=g+Zc1l14suX0u0YBvOIsMo1zzBsv0TyOQGHlf1q0Y1ctoJckxXzWv3HbkRBBRuHI0Q
         wzSmhQXbFqpcBK/UcclFaJK1NzsaXwnz1HRtBHv3lHw8rp5qFVZFCo1Q8tIW7jUyCyKb
         OnHKaTQM9TnS5X5nmoBpgTpBx139Ww1svMXMdF2cf/n5slF9ThHm28mkMTvlPBwyGyUk
         gdrdP95hmfPWXmu3UFxZmEMQLmWw818wVttEOa3/vyswwRnNg6eNo/+MktquPhqBXnXo
         XXCDnvUPcXZPbaeR5Wko4agRpjuevYvFHowzTDh2bYKWd7CZfqOvjvouW1tD6N8CVqLm
         RiCQ==
X-Gm-Message-State: AOAM5331kK9EwKev4kLTQ1WchHAuONn/kD4XQNHSwm+1Cn9peYQCTaK+
        jQjFH1LrP2DYHkQbtHStNwU=
X-Google-Smtp-Source: ABdhPJwNXniNspP+DZmXpOcMCxlchpfhDRiGx9PtqZZFAj55kOofSvckgrqYVYUYWcyt0Jt8SPxbVA==
X-Received: by 2002:a05:600c:21c1:: with SMTP id x1mr9533712wmj.43.1629020669006;
        Sun, 15 Aug 2021 02:44:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id i21sm7784240wrb.62.2021.08.15.02.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 02:44:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: close pipes in link-timeout
Date:   Sun, 15 Aug 2021 10:43:51 +0100
Message-Id: <02771d9c5820fa0fa2fc87f697f0f232b9b23a0d.1629020550.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629020550.git.asml.silence@gmail.com>
References: <cover.1629020550.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget to close pipe fds after link-timeout tests

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/link-timeout.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/test/link-timeout.c b/test/link-timeout.c
index 5d8417f..8c3e203 100644
--- a/test/link-timeout.c
+++ b/test/link-timeout.c
@@ -619,6 +619,8 @@ static int test_timeout_link_chain1(struct io_uring *ring)
 		io_uring_cqe_seen(ring, cqe);
 	}
 
+	close(fds[0]);
+	close(fds[1]);
 	return 0;
 err:
 	return 1;
@@ -713,6 +715,8 @@ static int test_timeout_link_chain2(struct io_uring *ring)
 		io_uring_cqe_seen(ring, cqe);
 	}
 
+	close(fds[0]);
+	close(fds[1]);
 	return 0;
 err:
 	return 1;
@@ -833,6 +837,8 @@ static int test_timeout_link_chain3(struct io_uring *ring)
 		io_uring_cqe_seen(ring, cqe);
 	}
 
+	close(fds[0]);
+	close(fds[1]);
 	return 0;
 err:
 	return 1;
@@ -917,6 +923,8 @@ static int test_timeout_link_chain4(struct io_uring *ring)
 		io_uring_cqe_seen(ring, cqe);
 	}
 
+	close(fds[0]);
+	close(fds[1]);
 	return 0;
 err:
 	return 1;
-- 
2.32.0

