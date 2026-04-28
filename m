Return-Path: <io-uring+bounces-13165-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHEaJV308GnUbQEAu9opvQ
	(envelope-from <io-uring+bounces-13165-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 19:54:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3184748A3D7
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 19:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 65B093033AAA
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50C72451060;
	Tue, 28 Apr 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="guVqxSzh"
X-Original-To: io-uring@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF08B450902
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398713; cv=none; b=b/MWth/AbJfCahLUSf+CZ3+SNnSXgG+0LOni3Fv8JKK7bZlWTW3QkINSr/YFj/OsAKodfhml3d+Mac4+o1TachhzADhCl1rYg+OLY1Y4UlZLXtYNxqNNVtcnTwB+htnN+7UzruyfIfkgHnlL4FLum1Xs/3EWoxZxSjlA8Gk0ois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398713; c=relaxed/simple;
	bh=eDqNHvMjMCCfhHrRctWkRRY8LOuOq1ldKu8zEZ0Bf+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDO70zPkn9rb60xhlztAn3u1GPYhG13MKZClOxwW4SuDsfvtSIV33TCta41oaJVUFq7fuyD74muUispCOrkn+PXJr1quJ2s97R8sBUIZBy4eXIUUPJcZxHvYO+MhYL/ii9UcKkt1KLjwrZInoV0wtvX94eakBZ/+8nDjxztonfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=guVqxSzh; arc=none smtp.client-ip=195.121.94.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: ea401a27-432a-11f1-8a9e-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id ea401a27-432a-11f1-8a9e-005056ab378f;
	Tue, 28 Apr 2026 19:51:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=rlU/JIk+hJwSw/A8PF9iW2EbbrCOIQ1gz040uJI6hHI=;
	b=guVqxSzhkzNN9TUUIMAopWmLuToTADj9qrpI7XwN8CiiU8iJ4F7kOBMgptwMQ8tdZKAmF+oqgbmeI
	 QAUzWp8Y+bkjs/IJUbGeMObda5aysl9Fpis9mCD6BUI2qrv8PdSB4TnQURpLf5syRH46dxtp6f0qQq
	 lonQdTzI0HsUnfQI6FKkbC5KUJ+otVwAKBr75I8UnVle5dJw3fRD/pU8EypbqLIw8mIkXL3KDNmpEx
	 mgwHhGHvF/4ZnE4g9yRCvw0PBazB3VHtP1LrCB39xldo2aCnL6x/zM8T783pkGh7frhCC43Kbluy1i
	 IkOVU7ND0UPH0xtNHZ3TicsY+FuMlyg==
X-KPN-MID: 33|XYALgN2CzSLAKwGuvXzQt5/gMsMFjRJ7JC/m4LtV9I1033UcFLulCyFgGW/+8tT
 gQF4OFHY4JvGTBtXG+RDG7XlatdfHj/x+JgkClJxqD8g=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|3HpaWLzlAfQmJH7mU1utHDRG2EW3gK78wcUoydhqAznoBGwB/xPPmr2d8OEAwrs
 xCPhxytR5W8XeOn0ZE16TXQ==
Received: from daedalus.home (unknown [178.227.109.38])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id e9795b76-432a-11f1-b8eb-005056ab7584;
	Tue, 28 Apr 2026 19:51:42 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Kees Cook <kees@kernel.org>
Cc: Simon Horman <horms@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrei Vagin <avagin@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Charlie Mirabile <cmirabil@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 2/2] selftest: Add tests for useful handling of LSM denials on SCM_RIGHTS
Date: Tue, 28 Apr 2026 19:51:25 +0200
Message-ID: <20260428175125.2705296-3-jkoolstra@xs4all.nl>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428175125.2705296-1-jkoolstra@xs4all.nl>
References: <20260428175125.2705296-1-jkoolstra@xs4all.nl>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3184748A3D7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13165-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,amacapital.net,chromium.org,xs4all.nl,redhat.com,gmail.com,virtuozzo.com,cyphar.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[xs4all.nl];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jkoolstra@xs4all.nl,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[xs4all.nl:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,xs4all.nl:email,xs4all.nl:dkim,xs4all.nl:mid,test_scm_rights_smack.sh:url]

Tests SCM_RIGHTS fd passing using Smack LSM blocking in combination with
the MSG_RIGHTS_FILTER flag.

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 .../net/af_unix/lsm_blocking/helper.h         |  37 ++++
 .../net/af_unix/lsm_blocking/receiver.c       | 187 ++++++++++++++++++
 .../net/af_unix/lsm_blocking/sender.c         | 126 ++++++++++++
 .../lsm_blocking/test_scm_rights_smack.sh     | 172 ++++++++++++++++
 4 files changed, 522 insertions(+)
 create mode 100644 tools/testing/selftests/net/af_unix/lsm_blocking/helper.h
 create mode 100644 tools/testing/selftests/net/af_unix/lsm_blocking/receiver.c
 create mode 100644 tools/testing/selftests/net/af_unix/lsm_blocking/sender.c
 create mode 100644 tools/testing/selftests/net/af_unix/lsm_blocking/test_scm_rights_smack.sh

diff --git a/tools/testing/selftests/net/af_unix/lsm_blocking/helper.h b/tools/testing/selftests/net/af_unix/lsm_blocking/helper.h
new file mode 100644
index 000000000000..e827560ee78d
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/lsm_blocking/helper.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <unistd.h>
+#include <fcntl.h>
+
+#define MSG_RIGHTS_DENIAL 0x200000
+#define MSG_RIGHTS_FILTER 0x400000
+
+#define CMSG_IS_SCM_RIGHTS(cmsg) ({		\
+	typeof(cmsg) _cmsg = (cmsg);		\
+	_cmsg &&				\
+	_cmsg->cmsg_level == SOL_SOCKET &&	\
+	_cmsg->cmsg_type == SCM_RIGHTS;		\
+})
+
+#define MIN(a, b) ({ \
+	typeof(a) _a = (a); \
+	typeof(b) _b = (b); \
+	_a < _b ? _a : _b; \
+})
+
+#define MAX_FDS 10
+
+static inline int read_current_label(char *label, size_t size)
+{
+	int fd = open("/proc/self/attr/current", O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	ssize_t r = read(fd, label, size - 1);
+	close(fd);
+	if (r <= 0)
+		return r;
+
+	label[r] = '\0';
+
+	return 0;
+}
diff --git a/tools/testing/selftests/net/af_unix/lsm_blocking/receiver.c b/tools/testing/selftests/net/af_unix/lsm_blocking/receiver.c
new file mode 100644
index 000000000000..f5af9dcddc22
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/lsm_blocking/receiver.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * receiver.c - Receive a file descriptor over a Unix domain socket via SCM_RIGHTS
+ *
+ * Usage: ./receiver <socket_path>
+ *
+ * Listens on the given Unix socket path, accepts a connection, and
+ * attempts to receive file descriptors via SCM_RIGHTS. Reports
+ * whether the fds were delivered or blocked.
+ *
+ * Used for testing LSM (Smack) blocking of fd passing.
+ */
+
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/xattr.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+
+#include "helper.h"
+
+#define RECV_LOG(fmt, ...) printf("receiver: " fmt, ##__VA_ARGS__)
+#define RECV_ERR(fmt, ...) fprintf(stderr, "receiver: " fmt, ##__VA_ARGS__)
+
+static int recv_fds(int sock, int *fds)
+{
+	char buf[1];
+	char ctrl[CMSG_SPACE(MAX_FDS * sizeof(int))];
+
+	struct iovec iov = {
+		.iov_base = buf,
+		.iov_len  = sizeof(buf),
+	};
+	struct msghdr msg = {
+		.msg_iov        = &iov,
+		.msg_iovlen     = 1,
+		.msg_control    = ctrl,
+		.msg_controllen = sizeof(ctrl),
+	};
+
+	ssize_t bytes_read = recvmsg(sock, &msg, MSG_RIGHTS_FILTER);
+	if (bytes_read < 0) {
+		perror("receiver: recvmsg");
+		return -1;
+	}
+	if (bytes_read == 0) {
+		RECV_ERR("connection closed, no data received\n");
+		return -1;
+	}
+
+	if (msg.msg_flags & MSG_RIGHTS_DENIAL)
+		RECV_LOG("MSG_RIGHTS_DENIAL set - some fds were blocked by the LSM!\n");
+
+	struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
+	if (!CMSG_IS_SCM_RIGHTS(cmsg)) {
+		RECV_ERR("no SCM_RIGHTS in control message\n");
+		return -1;
+	}
+
+	int num_fd_slots = (cmsg->cmsg_len - CMSG_LEN(0)) / sizeof(int);
+	memcpy(fds, CMSG_DATA(cmsg), num_fd_slots  * sizeof(int));
+
+	RECV_LOG("got %d fd slots:", num_fd_slots);
+	for (int i = 0; i < num_fd_slots ; i++)
+		printf(" %d", fds[i]);
+	putchar('\n');
+
+	return num_fd_slots;
+}
+
+static inline int print_current_label(void)
+{
+	char label[256];
+	if (!read_current_label(label, sizeof(label))) {
+		RECV_LOG("running with Smack label '%s'\n", label);
+		return 0;
+	}
+	return -1;
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <socket_path>\n", argv[0]);
+		return -1;
+	}
+
+	if (print_current_label()) {
+		RECV_ERR("cannot read process Smack label");
+		return -1;
+	}
+
+	int listen_sock = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (listen_sock < 0) {
+		perror("receiver: socket");
+		return -1;
+	}
+
+	struct sockaddr_un addr = {};
+	addr.sun_family = AF_UNIX;
+	strncpy(addr.sun_path, argv[1], sizeof(addr.sun_path) - 1);
+
+	/* Remove any stale socket file */
+	unlink(argv[1]);
+
+	if (bind(listen_sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
+		perror("receiver: bind");
+		return -1;
+	}
+
+	if (listen(listen_sock, 1) < 0) {
+		perror("receiver: listen");
+		return -1;
+	}
+
+	RECV_LOG("listening on '%s'\n", argv[1]);
+
+	int conn_sock = accept(listen_sock, NULL, NULL);
+	if (conn_sock < 0) {
+		perror("receiver: accept");
+		return -1;
+	}
+
+	RECV_LOG("connection accepted\n");
+
+	/* Try to receive the fds */
+	int fds[MAX_FDS];
+	int num_fds = recv_fds(conn_sock, fds);
+	if (num_fds < 0)
+		goto out_sock;
+
+	/* Try to use the received fds -- read and print their contents */
+	RECV_LOG("attempting to read from received fds...\n");
+	int i;
+	for (i = 0; i < num_fds; ++i) {
+		char readbuf[256];
+
+		if (fds[i] < 0) {
+			RECV_LOG("fd in position %i blocked\n", i);
+			continue;
+		} else if (fds[i] == 0) {
+			RECV_LOG("bad fd in position %i\n", i);
+			goto out_recv;
+		}
+
+		ssize_t n = read(fds[i], readbuf, sizeof(readbuf) - 1);
+		if (n < 0) {
+			perror("receiver: read from received fd");
+			goto out_recv;
+		}
+
+		readbuf[n] = '\0';
+		RECV_LOG("read %zd bytes from fd at position %i: '%s'\n", n, i, readbuf);
+	}
+
+	RECV_LOG("final result:\n");
+	for (int j = 0; j < num_fds; ++j) {
+		if (fds[j] < 0) {
+			printf("BLOCKED");
+		} else {
+			printf("PASSED");
+			close(fds[j]);
+		}
+		putchar(' ');
+	}
+
+	close(conn_sock);
+	close(listen_sock);
+	unlink(argv[1]);
+	return 0;
+
+out_recv:
+	for (int j = 0; j < num_fds; ++j) {
+		if (fds[j] > 0)
+			close(fds[j]);
+	}
+
+out_sock:
+	close(conn_sock);
+	close(listen_sock);
+	unlink(argv[1]);
+	return -1;
+}
diff --git a/tools/testing/selftests/net/af_unix/lsm_blocking/sender.c b/tools/testing/selftests/net/af_unix/lsm_blocking/sender.c
new file mode 100644
index 000000000000..b1c76d23b8bd
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/lsm_blocking/sender.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * sender.c - Send file descriptors over a Unix domain socket via SCM_RIGHTS
+ *
+ * Usage: ./sender <socket_path> <file_to_send> [<file_to_send>...]
+ *
+ * Opens the specified files and sends their fds to a receiver connected
+ * on the given Unix socket path. Used for testing LSM blocking of fd
+ * passing.
+ */
+
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <unistd.h>
+#include <string.h>
+#include <stdio.h>
+#include <fcntl.h>
+
+#include "helper.h"
+
+#define SEND_LOG(fmt, ...) fprintf(stdout, "sender: " fmt, ##__VA_ARGS__)
+#define SEND_ERR(fmt, ...) fprintf(stderr, "sender: " fmt, ##__VA_ARGS__)
+
+static int send_fds(int sock, int *fds, int num_fds)
+{
+	if (num_fds > MAX_FDS)
+		return -1;
+
+	char buf[1] = { 'X' };
+	char ctrl[CMSG_SPACE(MAX_FDS * sizeof(int))] = { 0 };
+
+	struct iovec iov = {
+		.iov_base = buf,
+		.iov_len  = sizeof(buf),
+	};
+	struct msghdr msg = {
+		.msg_iov        = &iov,
+		.msg_iovlen     = 1,
+		.msg_control    = ctrl,
+		.msg_controllen = CMSG_SPACE(num_fds * sizeof(int)),
+	};
+
+	struct cmsghdr *cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_SOCKET;
+	cmsg->cmsg_type  = SCM_RIGHTS;
+	cmsg->cmsg_len   = CMSG_LEN(num_fds * sizeof(int));
+	memcpy(CMSG_DATA(cmsg), fds, num_fds * sizeof(int));
+
+	ssize_t bytes_send = sendmsg(sock, &msg, 0);
+	if (bytes_send < 0) {
+		perror("sender: sendmsg");
+		return -1;
+	}
+
+	return 0;
+}
+
+static inline int print_current_label(void)
+{
+	char label[256];
+	if (!read_current_label(label, sizeof(label))) {
+		SEND_LOG("running with Smack label '%s'\n", label);
+		return 0;
+	}
+	return -1;
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc < 3 || argc > 2 + MAX_FDS) {
+		fprintf(stderr, "Usage: %s <socket_path> <file_to_send> [<file_to_send>...]\\n",
+			argv[0]);
+		fprintf(stderr, "Up to a maximum of %d files", MAX_FDS);
+		return -1;
+	}
+
+	if (print_current_label()) {
+		SEND_ERR("cannot read process Smack label");
+		return -1;
+	}
+
+	int sock = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (sock < 0) {
+		perror("sender: socket");
+		return -1;
+	}
+
+	struct sockaddr_un addr = {};
+	addr.sun_family = AF_UNIX;
+	strncpy(addr.sun_path, argv[1], sizeof(addr.sun_path) - 1);
+
+	if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
+		perror("sender: connect");
+		goto out_sock;
+	}
+
+	SEND_LOG("connected to '%s'\n", argv[1]);
+
+	int num_files = argc - 2;
+	int fds[MAX_FDS];
+	int i;
+	for (i = 0; i < num_files; i++) {
+		fds[i] = open(argv[2 + i], O_RDONLY);
+		if (fds[i] < 0) {
+			perror("sender: open file");
+			goto out_opened;
+		}
+		SEND_LOG("opened '%s' as fd %d\n", argv[2 + i], fds[i]);
+	}
+
+	if (send_fds(sock, fds, num_files) < 0)
+		goto out_opened;
+
+	SEND_LOG("fds successfully sent:");
+	for (int j = 0; j < num_files; j++)
+		printf(" %d", fds[j]);
+	putchar('\n');
+
+out_opened:
+	for (int j = 0; j < i; j++)
+		close(fds[j]);
+out_sock:
+	close(sock);
+	return -1;
+}
diff --git a/tools/testing/selftests/net/af_unix/lsm_blocking/test_scm_rights_smack.sh b/tools/testing/selftests/net/af_unix/lsm_blocking/test_scm_rights_smack.sh
new file mode 100644
index 000000000000..76fcfdd2cd4a
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/lsm_blocking/test_scm_rights_smack.sh
@@ -0,0 +1,172 @@
+# SPDX-License-Identifier: GPL-2.0
+
+#
+# test_scm_rights_smack.sh - Test SCM_RIGHTS fd passing using Smack LSM blocking
+#
+# Must be run as root on a kernel with Smack enabled (security=smack).
+# Requires: capsh (libcap), setfattr/getfattr (attr)
+#
+# We use the following Smack labels:
+#   "Sender"   - label for the sending process
+#   "Receiver" - label for the receiving process
+#   "SecretX"   - labels for the files being passed
+#
+# Socket communication (Sender <-> Receiver) is always allowed.
+# The test controls whether Receiver can access "SecretX"-labeled fds.
+#
+
+
+readonly SOCK="/tmp/scm_test.sock"
+readonly TESTFILE1="/tmp/scm_test_secret_1"
+readonly TESTFILE2="/tmp/scm_test_secret_2"
+readonly SENDER="./sender"
+readonly RECEIVER="./receiver"
+
+set -e
+
+run_tests() {
+
+	preflight
+	setup
+
+	run_test "TEST 1" \
+		"Receiver should NOT have access to Secret1." \
+		"Receiver Secret1 ---
+Receiver Secret2 ---" \
+		"$TESTFILE1" \
+		"BLOCKED"
+
+	run_test "TEST 2" \
+		"Receiver should have access to Secret1." \
+		"Receiver Secret1 r--
+Receiver Secret2 ---" \
+		"$TESTFILE1" \
+		"PASSED"
+
+	run_test "TEST 3" \
+		"Receiver should have access to Secret2, but NOT Secret1." \
+		"Receiver Secret1 ---
+Receiver Secret2 r--" \
+		"$TESTFILE1 $TESTFILE2" \
+		"BLOCKED PASSED"
+}
+
+run_test() {
+	local name="$1"
+	local description="$2"
+	local rules="$3"
+	local files="$4"
+	local expected="$5"
+
+	echo ""
+	echo "$name: $description"
+	echo "Rules:"
+	echo "$rules"
+	echo "Expected: $expected"
+	echo ""
+
+	while IFS= read -r rule; do
+		[ -n "$rule" ] && echo "$rule" > /sys/fs/smackfs/load2
+	done <<< "$rules"
+
+	local output status last_line
+	output=$(send_fds "$SOCK" $files)
+	status=$?
+	echo "$output"
+	last_line=$(echo "$output" | tail -n 1 | xargs)
+
+	if [ "$status" -ne 0 ]; then
+		echo "TEST FAILED: receiver returned $status"
+		return 1
+	fi
+
+	if [[ "$last_line" == "$expected" ]]; then
+		echo "TEST PASSED: outcome was $expected as expected"
+		return 0
+	else
+		echo "TEST FAILED: expected $expected, got '$last_line'"
+		return 1
+	fi
+}
+
+setup() {
+
+	printf "Secret 1" > "$TESTFILE1"
+	printf "Secret 2" > "$TESTFILE2"
+
+	setfattr -n security.SMACK64 -v "Secret1" "$TESTFILE1"
+	setfattr -n security.SMACK64 -v "Secret2" "$TESTFILE2"
+	setfattr -n security.SMACK64 -v "Tmp" /tmp
+
+	echo "Sender	Receiver	-w-" > /sys/fs/smackfs/load2
+	echo "Receiver	Sender		-w-" > /sys/fs/smackfs/load2
+	echo "Sender	Tmp 		rwx" > /sys/fs/smackfs/load2
+	echo "Receiver	Tmp		rwx" > /sys/fs/smackfs/load2
+	echo "Sender	Secret1		r--" > /sys/fs/smackfs/load2
+	echo "Sender	Secret2		r--" > /sys/fs/smackfs/load2
+}
+
+send_fds() {
+
+	local sk="$1"
+	shift
+	local files="$*"
+
+	(
+	    echo "Receiver" > /proc/self/attr/current
+	    exec capsh --drop=cap_mac_override,cap_mac_admin -- -c "$RECEIVER $sk"
+	) &
+	local recv_pid=$!
+	sleep 1
+
+	(
+	    echo "Sender" > /proc/self/attr/current
+	    exec capsh --drop=cap_mac_override,cap_mac_admin -- -c "$SENDER $sk $files"
+	) || true
+
+	local recv_status=0
+	wait "$recv_pid" || recv_status=$?
+
+	if [ "$recv_status" -ne 0 ]; then
+	    echo "receiver exited with $recv_status"
+	fi
+	return "$recv_status"
+}
+
+preflight() {
+
+	if [ "$(id -u)" -ne 0 ]; then
+	    echo "ERROR: must be run as root"
+	    exit 1
+	fi
+
+	if ! grep -q smack /sys/kernel/security/lsm 2>/dev/null; then
+	    echo "ERROR: Smack is not active"
+	    echo "  Check: cat /sys/kernel/security/lsm"
+	    echo "  Boot with: security=smack"
+	    exit 1
+	fi
+
+	if ! mountpoint -q /sys/fs/smackfs 2>/dev/null; then
+	    echo "Mounting smackfs..."
+	    mount -t smackfs smackfs /sys/fs/smackfs
+	fi
+
+	if ! command -v capsh &>/dev/null; then
+	    echo "ERROR: capsh not found (install libcap)"
+	    exit 1
+	fi
+
+	# Build the test programs if needed
+	if [ ! -x "$SENDER" ]; then
+	    echo "Building sender..."
+	    gcc -Wall -o sender sender.c
+	fi
+	if [ ! -x "$RECEIVER" ]; then
+	    echo "Building receiver..."
+	    gcc -Wall -o receiver receiver.c
+	fi
+
+}
+
+run_tests
-- 
2.54.0


