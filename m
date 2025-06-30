Return-Path: <io-uring+bounces-8521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F13AEE3CF
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:13:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5C12189FAEA
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:10:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABCA28FAB9;
	Mon, 30 Jun 2025 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLTv24wr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B19292B25
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751299673; cv=none; b=JGxqDWpwRpRc9rLBfKLBh7v5AiFCUr/I8Ho5FWQjsyx2Q8ATexkg76JZ3dcQvwYd75yb70inOi0WcwUtOpvF2KrOu9iT8zAFjLfbZETUK0pv2s5KF0qYuLtsgYWEdmt5B/oOJR550xppXlGDPXoXhRYTI+oM01ox7SEPB8RI/yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751299673; c=relaxed/simple;
	bh=IWILpAt47nyXD8ITwcCiCE0mKzshSrgmEagMdaTXUYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyjXIQbI5i8Dx/47ka/XXWlIZ9OOhTN5tJyMR+o6iplINkoVu1Iz0VhypwN2/mku2S8zdqnMOd6zyfQTt+XiRwmqA8PT0T0MBisFPGnsznYZFTUhv/og+OBhtdWWOlqC4B6komA5MpAZRcMWE25mwYkx96ibn5Eo0Y2fAbuXjA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BLTv24wr; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-73c17c770a7so2978354b3a.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751299670; x=1751904470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ay1BsECCTijfz6On+j85TIwV38gmTkVnrmjvVgwtbH4=;
        b=BLTv24wrIX1wNs6rMzlMQ3fZhvbS4kJD13qv4q2jjyiIF4CtsyxALz6PTJ3DK+1Ga1
         uQu11Yj8Pwt1GBVfeuETpRxtDuza/lHIJTrWBK9KwwHJ4l0LwUI60dYB6rP1vFgVfNJf
         cIVbIFq9hVgWYWDBgxfP9ZIZWGwA7cEx7Ds5Uzikcy1KJ6e6Z3s2RFd0GXkzlKjLUXrg
         lgDghYaE+kCJXDijg445iotlXy7vNFOe67b9FiG5yrF6tiMelzG8B30ylFjcw307uwCI
         zbn1NzO6uMFgNIKaJmPBbr4tik7c0mXYan1sD8PT3LJSEvacgalZAijA/+fUpVfAxPtk
         Iz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751299670; x=1751904470;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ay1BsECCTijfz6On+j85TIwV38gmTkVnrmjvVgwtbH4=;
        b=UGKf4wEFLamIJvyHmY77PW/sYFAhipodURx/z517Z0+7O1LoJMUeO+ulR3ASqDw4Uh
         aUyqgGKhp2opxZukn1zvt+tqOTGx2KsxfJYBHBwY7MV2oknQ76dlqCeZwb7ufEJApxzt
         UhsND/0dVAeFMGY28bq8nAD1sMJZOKAgjgUPohHzV9RA+sZicblyWlsFoezQKIso9EAK
         UnVOYKk94Vs+p2/m+BmhH9wGXDL8XbgMG76B9QNzhmrD0IEPXlEFUEeitV7B4TXuJiVj
         Oj/C1cGQ3j8qC/UjYuOgR62igc139vdmSBDgf24+F+enP8CSTtF1Vnd5Xwu8eUq7WIq5
         /Hkg==
X-Gm-Message-State: AOJu0Yy9q1H7yPM+xfRSKrv1a9t2cSuPo/0j9uvrr44ioAMG//fOyAm+
	08oQvdVhumrrNVpHEpxoQxXzsmMSKGoRATczgiFLva5ANA2RZcqijB2ycCFqNs23
X-Gm-Gg: ASbGncukdMGSBPB192daXDtkvI0TyirDtWyt2An7dmZUDItVVaAYHBfk3xpMaaAVB8q
	AzXugCCtsaCZ2u14fE9NlFB8ylFJJN61OMNzzkxdJ7WuvJzQr57D6FXW3CsSBIRAej6s9DpSw6s
	vgnZ7sNtaLZnEdXC7m+qCNvNMHxbD3aZynGWg3iJHj1cUTnRRTGAnhy9aJWwOp7w7YcOgrY1RPC
	DgsuPvBCIL/1T7v9BYOq06hhq8oENifcJHyKcjloWL46GzmYzRyw1HAK/Jb6cz+rXVmefaiTkdw
	Qb/D4Stln0D7rvKh24SHhpLoemFdg7DUyJ+qqBZkZ1sUuw==
X-Google-Smtp-Source: AGHT+IFf/Ll1E9QnkIXDq04jUDl9m/Al69s2OXYScDv21TnV8E/4r8K9o/uFZ37IsRBqIistNQy3nw==
X-Received: by 2002:a05:6a00:14c2:b0:748:2d1d:f7b7 with SMTP id d2e1a72fcca58-74af6f7a470mr18231879b3a.21.1751299670323;
        Mon, 30 Jun 2025 09:07:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e320fc3bsm7577870a12.75.2025.06.30.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 09:07:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/2] tests: timestamp example
Date: Mon, 30 Jun 2025 17:09:10 +0100
Message-ID: <4ba2daee657f4ff41fe4bcae1f75bc0ad7079d6d.1751299730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751299730.git.asml.silence@gmail.com>
References: <cover.1751299730.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile    |   1 +
 test/timestamp.c | 376 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 377 insertions(+)
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
index 00000000..47c82d9a
--- /dev/null
+++ b/test/timestamp.c
@@ -0,0 +1,376 @@
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
+#define SCM_TS_OPT_ID 0
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
+	const char *hostname;
+
+	if (SCM_TS_OPT_ID == 0) {
+		fprintf(stderr, "no SCM_TS_OPT_ID, skip\n");
+		return T_EXIT_SKIP;
+	}
+
+	hostname = "::1";
+	resolve_hostname(hostname, dest_port);
+	do_listen(PF_INET6, SOCK_STREAM, &daddr6, sizeof(daddr6));
+	return do_main(PF_INET6, SOCK_STREAM);
+}
-- 
2.49.0


