Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B71D153DF6
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 05:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgBFE5N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 23:57:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFE5N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 23:57:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=qCN7yVOVetZZAawoWe0NROxUZNBW+rfsd8LEb6PrkI4=; b=i7DoUdgbFBRLxlRX6FMRyrGEfM
        9L9flbNNuDLXVKSRXJSodSUdUh4FGXlEZiV9/+sxFigRTwAPYKV3rcuIc8JjDL6I59JSvNVI5llHW
        L0NSnlZMe4YcSiFoL92HhISTTsI4O+zbySXoHzOAcEUYI+uK0okv/M1Me3KGsqRtLO/vm14jqcBXI
        xgXMjSCmxF9sUuD3sPnFjA4lAJV1ircwrPm+YpRgYwke40tRFokP1YsPa4RRyZbEyJ+mwaw1eKnpI
        PQ9o7Bq5dDxcWGcqBXwiGqUFKOndZCiM1YywsBeoLzYr9DQkEryb7b63sljYxgRNOXu1mOotBcxIg
        +FqDqUag==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izZDz-0000SW-Q9; Thu, 06 Feb 2020 04:57:11 +0000
To:     LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] io_uring: fix 1-bit bitfields to be unsigned
Message-ID: <3917704d-2149-881c-f9e5-2a7764dccd3f@infradead.org>
Date:   Wed, 5 Feb 2020 20:57:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Make bitfields of size 1 bit be unsigned (since there is no room
for the sign bit).
This clears up the sparse warnings:

  CHECK   ../fs/io_uring.c
../fs/io_uring.c:207:50: error: dubious one-bit signed bitfield
../fs/io_uring.c:208:55: error: dubious one-bit signed bitfield
../fs/io_uring.c:209:63: error: dubious one-bit signed bitfield
../fs/io_uring.c:210:54: error: dubious one-bit signed bitfield
../fs/io_uring.c:211:57: error: dubious one-bit signed bitfield

Found by sight and then verified with sparse.

Fixes: 69b3e546139a ("io_uring: change io_ring_ctx bool fields into bit fields")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
---
 fs/io_uring.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-next-20200205.orig/fs/io_uring.c
+++ linux-next-20200205/fs/io_uring.c
@@ -204,11 +204,11 @@ struct io_ring_ctx {
 
 	struct {
 		unsigned int		flags;
-		int			compat: 1;
-		int			account_mem: 1;
-		int			cq_overflow_flushed: 1;
-		int			drain_next: 1;
-		int			eventfd_async: 1;
+		unsigned int		compat: 1;
+		unsigned int		account_mem: 1;
+		unsigned int		cq_overflow_flushed: 1;
+		unsigned int		drain_next: 1;
+		unsigned int		eventfd_async: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is

