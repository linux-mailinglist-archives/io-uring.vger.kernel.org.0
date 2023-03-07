Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BF56AE952
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 18:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjCGRWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 12:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjCGRWd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 12:22:33 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE14B23C46;
        Tue,  7 Mar 2023 09:18:00 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u9so55389639edd.2;
        Tue, 07 Mar 2023 09:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678209479;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h22I7Lml+oXt3P/IjlAaN3/xdSQe2NePORKVjkqYpEc=;
        b=O4rvq9oDd0Pk9WvrX6ZQ0cvXxCiEKuvb1T8DHB2a7I0phMlc2JtCjXrH1Oj5IkJv+X
         90RpE+XVhupxZ9iEsrf7V8nLEFkr/t3wqy7iOTaNTbz4umn+45VMNMDv3mdNzQcg5bu0
         189pcvKybzWxGsOpzfDGhf5IFxc67scTvbdqbCH4K/SjaPLLGTqUHzK+i3+D1WH4soK/
         PcQyvkYB/FECA3mi14mQ+xaRyp9Z9FCxUvL0536bsAJSBDF7A7OJdTb42f1BXhKXGUpD
         paAhr0HZLYs3xkHCnFOzwWzspWmWewPDliiXR998PHVOioOyoStaCVukYon4d5GyJY6r
         K1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678209479;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h22I7Lml+oXt3P/IjlAaN3/xdSQe2NePORKVjkqYpEc=;
        b=gnSduJyJubi3qjr/1jg0veZPC0scDKBbzZbVfdBAbWAoK0KwHKRcSI+rgKO0AXo77I
         CTlHoQNzi7OIj1fLdenKxNLW36Ndhc/LBE/yAycPNzyPTuNq0SjqZA3uNmekiwLnOwGV
         FJiG7UuP4OMARSv51SZHqiJqshcmLN1ML9MkFyOhLUriRFAKZLicnlg7Ut30rqls6Ruk
         JAxBK9XMMpQaqb4V0OadMyE5hWcVRzE4U82WS/co2pyvIvWmlliGnTqtb4aUj5jqeu12
         +JE03P5VME3kEsDz/O2C4YKMeL0QCslUS3tKVgqVviDOswQI0AnNxrxrzRMxTKCabg98
         z5/A==
X-Gm-Message-State: AO0yUKWJGfLcLt1zYA+aJcImZKjuXpEfgp/cPWIypKox26Cc6z2y1H8T
        Kmd+nyac6xYbQ2Po2VZmRrgEjQwILws=
X-Google-Smtp-Source: AK7set9SNqRfoLI9PZ37gcislmhcd5QCM4unicxoybr504tYh6Ew9Z17HoL3IkA0ViEwNx9LlzWPjA==
X-Received: by 2002:aa7:df96:0:b0:4b1:b71d:cbfe with SMTP id b22-20020aa7df96000000b004b1b71dcbfemr14545785edy.2.1678209479251;
        Tue, 07 Mar 2023 09:17:59 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:e13])
        by smtp.gmail.com with ESMTPSA id i9-20020a1709063c4900b008d427df3245sm6405057ejg.58.2023.03.07.09.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 09:17:59 -0800 (PST)
Message-ID: <ce96f7e7-1315-7154-f540-1a3ff0215674@gmail.com>
Date:   Tue, 7 Mar 2023 17:17:04 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH V2 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
 <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
Content-Language: en-US
In-Reply-To: <7e05882f-9695-895d-5e83-61006e54c4b2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/7/23 15:37, Pavel Begunkov wrote:
> On 3/7/23 14:15, Ming Lei wrote:
>> Hello,
>>
>> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
>> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
>> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
>> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
>> and its ->issue() can retrieve/import buffer from master request's
>> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
>> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
>> submits slave OP just like normal OP issued from userspace, that said,
>> SQE order is kept, and batching handling is done too.
> 
>  From a quick look through patches it all looks a bit complicated
> and intrusive, all over generic hot paths. I think instead we
> should be able to use registered buffer table as intermediary and
> reuse splicing. Let me try it out

Here we go, isolated in a new opcode, and in the end should work
with any file supporting splice. It's a quick prototype, it's lacking
and there are many obvious fatal bugs. It also needs some optimisations,
improvements on how executed by io_uring and extra stuff like
memcpy ops and fixed buf recv/send. I'll clean it up.

I used a test below, it essentially does zc recv.

https://github.com/isilence/liburing/commit/81fe705739af7d9b77266f9aa901c1ada870739d


 From 87ad9e8e3aed683aa040fb4b9ae499f8726ba393 Mon Sep 17 00:00:00 2001
Message-Id: <87ad9e8e3aed683aa040fb4b9ae499f8726ba393.1678208911.git.asml.silence@gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Tue, 7 Mar 2023 17:01:44 +0000
Subject: [POC 1/1] io_uring: splicing into reg buf table

EXTREMELY BUGGY! Not for inclusion.

Add a new operation called IORING_OP_SPLICE_FROM,
which splices from a file into the registered buffer table. This is
done in a zerocopy fashion with a caveat that the user won't have
direct access to the data, however it can use it with any io_uring
request supporting registered buffers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
  include/uapi/linux/io_uring.h |  1 +
  io_uring/io_uring.c           |  4 +-
  io_uring/opdef.c              | 10 ++++
  io_uring/splice.c             | 98 +++++++++++++++++++++++++++++++++++
  io_uring/splice.h             |  3 ++
  5 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 709de6d4feb2..a91ce1d2ebd7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,7 @@ enum io_uring_op {
  	IORING_OP_URING_CMD,
  	IORING_OP_SEND_ZC,
  	IORING_OP_SENDMSG_ZC,
+	IORING_OP_SPLICE_FROM,
  
  	/* this goes last, obviously */
  	IORING_OP_LAST,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7625597b5227..b7389a6ea190 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2781,8 +2781,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
  	io_wait_rsrc_data(ctx->file_data);
  
  	mutex_lock(&ctx->uring_lock);
-	if (ctx->buf_data)
-		__io_sqe_buffers_unregister(ctx);
+	// if (ctx->buf_data)
+	// 	__io_sqe_buffers_unregister(ctx);
  	if (ctx->file_data)
  		__io_sqe_files_unregister(ctx);
  	io_cqring_overflow_kill(ctx);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index cca7c5b55208..28d4fa42676b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -428,6 +428,13 @@ const struct io_issue_def io_issue_defs[] = {
  		.prep			= io_eopnotsupp_prep,
  #endif
  	},
+	[IORING_OP_SPLICE_FROM] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		// .pollin			= 1,
+		.prep			= io_splice_from_prep,
+		.issue			= io_splice_from,
+	}
  };
  
  
@@ -648,6 +655,9 @@ const struct io_cold_def io_cold_defs[] = {
  		.fail			= io_sendrecv_fail,
  #endif
  	},
+	[IORING_OP_SPLICE_FROM] = {
+		.name			= "SPLICE_FROM",
+	}
  };
  
  const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 2a4bbb719531..0467e9f46e99 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -8,11 +8,13 @@
  #include <linux/namei.h>
  #include <linux/io_uring.h>
  #include <linux/splice.h>
+#include <linux/nospec.h>
  
  #include <uapi/linux/io_uring.h>
  
  #include "io_uring.h"
  #include "splice.h"
+#include "rsrc.h"
  
  struct io_splice {
  	struct file			*file_out;
@@ -119,3 +121,99 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
  	io_req_set_res(req, ret, 0);
  	return IOU_OK;
  }
+
+struct io_splice_from {
+	struct file			*file;
+	loff_t				off;
+	u64				len;
+};
+
+
+int io_splice_from_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
+
+	if (unlikely(sqe->splice_flags || sqe->splice_fd_in || sqe->ioprio ||
+		     sqe->addr || sqe->addr3))
+		return -EINVAL;
+
+	req->buf_index = READ_ONCE(sqe->buf_index);
+
+	sp->len = READ_ONCE(sqe->len);
+	if (unlikely(!sp->len))
+		return -EINVAL;
+
+	sp->off = READ_ONCE(sqe->off);
+	return 0;
+}
+
+int io_splice_from(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_splice_from *sp = io_kiocb_to_cmd(req, struct io_splice_from);
+	loff_t *ppos = (sp->off == -1) ? NULL : &sp->off;
+	struct io_mapped_ubuf *imu;
+	struct pipe_inode_info *pi;
+	struct io_ring_ctx *ctx;
+	unsigned int pipe_tail;
+	int ret, i, nr_pages;
+	u16 index;
+
+	if (!sp->file->f_op->splice_read)
+		return -ENOTSUPP;
+
+	pi = alloc_pipe_info();
+	if (!pi)
+		return -ENOMEM;
+	pi->readers = 1;
+
+	ret = sp->file->f_op->splice_read(sp->file, ppos, pi, sp->len, 0);
+	if (ret < 0)
+		goto done;
+
+	nr_pages = pipe_occupancy(pi->head, pi->tail);
+	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	if (!imu)
+		goto done;
+
+	ret = 0;
+	pipe_tail = pi->tail;
+	for (i = 0; !pipe_empty(pi->head, pipe_tail); i++) {
+		unsigned int mask = pi->ring_size - 1; // kill mask
+		struct pipe_buffer *buf = &pi->bufs[pipe_tail & mask];
+
+		bvec_set_page(&imu->bvec[i], buf->page, buf->len, buf->offset);
+		ret += buf->len;
+		pipe_tail++;
+	}
+	if (WARN_ON_ONCE(i != nr_pages))
+		return -EFAULT;
+
+	ctx = req->ctx;
+	io_ring_submit_lock(ctx, issue_flags);
+	if (unlikely(req->buf_index >= ctx->nr_user_bufs)) {
+		/* TODO: cleanup pages */
+		ret = -EFAULT;
+		kvfree(imu);
+		goto done_unlock;
+	}
+	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+	if (ctx->user_bufs[index] != ctx->dummy_ubuf) {
+		/* TODO: cleanup pages */
+		kvfree(imu);
+		ret = -EFAULT;
+		goto done_unlock;
+	}
+
+	imu->ubuf = 0;
+	imu->ubuf_end = ret;
+	imu->nr_bvecs = nr_pages;
+	ctx->user_bufs[index] = imu;
+done_unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+done:
+	free_pipe_info(pi);
+	if (ret != sp->len)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/splice.h b/io_uring/splice.h
index 542f94168ad3..abdf5ad8e8d2 100644
--- a/io_uring/splice.h
+++ b/io_uring/splice.h
@@ -5,3 +5,6 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags);
  
  int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
  int io_splice(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_splice_from_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_splice_from(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.39.1


