Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54AB166A40
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgBTWSI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:18:08 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44434 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbgBTWSI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:18:08 -0500
Received: by mail-pg1-f194.google.com with SMTP id g3so2609761pgs.11
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/8tuEuzFiBGCsp6pV7ua14d9wQcA4l5gyZo5REE+4PU=;
        b=Dq7cAxAfohJEXfJ8xYh7+o1NzbmxYZOq+rQ+pAzkHI52N/KveqJgrnVhpf8BrPLKrN
         FJ1Xu7sEfY3C9Bf7ndZ1IntN42piG0VucPxI9MoyZCLcgxD/03EeOrY9IVYUKIl9XY7T
         ExiLmBkP5h3pU0LTAVpGByebPBAf9XRIcg4+97vxON+/ddNflr/sT5/4qG2uhOhjzu+q
         VJaJ8+LQIXvqFm7dy5+za5FBe/O6y7A92Xfm2P60COJeJxM33XstLfSZ/eqokbBxC4vB
         AftN/kBQ0Ssxibb2NSVOEK+4q+YdKDPNWxmG7HY8/vofOn6jcC0vcjIIj4eJuJWMef/8
         vrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/8tuEuzFiBGCsp6pV7ua14d9wQcA4l5gyZo5REE+4PU=;
        b=ZaXdpZW0O5GnvVt/EFtKVGbV3qdPFyW2jrH2UYx8iwmPxAnD162YzEIYpBjP8io2Sa
         8Tf/1RO4hWpje6hWpymBpjpa0cbhQjaH5XrDxN1dMSBEr19FsRwKE/NbiJSjkc9DmZTC
         hTSxw3foFdtXnpc5gAoWGUjsSK3PTBn94OwzO/JMn5r0wVGCkpC/yiaVb2C67jFlaEKA
         IVGwgz9EFp7WY61E3FHJc783AHABf8z9MDJzR81teiDExlVUJ8R603XJ4YKvKbd21c39
         PFBVGWPy5nT0Y0W3Kx0MYEkLKHp8kHdN9vKkEZ2vskYoo2IpfKzCQxpYZHIRsPU96jIE
         zB0A==
X-Gm-Message-State: APjAAAWZ5t691jStE6otgvkXFEB67NqyP8/VB736k/9giiaDgdgbaOHA
        8LPWK6y4YDOws+OpsCrzD0Athw==
X-Google-Smtp-Source: APXvYqzMT4O4zemE4P4Q0X+vWqvWhzcjpdu4jAi13MMrt/OqBH5M9zrmcJTwew5JW97GOktC/DKXRA==
X-Received: by 2002:a63:7013:: with SMTP id l19mr34533339pgc.58.1582237087410;
        Thu, 20 Feb 2020 14:18:07 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id g19sm563922pfh.134.2020.02.20.14.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:18:06 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
Message-ID: <bb062108-4065-bd7c-f9bf-dfc433a6bd5d@kernel.dk>
Date:   Thu, 20 Feb 2020 14:18:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 3:14 PM, Jens Axboe wrote:
>>> @@ -3733,6 +3648,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>>>
>>>         events = READ_ONCE(sqe->poll_events);
>>>         poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
>>> +
>>> +       /* task will wait for requests on exit, don't need a ref */
>>> +       req->task = current;
>>
>> Can we get here in SQPOLL mode?
> 
> We can, this and the async poll arm should just revert to the old
> behavior for SQPOLL. I'll make that change.

Actually, I think that should work fine, are you seeing a reason it
should not?

-- 
Jens Axboe

