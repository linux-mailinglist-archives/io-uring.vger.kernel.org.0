Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72631308D29
	for <lists+io-uring@lfdr.de>; Fri, 29 Jan 2021 20:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhA2TLQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Jan 2021 14:11:16 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:39472 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbhA2TKy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Jan 2021 14:10:54 -0500
Received: by mail-pl1-f177.google.com with SMTP id b17so5780824plz.6
        for <io-uring@vger.kernel.org>; Fri, 29 Jan 2021 11:10:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zoxp/TsXh9/LNtMrLhx9VBres8tHw9kVtgd04k2J+x4=;
        b=HHGvQ8NEgsspeJU7OYZQwnjGi9/nFcm8ZJUuB3weINtziTECpbJZAJFCcN7U6jFfMH
         VjCww1RY9gUtTdpLSvmwAsnL59apqdZbmfcNujbUoz9wAsw53pVLveglG5IlrTB1eQyG
         wCeXGaO20dKU8NaFczhUoHEN5fzdcdVtFuWxB6fMaHooz9otJ8qZ2PgjSIZKolEtyENl
         U9zbQzCH4g5h5Ag2jDOS09bqM0qrWl8CiVyvRhjgl07slLx7l3qTaMxl87ePIUtDYYVM
         aff64AYfADZp+++uP+kGWERG9xHneFWygF2vgvckkauD6wfGg/OvvczpkryrYz9j2deK
         u55Q==
X-Gm-Message-State: AOAM533fIhlJMV73wnLXX334TwgU3MaDH5vLPPFeUesjONfeAXKJdfJe
        TARibxRPU3bGio6QDJ+YX+z5Oh4mpfY=
X-Google-Smtp-Source: ABdhPJwvI91YCCgIJlEc46B/o3oCdoKtdZIOJkm/+e35L0fss3ts9ye+oS+4Vn1Zyu/5R6R8uLjXHQ==
X-Received: by 2002:a17:90b:8d1:: with SMTP id ds17mr5765491pjb.194.1611947412212;
        Fri, 29 Jan 2021 11:10:12 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:c076:2392:ded5:e7ad? ([2601:647:4000:d7:c076:2392:ded5:e7ad])
        by smtp.gmail.com with ESMTPSA id j26sm6416294pfa.35.2021.01.29.11.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jan 2021 11:10:10 -0800 (PST)
Subject: Re: [PATCH] io_uring: Optimize and improve the hot path
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
References: <20210128183637.7188-1-bvanassche@acm.org>
 <073e23d1-aef6-76f9-f970-b7a0a96aacd2@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e240b712-7bef-4bff-3130-0f0b9eb323cc@acm.org>
Date:   Fri, 29 Jan 2021 11:10:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <073e23d1-aef6-76f9-f970-b7a0a96aacd2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/21 4:46 AM, Pavel Begunkov wrote:
> It doesn't apply well, not for 5.11 nor for-5.12, and one more
> comment below

This patch was prepared on top of Linus' master branch. I will rebase it
on top of Jens' for-next branch.

>>  		req = list_first_entry(done, struct io_kiocb, inflight_entry);
>> -		if (READ_ONCE(req->result) == -EAGAIN) {
>> +		if (smp_load_acquire(&req->iopoll_completed) &&
> 
> No need, you can't get here unless exactly same iopoll_completed
> check succeeded in io_do_iopoll().

Agreed, I will revert this change. Thanks for having taken a look!

Bart.

