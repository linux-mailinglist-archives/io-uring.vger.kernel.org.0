Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B58464EB7
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 14:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243852AbhLANYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 08:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbhLANYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 08:24:44 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB17C061574
        for <io-uring@vger.kernel.org>; Wed,  1 Dec 2021 05:21:22 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so1136807wmb.0
        for <io-uring@vger.kernel.org>; Wed, 01 Dec 2021 05:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSpnMHKvhBQEYOSDHZ4uy6f8JUGZsGZg8bj5CZFIIHw=;
        b=kC5gcRaO4pNKu2WwkGGRqxUnYarmdtFNfeP2NTeApMKoI0lutD7N1vrXceLV90AImJ
         0BNxx4Gh5UWSAySsreIKNOOgTa0rOKGdIt5xsdDQUjmtufZutnB7IG9xxthIiXj+XhWh
         RmoEbxZQTihIen3nF1j7T6zP+sVmBmJZUojkW5uTOceGpWMYObDr6x5aYDZas97bEXSx
         YnzXf1kSGlmywAF+wfp9tofGqbFk0qi3iu8bBuALYeUCCZuG7D40zkx0cmFvR1OdYvev
         eMubnrafmO0owiGX1XJIwY+UziFPKxfzJTMokwbHsqE9J7Js5SpTbA2TzF4S5WyYBBP2
         CB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jSpnMHKvhBQEYOSDHZ4uy6f8JUGZsGZg8bj5CZFIIHw=;
        b=Yvk8Er7mqpKPf3cEfJ8UW5StTU7HQlbDeEk28xS4zCnKE7rFV+wI6hRZBYh73D5Uqd
         9a2quD2KUm8BmkRDidobBj7AU9usUIMFFAijPgSeePvxiaBgnMhvX0zsDb2pBv0AEvHC
         1DPalTXlds+IxGO2at7tQwHDT2OyFmUbWBDhbRVLTfj9lnll1dYI1w8MQ+A5u4Kl+jd3
         i+nw+LzVdyD7aYBKqQB4U7fcbJNxEgHm96nZ6/MtDMl8uaPhcYf8eQQj/9zgy+S+kn3E
         DbTPyvPfGlgAntfDLrkkEgz8brC+nCF3hxf682/98Lzqc12ea+sF/rYdxDvF92FckqRG
         AAag==
X-Gm-Message-State: AOAM530JB16BOM56Q1pKixRHLWBvOn+Vzmsu6dzfwWpj3i1RZc7EUtaE
        L47TV8UQukDgb3D9ps7mUQhxT9N3wBE=
X-Google-Smtp-Source: ABdhPJwG1LmqeSATZqdklddWENRtVA/tX4K5yzVCEN38EUK6ZwHfzzepzSxAQNLC+KwFVYlGojcq2A==
X-Received: by 2002:a1c:80c5:: with SMTP id b188mr7198557wmd.57.1638364881212;
        Wed, 01 Dec 2021 05:21:21 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-231-182.dab.02.net. [82.132.231.182])
        by smtp.gmail.com with ESMTPSA id d2sm1103929wmb.31.2021.12.01.05.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 05:21:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH liburing 1/1] man/io_uring_enter.2: notes about cqe-skip & drain interoperability
Date:   Wed,  1 Dec 2021 13:20:37 +0000
Message-Id: <8c81bf9b01a54d1214bb65678c2ff1362a9f9328.1638364791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOSQE_CQE_SKIP_SUCCESS can't be used together with draining in a single
ring, add a paragraph explaining what are the restrictions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index b003e05..871cbce 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1115,6 +1115,15 @@ CQEs in cases where the side effects of a successfully executed operation is
 enough for userspace to know the state of the system. One such example would
 be writing to a synchronisation file.
 
+It also doesn't work with
+.B IOSQE_IO_DRAIN.
+Using both of them in a ring is undefined behaviour even when they never appear
+together in a single request. Currently, after first request with
+.B IOSQE_CQE_SKIP_SUCCESS,
+all subsequent requests marked for drain will be failed. However, the
+error reporting is best effort only and restrictions may change in
+the future.
+
 Available since 5.17.
 
 .PP
-- 
2.34.0

