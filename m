Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38206386DAB
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 01:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhEQXdj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 19:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhEQXdi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 19:33:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ABEC061573
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 16:32:20 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j14so6375591wrq.5
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 16:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2mfPNuyYArm2UpCJpCqdDydBSMv8gtiKbAnIjWiVGtI=;
        b=nDsRvU217tTV4rpsAMzk4EGY2xi8+dXkVTTXDpEn4fHRsFpQGOOXGXXk406DRWV7D+
         MnjcXW5EIgogVc8BAZtF2+en5fEvMlofcb73LE0MIqBOxnqmSfOB7ZPKQxierdls3hG9
         VMnuAxkd2urmnJlIltnJnjzdaFvFL+a+4IeIZ4rAGSolNKLN9Mk6rMuGCWb1r+FhyAgh
         +AbYI626zuioIQEwwBJRkLT+dJl2haP+ucE2S70WkQFjDXPLwG5SP3vd3tZ0BSZs8OV6
         Qz8hQQt6UULsK48CG0Lb8qDbyHCstSQErYUep447eJ+oLEWSyXyXHoEnlB53UozIaPGM
         pLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2mfPNuyYArm2UpCJpCqdDydBSMv8gtiKbAnIjWiVGtI=;
        b=PUM7Fw55REfXMr51PuT7nfXKm45r91gdxnMi+DYwa82DENsk5s+4NrO6VH/41dZexK
         jcboxhUCWxoGZGiVPHvkFhgcAqKYkt/T20K6JMHVPqFW55cOyB/bvrSQO7Jjpb9PpiGs
         9n3e7tZ8hryr0ADVY0dzOmFu73RW0H8BTtwlpXCB22o7j9wh4SBumZ4MSKSjVW7X/UVK
         yrP0OaeifMPVvs9c6r4Vzpd6HkjUPGcj5wGKoIU7bzxAx6d/eJkCp1NgpMytkcZ5A5hW
         WrfMzyPgw4JG94NmyfaVLEoL0cUg5xex5RqrPuXzHfePMqUgK2jjS6tAjibup/ajVzHE
         0hKQ==
X-Gm-Message-State: AOAM532hj6M6pKVdoWvQX2KK81Trczk/5HhPxEPCUZ7NEMDJAtFRlAvy
        J5Z9fc8IfalTYt9iNxkrZ3U=
X-Google-Smtp-Source: ABdhPJwc6/7Z0BMJdU8zpIBEIXupCORvNUzll8OQNqRaEgFdK8wCtiOip6CYfn6v1R9bqBcrC59odg==
X-Received: by 2002:adf:edc9:: with SMTP id v9mr879765wro.103.1621294339248;
        Mon, 17 May 2021 16:32:19 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.8])
        by smtp.gmail.com with ESMTPSA id k132sm169306wma.34.2021.05.17.16.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 16:32:18 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add IORING_FEAT_FILES_SKIP feature flag
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
Cc:     noah <goldstein.w.n@gmail.com>, Jens Axboe <axboe@kernel.dk>
References: <20210517192253.23313-1-sir@cmpwn.com>
 <b836b9cd-e91b-7e46-ce29-8f32e24fb6ab@gmail.com>
 <CBFWQ64F7PWU.3EOQ3BQXFHZY7@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <7f2c075d-bf3a-7101-23ac-ef63eecb70cd@gmail.com>
Date:   Tue, 18 May 2021 00:32:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CBFWQ64F7PWU.3EOQ3BQXFHZY7@taiga>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/21 12:25 AM, Drew DeVault wrote:
> On Mon May 17, 2021 at 7:19 PM EDT, Pavel Begunkov wrote:
>> On 5/17/21 8:22 PM, Drew DeVault wrote:
>>> This signals that the kernel supports IORING_REGISTER_FILES_SKIP.
>>
>> #define IORING_FEAT_FILES_SKIP IORING_FEAT_NATIVE_WORKERS
>>
>> Maybe even solely in liburing. Any reason to have them separately?
>> We keep compatibility anyway
> 
> What is the relationship between IORING_FEAT_NATIVE_WORKERS and
> IORING_REGISTER_FILES_SKIP? Actually, what is NATIVE_WORKERS? The
> documentation is sparse on this detail.

They are not related by both came in 5.12, so if you have one
you have another

-- 
Pavel Begunkov
