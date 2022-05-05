Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A85051C5AE
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343513AbiEERI1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 13:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245125AbiEERIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 13:08:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD6B4AE0C
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 10:04:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso4649248pjj.2
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=rXWsIQnWwnTUQnKv0nFYg7ghVoDY9SAWwWKxyJ6lurI=;
        b=BbhA3q6Km4lr3y/fVIQpsFVgyISR7PAXxS+wgKsuuU66UKUI215RqxrC5xKLeuS7Eu
         ZkjbcretsKtvwdEJYWbLcmbhcqLHveOo9V9ZeyAAjtpVF9cpsICZACBFuUZA76om/Uh3
         vL/HXnakRic5QeiNWmII0XNqc/tctpLUUj1yE3DQ1M9AHykreYmdKB5jMOx56NHExyIe
         8l/2W49rKOvk019VpU9XqvcJ34jxah1LZrli/xnG9KG/g9rI7dwPp1n44utg+FnNgbb4
         A5LO3DgxohwsjnJHS3xy3iX/HiaT2D9M3UR6Amgp2DnZP7eylUguju7fR+eKwCSPJ+Lk
         ittg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=rXWsIQnWwnTUQnKv0nFYg7ghVoDY9SAWwWKxyJ6lurI=;
        b=CTJkTTIlLgRRCbMTdl2tzKa69QnadocU5qFiBWusG856LYYYNPLoxy1rw9XsScHZso
         xN7JnfUjl9FEoqMKrqj/qGfSSxwnlhAUmjrlPxc4B+Ge6h/BhndLPC0qoccBkVWDej+J
         UMI1UZqjfP7wE1R7AeU6+H7yISL4NjHcI6B+hQutMwrh7zhV9GxOuqhseTH6zA4dHWb6
         /xuMtp9w7dKPU6i/J6zbcC4CM/SO0AoqlUh3W+1Xco82IDKU4yA0gjFBWqAg+Dje1oL4
         cSsuDE0vrnktQfDMiJJHxiPl0wuuTOYRBIo+wcO95lleoKb6D73CCI93P755As0CzkIP
         8Ncg==
X-Gm-Message-State: AOAM530HvZpcEn7HIFvJgQMpKmxRDj29W2o6cFfw07WEsQRG2VaJN49l
        T68qxDnLzdCAYa/+DMVMvaep0Q==
X-Google-Smtp-Source: ABdhPJz2WqbyxLLuVFh38hIhiuZzlOCL45ivQ9D0X8HBbwljI6d3XECw5qM2Hsq0XPqUnZimxgrNwA==
X-Received: by 2002:a17:903:22ce:b0:15e:bd57:5bec with SMTP id y14-20020a17090322ce00b0015ebd575becmr13010052plg.114.1651770283143;
        Thu, 05 May 2022 10:04:43 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id j8-20020a170903024800b0015e8d4eb210sm1814596plh.90.2022.05.05.10.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 10:04:42 -0700 (PDT)
Message-ID: <e41b6e82-3892-4e7f-c4d1-0d43e9739399@kernel.dk>
Date:   Thu, 5 May 2022 11:04:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
 <20220505060616.803816-2-joshi.k@samsung.com>
 <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
In-Reply-To: <1af73495-d4a6-d6fd-0a03-367016385c92@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 10:17 AM, Jens Axboe wrote:
> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>> +static int io_uring_cmd_prep(struct io_kiocb *req,
>> +			     const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +
>> +	if (ctx->flags & IORING_SETUP_IOPOLL)
>> +		return -EOPNOTSUPP;
>> +	/* do not support uring-cmd without big SQE/CQE */
>> +	if (!(ctx->flags & IORING_SETUP_SQE128))
>> +		return -EOPNOTSUPP;
>> +	if (!(ctx->flags & IORING_SETUP_CQE32))
>> +		return -EOPNOTSUPP;
>> +	if (sqe->ioprio || sqe->rw_flags)
>> +		return -EINVAL;
>> +	ioucmd->cmd = sqe->cmd;
>> +	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>> +	return 0;
>> +}
> 
> While looking at the other suggested changes, I noticed a more
> fundamental issue with the passthrough support. For any other command,
> SQE contents are stable once prep has been done. The above does do that
> for the basic items, but this case is special as the lower level command
> itself resides in the SQE.
> 
> For cases where the command needs deferral, it's problematic. There are
> two main cases where this can happen:
> 
> - The issue attempt yields -EAGAIN (we ran out of requests, etc). If you
>   look at other commands, if they have data that doesn't fit in the
>   io_kiocb itself, then they need to allocate room for that data and have
>   it be persistent
> 
> - Deferral is specified by the application, using eg IOSQE_IO_LINK or
>   IOSQE_ASYNC.
> 
> We're totally missing support for both of these cases. Consider the case
> where the ring is setup with an SQ size of 1. You prep a passthrough
> command (request A) and issue it with io_uring_submit(). Due to one of
> the two above mentioned conditions, the internal request is deferred.
> Either it was sent to ->uring_cmd() but we got -EAGAIN, or it was
> deferred even before that happened. The application doesn't know this
> happened, it gets another SQE to submit a new request (request B). Fills
> it in, calls io_uring_submit(). Since we only have one SQE available in
> that ring, when request A gets re-issued, it's now happily reading SQE
> contents from command B. Oops.
> 
> This is why prep handlers are the only ones that get an sqe passed to
> them. They are supposed to ensure that we no longer read from the SQE
> past that. Applications can always rely on that fact that once
> io_uring_submit() has been done, which consumes the SQE in the SQ ring,
> that no further reads are done from that SQE.
> 
> IOW, we need io_req_prep_async() handling for URING_CMD, which needs to
> allocate the full 80 bytes and copy them over. Subsequent issue attempts
> will then use that memory rather than the SQE parts. Just need to find a
> sane way to do that so we don't need to make the usual prep + direct
> issue path any slower.

This one should take care of that. Some parts should be folded into
patch 1, other bits into the nvme adoption.


diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8c3b15d3e86d..7daa95d50db1 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -411,8 +411,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 		struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 {
-	struct nvme_uring_cmd *cmd =
-		(struct nvme_uring_cmd *)ioucmd->cmd;
+	struct nvme_uring_cmd *cmd = ioucmd->cmd;
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_command c;
 	struct request *req;
@@ -548,8 +547,8 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return __nvme_ioctl(ns, cmd, (void __user *)arg);
 }
 
-static void nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
-		unsigned int issue_flags)
+static int nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
+			     unsigned int issue_flags)
 {
 	int ret;
 
@@ -567,15 +566,15 @@ static void nvme_ns_uring_cmd(struct nvme_ns *ns, struct io_uring_cmd *ioucmd,
 		ret = -ENOTTY;
 	}
 
-	if (ret != -EIOCBQUEUED)
-		io_uring_cmd_done(ioucmd, ret, 0);
+	return ret;
 }
 
-void nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
+int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 {
 	struct nvme_ns *ns = container_of(file_inode(ioucmd->file)->i_cdev,
 			struct nvme_ns, cdev);
-	nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
+
+	return nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
 }
 
 #ifdef CONFIG_NVME_MULTIPATH
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 761ad6c629c4..26adc7660d28 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -783,7 +783,7 @@ long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
 long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 		unsigned long arg);
-void nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
+int nvme_ns_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
 void nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 		unsigned int issue_flags);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index cf7087dc12b3..cee7fc95f2c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1251,6 +1251,8 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.needs_file		= 1,
 		.plug			= 1,
+		.async_size		= 2 * sizeof(struct io_uring_sqe) -
+					  offsetof(struct io_uring_sqe, cmd),
 	},
 };
 
@@ -4936,6 +4938,20 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+static int io_uring_cmd_prep_async(struct io_kiocb *req)
+{
+	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+	struct io_ring_ctx *ctx = req->ctx;
+	size_t cmd_size = sizeof(struct io_uring_sqe) -
+				offsetof(struct io_uring_sqe, cmd);
+
+	if (ctx->flags & IORING_SETUP_SQE128)
+		cmd_size += sizeof(struct io_uring_sqe);
+
+	memcpy(req->async_data, ioucmd->cmd, cmd_size);
+	return 0;
+}
+
 static int io_uring_cmd_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
@@ -4951,7 +4967,7 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 		return -EOPNOTSUPP;
 	if (sqe->ioprio || sqe->rw_flags)
 		return -EINVAL;
-	ioucmd->cmd = sqe->cmd;
+	ioucmd->cmd = (void *) sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
 }
@@ -4960,10 +4976,18 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct file *file = req->file;
 	struct io_uring_cmd *ioucmd = &req->uring_cmd;
+	int ret;
 
 	if (!req->file->f_op->uring_cmd)
 		return -EOPNOTSUPP;
-	file->f_op->uring_cmd(ioucmd, issue_flags);
+
+	if (req_has_async_data(req))
+		ioucmd->cmd = req->async_data;
+
+	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
+	if (ret != -EIOCBQUEUED)
+		io_uring_cmd_done(ioucmd, ret, 0);
+
 	return 0;
 }
 
@@ -7849,6 +7873,8 @@ static int io_req_prep_async(struct io_kiocb *req)
 		return io_recvmsg_prep_async(req);
 	case IORING_OP_CONNECT:
 		return io_connect_prep_async(req);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep_async(req);
 	}
 	printk_once(KERN_WARNING "io_uring: prep_async() bad opcode %d\n",
 		    req->opcode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 30c98d9993df..87b5af1d9fbe 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1996,7 +1996,7 @@ struct file_operations {
 				   struct file *file_out, loff_t pos_out,
 				   loff_t len, unsigned int remap_flags);
 	int (*fadvise)(struct file *, loff_t, loff_t, int);
-	void (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
+	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
 } __randomize_layout;
 
 struct inode_operations {
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index e4cbc80949ce..74371503478a 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -14,10 +14,11 @@ enum io_uring_cmd_flags {
 
 struct io_uring_cmd {
 	struct file	*file;
-	const u8	*cmd;
+	void		*cmd;
 	/* callback to defer completions to task context */
 	void (*task_work_cb)(struct io_uring_cmd *cmd);
 	u32		cmd_op;
+	u32		pad;
 	u8		pdu[32]; /* available inline for free use */
 };
 

-- 
Jens Axboe

