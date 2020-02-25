Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B6C16EB27
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgBYQSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:18:54 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:44395 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728096AbgBYQSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:18:54 -0500
Received: by mail-il1-f193.google.com with SMTP id s85so11260795ill.11
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CoZ2G0od8sXqeFelKK0T6UxrLfV73A7DtjZqkerG8aE=;
        b=NRuAOWYkyWatb7Ewqh8C4pju2SbO2Lk3A0yRJn+jO1H+2OFA7HrJ31rC2Z3lAZfIG3
         4q77NPloMcoe/vEFNkpr51BLsLvQAaVDTygJyPU+Nd26Gm8C568pAOlZ/oaBKSDBpNgf
         aVvasqgT1rcZxybSamJeAGFzjX8Vwumff4Q3JBFmE44H7gPHv/d4s8iDtP0aeSn/NU55
         CJVU0yNWCqEEvgK7lDzg2HdnIcRqMtLTnldzrBUsBf4tafoHyiE/B4JwKVqVpfjWQ0P/
         1x61Pf6P8rdURxM4zNue4jh/nzl6tvJydTGM9sbNecrE1L7WuGwW6lvQMOFhB8wJ0HeB
         005w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CoZ2G0od8sXqeFelKK0T6UxrLfV73A7DtjZqkerG8aE=;
        b=gCwJzTXkLPg5F+tuDwUEjKlhO/8LEZ3qYmq7SV8X6izukLq2aJnfHchi/ci6Dw2/jZ
         W/xUXnHsGvVfM4zqlhKkzA7oYwKIwKLrJ39myBR8uMwIIrQ/h5THkZnqD1Wc5Nzh03s6
         pTiQiEl8LDC8g0j88W4+fAEdQnkskNbiNJwhJpGDvY/PZSHM8g+NKf8loNwMWq2NB+Xx
         t32QLR52hpmHXZkVyE3Y4ErlPAatAy/r4eMRAhLGr1TWmkelGglROD1dh+7pc3VT19Nh
         YBBYM1Dm1Mw6uSAz5DlwiAhCnVAx7+/uC1N38w1jZhuauzWxh2jXaB4nBZmu0xQNaBWN
         KGXg==
X-Gm-Message-State: APjAAAWBuhqc3ZCuWYOdbCH/W+CZKIhtGNrCCJCF95hwQhPnnRmNG0WY
        SGAXEuCr4o4d1AezgEGhe0nKBA==
X-Google-Smtp-Source: APXvYqwOVEaiwidAtUt5hQgl7z9su93eHc0g35DqZy5yXxaLeQtcTKGHCyu3tQMS8JFKc8AoaBCYGw==
X-Received: by 2002:a92:3a9b:: with SMTP id i27mr72042179ilf.39.1582647533171;
        Tue, 25 Feb 2020 08:18:53 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v3sm5688258ili.0.2020.02.25.08.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 08:18:52 -0800 (PST)
Subject: Re: [PATCHSET v2 0/3] io_uring support for automatic buffers
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200225160451.7198-1-axboe@kernel.dk>
Message-ID: <8afdda5b-4a18-1fcf-e5f4-5580cb692263@kernel.dk>
Date:   Tue, 25 Feb 2020 09:18:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225160451.7198-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ignore this one, sent out a series that hadn't been collapsed yet...
I'll post a v2b in a second.


On 2/25/20 9:04 AM, Jens Axboe wrote:
> With the poll retry based async IO patchset I posted last week, the one
> big missing thing for me was the ability to have automatic buffer
> selection. Generally applications that handle tons of sockets like to
> poll for activity on them, then issue IO when they become ready. This is
> of course at least two system calls, but it also means that it provides
> an application a chance to manage how many IO buffers it needs. With the
> io_uring based polled IO, the application need only issue an
> IORING_OP_RECV (for example, to receive socket data), it doesn't need to
> poll at all. However, this means that the application no longer has an
> opportune moment to select how many IO buffers to keep in flight, it has
> to be equal to what it currently has pending.
> 
> I had originally intended to use BPF to provide some means of buffer
> selection, but I had a hard time imagining how life times of the buffer
> could be managed through that. I had a false start today, but Andres
> suggested a nifty approach that also solves the life time issue.
> 
> Basically the application registers buffers with the kernel. Each buffer
> is registered with a given group ID, and buffer ID. The buffers are
> organized by group ID, and the application selects a buffer pool based
> on this group ID. One use case might be to group by size. There's an
> opcode for this, IORING_OP_PROVIDE_BUFFERS.
> 
> IORING_OP_PROVIDE_BUFFERS takes a start address, length of a buffer, and
> number of buffers. It also provides a group ID with which these buffers
> should be associated, and a starting buffer ID. The buffers are then
> added, and the buffer ID is incremented by 1 for each buffer.
> 
> With that, when doing the same IORING_OP_RECV, no buffer is passed in
> with the request. Instead, it's flagged with IOSQE_BUFFER_SELECT, and
> sqe->buf_group is filled in with a valid group ID. When the kernel can
> satisfy the receive, a buffer is selected from the specified group ID
> pool. If none are available, the IO is terminated with -ENOBUFS. On
> success, the buffer ID is passed back through the (CQE) completion
> event. This tells the application what specific buffer was used.
> 
> A buffer can be used only once. On completion, the application may
> choose to free it, or register it again with IORING_OP_PROVIDE_BUFFER.
> 
> Patches can also be found in the below repo:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-buf-select
> 
> and they are obviously layered on top of the poll retry rework.
> 
> Changes since v1:
> - Cleanup address space
> - Fix locking for async offload issue
> - Add lockdep annotation for uring_lock
> - Verify sqe fields on PROVIDE_BUFFERS prep
> - Fix send/recv kbuf leak on import failure
> - Fix send/recv error handling on -ENOBUFS
> - Change IORING_OP_PROVIDE_BUFFER to PROVIDE_BUFFERS, and allow multiple
>   contig buffers in one call
> 


-- 
Jens Axboe

