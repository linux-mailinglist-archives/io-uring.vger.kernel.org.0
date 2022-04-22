Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474D750B7A6
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 14:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiDVM5e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiDVMzL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 08:55:11 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D95527F5
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 05:52:18 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t13so7257435pgn.8
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 05:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:references
         :in-reply-to:content-transfer-encoding;
        bh=ZseMclVzfI8W03arRkRHTHhSpk1XBxW0ythQHRsKfr0=;
        b=oMHFt1yHBKS3RgU5l90JsoTWCfWAzZiYqTGBLW2MunFAJkznhvAEjZS4NyCtMgaGKK
         UNtkX54BqWrp9fiuylULdSDXZ+lgD2PLbNJQQE2HGLVD5REJ4v76qk0ShxBl/ilE2gpn
         UV21Z5jhuyeZcEjINLfjlZl9Etd3WyPf8LVyPEpHdN9N0PoPgJB/fzkoVpl+CWpvj7QA
         VNtPGsYQaHxeL/25PcaW3HNRqaiUSWmey6WFTrxrEAe/GNPREYsm/XTAjIv5M815MsHV
         hnlXpUC7PGjNzAg+rIQ80HU169vVFQ0RpRiJ44xB+3B10vgrbhayxr/1FsxjaLVm6+DQ
         Rjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:references:in-reply-to:content-transfer-encoding;
        bh=ZseMclVzfI8W03arRkRHTHhSpk1XBxW0ythQHRsKfr0=;
        b=QwIwUoEacGQvfX4jrRyVoFv4YkUDbCzyi5fGsLWPwwz2/RkIPXtYdRolVDQ5hLRs8D
         PAUGB+xUKNfVLppgUf9IhD0zsg8Bt20yr/sRy7kzKAL4X8LgnNCzDXidIVMrclnOkrij
         xTRO6l/0RzcngZH5oP1dgB7C8lsF2KeTJ+QnmWjDW5JmgQcERP6RAP/epgIvQkyi0fjj
         8oiOW7tKWswqXVTb46f3Ojzg0RqNGlBiXofXDKxPW9TQXiDvcizPlkoTGmVq6VioLy5T
         YpWPubrhZH3UzHnIjucQtN+50PDNnIbrH+MptHSuYmWipsmJl1SgjPQeIlSaOJO1c4PL
         41kw==
X-Gm-Message-State: AOAM533n7KrOcZ6cdR8SSLJzci09c3yKUAcwf58+Efob9R4Lvviiq5Uj
        NkeOwOevsNfYiZp6y1kb1UKoOn5/z4PU4g==
X-Google-Smtp-Source: ABdhPJys9S/k0d+46LJOvZmp/wK6bw3K9HfZK1GAbI/LM63LIzMax/M2x45DDSLvjjFFQmVWiW4X9A==
X-Received: by 2002:a63:e04a:0:b0:39f:ea06:e203 with SMTP id n10-20020a63e04a000000b0039fea06e203mr3880002pgj.146.1650631937791;
        Fri, 22 Apr 2022 05:52:17 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id mp9-20020a17090b190900b001cd4989feb6sm6187593pjb.2.2022.04.22.05.52.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 05:52:17 -0700 (PDT)
Message-ID: <9fef64ff-d13d-f9ff-a230-0d8fe928097e@gmail.com>
Date:   Fri, 22 Apr 2022 20:52:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
From:   Hao Xu <haoxu.linux@gmail.com>
Subject: Re: memory access op ideas
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
In-Reply-To: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Avi,
在 4/13/22 6:33 PM, Avi Kivity 写道:
> Unfortunately, only ideas, no patches. But at least the first seems very 
> easy.
> 
> 
> - IORING_OP_MEMCPY_IMMEDIATE - copy some payload included in the op 
> itself (1-8 bytes) to a user memory location specified by the op.
> 
> 
> Linked to another op, this can generate an in-memory notification useful 
> for busy-waiters or the UMWAIT instruction
> 
> 
> This would be useful for Seastar, which looks at a timer-managed memory 
> location to check when to break computation loops.
> 
> 
> - IORING_OP_MEMCPY - asynchronously copy memory
> 
> 
> Some CPUs include a DMA engine, and io_uring is a perfect interface to 
> exercise it. It may be difficult to find space for two iovecs though.

I have a question about the 'DMA' here, do you mean DMA device for
memory copy? My understanding is you want async memcpy so that the
cpu can relax when the specific hardware is doing memory copy. the
thing is for cases like busy waiting or UMAIT, the length of the memory
to be copied is usually small(otherwise we don't use busy waiting or
UMAIT, right?). Then making it async by io_uring's iowq may introduce
much more overhead(the context switch).

Regards,
Hao

> 
> 
>

