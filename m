Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E192716B7B1
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 03:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgBYCYQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 21:24:16 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:35561 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbgBYCYQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 21:24:16 -0500
Received: by mail-pl1-f176.google.com with SMTP id g6so4851215plt.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 18:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0YwjVigdP4+UYrZXG/qp277eDCcOtRgBqeTFNhiPxio=;
        b=sXxFgrH0qaakj8owFcK+N+g+fZLzQ16rN/1+6aJ2loUijV4Q3YqZXHwrZI+t1QdO/0
         OLPQHnFUrY1e6XH2WkRdQuNsZ0XLsPzx9ROOX8eyOrQ4PScsxXjpb8CvROtV/2Bxqp4P
         yXz5E3V8I1214FqWtx+YJjeEM0iwySgvl1G9aD3+wHjw630J9JyuZ3fo6F4IiLBebmjC
         0gDwKFRP4w4OpXCos5HkCUhDTvvCC9Xfv7gaBe5wOZMsHv7tzr66/1oF/H+K+YTXUIIG
         YGtit7FEpkGqL/GrTJ21wlKYF72KBW2Txv2b/N91U3jP10abv1wkaeDr+Z1lB1Gyqksv
         POhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YwjVigdP4+UYrZXG/qp277eDCcOtRgBqeTFNhiPxio=;
        b=dJMwb1DZX18SlFG5aVikmmWgNYdF933j7xCvfkLMm16qYPGl625DsmFgOJ9DTvzsBc
         3KUoFzfv3Je7V7HR8QWhSJMWjgJLXHIiYtzY2KKi0rTdyqFpN5D6b4rAgsjjDUEWLYuC
         y5ZdUj17cfyK3fk7/K9/pas0ISBn3WuonuiOH2ZRH1Spw/jjJjAoOcbmIWwv8UrfdgVR
         e5IaYPbAc1DMCd/YtkU/Y5IBKGxwLNcwpuAvHb9xRGAdXIfTWds5Gnqy+6myHEO8uGLg
         bI/yJlQWy466jyQ+6aFv/DhA6zLZR2pC2PWcRRMBJp4GB7Kxn4pVKvuiZFbrSig1Ey5/
         9wNw==
X-Gm-Message-State: APjAAAXy1cXEwldvZw1KY8Q64uqzu4R+138taIhamFVDc350+jWYOsBb
        Nm5La3b0inpEd6Sz6eanW42npg==
X-Google-Smtp-Source: APXvYqwn3RlqbGsgqzQs3dNMdh+urLIFCIxdCJru4X8wlrRE4rN9GA+nv9kKFS4W5sXn6I+0TvKVTg==
X-Received: by 2002:a17:90a:fb41:: with SMTP id iq1mr2463410pjb.89.1582597452499;
        Mon, 24 Feb 2020 18:24:12 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a195sm14448726pfa.120.2020.02.24.18.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 18:24:11 -0800 (PST)
Subject: Re: [RFC] single cqe per link
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38527def-4041-ddee-0cfe-c9aff0f4dc37@kernel.dk>
Date:   Mon, 24 Feb 2020 19:24:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 5:39 PM, Pavel Begunkov wrote:
> I've got curious about performance of the idea of having only 1 CQE per link
> (for the failed or last one). Tested it with a quick dirty patch doing
> submit-and-reap of a nops-link (patched for inline execution).
> 
> 1) link size: 100
> old: 206 ns per nop
> new: 144 ns per nop
> 
> 2) link size: 10
> old: 234 ns per nop
> new: 181 ns per nop
> 
> 3) link size: 10, FORCE_ASYNC
> old: 667 ns per nop
> new: 569 ns per nop
> 
> 
> The patch below breaks sequences, linked_timeout and who knows what else.
> The first one requires synchronisation/atomic, so it's a bit in the way. I've
> been wondering, whether IOSQE_IO_DRAIN is popular and how much it's used. We can
> try to find tradeoff or even disable it with this feature.

For a more realistic workload, I can try and run a random read workload
on a fast device. If I just make the QD the link count, then we'll
have the same amount in parallel, just with link-depth ratio less
CQEs. I'd be curious to see what that does.

-- 
Jens Axboe

