Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1981C3767BE
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhEGPOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 11:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhEGPOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 11:14:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2E6C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 08:13:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x5so9625392wrv.13
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 08:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dH+5B7dIsW2rHaoba+sp5VeAa7e7Jnz+lfFJx7PR/rI=;
        b=lCZms3fFNkGAEAY+rGrVm5XXOQ+sNrAZNEItVcnyc04XAwYErrLIubTxtAtYnj5OWc
         43JNu0qzZpHomjj30aWG1bF5mPqbZibnvaCZxG14WA8qEVzkkqUP66rS+4mBrpbdxgvm
         3C03S56VnaYGvIgPK77h8qmeD/BiGReXXTxOXyQpjHZINBAlQQlJwEvyRaBf4BjJyjhe
         dLCZ7r6i0sCh59SUSAZ5g/PvIh59abzqn0g8lOOeuLpvDpZ+7CSIq0yY4KohVQ7bm1zF
         8pLfOxqoFgo5EPASmC+rzdoW060XJEoJhpRzgjRzKnW1xZl51HuTy6p8FFTXo8QwOmR4
         Xspw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dH+5B7dIsW2rHaoba+sp5VeAa7e7Jnz+lfFJx7PR/rI=;
        b=Vy4Ab4p+l+c3tGmnPTisTQCQugIUqkCzM9ijdQtvQi111WQ78HKEo6MBEzVSyrmHlf
         1LvsDfqraPIH3qSEiFGsMumuTxnqz4qN3+EOOQuI1ciL5KM2IaYLN5cI3eB9qJF3IaN0
         88iq2GwrQk+aa0tU8DRBFwePeCJS1Ti2tI5OgQZS5qcxTwsIIzz9aOjPN6xN4lPFyeJV
         vXBPfee2rjqGBOg1UpnNWLvDYBmgRR5bk9wZU5L4UQ/8ZhwbmYBGk/tJbV+OFRIFiWXB
         AJvVN2mduMrJxzsNpUl91uzBukzZtoSqKnIfLCOEQ3YeycgZkuTlCrC/yMxWcvUR8Gun
         lUhw==
X-Gm-Message-State: AOAM533w4ZTIrM/3bEzl8+1IODo7sh1Ptnb37oF19/8OHiwccStpSbE+
        XXKSDE0uRNP1T4+qC4vJLr8=
X-Google-Smtp-Source: ABdhPJxnGU0dBr7f4q46lvGXPNQ03d0TCyrATdDol+BktJAASHVO6t+g5DKz+hZUE50aAaWZzDZnhg==
X-Received: by 2002:a5d:4351:: with SMTP id u17mr12781661wrr.47.1620400421252;
        Fri, 07 May 2021 08:13:41 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id j13sm10312825wrd.81.2021.05.07.08.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 08:13:40 -0700 (PDT)
Subject: Re: [RFC] Programming model for io_uring + eBPF
To:     Christian Dietrich <stettberger@dokucode.de>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
 <s7bv985te4l.fsf@dokucode.de>
 <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
 <s7bpmy5pcc3.fsf@dokucode.de> <s7bbl9pp39g.fsf@dokucode.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c45d633e-1278-1dcb-0d59-f0886abc3e60@gmail.com>
Date:   Fri, 7 May 2021 16:13:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <s7bbl9pp39g.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 5:13 PM, Christian Dietrich wrote:
> Christian Dietrich <stettberger@dokucode.de> [05. May 2021]:
> 
>> So perhaps, we would do something like
>>
>>     // alloc 3 groups
>>     io_uring_register(fd, REGISTER_SYNCHRONIZATION_GROUPS, 3);
>>
>>     // submit a synchronized SQE
>>     sqe->flags |= IOSQE_SYNCHRONIZE;
>>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.
>>
>> When looking at this, this could generally be a nice feature to have
>> with SQEs, or? Hereby, the user could insert all of his SQEs and they
>> would run sequentially. In contrast to SQE linking, the order of SQEs
>> would not be determined, which might be beneficial at some point.
> 
> I was thinking further about this statement: "Performing (optional)
> serialization of eBPF-SQEs is similar to SQE linking".
> 
> If we would want to implement the above interface of synchronization
> groups, it could be done without taking locks but by fixing the
> execution order at submit time. Thereby, synchronization groups would
> become a form of "implicit SQE linking".
> 
> The following SQE would become: Append this SQE to the SQE-link chain
> with the name '1'. If the link chain has completed, start a new one.
> Thereby, the user could add an SQE to an existing link chain, even other
> SQEs are already submitted.
> 
>>     sqe->flags |= IOSQE_SYNCHRONIZE;
>>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.
> 
> Implementation wise, we would hold a pointer to the last element of the
> implicitly generated link chain.
Such things go really horribly with performant APIs as io_uring, even
if not used. Just see IOSQE_IO_DRAIN, it maybe almost never used but
still in the hot path.

-- 
Pavel Begunkov
