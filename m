Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D728D20241A
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2020 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgFTOWT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Jun 2020 10:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgFTOWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Jun 2020 10:22:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FFCC06174E
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2020 07:22:18 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m2so5850945pjv.2
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2020 07:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H9djA1tRJ0ykMBgIyxg3N7Tr9L1CP17031UwUTwwUVA=;
        b=h1q49s7JaAkR/SfJacNXbaCTJpqpl0apEgML3ipOEuL9hnthn9XZ/R3a0WjrnNOMIE
         k3eKh9FXws14BLYJ8gPCLK4gieABOMJs9fjsXcSKKuff89cb+aK5ljJdkIf1MjtZr1M6
         ORk96YuiZbvPKw9KlIi5zEIIfqpWdsCsbgmW/7SJp7CqIapUzVPSKavMPxQNGr3+PZwJ
         WZP89NmnvEFrlDd3cAAzY9wXLwkFzxu8UZKErIptyZK8979kIhed5lgzYynF1uZnVQe7
         LKb7r18QCPkg3YTv4U/u00RoMNUEmBZMNuDzJtwh6O8bptLoL/aG/6YrbigU7aLKKECH
         4sZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H9djA1tRJ0ykMBgIyxg3N7Tr9L1CP17031UwUTwwUVA=;
        b=pXFbv3Rk+NWRsT7pL5Kro1SVWWq20tdqeCU+MVUubiHof0daJJjg1KuS+m2D6KNFnQ
         3BPB4BsoEgwFHltiB3gUwtEpkHqfBzzcvDQLoo0O6Hc8VdnCFmq6uDGk7NVxiSrQ4AOO
         rGZ75D/lWl5dU8yqif2YghG9UFQQasCjpSY7nMpTo2V8jKh3TWrQJ+5rCgEtUWq/B/Q8
         PmufAMYvuvHLbRwWkahO2P5gCju7UepqXfENV9VQBbBoxG4TTqMsTAgsyI5kFcOkbSln
         Z8Qk6Gj8T/AZomtTxC9O+qy/SQDNYQw0QIUT2PTHHOVjCPy5pdLtyN3xbaYEwqf4Zcte
         QWYw==
X-Gm-Message-State: AOAM533F/jpXwmL2QcbRfmW8TFyd00Ey0lHtuydMmY4l+GbLR92/rpi7
        rxmAjXbm5jy4grjcOgsprW2GEA4ccDM=
X-Google-Smtp-Source: ABdhPJyzhYcA1fDQE0gYvW8/0s2bjUBOR5xkhCRKOJ8u8V4LrC1R5yfOBMf0HsC5SHWnvKFJzedpsQ==
X-Received: by 2002:a17:90a:7b81:: with SMTP id z1mr8978462pjc.125.1592662935820;
        Sat, 20 Jun 2020 07:22:15 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k18sm9010517pfp.208.2020.06.20.07.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 07:22:15 -0700 (PDT)
Subject: Re: [RFC 1/1] io_uring: use valid mm in io_req_work_grab_env() in
 SQPOLL mode
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1592611064-35370-2-git-send-email-bijan.mottahedeh@oracle.com>
 <a812d57b-7d95-8844-4c50-9155aca0884d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e6178e2d-8fa7-4837-a2c1-b167179177dc@kernel.dk>
Date:   Sat, 20 Jun 2020 08:22:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a812d57b-7d95-8844-4c50-9155aca0884d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/20 3:59 AM, Pavel Begunkov wrote:
> On 20/06/2020 02:57, Bijan Mottahedeh wrote:
>> If current->mm is not set in SQPOLL mode, then use ctx->sqo_mm;
>> otherwise fail thre request.
> 
> io_sq_thread_acquire_mm() called from io_async_buf_retry() should've
> guaranteed presence of current->mm. Though, the problem could be in
> "io_op_defs[req->opcode].needs_mm" check there, which is done only
> for the first request in a link.

Right, Bijan are you sure this isn't fixed by one of the fixes that
went upstream yesterday:

commit 9d8426a09195e2dcf2aa249de2aaadd792d491c7
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Jun 16 18:42:49 2020 -0600

    io_uring: acquire 'mm' for task_work for SQPOLL

-- 
Jens Axboe

