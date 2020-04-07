Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224FC1A09AA
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGJAT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 05:00:19 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36393 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgDGJAT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 05:00:19 -0400
Received: by mail-pg1-f193.google.com with SMTP id c23so1412501pgj.3
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 02:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x75EdEh/YpcUWJG/d1Wq2JJ6x0TntRzVoGfF6edz+P0=;
        b=ShNiQqTuqf2euMEwG9cbJQmGJX24N/xXbr2ammtQnVRyK4VaGU/4aY55wqdrtp1Bx3
         958DHX6qz/Kk4LmidzgKsVsgDFGJCWkB1em+8ZGK0jqi6jk8MConUgAH3c3uMSKGWzXU
         THleAL8Fhv2HWolfZ44rHCUYlJCHBKD+gJcrYQSKdGLXxgQvXanIljswo2sI/9Fv90tD
         hfnwjJ+JPk8va8WIEAWBg/oPGk8+KM2LRKdvQ4qd7E3SKRIogHMMMnLCYTJweaqzbaZl
         qXreFWVN2Pf5nsNW3zfcM2axHWrZjn28J8Jrv/omvnTEn9XLEiInAfjFVUClxZwZoXgt
         Mn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x75EdEh/YpcUWJG/d1Wq2JJ6x0TntRzVoGfF6edz+P0=;
        b=p1pzRqzdktSzzMZxz2SFs38ECJUltc05OWtX9vez7Gp4nnrFkECzIOI13M4BnKOiiD
         EOsDcfFpl8o9bdWKBZy+iUZXWKVJ4qj6p8qP09gLvg8ZI//OANIM3TFeT+MdpslE+dwm
         bComNh77k/d8ZMPcl1Ejbvx2cazr5se6DHp3DjvtakXHpF73lEU8mdAYJcs9Qdlck+Jy
         l9ZXgKDtKcipRRptZLpt2MUhxnIPxGMrbxhbmjo5jOvJ2OVfsDtEBf0rHeuWyzmzdTQu
         X0SIgzg8MGx1owgFo6Y09rC638otIeFa8XiV9JmAMZd+UngC1br+nJM/ccUaYcZlk/PU
         aMHw==
X-Gm-Message-State: AGi0Pua6bf1H709ZBoiSUXn8qJnN5vimP5+NQQzBMUUHiBuewOg4NHZq
        9Qdl2c92FyWoY9o2W6eSRX7FIbJD
X-Google-Smtp-Source: APiQypLjR5VKdEloBBGPgGTgI6qQZ+Cpm1W8rFuttGPB8m+1z1JUtXQB9dk7JKMU0SwpuIuup61KNQ==
X-Received: by 2002:aa7:94a6:: with SMTP id a6mr1583846pfl.214.1586250018040;
        Tue, 07 Apr 2020 02:00:18 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([150.109.106.156])
        by smtp.gmail.com with ESMTPSA id u18sm13424716pfl.40.2020.04.07.02.00.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Apr 2020 02:00:17 -0700 (PDT)
From:   wu860403@gmail.com
To:     io-uring@vger.kernel.org
Cc:     Liming Wu <19092205@suning.com>
Subject: [PATCH] io_uring:IORING_SETUP_SQPOLL don't need to enter io_cqring_wait
Date:   Tue,  7 Apr 2020 16:44:35 +0800
Message-Id: <1586249075-14649-1-git-send-email-wu860403@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Liming Wu <19092205@suning.com>

When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, app don't
need to enter io_cqring_wait too. If I misunderstand, please give
me some advise.

Signed-off-by Liming Wu <19092205@suning.com>
---
 io_uring.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/io_uring.c b/io_uring.c
index b12d33b..36e884f 100644
--- a/io_uring.c
+++ b/io_uring.c
@@ -7418,11 +7418,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		 * polling again, they can rely on io_sq_thread to do polling
 		 * work, which can reduce cpu usage and uring_lock contention.
 		 */
-		if (ctx->flags & IORING_SETUP_IOPOLL &&
-		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
-			ret = io_iopoll_check(ctx, &nr_events, min_complete);
-		} else {
-			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		    if (ctx->flags & IORING_SETUP_IOPOLL) {
+		    	ret = io_iopoll_check(ctx, &nr_events, min_complete);
+		    } else {
+		    	ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
+		    }
 		}
 	}
 
-- 
1.8.3.1

