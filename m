Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E0151C89F
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 21:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbiEETHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 15:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiEETHD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 15:07:03 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AEB4B1D4
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 12:03:19 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso4896480pjb.5
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 12:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aP+sRyqjiJck3nF00KFz6cvLIN38Ozm1Q/g2weDJD/c=;
        b=nuTXi4Gks8zLZQTUikN10ntUHm93mhBNnjy6gt1M7Uah/Dxdvs4vjo75/q/ZdnipWm
         jzppcJIQkTx987/dZIGj31IqkwC/MZHBHGLemoJ4OV0JCLxDmAjG2Qq/zwc/hDZ1I/sA
         AUvr3W6ouV7Bx/bPPxsTOkHCRw3iGg2f3FtFI8gR0sPKssVP/S2Z8m0VXKzX4c+UbFUi
         sd1+I45O8pusIMnmRlB6bsz2U9wcmnXYM8pDVjsVu0GXVo5Sy+wd3Yw/qYwgCcQdlSLg
         mUU1+AhKMZzxaU4cMa2iyAMKIDN/o1t8SO3t7t1J1UhDkgnI13tC0X9bQUfYgTf3ODnl
         x4FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aP+sRyqjiJck3nF00KFz6cvLIN38Ozm1Q/g2weDJD/c=;
        b=FGxZPPYDeRHLvT4alPKwf3Klv+5DoEAKiRmtMPioTLeTsn03X7ketPyNop0t9J9AGQ
         6CUBetbIF9lrkRc8YC6hGMAWg/hQHRojxvYsHmqtlRvFYVSIAucWpB3t4o3UtzfzipnL
         sBYrHMXANJYknLMsmP1r4vp6Ql0LKgNnPf8ow+5ZbLMn0ACTzSd+RMUNIVpIy5gVk8Xq
         BO/ZRZS54IeIcrTGGMxVfERL5+FHfxV1aWjmazgcM51JdgeGYFBc6/LPX7Q0fx/2z6OF
         /mgnuv4yxxlpI/ffD1F7p1vN2zrlZJU33X0bukRj/LBbzphxTGSYX6iu2iakoJAHz8NW
         KVLw==
X-Gm-Message-State: AOAM531vfo2ZDQTsLoSxqoXRLAJsaKxq4HTqKaW39fiFwwww6LFQEIMb
        F1P/RnFL36VjNx1d/YL4LxAT2A==
X-Google-Smtp-Source: ABdhPJzDmj6HX/+1D0KDhpk6zS+5xDYteqaTRmNPNypBuaLzlwXlzfKr6TghC+yZ9YL2/KhcyNlEpQ==
X-Received: by 2002:a17:903:244e:b0:15e:b3f7:9509 with SMTP id l14-20020a170903244e00b0015eb3f79509mr16796803pls.42.1651777399239;
        Thu, 05 May 2022 12:03:19 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x5-20020a170902b40500b0015e8d4eb29bsm1875955plr.229.2022.05.05.12.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 12:03:18 -0700 (PDT)
Message-ID: <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk>
Date:   Thu, 5 May 2022 13:03:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Content-Language: en-US
To:     Clay Mayers <Clay.Mayers@kioxia.com>,
        Kanchan Joshi <joshi.k@samsung.com>, "hch@lst.de" <hch@lst.de>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>, "shr@fb.com" <shr@fb.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061148epcas5p188618b5b15a95cbe48c8c1559a18c994@epcas5p1.samsung.com>
 <20220505060616.803816-4-joshi.k@samsung.com>
 <80cde2cfd566454fa4b160492c7336c2@kioxia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <80cde2cfd566454fa4b160492c7336c2@kioxia.com>
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

On 5/5/22 12:37 PM, Clay Mayers wrote:
>> From: Kanchan Joshi
>> Sent: Wednesday, May 4, 2022 11:06 PM
>> ---
> 
>>  drivers/nvme/host/ioctl.c | 47 ++++++++++++++++++++++++++++++++++-----
>>  1 file changed, 42 insertions(+), 5 deletions(-)
>>
>> +static int nvme_execute_user_rq(struct request *req, void __user
>> *meta_buffer,
>> +		unsigned meta_len, u64 *result)
>> +{
>> +	struct bio *bio = req->bio;
>> +	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
> 
> I'm getting a NULL ptr access on the first ioctl(NVME_IOCTL_ADMIN64_CMD)
> I send - it has no ubuffer so I think there's no req->bio.

Does this work?

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8fe7ad18a709..f615a791a7cd 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -205,7 +205,6 @@ static int nvme_execute_user_rq(struct request *req, void __user *meta_buffer,
 		unsigned meta_len, u64 *result)
 {
 	struct bio *bio = req->bio;
-	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
 	int ret;
 	void *meta = nvme_meta_from_bio(bio);
 
@@ -213,11 +212,13 @@ static int nvme_execute_user_rq(struct request *req, void __user *meta_buffer,
 
 	if (result)
 		*result = le64_to_cpu(nvme_req(req)->result.u64);
-	if (meta && !ret && !write) {
-		if (copy_to_user(meta_buffer, meta, meta_len))
+	if (meta) {
+		bool write = bio_op(bio) == REQ_OP_DRV_OUT;
+
+		if (!ret && !write && copy_to_user(meta_buffer, meta, meta_len))
 			ret = -EFAULT;
+		kfree(meta);
 	}
-	kfree(meta);
 	if (bio)
 		blk_rq_unmap_user(bio);
 	blk_mq_free_request(req);

-- 
Jens Axboe

