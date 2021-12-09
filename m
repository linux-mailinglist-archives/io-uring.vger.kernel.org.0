Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F1A46F403
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 20:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhLITiZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 14:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhLITiZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 14:38:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9610EC061746
        for <io-uring@vger.kernel.org>; Thu,  9 Dec 2021 11:34:51 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e128so7933473iof.1
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 11:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+huw3A945S2ldKVloliaX5/XQ2eodIqC5A1TBO1GTS8=;
        b=h1my0CFAHBEdBhiSndIOkNWZgSlL/sH36TCoOdXqTXsKUT8jkLlfCB33jGCWQXiJTn
         8p7x3d7BjG4e7yoV/zTwyqpXUuXwWwFFDUBo/SiaOIvPxiTxiZVtmKswzlDNXoHFFmhY
         PUHKBIJf9lwOmxLCC6dx372G7vr6ypTqYdXTZYSZyht9rTy26AVV4T5g4SFiBHdMZte/
         Whi5jpQaBzcVuxsuxGLrUkFmTjOmSTzowZLNo3Ynz6sJzxrK4q+0973RsGhA9LUi+vGN
         YHRMqhZEPdO/1rXZMNuUudaTruONYhlrLckv6zq2hj3krLCyC8Om5w0nbbbmBImYF4Rh
         EL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+huw3A945S2ldKVloliaX5/XQ2eodIqC5A1TBO1GTS8=;
        b=Qrv0wjP/jbn+4enmSoxctinQH6Ov09/4pUxty7FpsM2f8KXWcoJM8FzYoLYSq+MVe7
         bVvz+9SMK/5ZSRLr4ThLP2MJcvkRvJzXVWo/nqZzZT4g6MCEWsdHdaJKsQSKB/UTJXM6
         YRETGYtEh1reKNNvBFdGiYQjNCbU960NiYFD/qbJ9nPoz9w+vu8w6pdzvXOgnKYcKSOY
         XwbR1EoHz7cX249hgn2candXfmXyH830TWnZpBHFI9qmGOc6CqBD5BiuaVu35GFVgTNT
         eg7yC4WALFGgdSzaiBxkWJ+xSu9qx9IMPzi0VD40Vte0NIx9RSCP+RHunNnIBSWjrpJv
         1WrQ==
X-Gm-Message-State: AOAM530HjtPNqp2CQ/MRAPWPksmKukJus0mITlMLOcw+p5AcF8dvLyGW
        BX5VYnooieYh+RTwE+8q1k9W7Slw5OI=
X-Google-Smtp-Source: ABdhPJx/TE8moeiOhc2m4QLJ4V1G4zBX+023sFZNGEWN6jIKF7JCanmJ4/MH1qZrlSuVA4ksU6DvGg==
X-Received: by 2002:a05:6602:3314:: with SMTP id b20mr15841627ioz.214.1639078491024;
        Thu, 09 Dec 2021 11:34:51 -0800 (PST)
Received: from p51.localdomain (bras-base-mtrlpq4706w-grc-05-174-93-161-243.dsl.bell.ca. [174.93.161.243])
        by smtp.gmail.com with ESMTPSA id b8sm510780iow.2.2021.12.09.11.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 11:34:50 -0800 (PST)
Received: by p51.localdomain (Postfix, from userid 60092)
        id 0EF4011C58C9; Thu,  9 Dec 2021 14:34:57 -0500 (EST)
Date:   Thu, 9 Dec 2021 14:34:57 -0500
From:   jrun <darwinskernel@gmail.com>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
Subject: possible bug with unix sockets
Message-ID: <20211209193457.a3qdaxk6dwsi5xuf@p51>
References: <20211208190733.xazgugkuprosux6k@p51>
 <024aae30-1fdc-f51b-7744-9518a39cbb19@gmail.com>
 <20211209175636.oq6npmqf24h5hthi@p51>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hybwvhvekiqrsisl"
Content-Disposition: inline
In-Reply-To: <20211209175636.oq6npmqf24h5hthi@p51>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--hybwvhvekiqrsisl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Dec 09, 2021 at 12:56:36PM -0500, jrun wrote:
> On Thu, Dec 09, 2021 at 03:02:12PM +0000, Pavel Begunkov wrote:
> > 1) Anything in dmesg? Please when it got stuck (or what the symptoms are),
> > don't kill it but wait for 3 minutes and check dmesg again.
> >
> 
> nothing in dmesg!
> 
> > Or you to reduce the waiting time:
> > "echo 10 > /proc/sys/kernel/hung_task_timeout_secs"
> 
> oh, my kernel[mek] is missing that; rebuilding right now with
> `CONFIG_DETECT_HUNG_TASK=y`; will report back after reboot.
> 
> btw, enabled CONFIG_WQ_WATCHDOG=y for workqueue.watchdog_thresh; don't know if
> that would help too. let me know.

nothin!

> > 3) Have you tried normal accept (non-direct)?

hum, io_uring_prep_accept() also goes out for lunch.

wait a minute, i see something (BUG?):
all things equal, unix sockets fails but tcp socket works. i can investigate
further to see if it has to do with _abstract_ unix sockets. let me know.

to test, apply the attached patch to the origial repo in this thread.

> no, will try, but accept_direct worked for me before introducing pthread into
> the code. don't know if it matters.
> 
> > 4) Can try increase the max number io-wq workers exceeds the max number
> > of inflight requests? Increase RLIMIT_NPROC, E.g. set it to
> > RLIMIT_NPROC = nr_threads + max inflight requests.

i'm maxed out i think, doing this at the top of main anyway, main():

```
struct rlimit rlim = {0};
getrlimit(RLIMIT_NPROC, &rlim);
if (!(rlim.rlim_cur == RLIM_INFINITY) || !(rlim.rlim_max == RLIM_INFINITY)) {
	fprintf(stderr, "rlim.rlim_cur=%lu rlim.rlim_max=%lu\n",
		rlim.rlim_cur, rlim.rlim_max);
	rlim.rlim_cur = RLIM_INFINITY;
	rlim.rlim_max = RLIM_INFINITY;
	setrlimit(RLIMIT_NPROC, &rlim);
	perror("setrlimit");
	if (ret)
		exit(EX_SOFTWARE);
}
```


	- jrun

--hybwvhvekiqrsisl
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-try-with-tcp.patch"

From fd6c8c353c28a2c3de39847957661014b6142470 Mon Sep 17 00:00:00 2001
From: Paymon MARANDI <darwinskernel@gmail.com>
Date: Thu, 9 Dec 2021 14:30:19 -0500
Subject: [PATCH] try with tcp

---
 main.c | 106 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 68 insertions(+), 38 deletions(-)

diff --git a/main.c b/main.c
index cc14a89..bc2f21f 100644
--- a/main.c
+++ b/main.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include <net/if.h>
 #include <pthread.h>
+#include <sys/resource.h>
 
 #include <liburing.h>
 
@@ -156,9 +157,16 @@ static void q_accept(struct io_uring *ring, conn_info *conn_i)
 		sqe, conn_i->skf.mama,
 		(struct sockaddr *)&conn_i->skf.child.peer.addr,
 		&conn_i->skf.child.peer.addrlen, 0, conn_i->gbid);
+	/*
+	io_uring_prep_accept(
+		sqe, conn_i->skf.mama,
+		(struct sockaddr *)&conn_i->skf.child.peer.addr,
+		&conn_i->skf.child.peer.addrlen, 0);
+	*/
 	conn_i->state = ACCEPT;
 	io_uring_sqe_set_data(sqe, conn_i);
 
+	// sqe->flags |= IOSQE_IO_DRAIN;
 	// sqe->flags |= IOSQE_IO_LINK | IOSQE_IO_HARDLINK;
 	/* if (conn_i->reacts->recv.q) */
 	/*	conn_i->reacts->recv.q(ring, conn_i); */
@@ -377,8 +385,12 @@ static int conn_factory(conn_info **conns, struct io_uring *ring,
 		if ((conns[i]->provides_buf = tmpl.provides_buf))
 			conns[i]->reacts->buf.q(ring, conns[i]);
 	}
-	if (!tmpl.provides_buf)
+	if (!tmpl.provides_buf) {
+		for (int i = 0; i < max_conn; i++)
+			conns[i]->state = READY;
+
 		return ret;
+	}
 
 	unsigned head;
 	unsigned count = 0;
@@ -543,11 +555,11 @@ void *ctrlsock(void *name)
 		exit(EX_OSERR);
 
 	struct io_uring ring = { 0 };
-	/* struct io_uring_params p = { */
-	/*	.flags = IORING_SETUP_SQPOLL, */
-	/*	.sq_thread_idle = 2000, */
-	/* }; */
-	struct io_uring_params p = { 0 };
+	// struct io_uring_params p = { 0 };
+	 struct io_uring_params p = {
+		.flags = IORING_SETUP_SQPOLL,
+		.sq_thread_idle = 2000,
+	 };
 
 	ret = io_uring_queue_init_params(MAX_CONNECTIONS * 2, &ring, &p);
 	perrork(ret, "io_uring_queue_init_params::unix");
@@ -565,12 +577,13 @@ void *ctrlsock(void *name)
 	conn_info tmpl = {
 		.buf_len = 1024,
 		.buf_num_seg = 1,
-		.reacts = &reacts,
 		.provides_buf = true,
+		.reacts = &reacts,
 	};
 	conns[0] = &tmpl;
 	ret = conn_factory(conns, &ring, children_pool, unix_addr,
 			   MAX_CONNECTIONS);
+	perrork(ret, "conn_factory(unix)");
 	if (ret) {
 		fprintf(stderr, "%s::%s %s\n", "conn_factory", __func__,
 			strerror(ret));
@@ -584,8 +597,7 @@ void *ctrlsock(void *name)
 		exit(EX_OSERR);
 	}
 
-	for (int i=0; i<MAX_CONNECTIONS/2; i++)
-		conns[i]->reacts->accept.q(&ring, conns[i]);
+	conns[0]->reacts->accept.q(&ring, conns[0]);
 
 	fprintf(stderr, "accepting connections to @%s\n", (char *)name);
 
@@ -624,33 +636,29 @@ static void *wsub(void *data)
 	children_pool[0] = socket(args->addrstore.ss_family, SOCK_STREAM, 0);
 	/* shorthand */
 	__s32 mama = children_pool[0];
-	if (mama == -1) {
-		perror("sock");
+	perror("sock");
+	if (mama == -1)
 		exit(EX_OSERR);
-	}
 
 	int val = 1;
 	int ret = setsockopt(mama, SOL_SOCKET, SO_REUSEPORT | SO_REUSEADDR,
 			     &val, sizeof(val));
-	if (ret == -1) {
-		perror("setsockopt(wsub)");
+	perror("setsockopt(wsub)");
+	if (ret == -1)
 		exit(EX_OSERR);
-	}
 
 	int tcp_f = TCP_NODELAY | TCP_DEFER_ACCEPT;
 	ret = setsockopt(mama, IPPROTO_TCP, tcp_f, &val, sizeof(val));
-	if (ret == -1) {
-		perror("setsockopt(tcp_f)");
+	perror("setsockopt(tcp_f)");
+	if (ret == -1)
 		exit(EX_OSERR);
-	}
 
 	if (args->ipv6) {
 		ret = setsockopt(mama, IPPROTO_IP, IPV6_RECVPKTINFO, &val,
 				 sizeof(val));
-		if (ret == -1) {
-			perror("setsockopt(ipv6)");
+		perror("setsockopt(ipv6)");
+		if (ret == -1)
 			exit(EX_OSERR);
-		}
 		// "fe80::5b3e:1bc6:ac47:c5c4",
 		// wsub_addr->sin6.sin6_scope_id = if_nametoindex("enp0s31f6");
 		// wsub_addr.sin6_addr = inet_pton(in6addr_loopback);
@@ -667,27 +675,30 @@ static void *wsub(void *data)
 	}
 
 	// bind and listen
-	if (bind(mama, (struct sockaddr *)args->addr, sizeof(*args->addr)) <
-	    0) {
-		perror("bind(wsub)");
+	ret = bind(mama, (struct sockaddr *)args->addr, sizeof(*args->addr));
+	perror("bind(wsub)");
+	if (ret)
 		exit(EX_OSERR);
-	}
-	if (listen(mama, BACKLOG) < 0) {
-		perror("listen(wsub)");
+	ret = listen(mama, BACKLOG);
+	perror("listen(wsub)");
+	if (ret)
 		exit(EX_OSERR);
-	}
 	fprintf(stderr, "wsub listening for connections on port: %d\n",
 		args->port);
 
 	struct io_uring_params p;
 	struct io_uring ring;
 
-	memset(&p, 0, sizeof(p));
+	// struct io_uring_params p = { 0 };
+	 struct io_uring_params param = {
+		.flags = IORING_SETUP_SQPOLL,
+		.sq_thread_idle = 2000,
+	 };
 
-	if (io_uring_queue_init_params(2048, &ring, &p) < 0) {
-		perror("io_uring_queue_init_params(wsub)");
+	ret = io_uring_queue_init_params(MAX_CONNECTIONS * 2, &ring, &param);
+	perrork(ret, "io_uring_queue_init_params::unix");
+	if (ret < 0)
 		exit(EX_OSERR);
-	}
 
 	reactions reacts = {
 		.accept = { .dq = dq_accept, .q = q_accept },
@@ -702,16 +713,23 @@ static void *wsub(void *data)
 		.reacts = &reacts,
 	};
 	conns[0] = &tmpl;
-	// io_uring_prep_provide_buffers(sqe_wsub, bufs, MAX_MESSAGE_LEN,
-	// BUFFERS_COUNT, group_id, 0);
-
 	ret = conn_factory(conns, &ring, children_pool, args->addr,
 			   MAX_CONNECTIONS);
+	perrork(ret, "conn_factory(wsub)");
 	if (ret) {
 		fprintf(stderr, "ret = %d\n", ret);
-		perror("conn_factory(wsub)");
 		exit(EX_OSERR);
 	}
+	ret = io_uring_register_files(&ring, children_pool,
+				      MAX_CONNECTIONS + 1);
+	if (ret) {
+		fprintf(stderr, "%s::%s %s\n", "io_uring_register_files",
+			__func__, strerror(-ret));
+		exit(EX_OSERR);
+	}
+
+	conns[0]->reacts->accept.q(&ring, conns[0]);
+
 	event_loop(&ring, conns);
 
 	close(mama);
@@ -732,6 +750,18 @@ static void *wsub(void *data)
 int main(int argc, char **argv)
 {
 	rval_t ret = EX_OK;
+	struct rlimit rlim = {0};
+	getrlimit(RLIMIT_NPROC, &rlim);
+	if (!(rlim.rlim_cur == RLIM_INFINITY) || !(rlim.rlim_max == RLIM_INFINITY)) {
+		fprintf(stderr, "rlim.rlim_cur=%lu rlim.rlim_max=%lu\n",
+			rlim.rlim_cur, rlim.rlim_max);
+		rlim.rlim_cur = RLIM_INFINITY;
+		rlim.rlim_max = RLIM_INFINITY;
+		ret = setrlimit(RLIMIT_NPROC, &rlim);
+		perror("setrlimit");
+		if (ret)
+			exit(EX_SOFTWARE);
+	}
 
 	struct wsub_args wsub_args = {
 		.port = 8002,
@@ -767,19 +797,19 @@ int main(int argc, char **argv)
 	if (!exec_name)
 		return EX_OSERR;
 
+	/*
 	ret = pthread_create(&ctrl_thread, NULL, ctrlsock, (void *)(exec_name));
 	if (ret) {
 		perror("pthread_create(ctrlsock)");
 		return EX_OSERR;
 	}
-	/*
+	*/
 	pthread_t wsub_thread;
 	ret = pthread_create(&wsub_thread, NULL, wsub, (void *)(&wsub_args));
 	if (ret) {
 		perror("pthread_create(wsub)");
 		return EX_OSERR;
 	}
-	*/
 
 	pthread_exit(0);
 	return ret;
-- 
2.34.1


--hybwvhvekiqrsisl--
