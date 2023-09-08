Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4C3797FF5
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 03:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbjIHBDn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 21:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbjIHBDm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 21:03:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B32F1BC1;
        Thu,  7 Sep 2023 18:03:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-991c786369cso198287566b.1;
        Thu, 07 Sep 2023 18:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694135015; x=1694739815; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dSNecOlkM3dmv48kmDezwCkkb12QRRiR2K+wIvJ8xgg=;
        b=h5gLy8SgrCs/7mUlI4ZIefXKUhmodOVk3Btqc3djia5PS3uO3yZPbKDN7HiZorpnon
         mOPU9CIWqIyWDtmViB2t0jKXRsHjp5ysoiaM9/d/FkMS/UPLJhlHFp3muWMtAezYci6i
         lrLb/J4OQnt++5XZ8xMpiAysA33VC5qg2ebGzQ2U3hqhsu5X6O8BT5cjli5wq6h8g6Qw
         ueThxd4iQ1X0vX1yAq2T4B3JGb3xv7biEs/zZGYmrOl6oGnwl8kwIvJWQt0AZOF6PSa0
         AFJR3FwbF3A4yHX6c7jpLdmS0C6vKMYxaKSNNBUsCdEQ9tsSRgdJzNNNAIhpJuPXzgUQ
         +x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694135015; x=1694739815;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dSNecOlkM3dmv48kmDezwCkkb12QRRiR2K+wIvJ8xgg=;
        b=nPu7CN7rDrAYYfrZRr34/vKeCVtbp0SzTF1gBDecUQ7X5YLnkoULgQ2415RsTA3B8v
         pPxd3Xb2BIS4OtgpvhYVjz04fwqqK+7znUTtY7T93zrOn7LkUbTNugJ0ZIT4vkLqY+gI
         Vct8f/WfM+Edp+XzV99bPuhXE8g2hDy17fMFHJKuTH3+6xYWUp9MwVGuol8c7Axox38t
         amjFDlsIACc0wqMe3IuXexFjYUbKRPNk54d+G0ujgOTP06gXJrW2aAWyHbX3Ij/4Pty/
         IZI+uaq53GEd16T1e1r3zoLRcWSijl3TL06/oip2iAAO7JPGSYzelY85eGzftLn4NWin
         w0cw==
X-Gm-Message-State: AOJu0YxpS3YKxqzD/OpSe7mt1MNsJVqLWZw1WsC5h88pG5NO+WSXgPbA
        eVZABIZXMzoUCY/oj3pBoy0=
X-Google-Smtp-Source: AGHT+IFNdsS7IRRU5TTGXnfJc8Ejg0T0RfEXVdRWy8R5pq/cSgm60vBfIOWstctzfgTpWWh4HR6fqQ==
X-Received: by 2002:a17:906:32c3:b0:9a5:a701:2b90 with SMTP id k3-20020a17090632c300b009a5a7012b90mr644578ejk.40.1694135014706;
        Thu, 07 Sep 2023 18:03:34 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id t1-20020a170906268100b0099cce6f7d50sm313196ejc.64.2023.09.07.18.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Sep 2023 18:03:34 -0700 (PDT)
Message-ID: <ffbe8a96-9f3e-9139-07c6-9bbf863185ed@gmail.com>
Date:   Fri, 8 Sep 2023 02:03:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
 <169358121201.335729.4270950770834703042.b4-ty@kernel.dk>
 <f6be40a3-38de-41ed-a545-d9063379f8e2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f6be40a3-38de-41ed-a545-d9063379f8e2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/23 16:36, Jens Axboe wrote:
> On 9/1/23 9:13 AM, Jens Axboe wrote:
>>
>> On Fri, 01 Sep 2023 21:49:16 +0800, Ming Lei wrote:
>>> io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
>>> in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
>>> Meantime io_wq IO code path may share resource with normal iopoll code
>>> path.
>>>
>>> So if any HIPRI request is submittd via io_wq, this request may not get resouce
>>> for moving on, given iopoll isn't possible in io_wq_put_and_exit().
>>>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
>>        commit: b484a40dc1f16edb58e5430105a021e1916e6f27
> 
> This causes a regression with the test/thread-exit.t test case, as it's
> canceling requests from other tasks as well. I will drop this patch for
> now.

And this one has never hit my mailbox... Anyway, I'm confused with
the issue:

1) request tracking is done only for io_uring polling io_uring, which
shouldn't be the case for t/io_uring, so it's probably unrelated?

2) In case of iopoll, io-wq only submits a request but doesn't wait/poll
for it. If io_issue_sqe() returned -EAGAIN or an error, the request is
considered not yet submitted to block and can be just cancelled normally
without any dancing like io_iopoll_try_reap_events().


3) If we condense the code it sounds like it effectively will be
like this:

void io_wq_exit_start(struct io_wq *wq)
{
	set_bit(IO_WQ_BIT_EXIT, &wq->state);
}

io_uring_cancel_generic()
{
	if (tctx->io_wq)
		io_wq_exit_start(tctx->io_wq);
	io_uring_clean_tctx(tctx);
	...
}

We set the flag, interrupt workers (TIF_NOTIFY_SIGNAL + wake up), and
wait for them. Workers are woken up (or just return), see
the flag and return. At least that's how it was intended to work.

What's missing? Racing for IO_WQ_BIT_EXIT? Not breaking on IO_WQ_BIT_EXIT
correctly? Not honouring / clearing TIF_NOTIFY_SIGNAL?

I'll try to repro later

-- 
Pavel Begunkov
