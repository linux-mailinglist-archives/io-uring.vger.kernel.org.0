Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890C665DDAE
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 21:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbjADUaC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 15:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240105AbjADU37 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 15:29:59 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CD410B41
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 12:29:58 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id bs20so32139593wrb.3
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 12:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=38F+YSeAQrTIXSy8y5T5TG34BlkNzkxYd5RsCf5PtZk=;
        b=XtZ2aIsilVxGey4SiUxaYn282nesWzSiGyQUNqOhU+bo9958NE7qW2IndmfphNT/aF
         BPQuD/OT1AB7lGLWnT0WWEhTHLadEcBQ+9rE/tcst/WITCa5TDfG/NCFNJcJYzjZ4xCl
         hg81rw3mnfLDMcRDaAUl3m6ql1Uz6ZelrCkDBYIMO4wcyyR5tfiRrUAv1Cema++9V5zF
         tOlhPR87VMjV1XPhbPBe5Y1TLFAdMkwZPW81/PJRX+oLRcF9rH15UcaWQY+o03abiiGj
         InMCvvRqc9OjFCYWGwUzdnK2KSRp9ivvyEnjNy78s8eJuCi79lRdoUS3lUaGWKh3C/iX
         doKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=38F+YSeAQrTIXSy8y5T5TG34BlkNzkxYd5RsCf5PtZk=;
        b=0MOACcjjE0nQz/17OMioNbSdbKMU2ixSa4qPebcJ97V2lMDZ9Jpz7ypubp7ZQlfWIs
         3YD/Tmizuf37I7mk9G0enHgjvIhFBhfWhX+FoezSpW04Hvo+kREkKQJt4QwAbdPMEErm
         oyY8PgEfuuSnPo52kpSsrV/68BxjbJnPn9p2PrALwDnnRkoM40sRW3GC1pwtqBLSHV6o
         fYfFtILbP0M40XiUvafcMMEyX8fwhuxlIj7HXZNiXXmD9rFk4XW9yPNM0BKgYyJqVF9g
         dWFleJ3YoWp7/xyBFSZXgcMVRFmDv7PMJzDzsks4t+jZji9bh8cuINv+DF11OI5yo+Iy
         4d7A==
X-Gm-Message-State: AFqh2krWmhzEpD2qaJYU27/SGkw/FXi68cUoPQtCQQtz7sHqOJXQlh0W
        T2u8IMOCMs3ZzIg5QWh67R27La0x3ZM=
X-Google-Smtp-Source: AMrXdXse1Qf1wjoTQtB3/VBlhDx0q1iOzy2no8ArEwCcja0Ocu/H6bjc99M0R0ntC6ze3k2PTqdgKg==
X-Received: by 2002:a5d:4387:0:b0:26f:2fb:7f88 with SMTP id i7-20020a5d4387000000b0026f02fb7f88mr31050720wrq.33.1672864197293;
        Wed, 04 Jan 2023 12:29:57 -0800 (PST)
Received: from [192.168.8.100] (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id y13-20020adfe6cd000000b002a1ae285bfasm3789205wrm.77.2023.01.04.12.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 12:29:57 -0800 (PST)
Message-ID: <894c3092-9561-1a32-fb4c-8bf33e3667a1@gmail.com>
Date:   Wed, 4 Jan 2023 20:28:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC v2 09/13] io_uring: separate wq for ring polling
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1672713341.git.asml.silence@gmail.com>
 <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
 <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/23 18:08, Jens Axboe wrote:
> On 1/2/23 8:04 PM, Pavel Begunkov wrote:
>> Don't use ->cq_wait for ring polling but add a separate wait queue for
>> it. We need it for following patches.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/io_uring_types.h | 1 +
>>   io_uring/io_uring.c            | 3 ++-
>>   io_uring/io_uring.h            | 9 +++++++++
>>   3 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index dcd8a563ab52..cbcd3aaddd9d 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -286,6 +286,7 @@ struct io_ring_ctx {
>>   		unsigned		cq_entries;
>>   		struct io_ev_fd	__rcu	*io_ev_fd;
>>   		struct wait_queue_head	cq_wait;
>> +		struct wait_queue_head	poll_wq;
>>   		unsigned		cq_extra;
>>   	} ____cacheline_aligned_in_smp;
>>   
> 
> Should we move poll_wq somewhere else, more out of the way?

If we care about polling perf and cache collisions with
cq_wait, yeah we can. In any case it's a good idea to at
least move it after cq_extra.

> Would need to gate the check a flag or something.

Not sure I follow

-- 
Pavel Begunkov
