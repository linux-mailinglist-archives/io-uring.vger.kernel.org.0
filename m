Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A303675996
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjATQLq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjATQLp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:11:45 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D7161BD
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:11:44 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p12so2912497ilq.10
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rND2F1XYF958GKKeyTe2MmPn0ao2P8vaS8QXMaC+K8=;
        b=mudjBkNrAIASXOSbkDfP8sbfsLaqkoyCatbEiww1HkN7PvYCvtn6WBXEMYKO0xngK0
         LZD7Oc0AAqKGjP7Mu17oxwJa1Kr4LfMgwGacjfQ4uua09ChPbKO6jWxKZ5qhhHGXKqic
         ViKA4HFYo3dFcANKrPrCJKQ//o0jWfOnrRstCrCLt8M/5hQaMVxDL+L/SfoVrbZ69UOo
         s7y3oukgwjuo0pIX0/Cg/e3v3dE1YLozJ+ZNN5fT7Ok89gL78lGfkhoAFWSQ3Elzl+Gm
         LrE0zMht9tIJdeIahmQCKTCuCZYq07k2v3fyLZFqt/nCErjxxedYDn3uTkRBjShxA8YD
         +6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2rND2F1XYF958GKKeyTe2MmPn0ao2P8vaS8QXMaC+K8=;
        b=sj7+KZ/ud0gRmmt1Kr1iZ8BZVHv6T+2pr6jluQ9I4ZyywEw6mNwlzNJePIYtXBQZ9L
         hqQa7OTnT6g7KVjIcAwcjP8SXHCyCgKm1jpUrww3+lbMfnI02ConlgNOwID7i110bPgA
         qF6Ez/oG5DEHaDmSObMQsiMK0lW3RrKBBNW/oPuJom86esnRPv1xkfCWsG12s2Nj/PAM
         x4CBW7ypnVywNVDElRxGMqC1Ts5a++s3pYu1zrtNgQVvMClesaU4AYMqOAfG9/MoaNdO
         bkaRgsOsxVcyjIrFW7d6j5bwHTrvem6/fDNAsN9TknMLZHKwG+8hPAIGyKuw1NLGXN0k
         c3Zg==
X-Gm-Message-State: AFqh2ko/Nq0LXF06DDbwG+CtOTWdOUrUzvccHIjQr0YJ5I33BNpga6aj
        alZGItUvpa/ldT1nVE9gN4li07rFnJWrxX/t
X-Google-Smtp-Source: AMrXdXsHHGWEqFg9UIrC/vLDD4BYL1PrawIUsoJC8IyRcmCboJWMx3lZCUeTM05gU+2l/PKYT08pPg==
X-Received: by 2002:a05:6e02:ed1:b0:30d:c502:a9de with SMTP id i17-20020a056e020ed100b0030dc502a9demr2333096ilk.2.1674231103102;
        Fri, 20 Jan 2023 08:11:43 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a027a12000000b0039f0afe9901sm8750757jac.143.2023.01.20.08.11.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 08:11:42 -0800 (PST)
Message-ID: <1dfd3b84-288f-89ad-582d-718fa74e6f15@kernel.dk>
Date:   Fri, 20 Jan 2023 09:11:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: pass in io_issue_def to io_assign_file()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This generates better code for me, avoiding an extra load on arm64, and
both call sites already have this variable available for easy passing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 65cbb83573e5..c3aea69e4b44 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1860,9 +1860,10 @@ static void io_clean_op(struct io_kiocb *req)
 	req->flags &= ~IO_REQ_CLEAN_FLAGS;
 }
 
-static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
+			   unsigned int issue_flags)
 {
-	if (req->file || !io_issue_defs[req->opcode].needs_file)
+	if (req->file || !def->needs_file)
 		return true;
 
 	if (req->flags & REQ_F_FIXED_FILE)
@@ -1879,7 +1880,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
-	if (unlikely(!io_assign_file(req, issue_flags)))
+	if (unlikely(!io_assign_file(req, def, issue_flags)))
 		return -EBADF;
 
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
@@ -1948,7 +1949,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 		io_req_task_queue_fail(req, err);
 		return;
 	}
-	if (!io_assign_file(req, issue_flags)) {
+	if (!io_assign_file(req, def, issue_flags)) {
 		err = -EBADF;
 		work->flags |= IO_WQ_WORK_CANCEL;
 		goto fail;

-- 
Jens Axboe

