Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5D6140FFC
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 18:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgAQRg7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 12:36:59 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39217 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQRg7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 12:36:59 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so10137153plp.6
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 09:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V7YhkY4PmkI1LSMyEXwK4wPoXy4GsmQJJpn30aCzOUA=;
        b=1V1uDWrgRIiuhRywDmLnKVYh4M1Q/9VHzgQOW9zMJOtpg9RytH/zNO/hqMLtVLahXB
         wv5py7+mh5/1Zsc2kLRkxCy+FvcxddDQnIgIn5GhT9g5UUnbOGXjwo5UpDYGxJd/5c3S
         k7YjHjNzpbU/3749LwYw/BJPrOaR4V/8nUcO1Svopve+uoAFUG70xXoBJ0C5yjkeb5EN
         oaRbfaXSBW3mF2MdOYogvz8gVt46SrUdCZE26ZCgazoxw8DdPrnO1RUsyVz6CnAnBqo3
         TTLFH/5pzvOWj+sOXOuvyf/GrJJTX2nN6XuBtEGBTc4b4MhC8ysYbAkQLMuoXbvWeQYd
         4SQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V7YhkY4PmkI1LSMyEXwK4wPoXy4GsmQJJpn30aCzOUA=;
        b=C0nfwIycNneFSLqvVvz3TNcmC9FT4WC6t+F330KmddpSm9tGGYqbPPDmv7yRoMxxrr
         ceauGRso0Mz6zDHfbfJararHKovFIhR1tFmSbKayPm20kr4B6P7BfnPiw6FFjcFhGcFi
         0bxYCLi0XMVB0Zq1JYWHiI5JcSNLC3rVrMg2GLe3iQHHHEF7xES4c4kSwQa/BKXJzuLi
         aHlnIRTmGv69nWJAwaQJJOYzXjoPyrbMKkupGn8hMF829vBrb+c7Zs6Ew381iPYe0Sg0
         Tq4KtcntdGNy/8ZFrzTa9HWZVuzoS5N9f7HXRSNJizpCr66pR9NWY24NIR4jflUoeNdE
         yuEQ==
X-Gm-Message-State: APjAAAU4FeZihJ2lhYHfEvyMAO2gWoYWCP5yLodoiPJh7DR47XD/dUaz
        Z7aHdgdcPuZwZ0Mm5AUcAayzwyQy14o=
X-Google-Smtp-Source: APXvYqyIFUZSpP6/25ZzbeNmmTeWPLJ1CxKoBvdmAylfCxv9Y4vHE9gmO9OUVk6bc2YjpJYh0DCHsA==
X-Received: by 2002:a17:902:5ace:: with SMTP id g14mr106514plm.311.1579282618330;
        Fri, 17 Jan 2020 09:36:58 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1028? ([2620:10d:c090:180::3360])
        by smtp.gmail.com with ESMTPSA id m19sm7072021pjv.10.2020.01.17.09.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 09:36:57 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: add support for probing opcodes
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>
References: <886e284c-4b1f-b90e-507e-05e5c74b9599@kernel.dk>
 <x491rry3sxr.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7dae1f4-ebfd-bdaa-b2c1-b89e4da62de7@kernel.dk>
Date:   Fri, 17 Jan 2020 10:36:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <x491rry3sxr.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 10:15 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> The application currently has no way of knowing if a given opcode is
>> supported or not without having to try and issue one and see if we get
>> -EINVAL or not. And even this approach is fraught with peril, as maybe
>> we're getting -EINVAL due to some fields being missing, or maybe it's
>> just not that easy to issue that particular command without doing some
>> other leg work in terms of setup first.
>>
>> This adds IORING_REGISTER_PROBE, which fills in a structure with info
>> on what it supported or not. This will work even with sparse opcode
>> fields, which may happen in the future or even today if someone
>> backports specific features to older kernels.
> 
> This looks pretty good to me.  You can call it with 0 args to get the
> total number of ops, then allocate an array with that number and
> re-issue the syscall.  I also like that you've allowed for backporting
> subsets of functionality.

Right, this is similar to how most hardware commands work when you don't
know what the max size would be. Since this is pretty small, I would
expect applications to just use 256 as the value and get all of them.
But if they want to probe and use that method, that'll work just fine.

> I have one question below:
> 
>> @@ -6632,6 +6674,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>  			break;
>>  		ret = io_eventfd_unregister(ctx);
>>  		break;
>> +	case IORING_REGISTER_PROBE:
>> +		ret = -EINVAL;
>> +		if (!arg || nr_args > 256)
>> +			break;
>> +		ret = io_probe(ctx, arg, nr_args);
>> +		break;
> 
> Why 256?  If it's just arbitrary, please add a comment.

We can't have more than 256 opcodes, as it's a byte for the opcode.

> Otherwise looks good!
> 
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!

-- 
Jens Axboe

