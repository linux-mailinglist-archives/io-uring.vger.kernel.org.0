Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852342DF0A4
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 18:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgLSRL6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 12:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbgLSRL6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 12:11:58 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC80C0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 09:11:17 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so3497658pfm.6
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 09:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nw5aZkOil78pkmugVP07utjO5183COL147Zd7SB6hDs=;
        b=0Inbo0fo4DFvhmEqTgolomgO2/XLcEuwfRIscy8EWbqDDqKREGDbtL3wqiRQs0TEBD
         hFxTayg69veorbRbdOJ0N+Ek0kp7QEuuybzNG5PF0D2CPKEZBF2gPFnkUxQslgskKdXF
         7yU/izrEcjSQyIKRj2zdeqvAtVmvgyK2vNN34oHG5TUDFkE/zhwTs8YR1P/TseIseP1X
         R829qPguLrsoGxeku3VFLXAzyIaXWPQyDTSYYdjRbPYCrg5c5KOAWzVG05DF9uFGNl4i
         1spLhHUUXIURe5keNgLX6JiuurIAGI9YxgC8DtZnHTAPXZE7OGvrp6X0bMjsU731l2d4
         TDuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nw5aZkOil78pkmugVP07utjO5183COL147Zd7SB6hDs=;
        b=VbllYKibPC72kNWZ6m0YWUJBJUDMJiq98ve0ZRCU+jwC+dImDZq25jshvFo53Vb+if
         AzeRtpsG9lmD4fzUX1em5JhQFOhUBWs8zyXIygXVWnSFQjG31oaQN89mypT+uBAbkUF2
         DjqSXeytZBpYWuU8VC3Sa6i8+45xj/6YZgUlTUPNqFpjb4z0HFNomcO+BBzh2k2sU+Bk
         z1ql1AgYQUyApCMK36j9KtfGlgJrCKC1SEsUQQRmnqt9cFcEvNQIaN3WVnNBbsA1jNoE
         1wxRQabdpzqz/G8Rjo0tsRmtdtftLsi7ZPmv2GfeusMCc/+6zTmMNvWmXKs/6+ctHDQm
         2I1w==
X-Gm-Message-State: AOAM530PzSWuO6iEYTdY5NFzSI0YJKbBRXgwVWgRlJ52w8Kjp6mF4/NS
        8VMCIlC8lScCkQZqQX/spcu1eQ==
X-Google-Smtp-Source: ABdhPJzlL8c3h5mUYEBLulLaZsbfUFfNxrSZ5Wk/y4cRalgwcs9YxZCEY/Pgcae4clte11hq1bCtRA==
X-Received: by 2002:a63:194c:: with SMTP id 12mr8997792pgz.159.1608397877316;
        Sat, 19 Dec 2020 09:11:17 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 145sm6246196pge.88.2020.12.19.09.11.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 09:11:16 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
 <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
 <caca825c-e88c-50a6-09a8-c4ba9d174251@kernel.dk>
 <CAAss7+rwgjo=faKi2O7mUSJTWrLWcOrpyb7AESzaGw+_fWq1xQ@mail.gmail.com>
 <159a8a38-4394-db3b-b7f2-cc26c39caa07@kernel.dk>
 <37d4d1fa-a512-c9d0-eaa6-af466adc2a4e@kernel.dk>
Message-ID: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
Date:   Sat, 19 Dec 2020 10:11:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <37d4d1fa-a512-c9d0-eaa6-af466adc2a4e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/20 9:29 AM, Jens Axboe wrote:
> On 12/19/20 9:13 AM, Jens Axboe wrote:
>> On 12/18/20 7:49 PM, Josef wrote:
>>>> I'm happy to run _any_ reproducer, so please do let us know if you
>>>> manage to find something that I can run with netty. As long as it
>>>> includes instructions for exactly how to run it :-)
>>>
>>> cool :)  I just created a repo for that:
>>> https://github.com/1Jo1/netty-io_uring-kernel-debugging.git
>>>
>>> - install jdk 1.8
>>> - to run netty: ./mvnw compile exec:java
>>> -Dexec.mainClass="uring.netty.example.EchoUringServer"
>>> - to run the echo test: cargo run --release -- --address
>>> "127.0.0.1:2022" --number 200 --duration 20 --length 300
>>> (https://github.com/haraldh/rust_echo_bench.git)
>>> - process kill -9
>>>
>>> async flag is enabled and these operation are used: OP_READ,
>>> OP_WRITE, OP_POLL_ADD, OP_CLOSE, OP_ACCEPT
>>>
>>> (btw you can change the port in EchoUringServer.java)
>>
>> This is great! Not sure this is the same issue, but what I see here is
>> that we have leftover workers when the test is killed. This means the
>> rings aren't gone, and the memory isn't freed (and unaccounted), which
>> would ultimately lead to problems of course, similar to just an
>> accounting bug or race.
>>
>> The above _seems_ to be related to IOSQE_ASYNC. Trying to narrow it
>> down...
> 
> Further narrowed down, it seems to be related to IOSQE_ASYNC on the
> read requests. I'm guessing there are cases where we end up not
> canceling them on ring close, hence the ring stays active, etc.
> 
> If I just add a hack to clear IOSQE_ASYNC on IORING_OP_READ, then
> the test terminates fine on the kill -9.

And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
file descriptor. You probably don't want/mean to do that as it's
pollable, I guess it's done because you just set it on all reads for the
test?

In any case, it should of course work. This is the leftover trace when
we should be exiting, but an io-wq worker is still trying to get data
from the eventfd:

$ sudo cat /proc/2148/stack
[<0>] eventfd_read+0x160/0x260
[<0>] io_iter_do_read+0x1b/0x40
[<0>] io_read+0xa5/0x320
[<0>] io_issue_sqe+0x23c/0xe80
[<0>] io_wq_submit_work+0x6e/0x1a0
[<0>] io_worker_handle_work+0x13d/0x4e0
[<0>] io_wqe_worker+0x2aa/0x360
[<0>] kthread+0x130/0x160
[<0>] ret_from_fork+0x1f/0x30

which will never finish at this point, it should have been canceled.

-- 
Jens Axboe

