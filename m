Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386CF3460A0
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhCWN6T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 09:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhCWN56 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 09:57:58 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191BAC061763
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 06:57:58 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id e8so17762173iok.5
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 06:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I90ESuI5O8aLWAh43m6u5xnoYufJpw6WlLxYZkk9+Zo=;
        b=j2vBu9b0wEu3bKeLTQW7Ym1EtfKzXGgj/iQrIZ2m8ExDYMCmI1c4OEkL8p19FrQDup
         Dha5zROTkt2CF9FjaxcLmWzrdMtuLcInpsRgtY0Vn7nzcYHnYhMqBEU6Frv2qXjjGqZW
         hsq4IR6cVjUYue1DlvOjBCrnbu6QCh2KNxxpDj31cw2WWdowlcqEgniBXNfxrWqlxRi4
         0gYWZso9PkXOhPgW/3rXc5Tk5R+U34iPAJy2MqnuH0dvfLVyzxxFwulU8y0xyVQ3IT/d
         Ag6xuzJF9uEm6R4CBpWuCu5s3PL8bjX4ENvApPvfzmUNWIxJY7mvLe8NKRRKYKRi0XaL
         /K5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I90ESuI5O8aLWAh43m6u5xnoYufJpw6WlLxYZkk9+Zo=;
        b=KJl/HVdNPQBjzkpYXxwy9h0kwfYNFplno6ZqEQTBUYiPjZrYfU3zLjDIRh5m0OAAS1
         MrbuQ8x3H1p5XXCmOnlvv/q94lcOZohVKJ2YC/gOW3OI++k/n0D+puvBN5WKeUeyUrEz
         8XkEeqQXz2TMOF3w2j+cJ4DQHlEhYi+ozwURUWafiYD5Q7U6UOxXBNwT4k8UFBXQLQJt
         LIZkvj2vG+oj6skxlnDXGaXgBlVCUiM+M/ll0Sj2EJS+BZrCWD5ZrsEcfG3c/FFQgSfo
         j3y+XOk7gcgx/roU/oA0+72dBCAWq1zkUo29xSeF0HvuCm4TWfrRVhoc3Qkiw6qHLqMq
         JTlA==
X-Gm-Message-State: AOAM532A9g8g92V5iI/rznFS1Gf6jYbSQJRsC/oGc+XErWZ3akYJ2F+T
        InGqMtSZ140sbbNGoXC5iOATIn2BjtkJYg==
X-Google-Smtp-Source: ABdhPJwuUePmH8V6TEhXmk3yrWNBex2GWI4r2xJOyJNrNYBCfummNQykZiA2uKOL/ODJbR9/0WDFbw==
X-Received: by 2002:a02:230d:: with SMTP id u13mr4639324jau.53.1616507877108;
        Tue, 23 Mar 2021 06:57:57 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v19sm8956737iol.21.2021.03.23.06.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 06:57:56 -0700 (PDT)
Subject: Re: [PATCH 2/2] io-wq: eliminate the need for a manager thread
To:     Hillf Danton <hdanton@sina.com>
Cc:     io-uring@vger.kernel.org
References: <20210322180059.275415-1-axboe@kernel.dk>
 <20210323091522.2185-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e1ab2eae-d090-4708-da61-8573fcb1a100@kernel.dk>
Date:   Tue, 23 Mar 2021 07:57:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210323091522.2185-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/21 3:15 AM, Hillf Danton wrote:
> On Mon, 22 Mar 2021 12:00:59   Jens Axboe wrote:
>>  
>> @@ -109,19 +110,16 @@ struct io_wq {
>>  	free_work_fn *free_work;
>>  	io_wq_work_fn *do_work;
>>  
>> -	struct task_struct *manager;
>> -
> [...]
>> -static void io_wq_cancel_pending(struct io_wq *wq)
> 
> No more caller on destroying wq?

Should probably keep that for io_wq_destroy(), I'll add it.
Thanks.

>> -{
>> -	struct io_cb_cancel_data match = {
>> -		.fn		= io_wq_work_match_all,
>> -		.cancel_all	= true,
>> -	};
>> -	int node;
>> -
>> -	for_each_node(node)
>> -		io_wqe_cancel_pending_work(wq->wqes[node], &match);
>> -}
> [...]
>>  static void io_wq_destroy_manager(struct io_wq *wq)
> 
> s/io_wq_destroy_manager/__io_wq_destroy/ as manager is gone.

Renamed - also missed another comment on having the manager create
a worker, fixed that one up too.

-- 
Jens Axboe

