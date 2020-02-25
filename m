Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CAA16EB41
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgBYQVa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:21:30 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33784 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQV3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:21:29 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so2881706ioh.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3JmpoJraUTO4e+Xev5oLxU1QgUlLMH/IsRDDZKykTIM=;
        b=f34tVtAZxNC7KiHGfqi9BAiiQz0m51hASBsyE4+Y/tpyOJeQR5MuMCww5G03VRnRLW
         eRfd1HvZvn8MJVMa/sAYQCZVj/qWqaE59IVrO0khZEiBIZy3AXfhKSo6gTLZEQidAovI
         OuK3NVbQlPRCRiz6deSbwLgkyrUBAOzatxWc3Hh+dPejNbLO0Eg6mgyeigjxp5O460qE
         lQd4Cd0a+8L1U1yAxPwhRsNNdHltofyfF/xbAfmvRZWy+8C7as1yCbtpUlcG7O92+0rQ
         8lhxWZvVpfGvCB/woxcL8pUEW4TlznkTJ/+wrVKMm67GTZzZvgVXDRsISZkKV5CpgeYs
         3E9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3JmpoJraUTO4e+Xev5oLxU1QgUlLMH/IsRDDZKykTIM=;
        b=Lrr/M/KGYPVwzCYZ4bMz7SGzWnKFCy1cSNaRNh/wNW7n6p8jFQxaoEx3eUmm0WJgXj
         mwBgEcxNcpBaN/jFWgQprnI2SJz/2RT+P1WFV1OsmZfufwadFOUXyhueclrTIyxCJll7
         6OgF/eNe3PR1cA7oiAE1CtPB1DJ3M4+C7KS/PsMeYupm5E9/R3Vg6tcPyaoVyXen08DT
         Yu+sEA/av5tCy4WH2wUqtQJUjOB4WAUTRO0V6rmgUyealup9z0l8aci7lodloZGWQrHf
         UmOdvcLz52A6NSb2+8yfnh5W7/2qpNS/tm9mNHzKjWaOt3zunS2nft0Gyapg32sAHg6v
         9ecg==
X-Gm-Message-State: APjAAAVlJTLG53K7LOWqaIIhDfd5UDUQcbDN1DBt/g7+4SqIvVkuDpAn
        LO7vai2MbinB3WsPDiaXzV8uDJ8viLA=
X-Google-Smtp-Source: APXvYqyzANHHScinWtIxRdyA1ixy0otqz90mOUBZpt3UYQ8cgmwi/Ys1LxpnlCjh3fdD7jVAa6SqXg==
X-Received: by 2002:a05:6602:220b:: with SMTP id n11mr60471606ion.6.1582647688867;
        Tue, 25 Feb 2020 08:21:28 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s10sm3914424iop.36.2020.02.25.08.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 08:21:28 -0800 (PST)
Subject: Re: [PATCHSET v2 0/3] io_uring support for automatic buffers
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200225161938.11649-1-axboe@kernel.dk>
Message-ID: <f1a9bc7b-c70a-3fec-24af-31dd37dbf8b0@kernel.dk>
Date:   Tue, 25 Feb 2020 09:21:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225161938.11649-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

And this got botched too, really not my morning. 2b posted with the
right subject line, and the right patches too...


On 2/25/20 9:19 AM, Jens Axboe wrote:
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

