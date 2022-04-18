Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006C5505EFD
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 22:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347821AbiDRUym (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 16:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiDRUyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 16:54:41 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488DB22BD9
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 13:52:01 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 125so15537474iov.10
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 13:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=of1/rbaaT1Um7EUplxJ1Z6dmlvMovJeITqPf+w5McRg=;
        b=olxYcw0MaAC69qfMkv3hiXaOzkINShMm3NVhQXfGgnw1PeSrPp2ZTVpnsnfboqEmzk
         sE4vU93zZXjNn1zISeTOTxKRzT765Z5M0ipvw97FrNUmsJaerYQsRqT3NjAWIJFccXUQ
         kicShRRgJre/dTqWICwcp9ytEzklnfwMUsQtCKBXLY+pmMT60dRvTMnXp7i8chSW8XMc
         EC6fzC03vc6WDBy5eZ9dZtafF8HCG15ARJr12pUzxTwYOr18JfRNXvy1HrZN0Tq3SQei
         /p3wphdqUvhZ31XR53gCcQ4wh5Dn/YOt/kHPGWQeoiFk4JJQxBsN5DD2B1TASVKrzgjr
         YDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=of1/rbaaT1Um7EUplxJ1Z6dmlvMovJeITqPf+w5McRg=;
        b=5zITciyTlCBXH69u/AYP7yA0rd+4AWPkzcYU6LKV2Z9brrFDOpI1VkTHawqsvSGihp
         9OlEKAxnOARdybvmvT+27W2iGATdEb8vyDdfYk8vze1JoPlg4Lufwj0R3aVjbqC151v1
         VPdfjTrn1OX/pk3MRAfrh1Xz1GcSaEVRYVshjMpRAl1kopQsieCtsloTrj3zXwZpeIJU
         /L9Uv6HcqdLZPcVBolNpiiHeYxjMEFFd3Jd/xvPi2qaINpoxecXHyx8anoIfoMEWxaIS
         LM7yk1gAKYRnSNDI66sbcry6hCbuAiJp4GlK+In2Dky4Swhfplep//NhSOMz+7xVXzJ+
         mT/g==
X-Gm-Message-State: AOAM532ZqqTEdpe/JIbHaNyidN1AhGAP3UckjDsomFmetXqoALJXoTK5
        rR92qMDTjCjDu5LmWAEsV073k/gHmbX43g==
X-Google-Smtp-Source: ABdhPJzMEJNKmun26hKya8c69Jk7x+rlAYv9cjb98YD0F/BjvSo2tSrS2W3y1Ja6r65IkftwJR6flA==
X-Received: by 2002:a02:b0c3:0:b0:327:b824:b8ac with SMTP id w3-20020a02b0c3000000b00327b824b8acmr5984548jah.120.1650315120610;
        Mon, 18 Apr 2022 13:52:00 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id ay18-20020a5d9d92000000b0064c77f6aaecsm9079727iob.3.2022.04.18.13.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 13:52:00 -0700 (PDT)
Message-ID: <5e4fe95b-9043-d2d7-1eaa-e74717572d76@kernel.dk>
Date:   Mon, 18 Apr 2022 14:51:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/5] io_uring: refactor io_assign_file error path
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1650311386.git.asml.silence@gmail.com>
 <eff77fb1eac2b6a90cca5223813e6a396ffedec0.1650311386.git.asml.silence@gmail.com>
 <edbfa8e8-c3a0-aa58-81ab-09e3841101f3@kernel.dk>
In-Reply-To: <edbfa8e8-c3a0-aa58-81ab-09e3841101f3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/22 2:50 PM, Jens Axboe wrote:
> On 4/18/22 1:51 PM, Pavel Begunkov wrote:
>> All io_assign_file() callers do error handling themselves,
>> req_set_fail() in the io_assign_file()'s fail path needlessly bloats the
>> kernel and is not the best abstraction to have. Simplify the error path.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 423427e2203f..9626bc1cb0a0 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7117,12 +7117,8 @@ static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags)
>>  		req->file = io_file_get_fixed(req, req->cqe.fd, issue_flags);
>>  	else
>>  		req->file = io_file_get_normal(req, req->cqe.fd);
>> -	if (req->file)
>> -		return true;
>>  
>> -	req_set_fail(req);
>> -	req->cqe.res = -EBADF;
>> -	return false;
>> +	return !!req->file;
> 
> Wouldn't it be cleaner to just do:

As soon as I sent that, realize we're missing the file assignment
in that case. Stupid. Looks fine as-is.

-- 
Jens Axboe

