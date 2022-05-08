Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB3B51EEA8
	for <lists+io-uring@lfdr.de>; Sun,  8 May 2022 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiEHPgO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 May 2022 11:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiEHPgK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 May 2022 11:36:10 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2048.outbound.protection.outlook.com [40.92.107.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642AFE03D
        for <io-uring@vger.kernel.org>; Sun,  8 May 2022 08:32:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY6fzfycZ5q5ESvrLCL0hkaeEN2aqDDCyaI5cZ03payXtXt3RO6biTEFgYKEQkxQ7XsX5nBbhTNVzYDj7uPW54BAGQBYbYcZo4M2sClTvFweJ4VUbyiKJogR7SBntv/mn1xadhSib+ajfNYwNXW9JledwP83hhCS/ooTLnvrKqIvV4rTQ0umrdK56/Y5igRV1tZFG9psHCXHXsIwmGboItVvzb+gbuFQXfHVQqO4R9gFbgnYbXXXdIc1/HpGo4s/VersWbibi6XivNMLrwkSz9HHFGlohTlF/GQDxt96rvhyLBp4BhgqXAtdvlkUpSxQNiGUJe6Epog9gvnb7qhU2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SNo7VpwdkzEaOlsl0AyRshC/t/ymJnTRXUpGnoHmt0=;
 b=jLQy6TvXhjOmhEx/vp5zzoSO94j1/uu7lrsSchTJ0X1yXcI2qpC/+HD3XVJJfnjJqv9ntnsKkxMRIZVNvYzCwrvLvDBZdNYNSEMlTLbQowZcChlXd9e6LI3qQ6me+5PpOnNDjl/m47uys/A8Eos6Zu43s6tVWRx+lShBHDu4fbwR30+O9da2j6sPZSpbH5WbqWpxwR03dsfAHGKcr+PpEPEI33YswuComw2SAC3jrkVL5d3TGWzl4IIQryzW06x4hzM6moZRv3/Uknxx1fEF2XrGFlu3qe/wLpLqFLOOj2HzJeGN87lP1H/bjOumgF4gkSyc++r8mXib3u1cDa+IfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SNo7VpwdkzEaOlsl0AyRshC/t/ymJnTRXUpGnoHmt0=;
 b=C6LKdV/0UGpaQEZ5KANS0fs6n872UKtBPljThsyd++qzbOHi/s9dLUydH2m3DnRA4yf2cLYw8lYkvUjqd+zqKZClg9EuIX4B9lK+HyHAj8PbpKPOIQSyRgOPoFKxY2PbK3zo0HlY6+tm/uztJugnFivBCixMYucsV3l8BqolOXt1bLnAcI77Cgvi/tAJUfiSFybrTbgqOPLJnxsxKfPlbW1xeGzvDUJYH5sv4MThZdq+iCOVSzNpLqrN1YJRqLPjlNRiJYDwHzQK0mQWUVsxhrtTN7BORv/LGV0OEbUh2yhoh/z2H1qXnAX0BR1bGXh+c6D3YUNqDDzZ2ilFeLF5EA==
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14) by TY2PR0101MB3104.apcprd01.prod.exchangelabs.com
 (2603:1096:404:e8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Sun, 8 May
 2022 15:32:17 +0000
Received: from SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2]) by SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 ([fe80::f50a:7a05:5565:fda2%5]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 15:32:17 +0000
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/4] io_uring: implement multishot mode for accept
Date:   Sun,  8 May 2022 23:32:03 +0800
Message-ID: <SG2PR01MB241129D7CDF5AFA14DB98946FFC79@SG2PR01MB2411.apcprd01.prod.exchangelabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508153203.5544-1-haoxu.linux@gmail.com>
References: <20220508153203.5544-1-haoxu.linux@gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [2gYRLntLoMy68tBtpK6luDs+dwdPP2ag]
X-ClientProxiedBy: HK2PR04CA0051.apcprd04.prod.outlook.com
 (2603:1096:202:14::19) To SG2PR01MB2411.apcprd01.prod.exchangelabs.com
 (2603:1096:4:4f::14)
X-Microsoft-Original-Message-ID: <20220508153203.5544-5-haoxu.linux@gmail.com>
MIME-Version: 1.0
Sender: Hao Xu <outlook_CA44A5BC8B94E9F7@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db8bec4c-1a77-4abd-a5e1-08da3107ee49
X-MS-TrafficTypeDiagnostic: TY2PR0101MB3104:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XSmjpO/I6RlX7pv+xC+MeXuLOj1fmGNLAkDfFOxnR/oTtUQDN55Fwcu9qzLgxSUr4EPknRWnBho2YXfOqBEOyR5KjpkEzMDpibiz0cSCr83udXOPc6pICO0mAVvu/mp/b46E7ocrW90I7bHM/CBxwNO0uMWGfmnNV2AcSiEMNN55gRrkfJwj9S/2HjLtNhHQ5UxbvRwse/nEbPlcanqzb9h3DpJ6pBiprhAfxIbzP+zxZ9dNLzjF5FSjKYZwZtut7FQ5IFGGJbdIkOqbrBMnMPDD7OQB3gQPaPfxzcw4ossD2bmeExCFHUPpW/7gJeARq73MynMo5HkvXXb57v9Y5FxoBfIqo9PCm7LdGl42wp3AZKVDW01pdpE+JK+tIF8RLdo0y/wvEF8ja1VNSOH2pyLHq4iXq1OxBVh7r+j1xSmw1ljMuZiIbRodvWKdxQ2KXN1qFiCOVU+rvpihrubAb89h4lDohVD4fJByfegCq/gNN4qGD+51NFqYRfbRX6gN4NxY9Ct7cTX6kDIePB1RmAiroqRy3om5Aj+ZbvLqWLOZsbzQTQe1tg18/eemLyCToPygbAhvtSleEFFWDexV9hS1Z8Lnrd+mhRHFDPLxPIo6tnMkJjm4fSKglafacmBw
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ip/EoU8VGdiMapu+BJicW80pjKCPVGmZEdOREV4RMrkLjknGkcAS1vNV14wc?=
 =?us-ascii?Q?8NjMicx0mAR+Byhs/u5+Yk69GKzfmpjB3bKxI1/5G+KWJMK1/yd/xnje+Wmv?=
 =?us-ascii?Q?2xg1/7Zm6o4evE8d5GKqdiDmQ/1X3WSEuQgLDzQ1EixQH0GAU3Gw52cEAhE4?=
 =?us-ascii?Q?YAbRmgturDWZwe8FXf30r8DamfINCMvLLM/NXa5dov/pqsercxDMJMHFi7S0?=
 =?us-ascii?Q?bsj4TVbvQIvPNUxT9vXU61oV2ErTAfMt5UtZEXagy1v7qPqRlT5XUnBMuCcd?=
 =?us-ascii?Q?tT0UVioSuPuD4SpYqh0hUqMcV7vpkzlk+rWH3RcuzLhxtt3G6m8/Un9XgT/B?=
 =?us-ascii?Q?GWcy1vQ/wyrzsea9IlY8ex+ub8HZ1Am1p9zxl52YWkhLmY7KC9bu39RPd716?=
 =?us-ascii?Q?l0rp5pTvdHRrHQvYu8X+KXI6kO5Z/ItWnY8i7aIE6QmZ9k/DVVL2/f4O1Ir0?=
 =?us-ascii?Q?PF8RKSqPGVLYJS0u9O5kzzV2uJPl4uK+AyoZvYCPGs81ApKKuYcVQT841uYD?=
 =?us-ascii?Q?490i3BX05S59daWaVfQBIaTjuGGRO6pxkY4yrXv78wHq1sab+tOn1hMQVXT6?=
 =?us-ascii?Q?kcIIXLPWoUPw5JIL2RPU/jfn3SZox2J2ZyZLketHIAmLapXHRQNDYD176B7e?=
 =?us-ascii?Q?HxdAvo3/dysQsRnGO7QErq2xagmCLMCWZssYzVLI5max1t0CJQoYr4imAIyp?=
 =?us-ascii?Q?EuNtuVT6jrXcsIzWaeIyAPuS7Hnh3eCNm7dRGlvpCc4MAKy6y3fBURjyhzwP?=
 =?us-ascii?Q?kU1w1wl+HLCA2EoJhgNvHxlx88Rs9v5mCZY4Ry+eSXt0hXfLxZ/wSlhE8h9d?=
 =?us-ascii?Q?uaDpEY4h8kQjPL/YWuW+oISH1AJnQmMwupjmwjEZF18qXSTfEq8DtGVerU+A?=
 =?us-ascii?Q?fDkeiGnqZaxcqEh80+SjSBFCaArBC3BMyTgCnqH82/tm9A9NLE34kWusGJUx?=
 =?us-ascii?Q?lZUdiwF3A7kE5VIgicQEwEGR/HsQIa1u0QZVkTDCLMujSBjJvT8D1w2LcsBs?=
 =?us-ascii?Q?W7tF+kfFr669SpmFOhNBZBkAbigB4OFhpSPYSUeEhq8EviRHQVErY7naSoIW?=
 =?us-ascii?Q?fmA0QbDuzUMtlJJ4DYVG5X4QwI2gtI5YGPmYNELKCw5xm57ZMcVUdjwAQ/a0?=
 =?us-ascii?Q?ALM0Q2bM8sxbsuzlD+MFlV7YBrI/yW6oLP5126iyEmHMIJB5z7GKmd34EMn6?=
 =?us-ascii?Q?9nE+UwcPJcS6dhgKGQ3i6BaGbuVFed4XGMkmvlhNdyjyRv1hbe3INQtm5sMN?=
 =?us-ascii?Q?2Cq4at2A0xlt8pVgqGRZc40YAena9zfr483wnZho113Usft13foGxP/BJ+aQ?=
 =?us-ascii?Q?oogI25sDhuIcpxVov9eG1zbnjSIZTzKFrt9gVg/vS2VIIf5lzSC1/5UNxjnE?=
 =?us-ascii?Q?ovG5+JlFexJDA/EWPBZQ9SU56Cv9jZO6oN4WHChNqAc1WLuO2wKUXfxSvdjq?=
 =?us-ascii?Q?8RZ1GBu2Z9Iq7U1AKg3ayLPnTEj7T9zeAE6/WNsRbBQKORmXGDxRyg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8bec4c-1a77-4abd-a5e1-08da3107ee49
X-MS-Exchange-CrossTenant-AuthSource: SG2PR01MB2411.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:32:16.0245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR0101MB3104
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

