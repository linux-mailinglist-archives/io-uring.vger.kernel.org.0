Return-Path: <io-uring+bounces-8530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DAAAEE560
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DE24189F2F2
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4584A29550F;
	Mon, 30 Jun 2025 17:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhiyggoP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6F8292B36
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751303360; cv=none; b=MnFA4lZ+ulAaCJ/SZBJL2/9v+JWjyOPBi+5UZ6YCeQLlEBIGF05BoifNO3e4vHJ93lWIWZBIzmdArA2j77UREL+OgiJ+90G2MyjFZm4Yp5vd6Jc2zjqLU+H14Kilcf5cMMFBT3krMJjb1tY/04EM2GBGOjy83wcmCtpQs5LNSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751303360; c=relaxed/simple;
	bh=G26g2UIyEc/oitwV1RetB36KP9ZHeiY6yLJsw7zCw2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP/wte6Qb/GIZ5iqrVVYQnzD1LKE3pLINMV/TO3ftgksL2rp6vxPKqbNUOKo2jO2KBSMZRh1Pkhz4u154kjx8cNZg/C4SvpOt0KYeVMwD1fCvxhNzdn65lMvtt527ukc/wwBwuiO8JIgR7T8s6JK33Fm9JArKajnScvr6HS/VLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FhiyggoP; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2363497cc4dso38440475ad.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751303355; x=1751908155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZunOjnpAALZB4MJDUbVxdEP/daSoC2m2ct8rTkoXemE=;
        b=FhiyggoPwSRgOJtGkTTgtAiuyNwNgaDuVXXJN4QzqierwaHTZxw60s8ZDO1tR4Qh4u
         xmhIqrDcFphWeHnQDDuFjE5/eRnW8qbN/Y9MqFs/G5ti45f2T90L0eo0STzqkrz7Khm9
         oEI0fxeGPQCeeS8fwBaMzzYFcBJg4odmIZMvJrHyD45+3hhKpP+Jyx+GC8p0cdv8PK/o
         jR6Y1IlZZqby3SRRnI2OXpyq9sJSkgTBlXZm3Q55+3abclpVtA3a+eVOe2xsdyMGs4C2
         w60g71DyOPODv9V67cKBoSYOI6FHrVqjjzQ89CZrKqxcHe74v34gz8j2vM69ggS36Roj
         xZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751303355; x=1751908155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZunOjnpAALZB4MJDUbVxdEP/daSoC2m2ct8rTkoXemE=;
        b=VD97E1cnlPZ8lpWsZ35tZYpSw0g1wyVI18pjFuw8J8lk1n8Sq+hlJrQq0YF+Y5gcBJ
         0Ntkef+pdRIUw7t9CXfjz1/eUf6TO47SIq8jyyQdlxu5Map/bpoYgJt0Q/szFersZxGp
         NXj2zhQOQfbaai6gJTL8S1UiN0/lFnNPmXaMz7OHXWw0BTn5DjMlNVsTp/J0ve2CKF4f
         gILob1X2jWig9A1r20LkQAclJiCD06fDLWBk3dO4Gf5U2luSBAzey6csbr4ipJoTXFis
         OiLOJZfu1VwFZUoZNjSR1T8zp3ArhYxkAdMxaXifNhOlbM9J+lBB5+Z6pxeX1YTyAW5F
         djhQ==
X-Gm-Message-State: AOJu0YzHibfx5lGfdAnHtjdGIpOkY2TBKJYYKC225cvgFZLYE7dKkQ/e
	csTQFFdUzQ+OYqu3GwSjMCPEAMuwCldR7rEpK7FVY8HBXBCxrWIANXF63ss/ykLq
X-Gm-Gg: ASbGncsMKFTTmJ7NughmN0iDgi1tQ34LblJqXpniiTnSPmUM7r54048yXMx0fqwX2Qg
	XUtbYT0A6q/bB26eIbto74Px9cuxDfs+tISl+2Qx+KE9HfKwNVxvdg3MyYfKlN7Gx4jsJGF+DDZ
	ypf+fmmk3FflrXrPwlBtvG+lrzvsuIAXjHCvv0mjOfybBQ2I3W9q97dd9ErD1WRtX0lcq0RNqbB
	Js/Lqz8TaG83TL3++oCDoEc1+OwKSU1QR3c6aI5Lfr4cPzPXHeFqMWD32xbmhSKvQ5Paadxa/U1
	kmjY5R8JMSGZH2snxjsAIbck628K6DwHBnhfeQ4UFLAfcw==
X-Google-Smtp-Source: AGHT+IEt2sncbX4h9H5sF09a3DhBCYT8KRmX00eN42+OkVnCudF+PtlfBM3GV9xDPOV+uoWzbLC1vQ==
X-Received: by 2002:a17:902:c94c:b0:225:abd2:5e4b with SMTP id d9443c01a7336-23ac3afd0d2mr237125035ad.16.1751303354448;
        Mon, 30 Jun 2025 10:09:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f2239sm89182395ad.81.2025.06.30.10.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 10:09:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 2/2] tests: add a tx timestamp test
Date: Mon, 30 Jun 2025 18:10:31 +0100
Message-ID: <2fb900775605e04f6a29563fbf4cee9e96c679e6.1751303417.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751303417.git.asml.silence@gmail.com>
References: <cover.1751303417.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test for tx timestamping io_uring API.

https://lore.kernel.org/all/cover.1750065793.git.asml.silence@gmail.com/

The test itself is just an adapted version of txtimestamp.c
kernel selftest.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile    |   1 +
 test/timestamp.c | 373 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 374 insertions(+)
 create mode 100644 test/timestamp.c

diff --git a/test/Makefile b/test/Makefile
index ee09f5a8..99b272d7 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -249,6 +249,7 @@ test_srcs := \
 	xattr.c \
 	zcrx.c \
 	vec-regbuf.c \
+	timestamp.c \
 	# EOL
 
 # Please keep this list sorted alphabetically.
diff --git a/test/timestamp.c b/test/timestamp.c
new file mode 100644
index 00000000..98180557
--- /dev/null
+++ b/test/timestamp.c
@@ -0,0 +1,373 @@
+#include <arpa/inet.h>
+#include <error.h>
+#include <errno.h>
+#include <inttypes.h>
+#include <linux/errqueue.h>
+#include <linux/ipv6.h>
+#include <linux/net_tstamp.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/udp.h>
+#include <netinet/tcp.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <time.h>
+#include <unistd.h>
+#include <assert.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#ifndef SCM_TS_OPT_ID
+/* It's generally 81 except for a few selected archs. Jens requested it
+ * to be set here, please report if the test fails.
+ */
+#define SCM_TS_OPT_ID 81
+#endif
+
+static const int cfg_payload_len = 10;
+static uint16_t dest_port = 9000;
+static uint32_t ts_opt_id = 81;
+static bool cfg_use_cmsg_opt_id = false;
+static char buffer[128];
+static const bool verbose = false;
+
+static struct sockaddr_in6 daddr6;
+
+static int saved_tskey = -1;
+static int saved_tskey_type = -1;
+
+struct ctx {
+	int family;
+	int proto;
+	int report_opt;
+	int num_pkts;
+};
+
+static int validate_key(int tskey, int tstype, struct ctx *ctx)
+{
+	int stepsize;
+
+	/* compare key for each subsequent request
+	 * must only test for one type, the first one requested
+	 */
+	if (saved_tskey == -1 || cfg_use_cmsg_opt_id)
+		saved_tskey_type = tstype;
+	else if (saved_tskey_type != tstype)
+		return 0;
+
+	stepsize = ctx->proto == SOCK_STREAM ? cfg_payload_len : 1;
+	stepsize = cfg_use_cmsg_opt_id ? 0 : stepsize;
+	if (tskey != saved_tskey + stepsize) {
+		fprintf(stderr, "ERROR: key %d, expected %d\n",
+				tskey, saved_tskey + stepsize);
+		return -EINVAL;
+	}
+
+	saved_tskey = tskey;
+	return 0;
+}
+
+static int test_prep_sock(int family, int proto, unsigned report_opt)
+{
+	int ipproto = proto == SOCK_STREAM ? IPPROTO_TCP : IPPROTO_UDP;
+	unsigned int sock_opt;
+	int fd, val = 1;
+
+	fd = socket(family, proto, ipproto);
+	if (fd < 0)
+		error(1, errno, "socket");
+
+	if (proto == SOCK_STREAM) {
+		if (setsockopt(fd, IPPROTO_TCP, TCP_NODELAY,
+			       (char*) &val, sizeof(val)))
+			error(1, 0, "setsockopt no nagle");
+
+		if (connect(fd, (void *) &daddr6, sizeof(daddr6)))
+			error(1, errno, "connect ipv6");
+	}
+
+	sock_opt = SOF_TIMESTAMPING_SOFTWARE |
+		   SOF_TIMESTAMPING_OPT_CMSG |
+		   SOF_TIMESTAMPING_OPT_ID;
+	sock_opt |= report_opt;
+	sock_opt |= SOF_TIMESTAMPING_OPT_TSONLY;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING,
+		       (char *) &sock_opt, sizeof(sock_opt)))
+		error(1, 0, "setsockopt timestamping");
+
+	return fd;
+}
+
+#define MAX_PACKETS 32
+
+struct send_req {
+	struct msghdr msg;
+	struct iovec iov;
+	char control[CMSG_SPACE(sizeof(uint32_t))];
+};
+
+static void queue_ts_cmd(struct io_uring *ring, int fd)
+{
+	struct io_uring_sqe *sqe;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, NULL, 0, 0);
+	sqe->cmd_op = SOCKET_URING_OP_TX_TIMESTAMP;
+	sqe->user_data = 43;
+}
+
+static void queue_send(struct io_uring *ring, int fd, void *buf, struct send_req *r,
+			int proto)
+{
+	struct io_uring_sqe *sqe;
+
+	r->iov.iov_base = buf;
+	r->iov.iov_len = cfg_payload_len;
+
+	memset(&r->msg, 0, sizeof(r->msg));
+	r->msg.msg_iov = &r->iov;
+	r->msg.msg_iovlen = 1;
+	if (proto == SOCK_STREAM) {
+		r->msg.msg_name = (void *)&daddr6;
+		r->msg.msg_namelen = sizeof(daddr6);
+	}
+
+	if (cfg_use_cmsg_opt_id) {
+		struct cmsghdr *cmsg;
+
+		memset(r->control, 0, sizeof(r->control));
+		r->msg.msg_control = r->control;
+		r->msg.msg_controllen = CMSG_SPACE(sizeof(uint32_t));
+
+		cmsg = CMSG_FIRSTHDR(&r->msg);
+		cmsg->cmsg_level = SOL_SOCKET;
+		cmsg->cmsg_type = SCM_TS_OPT_ID;
+		cmsg->cmsg_len = CMSG_LEN(sizeof(uint32_t));
+
+		*((uint32_t *)CMSG_DATA(cmsg)) = ts_opt_id;
+		saved_tskey = ts_opt_id;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_sendmsg(sqe, fd, &r->msg, 0);
+	sqe->user_data = 0;
+}
+
+static const char *get_tstype_name(int tstype)
+{
+	if (tstype == SCM_TSTAMP_SCHED)
+		return "ENQ";
+	if (tstype == SCM_TSTAMP_SND)
+		return "SND";
+	if (tstype == SCM_TSTAMP_ACK)
+		return "ACK";
+	return "unknown";
+}
+
+static int do_test(struct ctx *ctx)
+{
+	struct send_req reqs[MAX_PACKETS];
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	unsigned long head;
+	int cqes_seen = 0;
+	int i, fd, ret;
+	int ts_expected = 0, ts_got = 0;
+
+	ts_expected += !!(ctx->report_opt & SOF_TIMESTAMPING_TX_SCHED);
+	ts_expected += !!(ctx->report_opt & SOF_TIMESTAMPING_TX_SOFTWARE);
+	ts_expected += !!(ctx->report_opt & SOF_TIMESTAMPING_TX_ACK);
+
+	ret = t_create_ring(32, &ring, IORING_SETUP_CQE32);
+	if (ret == T_SETUP_SKIP)
+		return T_EXIT_SKIP;
+	else if (ret)
+		t_error(1, ret, "queue init\n");
+
+	assert(ctx->num_pkts <= MAX_PACKETS);
+
+	fd = test_prep_sock(ctx->family, ctx->proto, ctx->report_opt);
+	if (fd < 0)
+		t_error(1, fd, "can't create socket\n");
+
+	memset(buffer, 'a', cfg_payload_len);
+	saved_tskey = -1;
+
+	if (cfg_use_cmsg_opt_id)
+		saved_tskey = ts_opt_id;
+
+	for (i =  0; i < ctx->num_pkts; i++) {
+		queue_send(&ring, fd, buffer, &reqs[i], ctx->proto);
+		ret = io_uring_submit(&ring);
+		if (ret != 1)
+			t_error(1, ret, "submit failed");
+
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret || cqe->res != cfg_payload_len) {
+			fprintf(stderr, "wait send cqe, %d %d, expected %d\n",
+				ret, cqe->res, cfg_payload_len);
+			return T_EXIT_FAIL;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	usleep(200000);
+
+	queue_ts_cmd(&ring, fd);
+	ret = io_uring_submit(&ring);
+	if (ret != 1)
+		t_error(1, ret, "submit failed");
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe failed %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	io_uring_for_each_cqe(&ring, head, cqe) {
+		struct io_timespec *ts;
+		int tskey, tstype;
+		bool hwts;
+
+		cqes_seen++;
+
+		if (!(cqe->flags & IORING_CQE_F_MORE)) {
+			if (cqe->res == -EINVAL || cqe->res == -EOPNOTSUPP)
+				return T_EXIT_SKIP;
+			if (cqe->res)
+				t_error(1, 0, "failed cqe %i", cqe->res);
+			break;
+		}
+
+		ts = (void *)(cqe + 1);
+		tstype = cqe->flags >> IORING_TIMESTAMP_TYPE_SHIFT;
+		tskey = cqe->res;
+		hwts = cqe->flags & IORING_CQE_F_TSTAMP_HW;
+
+		ts_got++;
+		if (verbose)
+			fprintf(stderr, "ts: key %x, type %i (%s), is hw %i, sec %lu, nsec %lu\n",
+				tskey, tstype, get_tstype_name(tstype), hwts,
+				(unsigned long)ts->tv_sec,
+				(unsigned long)ts->tv_nsec);
+
+		ret = validate_key(tskey, tstype, ctx);
+		if (ret)
+			return T_EXIT_FAIL;
+	}
+
+	if (ts_got != ts_expected) {
+		fprintf(stderr, "expected %i timestamps, got %i\n",
+			ts_expected, ts_got);
+		return -EINVAL;
+	}
+
+	close(fd);
+	io_uring_cq_advance(&ring, cqes_seen);
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
+
+static void resolve_hostname(const char *name, int port)
+{
+	memset(&daddr6, 0, sizeof(daddr6));
+	daddr6.sin6_family = AF_INET6;
+	daddr6.sin6_port = htons(port);
+	if (inet_pton(AF_INET6, name, &daddr6.sin6_addr) != 1)
+		t_error(1, 0, "ipv6 parse error: %s", name);
+}
+
+static void do_listen(int family, int type, void *addr, int alen)
+{
+	int fd;
+
+	fd = socket(family, type, 0);
+	if (fd == -1)
+		error(1, errno, "socket rx");
+
+	if (bind(fd, addr, alen))
+		error(1, errno, "bind rx");
+
+	if (type == SOCK_STREAM && listen(fd, 10))
+		error(1, errno, "listen rx");
+
+	/* leave fd open, will be closed on process exit.
+	 * this enables connect() to succeed and avoids icmp replies
+	 */
+}
+
+static int do_main(int family, int proto)
+{
+	struct ctx ctx;
+	int ret;
+
+	ctx.num_pkts = 1;
+	ctx.family = family;
+	ctx.proto = proto;
+
+	if (verbose)
+		fprintf(stderr, "test SND\n");
+	ctx.report_opt = SOF_TIMESTAMPING_TX_SOFTWARE;
+	ret = do_test(&ctx);
+	if (ret) {
+		if (ret == T_EXIT_SKIP)
+			fprintf(stderr, "no timestamp cmd, skip\n");
+		return ret;
+	}
+
+	if (verbose)
+		fprintf(stderr, "test ENQ\n");
+	ctx.report_opt = SOF_TIMESTAMPING_TX_SCHED;
+	ret = do_test(&ctx);
+	if (ret)
+		return T_EXIT_FAIL;
+
+	if (verbose)
+		fprintf(stderr, "test ENQ + SND\n");
+	ctx.report_opt = SOF_TIMESTAMPING_TX_SCHED | SOF_TIMESTAMPING_TX_SOFTWARE;
+	ret = do_test(&ctx);
+	if (ret)
+		return T_EXIT_FAIL;
+
+	if (proto == SOCK_STREAM) {
+		if (verbose)
+			fprintf(stderr, "test ACK\n");
+		ctx.report_opt = SOF_TIMESTAMPING_TX_ACK;
+		ret = do_test(&ctx);
+		if (ret)
+			return T_EXIT_FAIL;
+
+		if (verbose)
+			fprintf(stderr, "test SND + ACK\n");
+		ctx.report_opt = SOF_TIMESTAMPING_TX_SOFTWARE |
+				  SOF_TIMESTAMPING_TX_ACK;
+		ret = do_test(&ctx);
+		if (ret)
+			return T_EXIT_FAIL;
+
+		if (verbose)
+			fprintf(stderr, "test ENQ + SND + ACK\n");
+		ctx.report_opt = SOF_TIMESTAMPING_TX_SCHED |
+				  SOF_TIMESTAMPING_TX_SOFTWARE |
+				  SOF_TIMESTAMPING_TX_ACK;
+		ret = do_test(&ctx);
+		if (ret)
+			return T_EXIT_FAIL;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	const char *hostname = "::1";
+
+	resolve_hostname(hostname, dest_port);
+	do_listen(PF_INET6, SOCK_STREAM, &daddr6, sizeof(daddr6));
+	return do_main(PF_INET6, SOCK_STREAM);
+}
-- 
2.49.0


