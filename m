Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93ABB20AF2A
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 11:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgFZJnX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 05:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgFZJnW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 05:43:22 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02154C08C5C1
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 02:43:22 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so8201163wme.5
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 02:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1nwxniGFRrAX/g1DSI5G2avJmhL4EygPUf9+FSqGwYo=;
        b=A6H/aqRQ6+xnoBEMBVZG63jtrmf/e6Vh8C9GJoa7CX4Kbt5R//xg5da6Uiz1FerPSE
         FGP+6cF+5PYTE+jJt4uqLWTQ6seVwPy1FL627ahwPezGnV3M3BiNAfsQbHYM/26UsMLH
         HrQW+ceQ26u2t+hG4y7t2ITF8NRvHwVgh7PCNRod/LmkeCqG9RQmsLrZyc9p3zTKAb9p
         Bnt5YZ0Q+p7u18QpC5A4yFqFDlJ/BR8eIT6d10RVupIvEmB5647aVD60JYxo253SdzQk
         fM9a561btZP/kFCohnKu3YIS1uZLkTP2TfJmDkY9RgCFBEpzStzcGQt9fSJH2vgFpgvt
         ERxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1nwxniGFRrAX/g1DSI5G2avJmhL4EygPUf9+FSqGwYo=;
        b=cqozh6Syn2FtUMUxVqggnNfLGbcg5gi9yvjMCr47VVENC29NT/pUzHfWOmn8et+rOx
         SvzOydkabt6T5yy92ymGc3ZqjQE4G4jfKhMNflnUUqWdij0KhgGGXrMQqvR7sLpFlDLw
         dCgPVHVbtQIzuqbapqERQ+KIGCuqyNKBCEA3BlUW8cJIuJ/nDAtcIdSeFuZGxoXElBK7
         dgJ+5dM/z+gTlsak5BXwmdqbahJxfjEHUuXKaTB7NK4QIMyL0difM+7RQ2S3T6YuBvlE
         8fOtwpWmZhDeQml3V6bH+nYK8PruZBphVj4+JpolZ4Z+SEsMkv1Hx83Vlmy90H3Cp2jo
         80hQ==
X-Gm-Message-State: AOAM532nJ2dVf4TVvCKakSOaOQts/psQV2E2XErs12IAX+oR3KdH98OA
        IVzR1jJQ9KUprIhAawB+rvAuUCcS
X-Google-Smtp-Source: ABdhPJw6ZtlNnGQXziXVWRSUWSYSsOZYCIftnR0DaUZBJCxHDQZcpoL3iRoTlT5fogyLCaWZqC7bnQ==
X-Received: by 2002:a1c:154:: with SMTP id 81mr2422677wmb.23.1593164600286;
        Fri, 26 Jun 2020 02:43:20 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id t4sm10780860wmf.4.2020.06.26.02.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 02:43:19 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
 <e9fe5b4d-4058-dda7-eed4-2c577825aca4@gmail.com>
 <68603efe-8cb4-b431-fc07-652342237a23@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: use task_work for links if possible
Message-ID: <7af5f5e8-11bd-b2a7-805a-9e37494efc80@gmail.com>
Date:   Fri, 26 Jun 2020 12:41:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <68603efe-8cb4-b431-fc07-652342237a23@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/06/2020 00:37, Jens Axboe wrote:
>>
> On 6/25/20 2:28 PM, Pavel Begunkov wrote:
>> On 25/06/2020 21:27, Jens Axboe wrote:
>>> Currently links are always done in an async fashion, unless we
>>> catch them inline after we successfully complete a request without
>>> having to resort to blocking. This isn't necessarily the most efficient
>>> approach, it'd be more ideal if we could just use the task_work handling
>>> for this.
>>
>> Well, you beat me on this. As mentioned, I was going to rebase it after
>> lending iopoll fixes. Nice numbers! A small comment below, but LGTM.
>> I'll review more formally on a fresh head.
> 
> I thought you were doing this for the retry -EAGAIN based stuff, didn't
> know you had plans on links! If so, I would have left it alone. This was
> just a quick idea and execution this morning.

I don't mind, just we did double work and that looks kind of wasteful.

> 
>> Could you push it to a branch? My other patches would conflict.
> 
> Yep, I'll push it out now.

Thanks

> 
>>> +static void __io_req_task_submit(struct io_kiocb *req)
>>> +{
>>> +	struct io_ring_ctx *ctx = req->ctx;
>>> +
>>> +	__set_current_state(TASK_RUNNING);
>>> +	if (!io_sq_thread_acquire_mm(ctx, req)) {
>>
>> My last patch replaced it with "__" version. Is it merge problems
>> or intended as this?
> 
> I'll make sure it applies on for-5.9/io_uring, and then I'll sort out
> any merge issues by pulling in io_uring-5.8 to there, if we need to.
> 

-- 
Pavel Begunkov
