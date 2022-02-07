Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA14ACA35
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 21:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiBGUMq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 15:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241216AbiBGUJb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 15:09:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 424E0C0401E1
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 12:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644264569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oAKAsUPUKTpUUZnEXmxnxU0YG6aRlUUAiMH3EfYzKGI=;
        b=Oktdx55Cy5+2kois0hc1tjCINo1p98Db30JtaAn6aIO7gJhyjKhxTpsow32a1Nf4z/SoKR
        fVsv5Pniy0Uei2riVwRXpLUpLPaJbOoQ5qQ06LNpoyqpNIcl3aCkNTUZTDT6boCczQe+qH
        fx6OFH8dZdbHhW0NJ42zkvW8BtMYeQ4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-Tk7t2zaTPvidgoaBfMfNoQ-1; Mon, 07 Feb 2022 15:09:28 -0500
X-MC-Unique: Tk7t2zaTPvidgoaBfMfNoQ-1
Received: by mail-qk1-f199.google.com with SMTP id h10-20020a05620a284a00b0047649c94bc7so9368931qkp.20
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 12:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oAKAsUPUKTpUUZnEXmxnxU0YG6aRlUUAiMH3EfYzKGI=;
        b=F9c37VVATHMmrKs38tpIrVRlvTGN4euEaD6QfZi7SoozMj+YvypGRcX8aPbKiu3VrS
         2reIV7hyaG471hF5h4r4EzpL9RQcLDydd/G1EaWN2KGIcOicQhaD8EFGy6RYAgidDTWm
         GX8kp4OdUDNi56wdbaVBuXwVD3yJU0vy1LXSnRAOC/grAJGM1eO/6zO/axpxxcDo2FvF
         ZPjnTbMrVp/lDgq+LvViu2gQXGDqB/aVC31Eq67uwy5QMFafUJQ7rGy3q1qTk3xDiIAn
         7azg5y7V1JdAc/TyDbf/qaQleZMa4MneG/m3vQptaym0lMt41pwaDe30YTFtfErucNSJ
         jF4g==
X-Gm-Message-State: AOAM533p7b2YvmBqQADXcSgcSqDXBLn+IEi13iT+0geEuxHmEvk+m5z4
        EgVLk5y+4APagVDRm/6YSjl5C2vdysVa6KWAxhmpt12YEVliNQtEBeOgOjUP71QgtIFSLThcumg
        DsCd2WJDVX0C8wxZ17R8=
X-Received: by 2002:a05:622a:592:: with SMTP id c18mr830646qtb.135.1644264567634;
        Mon, 07 Feb 2022 12:09:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywAnyIcF5clfnoxlwiuAguCyMOTb/Q0XK6fapq4xAke4rq7+JEFToSVHf/fm0Di7oe+k2noA==
X-Received: by 2002:a05:622a:592:: with SMTP id c18mr830628qtb.135.1644264567407;
        Mon, 07 Feb 2022 12:09:27 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id s9sm4840314qki.101.2022.02.07.12.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 12:09:26 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix uninitialized return
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, nathan@kernel.org,
        usama.arif@bytedance.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220207185126.2085525-1-trix@redhat.com>
 <CAKwvOdnyPZ6w5qg-+W0H0ait3KUV5S9+-gmty-ANK46BeKd5VQ@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <831dd322-4931-2285-4408-79df5ab1df64@redhat.com>
Date:   Mon, 7 Feb 2022 12:09:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAKwvOdnyPZ6w5qg-+W0H0ait3KUV5S9+-gmty-ANK46BeKd5VQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 2/7/22 11:48 AM, Nick Desaulniers wrote:
> On Mon, Feb 7, 2022 at 10:51 AM <trix@redhat.com> wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> The clang build fails with this error
>> io_uring.c:9396:9: error: variable 'ret' is uninitialized when used here
>>          return ret;
>>                 ^~~~
>> Return 0 directly.
>>
>> Fixes: b77e315a9644 ("io_uring: avoid ring quiesce while registering/unregistering eventfd")
>> Signed-off-by: Tom Rix <trix@redhat.com>
> Thanks for the patch:
> See also:
> https://lore.kernel.org/llvm/20220207162410.1013466-1-nathan@kernel.org/

No worries as long as it gets fixed.

Tom

>
>> ---
>>   fs/io_uring.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index aadabb31d6da7..74afb96af214c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -9393,7 +9393,7 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
>>          ev_fd->eventfd_async = eventfd_async;
>>
>>          rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
>> -       return ret;
>> +       return 0;
>>   }
>>
>>   static void io_eventfd_put(struct rcu_head *rcu)
>> --
>> 2.26.3
>>
>

