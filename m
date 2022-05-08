Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1490951EEA3
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbiEHPl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiEHPlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:41:55 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2096.outbound.protection.outlook.com [40.92.53.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91439E08C
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:38:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQph/u5Wajp0q2H+uNt/XhvDqdmXhTuVMNy7CWQBZBZcswnknCTaAeAa1osxSRYoS5HQ8e0qhKay1JIs66Oz0UKjD3ON+InaPugIzBWK33BRvuLD3h36r0TCzMXNCfslolJPCrIJAmjxVzdEUjqDzgTkY6lR8TZrGnLsyqGZNJxIJdOEjYrXIB6xY3qwW3K2P8tZhFOXKpGoStWFlyJWLSD56WJldAbnuEoiekVTAZkHWxejqQ2lpUIQSizxMy8rMfJ68d/UrmLTIOdvNmxahd7wa4nAG5Ctwrd8la28FHkIOghgFCjxf9Rclo/PeT0uz6RlEWVVem6ormgbZZnlhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SNo7VpwdkzEaOlsl0AyRshC/t/ymJnTRXUpGnoHmt0=;
 b=P84O8j0fRlvBqOjMDcBAm0pFrrfX2HmmXFyE2VHN8tX/b5VLiq5cH1uMiS5Wu2pQF89HgantWRoJUYKEi2U07cLeoQvjE+2vtOBTGeKXNQNEqrW3wvnWRcGOftH10Qr/ZLzFrLJo3CLOc2ka0pRsegAJGRaYdMhPs3HQfjYj+oIpfTTQ5dNbZ/f2ABZHLbZep0k9RyqbPCGoxmrW5x6Dx39IcrScQ3OIxpCDHQSURzMMmY8up/06YcKQHmJK/IW34pcGNJWI9yi6VY5fqh3xMjkHtmsr1SkVfbzcPQiYwryfboA9L/00Yy19DBSaHJibft43VP4+0C3+wmrz0AlDHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SNo7VpwdkzEaOlsl0AyRshC/t/ymJnTRXUpGnoHmt0=;
 b=mnpabaxth/SKFB31yE1QSI2ue9Xs7r/xC2qlPkBc/+qx7PIMeEnwRz/WF3oyt27+3tKlBvRCWt8XMX8oylvWFQ3/jnOuViCa+inBbI8/T3suJ0rPgxhG9tr4F4BGYongspC0Bf1rCXaJKy3d28xu0m+H6LPQMmiqgX9gNelSB6DW68p1Mw53wBEHx7ghdk+77o4DgHcC0Fh9MBFfBwH1tt6WbRhe2W5578/wLMUxYBM0nArI18tSw3q23R/VSaG+DsKVN4e2+UEL62YummsXyVPzwxDsATE5YuLxvB0ztCmMNBQVmKwsWGpMGtcMlw+HqJBcsADDF/Sb5zag6CsOoQ==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by PSAPR01MB3910.apcprd01.prod.exchangelabs.com
 (2603:1096:301:17::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:37:59 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:37:59 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/4] io_uring: implement multishot mode for accept
Date:   Sun,  8 May 2022 23:37:47 +0800
Message-ID: <SG2PR01MB2411A0DC1DB76D0CEF00D328FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153747.6184-1-haoxu.linux@gmail.com>
References: <20220508153747.6184-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [kk6D0JQgcehsctJ1e1bTRRLMv7h8WvrS]
X-ClientProxiedBy: HK2PR0302CA0005.apcprd03.prod.outlook.com
 (2603:1096:202::15) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153747.6184-5-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30b6de00-eae4-4b80-a8bd-08da3108bb31
X-MS-TrafficTypeDiagnostic: PSAPR01MB3910:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DglhtveFDf4wgMZ+IhVWgyOfXc5ug2/FdzNBIeQY5zdRZATcrStR6qMC/V8E7eizyo3r3fvJnVMnIW9Iw4BPyCjbANFsiyr0bllxev8o0vLgWLigxcpFvX88/ZEfWCFLDrLKwqa/j+HCFvsHS3HQ5r5faNHZWcREZN2WUIDoZbVUb4u52H9grTGn48vZDHeAy/ZFmIaloVn6tpj7DpVRuMBdWbU1C0fudEvPz4RwhDjTUBHGFQ0e0cUqabmb5CyT0NaAeGNGBPQbttWqxjSqekQ+CHtxpKBAqh3yiWrtursFMbbgdko8wpXyN1McgkSaR0BaJU6AIpnH4mCivsO3CYUBFnqnFqRk/Ebq6iHHU0cJ+FaG4d9pIyOKhibkAQgnwriwICWZQLtAKSU+D/LBgNPnIsM0/HJQk6wIcIO7jfQhQ0Y3UOu/pygkhaP4rnLBDrERAvHiuQoHF6Nimlr1f8wOD+MW/Oo2a76DTBlsFmBJAFjg1kiBC5bOLrf2Ql3psjBvMjukDH9U/Wf8fLQ2jPXWS+NS0ek04JGkLIpevqAMrS+go+MXkoJjYjkkICNIJ8dErI/IjPc2aWFySpNA/5CefrM9RYzQ2tJ1QkbLLW2XjT22Kf+8eg8Ja0CJ+So7
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S8gAmNZnDRjtNK6LBUPJmqVfxQvNz8kUShjr2EOZiZ8tCbetIZ2rwrBI1zBB?=
 =?us-ascii?Q?3S73M1yNVFRDn6yh7nCsYPYALrxdTsHgem9YG8RDRhcfXNSG29JGyL5TetzP?=
 =?us-ascii?Q?uDajN3g+6J9VpSgwTXNVoqZKiF5HspiTBa4gH7oJ9lOOkyHpoJclSegSwwX3?=
 =?us-ascii?Q?xVcF2Xnyvpr+DNnrtNKL2Zj/H33l4ONx+D67zKO6NvRKk4jyF8e3WCJl0Ob2?=
 =?us-ascii?Q?dMMkIAbyYJmVSrqoPQ517YuI6MHlbQ2NxJX+e74xIET3zuyZF+1w/x+xM9m/?=
 =?us-ascii?Q?o+BeFw41iBqOjcv0uZs8JcsYmjmZTPmBe7JlP77Mt3q4XxERpvRACRVzZPey?=
 =?us-ascii?Q?tTDNH+jKmLshNdN+vhFC2QD2LdV7hoSeoXMtECKPTsvs+dJBwUTR743LpyVY?=
 =?us-ascii?Q?UOtIVTQvAyWJHQQHox5LS03CGAtzt3AaF+ESwV7gJBEE0FlOY13axDVc1v2+?=
 =?us-ascii?Q?FjOEAbN05yr9KtFNs+a6YpvR/KHoORlg5kf+4rG75pZatPrBTkjPr19J66je?=
 =?us-ascii?Q?gI2J9hPdbJqExh0+201t/Qt+kQjUvvKC84kYqIGxZ3XCIOtLzAD5dj1iZjG4?=
 =?us-ascii?Q?wbYAxaSvN+B6Kj+LAzVPxb1oHJZ9I0Ke+54V26tJdbg49AwhSPJuSc/gYKTi?=
 =?us-ascii?Q?nYdVGeiLgw4STTNIJGLArh6v9iXdDETQIPE042OE1mz8LDJYwYHCGtJvdwNX?=
 =?us-ascii?Q?tIWNz63or60fqlO/u5CJBdBsjO3rncBXjX0aXWaSNY7jiIfleFKddycDj0xI?=
 =?us-ascii?Q?TRIxUPyBh4t2QZ/AxpQm6kVAJ9EtdYGxqCSPjERz9T7SqXsM3HQZEMZyqC/w?=
 =?us-ascii?Q?4YFvViQFt+TEle9B4I00kZNwhMduYkUHNX5uDPj7qnKp/PcTwrEoJGmF2f8+?=
 =?us-ascii?Q?Iil2iUolAezy6+gN1ct7B/pe7ezNuUaSBXITZlKf5hLdUpp5OJVvKPxPglp8?=
 =?us-ascii?Q?vnagHK8OARDATCWpNdcWP/p203m7Q972T1R04wGrYpHOWhHn4jknjhtZAfsl?=
 =?us-ascii?Q?G3taVd6pnvgPuX7Fyd9CaWeqbatvkr4BTjZe3Mj7dRIoocUrLVMjEMR3o4Yt?=
 =?us-ascii?Q?E00V/D908fy/+gql0QQgtTYtMoKBc0fuCyMOJZBAvkPj/eOwpkZ3LZ1nz8yr?=
 =?us-ascii?Q?jpsEzHLf8uZXmb7KKho8WvcLAyOngYWoGQ+F0tmSQNJUEkGDbWcYnHVwhJd5?=
 =?us-ascii?Q?Ki4j1md9um5z88iQ/TDz0DUoPctyoaLL1QZqJzwCPNAm1zc5NVAplvER3o+/?=
 =?us-ascii?Q?694SiBaqPRR2VzB9CDJkjwfvNTyJYUJkdFxQ9gOrUVMugTmN5iIur0Sn04mk?=
 =?us-ascii?Q?rvP3n3WtZUQ4/jAt1ScDbCy2+A9bGgyIcgJLFK2LSEjTAd5hvUGXQ9PmXpCp?=
 =?us-ascii?Q?2NVkOWrzBCSpPLUCdHg8FFJwbyPe5jvmog7aUDsjXOuGghuQgBKN46+d2V/w?=
 =?us-ascii?Q?pa8JZv3wcfev8ECTzFKfEk4o0P4YJ0tasND9xAacFkc2jjDI/vO4Rw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b6de00-eae4-4b80-a8bd-08da3108bb31
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:37:59.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR01MB3910
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,FORGED_GMAIL_RCVD,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Refactor io_accept() to support multishot mode.

theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userpsace) --> accept inline
                              ^                 |
                              |-----------------|
    - multishot:
             add accept sqe(userspace) --> accept inline
                                              ^     |
                                              |--*--|

    we do accept repeatedly in * place until get EAGAIN

  2) when connections come in at a low pressure
    similar thing like 1), we reduce a lot of userspace-kernel context
    switch and useless vfs_poll()

tests:
Did some tests, which goes in this way:

  server    client(multiple)
  accept    connect
  read      write
  write     read
  close     close

Basically, raise up a number of clients(on same machine with server) to
connect to the server, and then write some data to it, the server will
write those data back to the client after it receives them, and then
close the connection after write return. Then the client will read the
data and then close the connection. Here I test 10000 clients connect
one server, data size 128 bytes. And each client has a go routine for
it, so they come to the server in short time.
test 20 times before/after this patchset, time spent:(unit cycle, which
is the return value of clock())
before:
  1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
  +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
  +1934226+1914385)/20.0 = 1927633.75
after:
  1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
  +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
  +1871324+1940803)/20.0 = 1894750.45

(1927633.75 - 1894750.45) / 1927633.75 = 1.65%

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0d12af04cd1..f21172913336 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1146,6 +1146,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.poll_exclusive		= 1,
+		.ioprio			= 1,	/* used for flags */
 	},
 	[IORING_OP_ASYNC_CANCEL] = {
 		.audit_skip		= 1,
@@ -5706,6 +5707,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
+	unsigned flags;
 
 	if (sqe->len || sqe->buf_index)
 		return -EINVAL;
@@ -5714,19 +5716,26 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	flags = READ_ONCE(sqe->ioprio);
+	if (flags & ~IORING_ACCEPT_MULTISHOT)
+		return -EINVAL;
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
+	if (accept->file_slot && ((accept->flags & SOCK_CLOEXEC) ||
+	   flags & IORING_ACCEPT_MULTISHOT))
 		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
 		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+	if (flags & IORING_ACCEPT_MULTISHOT)
+		req->flags |= REQ_F_APOLL_MULTISHOT;
 	return 0;
 }
 
 static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -5734,6 +5743,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5745,8 +5755,12 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock)
-			return -EAGAIN;
+		if (ret == -EAGAIN && force_nonblock) {
+			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
+			    IO_APOLL_MULTI_POLLED)
+				ret = 0;
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -5757,8 +5771,26 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_install_fixed_file(req, file, issue_flags,
 					    accept->file_slot - 1);
 	}
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
+
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		__io_req_complete(req, issue_flags, ret, 0);
+		return 0;
+	}
+	if (ret >= 0) {
+		bool filled;
+
+		spin_lock(&ctx->completion_lock);
+		filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
+					 IORING_CQE_F_MORE);
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		if (!filled)
+			return -ECANCELED;
+		io_cqring_ev_posted(ctx);
+		goto retry;
+	}
+
+	return ret;
 }
 
 static int io_connect_prep_async(struct io_kiocb *req)
-- 
2.25.1

