Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10040798920
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 16:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjIHOpA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 10:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjIHOpA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 10:45:00 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092351FE0
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 07:44:48 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-34ca6863743so2818655ab.1
        for <io-uring@vger.kernel.org>; Fri, 08 Sep 2023 07:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694184287; x=1694789087; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60mf1xX1YcoxaxSA/GlBLkU3UEqqxPDQjjCzD8+wFSI=;
        b=QnjDUFkHaTYRx513xbzwpY4mzRA5dLyMRe36CQOt/HPzzqzUdzczSc8Ofn0KRv00Uz
         K0jMGaXE0VFGJw3LQzap34H/qF6DBGqxA0sX9XqKGIrE591DumEnJekEdZmzra4BoCYg
         cn4pinDsKRCBPShXPJByu768574HtO8NPiXn6CKz/5tWCv4vUqqpDeqIRb/jDNZcvVFO
         deJZVfB3MoDQLf6KJFpBiKMaOX+cAtVrsCWmfPRE5ck+IVkwb1mJbhH3BXDcaKp3pRse
         jEHTMmbXeEQbHGexi4CdLXmUCdu8mn5ujyuofwbccCiSnWqL9UQNyA3xoexm7M5q+UAB
         HXCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694184287; x=1694789087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60mf1xX1YcoxaxSA/GlBLkU3UEqqxPDQjjCzD8+wFSI=;
        b=WUQP/LdVkzLhItYBjQdmAO7OPpDLsPSnMDOBkriW5lVRTCKy5/HC+95uhZHgqCs13T
         xZWAB/lBP8ckz35dgVhYt8b8a0nnPSDtv7u8Nig3JGy10wXCyi7cIC5Tov+k026KabTC
         xXN92IQ2X1qNK1MC6HUVvbEjn832LCR/UxdONNiLsYSpeFjpA8mZiKShMLoJWgb0Bna+
         B7DlEzBkLcHFilwt/qLm3k9P/pWGfYK/H2rvzpYnPM2zbXLWdOKwwAVl+Szqkmjson+H
         oCYVEa9YVynuQpzFy12Wlt/qLaUQK06ljc9MuUmxH+vZ2BgtlvA5kIhSVkNAyMna9W3E
         BsHg==
X-Gm-Message-State: AOJu0YziH+AQ2Swpowf6zonbu2+n6B/FGlOZNhRXinEdkElSY60xV0jN
        FjyErVVTnwTt0Sl/WeZS7OnhHA==
X-Google-Smtp-Source: AGHT+IGr5Psf0GhHlwjSfmvSoqfBSpxswW1uRbZfvjGgAIzMT+0wwOt8XjXNPCaHjJrdzH4aBmjnng==
X-Received: by 2002:a92:d6ca:0:b0:346:1919:7cb1 with SMTP id z10-20020a92d6ca000000b0034619197cb1mr2947891ilp.2.1694184286891;
        Fri, 08 Sep 2023 07:44:46 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fn2-20020a056638640200b0042aec33bc26sm506810jab.18.2023.09.08.07.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Sep 2023 07:44:46 -0700 (PDT)
Message-ID: <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk>
Date:   Fri, 8 Sep 2023 08:44:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk> <ZPsxCYFgZjIIeaBk@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZPsxCYFgZjIIeaBk@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/23 8:34 AM, Ming Lei wrote:
> On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
>> On 9/8/23 3:30 AM, Ming Lei wrote:
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index ad636954abae..95a3d31a1ef1 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
>>>  		}
>>>  	}
>>>  
>>> +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
>>> +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
>>> +		issue_flags |= IO_URING_F_NONBLOCK;
>>> +
>>
>> I think this comment deserves to be more descriptive. Normally we
>> absolutely cannot block for polled IO, it's only OK here because io-wq
> 
> Yeah, we don't do that until commit 2bc057692599 ("block: don't make REQ_POLLED
> imply REQ_NOWAIT") which actually push the responsibility/risk up to
> io_uring.
> 
>> is the issuer and not necessarily the poller of it. That generally falls
>> upon the original issuer to poll these requests.
>>
>> I think this should be a separate commit, coming before the main fix
>> which is below.
> 
> Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, and the
> approach in V2 doesn't need this change.
> 
>>
>>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>>>  		finish_wait(&tctx->wait, &wait);
>>>  	} while (1);
>>>  
>>> +	/*
>>> +	 * Reap events from each ctx, otherwise these requests may take
>>> +	 * resources and prevent other contexts from being moved on.
>>> +	 */
>>> +	xa_for_each(&tctx->xa, index, node)
>>> +		io_iopoll_try_reap_events(node->ctx);
>>
>> The main issue here is that if someone isn't polling for them, then we
> 
> That is actually what this patch is addressing, :-)

Right, that part is obvious :)

>> get to wait for a timeout before they complete. This can delay exit, for
>> example, as we're now just waiting 30 seconds (or whatever the timeout
>> is on the underlying device) for them to get timed out before exit can
>> finish.
> 
> For the issue on null_blk, device timeout handler provides
> forward-progress, such as requests are released, so new IO can be
> handled.
> 
> However, not all devices support timeout, such as virtio device.

That's a bug in the driver, you cannot sanely support polled IO and not
be able to deal with timeouts. Someone HAS to reap the requests and
there are only two things that can do that - the application doing the
polled IO, or if that doesn't happen, a timeout.

> Here we just call io_iopoll_try_reap_events() to poll submitted IOs
> for releasing resources, so no need to rely on device timeout handler
> any more, and the extra exit delay can be avoided.
> 
> But io_iopoll_try_reap_events() may not be enough because io_wq
> associated with current context can get released resource immediately,
> then new IOs are submitted successfully, but who can poll these new
> submitted IOs, then all device resources can be held by this (freed)io_wq
> for nothing.
> 
> I guess we may have to take the approach in patch V2 by only canceling
> polled IO for avoiding the thread_exit regression, or other ideas?

Ideally the behavior seems like it should be that if a task goes away,
any pending polled IO it has should be reaped. With the above notion
that a driver supporting poll absolutely must be able to deal with
timeouts, it's not a strict requirement as we know that requests will be
reaped.

>> Do we just want to move this a bit higher up where we iterate ctx's
>> anyway? Not that important I suspect.
> 
> I think it isn't needed, here we only focus on io_wq and polled io,
> not same with what the iteration code covers, otherwise
> io_uring_try_cancel_requests could become less readable.

Yeah, this part isn't a big deal at all, more of a stylistic thing.

-- 
Jens Axboe

