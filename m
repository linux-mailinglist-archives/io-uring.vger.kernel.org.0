Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAD2E2181
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 21:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgLWUgw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 15:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgLWUgv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 15:36:51 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADCBC06179C;
        Wed, 23 Dec 2020 12:36:11 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d13so345851wrc.13;
        Wed, 23 Dec 2020 12:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a0rpAb93KEzfxlmUoYJd4BCt58+pD6nzkkuli/XS38E=;
        b=GL9+LliYfL8/uuo3thjXfhFVPCDzOYuzbT/YTw/gXSU+e8byMr6IWG4JRI9A8JE1Rn
         J9F+Ir8ph1gDvr7NIwbitZrbdOvoFkdCskpdPUe0+u+xQkaaZt1QjU+jmYdbcxRaLdSH
         uyzsd+GuiBVEMIh8kdtKqtCyww+Q/F2QGVjMQfLw/YdsaOdwrZPPB1jZXqCg0eW9pMce
         /temjc8dJPt94GBmENn8B/W+ZvU8MQv6D+CtSbHI4OCSEpVViXkVmOlRHPaEUhoYibtM
         mJZ/zLY5P4eiA5GmYsPXYOEs3WT9tS0nn9n1wYh3Gl1ORDTb0hYgjidc1+25qIGnkAJ8
         wCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=a0rpAb93KEzfxlmUoYJd4BCt58+pD6nzkkuli/XS38E=;
        b=oY8+TdHU8TM74A2oRhkyR0SVWc0mWjBhP60BzAYU2z04w5CRg3Rdd17PfokXC1AgJZ
         RXYYnmPgYz7LcPkfiF8cGO7E1S4yZ6zM6nPgX7QF1vq3h1oRcHhuwdZy86xSdHCIZERA
         4g4SSoCUS1HzNcy3oZOcQdwddq07035NVwujouMwMj5hTHJOW724Bgn+qbEGiGouAIXC
         Ov49LspcYQzqGr//MTkK/VmLDaEs6A4X6wWkCkx+C1YLyZ3sRA0LKl1IGUbBywjZUp/m
         oGEJ/e/t2RjWFcacQB4oGg0G9dgGhwitJzTbMZj7CqYD2MC7j81LC8D6IAxmNdz4OH/V
         fRpw==
X-Gm-Message-State: AOAM532fysX1+lJ3THoG4xbdi1GDTSgcq7sz5cjjmTVZOR3WpQXUJhXl
        Y81pWBwdiALG/CBeziD5cCSHg771b7GcRA==
X-Google-Smtp-Source: ABdhPJyfdcpevW4c5rLF9fw3eGxFPW+d0c0i5c8SoYyvopbDxArb44ULVgyephWBuR+3XrCfl6GgOA==
X-Received: by 2002:adf:9d82:: with SMTP id p2mr19030926wre.330.1608755769486;
        Wed, 23 Dec 2020 12:36:09 -0800 (PST)
Received: from [192.168.8.148] ([85.255.233.85])
        by smtp.gmail.com with ESMTPSA id n9sm36389523wrq.41.2020.12.23.12.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 12:36:09 -0800 (PST)
Subject: Re: [PATCH v1 0/6] no-copy bvec
To:     dgilbert@interlog.com,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1607976425.git.asml.silence@gmail.com>
 <20201215014114.GA1777020@T590>
 <103235c1-e7d0-0b55-65d0-013d1a09304e@gmail.com>
 <20201215120357.GA1798021@T590>
 <e755fec3-4181-1414-0603-02e1a1f4e9eb@gmail.com>
 <20201222141112.GE13079@infradead.org>
 <933030f0-e428-18fd-4668-68db4f14b976@gmail.com>
 <20201223155145.GA5902@infradead.org>
 <f06ece44a86eb9c8ef07bbd9f6f53342366b7751.camel@HansenPartnership.com>
 <8abc56c2-4db8-5ee3-ab2d-8960d0eeeb0d@interlog.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <f5cb6ac2-1c59-33be-de8f-e86c8528fbec@gmail.com>
Date:   Wed, 23 Dec 2020 20:32:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8abc56c2-4db8-5ee3-ab2d-8960d0eeeb0d@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/12/2020 20:23, Douglas Gilbert wrote:
> On 2020-12-23 11:04 a.m., James Bottomley wrote:
>> On Wed, 2020-12-23 at 15:51 +0000, Christoph Hellwig wrote:
>>> On Wed, Dec 23, 2020 at 12:52:59PM +0000, Pavel Begunkov wrote:
>>>> Can scatterlist have 0-len entries? Those are directly translated
>>>> into bvecs, e.g. in nvme/target/io-cmd-file.c and
>>>> target/target_core_file.c. I've audited most of others by this
>>>> moment, they're fine.
>>>
>>> For block layer SGLs we should never see them, and for nvme neither.
>>> I think the same is true for the SCSI target code, but please double
>>> check.
>>
>> Right, no-one ever wants to see a 0-len scatter list entry.  The reason
>> is that every driver uses the sgl to program the device DMA engine in
>> the way NVME does.  a 0 length sgl would be a dangerous corner case:
>> some DMA engines would ignore it and others would go haywire, so if we
>> ever let a 0 length list down into the driver, they'd have to
>> understand the corner case behaviour of their DMA engine and filter it
>> accordingly, which is why we disallow them in the upper levels, since
>> they're effective nops anyway.
> 
> When using scatter gather lists at the far end (i.e. on the storage device)
> the T10 examples (WRITE SCATTERED and POPULATE TOKEN in SBC-4) explicitly
> allow the "number of logical blocks" in their sgl_s to be zero and state
> that it is _not_ to be considered an error.

It's fine for my case unless it leaks them out of device driver to the
net/block layer/etc. Is it?

-- 
Pavel Begunkov
