Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7DBE135CDC
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 16:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgAIPeb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 10:34:31 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:42436 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbgAIPea (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 10:34:30 -0500
Received: by mail-pf1-f178.google.com with SMTP id 4so3537440pfz.9
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 07:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KDIoqjFAdAEI9Z9CN7Scny5MZlaVFvws0UlGpuAboPU=;
        b=ZBoESHS1ClnHzs6/dUwqyCdNhAcIHQsexiHpJGwS4Sov0e91VdH5bu6g4Jwzwjv8Uj
         0eDfn/38OBHr+Z2l4DfjoEt+lL3ivpXU5LoKxLUgf/9DPqwPfOd53N0Z9vCw8wmIhQ9c
         Snwc8Qt+fK6Uc0DUvBpaDDIoW8fH7ACriwIERau6xYVMlpMiFXkC6DtZP1TeOL4+0E40
         J0QKZOfnHLorhdg8mQnfswg3HQlYQ21T6Z3WXyycaGiqcZEx7NrdLGjI0ShSrS/LIEM/
         QJLXCaBsC3yh7ENY1Jr8P6jhiN5NSsSAxc12/E+PGG2BE4hCP7VXsmzAJ5QaZTfsrcW+
         aiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KDIoqjFAdAEI9Z9CN7Scny5MZlaVFvws0UlGpuAboPU=;
        b=PC9iUUnkwag/+MKPHC7Ag9G8wyJGfb96x15OsmyuMfCWCn/Cjq43T1VWjjROUTZrr+
         smKoan43DTTxqoaTrrhJECEAy3huIJ0dzYc5/GG7iZIFcz1ubX53/akB3fU6If9tcIMh
         s5yq83cRCZ+vgTfEQAi0ACbQng4wLCPrBHJK8yeD2T7oq7c5Grn5ek5Rg8Ja1h6HZBsj
         wBFNTPbfc3Yo/eaVLvhjktDfeMYKIValjVh30OaN1lKfggfoilduVJHUDOOw9iXnD4WE
         tJmHrzxkXAmDqYg2uBzwsWa/mx3t1Y38U+oR9kHQ1V0bgEk1FnvR1IxX9DXifD6XcC0t
         E9Iw==
X-Gm-Message-State: APjAAAX1McQYRMc7nUkz8aJYKAUKOlHzYoWJsk1bJymCndeZWKp5qSxN
        0s3rF6m0gsQqVGOZV+hjfE7uPTPwFDk=
X-Google-Smtp-Source: APXvYqzvJUnUM4uLsoFGg40fgFLiSHfRLgzVVXs770akU3PZJ244O0r3RGc+AYuT7Hl5Xwyl/ewwOg==
X-Received: by 2002:a62:14c4:: with SMTP id 187mr11754653pfu.96.1578584069943;
        Thu, 09 Jan 2020 07:34:29 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s20sm3641831pjn.2.2020.01.09.07.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 07:34:29 -0800 (PST)
Subject: Re: [RFC] Check if file_data is initialized
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        io-uring@vger.kernel.org
References: <20200109131750.30468-1-9erthalion6@gmail.com>
 <e6cd2afe-565f-8cde-652c-26c52b888962@gmail.com>
 <07aeb2b5-b459-746b-30a2-b63550b288df@kernel.dk>
 <73e00d5c-e36e-6614-9de1-19978efd7e61@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <105a9991-2c04-d2d3-cc8c-8ffa6ae3529f@kernel.dk>
Date:   Thu, 9 Jan 2020 08:34:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <73e00d5c-e36e-6614-9de1-19978efd7e61@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/20 8:17 AM, Pavel Begunkov wrote:
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 32aee149f652..b5dcf6c800ef 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1218,6 +1218,8 @@ struct req_batch {
>>  
>>  static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
>>  {
>> +	int fixed_refs = 0;
>> +
> 
> If all are fixed, then @rb->need_iter == false (see
> io_req_multi_free()), and @fixed_refs will be left 0. How about to set
> it to rb->to_free, and zero+count for rb->need_iter == true?

Good catch, I'll make that change.

-- 
Jens Axboe

