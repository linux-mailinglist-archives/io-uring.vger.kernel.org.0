Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8129677DA8
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjAWOKJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbjAWOKI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:10:08 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7244F26B0
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:10:04 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9so11470056pll.9
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5SjJ6tUXT5UMWw7TnGlywV3SDFB2S/Km3mNR1hr6E8=;
        b=JxOjfWlLCTMTTei422eQkTuT4dMnb/9KSEVllwzKYjAcqd9pY8rsHNMtDm4bO0wt8Z
         ZI11uYhUdQz5w8rYTFkXrNV8eXkDdNOjXoBfFskgZPNOd0JT15oOvaANJn/rcdti/HUu
         U43+CZInRhD/wY8q54ASZuUMPRkLv/mHEuT8kG27FKjCHrFGaEcM78kTqg7xsn9nb2RP
         XUA39zOsiVSrJT5HiRkxpj6LjIpnxYFC7a+S/XXFmUWo+HxBxfwxpCii7htjNXQnuyJv
         9VklLJA3903u2ZAZ2yK/mlh7FJYbWusen8xmzwembM7kAoqC7YBJm/yf7DLr/oxyDG6w
         BSrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G5SjJ6tUXT5UMWw7TnGlywV3SDFB2S/Km3mNR1hr6E8=;
        b=YLNLFdePs3MWuSFluEnLt2vqIbSofFJP4nS9YUF7GeBnEzamhdqMAQN5hdmESXS3WP
         ZvATqFSOm6jiBW6XK/e7Qh07+smMc7Cuzr0d6eI+rcszZh1l8L5lbs8elI1cD0BxuiQn
         ukpw0bD2nVXBt0WeZFBrxQ2NBv1dCbO1LBjc7TuZ+TiQla5tOObM5azcEuIErQYYgJaa
         f2DKISwzyqMuwb3TplLdNCZCFEj7NN/Ji5ecOr6lhRI5aLWy7JcgGjfyAMHDAapw8m41
         nB7b+y9/8iXHoygQjXYxUIUfy0W5BOdNwdf5QVNDPU6cNUK4b5MBPxiQJtOMAT7IUEWU
         ufaQ==
X-Gm-Message-State: AFqh2kqPrvN0X10ZMbP+1vuY4xPQVyUFEgg1VhWx01ALZvBlCr5JxOAc
        GJiRrgjuMXZ19ri0IshQCEPoB5JRvZrjC7ak
X-Google-Smtp-Source: AMrXdXt7wXkUJkEIw51UAjulL8aHeyCp7nTFkCnvMujvt0K47QzHwEWtdn+N8CXKYzpHxfzghuQ0oA==
X-Received: by 2002:a17:902:b591:b0:18f:a0de:6ac8 with SMTP id a17-20020a170902b59100b0018fa0de6ac8mr6103594pls.2.1674483003594;
        Mon, 23 Jan 2023 06:10:03 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090322c800b00186f0f59c85sm11032792plg.235.2023.01.23.06.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 06:10:03 -0800 (PST)
Message-ID: <f1a1ba93-1adf-63fa-6f0f-f3182f165841@kernel.dk>
Date:   Mon, 23 Jan 2023 07:10:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Dylan Yudaken <dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: cache provided buffer group value for
 multishot receives
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

v2 - add buf group restore to io_recv_prep_retry (Dylan)

diff --git a/io_uring/net.c b/io_uring/net.c
index fbc34a7c2743..90326b279965 100644
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
@@ -596,6 +606,7 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
 
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
+	req->buf_index = sr->buf_group;
 }
 
 /*

-- 
Jens Axboe

