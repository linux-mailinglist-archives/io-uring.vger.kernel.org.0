Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1415846F
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2020 21:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgBJUxj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 15:53:39 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:40414 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJUxj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 15:53:39 -0500
Received: by mail-il1-f194.google.com with SMTP id i7so1487504ilr.7
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 12:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dCd2gxtB0s0GW+Hn+y/yyRY7RtM6NVWJVybykJQmFjA=;
        b=bohTEwrcmY5Zja/JQSyWCh0pMPyj4spag51miE3uAdynoR8NJQ/scVtewEMYC3hrah
         i4nBj11pF9qVOTSvI+2pyvb2WZVW7mEX8TOO8/uKk9feHzmV32iwa1xBHcWkhMjN5E2m
         8JEhOS94P2vMZJw4En05WhuRtah9w8sb3ngeUxfdIV3f/xyEppzT26vqdo6aR30PBnu5
         XXUyvcUAevX2cYUokJqr7bxnskm13eavsHoREETLw9N4kWOAI26SzvfhrcT7Meni3aw3
         kBF+dU25wV2iKrR8T8jNfss2WTxJOYglBqasqt2wbHMsJvrbNQ5dOHRo7x0JPhOtHnQZ
         HqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dCd2gxtB0s0GW+Hn+y/yyRY7RtM6NVWJVybykJQmFjA=;
        b=LGc/Ox3OZosyY2GaBMXcXs7++u2pTqslZ3WVTfWSg5af+LPuYFr85Z0wG2xpOqSqUx
         jMR5NNkoVwYbbjzYyRDdoljjChAiXCYhjDZG5fg5KUx0cJ3BxnCNG4Y9NTPiPPoU8JRS
         9ctLQR++EsdGC49Nsd7+VYWy61te54+rWSnjycKni5O+55u71RAcptPF8D7iG+5cKY2i
         mE1wDFEiKkGrgbVMzjo4FKLfmSEiaOs21Nmw12lsvb7uLh2aeV36Rx6I+Klz4mJWolNi
         rDaVtZeiJJb/ZDiCTDdDVktRBm33fFXxsA2My2Vj5m9r1zow41FTEvHThhUVNGcXwRvl
         XJSA==
X-Gm-Message-State: APjAAAWA66xEWhYYlhP4oPVpur/FNR2WsR4ILthi4QK00bx5/i5vcRM5
        R8w2N9/jey+u8qeHHZoHx/mrqP06k80=
X-Google-Smtp-Source: APXvYqzoDz73mFxjJfc8jz8/vYIgISDgZA8cijOny6ePhOImpzWy1o/g8yyuLY9MFc1Lla8vlLwDAg==
X-Received: by 2002:a92:914a:: with SMTP id t71mr3390528ild.293.1581368017308;
        Mon, 10 Feb 2020 12:53:37 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e7sm390709ios.47.2020.02.10.12.53.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 12:53:36 -0800 (PST)
Subject: Re: TODO list item - multiple poll waitqueues
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <81c68aa5-1ea4-3378-58c2-4bb9c6d779ad@kernel.dk>
Message-ID: <478d23ec-eb51-3c9b-4ca6-4430d446dec6@kernel.dk>
Date:   Mon, 10 Feb 2020 13:53:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <81c68aa5-1ea4-3378-58c2-4bb9c6d779ad@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/20 8:12 AM, Jens Axboe wrote:
> Hi,
> 
> This has been on my TODO list for a while, just haven't gotten around to
> it.
> 
> The issue is that some drivers use multiple waitqueues for poll, which
> doesn't work with POLL_ADD. io_poll_queue_proc() checks for this and
> fails it:
> 
> static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
> 			       struct poll_table_struct *p)
> {
> 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
> 
> 	if (unlikely(pt->req->poll.head)) {
> 		pt->error = -EINVAL;
> 		return;
> 	}
> 
> 	pt->error = 0;
> 	pt->req->poll.head = head;
> 	add_wait_queue(head, &pt->req->poll.wait);
> }
> 
> since we just have the one waitqueue on the io_uring side. Most notably
> affected are TTYs, I've also noticed that /dev/random does the same
> thing, and recently pipes as well.
> 
> This is a problem for event handlers, in that not all file types work
> reliably with POLL_ADD. Note that this also affects the aio poll
> implementation, unsurprisingly.
> 
> If anyone has the inclination to look into this, that'd be great.

Of course after sending this one, I did take a look and hacked up
some support for it. Not super happy with it, but I'll send it out
for proper review and hopefully we can turn it into something that's
5.6 material.

Forgot to mention that this is particularly sucky since pipes were
recently switched to using multiple waitqueues.

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-5.6-poll

-- 
Jens Axboe

