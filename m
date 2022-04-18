Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3372E504E3F
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 11:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiDRJM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 05:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiDRJM1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 05:12:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6173B12AA7
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 02:09:45 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b15so16814049edn.4
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 02:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=q4v2sv4MdaApv7FR1PqLP7grfLyVMx/EhWJhEsT1c4Q=;
        b=D5xKyNkjXwOm5LnLDIC74UTNYnjjjSRSmA67jVIMYIZ8p8FeEGWcJVZSiHIVXk0W+M
         Hu0jILGePLmOefvLWOQzELk3JnJbrjKhOWCjuW2xtWcmeqzkZ58HsLXwP1eQ+kUdn7Xi
         jup1iBCDdWgN/VFlwLnTt5gsf1oyR2EmondJpH2HmVekbCxKqkTQZoXh8KWcL3Cfy6m/
         PvF+X596x0bZs+AfEkQtFUbIbSQZGdf3JQni+ki/ST7O1LnaAkvHROIy1QKfaIxZaRNa
         dty7YnIRF75KuPgotiMsHwoawfZ0VeCyh7BEiH5sKkkTu5fdqcWM451A2Np+eD2Lkv2Y
         8SOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q4v2sv4MdaApv7FR1PqLP7grfLyVMx/EhWJhEsT1c4Q=;
        b=ghC9DVFKojqCAg62otkr8rkAfCneUZW+VGfPIH3147e8I+bLzWPK53Z7VaxYhv2dxT
         X47Gew32QkwfLebJcOpFDSgwOdLtNapViGyuqJOYA3PgIIXoOiaGt0lYZCO+1BchWl6U
         67VKjwexMlw37B2NxjJMd66kqL1fEQNgTP3MCibcQYgvJql4jKe0VZoq7Y2mrWOwCBgU
         6sWVGBrgQpdo50H+sbUHcVeGpqH4C/2EVemACj+QWccbWQRlR1IU7Wdftb+DQWbs9xQe
         lYP/8VNtT2WHDDjYEJe0eFJXc8Nqb7jQHzUdR0donkw31IR/e4GLA3vdDI+OzH8I6r6/
         hpuw==
X-Gm-Message-State: AOAM530vlVTUGkPqk4i7Y6kGZ/+Nw4TC6b3KvD0P8kcYihmuQbJzzZE6
        4ynBNp/knxRE8A9mFwtSznYRwe998Do=
X-Google-Smtp-Source: ABdhPJxauuLCwzAyYwspmKxJ2RUdm8R2JFF9I04mUAetKgq7ihPQhoSE6o+0XD5hNsz9dBw7KSAj4Q==
X-Received: by 2002:a50:c316:0:b0:41d:6fdb:f3db with SMTP id a22-20020a50c316000000b0041d6fdbf3dbmr11339660edb.315.1650272983794;
        Mon, 18 Apr 2022 02:09:43 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.82])
        by smtp.gmail.com with ESMTPSA id dm11-20020a05640222cb00b00423d721315dsm2957359edb.76.2022.04.18.02.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 02:09:43 -0700 (PDT)
Message-ID: <ba59be2e-5d3b-bac3-7343-5e9921de1ed5@gmail.com>
Date:   Mon, 18 Apr 2022 10:08:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 02/14] io_uring: add a hepler for putting rsrc nodes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1650056133.git.asml.silence@gmail.com>
 <865313e8a7eac34b6c01c047a4af6900eb6337ee.1650056133.git.asml.silence@gmail.com>
 <6ba23bd7-26c1-64fd-a312-f90c398b4062@kernel.dk>
 <2aa72b12-bdf6-0815-dfa3-304444f38e67@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2aa72b12-bdf6-0815-dfa3-304444f38e67@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/22 02:22, Jens Axboe wrote:
> On 4/17/22 6:05 PM, Jens Axboe wrote:
>> On 4/15/22 3:08 PM, Pavel Begunkov wrote:
>>> @@ -1337,21 +1342,21 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
>>>   		if (node == ctx->rsrc_node)
>>>   			ctx->rsrc_cached_refs++;
>>>   		else
>>> -			percpu_ref_put(&node->refs);
>>> +			io_rsrc_put_node(node, 1);
>>>   	}
>>>   }
>>>   
>>>   static inline void io_req_put_rsrc(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>>   {
>>>   	if (req->rsrc_node)
>>> -		percpu_ref_put(&req->rsrc_node->refs);
>>> +		io_rsrc_put_node(req->rsrc_node, 1);
>>>   }
>>
>> What's this against? I have req->fixed_rsrc_refs here.
>>
>> Also, typo in subject s/hepler/helper.
> 
> As far as I can tell, this patch doesn't belong in this series and not
> sure what happened here?

Turns out 3 patches are missing from the series,
sorry, will resend what's left

> But for that series, let's drop 'ctx' from io_req_put_rsrc() as well as
> it's unused.

ok

-- 
Pavel Begunkov
