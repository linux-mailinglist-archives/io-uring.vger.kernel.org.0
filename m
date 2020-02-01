Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCEFC14F5E4
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 03:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBACKD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 21:10:03 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41701 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgBACKC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 21:10:02 -0500
Received: by mail-pg1-f194.google.com with SMTP id l3so449379pgi.8
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 18:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=H5w6I3OS4WZjjlTpvsBmyPnESGojpboh+taS7AUCgO4=;
        b=xvfUtClqOCuoLdJ/ZRdfM5dQbo5QM8ntjeUBENH8l/BRCSbUD96QR6RXH1ubGsM99Q
         V6RLOdEGCNa+019hQCLuzoIx7grR48V6/w0D9Ku7KxiI/OmjwkH4ar/ZKALkEmTvpqBx
         nhXIW6w4nM0FkLPd8EHvcv+EeMO+1r1EJuPIVlL8lS4Kjlbqmr0uIqqsoHrAKpMs3GF9
         jpwEjiXpoBKgUUdbaiZguYgg33zPISAkKgIN2KK9ranthjJlptdbuk8G/nFEkQcmdxyB
         FXpWfGUmuTc3PWr8eIg7WYvQixP3wP4cMuCrbVzZyAlJa88pRYEk22R6F/doh8KkIZU7
         +vwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H5w6I3OS4WZjjlTpvsBmyPnESGojpboh+taS7AUCgO4=;
        b=Tt7ONbZvI91/4aclv4KeZDtYsz00D8USoCQS++hvJaFLpo04LiP7dZSjGmT560HQR3
         Px5yyrlNA8Sr76dJlqNMXm19iSMzjIaEXKA3J/Vp/ftWhogrFv7exu+Z1OzFrwK+V+Tf
         dmkG63KJa870J7NrEh+2/Kgd/KkbFo2Vfxc+paM2eYQaNbWRHjAuVTS80Uv4BspDTvzL
         4+M93Yy0JKJkHu94s+E2cTLrhOhzjZBgFBLOPvGWz0lHzbe79KcxUtxTnynM4uavJPw3
         IAkO8A+15EX/9Ib8DCHw5NREAj6Kw3vh8CUTjKO/Bc0LcEKCQmsSap0DvCNfiLyjNrA7
         vHlw==
X-Gm-Message-State: APjAAAXEOGiLctUJkxsfaZ1hu2XmZhldkyAI+5bVqU6kW/LKehb9QK/a
        Q1uDSOmZFkI9pddjQDXo0J2/ZHRS++s=
X-Google-Smtp-Source: APXvYqyxUdFrg7gok840YZS/l6mgq1lD7uIP+gO4ce+WlI79wghcXrpok74+fc3sDsFCSe3mIM6kPQ==
X-Received: by 2002:a63:ba05:: with SMTP id k5mr13097453pgf.158.1580523000535;
        Fri, 31 Jan 2020 18:10:00 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm11568922pjv.32.2020.01.31.18.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 18:10:00 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix sporadic double CQE entry for close
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b0b0bb08-d3ab-a9f7-d468-6f113fbda19f@kernel.dk>
 <c1b8f3c9-af7c-7327-cd15-5bc92ffc8e6b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ac0d841-0307-d475-be84-ffaaf1c985b3@kernel.dk>
Date:   Fri, 31 Jan 2020 19:09:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c1b8f3c9-af7c-7327-cd15-5bc92ffc8e6b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/31/20 5:40 PM, Pavel Begunkov wrote:
> On 01/02/2020 03:21, Jens Axboe wrote:
>> We punt close to async for the final fput(), but we log the completion
>> even before that even in that case. We rely on the request not having
>> a files table assigned to detect what the final async close should do.
>> However, if we punt the async queue to __io_queue_sqe(), we'll get
>> ->files assigned and this makes io_close_finish() think it should both
>> close the filp again (which does no harm) AND log a new CQE event for
>> this request. This causes duplicate CQEs.
>>
>> Queue the request up for async manually so we don't grab files
>> needlessly and trigger this condition.
>>
> 
> Evidently from your 2 last patches, it's becoming hard to track everything in
> the current state. As mentioned, I'm going to rework and fix submission and prep
> paths with a bit of formalisation.

Honestly don't think it's that bad, not unusual to have a bit of
fallout from the large amount of changes that just went in. That said,
I'm obviously always interested in anything that is clear and hardens
the flow.

-- 
Jens Axboe

