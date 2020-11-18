Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120F22B8152
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 17:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgKRP50 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 10:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgKRP50 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 10:57:26 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1061AC0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 07:57:26 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so1390944pga.7
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 07:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aYoULJBLjYGf/KnqfWyFT8lv8s/n50oQRcou8Xw75Ww=;
        b=cLBFqLchvcrUH3Zu4Uj8bOR4y04RQu9MUrmHxnwUP0h5Quwcf9UB5Z033XjW0wPDgz
         Z7vEZOtExQX4I7Hp/jonp8DgxeT70EWqcTxxaWC9onpU5krj0HKnadRqnk+vOCHJZsYO
         EfetRUXmARI7r42v/BJf/nrQ4v2wMJwX4J+m+2qezQlcsaGXbYuQZYHhOLqMPbo5WZ4L
         Ks2CDKcRUyjHU/jLu6sII5SBHyE261OTuv3yevB7bW50Xj8XRBgsB1b5poPWFvycqITx
         97pCDuePjQNpxW0yYE7xSZOPfuWB2zYgrX93fan5lWjdGxD9XgqI9WV8Dt4hmfIVdvL8
         r9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYoULJBLjYGf/KnqfWyFT8lv8s/n50oQRcou8Xw75Ww=;
        b=m6VmIx8W7YO7L0vIYmPZyZdHzwx3cOAALCUhHxGsSocOQsDE/KskoiCsv9Q8TjpUnE
         if20J7qr15EkFITkjY6Q95Ot6g1YfqMWeXdI3owuflRs8xZxd6aksAuMY8/Aqj6Zt88r
         bpM+cDy0EeAy4hTV6KzvpduqbxHUHgXHBRF+sK5dHmDrq47agP9cKevaCIOCWARe7pQv
         OJrf1BX072zAglatxpxxONzK5/NuEQ+GKCguHjzSpD9wvPc+lI8hjpBAcylo0Cvd6bkO
         1TCQU2D8XW7sKTUmYTrmairBWUgZE8t3R9P3/J4OidHskbf9QCmmyt3bJuZ0ZuJkSYKK
         +W1A==
X-Gm-Message-State: AOAM533zbwz+LpAs3aYz7MCwy+tCae3/HEA5gdjCb9Isc+VW3urcZDiL
        ginIFv7sCQ+wcv+pWUnKDot7Tg==
X-Google-Smtp-Source: ABdhPJzv/1OFAb/EUWVPFWBWDL9WYPrmUkagXaAX2rHAvBATQIpTkrTxd8QlTu6PKSRpHaWnvlg4sA==
X-Received: by 2002:a63:7703:: with SMTP id s3mr9118331pgc.9.1605715045522;
        Wed, 18 Nov 2020 07:57:25 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 85sm26069623pfa.204.2020.11.18.07.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 07:57:24 -0800 (PST)
Subject: Re: [PATCH 5.11 2/2] io_uring: don't take percpu_ref operations for
 registered files in IOPOLL mode
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201117061723.18131-1-xiaoguang.wang@linux.alibaba.com>
 <20201117061723.18131-3-xiaoguang.wang@linux.alibaba.com>
 <8e597c50-b6f4-ea08-0885-56d5a608a4ca@gmail.com>
 <9713dc32-8aea-5fd2-8195-45ceedcb74dd@kernel.dk>
 <82116595-2e57-525b-0619-2d71e874bd88@gmail.com>
 <148a36f1-ff60-4af6-7683-8849c9973010@kernel.dk>
 <f8e59ed9-4329-dada-cf16-329bdb7335be@gmail.com>
 <12c010e5-d298-c48a-1841-ff0da39e2306@kernel.dk>
 <2a1f4d77-87f4-fe50-b747-8f1be1945b55@linux.alibaba.com>
 <9e325c66-1b55-6ef9-6fac-cca7b00cda1f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1f1c9d3d-e4ba-e2dc-c044-2405418bf0cf@kernel.dk>
Date:   Wed, 18 Nov 2020 08:57:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9e325c66-1b55-6ef9-6fac-cca7b00cda1f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/20 8:52 AM, Pavel Begunkov wrote:
> On 18/11/2020 15:36, Xiaoguang Wang wrote:
>>> On 11/18/20 6:59 AM, Pavel Begunkov wrote:
>>> Ran it through the polled testing which is core limited, and I didn't
>>> see any changes...
>> Jens and Pavel, sorry for the noise...
> 
> Not at all, that's great you're trying all means to improve
> performance, some are just don't worth the effort.

Exactly, never stop trying, it's just that not all efforts pan out.
That's pretty typical for software development :-)

>> I also have some tests today, in upstream kernel, I also don't see
>> any changes, but in our internal 4.19 kernel, I got a steady about 1%
>> iops improvement, and
> 
> hmm, 1% is actually a good result

It is, I wonder why there's such a big discrepancy between the 4.19 base
and current -git in terms of the win on that. Might be changes outside
of io_uring.

-- 
Jens Axboe

