Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C164816872F
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 20:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBUTET (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 14:04:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40031 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgBUTES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 14:04:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id y1so1242727plp.7
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 11:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pov2nbtpb7uvTShm3uitMmW45vbXbgWN1SBbuSp99L0=;
        b=bD3XeLKR9NyPMkpu8EZWbymT0uuHE7q2W+iArtYkwQahRe7pvz3RmaMGpyVZb2wVns
         C9KwFuU2FLwhbwINtWhf6JYjLs4osSIdftjkIc9x9AkYfzRzkPoPpgp9Fu8ffHRlzZDP
         Txl52a92mIS+9fBVhj8B6pCooKfQTlkYKpUYM5TtBAVeBoj/fSpnaij6L4y4csgubJ45
         RKZ9tBoa6ljhOqiBkD9gY9d8b/H08jVeWpnxkCFi8GV99okgaTm7EE0baihqUzpvM6y+
         dbb4YcrDj6erQq84NSSwU/pW0T4BIhaNbbkDsa/tndwQxmEi5Haq99tdg91hXzb5p8D5
         F19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pov2nbtpb7uvTShm3uitMmW45vbXbgWN1SBbuSp99L0=;
        b=V/LzXdMDxLLOf+HPaCZRH64vaquQo7EjnYVQwEzQi76V18i1iBWnvP+K3jEO1/T5AB
         3en0BJoCzVPZAqlo6hx+2mBXzqZG3vPQd2k31Qmhoc+qBwlOzDn6wgiy+kGC1rtt49G/
         cxVsmUd5qgqp4eqwig44NCKRfLJTtZsgYNkVzXwA1Q1cqmH4sVpIZFipJntdG9n3Vgcu
         M2lKqf3k1SWq3C+FDjLX8oQn28jtNJQ/pmIG2eeKTK2hrDb6bZn1AyqPypRVqzJSrnDd
         LxqhhrHE6uHSqInhwgzG9OWNur8l5joShO1VQYtT7PVatFPh5MrK0MwJVRAiojgymipN
         H9Kw==
X-Gm-Message-State: APjAAAW5T+iV0OkSTfnFb9i2wjHQJItXF3geWqKyVucEuH68Iw3BdfVF
        cFcZzMCHGabCBz6XKui7yqLFjvQ4hos=
X-Google-Smtp-Source: APXvYqzNZ2YCaUx94Lp2LA48TZpTJJzdL1hpgFFF2OOS7EioE3973GULQItSThnwKfRa/1Ru5B/ROg==
X-Received: by 2002:a17:90a:c708:: with SMTP id o8mr4833728pjt.104.1582311856859;
        Fri, 21 Feb 2020 11:04:16 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id z27sm3662081pfj.107.2020.02.21.11.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 11:04:16 -0800 (PST)
Subject: Re: Crash on using the poll ring
From:   Jens Axboe <axboe@kernel.dk>
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org,
        Avi Kivity <avi@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <CAD-J=zbKXuF1HCd5yG0oNaizNWZTD3248Oii7xoofQ--EqO3dw@mail.gmail.com>
 <97074e5b-896e-6bd5-3c6e-bfa38bf522c4@kernel.dk>
Message-ID: <c5e2ee4f-0934-c365-343f-867c18021c80@kernel.dk>
Date:   Fri, 21 Feb 2020 11:04:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <97074e5b-896e-6bd5-3c6e-bfa38bf522c4@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 7:51 AM, Jens Axboe wrote:
> On 2/21/20 6:17 AM, Glauber Costa wrote:
>> Hi
>>
>> Today I found a crash when adding code for the poll ring to my implementation.
>> Kernel is 2b58a38ef46e91edd68eec58bdb817c42474cad6
>>
>> Here's how to reproduce:
>>
>> code at
>> https://github.com/glommer/seastar.git branch poll-ring
>>
>> 1. same as previous steps to configure seastar, but compile with:
>> ninja -C build/release apps/io_tester/io_tester
>>
>> 2. Download the yaml file attached
>>
>> 3. Run with:
>>
>> ./build/release/apps/io_tester/io_tester --conf ~/test.yaml --duration
>> 15 --directory /var/disk1  --reactor-backend=uring --smp 1
>>
>> (directory must be on xfs because we do c++ but we're not savages)
> 
> This is due to killing the dummy callback function on the task work.
> I'll play with this a bit and see how we can fix it.

I re-did the code to use task_works instead, can you try the current
one? Same branch, sha is currently 9ba3cd1b8923.

-- 
Jens Axboe

