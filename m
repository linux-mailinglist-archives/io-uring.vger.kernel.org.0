Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18F74E6B05
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 00:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346447AbiCXXLv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 19:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244602AbiCXXLv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 19:11:51 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD64638BEA
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 16:10:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c11so5004677pgu.11
        for <io-uring@vger.kernel.org>; Thu, 24 Mar 2022 16:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=zEhI93Y3PhVbWj4XSEntk8XrMwdrkmIlgcg22Y2pu8E=;
        b=42msovNjAt4Dw51HGyrO2dwAhQCl+1fw5WAwGrPlsYi1vMwW1F/4JQiYAZ8lTtB3Hm
         LpAWmV4J9ZC02JvjDRCPB7ONoLpsIq7LeBqiVk5hroy0G/f5T+gh/ZFCurQpIDolspa4
         6tOAPMSfl7ui4HwaQCn9Lu6gmEyUa8lAHTzSrQefeVY1dZmKBO3nLgoLEXPe0EsJBLFw
         dDaAMyjnyudUoFB1qHGkyOnH1qv6JX2b6QABBW+dylySgVFjLU/59LvbY8neEe16LOmj
         4FEFbRM1dBqVVUfeCNw9SpjW5dOF0xyqLFG4MEOLVFTmMzqphP8H3aWL4RA4x6L1xonk
         SJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=zEhI93Y3PhVbWj4XSEntk8XrMwdrkmIlgcg22Y2pu8E=;
        b=N/vEjp/Uh05+qUrV+oIr5Yku2Oqu+9yAIISG1umUamVyYM4BEGQx+T4aMM4FnklMVl
         t8UAOSTyf1mUTDFOPzwssz2e/EevsHxizNR+hlKz4JKsvJGnPB1eObFIM6ABkVkBhBd+
         80yRxGuJr8WS8RF5WZRReEZUnjIkCgZ6kfrGGg+BnUi1VaPi8Ygy2+PYwHm+YCAFCl71
         OaX2rDNfRRnRdYekcfa8gyKnBW7Azp9xvO/hOo2eUQ3R3xJhQtJaTsyAumZ5V/IlMKxW
         tnYnSwTY8D1a0Qk09Yj685zGDlaYheHWL6c7DsklOtilZ+HL8I4s/75RaechdfBLM6hm
         bMCg==
X-Gm-Message-State: AOAM532FK0ImAJFzKCe2OVwq6tcRJFBa3LscVLSg129JE+RIiqhazRlc
        HE0gZaSAfccZGaMTDH2ZcSC9jKtSKoWN3pmi
X-Google-Smtp-Source: ABdhPJzZ6AKUdV6ReaM9kS++U5FvsuP/Wg2OiVR9ewPpGO6Q4dSgZthpVBK5IGEiJIe0Q4RJb+hBZA==
X-Received: by 2002:a63:f24c:0:b0:383:c279:e662 with SMTP id d12-20020a63f24c000000b00383c279e662mr5679374pgk.303.1648163413828;
        Thu, 24 Mar 2022 16:10:13 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s141-20020a632c93000000b0038134d09219sm3493517pgs.55.2022.03.24.16.10.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 16:10:13 -0700 (PDT)
Message-ID: <4f7b8a9c-5aab-e583-8f31-2cc49e9316bf@kernel.dk>
Date:   Thu, 24 Mar 2022 17:10:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3] io_uring: improve task work cache utilization
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While profiling task_work intensive workloads, I noticed that most of
the time in tctx_task_work() is spending stalled on loading 'req'. This
is one of the unfortunate side effects of using linked lists,
particularly when they end up being passe around.

Prefetch the next request, if there is one. There's a sufficient amount
of work in between that this makes it available for the next loop.

While fiddling with the cache layout, move the link outside of the
hot completion cacheline. It's rarely used in hot workloads, so better
to bring in kbuf which is used for networked loads with provided buffers.

This reduces tctx_task_work() overhead from ~3% to 1-1.5% in my testing.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v3 - apparently it's nicely documented that prefetch need not be a valid
address, so just get rid of the next checking for it

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a76e91fe277c..bb40c80fd9ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -928,7 +928,6 @@ struct io_kiocb {
 	struct io_wq_work_node		comp_list;
 	atomic_t			refs;
 	atomic_t			poll_refs;
-	struct io_kiocb			*link;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
@@ -939,6 +938,7 @@ struct io_kiocb {
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
+	struct io_kiocb			*link;
 	const struct cred		*creds;
 	struct io_wq_work		work;
 };
@@ -2451,6 +2451,8 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
+		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
+
 		if (req->ctx != *ctx) {
 			if (unlikely(!*uring_locked && *ctx))
 				ctx_commit_and_unlock(*ctx);
@@ -2483,6 +2485,8 @@ static void handle_tw_list(struct io_wq_work_node *node,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
+		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
+
 		if (req->ctx != *ctx) {
 			ctx_flush_and_put(*ctx, locked);
 			*ctx = req->ctx;
-- 
Jens Axboe

