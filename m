Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FE239B896
	for <lists+io-uring@lfdr.de>; Fri,  4 Jun 2021 13:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhFDMA0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Jun 2021 08:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhFDMAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Jun 2021 08:00:25 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC71C06174A;
        Fri,  4 Jun 2021 04:58:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ci15so14048460ejc.10;
        Fri, 04 Jun 2021 04:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1Fe/Z05xnT6BVBzZXbmdjpF8j14Qb2X3kcylmlP9s+Q=;
        b=upH2hIZYKlzGo8WteDWe1N5VTdxdzid7tno4FMRUvgbVLRjueopoHTxo8BnzYHsCkx
         OWH5FMp2rGp4RP9WLuaDkHCmjGRkkde3hANXa0Tid7DY/Zciq9e2bZ2M/gbpAl1uG4ET
         y5ikLI8YRbQaPFS/zpqs+e92xmwibq/8mXRK6q9XPQmHOTryc8Fy+AuwjdHwK8dXlbD+
         ii+zoDgdZdZ+V5Od3MDD/RGizsvkiPKmckq9SUa0rYLtgWdZtf6NI582GanVarodVfgT
         V2QKjwu3tNOJ9uAZ9NprCAIX0pLpC2zF1cS4j96xkboaN0zhYbL+UT5rIgLhfVdfrtRd
         tlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Fe/Z05xnT6BVBzZXbmdjpF8j14Qb2X3kcylmlP9s+Q=;
        b=uebx0nARO3WxegwAtthT4yCmCjfvcAkvZxE41/mLjIx3PmZRCfNtTeFqiQ3ZIVFi5x
         jNzxjaP6fr6nr9rJ9rj7Ki6Ylt4kE0ELP8lMDkHey4FuKIV3TlMnhiqfE6+J4jAgwvsD
         PStNucvLFyvgaQj1vDDGzqv+nane7kYUa/P+PDbt4oyxtCa7tVvx9uWNyf5PllGdrM91
         +m8MCtftvZPODGjfWb38P2+ZQl7U8xkyQjqnn37DMsO9zrpGu2T2VdTy0Ooyf8MBviLU
         XKtdYZ0esJ1HayOrhE6Xk60/pDk55YC2Cyu+95umuVXK4udjIdog+Uvoel8ivgPLKwIo
         me5g==
X-Gm-Message-State: AOAM530nTBX1jhtCfb4IpAHJSe5eeViJAWO1/Ug+eXjKjubABDiYZIxl
        vi/Cbu5b7p02LIUNA33XTEelTTcOlGNhmRUn
X-Google-Smtp-Source: ABdhPJxlXWybseV7Sq6ZkmQqWIVLAAB+K7aA7L1pVfKSrtl7v6M60jozZe+oAz6kBAvzuq1kGm16Jw==
X-Received: by 2002:a17:906:4e06:: with SMTP id z6mr3957363eju.34.1622807914396;
        Fri, 04 Jun 2021 04:58:34 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:b808])
        by smtp.gmail.com with ESMTPSA id i5sm3122648edt.11.2021.06.04.04.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 04:58:34 -0700 (PDT)
To:     Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
 <30bdf12c-6287-4c13-920c-bb5cc6ac02bf@gmail.com>
 <87k0nayojy.ffs@nanos.tec.linutronix.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <aba00834-2e1c-f8cf-e2ab-f13303eac562@gmail.com>
Date:   Fri, 4 Jun 2021 12:58:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87k0nayojy.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/21 10:19 AM, Thomas Gleixner wrote:
> Pavel,
> 
> On Thu, Jun 03 2021 at 11:31, Pavel Begunkov wrote:
>> On 6/1/21 10:53 PM, Thomas Gleixner wrote:
>>> 1) The proposed solution: I can't figure out from the changelogs or the
>>>    cover letter what kind of problems it solves and what the exact
>>>    semantics are. If you ever consider to submit futex patches, may I
>>>    recommend to study Documentation/process and get some inspiration
>>>    from git-log?
>>
>> I'm sorry you're incapable of grasping ideas quick, but may we
>> stop this stupid galling and switch to a more productive way of
>> speaking?
> 
> which you just achieved by telling me I'm too stupid to understand your
> brilliant idea. Great start for a productive discussion. Try again.

Exactly why there was "we". I have my share of annoyance, which I would
readily put aside if that saves me time. And that's the suggestion
made

-- 
Pavel Begunkov
