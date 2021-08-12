Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C073EA8A0
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 18:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhHLQkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 12:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbhHLQkC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 12:40:02 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1476FC0613D9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 09:39:37 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l36-20020a0568302b24b0290517526ce5e3so1017627otv.11
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 09:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oc7AsSC8FMlC5aYCamMtXfCw/2PnaPBOswPZvo9sqig=;
        b=ru8tup9NQ4fbtr8r4VVkusn7ZkPn6CWbWFNDTcYz8Bdlt+MADL0Zic5HRH7Ue7QTfY
         7Upv4fKS1u1OJFnvHzspMc6vAM41G3ulec8zTaWHdR/HCwdpMVd3Idzqi7zlgv25DBMZ
         kyX6vBB/VWvDggTOef6Uq5U7qTdDjf7OOras7VFD6XIUqz9swab4eBQzjuhAc+eZAJ8p
         b0jMI3ADq/qPIIpu/ppfyAuEzdeG05M4qkEMFPCfmpwtcVyeBaDYZzDYNR0qq3+AZnnm
         C7MOPjx1EynlvxVdi4Xm1/4kOqI9EQhpvb+aTqUf7LgBmJJK3xrPR8ifanTxEcz85RMo
         DsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oc7AsSC8FMlC5aYCamMtXfCw/2PnaPBOswPZvo9sqig=;
        b=MkNpkK124rIUxdiG46vWZxnB7Wv8VuwKepeU+ECPZESMKjhJMNLFKjj0G30uR5fq5v
         UQKQn7NzKMPzpWylZ5KfWxslOJ/kFOznEhyOJmPvXJ8b4FOF0o1UFCpVkIRHfQudYfgE
         KSiOJ/li/6HXhiBUnuc8KwT2DU8+W2+Eu52FG2KmKIftYaWeYAaYAKRdoVoJsKrMHDSE
         oWbFxLu2daAzerrADnLBbr0ouNLtFeiHrG+MvNGSmVRZwOXBiCHwPtrLtWZknjm/mfx8
         lI/ZRTagBf7Mv9l2Rvml5Ppp7YHZ4LrQ3x56lZQvUFFefBRbhdAFiK4fmjZ3REiaX/56
         z8PQ==
X-Gm-Message-State: AOAM530AzcOTztoG/8k+V+MGUUhGKdSLT+sXE8mUBGFcqMTU3FcRkzZA
        Em1VqWkwqo1wrmzjVTTbJCVU+A==
X-Google-Smtp-Source: ABdhPJwummIxPlevoZPgEzD5Bc40kmov5ywaH410V1XXkWZUnzaIabolbpjAFK1AKAQmcdMQS0eaYQ==
X-Received: by 2002:a9d:65d0:: with SMTP id z16mr4128805oth.196.1628786376403;
        Thu, 12 Aug 2021 09:39:36 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n5sm711377oij.56.2021.08.12.09.39.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:39:36 -0700 (PDT)
Subject: Re: [PATCH 3/6] bio: add allocation cache abstraction
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-4-axboe@kernel.dk> <YRVNCubDmQSUslSd@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <667e9fb6-d02f-a5c5-ff9e-f67af35ec1c5@kernel.dk>
Date:   Thu, 12 Aug 2021 10:39:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRVNCubDmQSUslSd@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 10:32 AM, Christoph Hellwig wrote:
> [adding Thomas for a cpu hotplug questions]
> 
>> +static void bio_alloc_cache_destroy(struct bio_set *bs)
>> +{
>> +	int cpu;
>> +
>> +	if (!bs->cache)
>> +		return;
>> +
>> +	preempt_disable();
>> +	cpuhp_state_remove_instance_nocalls(CPUHP_BIO_DEAD, &bs->cpuhp_dead);
>> +	for_each_possible_cpu(cpu) {
>> +		struct bio_alloc_cache *cache;
>> +
>> +		cache = per_cpu_ptr(bs->cache, cpu);
>> +		bio_alloc_cache_prune(cache, -1U);
>> +	}
>> +	preempt_enable();
> 
> If I understand the cpu hotplug state machine we should not get any new
> cpu down callbacks after cpuhp_state_remove_instance_nocalls returned,
> so what do we need the preempt disable here for?

I don't think we strictly need it. I can kill it.

>> +	/*
>> +	 * Hot un-plug notifier for the per-cpu cache, if used
>> +	 */
>> +	struct hlist_node cpuhp_dead;
> 
> Nit, even if we don't need the cpu up notifaction the node actually
> provides both.  So I'd reword the comment drop the _dead from the
> member name.

Right, but we only sign up for the down call.

-- 
Jens Axboe

