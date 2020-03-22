Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED918EC05
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 20:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgCVTvh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 15:51:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35830 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgCVTvh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 15:51:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id u68so6381584pfb.2
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 12:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Gzuwlbx6R45ZCfdoncAt4iaxakaOdKNbv4vbpAiOBUs=;
        b=NcByhkb1KKSTRGMifLTFlzIo3rJs2iLUau/AbCwqE2MiXPMu5f0f6PezFZN4sfWHAC
         Dll1D49mJS1X9jFbR5QYr4NjsL4Xp3WAcIWWzr7MUx+WT3f1r0mvQJtdO+Gofo6CsImk
         Te1V72gHcEnsA9pCdBowT9w4f2eM4dxn1H/ilpBqHoJkMDgO34nLr8Dfr342Jm7ykEVR
         XrD6tYUGH3Oyt7n3Gf8ERwuzrBiOID79HL8PBvwMMGdgeTB4RluGNRBBE74ux4+n6W6u
         ynD/2ufk9faZAYI0y4lmM5SaWWXTZasl+5fx8XqPT5kTcoOHEgeikmSX+7wMz5HjY0KG
         oiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gzuwlbx6R45ZCfdoncAt4iaxakaOdKNbv4vbpAiOBUs=;
        b=CR3zNG49RrIr3VH9uAVFkYbvE3VxQ+inAuuEL5EvoSCtm4VEUpSs6ATu1n1DTTXNzZ
         iliXt5DryeylK/cbu2AzJTQLuWp6bbXzwbTbn3zwKvHgFTeUp+MSDoxB0yoWfc6TWJx9
         3qp9+jZOtEBCzhR0kiNARAvqpbkDXdcDxZQyWnaAL/BTJIRwuKc75D64owUw4Zp7qpvE
         aLtg61VLUhzeRh4m4Sh4BaUbMxtwpSafdqbLKJ3DxrSpnnaDpcZK6ptMzIJTang6lYTl
         omDh+FlPWbHvAquA/MQQjzitDG/ZUN5r08gnlRwfMTKEC2gQ5z26jYmWLd8YLsMqMrYy
         mFtQ==
X-Gm-Message-State: ANhLgQ25lxCMsQQI2+1VObErwF3Btfp5mASJLTX6yBLK3AX8+rcnvhtp
        5ENlVQ+zLVNZta2LfHqhcpJ3IJowcyM/mg==
X-Google-Smtp-Source: ADFU+vvQ1bieuzboDNUZMw+eZ5R2cv7ZZC4qBkn2K1MCbaO0yKUdelvU2x9XogDKaD03QdnRJIL9Bg==
X-Received: by 2002:a63:f502:: with SMTP id w2mr10585435pgh.423.1584906694115;
        Sun, 22 Mar 2020 12:51:34 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k2sm10205953pgj.16.2020.03.22.12.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 12:51:33 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
Date:   Sun, 22 Mar 2020 13:51:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 12:54 PM, Pavel Begunkov wrote:
> On 22/03/2020 19:24, Pavel Begunkov wrote:
>> On 22/03/2020 19:09, Pavel Begunkov wrote:
>>> On 19/03/2020 21:56, Jens Axboe wrote:
>>>> We always punt async buffered writes to an io-wq helper, as the core
>>>> kernel does not have IOCB_NOWAIT support for that. Most buffered async
>>>> writes complete very quickly, as it's just a copy operation. This means
>>>> that doing multiple locking roundtrips on the shared wqe lock for each
>>>> buffered write is wasteful. Additionally, buffered writes are hashed
>>>> work items, which means that any buffered write to a given file is
>>>> serialized.
>>>>
>>>> When looking for a new work item, build a chain of identicaly hashed
>>>> work items, and then hand back that batch. Until the batch is done, the
>>>> caller doesn't have to synchronize with the wqe or worker locks again.
>>
>> I have an idea, how to do it a bit better. Let me try it.
> 
> The diff below is buggy (Ooopses somewhere in blk-mq for
> read-write.c:read_poll_link), I'll double check it on a fresh head.

Are you running for-5.7/io_uring merged with master? If not you're
missing:

commit f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Mar 13 22:29:14 2020 +0300

    io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}

which is what I ran into as well last week...

> The idea is to keep same-hashed works continuously in @work_list, so
> they can be spliced in one go. For each hash bucket, I keep last added
> work
> - on enqueue, it adds a work after the last one
> - on dequeue it splices [first, last]. Where @first is the current
>   one, because
>
> of how we traverse @work_list.
>
> 
> It throws a bit of extra memory, but
> - removes extra looping
> - and also takes all hashed requests, but not only sequentially
>   submitted
> 
> e.g. for the following submission sequence, it will take all (hash=0)
> requests.

> REQ(hash=0)
> REQ(hash=1)
> REQ(hash=0)
> REQ()
> REQ(hash=0)
> ...
> 
> 
> Please, tell if you see a hole in the concept. And as said, there is
> still a bug somewhere.

The extra memory isn't a bit deal, it's very minor. My main concern
would be fairness, since we'd then be grabbing non-contig hashed chunks,
before we did not. May not be a concern as long as we ensure the
non-hasned (and differently hashed) work can proceed in parallel. For my
end, I deliberately added:

+	/* already have hashed work, let new worker get this */
+	if (ret) {
+		struct io_wqe_acct *acct;
+
+		/* get new worker for unhashed, if none now */
+		acct = io_work_get_acct(wqe, work);
+		if (!atomic_read(&acct->nr_running))
+			io_wqe_wake_worker(wqe, acct);
+		break;
+	}

to try and improve that.

I'll run a quick test with yours.

-- 
Jens Axboe

