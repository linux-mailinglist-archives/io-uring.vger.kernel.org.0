Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C43D20BD28
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 01:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgFZXdR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFZXdR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 19:33:17 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE40C03E979;
        Fri, 26 Jun 2020 16:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FFnZ2DH3BBsvpUYqMMKOpb6IQpnDbi/NHQDeFMlmgCk=; b=XPUXN5CIj90hvXjTh5U83Qdt8J
        9fbINVs58U//tuC00nBGBIzosle9QqNlYwGDoskhdG41WvFeW0PDP/eCckQs3w4fWOHfvWQkcp884
        ojXcggAVFQknGn0HthlbRVGIrqf6o6UkEuOW9ur/ZJ6m5MoNS6zqBJ56FaVL5t89+kD5dPIjg0QYF
        WLrU/LVXIpEz7uO646A9a7kTvcgLwAcsrzSrUrmv1xuAT0C+SURafIK+Ej73Ww0frbSRWEegIm5W1
        C1ylsja6bWhTsqLejDDYpljK0+/F09sLlbaNfL9vnPc3LQN7nf2jgjw9ClK+q+3oYczOxc71NPSB/
        GoKRLQ3A==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1joxq3-0008I6-If; Fri, 26 Jun 2020 23:32:59 +0000
To:     LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] io_uring: fix function args for !CONFIG_NET
Message-ID: <c3db950b-9062-11bd-97e4-afe7c9bf2f27@infradead.org>
Date:   Fri, 26 Jun 2020 16:32:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors when CONFIG_NET is not set/enabled:

../fs/io_uring.c:5472:10: error: too many arguments to function ‘io_sendmsg’
../fs/io_uring.c:5474:10: error: too many arguments to function ‘io_send’
../fs/io_uring.c:5484:10: error: too many arguments to function ‘io_recvmsg’
../fs/io_uring.c:5486:10: error: too many arguments to function ‘io_recv’
../fs/io_uring.c:5510:9: error: too many arguments to function ‘io_accept’
../fs/io_uring.c:5518:9: error: too many arguments to function ‘io_connect’

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
---
 fs/io_uring.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- mmotm-2020-0625-2036.orig/fs/io_uring.c
+++ mmotm-2020-0625-2036/fs/io_uring.c
@@ -4315,12 +4315,14 @@ static int io_sendmsg_prep(struct io_kio
 	return -EOPNOTSUPP;
 }
 
-static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
 
-static int io_send(struct io_kiocb *req, bool force_nonblock)
+static int io_send(struct io_kiocb *req, bool force_nonblock,
+		   struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
@@ -4331,12 +4333,14 @@ static int io_recvmsg_prep(struct io_kio
 	return -EOPNOTSUPP;
 }
 
-static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
 
-static int io_recv(struct io_kiocb *req, bool force_nonblock)
+static int io_recv(struct io_kiocb *req, bool force_nonblock,
+		   struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
@@ -4346,7 +4350,8 @@ static int io_accept_prep(struct io_kioc
 	return -EOPNOTSUPP;
 }
 
-static int io_accept(struct io_kiocb *req, bool force_nonblock)
+static int io_accept(struct io_kiocb *req, bool force_nonblock,
+		     struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }
@@ -4356,7 +4361,8 @@ static int io_connect_prep(struct io_kio
 	return -EOPNOTSUPP;
 }
 
-static int io_connect(struct io_kiocb *req, bool force_nonblock)
+static int io_connect(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
 {
 	return -EOPNOTSUPP;
 }

