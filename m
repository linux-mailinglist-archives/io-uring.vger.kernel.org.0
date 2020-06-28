Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEEC20C88F
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 16:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgF1OuD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 10:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgF1OuC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 10:50:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B08C03E979
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:50:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so14066539wru.6
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=72B3AokVhl6jNraKRPd9EOTZC5QIzquxXcC47gpz49k=;
        b=mLLoF3Bzb/lgCjf18tek64ydU0gPVkhRUnsGMggqk+fm7PNJLXpgpR8DftvGKHXgG6
         2kSDE9pZ7ob2o9iUbaBPU2emDJ28iKpTK0g6XEHtW2eGCKZ2ORYhfo9onY4vSfmEgHdX
         Qv8D/eVyPQk+aXXKprqalGsX0ZWp1Pwz/X36/tPrIxKoE0O+QYyM2EQiX5Uk41+hS8J5
         HcBFsZKSHvQPZd79QIx/AJgpGPGPoA/tsvOHxWQWwmFf7EpfS9iKt43qZ0QPMxe3/qb0
         c4yeeSTHQlQallc8LkmdYUkJRpZHpMRXOkAa1VmEP3B9O/G1OKHSuHuKhSxyD3WngX2n
         OQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=72B3AokVhl6jNraKRPd9EOTZC5QIzquxXcC47gpz49k=;
        b=s1pTnw7EkYkY6HzDdVN7m2RAH6iC0BUzfgaRweCV8lwS4ylqoUDS+zOg5HFV3CANgj
         DYOv5L12BFod1S8XyRAw/PK5bpg4Xr6SDhAMpKOBkYn1WhuzA9ZuPtUgNSbouxMYYL5h
         U0F0mSVE80gn1qbYAFbhJVH3gAFuNVbwJ++6BP6gTDmyKbdmIwPaPjWbxiPbbDWounvU
         tuIgH1rYF+/TFlwuKCuBQmEkX92CedjCXHZV9optUnAC9tTnPZx/wzmmLN5Izd/gaXsv
         eGMd4iYKQOrDpoBxsCzhwELnpPJKeSfpwmlEHyoZB/pASBr+uLV/nhr8G2PQQITmGNFz
         EapA==
X-Gm-Message-State: AOAM532RoNiCRPHlB1ePrRzCZ5IhWUhbSKiiwvPpUiDSsa/DZNdal3AZ
        iQkZvgZszT/z//ZkiRvom+B4yyQv
X-Google-Smtp-Source: ABdhPJwtzyWtT6OONxkEx60So4p4N+Lq/N0LwZVeoiaU9zY8Hk2u4gHFrxdTW3XjA9S/sUfIx7UfXg==
X-Received: by 2002:adf:f14c:: with SMTP id y12mr12932125wro.30.1593355800955;
        Sun, 28 Jun 2020 07:50:00 -0700 (PDT)
Received: from [192.168.43.39] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id c20sm45478687wrb.65.2020.06.28.07.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 07:50:00 -0700 (PDT)
Subject: Re: [PATCH 08/10] io_uring: fix missing wake_up io_rw_reissue()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1593337097.git.asml.silence@gmail.com>
 <6a4a9caabaf6b74de7cd852d263c9eb284cd014b.1593337097.git.asml.silence@gmail.com>
 <67a10cea-5ee5-ea23-42c5-0d2124df4efe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <65fbdf1d-50a8-7609-4552-c587350f190d@gmail.com>
Date:   Sun, 28 Jun 2020 17:48:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <67a10cea-5ee5-ea23-42c5-0d2124df4efe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/06/2020 17:12, Jens Axboe wrote:
> On 6/28/20 3:52 AM, Pavel Begunkov wrote:
>> Don't forget to wake up a process to which io_rw_reissue() added
>> task_work.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 5e0196393c4f..79d5680219d1 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2172,6 +2172,7 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
>>  	ret = task_work_add(tsk, &req->task_work, true);
>>  	if (!ret)
>>  		return true;
>> +	wake_up_process(tsk);
>>  #endif
>>  	return false;
>>  }
>>
> 
> Actually, I spoke too soon, you'll want this wake_up_process() to be for
> the success case. I've dropped this patch, please resend it.

Oh, a stupid mistake. Thanks for taking a look


-- 
Pavel Begunkov
