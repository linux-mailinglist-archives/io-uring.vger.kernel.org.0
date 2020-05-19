Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69961DA464
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 00:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgESWVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 18:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESWVB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 18:21:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E46DC061A0F
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:21:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q16so464428plr.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eqpcqJBR+hIKeZzFOfZeZqgc2os+r+pnFNGpXOBaFSI=;
        b=IDjPALVFG7v/PkTvU++efe7fQQp1rbqlc02U7oidNA4MUgiCU1qr+QDSgEMDe3qRCg
         B8sx7AmUZnk2WRMf3s5w0isws/KAvdRxYmLjR6eTiSZojC+UiLwVCRmF5sejuboNJf93
         6e8BrPIRmTv0UIypXoHjfJXPdD15dgjcZLHUScVOh5B3YwYiChtsnO1wRBAK5xOzTUON
         NPraO7xLPLZ1AFSoN+dsiUS6TdAB8894RAmcOdMNIZcGDv9enwRlp2uYI94VoiIFR4HS
         +9539jniOakTsp5VqjRM1vl/ru/fcjzCybHI8zvpuuDtAdNewOZSwodQGW9yNWXTFPmj
         K+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eqpcqJBR+hIKeZzFOfZeZqgc2os+r+pnFNGpXOBaFSI=;
        b=jdQeyj4N9CrEFCubpe/w4B0L+j1m07c3R45iVvgYtYo11uRaPrXUH82srlbV5THohB
         etFSGRYyJY8pZnMwUvZ7sm6HdWa37sBYiLEN7Ac+bn/aZ14vCOjYm/DYBFBVmzYQe62z
         bhBucuCQ78qGFkPm1pQXE4kS3MMHrnRwEiycRocmFVcxBEOlbaD1W6Wh2WZ/3RrByLfk
         ssB1c/95XPYagQLkMYQfDuPl9Z3A/f4c6XX7e50w4FVlH63dC0vYAQ7dBkjD0jfUj8Xw
         kXSjjRWjulwNwwpiAlSjbravN4ZFexgJhfGq22Y9QEdEHg6nl/UPOrL88vSD/peCqosD
         eD0Q==
X-Gm-Message-State: AOAM531kWwSpqVRmqOr1iB4JtfMdp48rtGG9Vn6Vr+qgGwLv/VLv1SkM
        4JvTNx8fmx85zeCFcCMsqyizkZ69Njo=
X-Google-Smtp-Source: ABdhPJxQ78fq+30k5hX3CZX16iAVVZ+tXdAXNieQttArqgPh3XZ8THeZrFWJt65P3tCCuYbau4Gffw==
X-Received: by 2002:a17:90a:c385:: with SMTP id h5mr1771626pjt.147.1589926859369;
        Tue, 19 May 2020 15:20:59 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:14f4:acbd:a5d0:25ca? ([2605:e000:100e:8c61:14f4:acbd:a5d0:25ca])
        by smtp.gmail.com with ESMTPSA id k7sm341468pga.87.2020.05.19.15.20.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 15:20:58 -0700 (PDT)
Subject: Re: [RFC 1/2] io_uring: don't use kiocb.private to store buf_index
From:   Jens Axboe <axboe@kernel.dk>
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1589925170-48687-2-git-send-email-bijan.mottahedeh@oracle.com>
 <6ce9f56d-d4eb-0db1-6ea3-166aed29807f@kernel.dk>
Message-ID: <91cd9cdb-b65a-879c-0318-a888d2658bed@kernel.dk>
Date:   Tue, 19 May 2020 16:20:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6ce9f56d-d4eb-0db1-6ea3-166aed29807f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/20 4:07 PM, Jens Axboe wrote:
> On 5/19/20 3:52 PM, Bijan Mottahedeh wrote:
>> kiocb.private is used in iomap_dio_rw() so store buf_index separately.
> 
> Hmm, that's no good, the owner of the iocb really should own ->private
> as well.
> 
> The downside of this patch is that io_rw now spills into the next
> cacheline, which propagates to io_kiocb as well. iocb has 4 bytes
> of padding, but probably cleaner if we can stuff it into io_kiocb
> instead. How about adding a u16 after opcode? There's a 2 byte
> hole there, so it would not impact the size of io_kiocb.

I applied your patch, but moved the buf_index to not grow the
structure:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.7&id=4f4eeba87cc731b200bff9372d14a80f5996b277

-- 
Jens Axboe

