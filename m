Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF2C2D33B5
	for <lists+io-uring@lfdr.de>; Tue,  8 Dec 2020 21:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgLHUXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 15:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbgLHUWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 15:22:19 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44CC0613CF
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 12:21:33 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so13215144pga.7
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 12:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yFQ9PBr9ijsmwIy3vmtrIQJdhEMP+P6YcVTJecIQ+cQ=;
        b=f5y0bnRdwolJy60FK9OAZ1Nh2A61wr3UhCAIHELpMTVGFbn4DyL9HimU4dHLdb7PCf
         93dR25q/dueaWsdVo+u+YwZWSsBVJ3a9buyS+PC0KUyGiBoWzR5rMQXyp8bJo2D8BLiE
         KANPrzBdm7PAvVMfggMpFLEL6jRWrIyWqOl5GAy1r1CUYF1oNOERxS8hS8EdrvE211th
         Ef9SUtlFrTy0dpne2o0QPlX3TIm5pS+XUK17OK3M9WVzW+X2ehxKZDwae5NIDiffbJka
         YgBhOJes7/9VtaPrxpTnZIxtpk2XNJHgTg/Tc88G4estENeNFA7AmG5Rsiw9MkLOubaN
         M3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yFQ9PBr9ijsmwIy3vmtrIQJdhEMP+P6YcVTJecIQ+cQ=;
        b=GVgx0XAI+mHdPcdhLb27/4ZQ5UCPa/vO6bxReoZbf3i8zFLbpvseXqpmTKhva3Rmjb
         7c1mIbIa5kGbDMtQR6eodEy/HM6W+X70pITIlJ3FRvKb9mtzik48e5jbrqzj7rTVCwc0
         HMdgm3NcgaIzJWlptqZEm/LZQxLWqqmEG0kdZ/qZahRMJuxpEplcMCBymvCUaYlUEqVB
         g+JB6WtpMnurix7N74AHDno/GeHzG7X1VMZ7M7jeF1g8nuWgV5Jsa/8J59c00TBBjNP4
         MY+keqDOYC9IShpK+ubTWhXARkeYa1jSvpMuXv8zAowEUtA+BRoCm5vzmM1EOgUdscOU
         ptpA==
X-Gm-Message-State: AOAM5315PiRvMgkgGOECLW8YnTdiuB4Byc2Gs+lwZnLtuBdKamruFvMR
        qhLlMo0Pra/dv3YQ0LJa/rGpMFA56lpZOw==
X-Google-Smtp-Source: ABdhPJyWqoFljKzfwxa1KiS9pPKXmhKwMnLrDMt3sYC8qyPYFEAmitOy9AUiuNbkivjg4sqgNF/pLA==
X-Received: by 2002:a6b:928b:: with SMTP id u133mr18983721iod.145.1607455029163;
        Tue, 08 Dec 2020 11:17:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c7sm9939717ilo.75.2020.12.08.11.17.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 11:17:08 -0800 (PST)
Subject: Re: [PATCH 5.10 1/5] io_uring: always let io_iopoll_complete()
 complete polled io.
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     xiaoguang.wang@linux.alibaba.com,
        io-uring <io-uring@vger.kernel.org>
References: <cover.1607293068.git.asml.silence@gmail.com>
 <cf556b9b870c640690a1705c073fe955c01dab47.1607293068.git.asml.silence@gmail.com>
 <10e20bd3-b08f-98b8-f857-8b9a75a511dd@kernel.dk>
 <d9f677a4-1ac0-0e64-5c2a-497cac9dc8e5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <33b5783d-c238-b0da-38cf-974736c36056@kernel.dk>
Date:   Tue, 8 Dec 2020 12:17:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d9f677a4-1ac0-0e64-5c2a-497cac9dc8e5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/20 12:12 PM, Pavel Begunkov wrote:
> On 07/12/2020 16:28, Jens Axboe wrote:
>> On Sun, Dec 6, 2020 at 3:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>> From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>>>
>>> The reason is that once we got a non EAGAIN error in io_wq_submit_work(),
>>> we'll complete req by calling io_req_complete(), which will hold completion_lock
>>> to call io_commit_cqring(), but for polled io, io_iopoll_complete() won't
>>> hold completion_lock to call io_commit_cqring(), then there maybe concurrent
>>> access to ctx->defer_list, double free may happen.
>>>
>>> To fix this bug, we always let io_iopoll_complete() complete polled io.
>>
>> This patch is causing hangs with iopoll testing, if you end up getting
>> -EAGAIN on request submission. I've dropped it.
> 
> I fail to understand without debugging how does it happen, especially since
> it shouldn't even get out of the while in io_wq_submit_work(). Is that
> something obvious I've missed?

I didn't have time to look into it, and haven't yet, just reporting that
it very reliably fails (and under what conditions).

-- 
Jens Axboe

