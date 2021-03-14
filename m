Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466BB33A480
	for <lists+io-uring@lfdr.de>; Sun, 14 Mar 2021 12:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235228AbhCNLQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 07:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbhCNLP5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 07:15:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5478CC061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 04:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:To:From:CC;
        bh=XraGQ66PIWZZNdHkxzp2YaOk0DADPiG3vxLi6VKZnHg=; b=a5zh3dbf0VscVrw5BfcFd+ZO0t
        LVDgvTHfGp9fmWPRppNlKBNh/vxnZDGBuoKA88HbiUXnBHSkxPhPsJLCs1G59oM5Vnd2Fy8a9sSzZ
        emV6Tm1VKldbU2RIb98er7MnWYySyGh4fwmLh9SpwjxX9XGMJxodZvQAq1eXU46klym3wwGj6YH5e
        zW8xT1dATbCVkEb+AMr2/mFfEwkkGMy8E1+HWtVQT7tktpzWPCARR87GA5d8jXdeJegejlAKOw7JW
        wKBNID5gr672j3eX3MkdETJVjObnRJ9EDU6V85xe69v3nAy5dXSjlCGSXQf+/Ac2gb5eH4GRWnoCu
        M2ndEjdSJiApJ2gYr0TbQ/ndm52tzJ/2KmIB5gaUipT4Loj/CDAOi6HvKaAUxxZNUu8VZPTbDfEAo
        cQBBss/UlpJg1/KSCb7pO/dWFq4B83eUL1YsNOAkHx1NdISjRH8WPvL/IMMFFspu7qPgUD0xITBKf
        Kk9XwQbs3iNegSduwDwZc67Q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lLOix-0000M4-O6
        for io-uring@vger.kernel.org; Sun, 14 Mar 2021 11:15:55 +0000
From:   Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 2/2] io_uring: use typesafe pointers in io_uring_task
To:     io-uring@vger.kernel.org
References: <cover.1615719251.git.metze@samba.org>
Message-ID: <270653ab-91aa-392a-35f5-0a02893b1988@samba.org>
Date:   Sun, 14 Mar 2021 12:15:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <cover.1615719251.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fd0807a3c9c3..9b8cd9559584 100644
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

