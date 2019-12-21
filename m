Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2E128A72
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfLUQic (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:38:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46135 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfLUQib (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:38:31 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so5419421pll.13
        for <io-uring@vger.kernel.org>; Sat, 21 Dec 2019 08:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FFdVAvdSfIfaMK6QeKBxjHAHUu1BybZ/Mc92Cm10RCM=;
        b=qc1zHw+VW6fvtAdMa1rHvDqyDHNd7+Q+Y8y+wIrl7sk+MgQnejY+fIYMCUcSeTd7TC
         KTJhjPoRPafvuFIwNcCRbVP5ljKF+ZjNubeTXRtUYK51TGUAze1oEf3lu8wW3o6G6j5G
         +T/cnQFh042QJrG0cDWnoXEfqb6fi2LlSGso2e203JfGnk3Byl/lNlgBIZ22xbCSVoOV
         bws01i7D+G1Ux8T5IxBEYuGLoquSF3r1CONYX1YA2/kfEfK2fuM49aJIknkZYHwSw04z
         ZJMcMixdpg3Ms3It1fWIkBqo0lWRH9H1S50tulab9b9DycNFGC8bbBzCYPzXF31nByfA
         VvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FFdVAvdSfIfaMK6QeKBxjHAHUu1BybZ/Mc92Cm10RCM=;
        b=dJjdHyoWt1ZX0/msynceEYvP2VkGVpsuGw5TrqZvWHhVjO19vYA/d6ZhRfVZAt6Mqu
         l0DFhVOrMLKPClHq1tnUqSRfG4m1cxhR49r+uCfsofxptI/9xXC5X4zGPf6qd1nNE8jS
         hC+NqrGMut+z1My4kSRfkCNQdyY15ILNjnKB4pF3ipPvLwrknKFGnVUY1+U3LrhVh6JE
         oFk7piaEL8B9mYDWew5fyrqgKYzYxxpCAPaHtb14aUNmT9pclct7McCy1QkEuciIcITB
         TSV4KSuQTd7CCBnHRj2Le9VFz2fPKFdtIk7NS5nKKRvXchoBjbQr3gBzHgcC0zG/tGRm
         Wc2A==
X-Gm-Message-State: APjAAAWR0wj7MCQLF+3peg4/K6Iguso7hIc/Y9r5hjYJuSRjzxeUsQNK
        FdphR3s0pI277vibJKsJukmGiQ==
X-Google-Smtp-Source: APXvYqx6B3d6J/kSeFQHWt0/J1oq+oxxSNrQ8Lt0sfC6I92uj8HWw2/xg8PZQ5Dl4KnrpNvtH+QXaQ==
X-Received: by 2002:a17:902:8547:: with SMTP id d7mr22316607plo.44.1576946310927;
        Sat, 21 Dec 2019 08:38:30 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s11sm6925925pfd.157.2019.12.21.08.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 08:38:30 -0800 (PST)
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
 <da858877-0801-34c3-4508-dabead959410@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff85b807-83e1-fd05-5f85-dcf465a50c11@kernel.dk>
Date:   Sat, 21 Dec 2019 09:38:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <da858877-0801-34c3-4508-dabead959410@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/19 9:20 AM, Pavel Begunkov wrote:
> On 21/12/2019 19:15, Pavel Begunkov wrote:
>> Double account ctx->refs keeping number of taken refs in ctx. As
>> io_uring gets per-request ctx->refs during submission, while holding
>> ctx->uring_lock, this allows in most of the time to bypass
>> percpu_ref_get*() and its overhead.
> 
> Jens, could you please benchmark with this one? Especially for offloaded QD1
> case. I haven't got any difference for nops test and don't have a decent SSD
> at hands to test it myself. We could drop it, if there is no benefit.
> 
> This rewrites that @extra_refs from the second one, so I left it for now.

Sure, let me run a peak test, qd1 test, qd1+sqpoll test on
for-5.6/io_uring, same branch with 1-2, and same branch with 1-3. That
should give us a good comparison. One core used for all, and we're going
to be core speed bound for the performance in all cases on this setup.
So it'll be a good comparison.

-- 
Jens Axboe

