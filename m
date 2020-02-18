Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7439A162AB1
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 17:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgBRQeA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 11:34:00 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:36685 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgBRQeA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 11:34:00 -0500
Received: by mail-pg1-f182.google.com with SMTP id d9so11212337pgu.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 08:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YbQxDvYegpReUQ+UuFqp2zKjvuxgBMG3YOrZJzrjnkg=;
        b=OQeVgNveGDe/MBUqt7sA6C1nzjwJ3QvGmnrC2f08HdjVvRV+tLRNJKCUmpR8qVFxsE
         VkALWHJ2d2+2F0WvRg619+oTvtGiLW0Gx7/Qqb5WU2LgCMJv4Mt6ABWWoRtJRaJL5nJ5
         CDIiQx6h/GLE6tnudNj3liIHTOe7b0EqNfC+BhQ00ghd9qsMA/aYoO1wkiqh4Wt5gkpR
         Ma2rTDsLTdXt+gsBKBwXBzV2T1RvHTHOlPdV0QMG6RnjAJAX9f3YitSrEY1dr82y2OmK
         rL6RTsrN+nsVGLYee53vIx3v+FG9Ui1FLUlSti45NQ9G4jZJRih0f48EOF784zouPFmg
         KnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YbQxDvYegpReUQ+UuFqp2zKjvuxgBMG3YOrZJzrjnkg=;
        b=sucaQOm8ErFfXowW8xvaQM89T8eUUCbgRlniRHp1fZPPXw0Yx7ka5f2WoGkR/ERPBO
         A+pALDNmlp+6GzGqaOuUCBDXQlFFzNbany8sK0yAhNdrIpZ1vPK0TL8vOUypHDS09D6l
         FWnPDQfn1q4bAYA0KB1rHLzBCLq+x6LsHmJREg/ZdI3nSQ2oaUs9gbkYto1VbmOxRwQD
         07b6Y6AgQL1NP+AwzmSdpPRYYIGhTyyzweUlqbDaSBqZioptkULtkhA3b8bLY9qPqKN6
         hY7AtKCfA8OWxLXZi4D1cuTu6+Od1ebAoN+wm9slXl1aL/Lp8LXeOype5rVbTz9D3ZlH
         Y5Ig==
X-Gm-Message-State: APjAAAVRt02M5iT9Mf6fF5Z6PjcpJV5XQ6Ny80NF4UdIckBvM9mY3ZTx
        kbsttA7KMwz7hyK9T+kYlVN4WBohECI=
X-Google-Smtp-Source: APXvYqx/zzzEne6UJodJvFCzU/ixi8e96T0XFarYIi4arpFrqL0iJD8yWaxJJ5rWMtKwCjgOSOAvAw==
X-Received: by 2002:a63:8c18:: with SMTP id m24mr24329549pgd.70.1582043639276;
        Tue, 18 Feb 2020 08:33:59 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:5924:648b:19a7:c9d0? ([2605:e000:100e:8c61:5924:648b:19a7:c9d0])
        by smtp.gmail.com with ESMTPSA id e7sm4787217pfj.114.2020.02.18.08.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:33:58 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com> <20200218150745.GC3466@redhat.com>
 <20200218153823.GF14914@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0a6c942e-0ffd-3fd6-e8f5-5f739b9e558c@kernel.dk>
Date:   Tue, 18 Feb 2020 08:33:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218153823.GF14914@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/20 8:38 AM, Peter Zijlstra wrote:
> On Tue, Feb 18, 2020 at 04:07:45PM +0100, Oleg Nesterov wrote:
>> On 02/18, Oleg Nesterov wrote:
>>>
>>> otherwise I think this is correct, but how about the patch below?
>>> Then this code can be changed to use try_cmpxchg().
>>
>> You have already sent the patch which adds the generic try_cmpxchg,
>> so the patch below can be trivially adapted.
>>
>> But I'd prefer another change, I think both task_work_add() and
>> task_work_cancel() can use try_cmpxchg() too.
> 
> Yeah, I'll go change the lot, but maybe after Jens' patches, otherwise
> we're just creating merge conflicts.

Just caught up with this thread, great stuff! Don't worry about me, I'll
just rebase on top of the fixes and cleanups from you and Oleg. Or you
can apply my two first if you wish, doesn't really matter to me, as I'll
likely just pull in that branch anyway for the rest to sit on top of.
Just let me know.

-- 
Jens Axboe

