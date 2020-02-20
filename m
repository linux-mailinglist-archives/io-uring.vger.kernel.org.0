Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7191666EA
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 20:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgBTTM7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 14:12:59 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33061 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgBTTM7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 14:12:59 -0500
Received: by mail-pj1-f65.google.com with SMTP id m7so1418225pjs.0
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 11:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cZyaCBGDakzTMRb4HGl/HCfsDb12luyx4H6QRM3Jq0o=;
        b=YTboF0CQ3QI0Ak2lHPLl2Xjrw55rPQRAGYMmQ1eLUV8/9gB6vP4wnh3q5H0NccBhvg
         gy+yrKtj7kmyOpLLao/K0U/z1/jT3jpAyUAWuGmIjDh58kt1FR1Q0/dPXHWBC2uzB98G
         FoCOMYRMUb4em09IppSNp/9Knnx+W4L681LwMvwBzcDxbiBka0wLD9Q53ikmLRapG6jr
         +4+LHNtuSmouehd0Gzstt9izom85Cw4J+1eavLipRZmbanRP39EURfcWqFmOuT4WuqJP
         6jhhPttVJs/YaVx+9fyAwJxIr5aMFsP5dO/MLC8RtnP2oWB7JcOOnLFSx1cePDz5xAbq
         /KhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cZyaCBGDakzTMRb4HGl/HCfsDb12luyx4H6QRM3Jq0o=;
        b=r8VcyF2VL9b90X78mq/24VhRyYRPLe/zfKiDGQYjMYR7R9f4gQ8mAUDcKIfDOTOqS3
         ehiGHjP0EEjy1nqIoOP3KUkJTiX5HviPwxvhn8zcofDdxHjAFkrI6k3e8ZGU7nYdCSsQ
         V6hRgJCTfHaLEjFl7t6y218NL5H7do36Ck4MO9IKDxnCf+xG0j86V2MA8AB0N46I1HEz
         Wtm5gU0MLknNU8sCaFOAPouQYIZSv1PKf82nBiU0sdb3DUCf8NKoTSa4ui9QYhC/0aOG
         S2ZGhrnX6qHeMBgIdH/DDdqZHQGrzcWz7Qy49sY4+h7JvLBPj6w2EXUpFWA54Njez010
         weXg==
X-Gm-Message-State: APjAAAV6JZbPkUduopYL3Jz40au4+LRXU+fZopHZsWjmyALrha+K6t2j
        fyuf5DAJoqMEkN5Q6Vh8XTYGgA==
X-Google-Smtp-Source: APXvYqymi3XHSvMnZMzWDOPwk2qFhNMunh5i3Giz4uN2Um0mk3KLdehtWdBOMI7PddqIOl8CyBFAtg==
X-Received: by 2002:a17:902:b604:: with SMTP id b4mr31630115pls.340.1582225978439;
        Thu, 20 Feb 2020 11:12:58 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:8495:a173:67ea:559c? ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id q187sm320622pfq.185.2020.02.20.11.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 11:12:57 -0800 (PST)
Subject: Re: crash on connect
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zbBU2j=a0t2zD7k_aGqguwwkzLpPnnrOUAm2DJ3ZUJFvg@mail.gmail.com>
 <5e4904d5-e7fc-c079-e112-5b978c8fa129@kernel.dk>
 <7fa66eac-73d0-c461-98dd-2818434e8bc8@kernel.dk>
 <CAD-J=zbRDiK2PfXW4B=gHjKtqX1SdXHHne9TsD-NVvp-uznkHg@mail.gmail.com>
 <ec76784f-d9fa-d5e3-fcf1-87c2754e419b@kernel.dk>
 <CAD-J=zYOmRvv+-yyvziF4BKM2xjiAwWp=OQEB-M3Gzk-Lfbwyw@mail.gmail.com>
 <ac81e9ef-b828-65e4-f2bb-5485c69fb7b8@kernel.dk>
 <CAD-J=zbdrZJ2nKgH3Ob=QAAM9Ci439T9DduNxvetK9B_52LDOQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2be9d30f-bbca-7aa6-3d8c-34e3fcf71067@kernel.dk>
Date:   Thu, 20 Feb 2020 11:12:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbdrZJ2nKgH3Ob=QAAM9Ci439T9DduNxvetK9B_52LDOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 11:45 AM, Glauber Costa wrote:
> On Thu, Feb 20, 2020 at 12:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/20/20 9:52 AM, Glauber Costa wrote:
>>> On Thu, Feb 20, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 2/20/20 9:34 AM, Glauber Costa wrote:
>>>>> On Thu, Feb 20, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 2/20/20 9:17 AM, Jens Axboe wrote:
>>>>>>> On 2/20/20 7:19 AM, Glauber Costa wrote:
>>>>>>>> Hi there, me again
>>>>>>>>
>>>>>>>> Kernel is at 043f0b67f2ab8d1af418056bc0cc6f0623d31347
>>>>>>>>
>>>>>>>> This test is easier to explain: it essentially issues a connect and a
>>>>>>>> shutdown right away.
>>>>>>>>
>>>>>>>> It currently fails due to no fault of io_uring. But every now and then
>>>>>>>> it crashes (you may have to run more than once to get it to crash)
>>>>>>>>
>>>>>>>> Instructions are similar to my last test.
>>>>>>>> Except the test to build is now "tests/unit/connect_test"
>>>>>>>> Code is at git@github.com:glommer/seastar.git  branch io-uring-connect-crash
>>>>>>>>
>>>>>>>> Run it with ./build/release/tests/unit/connect_test -- -c1
>>>>>>>> --reactor-backend=uring
>>>>>>>>
>>>>>>>> Backtrace attached
>>>>>>>
>>>>>>> Perfect thanks, I'll take a look!
>>>>>>
>>>>>> Haven't managed to crash it yet, but every run complains:
>>>>>>
>>>>>> got to shutdown of 10 with refcnt: 2
>>>>>> Refs being all dropped, calling forget for 10
>>>>>> terminate called after throwing an instance of 'fmt::v6::format_error'
>>>>>>   what():  argument index out of range
>>>>>> unknown location(0): fatal error: in "unixdomain_server": signal: SIGABRT (application abort requested)
>>>>>>
>>>>>> Not sure if that's causing it not to fail here.
>>>>>
>>>>> Ok, that means it "passed". (I was in the process of figuring out
>>>>> where I got this wrong when I started seeing the crashes)
>>>>
>>>> Can you do, in your kernel dir:
>>>>
>>>> $ gdb vmlinux
>>>> [...]
>>>> (gdb) l *__io_queue_sqe+0x4a
>>>>
>>>> and see what it says?
>>>
>>> 0xffffffff81375ada is in __io_queue_sqe (fs/io_uring.c:4814).
>>> 4809 struct io_kiocb *linked_timeout;
>>> 4810 struct io_kiocb *nxt = NULL;
>>> 4811 int ret;
>>> 4812
>>> 4813 again:
>>> 4814 linked_timeout = io_prep_linked_timeout(req);
>>> 4815
>>> 4816 ret = io_issue_sqe(req, sqe, &nxt, true);
>>> 4817
>>> 4818 /*
>>>
>>> (I am not using timeouts, just async_cancel)
>>
>> Can't seem to hit it here, went through thousands of iterations...
>> I'll keep trying.
>>
>> If you have time, you can try and enable CONFIG_KASAN=y and see if
>> you can hit it with that.
> 
> I can
> 
> Attaching full dmesg

Can you try the latest? It's sha d8154e605f84. Before you do, can you
do the lookup on __io_queue_sqe+0x639 with gdb?

-- 
Jens Axboe

