Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F025E5AD4B1
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 16:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbiIEOXf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 10:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbiIEOX3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 10:23:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5654D17D
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 07:23:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id qh18so17414598ejb.7
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+6GKmuMBvxvZ7P18wLcMpxJrZ6oY37ClDCfrGbE2Lhw=;
        b=nitVqB7/lmXkA+TJUD65MfrR/09V90JB6Dsw6k6tUbDAMHhE2clan9N/fTte8mtjW+
         Qmif1CJKAgGZrPpzJ3jn/CGolQZ5P8plz5vMDshq08vgl1Uilwr8P8kUCKkYm0e7QjHe
         gxxyJCsjNdXnYeum0x3HXc2RViPWXmxp3BTp1/oMuccygdHaoJrXBnc799LOkeHNaFei
         JY0AT+BNVmhEMVuKH2D+rD8rMvVy5E2rC0TxlOcelkjWBNcPMCWIAaeO8Ujr/lZaDJEz
         c89gW0ZMD2bAcNMWLlaTNfP1QTS8I+jozOo9uwLf7FBzBTYeevbfmwzkRG8sJJRm4uKB
         r0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+6GKmuMBvxvZ7P18wLcMpxJrZ6oY37ClDCfrGbE2Lhw=;
        b=tzCcdlbBnp6x/jxeAwp+YEFxd+vZ6i4bevJ9vVfuyt8f5Yj+wAp77zOzJzvSaHZ5KP
         6u1w9LKJOhMjhrnXOmuhs5KYatNHG+BPjyztK8/TMbbg/LLnp7OwQwDGCPKSffzL+qjl
         OgUYMqM8h8qH5NEMbXU4CAOKdSooYGmVQYtItIOpFZqmRZxy89fRKGLeGWy0+siFfx74
         mSND6LVE18XSCF12/mM7QsAtEcwCqKdwTCEbF/1nBEFV/BxdXTz1MeWvqvkS7T3GV1OB
         fG/uywXuOWoq1P/PNKyBhpX1x+qzkYY0a2vS6OxJfeDDxaBuYsGQyni4H1xNFWM4jI44
         /xvA==
X-Gm-Message-State: ACgBeo0l62WOesGrjHRdhZ/81QSsc7/OO0Ao3rp7kgThu2vViMXKK3+d
        SqB3ocvtTQfptt4Tl9MTZVAZEO2Cbug=
X-Google-Smtp-Source: AA6agR6gUrX0NSJ3IZToa/Adpk2VYfUIK4fLHkI7pmmd2R6pyzW8oQOW5BOUWQI0N8YzPYqFZp9vzw==
X-Received: by 2002:a17:907:a0c6:b0:741:d9a1:e2b6 with SMTP id hw6-20020a170907a0c600b00741d9a1e2b6mr21610869ejc.99.1662387806580;
        Mon, 05 Sep 2022 07:23:26 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a118])
        by smtp.gmail.com with ESMTPSA id x10-20020a1709064bca00b0074182109623sm5168799ejv.39.2022.09.05.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 07:23:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/4] tests/zc: move send size calc into do_test_inet_send
Date:   Mon,  5 Sep 2022 15:21:03 +0100
Message-Id: <e9e818b93fd3c0f969ebf1c4a0869edaadb161dd.1662387423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662387423.git.asml.silence@gmail.com>
References: <cover.1662387423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 8714b6f..0a8531e 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -238,7 +238,7 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     bool fixed_buf, struct sockaddr_storage *addr,
-			     size_t send_size, bool cork, bool mix_register,
+			     bool small_send, bool cork, bool mix_register,
 			     int buf_idx, bool force_async)
 {
 	const unsigned zc_flags = 0;
@@ -246,13 +246,13 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	struct io_uring_cqe *cqe;
 	int nr_reqs = cork ? 5 : 1;
 	int i, ret, nr_cqes;
+	size_t send_size = small_send ? 137 : buffers_iov[buf_idx].iov_len;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
 	pid_t p;
 	int wstatus;
 
-	assert(send_size <= buffers_iov[buf_idx].iov_len);
 	memset(rx_buffer, 0, send_size);
 
 	for (i = 0; i < nr_reqs; i++) {
@@ -394,7 +394,7 @@ static int test_inet_send(struct io_uring *ring)
 		for (i = 0; i < 256; i++) {
 			bool fixed_buf = i & 1;
 			struct sockaddr_storage *addr_arg = (i & 2) ? &addr : NULL;
-			size_t size = (i & 4) ? 137 : 4096;
+			bool small_send = i & 4;
 			bool cork = i & 8;
 			bool mix_register = i & 16;
 			bool aligned = i & 32;
@@ -406,8 +406,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (large_buf) {
 				buf_idx = 2;
-				size = buffers_iov[buf_idx].iov_len;
-				if (!aligned || !tcp)
+				if (!aligned || !tcp || small_send)
 					continue;
 			}
 			if (!buffers_iov[buf_idx].iov_base)
@@ -420,7 +419,7 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
-						addr_arg, size, cork, mix_register,
+						addr_arg, small_send, cork, mix_register,
 						buf_idx, force_async);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
@@ -535,8 +534,8 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
-	buffers_iov[0].iov_base = tx_buffer;
-	buffers_iov[0].iov_len = 8192;
+	buffers_iov[0].iov_base = tx_buffer + 4096;
+	buffers_iov[0].iov_len = 4096;
 	buffers_iov[1].iov_base = tx_buffer + BUFFER_OFFSET;
 	buffers_iov[1].iov_len = 8192 - BUFFER_OFFSET - 13;
 
-- 
2.37.2

