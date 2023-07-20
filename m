Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B964575B42A
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 18:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjGTQ1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 12:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjGTQ1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 12:27:16 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307DDE6F
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:27:14 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-785ccd731a7so12791639f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 09:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689870433; x=1690475233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNGQJK9GMxVIPezFWA0EfraPWR73FqaxU9vK05mP9fI=;
        b=caatJ6oNgwkpJATjzPpLBkPDFJ/2ZLKbMj+0F3E4Wv8xfZHz8JeWoaJsKvEbfbQioz
         i6lO9eVoq5ubHm0S+7/KjvRe87wvEtPUIopmjV/cNnykcl06mj+GHNEYLsjMqX6wgFM5
         14WYrNSNRX1+0Tf8CfUQw0WV7jDNNwxK7TZRZqv5YLs4KCBAQxc/6n3KCP4FBLtgVcCR
         NLzKUatIwuyN9mr0bg2lozzuPhwC4cYxPBFg8OycOcbshRuFs+duomZ6PHrbLKQE2Epp
         y4Z4+Clyu1+z5o6Eejdm1VnIREwzBzERocim9NYTuuzrVzrp/WdRsT16n5Y3SfjdU+h2
         +FLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689870433; x=1690475233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNGQJK9GMxVIPezFWA0EfraPWR73FqaxU9vK05mP9fI=;
        b=AAPEPqN7T2x8DgbmyIw6E6/DuqZjN7EybCfYzlAWgpZm+yK2u3PnS4s+GwV7S3UkbJ
         pKUaiT1wiEoCQtNxAmMsI8vtiuvqu3H1gP9gbk/h2Umay5v0zv4LxNWl/PEqC0NegMy1
         ucWIOVi9eIYQ0qSDfU2NRfBmVHYpNVNlr2FpPYjMyFz7eW05dlKxxRvcmLTrHorc2scH
         5BpfQGqEw3FkRbOLPh9MeOgYAQw/gfkEeZk6nVGPUPUA3PqUIJpH2Lmc3Rk2p8cendjr
         tRwXkHcR7lFXRDtqQAdFfRTQ6VWFnGhA1k+pEedXz7WXIxBWog866vt8KWiT9Cu2FS9F
         KxtQ==
X-Gm-Message-State: ABy/qLa9HJkWYQEq/6woxWe7jb8+kg/8w/ZFvLznBDjEDiANpGgutm20
        dSl4KRhX0kK/XxkvXb89+2pcfg==
X-Google-Smtp-Source: APBJJlGMrXJWL9ueuRWhdL5wz2y4wmJXFyjKdyLhiMFt39KtDC4ukPkUeRty+Qxv7SfCBi2iK58T6Q==
X-Received: by 2002:a05:6602:3423:b0:780:d65c:d78f with SMTP id n35-20020a056602342300b00780d65cd78fmr4357645ioz.2.1689870433460;
        Thu, 20 Jul 2023 09:27:13 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l4-20020a02cce4000000b0042b0ce92dddsm399918jaq.161.2023.07.20.09.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 09:27:12 -0700 (PDT)
Message-ID: <5a329b36-ea97-e05d-fbf9-9225aabe1b8b@kernel.dk>
Date:   Thu, 20 Jul 2023 10:27:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/6] iomap: support IOCB_DIO_DEFER
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230719195417.1704513-1-axboe@kernel.dk>
 <20230719195417.1704513-7-axboe@kernel.dk> <20230720045919.GD1811@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720045919.GD1811@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/19/23 10:59?PM, Christoph Hellwig wrote:
>> +	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
>> +		/* only polled IO cares about private cleared */
>> +		iocb->private = dio;
> 
> FYI, I find this comment a bit weird as it comments on what we're
> not doing in a path where it is irreleant.  I'd rather only clear
> the private data in the path where polling is applicable and have
> a comment there why it is cleared.  That probably belongs into the
> first patch restructuring the function.

OK, that makes sense.

>> @@ -277,12 +308,15 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		 * data IO that doesn't require any metadata updates (including
>>  		 * after IO completion such as unwritten extent conversion) and
>>  		 * the underlying device supports FUA. This allows us to avoid
>> -		 * cache flushes on IO completion.
>> +		 * cache flushes on IO completion. If we can't use FUA and
>> +		 * need to sync, disable in-task completions.
> 
> ... because iomap_dio_complete will have to call generic_write_sync to
> do a blocking ->fsync call.

Will add to that comment.

>> @@ -308,6 +342,8 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		pad = pos & (fs_block_size - 1);
>>  		if (pad)
>>  			iomap_dio_zero(iter, dio, pos - pad, pad);
>> +
>> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
> 
> Why does zeroing disable the deferred completions?  I can't really
> think of why, which is probably a strong indicator why this needs a
> comment.

If zerooout is set, then it's a new or unwritten extent and we need
further processing at write time which may trigger more IO. I'll add a
comment.

-- 
Jens Axboe

