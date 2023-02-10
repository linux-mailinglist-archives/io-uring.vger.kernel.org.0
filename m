Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8968B692774
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 20:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjBJTx4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 14:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjBJTxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 14:53:55 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6711A7A7EE
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:53:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id nn4-20020a17090b38c400b00233a6f118d0so3999082pjb.2
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 11:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tyTlWz5fYsKMWvFoz4Fm+BhCFJnS3C5FOiC8ggnUQfI=;
        b=Ol9zBscQLroOZLNiYZeIv/bRg1UL/AJUoHG3NuhutRaVVpj+QF100PIRYejUXFvuBc
         QfNqRH/f1UPFr/yaCTv6OA/rA+wEZkXcm43agI99YUdEVVYHiyv9VyFyCjfUF8LfutGY
         UmnIe963to6v8n0Cytr488j+BWbyLoJNiysJ2SzM3WflykR3wivjnc9q0XcXU12PgeUk
         +DS+LnzA/dLorlEz31WeofOmgV613YoGDdECNkJ34GZ/DKmpklG47P5iZ4NU61j/4M0D
         GuOGusK5pY1UHyDow8MUhDOl28Hn+xdn1/uLapUJlsVpUdLqT0epIPHpQ9ti4PIZ4/Ix
         YJ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tyTlWz5fYsKMWvFoz4Fm+BhCFJnS3C5FOiC8ggnUQfI=;
        b=L5ady2L6jJTi/xRVzgJH8G9XeQCgKxzxjHLN4TUf7mAmGHUV+pJRrdYz7jSxVNp7Ra
         ouiYHLV3W7jjx+XHpOsxmQxP7ByLQ2G6zsTKeC53J9gaAUjD/TBAkBSf5adlUYEOj13K
         7kCon4YHZUs+IBsJ14UQOzfcKv9LGsPN6ZLE2FaE/hvEpIMbEpKmii0rqlq4woUPPfXs
         n5nX1xvRs0H7D5I2zYQC+fjYwBur+PNdIhbS0ErFqmvWiIedCHWMQCKtPWs2doYPqaXW
         wCsGjcTAtHUeHRskFTEjw6ZTOEpc8h1oEPTpw+LAJtDIsP5XNG7+uff/KxEm6znF75WR
         RJTw==
X-Gm-Message-State: AO0yUKV145MkXD7VKCN0uZV6XZjXr6re4qtzN+nkAkLTCAoXnyx7pZLx
        jk7VKn789WjUfZpgXK94fwnXMAler2iluWXY
X-Google-Smtp-Source: AK7set/nvu8HziW1amt4dCHtn3BSe+vey3sbMHabG6azp6FyjmQj/GFCEnSrIOjP7tge14+lGQIKow==
X-Received: by 2002:a17:903:1107:b0:196:3f5a:b4f9 with SMTP id n7-20020a170903110700b001963f5ab4f9mr17238288plh.1.1676058831800;
        Fri, 10 Feb 2023 11:53:51 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b00199524dc67bsm3742155pls.163.2023.02.10.11.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 11:53:51 -0800 (PST)
Message-ID: <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
Date:   Fri, 10 Feb 2023 12:53:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230210180033.321377-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 11:00?AM, Kanchan Joshi wrote:
> is getting more common than it used to be.
> NVMe is no longer tied to block storage. Command sets in NVMe 2.0 spec
> opened an excellent way to present non-block interfaces to the Host. ZNS
> and KV came along with it, and some new command sets are emerging.
> 
> OTOH, Kernel IO advances historically centered around the block IO path.
> Passthrough IO path existed, but it stayed far from all the advances, be
> it new features or performance.
> 
> Current state & discussion points:
> ---------------------------------
> Status-quo changed in the recent past with the new passthrough path (ng
> char interface + io_uring command). Feature parity does not exist, but
> performance parity does.
> Adoption draws asks. I propose a session covering a few voices and
> finding a path-forward for some ideas too.
> 
> 1. Command cancellation: while NVMe mandatorily supports the abort
> command, we do not have a way to trigger that from user-space. There
> are ways to go about it (with or without the uring-cancel interface) but
> not without certain tradeoffs. It will be good to discuss the choices in
> person.
> 
> 2. Cgroups: works for only block dev at the moment. Are there outright
> objections to extending this to char-interface IO?
> 
> 3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
> with block IO path, last year. I imagine plumbing to get a bit simpler
> with passthrough-only support. But what are the other things that must
> be sorted out to have progress on moving DMA cost out of the fast path?

Yeah, this one is still pending... Would be nice to make some progress
there at some point.

> 4. Direct NVMe queues - will there be interest in having io_uring
> managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
> io_uring SQE to NVMe SQE without having to go through intermediate
> constructs (i.e., bio/request). Hopefully,that can further amp up the
> efficiency of IO.

This is interesting, and I've pondered something like that before too. I
think it's worth investigating and hacking up a prototype. I recently
had one user of IOPOLL assume that setting up a ring with IOPOLL would
automatically create a polled queue on the driver side and that is what
would be used for IO. And while that's not how it currently works, it
definitely does make sense and we could make some things faster like
that. It would also potentially easier enable cancelation referenced in
#1 above, if it's restricted to the queue(s) that the ring "owns".

-- 
Jens Axboe

