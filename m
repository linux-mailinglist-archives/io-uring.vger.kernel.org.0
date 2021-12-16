Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6CA477652
	for <lists+io-uring@lfdr.de>; Thu, 16 Dec 2021 16:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhLPPsG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Dec 2021 10:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238697AbhLPPsD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Dec 2021 10:48:03 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFB4C061574
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 07:48:03 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id c3so35760172iob.6
        for <io-uring@vger.kernel.org>; Thu, 16 Dec 2021 07:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NRFQR8Yf1vYbRc7EqH9E5i9XTaBo5dlhI5KykDhEunY=;
        b=jbGPcR8DsNLJmTTf6Jn9+BAvg4fll+eALhhOgFsGp/QxKiyf2eXeO/QZehs90taEM5
         3LtUg4rDb794xYffxF2sADQi7iP+XEXA1KB3sonsG0AHRXtK2neRkUFAPylYDlYVYqU5
         or8HEX0QhTXCjKXZgwdfg1t97UiAHTeGGtfIQHInHTzRBpmwh3SfhXau2MrLoplwy24r
         W8r16JxcPaTWD95IJF9JIUZSnEd3+Eme0MfTGZyOX/qUogC7yPIKavUJmqWVExMS3HBY
         CxNpYVcHQsZrcJJItYMK2+tx3ivpnbOecMDV82BSlSTgaMG8ydKudoBBFSB8X4vGeS3j
         weGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NRFQR8Yf1vYbRc7EqH9E5i9XTaBo5dlhI5KykDhEunY=;
        b=hFpA93ItwsqWKQsU5rSx0fa13K7bjIQ5CDa5yyJejWUIYK3IyvC0/15G8fYpRLa4/V
         twNBkBlWDGqqHt3uxyBQgigbbSBQMgeyUaB/7BDlX7TRNbE35jTPMJRoLvSAMl38801o
         Vip/cKCBBTolGBMStnKFTZlKCddWZXra3hDsCLpT1+0ZFN9D0RyLeYAqbNp4YsRI7Bcn
         cjSiqCAszfFxtu9lLtInxZY8ElIJIVcxg1bAI51dtnPlTGF6kn2SLJdlZyBUT7sd6Tjy
         2ENxTzYMIvBfSWiy2/k/KcV97Rw4WL/IEjvnYSIQhHFZ6fkYo+zueyvcgZkyyh/ryFpY
         UOpA==
X-Gm-Message-State: AOAM533+BMKQb9XZBRRZdTUwUvcay0QUzXzw/bOHyuNJxSahX8QEJ/KS
        3rYn8kHzrUpdRGnZT/aD7ZwX35iC+wZpYw==
X-Google-Smtp-Source: ABdhPJwOvcVk5qmGsJ1rKQqPyPcBkxxJ2k5pa75zQElP9O9KZv4qyx8PvMI6zG+010jN7cnOKI0L4w==
X-Received: by 2002:a02:85a9:: with SMTP id d38mr9988551jai.71.1639669682314;
        Thu, 16 Dec 2021 07:48:02 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j7sm3552824iow.26.2021.12.16.07.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 07:48:02 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk> <YbsB/W/1Uwok4i0u@infradead.org>
 <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06ab52e6-47b7-6010-524c-45bb73fbfabc@kernel.dk>
Date:   Thu, 16 Dec 2021 08:48:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2adafc43-3860-d9f0-9cb5-ca3bf9a27109@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/16/21 6:06 AM, Max Gurtovoy wrote:
> 
> On 12/16/2021 11:08 AM, Christoph Hellwig wrote:
>> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>>> +	spin_lock(&nvmeq->sq_lock);
>>> +	while (!rq_list_empty(*rqlist)) {
>>> +		struct request *req = rq_list_pop(rqlist);
>>> +		struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
>>> +
>>> +		memcpy(nvmeq->sq_cmds + (nvmeq->sq_tail << nvmeq->sqes),
>>> +				absolute_pointer(&iod->cmd), sizeof(iod->cmd));
>>> +		if (++nvmeq->sq_tail == nvmeq->q_depth)
>>> +			nvmeq->sq_tail = 0;
>> So this doesn't even use the new helper added in patch 2?  I think this
>> should call nvme_sq_copy_cmd().
> 
> I also noticed that.
> 
> So need to decide if to open code it or use the helper function.
> 
> Inline helper sounds reasonable if you have 3 places that will use it.

Yes agree, that's been my stance too :-)

>> The rest looks identical to the incremental patch I posted, so I guess
>> the performance degration measured on the first try was a measurement
>> error?
> 
> giving 1 dbr for a batch of N commands sounds good idea. Also for RDMA host.
> 
> But how do you moderate it ? what is the batch_sz <--> time_to_wait 
> algorithm ?

The batching is naturally limited at BLK_MAX_REQUEST_COUNT, which is 32
in total. I do agree that if we ever made it much larger, then we might
want to cap it differently. But 32 seems like a pretty reasonable number
to get enough gain from the batching done in various areas, while still
not making it so large that we have a potential latency issue. That
batch count is already used consistently for other items too (like tag
allocation), so it's not specific to just this one case.

-- 
Jens Axboe

