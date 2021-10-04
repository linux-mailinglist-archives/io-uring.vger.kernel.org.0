Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7551421872
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 22:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbhJDUfB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 16:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbhJDUfB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 16:35:01 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B844FC061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 13:33:11 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b6so19711432ilv.0
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 13:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6z5IstvTi0ntgnWQEJDCkH6Q5xHIWBkNzdGISpPkPIo=;
        b=uoQDNjuaaoDYlxhpH5kQrLztLUmCpjUQbo65igdIhJ5TZks6pSynjrL3ARZbyzlxJ3
         gH4G4mMKPU4SHxS0Iml3e2gDzdAY+rmk0Af4JYTkcAJNBlmmUQ6azl6Pd2fMpWhHehNn
         p+MnvX9QMM7gQt6iftbfucLYvX550zGYoB+PGcLEsLr5OSLkjlSmH5PDGpVw25OgX+uw
         HoYC2iu3jkH5kqqKQGrcA4ILr7+Tn6NUJhvtF5bolFhc6jO51OnBzsF6FTmI3c+/zNCn
         OuKEocchW66LUsXLUWxoD9aJ9ygtypXQPab7giLYjfqD87GT73TwpSHf6JyZYb3WvJod
         35cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6z5IstvTi0ntgnWQEJDCkH6Q5xHIWBkNzdGISpPkPIo=;
        b=qBWOY/c0yRLL5DzXTKyuVYqljEVwJkgLWTTrsMeUkXpR6HFUzzyXLQXA1q5dZq93Qu
         CxdObfRG/aDggQfnTgBR43dwP5J7jZ1ElBh3OEuw9MD1kj7ufE7DB0rgkBEqJYqVoK38
         CzQaKzbY4fA+7OSCtIIfZPF5htfuIyrZSXgQN8/TEkzUaPj7If/6X1gT/23s6d45pXP9
         Ut2tjGDpXErJme/i1vGybWQxdGNkZJe4YLtaonWGiM7tmunaGSOHBeSnxGX01udX5kSg
         cfod9K9CWq91oRaXdGsOaqabmGITXmWYXWkc2i9FydBr8paz7wbpnex+awItK4Wswf4J
         2U5Q==
X-Gm-Message-State: AOAM533sOgLYck8DPmI2M9a14+SlUsLls38WVjlgAssj1uj2Wnlhj7Vm
        LnJUDNuERtlWdWftsjuZaBdlnrnujB2oQjova6g=
X-Google-Smtp-Source: ABdhPJyD/ApRFBYyPxsKK0+tYgj35cNMbL+wG5AxykHSoat9lYX76fkUlXtZKuVPu5Hvm1ebcXax8A==
X-Received: by 2002:a92:cb43:: with SMTP id f3mr76670ilq.261.1633379590909;
        Mon, 04 Oct 2021 13:33:10 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h5sm10010887ioz.31.2021.10.04.13.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:33:10 -0700 (PDT)
Subject: Re: [PATCH 00/16] squeeze more performance
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1633373302.git.asml.silence@gmail.com>
 <6c6d9fde-5073-792d-312e-a57ee2a09598@kernel.dk>
Message-ID: <af5f6b50-f1e7-7647-4477-57e2942018d5@kernel.dk>
Date:   Mon, 4 Oct 2021 14:33:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6c6d9fde-5073-792d-312e-a57ee2a09598@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/21 2:19 PM, Jens Axboe wrote:
> On 10/4/21 1:02 PM, Pavel Begunkov wrote:
>> fio/t/io_uring -s32 -d32 -c32 -N1
>>
>>           | baseline  | 0-15      | 0-16        | diff
>> setup 1:  | 34 MIOPS  | 42 MIOPS  | 42.2  MIOPS | 25 %
>> setup 2:  | 31 MIOPS  | 31 MIOPS  | 32    MIOPS | ~3 $
>>
>> Setup 1 gets 25% performance improvement, which is unexpected and a
>> share of it should be accounted as compiler/HW magic. Setup 2 is just
>> 3%, but the catch is that some of the patches _very_ unexpectedly sink
>> performance, so it's more like 31 MIOPS -> 29 -> 30 -> 29 -> 31 -> 32
>>
>> I'd suggest to leave 16/16 aside, maybe for future consideration and
>> refinement. The end result is not very clear, I'd expect probably
>> around 3-5% with a more stable setup for nops32, and a better win
>> for io_cqring_ev_posted() intensive cases like BPF.
> 
> Looks and tests good for me. I've skipped 16/16 for now, we can
> evaluate that one later.

For reference, running this on just the faster box:

Setup/Test   |  Peak-1-thread   Peak-2-threads   NOPS   Diff
------------------------------------------------------------------
Setup 2 pre  |      5.07M            5.74M       71.1M
Setup 2 post |      5.23M            5.84M       73.9M

which is a pretty substantial win.

-- 
Jens Axboe

