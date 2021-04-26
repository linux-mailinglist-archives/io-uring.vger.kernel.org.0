Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5AF36B140
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 12:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhDZKJA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 06:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbhDZKI4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 06:08:56 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27170C061756;
        Mon, 26 Apr 2021 03:08:01 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id i129so2695794wma.3;
        Mon, 26 Apr 2021 03:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0CxAJGsWfI6bvhx4b1S37+OR2+rBYziqOE1wt59EsZg=;
        b=S5t3GYNrV+ALejk5CjzFyXgtMXkTv7+uQH07LQLfMYJY3aeSAqe3mhuv6BZ56SXfxn
         jdbSofskOT2mc37i/0sTYu8fK9WmRHOzMhXP9x4vkhSDwplWxac1DY9cTo0RjnbnTPVi
         QlqcZ4zGVZfiESfLMyizVFAbixj3MRKUd1fGSv+NcfDuovx8CaaPHylemxPUqT5VZ5ey
         W6cTA/A0vLNpAE5xw93MaHckjX50TEvMK+QlMDT3eoJYLJf3TH+YX+QLYWLpHy+R3Jqg
         LMPVG0XMmzhElR2Vze40vye9WSou6S0QI+jqexoOo4Jcj2V+bLhY1dNCUy1iXKv4epCc
         QCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0CxAJGsWfI6bvhx4b1S37+OR2+rBYziqOE1wt59EsZg=;
        b=O05+RBW8lCbjT0vD/gSWZmjUamd5ppUNGzUF/Fc1JhQ4Mx6X7d7hib40qZImUz4xmW
         3RE/F56GMgc/cCEpuL9LgZ5iYpcHyz+7ky41ZTKYeEIvcU5xUmNjl9YUtYISoC+3e8Qa
         YK0ze75B2u7/fesq3CfjKxSw73/w8SA6HdEpZwaRtyp1v+b7Q+yUAMJQ+N97iV/TakPW
         evxIZoQpyH1CKB5vqOx1c53enVUivgVn2wkn1FKJzETCoDe3cUUdy0dHOjrSbMlrw5bU
         Q5/nQyWPhmaYDeyw42dXVOGMYEWkXUaEmALipDhbPFDQu08hdKpE64Qej5QevbTIUNn2
         RTVg==
X-Gm-Message-State: AOAM5335sw+HQUdWDq+dO1J1wiMvaorskYBJO1fgeV/tzJr3SheoEu6o
        NuvRkecJ/iSnEaa2ODDECRalbyFifLg=
X-Google-Smtp-Source: ABdhPJwXxNRZ4EIEH2sh8LmxS8Phmq2ir+hukGmNyHrZ1yVZC/dp7ISf+xGxF+GogBm3SA7COHBsgQ==
X-Received: by 2002:a1c:9a95:: with SMTP id c143mr18905903wme.143.1619431679736;
        Mon, 26 Apr 2021 03:07:59 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id a22sm19613170wrc.59.2021.04.26.03.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 03:07:59 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Fix uninitialized variable up.resv
To:     Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210426094735.8320-1-colin.king@canonical.com>
 <ef9d0ed2-a8cd-fc4a-5b02-092d2c151313@gmail.com>
 <b937f247-e5b2-0630-aa7a-72d495a20667@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <681850b0-fe2a-ae9e-a55b-6788fce71a8e@gmail.com>
Date:   Mon, 26 Apr 2021 11:07:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <b937f247-e5b2-0630-aa7a-72d495a20667@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/21 11:01 AM, Colin Ian King wrote:
> On 26/04/2021 10:59, Pavel Begunkov wrote:
>> On 4/26/21 10:47 AM, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> The variable up.resv is not initialized and is being checking for a
>>> non-zero value in the call to _io_register_rsrc_update. Fix this by
>>> explicitly setting the pointer to 0.
> 
>                           ^^ s/pointer/variable/
> 
> Shall I send a V2?

If you like, but if you don't want to resend it's not important, or
Jens can edit it while applying.

> 
>>
>> LGTM, thanks Colin
>>
>>
>>> Addresses-Coverity: ("Uninitialized scalar variable)"
>>> Fixes: c3bdad027183 ("io_uring: add generic rsrc update with tags")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  fs/io_uring.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index f4ec092c23f4..63f610ee274b 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -5842,6 +5842,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>>>  	up.data = req->rsrc_update.arg;
>>>  	up.nr = 0;
>>>  	up.tags = 0;
>>> +	up.resv = 0;
>>>  
>>>  	mutex_lock(&ctx->uring_lock);
>>>  	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
>>>
>>
> 

-- 
Pavel Begunkov
