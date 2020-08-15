Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE112454EF
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 01:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHOXbF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 19:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbgHOXbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 19:31:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5F1C061786
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 16:31:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d19so6247002pgl.10
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 16:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lfRPGU2HRdwzn9GO9rJLdtncvChMz4kxxUaUDgh71IY=;
        b=nr8gwyUDb73GXkg/htvMmlnpFtwFNvPIY7wI80/Gp9GNfccqIB9MGSCpO5N4GAPOU6
         BfPxZ8Is7aXldzmspK26ge27o6+V42f7sW/JxLYMqZQtICoVA4YKtowVyK0bUh2cCsWW
         DgYD3g5gc7QFlKt9MCDYOu25v9mfAKkAFRM6iAYr0SfOVepEJW3RpRtAOZPoSP0mwpZp
         AbJWOUdli+Vzqw1CzLxCsHTYElXOlnE7Li8CbMjw+x2ja4zp1fEV61792YIZwg6WyVCl
         Q/NQx0TgSjYl1vAXcsR7ouJIsxhb3IeoY0EeHT7QD98W1cchYTqi51uncxmq54p73Srb
         JLgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfRPGU2HRdwzn9GO9rJLdtncvChMz4kxxUaUDgh71IY=;
        b=A7Tj49bZViatHbxW2/rp4lho5PmX81cF/Ver9+HMNKvxbCT/i9VK8QobXL0NiTqASG
         IET0Zw05HxbdkohXeOanwrDbJfK/1OpUyRv4T/Va6dIYFXq3W3TiOQwcw1Yw5+PVteAd
         YdwgC0fP/gCG2mx3jw9k+R2vKtS8956bphX7Qb+fe+m+CKW+GEZiFOqhJJufp7PBA1ei
         mBflIiex66VIV8OHsglbIyPCq2nMY9DEqd4jqpAf3KJFkGa8bWLj9fQliWT6y9d8bb2y
         0uEAFXEv9XMlcTQ8or7EcZ3vhbampgtd9zJHqeHEokZJxuhB62MHkGpPtXAECqD+6pyK
         s+hw==
X-Gm-Message-State: AOAM5338aW7yMtHEeNC8hm3bUWXcFKwKDvXD4MfHQR70ge9G0q1KItNV
        ZwuIuguP7flhMkdZDgcbDtKnwA==
X-Google-Smtp-Source: ABdhPJwd5/bNowWJ8Qr+OLpt3RgV+kscu/A/XGPI9mxlmHRtNdoalkIwR2Zt3sJRbBmFS+QTTww5bg==
X-Received: by 2002:a63:711e:: with SMTP id m30mr5939391pgc.40.1597534264555;
        Sat, 15 Aug 2020 16:31:04 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:6299:2df1:e468:6351? ([2605:e000:100e:8c61:6299:2df1:e468:6351])
        by smtp.gmail.com with ESMTPSA id x9sm13336122pff.145.2020.08.15.16.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 16:31:03 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
From:   Jens Axboe <axboe@kernel.dk>
To:     Josef <josef.grieb@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <CAAss7+qGqCpp8dWpDR2rVJERwtV7r=9vEajOMqbhkSQ8Y-yteQ@mail.gmail.com>
 <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
Message-ID: <904b4d74-09ec-0bd3-030a-59b09fb1a7da@kernel.dk>
Date:   Sat, 15 Aug 2020 16:31:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fa0c9555-d6bc-33a3-b6d1-6a95a744c69f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/20 3:35 PM, Jens Axboe wrote:
> On 8/15/20 2:43 PM, Josef wrote:
>> it seems to be that read event doesn't work properly, but I'm not sure
>> if it is related to what Pavel mentioned
>> poll<link>accept works but not poll<link>read -> cqe still receives
>> poll event but no read event, however I received a read event after
>> the third request via telnet
>>
>> I just tested https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=io_uring-5.9&id=d4e7cd36a90e38e0276d6ce0c20f5ccef17ec38c
>> and
>> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/commit/?h=io_uring-5.9&id=227c0c9673d86732995474d277f84e08ee763e46
>> (but it works on Linux 5.7)
> 
> I'll take a look. BTW, you seem to be using links in a funny way. You set the
> IOSQE_IO_LINK on the start of a link chain, and then the chain stops when
> you _don't_ have that flag set. You just set it on everything, then
> work-around it with a NOP?
> 
> For this example, only the poll should have IOSQE_IO_LINK set, accept
> and read should not.
> 
> This isn't causing your issue, just wanted to clarify how links are
> used.

Please try:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=41d3344604e80db0e466f9deca5262b0914e4827

There was a bug with the -EAGAIN doing repeated retries on sockets that
are marked non-blocking.

-- 
Jens Axboe

