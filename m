Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FBC759F13
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 21:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjGSTzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 15:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjGSTzm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 15:55:42 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ADDD92
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:55:40 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-346317895e7so168595ab.1
        for <io-uring@vger.kernel.org>; Wed, 19 Jul 2023 12:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689796540; x=1690401340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xJ++Hb17rNjv9dvXPfJimTgTmben16sA+ZmZQox3a0=;
        b=pGrhJy6ZSv9oUxtfOFJg90L2vM1tOVBBYCEIDbtoIfD3mnbK5fUjWePc36zK3LCCuU
         5+s9q/59NJB7mQ0UfhxptliuKbdGkkfCRvb5sD3oD/x6WQHvDlq24cH6jKbKh7eWUTHq
         w9Fwu5nc1g1Z8EKizlOP3jvfSI2MHriVGXDfxfduglcPEoxIplB3nrY7vabo9BqjRjH6
         tjouf2FAar1AeQ3leVclJINaqO0kFH+Ad3OV6mEbZalbY0lIamS99NZf6ezGCYZvTxpq
         W0XBuZRSAaJz3rP1+YiXROqKXwWMF4pa1BJABXGGbJiYZErXEj0B1TfnWm3bZPLZxB0k
         /dJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689796540; x=1690401340;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0xJ++Hb17rNjv9dvXPfJimTgTmben16sA+ZmZQox3a0=;
        b=daYaiCkLfUj8Fy88DHIZB4mMjkBHYqYXuY4jZe80yXFVn5QAXT7KiGYaXdaDhDi/Nj
         3lIXMdcARRGc3QsTtgaqevW9em7zlmDUHs9IPfIZkLe1jd3NedXkFGyROLiQG7D3Zi/G
         IeqcTGeOGg0otdFRGj7zKoJFw4xY9Knbe+dPeT7wFJhY2ZQxkrd6Fae6ZEGOCvt1QDBb
         HoscsurmnO35Zs/UEOA6Etdiqd6O/8ZPeLyeHeRiVdnvVOlfY6MKwikyg9bw0D4euBty
         AF75jKZ1WuG2+yu6n00FfEanvnfQm9WtEJMoSDh4ztg0pokWaqpdMSjDjadb45yKO75D
         2pJw==
X-Gm-Message-State: ABy/qLad3XXk+qZa9fTKmvy4g/7Qb/Kjpt5lryczZOeKTSlQMJ5lD+jn
        jAJe4MYkLLtrzETNl6yo0Y1AdgwymS4aQSa0PR0=
X-Google-Smtp-Source: APBJJlG4Ep/6aY60WGL5EGHx0EfBFLVaDFt8OQRMNaIWAy2/GLHbXFjxgEGyTM4Gx/HbDoQUUlq9bA==
X-Received: by 2002:a92:da83:0:b0:33b:d741:5888 with SMTP id u3-20020a92da83000000b0033bd7415888mr752717iln.0.1689796539877;
        Wed, 19 Jul 2023 12:55:39 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m7-20020a924b07000000b00345d2845c42sm1615114ilg.57.2023.07.19.12.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jul 2023 12:55:39 -0700 (PDT)
Message-ID: <0a7a1a39-8904-bebc-289e-c80f9d76d938@kernel.dk>
Date:   Wed, 19 Jul 2023 13:55:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/5] iomap: support IOCB_DIO_DEFER
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
References: <20230718194920.1472184-1-axboe@kernel.dk>
 <20230718194920.1472184-7-axboe@kernel.dk>
 <ZLclYR9AtKQXcGFJ@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZLclYR9AtKQXcGFJ@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/18/23 5:50?PM, Dave Chinner wrote:
>> @@ -167,6 +172,25 @@ void iomap_dio_bio_end_io(struct bio *bio)
>>  		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) && in_task()) {
>>  			WRITE_ONCE(dio->iocb->private, NULL);
>>  			iomap_dio_complete_work(&dio->aio.work);
>> +		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) &&
>> +			   (iocb->ki_flags & IOCB_DIO_DEFER)) {
>> +			/* only polled IO cares about private cleared */
>> +			iocb->private = dio;
>> +			iocb->dio_complete = iomap_dio_deferred_complete;
>> +			/*
>> +			 * Invoke ->ki_complete() directly. We've assigned
>> +			 * out dio_complete callback handler, and since the
>> +			 * issuer set IOCB_DIO_DEFER, we know their
>> +			 * ki_complete handler will notice ->dio_complete
>> +			 * being set and will defer calling that handler
>> +			 * until it can be done from a safe task context.
>> +			 *
>> +			 * Note that the 'res' being passed in here is
>> +			 * not important for this case. The actual completion
>> +			 * value of the request will be gotten from dio_complete
>> +			 * when that is run by the issuer.
>> +			 */
>> +			iocb->ki_complete(iocb, 0);
>>  		} else {
>>  			struct inode *inode = file_inode(iocb->ki_filp);
>>  
> 
> Hmmm. No problems with the change, but all the special cases is
> making the completion function a bit of a mess.
> 
> Given that all read DIOs use inline completions, we can largely
> simplify the completion down to just looking at
> dio->wait_for_completion and IOMAP_DIO_COMPLETE_INLINE, and not
> caring about what type of IO is being completed at all.
> 
> Hence I think that at the end of this series, the completion
> function should look something like this:

I took inspiration from this as I think it's a good idea, and did a few
cleanups and introduced things like the above as we go. It's in v3 I
just posted.

-- 
Jens Axboe

