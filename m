Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97B6C202B5A
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbgFUPb5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 11:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730295AbgFUPb5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 11:31:57 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CD3C061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 08:31:56 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so4009810ejq.6
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 08:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cKx3zaYnVXFnLd9vgiTv5r/9Oi/97lDF1xRj6rLYj9c=;
        b=XYmtPiFq3JzKg3nV+BkYadnCxSOI9FHxmvCsliYhr288r2M4tOJsiAGBQzCrmjNfej
         i9ZbG18pMWuDQfuTbv3XNh8gcfRIpmluzMnFIjOKsQg+va5CQPG1TIJcFeAvV1P+MH9w
         8cb6I8XdDWk/9J3IApy+0+wKBEB+XlGwNjr/ejZ/xinhwVp/lm5NrSGW+4bR+Nlb/ohM
         2jqK5DEo8bO+zKHmSqEUpJhl5iclDquLNhJVjQ8Mec6c3XNKEUoNYKpxeQOkWUu28LpV
         R5MRzoStSBUodqhTvx3i6Opzii85qVgE6obWd7H+5aWEarpesLiS+J+g8JGCdo0it3wx
         Qvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cKx3zaYnVXFnLd9vgiTv5r/9Oi/97lDF1xRj6rLYj9c=;
        b=DAVvinwoTXRaqhpEVqbpuvDXHPJC+JLMvWQedeec27aAcUMBjpKvhuFkFfaff2OcPp
         FD2RhU5+fwa1xqvYR2JjIEAnlEuL8QVeHGgTjI3woosnSQzHtooC+yCFjLUVqsHWSQdZ
         j/nED/zPd1JYU74pZbsA342RYQiuvOYuibjsbnFXbquNuqPrnlaqHovUjMqSmiNZfh0d
         km+ds6lFgV8secpfCmyO2znoPK81PYPfseOc6168vgJlHqxKyy3CGFkQsspOKd6wSq23
         xY+rGUhROmZCL/tYRMCqDbEhgvODci/wiyRfHJTD0hdE9jmRBCm2t2v3ogdS7GJbMO55
         V/zw==
X-Gm-Message-State: AOAM533VdhCyt1pPttrh5umfmi4dNZ1omF8R9AL9Eiy9pEp16Sh7RwsD
        XNorpdVad2IBqHwM12a+rqKQdNGY
X-Google-Smtp-Source: ABdhPJxUGsVGdG5YdKZ5SgHTBS3REwSLatKhSugBrUbiF3tTZkierr9FC3zE58KW+/MJaTlFseyReQ==
X-Received: by 2002:a17:906:22cc:: with SMTP id q12mr12467980eja.485.1592753515385;
        Sun, 21 Jun 2020 08:31:55 -0700 (PDT)
Received: from [192.168.43.206] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id y21sm10359032edl.72.2020.06.21.08.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 08:31:54 -0700 (PDT)
Subject: Re: [PATCH liburing] Fix hang in in io_uring_get_cqe() with iopoll
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <c1c4cd592333959bf2e0a4d2381372f1b40aef7b.1592735406.git.asml.silence@gmail.com>
 <b7e1f0c9-8650-d45f-5821-6c4984bec320@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8e9d1846-2bb0-4827-c527-9834c9101775@gmail.com>
Date:   Sun, 21 Jun 2020 18:30:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b7e1f0c9-8650-d45f-5821-6c4984bec320@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21/06/2020 18:23, Jens Axboe wrote:
> On 6/21/20 4:30 AM, Pavel Begunkov wrote:
>> Because of need_resched() check, io_uring_enter() -> io_iopoll_check()
>> can return 0 even if @min_complete wasn't satisfied. If that's the
>> case, __io_uring_get_cqe() sets submit=0 and wait_nr=0, disabling
>> setting IORING_ENTER_GETEVENTS as well. So, it goes crazy calling
>> io_uring_enter() in a loop, not actually submitting nor polling.
>>
>> Set @wait_nr based on actual number of CQEs ready.
>> BTW, atomic_load_acquire() in io_uring_cq_ready() can be replaced
>> with a relaxed one for this particular place.
> 
> Can you preface this with an addition of __io_uring_cqe_ready() that
> doesn't include the load acquire?

Sure

> Also, s/io_adjut_wait_nr/io_adjust_wait_nr for the patch.
Ouch, a typo


-- 
Pavel Begunkov
