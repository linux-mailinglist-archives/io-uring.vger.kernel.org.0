Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0224C54B426
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbiFNPFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353854AbiFNPFi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:05:38 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FD541638
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:05:37 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k19so11671753wrd.8
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=O2Rwuog5zrzICLL6iIlQRQk13JMsB10bdTVaYiW91Iw=;
        b=m13eAc0StFM/L3g8+qgaAjiL5fWnbR/rJEO0XyBCwEJPHIHW/+IR36o8cfpnZQfvK4
         5Ow8dyNFjHKGrre777X7iA2T36Ft28zykuka7HSvrDN6gRuMOjdoWZ7rVqkYxe8N00t7
         VioWV3VD/69wT0kj0S/qxPyeL5eEtpxLNVq1ycZ155t0sm6AgRfz980hjyewZ02cntAc
         utA0VRV1OEz/msaw1kSzKudhoqCt5m/snFod4OlP9nqrYd7k4vLBCXlXkevDuZXgGkLG
         00zOFSHP3IVycFaV9ocIDBtyM2KCu5n1LpLUk/xYzfP4/HoTUto/lBa3sQw2U9hO52mc
         T2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O2Rwuog5zrzICLL6iIlQRQk13JMsB10bdTVaYiW91Iw=;
        b=DTKvnaG/pMXl0JLel/DGN6Xtg6gVnpUTxH+04Fta20bt/7W7QodRnbx1KZSkUzCN3p
         y/KjAIlxN56/WkPPxl7HnWL7zAS1FyhEgGyZ9c6wg1lG3KP7rO3KpMMezQR+V8NDGvlY
         cY58Ye1o3M+EZjJFOLglHpz+dq+p4HyIwpVp36/9NORjZOMRTZuAVcSywcvuo4reDpY2
         kZrcbXI/GUa/wRTOHPZWF7w6eGkk7wbD6L9XILr674w9OFomGDVx7DEPKTxiKaOfOs54
         lggUCizDMgC/uX6ILod+n+so4T17xsDQJku762k3itmN+W5ut4oHTDNbD+dbatPm2PqJ
         qJAA==
X-Gm-Message-State: AJIora8HZVG82L4xaBtxVGPb+uZ7LD3Iz+kt5Oi0sLuS54LWTM0ZDsxH
        sdUvURDv0GWP96bU8j3dcCE=
X-Google-Smtp-Source: AGRyM1usSszpjJI8zNTWwIIFFb5u0mxywpb+/g5/QBExKWjLtqkWDDwDXnfbKBBuf6kj4TS4WSRJXw==
X-Received: by 2002:adf:dc81:0:b0:212:3a72:2f07 with SMTP id r1-20020adfdc81000000b002123a722f07mr5428151wrj.714.1655219135955;
        Tue, 14 Jun 2022 08:05:35 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m16-20020a05600c3b1000b0039c673952bfsm17764478wms.6.2022.06.14.08.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:05:35 -0700 (PDT)
Message-ID: <57c4acfc-af8a-9f0b-753c-47cca3014d14@gmail.com>
Date:   Tue, 14 Jun 2022 16:05:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing 2/3] examples: add a simple single-shot poll
 benchmark
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1655213733.git.asml.silence@gmail.com>
 <c73aebd699e851a36a8a85e263bedc56aa57e505.1655213733.git.asml.silence@gmail.com>
 <1e971a15-3476-1259-ab3b-7c6953d68760@gnuweeb.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1e971a15-3476-1259-ab3b-7c6953d68760@gnuweeb.org>
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

On 6/14/22 15:57, Ammar Faizi wrote:
> On 6/14/22 9:36 PM, Pavel Begunkov wrote:
>> +int main(void)
>> +{
>> +    unsigned long tstop;
>> +    unsigned long nr_reqs = 0;
>> +    struct io_uring_cqe *cqe;
>> +    struct io_uring_sqe *sqe;
>> +    struct io_uring ring;
>> +    int pipe1[2];
>> +    int ret, i, qd = 128;
>> +
>> +    if (argc > 1)
>> +        return 0;
>> +
> 
> Hi Pavel,
> 
> I am testing this and it doesn't compile, the main(void) needs fixing.

Indeed, some of final changes escaped git add. Thanks Ammar

> 
> ```
>    poll-bench.c: In function ‘main’:
>    poll-bench.c:39:13: error: ‘argc’ undeclared (first use in this function)
>       39 |         if (argc > 1)
>          |             ^~~~
>    poll-bench.c:39:13: note: each undeclared identifier is reported only once for each function it appears in
>    make[1]: *** [Makefile:34: poll-bench] Error 1
>    make[1]: *** Waiting for unfinished jobs....
>    make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/examples'
>    make: *** [Makefile:12: all] Error 2
> ```
> 

-- 
Pavel Begunkov
