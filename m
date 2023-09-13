Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5583E79E85F
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbjIMMx5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 08:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbjIMMx4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 08:53:56 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AADD19B1;
        Wed, 13 Sep 2023 05:53:52 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-50078eba7afso11781037e87.0;
        Wed, 13 Sep 2023 05:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694609630; x=1695214430; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CAdJP8w+BgU4Tkmg8XbWiCFHVF3sBYy4Av+m+ajHDTY=;
        b=rsBbAhl3neJx35TjzSrMjqd9TLzOi7J+zvClENA9Q5rgrygmjifGBRibQw1sy8Zokx
         rhQoKnR4uCYWhPY1dwS6uM8wdud2LBDlVR4Crz25wrNbgs+TX5mzS/dEM8lQ9WYeSohe
         M27Ugmkkw87KZWr0Psi0DYudlvee8biyL3pgBmoAy3Ou45gMcD6jfRHdM5HGDP09/6Si
         0AUAsZAr8Nkma77arwny8l6yfDW5LXX0Gd4VYMo1ImnFAmM9ABVvqQgmlFBYXTKbiOY6
         n+xNl3lQ7mN5wxhoxfPMqI9dEzP7cVQT6G4Z/dlqH7612RzQl/5A32nh7weRcvDMUcTZ
         RURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694609630; x=1695214430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CAdJP8w+BgU4Tkmg8XbWiCFHVF3sBYy4Av+m+ajHDTY=;
        b=LUoTapybf0woV6hEolB4Z4EQeqyurSYZBaTs5rFwcWUfYvjE9m89nufV9pJxrpe3Dh
         VCxv0WA+1ntY4Zc+3i7zxk3kXzpvbJuA95/3hnETRhzIFeC1XPNzuk9QHNc2lQ9ALvB9
         /NMxXMmU1hnFL9S8nDiueQMLEKu8QLa8aOLM6RVsVzsyioklVO1duxbH01gwBHDEIJus
         Py/NbioP1gQ+y1NX5COiMmu46PDvifaUMY6ynOaBZAldeXO2RfWGJ+E/V/Tiu0TtWHEz
         l3VeHxry8NTWIdm4l3Y2tvgxvSSSkpyaa6XmKVUw2NCOYiCo1BUp9q8L7zcyvJF0KPCL
         ZoIw==
X-Gm-Message-State: AOJu0Yy/ncrP0F5acXGA+t3S3HODEggQOSltNA0Q/p8IKlqPugxgE3AX
        QF3vZNis3iBL3pBNVpXJRR8=
X-Google-Smtp-Source: AGHT+IF1Toad8UGakpZqIjiNfBjNXXaD8dzBTyl4c/xQlP8yFQ/QS+ntfQIbrKaGTj9GSzyFbG1YkA==
X-Received: by 2002:a05:6512:3984:b0:500:9a45:63b with SMTP id j4-20020a056512398400b005009a45063bmr2216151lfu.13.1694609630339;
        Wed, 13 Sep 2023 05:53:50 -0700 (PDT)
Received: from [192.168.43.77] (82-132-233-153.dab.02.net. [82.132.233.153])
        by smtp.gmail.com with ESMTPSA id g14-20020a17090669ce00b0099b42c90830sm8444521ejs.36.2023.09.13.05.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 05:53:49 -0700 (PDT)
Message-ID: <6501b559-6986-8e6b-55a5-b6b9a46208ce@gmail.com>
Date:   Wed, 13 Sep 2023 13:53:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <78577243-b7a6-6d7c-38e4-dfef1762f135@gmail.com> <ZPvNwczbDYaOinIC@fedora>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZPvNwczbDYaOinIC@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/23 02:43, Ming Lei wrote:
> On Fri, Sep 08, 2023 at 04:46:15PM +0100, Pavel Begunkov wrote:
>> On 9/8/23 14:49, Jens Axboe wrote:
>>> On 9/8/23 3:30 AM, Ming Lei wrote:
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index ad636954abae..95a3d31a1ef1 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
>>>>    		}
>>>>    	}
>>>> +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
>>>> +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
>>>> +		issue_flags |= IO_URING_F_NONBLOCK;
>>>> +
>>>
>>> I think this comment deserves to be more descriptive. Normally we
>>> absolutely cannot block for polled IO, it's only OK here because io-wq
>>> is the issuer and not necessarily the poller of it. That generally falls
>>> upon the original issuer to poll these requests.
>>>
>>> I think this should be a separate commit, coming before the main fix
>>> which is below.
>>>
>>>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>>>>    		finish_wait(&tctx->wait, &wait);
>>>>    	} while (1);
>>>> +	/*
>>>> +	 * Reap events from each ctx, otherwise these requests may take
>>>> +	 * resources and prevent other contexts from being moved on.
>>>> +	 */
>>>> +	xa_for_each(&tctx->xa, index, node)
>>>> +		io_iopoll_try_reap_events(node->ctx);
>>>
>>> The main issue here is that if someone isn't polling for them, then we
>>> get to wait for a timeout before they complete. This can delay exit, for
>>> example, as we're now just waiting 30 seconds (or whatever the timeout
>>> is on the underlying device) for them to get timed out before exit can
>>> finish.
>>
>> Ok, our case is that userspace crashes and doesn't poll for its IO.
>> How would that block io-wq termination? We send a signal and workers
>> should exit, either by queueing up the request for iopoll (and then
> 
> It depends on how userspace handles the signal, such as, t/io_uring,
> s->finish is set as true in INT signal handler, two cases may happen:
> 
> 1) s->finish is observed immediately, then this pthread exits, and leave
> polled requests in ctx->iopoll_list

fwiw, I'm in favour of trying to iopoll there just because it's nicer
this way, but I still want to get to the bottom of it.

> 2) s->finish isn't observed immediately, and just submit & polling;
> if any IO can't be submitted because of no enough resource, there can
> be one busy spin because submitter_uring_fn() waits for inflight IO.
> 
> So if there are two pthreads(A, B), each setup its own io_uring context
> and submit & poll IO on same block device.  If 1) happens in A, all
> device tags can be held for nothing.  If 2) happens in B, the busy spin
> prevents exit() of this pthread B.

Thanks, that sounds clear now. So, nobody closes the first ring, hence
it's not destroyed even after pthread A exits and the 2nd ring cannot
progress. I agree with the judgement about timeouts and that it looks
like a user mismanagement.

-- 
Pavel Begunkov
