Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861A1251C09
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 17:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHYPS3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 11:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHYPSU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 11:18:20 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBE9C061755
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:18:00 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p18so10709117ilm.7
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 08:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sg06P7CqQIG8WaP71cebjGjMi1E0Oweq6AMy4acjpjM=;
        b=Rg6i/qXJTOQ5hP+l+2ybu1PSgKJG7gpqCWDQ+ASKnHJ+9MpxQzYrFKs6iAY7hsOPDX
         B9fgTVSVYeG64RxtGbB2DLi5bSObWEmHGAK7cgM+h4Q1mPbd+t0fnzwW4t2NxrjvB5Ks
         02RhBIOPCHCXpLu1zK5TyckjrI9KJe7dL3CLxCeBQMYLcTzB7ZeFfRpxlJP1y6uysJWc
         /NK92aaBTsP12Z6VgJpT9XS4o18lxTbjtgIZ7zVp9wUowpIvoe+5BqeAP2O8WqT0gp64
         jr+MgNC9StTDU5UqnJV4Gp1Y7Fbl9dzZtpGmJElft5ih71ghDY7evF6OESpDDnlC7zmg
         1s1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sg06P7CqQIG8WaP71cebjGjMi1E0Oweq6AMy4acjpjM=;
        b=W8qoGhxollym8m1S1ug5Wj1nhdjc5zQ27tPWFlbab3SbFDlid3xXFAXKZD/ibNQLa3
         xrDc7jhj5IsMGb40UC68jcv2//o5NJKx2hYg2UBiWi1QEN0iEpO8ce+lonBECdHvpjQa
         fDCwMVrlSOE1zzrHOYDcPeDSZ1hyND0XalbtF3itG0QSpKGN606OlBTxwcUo80n4aCWL
         Kx8w0yTGf66RZd5UF+ORr93tEgqhD8VlgqdOVTOzlmwIcXnQkzo4YAlJos7K/QVpT2EF
         0ZRquNysSxvTLx5SPUsHHTTrWVVHGuVy0oceSNh88Jwd9kncRW8ZJ4tebJvfefjuYVJG
         iEJw==
X-Gm-Message-State: AOAM531dP41nsBb9nnGVPtUd3G5OYylCqKJAX6dbNzsSwjDNwe2J2R/n
        4zOXg3JzZOKmbDslHQmpreSEKA==
X-Google-Smtp-Source: ABdhPJwIn8koXKSVs1OKc82QhIwZMqI5JA/AhNHMPBN8HdXlMuc05uB7SPBSQPYsv8VwQx3H5CN18w==
X-Received: by 2002:a05:6e02:5c7:: with SMTP id l7mr9911275ils.268.1598368679535;
        Tue, 25 Aug 2020 08:17:59 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm9279605ila.35.2020.08.25.08.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 08:17:58 -0700 (PDT)
Subject: Re: io_uring file descriptor address already in use error
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+o=0zd9JQj+B0Fe1cONCtMJdKkfQuT+Hzx9X9jRigrfZQ@mail.gmail.com>
 <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk>
Message-ID: <308222a7-8bd2-44a6-c46c-43adf5469fa3@kernel.dk>
Date:   Tue, 25 Aug 2020 09:17:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <639db33b-08f2-4e10-8f06-b6d345677df8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 9:12 AM, Jens Axboe wrote:
> On 8/25/20 9:00 AM, Josef wrote:
>> Hi,
>>
>> I found a bug submitting a server socket poll in io_uring. The file
>> descriptor is not really closed when calling close(2), if I bind a new
>> socket with the same address & port I'll get an "Already in use" error
>> message
>>
>> example to reproduce it
>> https://gist.github.com/1Jo1/3ace601884b86f7495fd5241190494dc
> 
> Not sure this is an actual bug, but depends on how you look at it. Your
> poll command has a reference to the file, which means that when you close
> it here:
> 
>     assert(close(sock_listen_fd1) == 0); 
> 
> then that's not the final close. If you move the io_uring_queue_exit()
> before that last create_server_socket() it should work, since the poll
> will have been canceled (and hence the file closed) at that point.
> 
> That said, I don't believe we actually need the file after arming the
> poll, so we could potentially close it once we've armed it. That would
> make your example work.

Actually we do need the file, in case we're re-arming poll. But as stated
in the above email, this isn't unexpected behavior. You could cancel the
poll before trying to setup the new server socket, that'd close it as
well. Then the close() would actually close it. Ordering of the two
operations wouldn't matter.

-- 
Jens Axboe

