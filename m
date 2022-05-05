Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB69F51C919
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 21:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351650AbiEETfR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 15:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384580AbiEETfP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 15:35:15 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067605AA70
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 12:31:31 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id p8so4419461pfh.8
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 12:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZEAB8wH7RODaxSZEgSNpHeJCOEOxRXAyc6C3j1SfBxA=;
        b=gc0UXxI7Q+lfWYxT1o7dy9a9Pt/3hwfBFDEeuF60JuWDX/yY5Sbd6m5eH2YTD8T/KA
         NMGy6vCTG7hmTan8VG/F/icYR2UahTeapqF24LtgkXBvSlqemWBCH6hRMwRewo2ccqWd
         340H9o7vu2I4MGZng8GXrUoSl+R+ooW2LWvSfa0iyaMJTfZALhdMXKMQ0tTY13iHSg4T
         PfcJ2jN+DbONnkeix+M9Pf11GozqSexcxjFkmIN6gXFZ0M3YOKDy86R4ZXc2hFisYVWI
         lj+4Jt9yvpqsKu6rFNlAYL8hFasdVWj1ZebnJmvayTl1KakvICr/hvERSDNw5wyS4JzC
         g+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZEAB8wH7RODaxSZEgSNpHeJCOEOxRXAyc6C3j1SfBxA=;
        b=QCo9u0YYfq4+AOBds+R1xRMT2W6dpxVhC8f6OLTbYBLrW8fs/NoNi/EF+6f3qIyF3E
         dmmm98OCaKfPTXsAiQBckQmTBhFg1Hdtl15E/dmpvxZ1tSOTzO5tDD3UmL0eI//og2zw
         wmRC1oumCuZfHiqdaocq8ubFNzxHB55aaLAoycBo4RAnxYs1JD2G8dRoCi2ueoCD1/qe
         5SRliY30kxDyZ2pPx+AP0wuMs8wjNB/VgOi0o2reIjPgNZqsmlvQ+8c3FBl+zWL90K/o
         mEg7cIQ81Wclnz6+FUuw7i2kuucle3KrcifOXzm4QWWzBXhWORcsAuH1UZ5lYY8wIueL
         uS/Q==
X-Gm-Message-State: AOAM5305xPX41+iXTWtgqcxkfu32tiqrMWfY0SuMXH2CP3Ra8StdSRKJ
        Ep3Ij744sRQwBw8Gr8k67S+cpA==
X-Google-Smtp-Source: ABdhPJwjeiwyGM8boT8FGrOO6e37KkyrsRzio67EZeHbJZ5rsApIS7H40f94mJ8q5n6dEotsAlT1yw==
X-Received: by 2002:a63:f44f:0:b0:3c1:ed4f:b066 with SMTP id p15-20020a63f44f000000b003c1ed4fb066mr20583437pgk.334.1651779091408;
        Thu, 05 May 2022 12:31:31 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id gg7-20020a17090b0a0700b001d97f17f9b5sm5726220pjb.35.2022.05.05.12.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 12:31:30 -0700 (PDT)
Message-ID: <70c1a8d3-ed82-0a5b-907a-7d6bedd73ccc@kernel.dk>
Date:   Thu, 5 May 2022 13:31:28 -0600
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
 <ce25812c-9cf4-efe5-ac9e-13afd5803e64@kernel.dk>
 <93e697b1-42c5-d2f4-8fb8-7b5d1892e871@kernel.dk>
 <0b16682a30434d9c820a888ae0dc9ac5@kioxia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0b16682a30434d9c820a888ae0dc9ac5@kioxia.com>
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

On 5/5/22 1:30 PM, Clay Mayers wrote:
>> This might be better, though you'd only notice if you had integrity
>> enabled. Christoph, I'm folding this in with patch 3...
>>
>>
>> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
>> index 8fe7ad18a709..3d827789b536 100644
>> --- a/drivers/nvme/host/ioctl.c
>> +++ b/drivers/nvme/host/ioctl.c
>> @@ -21,9 +21,13 @@ static void __user *nvme_to_user_ptr(uintptr_t ptrval)
>>
>>  static inline void *nvme_meta_from_bio(struct bio *bio)
>>  {
>> -	struct bio_integrity_payload *bip = bio_integrity(bio);
>> +	if (bio) {
>> +		struct bio_integrity_payload *bip = bio_integrity(bio);
>>
>> -	return bip ? bvec_virt(bip->bip_vec) : NULL;
>> +		return bip ? bvec_virt(bip->bip_vec) : NULL;
>> +	}
>> +
>> +	return NULL;
>>  }
>>
>>  /*
>> @@ -205,19 +209,20 @@ static int nvme_execute_user_rq(struct request *req,
>> void __user *meta_buffer,
>>  		unsigned meta_len, u64 *result)
>>  {
>>  	struct bio *bio = req->bio;
>> -	bool write = bio_op(bio) == REQ_OP_DRV_OUT;
>> -	int ret;
>>  	void *meta = nvme_meta_from_bio(bio);
>> +	int ret;
>>
>>  	ret = nvme_execute_passthru_rq(req);
>>
>>  	if (result)
>>  		*result = le64_to_cpu(nvme_req(req)->result.u64);
>> -	if (meta && !ret && !write) {
>> -		if (copy_to_user(meta_buffer, meta, meta_len))
>> +	if (meta) {
>> +		bool write = bio_op(bio) == REQ_OP_DRV_OUT;
>> +
>> +		if (!ret && !write && copy_to_user(meta_buffer, meta,
>> meta_len))
>>  			ret = -EFAULT;
>> +		kfree(meta);
>>  	}
>> -	kfree(meta);
>>  	if (bio)
>>  		blk_rq_unmap_user(bio);
>>  	blk_mq_free_request(req);
>>
>> --
>> Jens Axboe
> 
> This does work and got me past the null ptr segfault.

OK good, thanks for testing. I did fold it in.

-- 
Jens Axboe

