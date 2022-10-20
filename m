Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D407606027
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJTM1m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Oct 2022 08:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJTM1l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Oct 2022 08:27:41 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158701D3EB3;
        Thu, 20 Oct 2022 05:27:40 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so2075137wmb.0;
        Thu, 20 Oct 2022 05:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=29Xo6HXwmoJVWJYrYPfltdI8ZtK22sePqNB82FGfT2k=;
        b=TOlduXdIFuZuhrqzj6+PH1Bb9Q14uByPeFG7jufuEHncgs055zW1/cWz4MxRoy/Rnb
         6YH76hSD+xnQXYAQglRP0DWj7SvFmve2IoHrW5WnLnSrM161xDm2+tYca/iD6uwxM9hI
         ZW7ful55h4Qlb6i5rJxw/SjvCI+AwVZFG5XpOp7s8bnxMIIqLjYVqm1cnGMdtBCU4Q49
         Lozwbk2bvRySkBoPeM5HeByF7rGVvN8fyhSY0yK4v+5sfNxfh6eC1ia5TmwUzJKDjh02
         nI7ie5v1hLZ5lLTiRmlhkeZVcJOo2sxciIx1qHluXrNNvJEA81F36b2ghHO92Zk/WFZB
         Hskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29Xo6HXwmoJVWJYrYPfltdI8ZtK22sePqNB82FGfT2k=;
        b=7Y2EbnXzo9IUXyEzkTwdVshmI5hNeH3F7ZkqGTvaQlq8MRvRSvkEAYCXrWzeukyDP2
         27dqUxu/0nsa5ctoUPZm+zT9viMiCH7ULnAfNULFFd6/YpLTy5NrF1glCUD2UYyByWLH
         cVQ9ZC8pFJKwVEclhDozG7ROZUeUhZlMhjz2qq3sGMKuzqlCMcIHY03KycaolbX0rGGB
         cTa9eudDTGFtdDastihdnkUeiLx0pQYdffkTSakB0oE+BQpa9g/CQ63W5krtHagjpGhT
         I2+a3fIuVJwTi3BYCeO1CBPhB6Yov4ZqNbcPmBd1lKJ/EonHRXikUb4R5on+uJ8KtvzY
         xZ/Q==
X-Gm-Message-State: ACrzQf3DFtsMRSHOO1lEJ8DIUutlrU3Hk4HpMSlfFrV4csxx1kKPEOEu
        gLaePiYOCDIN6CqmDigE8aRtJdwbKEM=
X-Google-Smtp-Source: AMsMyM7WwMr9xBD7uZTUqdfHU8/9lzn+n/gf8PJx/zT+wDovjVHfBfxIP6RdaWaCwiuHiqmkJvRfZw==
X-Received: by 2002:a7b:c40e:0:b0:3c6:cedc:f874 with SMTP id k14-20020a7bc40e000000b003c6cedcf874mr30841043wmi.5.1666268858374;
        Thu, 20 Oct 2022 05:27:38 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id m2-20020adfe0c2000000b0022e6178bd84sm17069433wri.8.2022.10.20.05.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:27:37 -0700 (PDT)
Message-ID: <2b29a76c-682e-208f-8a0f-d693b6823482@gmail.com>
Date:   Thu, 20 Oct 2022 13:26:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC for-next v2 3/4] block/bio: add pcpu caching for non-polling
 bio_put
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <cover.1666122465.git.asml.silence@gmail.com>
 <9fd04486d972c1f3ef273fa26b4b6bf51a5e4270.1666122465.git.asml.silence@gmail.com>
 <Y1EHb36rQgqwbsXD@infradead.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Y1EHb36rQgqwbsXD@infradead.org>
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

On 10/20/22 09:31, Christoph Hellwig wrote:
>> +	unsigned long flags;
>>   
>>   	cache = per_cpu_ptr(bio->bi_pool->cache, get_cpu());
>>   	bio_uninit(bio);
>> @@ -737,12 +776,15 @@ static inline void bio_put_percpu_cache(struct bio *bio)
>>   		cache->free_list = bio;
>>   		cache->nr++;
>>   	} else {
>> -		put_cpu();
>> -		bio_free(bio);
>> -		return;
>> +		local_irq_save(flags);
>> +		bio->bi_next = cache->free_list_irq;
>> +		cache->free_list_irq = bio;
>> +		cache->nr_irq++;
>> +		local_irq_restore(flags);
>>   	}
> 
> Ok, I guess with that my previous comments don't make quite
> as much sense any more.  I think youcan keep flags local in

Yeah, a little bit of oracle coding

> the branch here, though.

Not like it makes any difference but can move it

-- 
Pavel Begunkov
