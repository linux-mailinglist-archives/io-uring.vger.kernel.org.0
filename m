Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C613160714
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 00:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgBPXGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 18:06:33 -0500
Received: from mail-pf1-f177.google.com ([209.85.210.177]:40487 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgBPXGd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 18:06:33 -0500
Received: by mail-pf1-f177.google.com with SMTP id q8so7843462pfh.7
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dW0nef4Q2iuqbR3d5NTG55VCHiSHhCPPe05HvA5iXEA=;
        b=xJXeIp37vxceqtPtxaiRA69QeNrfSU0RuCTPmvXb04uC3e9kbak358J6GxHC28ClVn
         V5ghBemdVxq+Z95oRAOpAQUmv3jK3jY9Il9GXxyxce/dZR034uCxhjXD68qk9Jj8DBeA
         2mEzs55G0Owvocp5Yrkg5H8n21vNKDA1Fs2iPJ6pKddfGtZ2gksDrRyDFkNmekQnO2wW
         pQTmAv0/HUseidpGtXx7X9TZ+8TfzTbcKHgQ3984D9UMdg/uyy3GezRZN5lkPZqPYNTP
         76QRw88Qu4b5jgrPAo/hIhfv417wdLxEhavb7yUxdTSEVamctR2V0EZpNgmOWZA+rYuA
         hoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dW0nef4Q2iuqbR3d5NTG55VCHiSHhCPPe05HvA5iXEA=;
        b=WKeU/NGP4aF/b8DwIiqer8HuLJzsrjFk0mzVGxTgI5/nILc8vohwxfj69UBmvLs5/g
         uu9M9nwrW0bQh35gQ9utm9oyYcsjtXkJWm9ZVR51EpW83/U6MgCA+Wt3yisDJav6gD/r
         OOZr9+eN0Rw6bTZ6ww8jv5CXfaIvkidFP1I6cDFpRKIXq1RMMgHyaQP/spFlnVPsnren
         vgSlH461ga5GZ3HkoIKmOisqIAvHre7GS0ObW5RB4GtQifD1B+vBzkBB/McNyYSDZVpS
         iox0qde2496UVjfzmd0YqSOnj/dv9umhs57BzmAEMquqJ2T0hjLhpzXn0GfoKpFKmcPQ
         EHzA==
X-Gm-Message-State: APjAAAX/pwbYQ2ARQfCYwbVA6zbwFmEoFccP7nxOtZV3jsumS+wMkJq+
        Pg/z2ZriiIVp5FbGKp+fdhdfF4D8sfo=
X-Google-Smtp-Source: APXvYqw6Se7joGnnxpEpNV7o8ADbLjK2d7yE+ooCEaOaZiRunTtKN1EDRcUYw3uEMhto4m5+/m23Dw==
X-Received: by 2002:a63:3154:: with SMTP id x81mr15170944pgx.32.1581894391260;
        Sun, 16 Feb 2020 15:06:31 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6cdc:d83a:55b1:9a10? ([2605:e000:100e:8c61:6cdc:d83a:55b1:9a10])
        by smtp.gmail.com with ESMTPSA id t28sm14262383pfq.122.2020.02.16.15.06.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:06:30 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
 <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <286b00c4-bff7-6c1a-b81f-612114637019@kernel.dk>
Date:   Sun, 16 Feb 2020 15:06:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/16/20 12:06 PM, Pavel Begunkov wrote:
> Also, the second sync-issue may -EAGAIN again, and as I remember,
> read/write/etc will try to copy iovec into req->io. But iovec is
> already in req->io, so it will self memcpy(). Not a good thing.

That got fixed, it's no longer doing that anymore.

>> +			else if (!retry_count)
>> +				goto done_req;
>> +			INIT_IO_WORK(&req->work, io_wq_submit_work);
> 
> It's not nice to reset it as this:
> - prep() could set some work.flags
> - custom work.func is more performant (adds extra switch)
> - some may rely on specified work.func to be called. e.g. close(), even though
> it doesn't participate in the scheme

For now I just retain a copy of ->work, seems to be the easiest solution
vs trying to track this state.

-- 
Jens Axboe

