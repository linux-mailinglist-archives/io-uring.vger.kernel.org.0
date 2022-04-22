Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA6950BB29
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 17:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343540AbiDVPGt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 11:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239807AbiDVPGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 11:06:46 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9069C5D1A1
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 08:03:52 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q22so8888487iod.2
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 08:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=YIC0IgpNUwDiaqrsr1zXGxypumrpev074mU8xkd2648=;
        b=qyp+i6phisTCwo3uyUsarW7UpNNaQU24vBMuZsjwqMbTrfGV1sVrrEhouhtXygYYU5
         uhEU7UatCU0qgLp7V57z2WFPCvs37234ad9mYIT08/cS2SRO3SQMl/xUr4mFbHvWyBQg
         ufhAKGikgP18n9E/Zv4UIsnQKr+vK4BTcVTLoGXDay3gZ4bAZQO2HvARVqzflgUF9knt
         G7p0zvhJX3XK5013OgaRG29ZTveuASSKu/T/tzNNuEQtJ1b1kADotfcMos/sucfcnXFL
         p9FTOo5VTxob1yBIC+nvH0iE+50DDuTGe6hyku691RTk5PZVXyIdBOYzr8oltvh12Ss6
         PL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=YIC0IgpNUwDiaqrsr1zXGxypumrpev074mU8xkd2648=;
        b=r0T9Ige80A/tu2P2FyVgUSexmSbvk/J0/Dexp+L7kKhW9h4y5AajUsrwVmR3dRu26C
         iv/9zrAu4PneIpiULOb19nR/hBK6cCUeiP6BDdQCr3Hwrghaqwr0NS7dN9YAWQre8/l1
         fonnMJWZ5QBtZWH+ratIS++zZf8zAHEgX96Tvsuq9HdN/4qUw5RlXea7q37APrSGqBCH
         Wum5rR7sBPB6ePs7j/uOMpfYwANGGlEMU1QL0DXszmBgMdXLI051cYzp7WMigex4cDL/
         LnOb7b1npYqixLhBKNUC2YxkohtR7qacje+cvsZZjRm4EMFgAmzABfMMTSdrb1WesuPG
         a43Q==
X-Gm-Message-State: AOAM533534tQM9vjo6FchLdopCF9lGrjS7A3mAxyMpCxw+LVwlMbPenv
        ofXFaQPDOPMezXG/QQtqOA65Gcq9W/RIXA==
X-Google-Smtp-Source: ABdhPJwg8akpWgC+LQMVo058Mj+jIIJcJCLlFV3VPm3Wt8s1n2SYolSeJvADhsSJGer3etGeysmcvw==
X-Received: by 2002:a05:6638:3794:b0:32a:9f1e:a1d0 with SMTP id w20-20020a056638379400b0032a9f1ea1d0mr2173095jal.257.1650639831904;
        Fri, 22 Apr 2022 08:03:51 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b14-20020a056e020c8e00b002cbf1ce218asm1474685ile.64.2022.04.22.08.03.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 08:03:51 -0700 (PDT)
Message-ID: <c663649e-674e-55d0-a59c-8f4b8f445bfa@kernel.dk>
Date:   Fri, 22 Apr 2022 09:03:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
In-Reply-To: <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/22 8:50 AM, Jens Axboe wrote:
> On 4/13/22 4:33 AM, Avi Kivity wrote:
>> Unfortunately, only ideas, no patches. But at least the first seems very easy.
>>
>>
>> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op
>> itself (1-8 bytes) to a user memory location specified by the op.
>>
>>
>> Linked to another op, this can generate an in-memory notification
>> useful for busy-waiters or the UMWAIT instruction
>>
>> This would be useful for Seastar, which looks at a timer-managed
>> memory location to check when to break computation loops.
> 
> This one would indeed be trivial to do. If we limit the max size
> supported to eg 8 bytes like suggested, then it could be in the sqe
> itself and just copied to the user address specified.
> 
> Eg have sqe->len be the length (1..8 bytes), sqe->addr the destination
> address, and sqe->off the data to copy.
> 
> If you'll commit to testing this, I can hack it up pretty quickly...

Something like this, totally untested. Maybe the return value should be
bytes copied? Just returns 0/error right now.

Follows the above convention.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2052a796436c..d2a95f9d9d2d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -586,6 +586,13 @@ struct io_socket {
 	unsigned long			nofile;
 };
 
+struct io_mem {
+	struct file			*file;
+	u64				value;
+	void __user			*dest;
+	u32				len;
+};
+
 struct io_sync {
 	struct file			*file;
 	loff_t				len;
@@ -962,6 +969,7 @@ struct io_kiocb {
 		struct io_msg		msg;
 		struct io_xattr		xattr;
 		struct io_socket	sock;
+		struct io_mem		mem;
 	};
 
 	u8				opcode;
@@ -1231,16 +1239,19 @@ static const struct io_op_def io_op_defs[] = {
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
+	[IORING_OP_MEMCPY_IMM] = {
+		.audit_skip		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -5527,6 +5538,38 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_memcpy_imm_prep(struct io_kiocb *req,
+			      const struct io_uring_sqe *sqe)
+{
+	struct io_mem *mem = &req->mem;
+
+	if (unlikely(sqe->ioprio || sqe->rw_flags || sqe->buf_index ||
+		     sqe->splice_fd_in))
+		return -EINVAL;
+
+	mem->value = READ_ONCE(sqe->off);
+	mem->dest = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	mem->len = READ_ONCE(sqe->len);
+	if (!mem->len || mem->len > sizeof(u64))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int io_memcpy_imm(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_mem *mem = &req->mem;
+	int ret = 0;
+
+	if (copy_to_user(mem->dest, &mem->value, mem->len))
+		ret = -EFAULT;
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
@@ -7494,6 +7537,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_getxattr_prep(req, sqe);
 	case IORING_OP_SOCKET:
 		return io_socket_prep(req, sqe);
+	case IORING_OP_MEMCPY_IMM:
+		return io_memcpy_imm_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -7815,6 +7860,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_SOCKET:
 		ret = io_socket(req, issue_flags);
 		break;
+	case IORING_OP_MEMCPY_IMM:
+		ret = io_memcpy_imm(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 5fb52bf32435..853f00a2bddd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -152,6 +152,7 @@ enum {
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
 	IORING_OP_SOCKET,
+	IORING_OP_MEMCPY_IMM,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,

-- 
Jens Axboe

