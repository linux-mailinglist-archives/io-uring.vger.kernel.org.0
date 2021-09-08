Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF298404029
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 22:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbhIHUXw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 16:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHUXw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 16:23:52 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B0DC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 13:22:43 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m9so5103991wrb.1
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 13:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4FWIygPmRvXKfyxZXPmgtP+8Iooyx5nQBsTDe3vteJY=;
        b=FmWlEy/vHJn6OkMP6kU4m8cf8eS7T2mBzRELWdGsWM8uqMeq46Jz3nXGGShHydxrhu
         DEZbsXlFJaaSLqQCSMjBYh1/3uNFU2Gs7YexJKcyTGtfjQcAQ5LE1f47PJPmLPGVdGhT
         /Oi15hV4zrTHQq1mpFQXbroAeEqnQOXMGzEEAU1TtqWDiPp/e5BposBtdS5WtZeGG721
         HAraAVhKBmOyHI10Dc2DHujeBSzrZNTgOKejg+UGhGuxsEn+Bh3BoKGuoAqwzTXzpTrI
         6IykGsuSItS8vCiV/pdYFHFpyPenrop5wnM+sRk1/7BIon+ysyxkXQa42UwxI2MW0Mi8
         I4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4FWIygPmRvXKfyxZXPmgtP+8Iooyx5nQBsTDe3vteJY=;
        b=wf1ipDaSr5tXDl1rQXu0i75TQPscRoJIo8iWCgWaTtbHLrIun2Hs6snpEe5bQGwqQV
         KcucGVAeamJbetqA0IsXMuAJ/8lcvwBGciLN6XSEmC/4uxB9ZYRcsU6pt6xRrGFn2yx6
         MV5edbSDsNZ/R0X4isSAFti+X/0duF3wm5oIoOK+YfhTgih11BVtMExbdRZf+hkpL+mf
         0rDl/CVUe4j12xXOLbBLRGFWs0T2s5CF5w8SVOusgapqyKGF9L9FJLA21PR42XrgTjTw
         whX7eSfgomv+hISuy74spRCR0zCTF4hYDlf4FqpfkDYCiUGO3H1R2Y7Rb/6jNRIP4CqB
         TE3A==
X-Gm-Message-State: AOAM530Pjcrr4IDxgWiwDn4O8hC/8Yfc16csACGcOUw2RuViu/SrnY3x
        LhyXdxVRJ+yL0Oy9Ol5tVbNHZNqChTI=
X-Google-Smtp-Source: ABdhPJykbntI8zzGqRv0B4zoLLa9PTZ9oX8YJT2c690mQOzoNIkbRKS/8tlfKnwFSSSBHDFAHk80uw==
X-Received: by 2002:adf:f101:: with SMTP id r1mr106258wro.355.1631132562358;
        Wed, 08 Sep 2021 13:22:42 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id z1sm2937506wmi.34.2021.09.08.13.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 13:22:42 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix missing mb() before waitqueue_active
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
 <bd0b0727-d0ac-7f2a-323d-39411edbe45d@kernel.dk>
 <34219094-7e90-a665-2998-4658f3becdff@gmail.com>
 <8d2a7c4e-67d3-681b-bf54-f0409cff672f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c6fa008c-2705-90cf-b3ff-31b9b58e323b@gmail.com>
Date:   Wed, 8 Sep 2021 21:22:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8d2a7c4e-67d3-681b-bf54-f0409cff672f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 9:15 PM, Jens Axboe wrote:
> On 9/8/21 2:09 PM, Pavel Begunkov wrote:
>> On 9/8/21 8:57 PM, Jens Axboe wrote:
>>> On 9/8/21 1:49 PM, Pavel Begunkov wrote:
>>>> In case of !SQPOLL, io_cqring_ev_posted_iopoll() doesn't provide a
>>>> memory barrier required by waitqueue_active(&ctx->poll_wait). There is
>>>> a wq_has_sleeper(), which does smb_mb() inside, but it's called only for
>>>> SQPOLL.
>>>
>>> We can probably get rid of the need to even do so by having the slow
>>> path (eg someone waiting on cq_wait or poll_wait) a bit more expensive,
>>> but this should do for now.
>>
>> You have probably seen smp_mb__after_spin_unlock() trick [1], easy way
>> to get rid of it for !IOPOLL. Haven't figured it out for IOPOLL, though
>>
>> [1] https://github.com/isilence/linux/commit/bb391b10d0555ba2d55aa8ee0a08dff8701a6a57
> 
> We can just synchronize the poll_wait() with a spinlock. It's kind of silly,
> and it's especially silly since I bet nobody does poll(2) on the ring fd for
> IOPOLL, but...

fwiw, for the ebpf cat ev_posted() -> smb_mb() for taking ~3-5%.
And there are non-bpf cases that may benefit from it.

On my list to publish a refined version of the patch.  

-- 
Pavel Begunkov
