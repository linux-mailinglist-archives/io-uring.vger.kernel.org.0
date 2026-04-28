Return-Path: <io-uring+bounces-13164-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cG8mE7f78GmqbgEAu9opvQ
	(envelope-from <io-uring+bounces-13164-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 20:25:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B1148A9BC
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 20:25:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E020630B3554
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E7A45BD5A;
	Tue, 28 Apr 2026 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="XbBxUKv0"
X-Original-To: io-uring@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A9244E02A
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 17:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777398704; cv=none; b=jxBpWtzSeTFQQPFEyuqhUIQmDPaUYxUO3rvWdivQxkn3v3SBFCfU1YkUqqo/Bj9ofEchGE1wurYXpoUTp4ssZCuj5BKBEbtwxF8NTlVzy4wy40UTK9erzgzAZCet+UEb5KVglOUUd6HFmy6XJyozbVhdW640qmfbI3H1Tm46qCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777398704; c=relaxed/simple;
	bh=1UmJMm9HRJeSnlQaY2zWjpm3Ui9VzYhP8m4prCL+PvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5wDQrMLakBm6ktm09DfhdpcyPbrLWzNdfW/QydmnywLym3XZt6Q0OaIe6c/ZqPSMaWODXLjqU1zgaBUJL01DJxfhY/Nx2nqOQSrrxpL2uaKRCgHHHyFja89bd8ZJQkMSAxQQx5ioUKvyMeCwgIZkGeTMskeV6++o1cQyTqOH0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=XbBxUKv0; arc=none smtp.client-ip=195.121.94.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: e8c39887-432a-11f1-969c-005056abbe64
Received: from smtp.kpnmail.nl (unknown [10.31.155.40])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id e8c39887-432a-11f1-969c-005056abbe64;
	Tue, 28 Apr 2026 19:51:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=mime-version:message-id:date:subject:to:from;
	bh=Hri1BJ45KAE6FjU8p+59YL6JiRnX+I7ffuR09+bwJzo=;
	b=XbBxUKv0R+R/+kdoYXwmEP6PhKdWEJon6AXuxEMImO0IpjDDXZULohqT9C9+SNNmjYYQ2aJaddE9s
	 2ZJwussEs30Cjn56v1BNFp586vV3GoPLGb1KRvjm0H9cquVObDBpwDTLQzVM6pyf8/K2zwr+kryt9/
	 VSJ4nLIocjRR8YIXunEWjAaF9eTcOdV9oVc+/PNyBhAxEFtoQmXeiwP0sInfjZnm4dO2+kNelHrHXA
	 hkOyIUW5EMNHnK5ksYUgs1cZUulcNlTUbCng8gH5M5X5GxiWgRw2U8/fHN0/zGM6yqizhzcMWGmrGL
	 LD22j/Gi3J4VLUkBGYlQF2MOtDhGSOA==
X-KPN-MID: 33|uU90Q5grKwi4IjgGrOdGshf+Clec16IlOKKUhI54Hpy6ftY/1gqFoYHHhNGdeVB
 OP8vwiEpSboa7GUaYNWDrzq04nRg4W+z8JXGiHdBqGDk=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|lYyLqNP5FA+hQdKBZ+APWpwwf/NktYR8S8hfN0D74eoUlPcDj4McY8QUbFsXtb4
 fqbuob7s4wiGezkcxsmSS9A==
Received: from daedalus.home (unknown [178.227.109.38])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id e81759cd-432a-11f1-b8eb-005056ab7584;
	Tue, 28 Apr 2026 19:51:39 +0200 (CEST)
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
Subject: [RFC PATCH 1/2] net: af_unix: Useful handling of LSM denials on SCM_RIGHTS
Date: Tue, 28 Apr 2026 19:51:24 +0200
Message-ID: <20260428175125.2705296-2-jkoolstra@xs4all.nl>
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
X-Rspamd-Queue-Id: 88B1148A9BC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[xs4all.nl];
	FREEMAIL_CC(0.00)[kernel.org,amacapital.net,chromium.org,xs4all.nl,redhat.com,gmail.com,virtuozzo.com,cyphar.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13164-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jkoolstra@xs4all.nl,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[xs4all.nl:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[xs4all.nl:email,xs4all.nl:dkim,xs4all.nl:mid]

Right now if some LSM such as Smack denies an AF_UNIX socket peer to
receive an SCM_RIGHTS fd the SCM_RIGHTS fd array will be cut short at
that point, and MSG_CTRUNC is set on return of recvmsg(). This is
highly problematic behaviour, because it leaves the receiver
wondering what happened. As per man page MSG_CTRUNC is supposed to
indicate that the control buffer was sized too short, but suddenly
a permission error might result in the exact same flag being set.
Moreover, the receiver has no chance to determine how many fds got
originally sent and how many were suppressed.[1]

Add two MSG_* flags:
 - MSG_RIGHTS_DENIAL is set whenever any file is rejected by the LSM
   during recvmsg() of SCM_RIGHTS fds.
 - If MSG_RIGHTS_FILTER is passed as a flag to recvmsg(), the SCM_RIGHTS
   fd array is always passed in its full original size. However, any
   files rejected by the LSM are replaced in this array with -EPERM
   instead of an assigned fd, while keeping the original order. If the
   flag is not set, the original truncate behavior is used.

[1]: https://github.com/uapi-group/kernel-features#useful-handling-of-lsm-denials-on-scm_rights

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
---
 fs/file.c              | 21 ++++++++++++++++++---
 include/linux/file.h   |  4 +++-
 include/linux/socket.h |  3 +++
 include/net/scm.h      |  8 ++++----
 io_uring/openclose.c   |  2 +-
 kernel/pid.c           |  2 +-
 kernel/seccomp.c       |  2 +-
 net/compat.c           |  7 ++++---
 net/core/scm.c         | 11 ++++++-----
 9 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 2c81c0b162d0..cc33a1e77049 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1370,10 +1370,11 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
 }
 
 /**
- * receive_fd() - Install received file into file descriptor table
+ * receive_fd_msg() - Install received file into file descriptor table
  * @file: struct file that was received from another process
  * @ufd: __user pointer to write new fd number to
  * @o_flags: the O_* flags to apply to the new fd entry
+ * @msg_flags: the MSG_* flags to set for recvmsg(2)
  *
  * Installs a received file into the file descriptor table, with appropriate
  * checks and count updates. Optionally writes the fd number to userspace, if
@@ -1384,13 +1385,21 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
  *
  * Returns newly install fd or -ve on error.
  */
-int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
+int receive_fd_msg(struct file *file, int __user *ufd, unsigned int o_flags,
+	       unsigned int *msg_flags)
 {
 	int error;
 
 	error = security_file_receive(file);
-	if (error)
+	if (error) {
+		if (msg_flags)
+			*msg_flags |= MSG_RIGHTS_DENIAL;
+
+		if (ufd)
+			put_user(-EPERM, ufd);
+
 		return error;
+	}
 
 	FD_PREPARE(fdf, o_flags, file);
 	if (fdf.err)
@@ -1406,6 +1415,12 @@ int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 	__receive_sock(fd_prepare_file(fdf));
 	return fd_publish(fdf);
 }
+EXPORT_SYMBOL_GPL(receive_fd_msg);
+
+int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return receive_fd_msg(file, NULL, o_flags, NULL);
+}
 EXPORT_SYMBOL_GPL(receive_fd);
 
 int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
diff --git a/include/linux/file.h b/include/linux/file.h
index 27484b444d31..38f022d997a6 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -118,7 +118,9 @@ DEFINE_FREE(fput, struct file *, if (!IS_ERR_OR_NULL(_T)) fput(_T))
 
 extern void fd_install(unsigned int fd, struct file *file);
 
-int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags);
+int receive_fd_msg(struct file *file, int __user *ufd, unsigned int o_flags,
+		   unsigned int *msg_flags);
+int receive_fd(struct file *file, unsigned int o_flags);
 
 int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags);
 
diff --git a/include/linux/socket.h b/include/linux/socket.h
index ec4a0a025793..3809a8add2fc 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -342,6 +342,9 @@ struct ucred {
 					  * plain text and require encryption
 					  */
 
+#define MSG_RIGHTS_DENIAL 0x200000
+#define MSG_RIGHTS_FILTER 0x400000
+
 #define MSG_SOCK_DEVMEM 0x2000000	/* Receive devmem skbs as cmsg */
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
 #define MSG_SPLICE_PAGES 0x8000000	/* Splice the pages from the iterator in sendmsg() */
diff --git a/include/net/scm.h b/include/net/scm.h
index c52519669349..983efa952c8e 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -50,8 +50,8 @@ struct scm_cookie {
 #endif
 };
 
-void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
-void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
+void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm, int recv_flags);
+void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm, int recv_flags);
 int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
 void __scm_destroy(struct scm_cookie *scm);
 struct scm_fp_list *scm_fp_dup(struct scm_fp_list *fpl);
@@ -108,11 +108,11 @@ void scm_recv_unix(struct socket *sock, struct msghdr *msg,
 		   struct scm_cookie *scm, int flags);
 
 static inline int scm_recv_one_fd(struct file *f, int __user *ufd,
-				  unsigned int flags)
+				  unsigned int o_flags, unsigned int *msg_flags)
 {
 	if (!ufd)
 		return -EFAULT;
-	return receive_fd(f, ufd, flags);
+	return receive_fd_msg(f, ufd, o_flags, msg_flags);
 }
 
 #endif /* __LINUX_NET_SCM_H */
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index c71242915dad..1b6cb05b0e3d 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -308,7 +308,7 @@ int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	ifi = io_kiocb_to_cmd(req, struct io_fixed_install);
-	ret = receive_fd(req->file, NULL, ifi->o_flags);
+	ret = receive_fd(req->file, ifi->o_flags);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
diff --git a/kernel/pid.c b/kernel/pid.c
index fd5c2d4aa349..62af6874192d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -929,7 +929,7 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ret = receive_fd(file, NULL, O_CLOEXEC);
+	ret = receive_fd(file, O_CLOEXEC);
 	fput(file);
 
 	return ret;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 066909393c38..ad5ab16fe2b1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1130,7 +1130,7 @@ static void seccomp_handle_addfd(struct seccomp_kaddfd *addfd, struct seccomp_kn
 	 */
 	list_del_init(&addfd->list);
 	if (!addfd->setfd)
-		fd = receive_fd(addfd->file, NULL, addfd->flags);
+		fd = receive_fd(addfd->file, addfd->flags);
 	else
 		fd = receive_fd_replace(addfd->fd, addfd->file, addfd->flags);
 	addfd->ret = fd;
diff --git a/net/compat.c b/net/compat.c
index 2c9bd0edac99..056bce0927c4 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -287,18 +287,19 @@ static int scm_max_fds_compat(struct msghdr *msg)
 	return (msg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
 }
 
-void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
+void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm, int recv_flags)
 {
 	struct compat_cmsghdr __user *cm =
 		(struct compat_cmsghdr __user *)msg->msg_control_user;
 	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
+	bool filter_rights = recv_flags & MSG_RIGHTS_FILTER;
 	int fdmax = min_t(int, scm_max_fds_compat(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_COMPAT_DATA(cm);
 	int err = 0, i;
 
 	for (i = 0; i < fdmax; i++) {
-		err = scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
-		if (err < 0)
+		err = scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_flags, &msg->msg_flags);
+		if (err < 0 && !filter_rights)
 			break;
 	}
 
diff --git a/net/core/scm.c b/net/core/scm.c
index eec13f50ecaf..035329645d8f 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -351,10 +351,11 @@ static int scm_max_fds(struct msghdr *msg)
 	return (msg->msg_controllen - sizeof(struct cmsghdr)) / sizeof(int);
 }
 
-void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
+void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm, int recv_flags)
 {
 	struct cmsghdr __user *cm =
 		(__force struct cmsghdr __user *)msg->msg_control_user;
+	bool filter_rights = recv_flags & MSG_RIGHTS_FILTER;
 	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
 	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
 	int __user *cmsg_data = CMSG_USER_DATA(cm);
@@ -365,13 +366,13 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 		return;
 
 	if (msg->msg_flags & MSG_CMSG_COMPAT) {
-		scm_detach_fds_compat(msg, scm);
+		scm_detach_fds_compat(msg, scm, recv_flags);
 		return;
 	}
 
 	for (i = 0; i < fdmax; i++) {
-		err = scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
-		if (err < 0)
+		err = scm_recv_one_fd(scm->fp->fp[i], cmsg_data + i, o_flags, &msg->msg_flags);
+		if (err < 0 && !filter_rights)
 			break;
 	}
 
@@ -524,7 +525,7 @@ static bool __scm_recv_common(struct sock *sk, struct msghdr *msg,
 	scm_passec(sk, msg, scm);
 
 	if (scm->fp)
-		scm_detach_fds(msg, scm);
+		scm_detach_fds(msg, scm, flags);
 
 	return true;
 }
-- 
2.54.0


