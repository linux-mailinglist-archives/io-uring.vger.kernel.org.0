Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861C45BFCED
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIULYl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiIULYk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:24:40 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0881055B1
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n10so9280405wrw.12
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pKbMXg8Ue1DsGmilQ1piyQRsNo5PG/HHHa0idiyGZpw=;
        b=WGdMq5JkoKj/zpUqGvHldK3OqDYIFk6TQ4jITJDwTj65F2JdedFL6H+ppXsmI3wdWw
         q1SsUVD4MfRJ41DvFV+W/KHCUxuaLvGs0Yo6qGqrnOg3jHve3uEAJU5PAXr+ONRte+p5
         RdoNVx0R4WpZJgMR2D8LV+1BCyBz+YYFPWLQyIJRx24VIIs5dBdc04imEVjAdsqH12Ef
         r4S0wPcUOmDql2CXwKvesVWFISWft02tMtBfsMcM4o2QaMOFl9q+7eEvVbgEeJhSYYO5
         dqhTyXZixzxIpCPCX3ciqGJ6Y2CjsrqvDTlXL+bb63hNTxOuHueHuCToyJ0SJ2nVjuq9
         Ih3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pKbMXg8Ue1DsGmilQ1piyQRsNo5PG/HHHa0idiyGZpw=;
        b=0R91XFtu4XMCOiUM4X2S14JZLCJgPI3mKS2jlksIb+ncgq/mrJ2VObecsgPEO6Ljm5
         598Zt2ULKmmxGghETZ+d236WT0L2mopw6SUemXOl0ttJVLAJreZ3FspYGAo7cqWJzcIN
         gh8ObyxPTJXzX2AvZYqMsIr5MEt8YZ0lQsoiONLQ9YbATcGSK4VXX4BnN6vBqoAq6ThM
         uGPsKLlQUnBRhm9X66tMsPbg3DZgpeCq5AXPxAt9PaeSur6xIeekEXLXi4EJcLMMB+O8
         FIS0kNEGf9gr4igshsYIGbR9RoTGCeXyLxA0Dlu9RB354ZEzgKcreBHozoN4/qIn0pRi
         Q+fw==
X-Gm-Message-State: ACrzQf30cOPjUOkei/C56cUIH35bUH7isbGWHc2kDQ0c5COcA4m8Wi7i
        PgTXOXWGm8Xr/nYrkzZDobvKjVwwRws=
X-Google-Smtp-Source: AMsMyM50exdMmRVmoHx1Jam4obuf8yX/keN+rFxgcUxwwF1n6utss2DiGv1z//KwyCC7kzrXzRG93w==
X-Received: by 2002:a5d:4c4c:0:b0:22a:35bd:84a9 with SMTP id n12-20020a5d4c4c000000b0022a35bd84a9mr15981892wrt.103.1663759476000;
        Wed, 21 Sep 2022 04:24:36 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id bw25-20020a0560001f9900b0022ac1be009esm2467539wrb.16.2022.09.21.04.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:24:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/4] tests: add sendmsg_zc tests
Date:   Wed, 21 Sep 2022 12:21:58 +0100
Message-Id: <d698961d4bf8f0ab3bb7ad36b42c309c3395e0c2.1663759148.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663759148.git.asml.silence@gmail.com>
References: <cover.1663759148.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h |  1 +
 test/send-zerocopy.c            | 85 +++++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 972b179..92f29d9 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -213,6 +213,7 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
+	IORING_OP_SENDMSG_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index e34e0c1..80723de 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -44,6 +44,7 @@
 #define HOST	"127.0.0.1"
 #define HOSTV6	"::1"
 
+#define CORK_REQS 5
 #define RX_TAG 10000
 #define BUFFER_OFFSET 41
 
@@ -60,6 +61,7 @@ enum {
 
 static char *tx_buffer, *rx_buffer;
 static struct iovec buffers_iov[4];
+static bool has_sendmsg;
 
 static bool check_cq_empty(struct io_uring *ring)
 {
@@ -252,18 +254,27 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
 			     bool fixed_buf, struct sockaddr_storage *addr,
 			     bool cork, bool mix_register,
-			     int buf_idx, bool force_async)
+			     int buf_idx, bool force_async, bool use_sendmsg)
 {
+	struct iovec iov[CORK_REQS];
+	struct msghdr msghdr[CORK_REQS];
 	const unsigned zc_flags = 0;
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
-	int nr_reqs = cork ? 5 : 1;
-	int i, ret, nr_cqes;
+	int nr_reqs = cork ? CORK_REQS : 1;
+	int i, ret, nr_cqes, addr_len = 0;
 	size_t send_size = buffers_iov[buf_idx].iov_len;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
 	char *buf = buffers_iov[buf_idx].iov_base;
 
+	if (addr) {
+		sa_family_t fam = ((struct sockaddr_in *)addr)->sin_family;
+
+		addr_len = (fam == AF_INET) ? sizeof(struct sockaddr_in) :
+					      sizeof(struct sockaddr_in6);
+	}
+
 	memset(rx_buffer, 0, send_size);
 
 	for (i = 0; i < nr_reqs; i++) {
@@ -280,25 +291,35 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			cur_size = chunk_size_last;
 
 		sqe = io_uring_get_sqe(ring);
-		io_uring_prep_send_zc(sqe, sock_client, buf + i * chunk_size,
-				      cur_size, msg_flags, zc_flags);
-		sqe->user_data = i;
-
-		if (real_fixed_buf) {
-			sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
-			sqe->buf_index = buf_idx;
-		}
-		if (addr) {
-			sa_family_t fam = ((struct sockaddr_in *)addr)->sin_family;
-			int addr_len = fam == AF_INET ? sizeof(struct sockaddr_in) :
-							sizeof(struct sockaddr_in6);
 
-			io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)addr,
-						    addr_len);
+		if (!use_sendmsg) {
+			io_uring_prep_send_zc(sqe, sock_client, buf + i * chunk_size,
+					      cur_size, msg_flags, zc_flags);
+			if (real_fixed_buf) {
+				sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+				sqe->buf_index = buf_idx;
+			}
+			if (addr)
+				io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)addr,
+							    addr_len);
+		} else {
+			io_uring_prep_sendmsg(sqe, sock_client, &msghdr[i], msg_flags);
+			sqe->opcode = IORING_OP_SENDMSG_ZC;
+
+			memset(&msghdr[i], 0, sizeof(msghdr[i]));
+			iov[i].iov_len = cur_size;
+			iov[i].iov_base = buf + i * chunk_size;
+			msghdr[i].msg_iov = &iov[i];
+			msghdr[i].msg_iovlen = 1;
+			if (addr) {
+				msghdr[i].msg_name = addr;
+				msghdr[i].msg_namelen = addr_len;
+			}
 		}
+		sqe->user_data = i;
 		if (force_async)
 			sqe->flags |= IOSQE_ASYNC;
-		if (cork && i != nr_reqs - 1)
+		if (i != nr_reqs - 1)
 			sqe->flags |= IOSQE_IO_LINK;
 	}
 
@@ -346,7 +367,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		}
 		if ((cqe->flags & IORING_CQE_F_MORE) ==
 		    (cqe->flags & IORING_CQE_F_NOTIF)) {
-			fprintf(stderr, "unexpected cflags %i\n", cqe->flags);
+			fprintf(stderr, "unexpected cflags %i res %i\n",
+					cqe->flags, cqe->res);
 			return 1;
 		}
 		io_uring_cqe_seen(ring, cqe);
@@ -384,13 +406,14 @@ static int test_inet_send(struct io_uring *ring)
 			return 1;
 		}
 
-		for (i = 0; i < 128; i++) {
+		for (i = 0; i < 256; i++) {
 			int buf_flavour = i & 3;
 			bool fixed_buf = i & 4;
 			struct sockaddr_storage *addr_arg = (i & 8) ? &addr : NULL;
 			bool cork = i & 16;
 			bool mix_register = i & 32;
 			bool force_async = i & 64;
+			bool use_sendmsg = i & 128;
 
 			if (buf_flavour == BUF_T_LARGE && !tcp)
 				continue;
@@ -402,10 +425,12 @@ static int test_inet_send(struct io_uring *ring)
 				continue;
 			if (!client_connect && addr_arg == NULL)
 				continue;
+			if (use_sendmsg && (mix_register || fixed_buf || !has_sendmsg))
+				continue;
 
 			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
 						addr_arg, cork, mix_register,
-						buf_flavour, force_async);
+						buf_flavour, force_async, use_sendmsg);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
 					"cork %i\n",
@@ -492,6 +517,22 @@ static int test_async_addr(struct io_uring *ring)
 	return 0;
 }
 
+static bool io_check_zc_sendmsg(struct io_uring *ring)
+{
+	struct io_uring_probe *p;
+	int ret;
+
+	p = t_calloc(1, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	if (!p) {
+		fprintf(stderr, "probe allocation failed\n");
+		return false;
+	}
+	ret = io_uring_register_probe(ring, p, 256);
+	if (ret)
+		return false;
+	return p->ops_len > IORING_OP_SENDMSG_ZC;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -550,6 +591,8 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
+	has_sendmsg = io_check_zc_sendmsg(&ring);
+
 	ret = test_send_faults(&ring, sp[0], sp[1]);
 	if (ret) {
 		fprintf(stderr, "test_send_faults() failed\n");
-- 
2.37.2

