Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC42397750
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 17:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFAQAQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 12:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhFAQAP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 12:00:15 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F6BC061574;
        Tue,  1 Jun 2021 08:58:33 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z8so9787956wrp.12;
        Tue, 01 Jun 2021 08:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BrgqyCEt8bgKgbuweog7fGLbyNRK5WZlLkrdHFGteoY=;
        b=tk1vS40M/iuFNpl2m3N4uP1bYv4WBYNe/nMHv6sfeV9UeISzXkXN1TGSPq6QX7GWR7
         XAhrXJx8cL6ynZ/2UuDUkAUL9I00Z5fCiVCY/3+XElDdpTTEtsiw6ANzWWUad0FIH7o7
         M3PQfU1/OlClSK6ZgQpVWITRk8dIL8oEKeaYvu2aVAMr4bZVFLbd7qUt3yHP6b0sWcgO
         Fmv+HVRn++na14GA8TqOgFwuqvoow1FEOruxZ5zHB6Q5POebetg+sE+pLO6TjheVgbRg
         cxGJgbHXHCyzuji5kBZFVd/h8jn6H0PPqcrVY+AXfpgt/mOKT3IrmAIEIxpSkmkilcoP
         efUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BrgqyCEt8bgKgbuweog7fGLbyNRK5WZlLkrdHFGteoY=;
        b=sK6XafMmnqoTnET7IP6ERn5+Y9TR3xgtAY3CJeWWSLh3ai90IhhDBaliP84CJ4QUP2
         +Jbu22P2evuZcIibFHKuWwL1BaBdTUm9BoxAXV744b9dV/u4efN1uPNhu/LfblGEJuG9
         tg4AKDzn/DpDrQEvlo6fuYhrlthc5uIOZO3y60LE/uQTiq5PRK3CmB1+43FSt0s3CgUS
         ummsK71r0Tu4KSgIhLwle4147Oc/MfVXCW4S/PJEKQEx+S+7rtV8TeDbFUtGYgCzfFjT
         W1yhhOfMZz2c4F625jPs05dbLBPjj3YB6xG3bPBXWM//YO1JZDv12RQWd0S+sLckSCyd
         qf/Q==
X-Gm-Message-State: AOAM531nOkUpwkguXmR8FE7BmatmSpx2WSmhp2bCWEg/Lu0eoV9B5trA
        612GI8pVh+/mZILdq8+LDdgSjuPSdg9KMw==
X-Google-Smtp-Source: ABdhPJw2AN3Yjjm2+FQnelUHEMloiXSFvgf1nviGdM3vWhPjxkM3I92u+O75pTIeszCKWANXtP1j2Q==
X-Received: by 2002:a5d:68ca:: with SMTP id p10mr4557011wrw.65.1622563111576;
        Tue, 01 Jun 2021 08:58:31 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.139])
        by smtp.gmail.com with ESMTPSA id a4sm18779928wme.45.2021.06.01.08.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 08:58:31 -0700 (PDT)
Subject: Re: [RFC 4/4] io_uring: implement futex wait
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
Date:   Tue, 1 Jun 2021 16:58:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/21 4:45 PM, Jens Axboe wrote:
> On 6/1/21 8:58 AM, Pavel Begunkov wrote:
>> Add futex wait requests, those always go through io-wq for simplicity.
> 
> Not a huge fan of that, I think this should tap into the waitqueue
> instead and just rely on the wakeup callback to trigger the event. That
> would be a lot more efficient than punting to io-wq, both in terms of
> latency on trigger, but also for efficiency if the app is waiting on a
> lot of futexes.

Yes, that would be preferable, but looks futexes don't use
waitqueues but some manual enqueuing into a plist_node, see
futex_wait_queue_me() or mark_wake_futex().
Did I miss it somewhere?

-- 
Pavel Begunkov
