Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DA269D7E1
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 02:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjBUBHK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 20:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232970AbjBUBHJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 20:07:09 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7ED23109
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:07 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id j3so155781wms.2
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 17:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qwv89hARzKNGP8KHrbG8R/UPgKVlvHM9AJKeoW7+km0=;
        b=VfQUdh8jPNVx/8iW1ETqenJgd0BTfHCltz8lodPcM8Vra5qN5PmweB0z3at3OBOdDJ
         0rrfVvakWQU7rJ17Tj2ZEWhkDbfXzEO86IuzoskjO0hHemdy/LfPJipoc+e7bNZfR/u3
         eXDtTMVwqC1zNe1/bfuKft2d8peVLwyA7f98QttNgufqXxmXzkab6IVPp33n9uQkDlsX
         P/gk43nFS7zB0JS+0VvuJZ8wAWMgxb0yWD+FHoH9G48J1dpD4vY4vi+CPmlu1sSqw/LD
         Nb3ovQQNceMcd4/Xo/VcGEvAMuFprS2RqACN+G7RWXF6aCtiMN3jv5TNzyc0NuELO83L
         LL9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qwv89hARzKNGP8KHrbG8R/UPgKVlvHM9AJKeoW7+km0=;
        b=7DBDgjYT1TxS7m5p1d+3VVUq7NnfirFJ0ifbLH0j3bghPuhcoW1yxJnApLBwaaijZF
         RJJ26OLOu7zQWm+KiQXIGEbGHUSG50qtA3k4i82BSlVoTJmU3/PO9JpXT5UQXFIX+WEG
         NtOd7pLFo2AQ9lk7HCkLISHmhkigso7FVUKMX1K9EGMnqzA4gO+f7e9C/0E08G2GYUEG
         glDaM8qolfZpucw+Lhx+MdzV6EVtMn0o8PJb4uK97KMeRo4IQaZ//LtELlfGij8hS6en
         F4CYLokPWmpDBR59njRybZ4wG+7fELqd5jxHrJmNBIWn1gX/hCczSPFRQL0//dAxpFcn
         /WPQ==
X-Gm-Message-State: AO0yUKV3JMRVEAJBx9YP8LnMU9gSOdxgM9Az0ple/EMXQ4txYqSwYyf9
        XBsTj0p2fVz1wE+fV52SLzHwPbQjqk8=
X-Google-Smtp-Source: AK7set/xEvsTmxlS6Sf7nlrT9IGwAZxxRhYXh/bIJZgsNDnfKmEnpJnMoPMe1hMyB8J+jDLY1Wlo3A==
X-Received: by 2002:a05:600c:3095:b0:3dc:555c:dd30 with SMTP id g21-20020a05600c309500b003dc555cdd30mr7170697wmn.27.1676941625713;
        Mon, 20 Feb 2023 17:07:05 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003dfee43863fsm2092469wmi.26.2023.02.20.17.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:07:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 7/7] tests/send: sends with offsets
Date:   Tue, 21 Feb 2023 01:05:58 +0000
Message-Id: <df6ee2e8912b3709f410a84fa2b58683d69a936d.1676941370.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Apart from arbitrary shifting buffers before registration so they're
not page aligned, also add offsets to send requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 8ddec39..57894aa 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -833,6 +833,15 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
+	if (buffers_iov[BUF_T_HUGETLB].iov_base) {
+		buffers_iov[BUF_T_HUGETLB].iov_base += 13;
+		buffers_iov[BUF_T_HUGETLB].iov_len -= 26;
+	}
+	if (buffers_iov[BUF_T_LARGE].iov_base) {
+		buffers_iov[BUF_T_LARGE].iov_base += 13;
+		buffers_iov[BUF_T_LARGE].iov_len -= 26;
+	}
+
 	ret = test_inet_send(&ring);
 	if (ret) {
 		fprintf(stderr, "test_inet_send() failed\n");
-- 
2.39.1

