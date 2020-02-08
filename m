Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09771567B2
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 21:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgBHU3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 15:29:03 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:35779 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgBHU3D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 15:29:03 -0500
Received: by mail-wm1-f47.google.com with SMTP id b17so6407420wmb.0
        for <io-uring@vger.kernel.org>; Sat, 08 Feb 2020 12:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=wwSQDOmhsQu+RySLxIyH++gBjbmuFbOVVIozMbVu1nY=;
        b=iYbUKNjdiY4BobO6pRjvNk+W8yOxJJKpdbF5S3si1kKQyPPZ2nyv+mdSLevVaX25bz
         ruyD10TMX1lZID7so/KVkCAXQNopPVbUkZbU+9Zi/rsUSeZZoApmga3mdHajPlkcnDwU
         fkdP+jf17B1x1eDaH5wcnDlMCj5zGqIeN9sERQ2GBTARTQGQzOT5K4OSfSGQf09u7Llo
         2+ZK9XYwZE8U1Qbbcin1/jYB7rX5NCjczp/o8JmjS1Njn4ATaDpxTYTd/cCE9/CQU/4o
         D2ZVZvDvTyO8kOWOyHLh3J5m4GyI3uH3n7gKDBmiElmlAUdZ7dF1+CeS3rWCEoV5V6OE
         jYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wwSQDOmhsQu+RySLxIyH++gBjbmuFbOVVIozMbVu1nY=;
        b=ImyrM/AiLi7xsdcuIdbb5tu1yg3eXhbN7KKmz4cSLOB3ShhXIi0Z3zQOpv6cCodbgF
         hA9FEZ6Vj2d7OJSlg+0quhzNdBNecOgQGxZLbw1DxGWLXa8J1/z1ao6VN+sJ7+WfrFDh
         LbWZdYhoQh74tbWQqoB5hbvbk6YtsHLzyQ14l0LWpQ2KuO0W/WVi4f7f+m9DQpSEIlkx
         njaqM1NjpjSe275K4U38mIpGNTvKemRMSB6h2pHe7jerG8QkzRdHIqE9VVE3geymGnuX
         NqJa1zlysjTS+XFgbSaZcQ0gpKkGKzKm0mowewhcdCX8MOiDbMA+9PGkn1H+OxUW6qTg
         9CAw==
X-Gm-Message-State: APjAAAX3VnfcHABA+/wnCMRhQJrcWAoAcpxzr3bkMsg/NHeQR9NdZw+x
        ZsArNGgGo6wFrcft91TdK6caZVTuBh8=
X-Google-Smtp-Source: APXvYqzZ2Cdx5gle0d27lNNILRwQKeK7K4lXth5aXZAy1M8uZqhChula8NLS8OqCb5McJMVu/XCkvw==
X-Received: by 2002:a1c:1dd0:: with SMTP id d199mr5551560wmd.42.1581193741143;
        Sat, 08 Feb 2020 12:29:01 -0800 (PST)
Received: from tmp.scylladb.com (bzq-109-67-34-200.red.bezeqint.net. [109.67.34.200])
        by smtp.googlemail.com with ESMTPSA id y8sm8356213wma.10.2020.02.08.12.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 12:29:00 -0800 (PST)
Subject: Re: shutdown not affecting connection?
To:     Glauber Costa <glauber@scylladb.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <CAD-J=zaQ2hCBKYCgsK8ehhzF4WgB0=1uMgG=p1BQ1V1YsN37_A@mail.gmail.com>
 <cfc6191b-9db3-9ba7-9776-09b66fa56e76@gmail.com>
 <CAD-J=zbMcPx1Q5PTOK2VTBNVA+PQX1DrYhXvVRa2tPRXd_2RYQ@mail.gmail.com>
 <9ec6cbf7-0f0b-f777-8507-199e8837df94@scylladb.com>
 <CAD-J=zZm2B8-EXiX8j2AT5Q0zTCi5rB1gQzzOaYi3JoO1jcqOw@mail.gmail.com>
 <CAD-J=zZwH7ceTaAS=ck5_5thGN_ne1kVXOJzZfBK-gorzwNLxg@mail.gmail.com>
From:   Avi Kivity <avi@scylladb.com>
Message-ID: <d651f706-68eb-0f15-6e5d-3919eb90f3da@scylladb.com>
Date:   Sat, 8 Feb 2020 22:28:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zZwH7ceTaAS=ck5_5thGN_ne1kVXOJzZfBK-gorzwNLxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/8/20 10:20 PM, Glauber Costa wrote:
>>
>>> Perhaps you can reduce the
>>> problem to a small C reproducer?
>>>
>> That was my intended next step, yes
> s***, I didn't resist and I had to explain to my wife that no, I don't
> like io_uring more than I like her.
>
> But here it is.
>
> This is a modification of test/connect.c.
> I added a pthread comparison example that should achieve the same
> sequence of events:
> - try to sync connect
> - wait a bit
> - shutdown
>
> I added a fixed wait for pthread to make sure that shutdown is not
> called before connect.
>
> For io_uring, the shutdown is configurable with the program argument.
> This works just fine if I sleep before shutdown (as I would expect from a race).
> This hangs every time if I don't.
>
> Unless I am missing something I don't think this is the expected behavior


I think it is understandable. Since the socket is blocking uring moves 
the work to a workqueue, and the shutdown() happens before the workqueue 
has had a chance to process the connection attempt. So we'll have to 
cancel the sqe.


Jens, does the blocking connect doesn't consume a kernel thread while 
it's waiting for a connection? Or does it just set things up and move on?

