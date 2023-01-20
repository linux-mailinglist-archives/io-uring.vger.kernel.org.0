Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36F8674A7F
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 05:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjATEMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 23:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjATEMp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 23:12:45 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B902386EEF
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 20:12:44 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k18so4287456pll.5
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 20:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZBnQ7FD+GLFKN6GXmu4W2t9vwDu0xXnpxWvY6mSeA4s=;
        b=GsnOqDuuuICAhwmSxLZkEbc4GIABzMFjiDPuIH/bQ5WMoHXo5BbbWqMazvzHnikncc
         muE1u2CXH3woyNa48//09jrS1p9/TqHtkja+aBAwh10zUZeb+NOCOJRt3DrCDUqGN7Rw
         FjV/QyOL6/wQJuaWdwJZbXcUA6mpIrzYAcc+v85Rv9Ji7mb3aPF5NIniOyw+Sd/YLOg2
         gm4ZJfU2Jy0n4zFYXiSmbdQloItyFzojQ0c1guiYnDUbugXPtJcHP9BKkPXQ5/Xkd2uh
         UsQTdDU/o6nfnLHJUTKWaYMwwJFl2d+I6xcc486TozAPPll4m7AWo8OTkcEbCNCeOzzG
         t4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBnQ7FD+GLFKN6GXmu4W2t9vwDu0xXnpxWvY6mSeA4s=;
        b=rHP4LDF/vwjJf50PwdVMrOTRPs2WGm94WtYABXNyV4lO7Jb8TuBZCucWrWKaOVwP/a
         ylGE98vV50yF9aAa1iV/LodhLp0jOemW4wMc6Xl9uw+U+PsYeFW3S9SUH/jYlnCoeI4Q
         GBCPZSX9DwzINU3OU15yY5dVcE2fa1dUfPFOWrX3h3UpcUvkvRN7kX2FzwtJc6hHOPUv
         VRz6PKd21vCRilC8vrEWQOI6C83YEPTRdH2n/rI7vCkxvcGe6j8wATnX4aAWuI/Kmz9S
         ra1gJS6TMfjgfAV/S2h+09EDQhPOAjxM+nZZK0+ythfdG5ZyGX67l9aV0AAq3KKL4gVr
         FkZA==
X-Gm-Message-State: AFqh2krPdcmppRG4IRmlwxBZSGtesyQ1NAYh60GAB3Qs0lJrNmg1BXGW
        Uoiw8OFxkmje9/G68F+SRdsa+w==
X-Google-Smtp-Source: AMrXdXvGWwocmW2GztUyCgO7sw8uqS9q9xXK8/YoSzrW+R1YNdEW6fp+dQE3czlRWd87oRr9t0SKUA==
X-Received: by 2002:a05:6a21:6daa:b0:b8:5c45:a6dd with SMTP id wl42-20020a056a216daa00b000b85c45a6ddmr4383320pzb.3.1674187964164;
        Thu, 19 Jan 2023 20:12:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x16-20020a634a10000000b004812f798a37sm19532884pga.60.2023.01.19.20.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 20:12:43 -0800 (PST)
Message-ID: <af6f6d3d-b6ea-be46-d907-73fa4aea7b80@kernel.dk>
Date:   Thu, 19 Jan 2023 21:12:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Phoronix pts fio io_uring test regression report on upstream v6.1
 and v5.15
Content-Language: en-US
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, linux-kernel@vger.kernel.org
References: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/23 2:36?PM, Saeed Mirzamohammadi wrote:
> Hello,
>  
> I'm reporting a performance regression after the commit below on
> phoronix pts/fio test and with the config that is added in the end of
> this email:
> 
> Link: https://lore.kernel.org/all/20210913131123.597544850@linuxfoundation.org/
> 
> commit 7b3188e7ed54102a5dcc73d07727f41fb528f7c8
> Author: Jens Axboe axboe@kernel.dk
> Date:   Mon Aug 30 19:37:41 2021 -0600
>  
>     io_uring: IORING_OP_WRITE needs hash_reg_file set
>  
> We observed regression on the latest v6.1.y and v5.15.y upstream
> kernels (Haven't tested other stable kernels). We noticed that
> performance regression improved 45% after the revert of the commit
> above.
>  
> All of the benchmarks below have experienced around ~45% regression.
> phoronix-pts-fio-1.15.0-RandomWrite-EngineIO_uring-BufferedNo-DirectYes-BlockSize4KB-MB-s_xfs
> phoronix-pts-fio-1.15.0-SequentialWrite-EngineIO_uring-BufferedNo-DirectYes-BlockSize4KB-MB-s_xfs
> phoronix-pts-fio-1.15.0-SequentialWrite-EngineIO_uring-BufferedYes-DirectNo-BlockSize4KB-MB-s_xfs
>  
> We tend to see this regression on 4KB BlockSize tests.
>  
> We tried out changing force_async but that has no effect on the
> result. Also, backported a modified version of the patch mentioned
> here (https://lkml.org/lkml/2022/7/20/854) but that didn't affect
> performance.
>  
> Do you have any suggestions on any fixes or what else we can try to
> narrow down the issue?

This is really mostly by design - the previous approach of not hashing
buffered writes on regular files would cause a lot of inode lock
contention due to lots of threads hammering on that.

That said, for XFS, we don't need to serialize on O_DIRECT writes. Don't
think we currently have a way to detect this as it isn't really
advertised. Something like the below might work, with the caveat that
this is totally untested.


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 595a5bcf46b9..85fdc6f2efa4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1171,7 +1171,8 @@ xfs_file_open(
 {
 	if (xfs_is_shutdown(XFS_M(inode->i_sb)))
 		return -EIO;
-	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC;
+	file->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYNC |
+			FMODE_ODIRECT_PARALLEL;
 	return generic_file_open(inode, file);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c1769a2c5d70..8541b9e53c2d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -166,6 +166,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File supports DIRECT IO */
 #define	FMODE_CAN_ODIRECT	((__force fmode_t)0x400000)
 
+/* File supports parallel O_DIRECT writes */
+#define	FMODE_ODIRECT_PARALLEL	((__force fmode_t)0x800000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e680685e8a00..1409f6f69b13 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -424,7 +424,12 @@ static void io_prep_async_work(struct io_kiocb *req)
 		req->flags |= io_file_get_flags(req->file) << REQ_F_SUPPORT_NOWAIT_BIT;
 
 	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL))
+		bool should_hash = def->hash_reg_file;
+
+		if (should_hash && (req->file->f_flags & O_DIRECT) &&
+		    (req->file->f_mode & FMODE_ODIRECT_PARALLEL))
+			should_hash = false;
+		if (should_hash || (ctx->flags & IORING_SETUP_IOPOLL))
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)

-- 
Jens Axboe

