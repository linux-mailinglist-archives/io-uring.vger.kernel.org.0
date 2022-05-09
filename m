Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7128A51FCA2
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiEIMZl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiEIMZk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:25:40 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6A2261969
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:21:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso12635056pjb.5
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kttireLmQf/p2PTc6TL6HS9CwarrwuSx05I4PCT1jmM=;
        b=XG05UfQc5viT7FUH6dLmrchIh7NXXjXtu4TVor59CEdAraiKEdAaRyQKRIrQ8Uf914
         Xzc2eMpYZ0WTaLep8Af3l+wGiKpq30XnymfVJaiUoQo1+LUWHjo/1lFDLzOpcM4p+9mx
         3smxWT/XIG4BdfTsyV++2aKkFbZn8VTYssUMWQBrNuBwZk8oU5qGF2ew/B0Q9aKtaNKn
         cTBJc24YY3LKAnpyiYYHOd5LD7VKgsafKtZvTwIgmVxtpAmdgz4c1aXe1rYE7q97saEx
         n/UTIh/O2e6n9vX6AUGq6LXShf1jy0OgF+ImUttRIumUDDh8kCluOtWoguBrgE25klJ8
         3eJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kttireLmQf/p2PTc6TL6HS9CwarrwuSx05I4PCT1jmM=;
        b=xUdXmMGM4wc51M4u+D8biG3WhXS0rNrMAeNUTG3/m9rgPkpL6rwb/poGGJe6xj8YtX
         zD0uVTxSNA73KHnZRwkoasR7Sej/F3GDz5lG0YSPq4irAYenua7cW4tVoRpa7NV9ICQA
         Uk2INWt1J5s3B5SfBZWXs2nY7VmU9gBwCyDqugX5ZKwp0Hac2XCpiYUsR4FGlGUC0reT
         JOX0nFJScfrkY9vc2LA7o3g3u+t9WCsvrzS3PpjmJC/GLlsCSvg3tJw3QdW/CSR9mNTE
         XwgMUHvMj/kPxn4DkgC87Q9L2wKhAcAOwpR72G67O7SZISH+zSAUfamKTAO9/W+xiNLb
         Fxpg==
X-Gm-Message-State: AOAM530GXHs8g5tfA7v4ikXYyhxrJdy9Wb/WgzvBN8x27TZQsYuZL7aq
        RvEaEkrIWYfvdQLQiOagcrXAPg==
X-Google-Smtp-Source: ABdhPJw80Va3sRqqcs6c1GapV1d7HWzoSKslDIgFWBPDTECFYSflggdAgOXyPBNC8AcyT8p5FLFMfQ==
X-Received: by 2002:a17:903:41c7:b0:15e:b1f4:3530 with SMTP id u7-20020a17090341c700b0015eb1f43530mr17122878ple.84.1652098905613;
        Mon, 09 May 2022 05:21:45 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z4-20020aa79484000000b0050dc762815bsm8409756pfk.53.2022.05.09.05.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:21:45 -0700 (PDT)
Message-ID: <d02cbe89-a110-2f1a-8fb4-ce90c3e61701@kernel.dk>
Date:   Mon, 9 May 2022 06:21:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <20220501205653.15775-1-axboe@kernel.dk>
 <20220501205653.15775-4-axboe@kernel.dk>
 <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 6:06 AM, Dylan Yudaken wrote:
> On Sun, 2022-05-01 at 14:56 -0600, Jens Axboe wrote:
>> There's no point in having callers provide a kbuf, we're just
>> returning
>> the address anyway.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 42 ++++++++++++++++++------------------------
>>  1 file changed, 18 insertions(+), 24 deletions(-)
>>
> 
> ...
> 
>> @@ -6013,10 +6006,11 @@ static int io_recv(struct io_kiocb *req,
>> unsigned int issue_flags)
>>                 return -ENOTSOCK;
>>  
>>         if (req->flags & REQ_F_BUFFER_SELECT) {
>> -               kbuf = io_buffer_select(req, &sr->len, sr->bgid,
>> issue_flags);
>> -               if (IS_ERR(kbuf))
>> -                       return PTR_ERR(kbuf);
>> -               buf = u64_to_user_ptr(kbuf->addr);
>> +               void __user *buf;
> 
> this now shadows the outer buf, and so does not work at all as the buf
> value is lost. A bit surprised this did not show up in any tests.

Hmm indeed, that is odd! Please do submit your patch separately, thanks.


-- 
Jens Axboe

