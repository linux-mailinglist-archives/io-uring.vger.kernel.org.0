Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2696918EDAF
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 02:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCWBiC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 21:38:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37093 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgCWBiC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 21:38:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id h72so4485936pfe.4
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 18:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+42l95w0n0aXjJ4w7Bb2a0kT3DFHRfAQFO7V7LjKWr8=;
        b=Kd827JWo9RRMaaA2f43ZfADSWDzdMtfDNN4XpEe+2V5rn0zeQYjG8e6jQXH2hqI4be
         vhK34PUXytBjBhvOlJG2+yLmSp5o4x4QrokqS/XhVn4UOcRSboASv8tFLiSj8JR0W3Re
         Oo0Yb2EGujYa0VCKngt4FszOrUXUgv38Js3fVNu2c2Jb+B93OPwBtyzBBlDTxJEaEj8w
         kjKyAzhPYWrP5bafLyCzvg4At/UmUzHzt+FglSu+OnhvIU/pcKRRyap0DOcs1jLVke/V
         fnn2m5dW9MPgW+xIt3FxGkTsmeVF+cVjN0wh+muPh8bqIPBs9tW4HD/Oq/LGVbThFvCq
         glcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+42l95w0n0aXjJ4w7Bb2a0kT3DFHRfAQFO7V7LjKWr8=;
        b=CuLBUE/sDj9MnZ4iOtQgXcHSlfw4O1bwxvN60XnLpbREz0SD34db9/JDTvV2eysKAO
         ll+bqsOogWqxNNTPReNZMjDjVlgOuEjNoRq998bCDg34FbRsu2AItMA3d1PqKCUSDjzN
         rAY1eM8YWBpYjLESi/NWp62rY4qcdjO+ujiMRbe+BKxpANN8/Tv+oY9Bv0F+gpkSXR9M
         Vf0Wwb5Hdc2OG8TYPu3/9Qd5Lsm3/m7uC8kv4MmjJL6upCAgOlKnaqsJTjwlLbdpOF13
         MJC9R5sWspXecGzWJAVbwzur1PB3wI01hBrIaMCH9qQhcdxidB3Y3sJQzPdSyKomwA4d
         4p1A==
X-Gm-Message-State: ANhLgQ0bc779WJol8BLn63p83bz/KLtxpmFBPOtfbWuZOX9m5xRzqq+o
        F4uf7g/BGgUvyB9xAgY0lhnk7OEX6q0YUQ==
X-Google-Smtp-Source: ADFU+vstZI1OqeHsOnRFIF9Ofq53+8yoaUVKLMJ5EJ/x5Rq8fkT6zvDEjXtnTv8r1oDTmUcNdWeRjQ==
X-Received: by 2002:a63:4912:: with SMTP id w18mr19136200pga.122.1584927479311;
        Sun, 22 Mar 2020 18:37:59 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 19sm10675894pgx.63.2020.03.22.18.37.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 18:37:58 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d2093dbe-7c75-340b-4c99-c88bdae450e6@kernel.dk>
Date:   Sun, 22 Mar 2020 19:37:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b8bc3645-a918-f058-7358-b2a541927202@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/22/20 2:25 PM, Pavel Begunkov wrote:
> On 22/03/2020 22:51, Jens Axboe wrote:
>> commit f1d96a8fcbbbb22d4fbc1d69eaaa678bbb0ff6e2
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Fri Mar 13 22:29:14 2020 +0300
>>
>>     io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
>>
>> which is what I ran into as well last week...
> 
> I picked it before testing
> 
>> The extra memory isn't a bit deal, it's very minor. My main concern
>> would be fairness, since we'd then be grabbing non-contig hashed chunks,
>> before we did not. May not be a concern as long as we ensure the
>> non-hasned (and differently hashed) work can proceed in parallel. For my
>> end, I deliberately added:
> 
> Don't think it's really a problem, all ordering/scheduling is up to
> users (i.e.  io_uring), and it can't infinitely postpone a work,
> because it's processing spliced requests without taking more, even if
> new ones hash to the same bit.

I don't disagree with you, just wanted to bring it up!

>> +	/* already have hashed work, let new worker get this */
>> +	if (ret) {
>> +		struct io_wqe_acct *acct;
>> +
>> +		/* get new worker for unhashed, if none now */
>> +		acct = io_work_get_acct(wqe, work);
>> +		if (!atomic_read(&acct->nr_running))
>> +			io_wqe_wake_worker(wqe, acct);
>> +		break;
>> +	}
>>
>> to try and improve that.
> 
> Is there performance problems with your patch without this chunk? I
> may see another problem with yours, I need to think it through.

No, and in fact it probably should be a separate thing, but I kind of
like your approach so not moving forward with mine. I do think it's
worth looking into separately, as there's no reason why we can't wake a
non-hashed worker if we're just doing hashed work from the existing
thread. If that thread is just doing copies and not blocking, the
unhashed (or next hashed) work is just sitting idle while it could be
running instead.

Hence I added that hunk, to kick a new worker to proceed in parallel.

-- 
Jens Axboe

