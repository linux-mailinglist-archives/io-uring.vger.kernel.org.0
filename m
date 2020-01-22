Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1291C144A0B
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 03:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAVCvD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 21:51:03 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:32860 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgAVCvD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 21:51:03 -0500
Received: by mail-pf1-f169.google.com with SMTP id z16so2578661pfk.0
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 18:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qz+3fxp5MDcA/KZYkDvsaPBNd3wThpvsgt8o2tswWyo=;
        b=W1JM7IlZOrtHGw5nRhp6ot3M2YHbj7yAfCt4u/zUBpcYb8kpYOegxxE2jfRJEkRJ1e
         MVZLt7sFayWJ7Dd6W2TcXLTPGahKRQ2uUD7SBO3jifajH9Kj9kH+cRgK2ikzt24udV5t
         TAWlK3HpmPjTxLBraWsqBK0XkzxI/R8KLZd+aG1Zbr8GSgBwCav6iL1OnMRym0IdBztb
         T/nrOcP5lmWWEkA4ALHoCHhvPxMezHHHRoYigwwoKU1pzXKxhjym9kqiZTaHTh6urLnM
         ZzAm6AqQgS58S6DS9T0FSI0uxUrESIU5c/wl1DQN+RRD7IuFpPVAM+1U61e9+/9O5/1b
         VlaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qz+3fxp5MDcA/KZYkDvsaPBNd3wThpvsgt8o2tswWyo=;
        b=SUFSA66XVZHVJfce6j3c2gH4SnlTRFB8t+kve5Wq9/U47fDdjtMIuc4fD/p3lbfrIT
         o6sOsmbRMwXVv/bWGTht+NHIWY5OTYlW126oRf8bcOgjcr8ANUc6QY2TIn/Yn6OHyxaG
         ZMaWdVG6VkOUom5m8dqEsd44Zh/+QoPtkCYiRpe3RjrdL/AoNF/2TxNJkEVqK7ZqPKVo
         rkSZVCv3XPHeCX9PajtTWplr3JCjIawSwxf0b6Y4IpjKYuC7fxp8HOdhy4/OZ/tNLrbq
         0yWkB3fNS2WzxS6UrQVXG5p7ACsZw4iOYqGZiDKwncqy1b58CW0dX8x0PqQteyGoqlWz
         PQTA==
X-Gm-Message-State: APjAAAXM57O8b8HSQsFLOxEkD3zFHgPPG7avai36ZdNSyZj4qZqnLyk5
        WYbIJZHafYR/0nINuQcRlOzxwFEOZVU=
X-Google-Smtp-Source: APXvYqx3y92LqpRHZAgMjA5eeiVWOv0NuBICRIXLrrMWKqq5LstaTua59Rypx8eDWkNyecYclWVttg==
X-Received: by 2002:aa7:8191:: with SMTP id g17mr600777pfi.25.1579661462174;
        Tue, 21 Jan 2020 18:51:02 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id dw10sm802883pjb.11.2020.01.21.18.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 18:51:01 -0800 (PST)
Subject: Re: Waiting for requests completions from multiple threads
To:     Dmitry Sychov <dmitry.sychov@gmail.com>, io-uring@vger.kernel.org
References: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk>
Date:   Tue, 21 Jan 2020 19:51:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 7:45 PM, Dmitry Sychov wrote:
> Really nice work, I have a question though.
> 
> It is possible to efficiently wait for request completions
> from multiple threads?
> 
> Like, two threads are entering
> " io_uring_enter" both with min_complete=1 while the completion ring
> holds 2 events - will the first one goes to thread 1 and the second
> one to thread 2?
> 
> I just do not understand exactly the best way to scale this api into
> multiple threads... with IOCP for example is is perfectly clear.

You can have two threads waiting on events, and yes, if they each ask to
wait for 1 event and 2 completes, then they will both get woken up. But
the wait side doesn't give you any events, it merely tells you of the
availability of them. When each thread is woken up and goes back to
userspace, it'll have to reap an event from the ring. If each thread
reaps one event from the CQ ring, then you're done.

You need synchronization on the CQ ring side in userspace if you want
two rings to access the CQ ring. That is not needed for entering the
kernel, only when the application reads a CQE (or modifies the ring), if
you can have more than one thread modifying the CQ ring. The exact same
is true on the SQ ring side.

-- 
Jens Axboe

