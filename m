Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E439798A2F
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbjIHPrM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjIHPrJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 11:47:09 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB1813E;
        Fri,  8 Sep 2023 08:47:05 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2bceb02fd2bso37070151fa.1;
        Fri, 08 Sep 2023 08:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694188024; x=1694792824; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N9qsLxOM13bxck3CM6JIuSQsy3GGSZyqY8iSyy8ZRQY=;
        b=Um/q4/Q6IWGzi2DbetiZEps06ZLtGdiiZwZqZHvZuqTBg/DszjQmqWIldVhbVJ2FxN
         bY9xH3nFLpg3qYOi5r0KBBMQX+4x55Lo9QUy0N1GZd8LWKjtgxBKkfsoYh1XK35SIPJz
         /2bGfLPH7HEepBcGBrtRq4EClm9aEAPOxVRujCxPiT8JLzMp/66WfQ3yv9VBt/tcJxgj
         E8g+SCRKImV095MWKyNrAXZJu5I06z9FZrZwasZdB+kLqWZwZUsARp8D1ksjDTm0Mz6j
         vjJWmjJ9C0ryDTa9G4sko1hA0t9VCKuBTS1PJdsPCLMA1gzp2y2wiU0SLRQuJl8UJDHv
         gHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694188024; x=1694792824;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N9qsLxOM13bxck3CM6JIuSQsy3GGSZyqY8iSyy8ZRQY=;
        b=NJn8KE2YSX23NPGKpQ54hESJo4389F9z/dYNaN3ji4V9BH49726RMR5cISussxAW+e
         gJPV9v8pjzF7MkIiD6suFGShGrpCBNMGRqRu25l6K2IeZV/9WtxO6ftpRIT3UO8A/IkQ
         JRII5bt0XE7z87oyUs5swtfb7EbkJxF91HHMwBdWRrPNtkIVuo2J6EkUBjLFrf4p1d1n
         2MSoC1gGXeTTPT1G//bMXK9mq6Jh6GEbOoBsTSs/vmPDS3dgRTWc+gNPlbmP7O3Ldbl8
         qhmearRHJYrUgL6P9AjPnvlYyPMce3IcWhGYp9U2OFU+eYWIhWEWGB/0qL7EHvKluMQx
         oIEg==
X-Gm-Message-State: AOJu0YyIxIWaX1Qdw7WjgJAiF01/WhIo7ZNvZNlo/Oqjt23Iwo7x6N+r
        aXRx96o/lyH0xs52cDw7Y7O/lmoE3Nc=
X-Google-Smtp-Source: AGHT+IHZKb3cAgfbhbN05eFrhUo3zpCm0B0OX700lc5bhERcU8KJ1UogEy6DrBkzfpfnLbDIkS4ySA==
X-Received: by 2002:a2e:9ed7:0:b0:2bd:124a:23d5 with SMTP id h23-20020a2e9ed7000000b002bd124a23d5mr2340817ljk.11.1694188023483;
        Fri, 08 Sep 2023 08:47:03 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id x1-20020a170906134100b009926928d486sm1186258ejb.35.2023.09.08.08.47.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Sep 2023 08:47:03 -0700 (PDT)
Message-ID: <78577243-b7a6-6d7c-38e4-dfef1762f135@gmail.com>
Date:   Fri, 8 Sep 2023 16:46:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
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

On 9/8/23 14:49, Jens Axboe wrote:
> On 9/8/23 3:30 AM, Ming Lei wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index ad636954abae..95a3d31a1ef1 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
>>   		}
>>   	}
>>   
>> +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
>> +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
>> +		issue_flags |= IO_URING_F_NONBLOCK;
>> +
> 
> I think this comment deserves to be more descriptive. Normally we
> absolutely cannot block for polled IO, it's only OK here because io-wq
> is the issuer and not necessarily the poller of it. That generally falls
> upon the original issuer to poll these requests.
> 
> I think this should be a separate commit, coming before the main fix
> which is below.
> 
>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>>   		finish_wait(&tctx->wait, &wait);
>>   	} while (1);
>>   
>> +	/*
>> +	 * Reap events from each ctx, otherwise these requests may take
>> +	 * resources and prevent other contexts from being moved on.
>> +	 */
>> +	xa_for_each(&tctx->xa, index, node)
>> +		io_iopoll_try_reap_events(node->ctx);
> 
> The main issue here is that if someone isn't polling for them, then we
> get to wait for a timeout before they complete. This can delay exit, for
> example, as we're now just waiting 30 seconds (or whatever the timeout
> is on the underlying device) for them to get timed out before exit can
> finish.

Ok, our case is that userspace crashes and doesn't poll for its IO.
How would that block io-wq termination? We send a signal and workers
should exit, either by queueing up the request for iopoll (and then
we queue it into the io_uring iopoll list and the worker immediately
returns back and presumably exits), or it fails because of the signal
and returns back.

That should kill all io-wq and make exit go forward. Then the io_uring
file will be destroyed and the ring exit work will be polling via

io_ring_exit_work();
-- io_uring_try_cancel_requests();
   -- io_iopoll_try_reap_events();

What I'm missing? Does the blocking change make io-wq iopolling
completions inside the block? Was it by any chance with the recent
"do_exit() waiting for ring destruction" patches?


-- 
Pavel Begunkov
