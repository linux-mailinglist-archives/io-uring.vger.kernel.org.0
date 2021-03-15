Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A191D33B1E6
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 12:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhCOL6V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Mar 2021 07:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhCOL57 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Mar 2021 07:57:59 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA34C061574
        for <io-uring@vger.kernel.org>; Mon, 15 Mar 2021 04:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=e4BOt8hBBHUs6LXZMInRLpx+oxcb6taGQ0UMYz8+j1A=; b=kxLjbQu3ET/E6Mm/135vMWZKhn
        g43uZS3JMToDrImiBbohIVVYnDNn/yEhLhNEEImKgd1NDsFWcOo6okj1srI+YYjEIgzBEm3U5q2vl
        r8+jpIyF264mRj///XaJuo5AFKttiQgPzKxidlusH3JDbAlhDgvbvjCA1YNWRKH1/oWpiBy0I+U81
        Z1S1nWF3DtwofN52C5NbSQTAg6gcq0a4Zwm9BPcqSu1RAYjSlZHdCZ8wcyK5CuK0feLIBhRKUWu+k
        777e0KOqNm3AXdl0Pi6WAWWwy/04wW4yffyZBWrf0DwZ8ZN/EHRwOs7+JEWKhN1Inc3c2EYqcTZ45
        d0Rx2ag8JJ4bP05xNfLElYbNaDQxFUK56kEwVJoG3jCkfyzHzSamn/jSuOheox6G2kF1MU1gPmYfg
        TdA16WBCNJfed+RT3MOfZqijeVpl6yMnygbsPlakwebDiEVRidAqCYb/vB8qqy7w12BtLOriPDeAi
        S0rGFcGtlMQRDvxU9kgyu12y;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLlrB-0002Al-Kx; Mon, 15 Mar 2021 11:57:57 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v2 2/2] io_uring: use typesafe pointers in io_uring_task
Date:   Mon, 15 Mar 2021 12:56:57 +0100
Message-Id: <ce2a598e66e48347bb04afbaf2acc67c0cc7971a.1615809009.git.metze@samba.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1615809009.git.metze@samba.org>
References: <ccbcc90b-d937-2094-5a8d-2fdeba87fc82@samba.org> <cover.1615809009.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 52b5ed71d770..f048c42d8b8f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -458,8 +458,8 @@ struct io_uring_task {
 	/* submission side */
 	struct xarray		xa;
 	struct wait_queue_head	wait;
-	void			*last;
-	void			*io_wq;
+	const struct io_ring_ctx *last;
+	struct io_wq		*io_wq;
 	struct percpu_counter	inflight;
 	atomic_t		in_idle;
 	bool			sqpoll;
-- 
2.25.1

