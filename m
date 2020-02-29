Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC914174870
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 18:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgB2RfJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 12:35:09 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40692 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgB2RfJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 12:35:09 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so2511176plp.7
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 09:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ucKg7yIAcYSWvuvekFlz4NVFT6ISO9mVkelMtFsnagg=;
        b=iIeRc183WPbDkT17vPUuV15kB4hAws5wbSapv9Aik01xoE311Iu/njxN5gjNbWxjTh
         KlvZ25KKOAMdzSYiN8mH0crP33eN4uFbia9yx5VU8yYGhyDNPi2oUmMgCQFSTnoapHhZ
         +XlUxhkTOxnBQUvB1LdpsXhouzyg2RqRJGg7t6h12s/qm98NZSOpUuVzVwwoppGZlwqm
         mXq/7I9ZzUcuIp2sOEafP1xoTAwrbxuBQ6FXGyOJGvS8k1WWGkkhhhKoRO/WJk/1wA9v
         wkCF+CjrCOwFjVx6t8rb0cCa3l9QyeDScgWCizSDfMNMMaR4/vBHYgJOR/FQpXaH2nDM
         ogMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ucKg7yIAcYSWvuvekFlz4NVFT6ISO9mVkelMtFsnagg=;
        b=V2M1syIg3FViHjhRyxI6r3fnZmNjG1p09WoxN0d0GNAlmnJ5dW9vgLnYzDg0isRAqB
         KcqXFx35eftuWsAFm53s+AFJv8Ei202RfpH9MUQ4HGdSdtrIYMIoCb8ROi6tEZ1PlZQE
         pAiB6Luh83hfxtLfHBE2K9GVfEPxy5t2Ng9wVLVhaQ+qdnnKuAM38EbUA6Zse64L1t+T
         gWnmtxU8l1dl+Z+jsqlcg1+2fsFTr6vvNigV1FOgiojJLHrV6Q0TCknVdknUSX663CuU
         Oa3KYHwEKUwoYgD6bS/QQIbqM3HnFGU/qKLD/DIVh21sK+itq74fhagHjJzn4x7KPvGu
         le0Q==
X-Gm-Message-State: APjAAAUrxrtWZUQWh8q4g6FJ8pTtsCkRi/Giv+72aaqH3n+eajEJRfpM
        toRUTBkByty7O4Z+wQpTV4eefw==
X-Google-Smtp-Source: APXvYqzRFcl0LOd0wyIT6ifBcWzNRN6JEItcwY62mZaEHXVZsW5c3cLg8OrW+OnOnUBRMY7irfERsQ==
X-Received: by 2002:a17:90a:a409:: with SMTP id y9mr11317944pjp.119.1582997706525;
        Sat, 29 Feb 2020 09:35:06 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b133sm14789846pga.43.2020.02.29.09.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 09:35:06 -0800 (PST)
Subject: Re: [PATCH 3/6] io_uring: support buffer selection
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-4-axboe@kernel.dk>
 <e6fdc525-760d-466f-b754-229d76406e45@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e6892459-9d87-516d-06f3-c4c70bd7f611@kernel.dk>
Date:   Sat, 29 Feb 2020 10:35:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e6fdc525-760d-466f-b754-229d76406e45@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/29/20 5:21 AM, Pavel Begunkov wrote:
> On 2/28/2020 11:30 PM, Jens Axboe wrote:
> 
>> +static int io_rw_common_cflags(struct io_kiocb *req)
> 
> Sounds more like sort of const/idempotent function, but not one changing
> internal state (i.e. deallocation kbuf). Could it be named closer to
> deallocate, remove, disarm, etc?

io_put_kbuf() or something like that is probably better.


-- 
Jens Axboe

