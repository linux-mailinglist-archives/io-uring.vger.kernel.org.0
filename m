Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEC5F6FCB
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 22:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJFUzH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 16:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiJFUzG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 16:55:06 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A7629C92
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 13:55:04 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u10so4473629wrq.2
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 13:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F3AxfhxQb68xnV9J9LEAZgKXEDnloxUT0DxXhxt4t0Q=;
        b=YjYB+/Gh+6qryPAS/UdtXkDolj4r2KGutlMmrwztNR+uPbKLxzB/kP5nGulMUgka3C
         gqGX1qa/MEkE9qv9N+OTBjMNAhyjAHkpRnh9SSopGVFGAYw2+5W8QWKoQjDnQfrbGOdT
         567dINjNVT/EoZgPk74rZn4vBD5mEGP4oMJv0hPSDQV2ebsvVyl3V7ZHdzo49q8RnGf7
         Xn4LtPnp0ZIwIph1lDN5H4EQRr+ncvkSewZDGEgvX0Ujg0QC+uQcYgBeGkBfaCRMA0sL
         N09I68ViMFCk54+VghinJO7a0b0royQ9YDw5WJbx/ysGiUFEEnWUJdpKi0VSGOom87RT
         VeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F3AxfhxQb68xnV9J9LEAZgKXEDnloxUT0DxXhxt4t0Q=;
        b=LoLgrliAeXoX8tCuuMcpCLUx/nY//plgV3ClI2xs6ln8vyxe/7ED6FA7pPeLXEOgzP
         cp8XTJZnISxQxf6YQE8CxOVtWMGG7CQ2hjEvliZ7efbpgImcz0AxLQCk/ZcH07upHw9F
         oS0uDduCOqnlt1QifpqrTxZg5TVLybUpMHN3wfZHGpNNfs5W3HAesGpLwOoyzY36TOYu
         FKfAObhw5szV3m/eN2M1vAJ1U04d1Td9XiwriuW7D5xjO03lMicpwWUv6hfdbHvjcsS2
         3IiEHviv4b0JfTmrjTrXwPWV42LHlBja2lF8PSAQo9W3r1aMQEfB39g1BZMJswRh7Yly
         pfwg==
X-Gm-Message-State: ACrzQf3uyqdyJIeOm8/SPZgUy65clsi7Zv38Awthx0C16ap8omaiDH/B
        71KAt3353AJd0OFWbq1ZuahDml55YjU=
X-Google-Smtp-Source: AMsMyM6jHSu3deQpWUuI3eJNdg2bfvUGGIbE+wlCWynADmiWwV4urmKryTvEvPTzkkpj6QU/VbDO6Q==
X-Received: by 2002:a05:6000:2ad:b0:22a:399b:5611 with SMTP id l13-20020a05600002ad00b0022a399b5611mr1168742wry.434.1665089702545;
        Thu, 06 Oct 2022 13:55:02 -0700 (PDT)
Received: from [192.168.8.100] (94.196.209.4.threembb.co.uk. [94.196.209.4])
        by smtp.gmail.com with ESMTPSA id bv10-20020a0560001f0a00b00228fa832b7asm308448wrb.52.2022.10.06.13.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 13:55:02 -0700 (PDT)
Message-ID: <b715a101-3ef6-6772-fb13-c6270520b7e9@gmail.com>
Date:   Thu, 6 Oct 2022 21:54:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next 0/2] net fixes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1664486545.git.asml.silence@gmail.com>
 <166449523995.2986.3987117149082797841.b4-ty@kernel.dk>
 <27c5613c-6333-c908-0c73-02904a8e5c37@gmail.com>
 <266638fb-7406-907d-c537-656bed72fac3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <266638fb-7406-907d-c537-656bed72fac3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/22 21:46, Jens Axboe wrote:
> On 10/6/22 2:30 PM, Pavel Begunkov wrote:
>> On 9/30/22 00:47, Jens Axboe wrote:
>>> On Thu, 29 Sep 2022 22:23:17 +0100, Pavel Begunkov wrote:
>>>> two extra io_uring/net fixes
>>>>
>>>> Pavel Begunkov (2):
>>>>     io_uring/net: don't update msg_name if not provided
>>>>     io_uring/net: fix notif cqe reordering
>>>>
>>>> io_uring/net.c | 27 +++++++++++++++++++++------
>>>>    1 file changed, 21 insertions(+), 6 deletions(-)
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>
>> Hmm, where did these go? Don't see neither in for-6.1
>> nor 6.1-late
> 
> They are in for-6.1/io_uring with the shas listed here too:
> 
>>> [1/2] io_uring/net: don't update msg_name if not provided
>>>         commit: 6f10ae8a155446248055c7ddd480ef40139af788
>>> [2/2] io_uring/net: fix notif cqe reordering
>>>         commit: 108893ddcc4d3aa0a4a02aeb02d478e997001227
> 
> Top of tree, in fact:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-6.1/io_uring

See now, thanks, seems messed up pulling branches

-- 
Pavel Begunkov
