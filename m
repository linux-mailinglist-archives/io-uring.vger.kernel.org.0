Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A37354C5B9
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344740AbiFOKSj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346203AbiFOKSi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:18:38 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB9E44A3A
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:18:35 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id w17so7196169wrg.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cFsb2fUU6oEkzdVwUNKewpHJ0yk5vdfqNFsYWQ2pjMQ=;
        b=RUPxR1evjpBXXB5gSW7d+XOmnHKljZBgbjz15ybxurU5fBxsziSrQwgYyAJdwGLqe8
         8MgVDmNqlDptFCJ56ysxPFwVtb2riRE1demAbJU34RHSevD7IeGg1XD//zMEmZCwCWfY
         7SG98wxmAP6Jd2pQ+vWNPbnOtm+OxCd83QJlAuzv7niir+a6D0V7vdJ1+lhJxa0NbWXm
         gGplDbS/LZ7MDGY3osd4MxhLqWh4MGtwkIvdcs/4V3va3UL0Cv/alq2ptInql6CeLcEU
         7EPhkOdu08k55rvSWwNvj6uZENvJmjAGyw696pFces7DUYbshuXVP+a2Frbf5qfaSMsG
         iRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cFsb2fUU6oEkzdVwUNKewpHJ0yk5vdfqNFsYWQ2pjMQ=;
        b=hRlxnYKdZfyzNn7+Z+IpA+nvyzCMiA3/BbfCTfUkqkuflqUCS6H0ddF9r1m+DC8FK5
         VrAbaJenv/7ip8gJXQ9FLl8237jEddtRA4pBWGkyoUABst12Qt7x7Stt+8vDkD0sXte6
         UbDnGgCrqmtHx5qhlbMOl9HAJk6V2NWryRVTRlXMJV+ZOyhU3eWI5POdHMqn9hai12Ee
         35s1Nfn4Qj+7rwuUVMksg2E+7/X1eVaw0BlLVIbAYrdPu9Q1viuxEGDik1x/Vp435mmr
         vF7F6PQf86Bvbv8Hd/h1cg4SS9YLxhSyDT/nnD34Hjjstn/k2gshMeq8K88YULGiRmat
         7CGQ==
X-Gm-Message-State: AJIora9TcWw4ugyzRs/GCpKol13wSC0AG550CnqHyvB1omGrHgaz+KBm
        8dNbHRMzzY+IfHnEDoxQrR+eUKymqtYUgQ==
X-Google-Smtp-Source: AGRyM1uftms2IA10YrRBZUd3STrn4xyyWG7GquAwz99KbawuZUMlvLjh3duOwECU3mb5aEX1jYw0Kw==
X-Received: by 2002:a05:6000:144d:b0:218:647d:9d8c with SMTP id v13-20020a056000144d00b00218647d9d8cmr9376557wrx.451.1655288314156;
        Wed, 15 Jun 2022 03:18:34 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f7-20020a5d50c7000000b0021031c894d3sm14499841wrt.94.2022.06.15.03.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:18:33 -0700 (PDT)
Message-ID: <91f3d0d4-9d37-8ec8-dcde-97b3351eb765@gmail.com>
Date:   Wed, 15 Jun 2022 11:18:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v2 10/25] io_uring: kill REQ_F_COMPLETE_INLINE
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <378d3aba69ea2b6a8b14624810a551c2ae011791.1655213915.git.asml.silence@gmail.com>
 <172baf20-e6d1-9098-187d-a2970885338b@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <172baf20-e6d1-9098-187d-a2970885338b@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 09:20, Hao Xu wrote:
> On 6/14/22 22:37, Pavel Begunkov wrote:
>> REQ_F_COMPLETE_INLINE is only needed to delay queueing into the
>> completion list to io_queue_sqe() as __io_req_complete() is inlined and
>> we don't want to bloat the kernel.
>>
>> As now we complete in a more centralised fashion in io_issue_sqe() we
>> can get rid of the flag and queue to the list directly.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c       | 20 ++++++++------------
>>   io_uring/io_uring.h       |  5 -----
>>   io_uring/io_uring_types.h |  3 ---
>>   3 files changed, 8 insertions(+), 20 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 1fb93fdcfbab..fcee58c6c35e 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1278,17 +1278,14 @@ static void io_req_complete_post32(struct io_kiocb *req, u64 extra1, u64 extra2)
>>   inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
>>   {
>> -    if (issue_flags & IO_URING_F_COMPLETE_DEFER)
>> -        io_req_complete_state(req);
>> -    else
>> -        io_req_complete_post(req);
>> +    io_req_complete_post(req);
>>   }
> 
> io_read/write and provide_buffers/remove_buffers are still using
> io_req_complete() in their own function. By removing the
> IO_URING_F_COMPLETE_DEFER branch they will end in complete_post path
> 100% which we shouldn't.

Old provided buffers are such a useful feature that Jens adds
a new ring-based version of it, so I couldn't care less about
those two.

I any case, let's leave it to follow ups. Those locking is a
weird construct and shouldn't be done this ad-hook way, it's
a potential bug nest

-- 
Pavel Begunkov
