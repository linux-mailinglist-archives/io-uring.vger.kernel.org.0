Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5FA6770FF
	for <lists+io-uring@lfdr.de>; Sun, 22 Jan 2023 18:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjAVRNp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Jan 2023 12:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjAVRNo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Jan 2023 12:13:44 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2502C4C26
        for <io-uring@vger.kernel.org>; Sun, 22 Jan 2023 09:13:43 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 5so4063016plo.3
        for <io-uring@vger.kernel.org>; Sun, 22 Jan 2023 09:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2uRjGvAuEzHVbhL6DIyceRd4fiERjP77Hn3+TUiFm8=;
        b=jClulBSlRTdVd5gzuK/eBMUqdPCwr173/YWQGICgnyjyDW3YqQjYHYCfDFo0Stpgr5
         gAEfS6/W8sR0wR5u/keAc3eOw/88bu+Ux8VsTYH0AIRbJhttdQ6ave5Ghb/al/U5nPWj
         V1acRQQIPZ6miTY6v5e9Gwn19sT53FSVZt8rBUzChZE2L1aiUvB+VRHuLqrNGHkhA10j
         SaHKMRB/S/il7xxT5zyFbI9Ym/Gu3YiHc6oZE0on4Nq0emmuKxvaMQSuH8tmC9C03l3d
         7lWNYokT76KG9G+yJb4QzrTkdRCRtth0MA6urSdeaJQiPfmIyM2HWMYLsghuCBAxcEFH
         fh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R2uRjGvAuEzHVbhL6DIyceRd4fiERjP77Hn3+TUiFm8=;
        b=Nw9PlkhPYx7DjfX09pvDzmcZNpGJBAx69BKftkueOoBE1DrfS+5hTUrpb7jDoueLh/
         Ws01EsUrJmCG5OmIFLEMRP/HVsMoCfkT+nO5JlHhM8QlTs02s2zhAdeiKnXGLGTN44FL
         g4YTlPhIupDSkYA2bjL7gjbbjXgBXLPhgsaYR/ZQdCQghwHXCp1rt/LPKMSCnAfYb+MC
         KpLJLj51DPIzUPJ5vWUK83DuxI8i7JOn+RZ58akc478mEKkT50Xrwe8EelmpJ41lJ6V3
         T+sz3FhVyOX/O17druOa29IQ46/v28/lwPCKNEFeZztO6Gaedb0sgTpGbsL1oa+BZxWr
         3CKg==
X-Gm-Message-State: AFqh2kq3LCW3eISZgwOLn+TEBpoGy4M9omcSCPgxVcycpHGp2UfHD3r3
        rvgxAwSsF0B9+EZ3vyQK+Urfw6AGrVGasmP+
X-Google-Smtp-Source: AMrXdXvOkWE93NboeXCSx1Bj3tEzeGgy/g80XCHPGKdbKe9oSlcMSVzt+87kJ4lDNLm42gh+fYvclQ==
X-Received: by 2002:a05:6a20:428d:b0:b8:7b2c:1831 with SMTP id o13-20020a056a20428d00b000b87b2c1831mr6672581pzj.1.1674407622304;
        Sun, 22 Jan 2023 09:13:42 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 201-20020a6303d2000000b004b4d4de54absm21436883pgd.59.2023.01.22.09.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jan 2023 09:13:41 -0800 (PST)
Message-ID: <3627b18d-92b0-394e-4d39-6e0807aa417c@kernel.dk>
Date:   Sun, 22 Jan 2023 10:13:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Dylan Yudaken <dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: cache provided buffer group value for multishot
 receives
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're using ring provided buffers with multishot receive, and we end
up doing an io-wq based issue at some points that also needs to select
a buffer, we'll lose the initially assigned buffer group as
io_ring_buffer_select() correctly clears the buffer group list as the
issue isn't serialized by the ctx uring_lock. This is fine for normal
receives as the request puts the buffer and finishes, but for multishot,
we will re-arm and do further receives. On the next trigger for this
multishot receive, the receive will try and pick from a buffer group
whose value is the same as the buffer ID of the las receive. That is
obviously incorrect, and will result in a premature -ENOUFS error for
the receive even if we had available buffers in the correct group.

Cache the buffer group value at prep time, so we can restore it for
future receives. This only needs doing for the above mentioned case, but
just do it by default to keep it easier to read.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
Cc: Dylan Yudaken <dylany@meta.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index fbc34a7c2743..07a6aa39ab6f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -62,6 +62,7 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
+	u16				buf_group;
 	void __user			*addr;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -580,6 +581,15 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (req->opcode == IORING_OP_RECV && sr->len)
 			return -EINVAL;
 		req->flags |= REQ_F_APOLL_MULTISHOT;
+		/*
+		 * Store the buffer group for this multishot receive separately,
+		 * as if we end up doing an io-wq based issue that selects a
+		 * buffer, it has to be committed immediately and that will
+		 * clear ->buf_list. This means we lose the link to the buffer
+		 * list, and the eventual buffer put on completion then cannot
+		 * restore it.
+		 */
+		sr->buf_group = req->buf_index;
 	}
 
 #ifdef CONFIG_COMPAT
@@ -816,8 +826,10 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags)) {
+		req->buf_index = sr->buf_group;
 		goto retry_multishot;
+	}
 
 	if (mshot_finished) {
 		/* fast path, check for non-NULL to avoid function call */
@@ -918,8 +930,10 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags)) {
+		req->buf_index = sr->buf_group;
 		goto retry_multishot;
+	}
 
 	return ret;
 }

-- 
Jens Axboe

