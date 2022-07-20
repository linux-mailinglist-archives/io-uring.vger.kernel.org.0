Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9023D57BD7C
	for <lists+io-uring@lfdr.de>; Wed, 20 Jul 2022 20:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiGTSNc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 14:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiGTSNb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 14:13:31 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AE162A6E
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 11:13:29 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id l11so7561364ilf.11
        for <io-uring@vger.kernel.org>; Wed, 20 Jul 2022 11:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=S+VXSDukK/OTHYC9Ft1p/BhMJLNvQaxCO1/JBdZMGJs=;
        b=hYQeNc+oyCrGVU4f9RAI8Nn50VyYg4YpCSGf7qKSdKgOQUDa+FnT43nLvhTSSWz8AA
         M85+Q0y+QcgIiM8soJhZUTxkB+M8asRc6yYzV62rRye0c/TGTveat0r2cMg4k2VYPkVa
         2wsqFiC9mSm8XnUpWpfHhFUXgJL51CX5k7hvzZ4jKSg0+kRG0zDscIy+IVUJtJveNs+E
         XahYG609Djq33GFdY+zC3sUCOa3N9ZbZ0lFXp2xMUfvdVeRi529XGfeZAZITF6vx5Sje
         mRwU239C/ilIokBmvZtFMEakGmJoeIu9hGjUVQdgAwrtryY4bKLtiB+JjLM5YhbdnH2E
         4A1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=S+VXSDukK/OTHYC9Ft1p/BhMJLNvQaxCO1/JBdZMGJs=;
        b=PxlPabbkI17w6+2JLfUGpc78mEsHZ7LjVS6ZGvt8lVkB2NB1YyeWVyk7hNqqe0sFyH
         /mRYQygWNDC2buBh+bfSJxTyH4toIbi9AjEVsdSELcRA+WDyL/OAR8o+Yq4LwaEImPAe
         s+4KbnB4e+0vowwXD2wVD4pAqJEFwLYIsKtVaHu2HdG+aBTFAf5b5YZyZHBTG3QcwiRY
         uXNwbGnTv14ZHr3lO2Wy04eD7bO7LTqK7YOyvZ0peTgcdocg4j3oupGBFRQKLsHXVdrI
         ZLUhDfy78UhZdi7kPo1w0pbetOrKYudfJZlVdM5CkLhKhvOvUnaBYe28NhbpJ+ZuuFyv
         eg0w==
X-Gm-Message-State: AJIora9GUVbL+XMmYd3u6PJ6093M+Y+fIM4AyclVAFdgrwNA3wPiw07d
        pbs0WjFriB3IH+sVBRlf+g7heA==
X-Google-Smtp-Source: AGRyM1v0IJKF0tr2iNyZHtKrEfIRLGpdvqdFhEbVEGnVlASdYTKp002nRoONGTP3htZ4Rv84nDfFbQ==
X-Received: by 2002:a05:6e02:16c7:b0:2dd:d67:f39d with SMTP id 7-20020a056e0216c700b002dd0d67f39dmr1293394ilx.316.1658340808839;
        Wed, 20 Jul 2022 11:13:28 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d6-20020a92d5c6000000b002dc0ddef9cfsm7126181ilq.73.2022.07.20.11.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 11:13:28 -0700 (PDT)
Message-ID: <299889df-db40-e0e2-6bc6-d9eb784ebe89@kernel.dk>
Date:   Wed, 20 Jul 2022 12:13:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
 <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
 <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
 <9df150bb-f4fd-7857-aea8-b2c7a06a8791@intel.com>
 <7146c853-0ff8-3c92-c872-ce6615baab40@kernel.dk>
 <81af5cdf-1a13-db2c-7b7b-cfd86f1271e6@intel.com>
 <74d1f308-de03-fd5e-b7f0-0e17980f988e@kernel.dk>
 <2ec953da-78fd-df01-44cf-6f33a5e40864@intel.com>
 <f5d20f6c-5363-231b-b208-b577a59b4ae9@kernel.dk>
In-Reply-To: <f5d20f6c-5363-231b-b208-b577a59b4ae9@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/22 11:24 AM, Jens Axboe wrote:
> On 7/19/22 2:58 AM, Yin Fengwei wrote:
>> Hi Jens,
>>
>> On 7/19/2022 10:29 AM, Jens Axboe wrote:
>>> I'll poke at this tomorrow.
>>
>> Just FYI. Another finding (test is based on commit 584b0180f0):
>> If the code block is put to different function, the fio performance result is
>> different:
> 
> I think this turned out to be a little bit of a goose chase. What's
> happening here is that later kernels defer the file assignment, which
> means it isn't set if a request is queued with IOSQE_ASYNC. That in
> turn, for writes, means that we don't hash it on io-wq insertion, and
> then it doesn't get serialized with other writes to that file.
> 
> I'll come up with a patch for this that you can test.

Can you try this? It's against 5.19-rc7.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01ea49f3017..34758e95990a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2015,6 +2015,64 @@ static inline void io_arm_ltimeout(struct io_kiocb *req)
 		__io_arm_ltimeout(req);
 }
 
+static bool io_bdev_nowait(struct block_device *bdev)
+{
+	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
+}
+
+/*
+ * If we tracked the file through the SCM inflight mechanism, we could support
+ * any file. For now, just ensure that anything potentially problematic is done
+ * inline.
+ */
+static bool __io_file_supports_nowait(struct file *file, umode_t mode)
+{
+	if (S_ISBLK(mode)) {
+		if (IS_ENABLED(CONFIG_BLOCK) &&
+		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
+			return true;
+		return false;
+	}
+	if (S_ISSOCK(mode))
+		return true;
+	if (S_ISREG(mode)) {
+		if (IS_ENABLED(CONFIG_BLOCK) &&
+		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
+		    file->f_op != &io_uring_fops)
+			return true;
+		return false;
+	}
+
+	/* any ->read/write should understand O_NONBLOCK */
+	if (file->f_flags & O_NONBLOCK)
+		return true;
+	return file->f_mode & FMODE_NOWAIT;
+}
+
+static inline bool io_file_supports_nowait(struct io_kiocb *req)
+{
+	return req->flags & REQ_F_SUPPORT_NOWAIT;
+}
+
+/*
+ * If we tracked the file through the SCM inflight mechanism, we could support
+ * any file. For now, just ensure that anything potentially problematic is done
+ * inline.
+ */
+static unsigned int io_file_get_flags(struct file *file)
+{
+	umode_t mode = file_inode(file)->i_mode;
+	unsigned int res = 0;
+
+	if (S_ISREG(mode))
+		res |= FFS_ISREG;
+	if (__io_file_supports_nowait(file, mode))
+		res |= FFS_NOWAIT;
+	if (io_file_need_scm(file))
+		res |= FFS_SCM;
+	return res;
+}
+
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -2031,6 +2089,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
+	if (req->file && !io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
 	if (req->flags & REQ_F_ISREG) {
 		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
@@ -3556,64 +3617,6 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	}
 }
 
-static bool io_bdev_nowait(struct block_device *bdev)
-{
-	return !bdev || blk_queue_nowait(bdev_get_queue(bdev));
-}
-
-/*
- * If we tracked the file through the SCM inflight mechanism, we could support
- * any file. For now, just ensure that anything potentially problematic is done
- * inline.
- */
-static bool __io_file_supports_nowait(struct file *file, umode_t mode)
-{
-	if (S_ISBLK(mode)) {
-		if (IS_ENABLED(CONFIG_BLOCK) &&
-		    io_bdev_nowait(I_BDEV(file->f_mapping->host)))
-			return true;
-		return false;
-	}
-	if (S_ISSOCK(mode))
-		return true;
-	if (S_ISREG(mode)) {
-		if (IS_ENABLED(CONFIG_BLOCK) &&
-		    io_bdev_nowait(file->f_inode->i_sb->s_bdev) &&
-		    file->f_op != &io_uring_fops)
-			return true;
-		return false;
-	}
-
-	/* any ->read/write should understand O_NONBLOCK */
-	if (file->f_flags & O_NONBLOCK)
-		return true;
-	return file->f_mode & FMODE_NOWAIT;
-}
-
-/*
- * If we tracked the file through the SCM inflight mechanism, we could support
- * any file. For now, just ensure that anything potentially problematic is done
- * inline.
- */
-static unsigned int io_file_get_flags(struct file *file)
-{
-	umode_t mode = file_inode(file)->i_mode;
-	unsigned int res = 0;
-
-	if (S_ISREG(mode))
-		res |= FFS_ISREG;
-	if (__io_file_supports_nowait(file, mode))
-		res |= FFS_NOWAIT;
-	if (io_file_need_scm(file))
-		res |= FFS_SCM;
-	return res;
-}
-
-static inline bool io_file_supports_nowait(struct io_kiocb *req)
-{
-	return req->flags & REQ_F_SUPPORT_NOWAIT;
-}
-
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct kiocb *kiocb = &req->rw.kiocb;

-- 
Jens Axboe

