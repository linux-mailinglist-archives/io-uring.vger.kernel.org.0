Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5324F48510C
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 11:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiAEKVL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 05:21:11 -0500
Received: from prt-mail.chinatelecom.cn ([42.123.76.223]:52477 "EHLO
        chinatelecom.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234187AbiAEKVK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 05:21:10 -0500
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2022 05:21:10 EST
HMM_SOURCE_IP: 172.18.0.188:39278.2063135568
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.92 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 99534280098;
        Wed,  5 Jan 2022 18:12:06 +0800 (CST)
X-189-SAVE-TO-SEND: +zhenggy@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 7809a9feb3d1420a8760338527f4550a for axboe@kernel.dk;
        Wed, 05 Jan 2022 18:12:08 CST
X-Transaction-ID: 7809a9feb3d1420a8760338527f4550a
X-Real-From: zhenggy@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: zhenggy@chinatelecom.cn
From:   GuoYong Zheng <zhenggy@chinatelecom.cn>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        GuoYong Zheng <zhenggy@chinatelecom.cn>
Subject: [PATCH] io_uring: remove unused para
Date:   Wed,  5 Jan 2022 18:12:02 +0800
Message-Id: <1641377522-1851-1-git-send-email-zhenggy@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Para res2 is not used in __io_complete_rw, remove it.

Signed-off-by: GuoYong Zheng <zhenggy@chinatelecom.cn>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6fb1bb..8473f955 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2858,7 +2858,7 @@ static inline void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	}
 }
 
-static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
+static void __io_complete_rw(struct io_kiocb *req, long res,
 			     unsigned int issue_flags)
 {
 	if (__io_complete_rw_common(req, res))
@@ -3108,7 +3108,7 @@ static void kiocb_done(struct io_kiocb *req, ssize_t ret,
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = req->rw.kiocb.ki_pos;
 	if (ret >= 0 && (req->rw.kiocb.ki_complete == io_complete_rw))
-		__io_complete_rw(req, ret, 0, issue_flags);
+		__io_complete_rw(req, ret, issue_flags);
 	else
 		io_rw_done(&req->rw.kiocb, ret);
 
-- 
1.8.3.1

