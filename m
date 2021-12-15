Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9A4476340
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 21:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhLOU1L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 15:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhLOU1J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 15:27:09 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF1DC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 12:27:09 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id t1so7475841ils.11
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 12:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LYn1ZC4DeuBKxM0V2BD7F1TKYsmbDE4nEOted6fGKI0=;
        b=se+oAFPIed6TNd0+XV9t2qZzZ80RJl8fuRbEqnYd0TaUu09Ie1k/fHYEpH4MW/1Rbe
         oNEBBZcfySoXb/Q1bq2LaacVcb9KgoRIHsDl4yoO03POJLU7Fx/JJJvuz1Df1PRtsB3P
         CgOG+mHa1UK/BmvfCAVsWWYE6BWJkwzMtcYWEbjRW99aSE8axodOyvaXSbsOaXhOS870
         EB0PgrAsF7j86zFD8Qrql46YS4LsL3yVzJwtGhk04gMSh9Zu0Nvcuooqp7SZYAN4gGle
         dv7HThoMfhUWvyoqQEu9KVabscD95IW3lK9zETG8sdQryQcP882B26S/Q94Va3wbyrAQ
         z30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LYn1ZC4DeuBKxM0V2BD7F1TKYsmbDE4nEOted6fGKI0=;
        b=qid0uTYkJ5LdjBjLLuXyg7gcO89kWysK/iwww3W60EeP/15huTVYgi6YnQXTi6zj4e
         xAv9aeQFbUZgpp0IfflQwP+WKRNPc+W/8SUhA8Fv9aM7JxwwbRy/kQ5yq9Jm8X183GjP
         gmQPwp2pmfEi9Ter9Lq5z3520snNZAcnfEa8Ssw6FhSvRl+JHxz0c0mQrre4dZcopWbf
         34WJq9BpA/CMWIJo8FLYoC5X5+Y7vHQ846cp+m5ZW++uN0olm+r7NZ28UAzaGOYy3hrp
         wtL+mwJz8GeQuT3aQcQ52BpDfZhHJpwDdw6/f+PtklAVpYg0aYN2AbLNuNd26W07MF/u
         7pNg==
X-Gm-Message-State: AOAM531ZbSmbSG7Q+uLlh4PFqPjqQH2HZbZgGNDV908mnc9r/Qdx3RGQ
        Zzfx+QAuI0Dkgr97wr1L/i2TeQ==
X-Google-Smtp-Source: ABdhPJwL0sALDY0MBYeyDEG7RYyYRKxrVtN1yVtKOAk3BO7u9LJ/x6SYjPmmzOyFScZhQGgNR/lquw==
X-Received: by 2002:a92:d992:: with SMTP id r18mr7350460iln.224.1639600028666;
        Wed, 15 Dec 2021 12:27:08 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r14sm1575628ill.70.2021.12.15.12.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 12:27:08 -0800 (PST)
Subject: Re: [PATCH 4/4] nvme: add support for mq_ops->queue_rqs()
To:     Keith Busch <kbusch@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
References: <20211215162421.14896-1-axboe@kernel.dk>
 <20211215162421.14896-5-axboe@kernel.dk>
 <20211215172947.GB4164278@dhcp-10-100-145-180.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ac9c7c9f-0b7f-12ea-38bb-b3b9279c8baf@kernel.dk>
Date:   Wed, 15 Dec 2021 13:27:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211215172947.GB4164278@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/15/21 10:29 AM, Keith Busch wrote:
> On Wed, Dec 15, 2021 at 09:24:21AM -0700, Jens Axboe wrote:
>> +static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
>> +{
>> +	/*
>> +	 * We should not need to do this, but we're still using this to
>> +	 * ensure we can drain requests on a dying queue.
>> +	 */
>> +	if (unlikely(!test_bit(NVMEQ_ENABLED, &nvmeq->flags)))
>> +		return false;
> 
> The patch looks good:
> 
> Reviewed-by: Keith Busch <kbusch@kernel.org>

Thanks Keith!

> Now a side comment on the above snippet:
> 
> I was going to mention in v2 that you shouldn't need to do this for each
> request since the queue enabling/disabling only happens while quiesced,
> so the state doesn't change once you start a batch. But I realized
> multiple hctx's can be in a single batch, so we have to check each of
> them instead of just once. :(
> 
> I tried to remove this check entirely ("We should not need to do this",
> after all), but that's not looking readily possible without just
> creating an equivalent check in blk-mq: we can't end a particular
> request in failure without draining whatever list it may be linked
> within, and we don't know what list it's in when iterating allocated
> hctx tags.
> 
> Do you happen to have any thoughts on how we could remove this check?
> The API I was thinking of is something like "blk_mq_hctx_dead()" in
> order to fail pending requests on that hctx without sending them to the
> low-level driver so that it wouldn't need these kinds of per-IO checks.

That's a good question, and something I thought about as well while
doing the change. The req based test following it is a bit annoying as
well, but probably harder to get rid of. I didn't pursue this one in
particular, as the single test_bit() is pretty cheap.

Care to take a stab at doing a blk_mq_hctx_dead() addition?

-- 
Jens Axboe

