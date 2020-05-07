Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836FF1C96BB
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 18:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgEGQnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 12:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726134AbgEGQnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 12:43:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA93C05BD43
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 09:43:20 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b6so2263498plz.13
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DVBxnzqeHALknuBlJLzW73kY6O63mg542ix70lW50Dg=;
        b=ARWm8Dl+xklY/OeFroqWohi49Ivi/hUwl8tznqfzxHMZgkiaDpV+b1KJQkAUxAAoVS
         MFcqFUbhpK50VYfTTCWN6fOZisgpgviRoL+fi6MNthdEsAHf4c+EkncHBNMvPTz9S7WB
         /Mgp6za5caYb9ST1unAGWECktUJ6FlUAK1QIXa7CoGCd16RilPIg8T1ipC+mDPn1U0w2
         7RKa6B4PhuX9GasUu5DapCZE/vZKK/OvRjRqPL9+s677Fyxijk5sv5634GqYYJT8Tjy/
         aLZvYvt5ZfwnxIPXvHSauELIFfmJZbMK0ziq1X8/wu6xtK4AZwJtSEvaOOwd5M1IBOGq
         5coA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DVBxnzqeHALknuBlJLzW73kY6O63mg542ix70lW50Dg=;
        b=UkoWcIfjyuErLhattIwfwnHLgA4XD+R7YL10M7X0SunNDjWLZt/6vwsZ529viMp5iq
         ibDczzmydZFNsdvluW48O2FgsbA+HwLfzLRVwYAZdu/DzufWfUFt2XzT5nJAP10tCsRd
         MsDcWjinTPcH5RcXYuutf1oEr3GdhWCocZcmUNqrADZdFFLQ3KjKexoz9rYIG86AGSl9
         dEVrYlez0yjlm7lrBZnCbyIaR8uWKVkh0oq/m2stBHwBAL9ryNK4pK6jJ+u79xhhTf17
         AbJlDI1SITFbnvn6WztaU8pKjhviKBhnEXPkr7FaA7OmS9CO+M5CWETkEO3dD8c0p3sw
         TPSQ==
X-Gm-Message-State: AGi0PuYVxt4B+5r/JGVRPD2AvI8lnQ2lifwcpMtvws4ihw4RUZf5HEFO
        ocOXUj/nZFbfpz6WKRi0lP2rGw==
X-Google-Smtp-Source: APiQypKOQXe/xM2EurYhBKW3ZUhSbmsfsJwnXmi8d7fVTA9752PzscXBYdYH4dTWh6iimwCjSK44tQ==
X-Received: by 2002:a17:902:b598:: with SMTP id a24mr13968670pls.63.1588869799793;
        Thu, 07 May 2020 09:43:19 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1239? ([2620:10d:c090:400::5:ddfe])
        by smtp.gmail.com with ESMTPSA id h13sm5024540pfk.86.2020.05.07.09.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 09:43:18 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
 <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97508d5f-77a0-e154-3da0-466aad2905e8@kernel.dk>
Date:   Thu, 7 May 2020 10:43:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/20 9:42 AM, Pavel Begunkov wrote:
> On 06/05/2020 18:20, Stefan Metzmacher wrote:
>> Am 06.05.20 um 14:55 schrieb Pavel Begunkov:
>>> On 05/05/2020 23:19, Stefan Metzmacher wrote:
>>> AFAIK, it can. io_uring first tries to submit a request with IOCB_NOWAIT,
>>> in short for performance reasons. And it have been doing so from the beginning
>>> or so. The same is true for writes.
>>
>> See the other mails in the thread. The test I wrote shows the
> 
> Cool you resolved the issue!
> 
>> implicit IOCB_NOWAIT was not exposed to the caller in  (at least in 5.3
>> and 5.4).
>>
> 
> # git show remotes/origin/for-5.3/io_uring:fs/io_uring grep "kiocb->ki_flags |=
> IOCB_NOWAIT" -A 5 -B 5
> 
> if (force_nonblock)
>         kiocb->ki_flags |= IOCB_NOWAIT;
> 
> And it have been there since 5.2 or even earlier. I don't know, your results
> could be because of different policy in block layer, something unexpected in
> io_uring, etc., but it's how it was intended to be.
> 
> 
>> I think the typical user don't want it to be exposed!
>> I'm not sure for blocking reads on a socket, but for files
>> below EOF it's really not what's expected.
> 
> Hard to say, but even read(2) without any NONBLOCK doesn't guarantee that.
> Hopefully, BPF will help us with that in the future.

Replying here, as I missed the storm yesterday... The reason why it's
different is that later kernels no longer attempt to prevent the short
reads. They happen when you get overlapping buffered IO. Then one sqe
will find that X of the Y range is already in cache, and return that.
We don't retry the latter blocking. We previously did, but there was
a few issues with it:

- You're redoing the whole IO, which means more copying

- It's not safe to retry, it'll depend on the file type. For socket,
  pipe, etc we obviously cannot. This is the real reason it got disabled,
  as it was broken there.

Just like for regular system calls, applications must be able to deal
with short IO.

-- 
Jens Axboe

