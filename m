Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B28A50CCCD
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 20:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiDWSFw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 14:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiDWSFv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 14:05:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19223BA47
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 11:02:53 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id s17so17859811plg.9
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 11:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=UyGwxpEHwjOeNK7nsbD+nSbBRyNPYH3KeEjdJDNtGtU=;
        b=YBdZveMRzPDUsd6GzNjblRbgtgiFcAKS/WXfQNj2dB1RpuxRkJyA+uv+OgtSpvx8la
         Ve3hiB77cxzwC08QMw0WK//hqWiiFaIRlTERV26ZSdzpdFRi+cZk9FYbrZ7L0FQRdO1X
         cu2f3F56i+2/0sknOr9Bjul+vJwJYkb5vu1LDofn08Dxn+LObO9twE6K5HgQFy/hpABg
         UTE8G5IYGjKFC6eHsI9azh4P28UA24cLderJpSC3cJ3nr1gP2HGF+qFMJpgXioRv9suy
         x3qXzQiwd8OBYmz3R3e/BfL9Aa8uYI2Y+4xDTbF7crbuAG3TzhM+9fMmMDweexq+zq4i
         Goog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=UyGwxpEHwjOeNK7nsbD+nSbBRyNPYH3KeEjdJDNtGtU=;
        b=duXEl+VbIn3Z0jccFcE2a/fY4vXluYAxlADQwnyt2t59wBMFlSFEOenI92TOvQcVkY
         cTRS1zbWvoqvKGCDC9wQnqi6EpFdBp1dg47NQ75/rGV703XPR4Ink6GrZaa3mbf59BgJ
         eG+2Gooo69Fy/IZXgjCj0Tk80dzRx88r8idcgmqN6PobFX9MASLJjnG2LAcCSH/yrbIU
         gUooy5gX91Y455uEMHysKI6gcSzjDDNTQnfJfOM/FRbrIrhtaR2HTX/QtzXGpb6vZk/l
         cNcOLPAuMnPjE0Rj/iUsYlZtiugXeyJ8+vSY55Gcb1e5qtgOZNmAJ/kVC/23hpWyx5SF
         4Ktw==
X-Gm-Message-State: AOAM531w2DQtWSu4BWdNl9J7pURRO2jc1YRa1BSa9SBJhd34/JBlc4tF
        AtIu/tIrBEXp7NeTexgL+MMeVe5s+AhhXXZL
X-Google-Smtp-Source: ABdhPJxFmjpG1hbL03iZzON8QSiPQQVj8zvTw5x7MNpItS1R/cuvujiG90cuVG4B05RKwBCxiq1bLA==
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id d22-20020a170902729600b0014b4bc60e81mr10190926pll.132.1650736973011;
        Sat, 23 Apr 2022 11:02:53 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b2-20020a056a000a8200b004e1414f0bb1sm6695850pfl.135.2022.04.23.11.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 11:02:52 -0700 (PDT)
Message-ID: <b5b7a49a-fc43-2af3-f3c8-988ea47ae986@kernel.dk>
Date:   Sat, 23 Apr 2022 12:02:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c663649e-674e-55d0-a59c-8f4b8f445bfa@kernel.dk>
 <27bf5faf-0b15-57dc-05ec-6a62cd789809@scylladb.com>
 <6041b513-0d85-c704-f1ae-c6657a3e680d@kernel.dk>
In-Reply-To: <6041b513-0d85-c704-f1ae-c6657a3e680d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/22 11:32 AM, Jens Axboe wrote:
>> I guess copy_to_user saves us from having to consider endianness.
> 
> I was considering that too, definitely something that should be
> investigated. Making it a 1/2/4/8 switch and using put_user() is
> probably a better idea. Easy enough to benchmark.

FWIW, this is the current version. Some quick benchmarking doesn't show
any difference between copy_to_user and put_user, but that may depend on
the arch as well (using aarch64). But we might as well use put user and
combine it with the length check, so we explicitly only support 1/2/4/8
sizes.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2052a796436c..3b94cb4b67ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -586,6 +586,14 @@ struct io_socket {
 	unsigned long			nofile;
 };
 
+struct io_mem {
+	struct file			*file;
+	u64				value;
+	void __user			*dest;
+	u32				len;
+	u32				flags;
+};
+
 struct io_sync {
 	struct file			*file;
 	loff_t				len;
@@ -962,6 +970,7 @@ struct io_kiocb {
 		struct io_msg		msg;
 		struct io_xattr		xattr;
 		struct io_socket	sock;
+		struct io_mem		mem;
 	};
 
 	u8				opcode;
@@ -1231,16 +1240,19 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 	},
 	[IORING_OP_FSETXATTR] = {
-		.needs_file = 1
+		.needs_file		= 1,
 	},
 	[IORING_OP_SETXATTR] = {},
 	[IORING_OP_FGETXATTR] = {
-		.needs_file = 1
+		.needs_file		= 1,
 	},
 	[IORING_OP_GETXATTR] = {},
 	[IORING_OP_SOCKET] = {
 		.audit_skip		= 1,
 	},
+	[IORING_OP_MEMCPY] = {
+		.audit_skip		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -5527,6 +5539,71 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_memcpy_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_mem *mem = &req->mem;
+
+	if (unlikely(sqe->ioprio || sqe->buf_index || sqe->splice_fd_in))
+		return -EINVAL;
+
+	mem->value = READ_ONCE(sqe->off);
+	mem->dest = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mem->len = READ_ONCE(sqe->len);
+	if (!mem->len || mem->len > sizeof(u64))
+		return -EINVAL;
+
+	mem->flags = READ_ONCE(sqe->memcpy_flags);
+	if (mem->flags & ~IORING_MEMCPY_IMM)
+		return -EINVAL;
+
+	/* only supports immediate mode for now */
+	if (!(mem->flags & IORING_MEMCPY_IMM))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int io_memcpy(struct io_kiocb *req)
+{
+	struct io_mem *mem = &req->mem;
+	int ret = mem->len;
+
+	switch (mem->len) {
+	case 1: {
+		u8 val = mem->value;
+		if (put_user(val, (u8 *) mem->dest))
+			ret = -EFAULT;
+		break;
+		}
+	case 2: {
+		u16 val = mem->value;
+		if (put_user(val, (u16 *) mem->dest))
+			ret = -EFAULT;
+		break;
+		}
+	case 4: {
+		u32 val = mem->value;
+		if (put_user(val, (u32 *) mem->dest))
+			ret = -EFAULT;
+		break;
+		}
+	case 8: {
+		u64 val = mem->value;
+		if (put_user(val, (u64 *) mem->dest))
+			ret = -EFAULT;
+		break;
+		}
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 #if defined(CONFIG_NET)
 static bool io_net_retry(struct socket *sock, int flags)
 {
@@ -7494,6 +7571,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_getxattr_prep(req, sqe);
 	case IORING_OP_SOCKET:
 		return io_socket_prep(req, sqe);
+	case IORING_OP_MEMCPY:
+		return io_memcpy_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -7815,6 +7894,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SOCKET:
 		ret = io_socket(req, issue_flags);
 		break;
+	case IORING_OP_MEMCPY:
+		ret = io_memcpy(req);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5fb52bf32435..9e69d70a3b5b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -46,6 +46,7 @@ struct io_uring_sqe {
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
+		__u32		memcpy_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -152,6 +153,7 @@ enum {
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
+	IORING_OP_MEMCPY,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -206,6 +208,14 @@ enum {
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 
+/*
+ * IORING_OP_MEMCPY flags.
+ *
+ * IORING_MEMCPY_IMM		Immediate copy. 'off' contains an immediate
+ *				value. If not set, 'off' is a source address.
+ */
+#define IORING_MEMCPY_IMM	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */

-- 
Jens Axboe

