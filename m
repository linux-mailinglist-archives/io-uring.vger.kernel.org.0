Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7F01662AF
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 17:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgBTQ3K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 11:29:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37343 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgBTQ3K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 11:29:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id z12so2187361pgl.4
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 08:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SG/r67JWUTbKG/NVKlTQyJmMmB4ByEvNOlApqemvMFQ=;
        b=M3kLVjJ5xlbAQuvO0btucLi4cugb+DArQpfRqqwUq4Anm/acqlzZZSSdqNgNHuCoc+
         G7NHPzTjQ8ZinlC9PgLIvjmLEp26ZKCwkZwMcdchjHQIgQFmEoui//lia2Rw8mb74IE5
         5XiuQo/5DnebGzUFCY/Eu2Awq7tVHE5OGtpcFt1rBgeo4aousbGzdAZIesk0K3+ltfQa
         NKvR8tn3cDD4dR0D8tj7V7Ag6HlyblAYY/WaBkSX8ZRaXttsv+/mot/wGw60Q/7iJMyh
         zVtp/l5zn9C4aT16qGmcZlmYvd29JgN9S4URNjX3RwpuzMe1BQVYKCd+jjCMN2qq1ciS
         Vlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SG/r67JWUTbKG/NVKlTQyJmMmB4ByEvNOlApqemvMFQ=;
        b=UwxyTnUUGFMTRM6hIh4Ke6OM3SZi6Cor2XC21VX5w23S4YcNeRVFOP+tVoDCWEuVFe
         ft9jsEmQOWiecgzr4q5O2djYIGz+gOirKa3W2AwMPbtfllp6hz20zvLnfeMFNONXrmN7
         FphzJuXdTdHVhdUeOszufUtzscKZh2ItL8j8HKnWaj9jrnwKQivfSAxF/eO03MO28HV3
         FwrkBIYiIuc1jJgQjz4q1k+1laYWroFP6FEsaXwhUCSl4VvzC9fg1W8wF6PWzsJOwZvh
         1hoMMs+SeJbZm5Giylz7WApwDFI0PM/TMIYfkCNG12Jc8bTXBUMOk4GYVdRkQjcDIBML
         Q0nA==
X-Gm-Message-State: APjAAAUjzEmNEoDa5x0YV0a1Qn0D1iL/nRoNZk5yh1KZzoAJHKOrP7zv
        qqE/Y8qmqRiTqiKwpWnxgjqxjg==
X-Google-Smtp-Source: APXvYqzwmHjHdo9LRjIMyHdZEgcblvkdmqKkN9n5DCrRtfNpm3c+hn7JiknjS/1ybscuDfOCtIcNOQ==
X-Received: by 2002:a65:68d8:: with SMTP id k24mr34998250pgt.208.1582216149570;
        Thu, 20 Feb 2020 08:29:09 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id g2sm4295669pgj.45.2020.02.20.08.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 08:29:09 -0800 (PST)
Subject: Re: crash on connect
From:   Jens Axboe <axboe@kernel.dk>
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
Message-ID: <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
Date:   Thu, 20 Feb 2020 08:29:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 9:17 AM, Jens Axboe wrote:
> On 2/20/20 7:19 AM, Glauber Costa wrote:
>> Hi there, me again
>>
>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
>>
>> This test is easier to explain: it essentially issues a connect and a
>> shutdown right away.
>>
>> It currently fails due to no fault of io_uring. But every now and then
>> it crashes (you may have to run more than once to get it to crash)
>>
>> Instructions are similar to my last test.
>> Except the test to build is now "tests/unit/connect_test"
>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
>>
>> Run it with ./build/release/tests/unit/connect_test -- -c1
>> --reactor-backend=uring
>>
>> Backtrace attached
> 
> Perfect thanks, I'll take a look!

Haven't managed to crash it yet, but every run complains:

got to shutdown of 10 with refcnt: 2
Refs being all dropped, calling forget for 10
terminate called after throwing an instance of 'fmt::v6::format_error'
  what():  argument index out of range
unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)

Not sure if that's causing it not to fail here.

-- 
Jens Axboe

