Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F9C31A69A
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 22:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBLVOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 16:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhBLVOj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 16:14:39 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D95C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 13:13:58 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u20so594302iot.9
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 13:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rmWD6Mskd8N1ntLqUmZoRu1fnFF56MZFMQEh5ZS0GeU=;
        b=bQSGYyn6S10uARHKA1Ma6rTzHfUGzvvJ2ovhkpYohhzjoi4I1lWKDa1RAGzixoCMfZ
         O8MPFJZdTIYVSEhZ7Uu67Z+sNc/hJvvhjD2O6tWeRnzyk2FjfipICf6bvejYXq2/qy1G
         ScxacLFqY2pirISeH0YL6pNF1/Jvg6UXah77KpZLJwUBZvqADZItoBjyheUsQQ/tLC+K
         0klyN+F3Rmrp2a8gQQ1UuLCYEmugDWNbBGoy2b99zklkEnRXLmZf0ed7nRRL8BcYuxQR
         R6eqxQ+/9xBDGR0mmLks6puupvzEZCwU2rcYK2XlElOLuTqETFno6bZSASm17rF+IHI8
         UBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rmWD6Mskd8N1ntLqUmZoRu1fnFF56MZFMQEh5ZS0GeU=;
        b=HgEu04MaJPPsThg2Jzbq2pY+gPtR0yG7phC+gpwrxtaQQoCW3oDAFF1ODksI+2h+zt
         qNm/nhMJ6XqzaRVMtBEHHvKwKpj2ggzdiUJBHZtFqXsNgg8fxz7ADpZxz9ftW6BVVmFq
         2cz+m5AUBIFmuc/1Z6Mcuug/OFytoPjlLCNprvJmn+GZrekLWT2owtrkFhhTCznxpSIT
         SU3kHhQoGqGE78Kt4ZbX15+Pf4kd7iZK7rHY9T84dh1DmO2CXPeyUnw3V8HyrLY6zg/P
         0AqdubCcg3lEhqlzuBatPwqz1q0n7SVuS0xFHL0pwqC7gvPDdbJT1sbohanHG9/TUBJI
         DNZw==
X-Gm-Message-State: AOAM5325/BXkht5vpwbU5PQyJib9heECwMOtjU8FoBw/2uU331CkzXzI
        VWda6Ah2nvFD95B2tYuywyqrWGM6si/XoJUq
X-Google-Smtp-Source: ABdhPJzjIHirSc68qr1G3/2/fO4PNF9PFuIpHVIC4OKVSIAGfiL4FWZUS2WuiGfJ1OinAvakDlMDbg==
X-Received: by 2002:a02:449:: with SMTP id 70mr4298443jab.137.1613164438214;
        Fri, 12 Feb 2021 13:13:58 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j2sm5061091ilr.73.2021.02.12.13.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 13:13:57 -0800 (PST)
Subject: Re: [PATCH liburing] a test for CVE-2020-29373 (AF_UNIX path
 resolution)
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Petr Vorel <pvorel@suse.cz>
References: <43f46a40dbc37bebf78f14d7738d5195dbb64460.1613163628.git.asml.silence@gmail.com>
 <53d0db2d-2692-887f-2eb1-947ef0713518@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7645c903-ed55-6d75-d79f-10975ab4433f@kernel.dk>
Date:   Fri, 12 Feb 2021 14:13:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <53d0db2d-2692-887f-2eb1-947ef0713518@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 2:03 PM, Pavel Begunkov wrote:
> On 12/02/2021 21:02, Pavel Begunkov wrote:
>> Add a regression test for CVE-2020-29373 where io-wq do path resolution
>> issuing sendmsg, but doesn't have proper fs set up.
> 
> Jens, what about licenses? The original test is GPLv2

That's fine, that's compatible. I just left the license blurb in there.

-- 
Jens Axboe

