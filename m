Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22C8798A48
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbjIHQC3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 12:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbjIHQC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 12:02:28 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2009C1BF5;
        Fri,  8 Sep 2023 09:02:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-500cfb168c6so3627033e87.2;
        Fri, 08 Sep 2023 09:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694188941; x=1694793741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=geBBxFrVZjSD5j9baX2PDBGAlBkwwGDEHjJ1GhsjKlc=;
        b=H51d8/rAsg0+tpc/Fb2CHcxU3122cHSXkalK4+7/ieOMGM2q7hwbHsf89Sr5ykIho4
         qdhjge1xGzaykDoawaEk8NXQaRn2ceLIxF/8EljVWAweBuf+2Iv4ph6aFieaexXJD+fq
         qu7JHlTO6LPelkGQm6BGh2YjXy7gxxwl1R2mi3FJ7ZprNFI9Ux+d/v63iopKm9Ws0P/4
         5rI5+O9T6F0nGb7aG6/KidFX4jXv0gM2bUTF4gigNAZ+4/bHPxu981mewF+xo5ZZQ4FV
         a8CaYkmN3nfKRCATRTXZm+QxyMhvezB4HqnLDo9f6odrZGyfXSPbYfDCdnUfqTxLJLJu
         YKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694188941; x=1694793741;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=geBBxFrVZjSD5j9baX2PDBGAlBkwwGDEHjJ1GhsjKlc=;
        b=JyjFuddsk6A5KNaWqpX7L/63zsfI7hAfJJf5qMgrK0EijmAEZB2K4l2NeDPcjcvQ0n
         wv4ICZVTxAwzZHtnrcK4gWCF8Bo2DyDdvqS86WZIDtA6h5QPli6RTzU9TD1Bm/X4RZv5
         L4wPKLNy36lEEMvzuSiE2kW7sBSgHgZ9JnJvLPHphlLMrqbYp6qcR1qr5tDxqiv3J+2k
         plBFhaXIRmQDxyWaEnp8neVZDiZItxBCdy4WKfalXTpEIfRYM3WYt8+q0mbKKfVLuhOK
         w5AUaxQpq+f3cdrwmqpSOe7AVEmTF2+DYQF0Jv4ECrq5ipM40pBor2+5Gl5/lYBrvdEI
         dxEA==
X-Gm-Message-State: AOJu0Yz+PMVAJT0JYISFQrSDD10z5yY8jCEjyT01raW915ks9Xks1uJt
        YozEA5DL9R94O/9WJwsjBG4=
X-Google-Smtp-Source: AGHT+IH2ONotKwCoa0X+BN7+pTPt9/G8CsCTMoppmFX+g+2QVWAciecEswIBIDJ+X8O3f8I39DRp1g==
X-Received: by 2002:a05:6512:1103:b0:500:77c4:108 with SMTP id l3-20020a056512110300b0050077c40108mr3171484lfg.9.1694188940912;
        Fri, 08 Sep 2023 09:02:20 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.16])
        by smtp.gmail.com with ESMTPSA id dy24-20020a05640231f800b00523a43f9b1dsm1184128edb.22.2023.09.08.09.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Sep 2023 09:02:20 -0700 (PDT)
Message-ID: <53103749-21e0-2a3e-9c46-8befb2753aff@gmail.com>
Date:   Fri, 8 Sep 2023 17:01:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
 <169358121201.335729.4270950770834703042.b4-ty@kernel.dk>
 <f6be40a3-38de-41ed-a545-d9063379f8e2@kernel.dk>
 <ffbe8a96-9f3e-9139-07c6-9bbf863185ed@gmail.com> <ZPq9mY51e7++cbpC@fedora>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZPq9mY51e7++cbpC@fedora>
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

On 9/8/23 07:22, Ming Lei wrote:
> On Fri, Sep 08, 2023 at 02:03:11AM +0100, Pavel Begunkov wrote:
>> On 9/7/23 16:36, Jens Axboe wrote:
>>> On 9/1/23 9:13 AM, Jens Axboe wrote:
>>>>
>>>> On Fri, 01 Sep 2023 21:49:16 +0800, Ming Lei wrote:
>>>>> io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
>>>>> in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
>>>>> Meantime io_wq IO code path may share resource with normal iopoll code
>>>>> path.
>>>>>
>>>>> So if any HIPRI request is submittd via io_wq, this request may not get resouce
>>>>> for moving on, given iopoll isn't possible in io_wq_put_and_exit().
>>>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [1/1] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
>>>>         commit: b484a40dc1f16edb58e5430105a021e1916e6f27
>>>
>>> This causes a regression with the test/thread-exit.t test case, as it's
>>> canceling requests from other tasks as well. I will drop this patch for
>>> now.
>>
>> And this one has never hit my mailbox... Anyway, I'm confused with
>> the issue:
>>

Thanks CC'ing while resending, I don't know what's up with lore

>> 1) request tracking is done only for io_uring polling io_uring, which
> 
> request tracking isn't done on FIXED_FILE IO, which is used by t/io_uring.
> 
>> shouldn't be the case for t/io_uring, so it's probably unrelated?
> 
> So io_uring_try_cancel_requests() won't be called because
> tctx_inflight() returns zero.

That's true for fixed files, but it also holds for non fixed files
as well apart from a narrow case t/io_uring doesn't exercise

>> 2) In case of iopoll, io-wq only submits a request but doesn't wait/poll
>> for it. If io_issue_sqe() returned -EAGAIN or an error, the request is
>> considered not yet submitted to block and can be just cancelled normally
>> without any dancing like io_iopoll_try_reap_events().
> 
> io_issue_sqe() may never return since IO_URING_F_NONBLOCK isn't set
> for iopoll, and recently polled IO doesn't imply nowait in commit

missing nowait semantics should be fine, io_uring_clean_tctx()
sends a signal to workers, which should break them out of waiting.

...
>> We set the flag, interrupt workers (TIF_NOTIFY_SIGNAL + wake up), and
>> wait for them. Workers are woken up (or just return), see
>> the flag and return. At least that's how it was intended to work.
>>
>> What's missing? Racing for IO_WQ_BIT_EXIT? Not breaking on IO_WQ_BIT_EXIT
>> correctly? Not honouring / clearing TIF_NOTIFY_SIGNAL?
>>
>> I'll try to repro later
> 
> After applying your patch of 9256b9371204 ("io_uring: break out of iowq
> iopoll on teardown") and the above patch, the issue still can be triggered,

Yeah, it doesn't appear that it'd help, it was rather something
randomly spotted than targeting your issue.

> and the worker is keeping to call io_issue_sqe() for ever, and
> io_wq_worker_stopped() returns false. So do_exit() isn't called on
> t/io_uring pthread yet, meantime I guess either iopoll is terminated or not
> get chance to run.

That prior to task exit then, right? I wonder if we're missing
signal checking in that loop like below or just need limit the
number of re-submission attempts.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cce8948bddf..c6f566200d04 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1944,6 +1944,8 @@ void io_wq_submit_work(struct io_wq_work *work)
  				break;
  			if (io_wq_worker_stopped())
  				break;
+			if (signal_pending(current))
+				break;
  			cond_resched();
  			continue;
  		}


-- 
Pavel Begunkov
