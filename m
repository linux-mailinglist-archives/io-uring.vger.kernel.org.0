Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9A5764CC
	for <lists+io-uring@lfdr.de>; Fri, 15 Jul 2022 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiGOP63 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jul 2022 11:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiGOP62 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jul 2022 11:58:28 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D866A9DB
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 08:58:27 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id a12so2703081ilp.13
        for <io-uring@vger.kernel.org>; Fri, 15 Jul 2022 08:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=njHUUTRkwNmezhjrHml0mpe3Yz515QMHQkK9aErxP34=;
        b=HNVXW1r1X+A7eh+QQhT/jKYYaWKylGxr9yzFRK/bECvW8S+9f6RpcR2ig3YUEbqjg2
         izLKurM2kjUOn12ZTHxWvTiE7W/NTbQkOROc4shmRYtOO35gETP9LoazMvRlUhpyqiIF
         Ng9ROxuXXVhoVojpT2lWG2rTlQe4hiDUnF6KThJqac1YVNEIKUGdMxFlvZDaL4GKdrbE
         JaAFV8cTYnKnpAEp3rJGzO+9und1R9Iu3QlqGhYO2nPRnbBgsK8m133VN9fJ2nagL1F/
         9JhrzJzCRtMLvSoHbg9UU/0Nr5sutj2nlgiK9uBV0pZx/LQR0QyNdMGYv6aTDsV/O+7j
         UNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=njHUUTRkwNmezhjrHml0mpe3Yz515QMHQkK9aErxP34=;
        b=kPs+McYvIJz7Ehog3UCJOosAx3remXjj8x2B4EjLKCUguSqV8gh0EgV468x1JSeMJ0
         TXr80j+3zpyzkk37fFoFOG0v9BSWowR+iG7b/BMbglG7OSwCnbTiajviraaek2b1U9s8
         wNrCDJbjN0w3QrMfohnbFzeFpaL2djj8ynmdzrefN5AroTTYia6OuAcRTP/VuK+GnabV
         IZPD3R0LCyD/e8c0BaaSU1f34FKhMWDv8U9At4XwrTGNS2imBL8SwOBF0q0UFVvzQKY+
         FcZFlUpNI/Gr7YKWzEf0ce5N9UJmgEqpUDvEWCMUVbGSr0Bk9ZJ+gAIicxs/hDlzdRtx
         jHsg==
X-Gm-Message-State: AJIora8HoYPVSmB5zCJ8xRNDRpgHfsQxzO/XwA/yjbA09e1NuEvfjL2c
        CYHq0W9Shi9I810GLUIobcS4rw==
X-Google-Smtp-Source: AGRyM1vfYuTFCuR3ahysJXP4YouQC50dvGwPmjhXLczZkazqXOvo9kytNyAd01U6EKPYOpWy9M9nDw==
X-Received: by 2002:a05:6e02:190a:b0:2dc:852c:bb4a with SMTP id w10-20020a056e02190a00b002dc852cbb4amr7721800ilu.208.1657900706818;
        Fri, 15 Jul 2022 08:58:26 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f96-20020a0284e9000000b0033cbbf0b762sm2089065jai.116.2022.07.15.08.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 08:58:26 -0700 (PDT)
Message-ID: <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
Date:   Fri, 15 Jul 2022 09:58:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
 <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
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

On 7/12/22 2:06 AM, Yin Fengwei wrote:
> Hi Jens,
> 
> On 5/27/2022 9:50 PM, Jens Axboe wrote:
>> I'm a bit skeptical on this, but I'd like to try and run the test case.
>> Since it's just a fio test case, why can't I find it somewhere? Seems
>> very convoluted to have to setup lkp-tests just for this. Besides, I
>> tried, but it doesn't work on aarch64...
> Recheck this regression report. The regression could be reproduced if
> the following config file is used with fio (tag: fio-3.25) :
> 
> 	[global]
> 	rw=write
> 	ioengine=io_uring
> 	iodepth=64
> 	size=1g
> 	direct=1
> 	buffered=1
> 	startdelay=5
> 	force_async=4
> 	ramp_time=5
> 	runtime=20
> 	time_based
> 	clat_percentiles=0
> 	disable_lat=1
> 	disable_clat=1
> 	disable_slat=1
> 	filename=test_fiofile
> 	[test]
> 	name=test
> 	bs=1M
> 	stonewall
> 
> Just FYI, a small change to commit: 584b0180f0f4d67d7145950fe68c625f06c88b10:
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 969f65de9972..616d857f8fc6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3181,8 +3181,13 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>         struct kiocb *kiocb = &req->rw.kiocb;
>         unsigned ioprio;
> +       struct file *file = req->file;
>         int ret;
> 
> +       if (likely(file && (file->f_mode & FMODE_WRITE)))
> +               if (!io_req_ffs_set(req))
> +                       req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
> +
>         kiocb->ki_pos = READ_ONCE(sqe->off);
> 
>         ioprio = READ_ONCE(sqe->ioprio);
> 
> could make regression gone. No idea how req->flags impact the write
> performance. Thanks.

I can't really explain that either, at least not immediately. I tried
running with and without that patch, and don't see any difference here.
In terms of making this more obvious, does the below also fix it for
you?

And what filesystem is this being run on?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index a01ea49f3017..797fad99780d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4269,9 +4269,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	if (unlikely(!file || !(file->f_mode & mode)))
 		return -EBADF;
 
-	if (!io_req_ffs_set(req))
-		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
-
 	kiocb->ki_flags = iocb_flags(file);
 	ret = kiocb_set_rw_flags(kiocb, req->rw.flags);
 	if (unlikely(ret))
@@ -8309,7 +8306,13 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		req->file = io_file_get_normal(req, req->cqe.fd);
 
-	return !!req->file;
+	if (unlikely(!req->file))
+		return false;
+
+	if (!io_req_ffs_set(req))
+		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
+
+	return true;
 }
 
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)

-- 
Jens Axboe

