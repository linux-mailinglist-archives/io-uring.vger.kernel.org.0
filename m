Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B033FF324
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 20:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346903AbhIBSU1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 14:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346972AbhIBSU0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 14:20:26 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F209C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 11:19:27 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id z2so2806532iln.0
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 11:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5tn/JtKMeJTkok9KHWjM5MvAFGzoWJbSm6taItXVCIQ=;
        b=hWsPxAXkX33yQ85Z9acYGNY2F9A663GkECfYPbMA5+1ywNP85kCqQ4rAsaJRexsJkM
         DgaFT9kFnonFwrLLlnl5J1pp9Lvr/mCqwAulZOsKW/HemGr9Bk+bVMGPFYjvcxSRecE1
         el1gKTatl+DLrQ3QifTVi9dxM1FK0v9iF2lCJyrzG3/RdVgjfCrSuqYFifrLXGr77IeN
         amdAsZPxg2oTlpEtyD9x/0R3bbTywstkPuxfJmaKqaAgzEeU9VeeG8tXarhSeGQrzqFU
         7Spetnlo41dasbpjqkGT9wo7ARVqqSOiLkTgs6jNFBnhuE4nwCKDGzY6XEf3FVSeQsfx
         RGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5tn/JtKMeJTkok9KHWjM5MvAFGzoWJbSm6taItXVCIQ=;
        b=kYYEA98mWyeB7wFC2hcxwIN/zJ7dBvWYGnCoQyoKYyRfVSNGSZ7Avb0N0p7jmBp1NU
         zCwFI4C0+wRun2uzcAcXPsauZsICE7cXPj0BQl7Q3RChQRvu4VwdVxq5XtzxYm5y2of+
         gO/s1E4FO/YYk4Hkpg/ugtNPuvYnw1rWqsyoKjRlWZI98ACsL/MEntSh4KmvPkd6HJ0h
         zbw4vE+ca4eEZzXoXQhKoE7Tez6j7/eOIgVIbsib1i/N6uEWNejztUxpkwE9bSwv6lNO
         HOtqxvO1Dydc6hBZrotnLu9lsHMa/B6v/1Mmb5SX1cPLuRwZZMFNjh065q7NgdukrvnF
         cfhg==
X-Gm-Message-State: AOAM532SibtFNMWVVVgSsvt3MGesnaLQzlyUSbkRdSyx0VouDTUAp1W8
        mBhU4vluCh5mHZI/sn8YFbXTz2H+gAGFMg==
X-Google-Smtp-Source: ABdhPJyQsLc/+/Bh9jAUTgb/ZPtHyJGXGQCtbgPurdwvjjVvbEqxkmz+88yfz5t9q8aJXjaxCgqUMA==
X-Received: by 2002:a92:6606:: with SMTP id a6mr3543281ilc.182.1630606766693;
        Thu, 02 Sep 2021 11:19:26 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q14sm1318706ilj.34.2021.09.02.11.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:19:26 -0700 (PDT)
Subject: Re: [PATCH] io_uring: trigger worker exit when ring is exiting
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <045c35f3-fb30-8016-5a7e-fc0c26f2c400@kernel.dk>
 <0a7dbae3-e48e-bf8c-1959-59195cad4bcf@gmail.com>
 <0d9cf759-98fc-334a-e6ab-c9605dc3a8af@kernel.dk>
Message-ID: <ee782e1d-ae8f-264c-bd21-4e0c496ece99@kernel.dk>
Date:   Thu, 2 Sep 2021 12:19:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0d9cf759-98fc-334a-e6ab-c9605dc3a8af@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 12:08 PM, Jens Axboe wrote:
> On 9/2/21 12:04 PM, Pavel Begunkov wrote:
>> On 9/2/21 6:56 PM, Jens Axboe wrote:
>>> If a task exits normally, then the teardown of async workers happens
>>> quickly. But if it simply closes the ring fd, then the async teardown
>>> ends up waiting for workers to timeout if they are sleeping, which can
>>> then take up to 5 seconds (by default). This isn't a big issue as this
>>> happens off the workqueue path, but let's be nicer and ensure that we
>>> exit as quick as possible.
>>
>> ring = io_uring_init();
>> ...
>> io_uring_close(&ring); // triggers io_ring_ctx_wait_and_kill()
>> rint2 = io_uring_init();
>> ...
>>
>> It looks IO_WQ_BIT_EXIT there will be troublesome.
> 
> I wonder if we can get by with just a wakeup. Let me test...

Nah not enough. Would be nice to fix though, pretty annoying that the
threads sit there for 5 seconds doing nothing.

-- 
Jens Axboe

