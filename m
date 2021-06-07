Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83739E5A0
	for <lists+io-uring@lfdr.de>; Mon,  7 Jun 2021 19:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFGRkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 13:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhFGRks (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 13:40:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E5DC061766;
        Mon,  7 Jun 2021 10:38:46 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id k25so22542771eja.9;
        Mon, 07 Jun 2021 10:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=odod/aL580usFoCrQ2ZIpR8f8KNjq0Ei0avyia9Sm5U=;
        b=btDts6FyI+dIQ7q2H4EKchwLevR6PmKqB9yrQtP4JEoPCxNeikQzMRWuoVBr09DLq+
         wK36KEtgglgUjflNdkOlcmRTOTlISWuhbWSzGN1MZwcVdll7bQa2/DofYyB0H7iph/Nc
         erYUYoLUk/9eCD+J3M9XpJSReTpMR+2WbY2Q7QW7gNaCPeWh5VR0SZoMMUr6On+krq5E
         HstA9K/iZc5t0rx9coL1SgRqmxlG5oWbBv+WPBh7SkN6uH5cWpZv+2wuPXJ3p0klN8hd
         5ojXthNK6TADGmBNMucCTeY9EYt7ccrEYXgISF60drqxtbyPZ2g+c57WRx+fB7HYY0YW
         jD9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=odod/aL580usFoCrQ2ZIpR8f8KNjq0Ei0avyia9Sm5U=;
        b=lflnWAL8YgkUfXZgU1i1kVWheRwiledZso+HLtDPSCxuwNMrP1AG9ppxBLoREFMkDy
         Yg8cIexVFRw8gNFPaf9jjm7Qxc/hNUL5ZU5GM6DdVn9TJkRb4o2mohERjZfBrlHmqti7
         m1ebSZ32Oq69sVBRkMiDLlTxKCRetS0ZqsgkAnjbJT5oc6VWwWi8wFGoXcH5Yp+WnIjC
         ircva32lawfYz2xMmzfWNRgsYWZV4gMjzB3Sg0QkvyHYSRVGRXXqeX9KYQLOTR1FaxtA
         KxUbZ56P6+EOr99jYQiMvPsMVoqRC6MhT+4mBycBFpimEBw4dAC7RU+SeyAVhHs/8OwV
         0STA==
X-Gm-Message-State: AOAM532bBC/OCvIEAAZbhpyhfa7A0T24ftRhKqIsFVxOCvkqdeViWIB8
        rEKgHN/drscIyI3ELsbtbjQPF7+I6QiKlmlW
X-Google-Smtp-Source: ABdhPJx0ZnhReR/1jiqP8yhgnrq7/Ghvsm+fhz4+W9eiJN6bvdX6MLhEwTsJ9Pi7s1DVhaCLdDOFzQ==
X-Received: by 2002:a17:906:cc14:: with SMTP id ml20mr19631965ejb.515.1623087524928;
        Mon, 07 Jun 2021 10:38:44 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:f766])
        by smtp.gmail.com with ESMTPSA id y10sm1730308edc.66.2021.06.07.10.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 10:38:44 -0700 (PDT)
To:     "Zhang, Qiang" <Qiang.Zhang@windriver.com>,
        Hillf Danton <hdanton@sina.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com" 
        <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210524071844.24085-1-qiang.zhang@windriver.com>
 <20210524082536.2032-1-hdanton@sina.com>
 <DM6PR11MB4202B442C4C27740B6EE2D64FF269@DM6PR11MB4202.namprd11.prod.outlook.com>
 <916ad789-c996-258f-d3b7-b41d749618d8@gmail.com>
 <DM6PR11MB4202561CE9ECD5B7F8DD74AFFF259@DM6PR11MB4202.namprd11.prod.outlook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: =?UTF-8?B?UmU6IOWbnuWkjTog5Zue5aSNOiBbUEFUQ0hdIGlvLXdxOiBGaXggVUFG?=
 =?UTF-8?Q?_when_wakeup_wqe_in_hash_waitqueue?=
Message-ID: <9af68623-57e4-cef0-bb61-347207fb0c45@gmail.com>
Date:   Mon, 7 Jun 2021 18:38:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <DM6PR11MB4202561CE9ECD5B7F8DD74AFFF259@DM6PR11MB4202.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/21 3:01 AM, Zhang, Qiang wrote:
[...]
>> Haven't looked at the trace and description, but I do think
>> there is a problem it solves.
>>
>> 1) io_wait_on_hash() -> __add_wait_queue(&hash->wait, &wqe->wait);
>> 2) (note: wqe is a worker) wqe's workers exit dropping refs
>> 3) refs are zero, free io-wq
>> 4) @hash is shared, so other task/wq does wake_up(&wq->hash->wait);
>> 5) it wakes freed wqe
>>
>> step 4) is a bit more trickier than that, tl;dr;
>> wq3:worker1     | locks bit1
>> wq1:worker2     | waits bit1
>> wq2:worker1     | waits bit1
>> wq1:worker3     | waits bit1
>>
>> wq3:worker1     | drop  bit1
>> wq1:worker2     | locks bit1
>> wq1:worker2     | completes all wq1 bit1 work items
>> wq1:worker2     | drop  bit1, exit and free io-wq
>>
>> wq2:worker1     | locks bit1
>> wq1             | free complete
>> wq2:worker1     | drops bit1
>> wq1:worker3     | waked up, even though freed
>>
>> Can be simplified, don't want to waste time on that
> 
> Thanks Pavel
> 
> Your description is better.  I have another question: under what circumstances will three io-wq(wq1, wq2, wq3) be created to share this @hash?

Oops, missed the email. It's created by io_uring, and passed to
io-wq, which is per-task and created on demand by io_uring.

Can be achieved by a snippet just below, where threads
haven't had io_uring instances before.

thread1: ring = create_io_uring();
thread2: submit_sqes(ring);
thread3: submit_sqes(ring);

> 
> This kind of problem also occurs between two io-wq(wq1, wq2). Is the following description OK？

Yep, and I feel like there are cases simpler (and
more likely) than the one I described.

> 
> wq1:worker2     | locks bit1
> wq2:worker1     | waits bit1
> wq1:worker3     | waits bit1
> 
> wq1:worker2     | completes all wq1 bit1 work items
> wq1:worker2     | drop  bit1, exit and free io-wq
> 
> wq2:worker1     | locks bit1
> wq1                       | free complete
> wq2:worker1     | drops bit1
> wq1:worker3     | waked up, even though freed


-- 
Pavel Begunkov
