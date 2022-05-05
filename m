Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DCE51C8B8
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 21:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384305AbiEETOv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 15:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384337AbiEETOv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 15:14:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012AF1DA6B
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 12:11:10 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x52so4373998pfu.11
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 12:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=HXBtYNEiiGr36yW2oPCyC28YGPtQYlQmBj0I/dHrOhM=;
        b=OUAbkaks+yvM3DtQVdmaNUM1XSdBgNI0yzKqP27uXLLn/szGtmPaPtIxtTUkZyMb/Z
         D8OL2MZMesLq6doSNR9iEtiP3ehxbM2sSSVGqCscgzZQ3qBDlgd30F0YqdYm0/7Iqqsq
         fQNDjLrHU4E+eZAu0vHzdyvyRQuY3/A3y/IqgY5dKnPfI7hCm294RZEk3fEvrW1LDt20
         x2goc4Bv2WDyx6ZUOVop/O8s2SCHovptaQbjxcrWUjG7JeA+9IJNdbd+cZwfO1iWgYKw
         7lOW+NbG7ybtAXj4CvSo6v0Ffl+PGxilxLJTThUIadPsZtm+u5gsjMVDJRhqHnwECCbK
         8ufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=HXBtYNEiiGr36yW2oPCyC28YGPtQYlQmBj0I/dHrOhM=;
        b=iOF8hgbRAX0GC0rJ71ph91W4CC+WeapoyCE/DUn/EHlUuJO72YZ+UoOKGu545/n1vU
         Novh9gX+uQJgJXr40XKviJqPcoW8B/SF0l48sd9fcMtL5UgOA3aK+ZUKys5QPl5n6iDT
         paB7uGp77/U3fhlucLQu+n2x5eUEKXNNyDT8IJED8rXDVASfYKgS6gUbVZJTLja9GZGO
         xGHETyJGFGKOU5FJbv1NGDOajLebWrokKgkRpZRtbN266gYAH4NAHLzeFhZ/z2AJSXDQ
         +4iDOr7F1rcYlUJmyTWCiJ5HfkybKBcGKGuPnK+mPiaMGURnbkHlOFz125TtB270ahXr
         ISDg==
X-Gm-Message-State: AOAM533oQcU3ILLiLI+O1QqEA4vTvLFTZQu7hjSe/K+S7X7XAosr54Gd
        7OeGZx7OoXeg2m9Qpvro7+Tllw==
X-Google-Smtp-Source: ABdhPJzFCnYOZXGucw65UIthd+Nw8r8hqArXNb2HHgNadpWvS0eO30S5s5Av/G7fI6pV3uGkKSKw0Q==
X-Received: by 2002:a63:d00b:0:b0:3c1:6c87:2135 with SMTP id z11-20020a63d00b000000b003c16c872135mr22631515pgf.93.1651777870404;
        Thu, 05 May 2022 12:11:10 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 185-20020a6219c2000000b0050dc762815esm1715203pfz.56.2022.05.05.12.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 12:11:09 -0700 (PDT)
Message-ID: <93e697b1-42c5-d2f4-8fb8-7b5d1892e871@kernel.dk>
Date:   Thu, 5 May 2022 13:11:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 3/5] nvme: refactor nvme_submit_user_cmd()
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
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
 <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk>
In-Reply-To: <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk>
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

On 5/5/22 1:03 PM, Jens Axboe wrote:
> On 5/5/22 12:37 PM, Clay Mayers wrote:
>>> From: Kanchan Joshi
>>> Sent: Wednesday, May 4, 2022 11:06 PM
>>> ---
>>
>>>  drivers/nvme/host/ioctl.c | 47 ++++++++++++++++++++++++++++++++++-----
>>>  1 file changed, 42 insertions(+), 5 deletions(-)
>>>
>>> +static int nvme_execute_user_rq(struct request *req, void __user
>>> *meta_buffer,
>>> +		unsigned meta_len, u64 *result)
>>> +{
>>> +	struct bio *bio = req->bio;
>>> +	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
>>
>> I'm getting a NULL ptr access on the first ioctl(NVME_IOCTL_ADMIN64_CMD)
>> I send - it has no ubuffer so I think there's no req->bio.
> 
> Does this work?

This might be better, though you'd only notice if you had integrity
enabled. Christoph, I'm folding this in with patch 3...


diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8fe7ad18a709..3d827789b536 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -21,9 +21,13 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
 
 static inline void *nvme_meta_from_bio(struct bio *bio)
 {
-	struct bio_integrity_payload *bip = bio_integrity(bio);
+	if (bio) {
+		struct bio_integrity_payload *bip = bio_integrity(bio);
 
-	return bip ? bvec_virt(bip->bip_vec) : NULL;
+		return bip ? bvec_virt(bip->bip_vec) : NULL;
+	}
+
+	return NULL;
 }
 
 /*
@@ -205,19 +209,20 @@ static int nvme_execute_user_rq(struct request *req, void __user *meta_buffer,
 		unsigned meta_len, u64 *result)
 {
 	struct bio *bio = req->bio;
-	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
-	int ret;
 	void *meta = nvme_meta_from_bio(bio);
+	int ret;
 
 	ret = nvme_execute_passthru_rq(req);
 
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

