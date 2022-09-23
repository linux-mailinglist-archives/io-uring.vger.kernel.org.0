Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1D75E7CFF
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 16:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiIWO1l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 10:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiIWO1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 10:27:22 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7431132FFE
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:27:18 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r7so297128wrm.2
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 07:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=xjESXrNdWtDo2qoYrjLvJvmJwWv2yGkYQTgeaR04QnQ=;
        b=MJMUlVygM7mKSdbuVCJNiJdrjeIqEJx9xfkuLlXpMpQwYfKbqO3p22XY0D/Fj0PqJs
         DFGkZyC6GCc5weYWy7r/FQCUQ+JDQasfGLrxFhlLOv4h0MnRkvkbvim0w1pzvxzF3teb
         8mLAuabJ36Po3riGgvEjnQq4dU+g2+6V1c5QxndjYH/5unBrLy8KsLzIIoGmzoTM+Xh3
         nNdhcWCfIpt8EsH8r6IcCCHIajZj9e2NOoTZb+DRlXbDBD5BV7UXlttE91H0/CFF+yrF
         mh6Y0iO6fuXulsuxM/jiOGSwTtVOu87s2MvURL+DOnSeVSKDLQD83gv5D2IwDzyiTn9e
         fWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=xjESXrNdWtDo2qoYrjLvJvmJwWv2yGkYQTgeaR04QnQ=;
        b=k0msrOpNGm61HGdvMTEah5m6zZ7RHWJcWc8lszF9eEzUpMsZ99tcOob5N2HON5f9K5
         BUvrKR2Qh1WKPVXk3VWDAYGzOyxo3aw6nKpqja+vf3Slf4Phk2y1ShAcRIqK+nT46v8g
         ddr3L+kfI625UihZUX5efyDxd6udCkWNxvimitRgAslrPMpTbtE2dGgq8LnqJMSMm1hp
         jr+2q7Itqa7n9QAgSnIGnPIyH7Qac9QlC8JVHJN313gDJwwlFJkKMEDV0UhArGFd/GBo
         kVk6kuGSzZ68GVltP7p0iBTwcQNVgXeFBdME4o2U2ftjXihjL9H5kzzgA3QyP1BsSqTH
         PInQ==
X-Gm-Message-State: ACrzQf3qNm7UEk6+WkfKqRFs2LtEiZ1eouLBIQ+Ue74ZgzSsYRe71IVa
        me/Gx+cpKcVM1cdFTd5c9Y9UT5iyOEo=
X-Google-Smtp-Source: AMsMyM4DP2Xjr80eo87BTU2bubRY4FwTS+vc5X/PHMAJdXUSgKGTViJWTRFqQLxqX6i+rf49+pBlPw==
X-Received: by 2002:a05:6000:1849:b0:228:c87d:2578 with SMTP id c9-20020a056000184900b00228c87d2578mr5426645wri.274.1663943236808;
        Fri, 23 Sep 2022 07:27:16 -0700 (PDT)
Received: from [192.168.8.198] (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id u15-20020a05600c19cf00b003a2f2bb72d5sm3343918wmq.45.2022.09.23.07.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 07:27:16 -0700 (PDT)
Message-ID: <56c084c9-8920-dfa6-74d7-9b0ff8423b67@gmail.com>
Date:   Fri, 23 Sep 2022 15:26:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next] io_uring: fix CQE reordering
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Dylan Yudaken <dylany@fb.com>
References: <ec3bc55687b0768bbe20fb62d7d06cfced7d7e70.1663892031.git.asml.silence@gmail.com>
 <30718187-8558-4b32-b8d1-5c1f4f322d4f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <30718187-8558-4b32-b8d1-5c1f4f322d4f@kernel.dk>
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

On 9/23/22 15:19, Jens Axboe wrote:
> On 9/23/22 7:53 AM, Pavel Begunkov wrote:
>> Overflowing CQEs may result in reordeing, which is buggy in case of
>> links, F_MORE and so.
>>
>> Reported-by: Dylan Yudaken <dylany@fb.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c | 12 ++++++++++--
>>   io_uring/io_uring.h | 12 +++++++++---
>>   2 files changed, 19 insertions(+), 5 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index f359e24b46c3..62d1f55fde55 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -609,7 +609,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
>>   
>>   	io_cq_lock(ctx);
>>   	while (!list_empty(&ctx->cq_overflow_list)) {
>> -		struct io_uring_cqe *cqe = io_get_cqe(ctx);
>> +		struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
>>   		struct io_overflow_cqe *ocqe;
>>   
>>   		if (!cqe && !force)
>> @@ -736,12 +736,19 @@ bool io_req_cqe_overflow(struct io_kiocb *req)
>>    * control dependency is enough as we're using WRITE_ONCE to
>>    * fill the cq entry
>>    */
>> -struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
>> +struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
>>   {
>>   	struct io_rings *rings = ctx->rings;
>>   	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
>>   	unsigned int free, queued, len;
>>   
>> +	/*
>> +	 * Posting into the CQ when there are pending overflowed CQEs may break
>> +	 * ordering guarantees, which will affect links, F_MORE users and more.
>> +	 * Force overflow the completion.
>> +	 */
>> +	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
>> +		return NULL;
> 
> Rather than pass this bool around for the hot path, why not add a helper
> for the case where 'overflow' isn't known? That can leave the regular
> io_get_cqe() avoiding this altogether.

Was choosing from two ugly-ish solutions, but io_get_cqe() should be
inline and shouldn't really matter, but that's only the case in theory
though. If someone cleans up the CQE32 part and puts it into a separate
non-inline function, it'll be actually inlined.

-- 
Pavel Begunkov
