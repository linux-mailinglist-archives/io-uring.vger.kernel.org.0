Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D6B2D3791
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 01:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgLIAZa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 19:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731835AbgLIAZZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 19:25:25 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2D6C0613D6
        for <io-uring@vger.kernel.org>; Tue,  8 Dec 2020 16:24:45 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id y8so3461plp.8
        for <io-uring@vger.kernel.org>; Tue, 08 Dec 2020 16:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MujwOIHdtlSw9762ofac2yZhovLN14Xu9TYPnibJ8F8=;
        b=y+3C9PJL/emg+lp2RMCuKafREITh+woR4+68+3a9s53B9dqRQuJNoyxLQiDPoTxAR9
         6+g7egNB4qwJdFVapJwmanyqGIx0IdZGT6dJB14RnLVW7aj2UkeGQ/8vh2sutjzxM8HI
         C2SE6NFJDZKb8YQzA38P6B5OtCDrwOrwPmgJOamyHdLEqVPcw9XOOesVovHGdPE8tMUR
         XNRo8iWD7BMZV/qbs3aihShCEkLmHyauDdPjKmflMzFiNVTZSp5J6BSDId3vQwHmWjE+
         AHhPJNdPZsiDqAMyorWgfZ1P1bn3CTtvzUWwAN7w/VGIgIoGiw46HQzy8WEyZDv4YSmA
         ytpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MujwOIHdtlSw9762ofac2yZhovLN14Xu9TYPnibJ8F8=;
        b=FO8vKNRjIyTcL8e1op2tLxEZIR4dTeEO8fbSGE7E8sf7DUhBEZK07NVDngR4hvMTlZ
         nuaooGsGkdxmJIHlPOlkGQsBVPNYUigW2o17xCPs4/pTYF0ii9JA/kaqGcmJZFf63WeN
         xqSARhVqdHg8JGReh1kqQs5XjC/d+PRD4SVDVN+BdIF1+rm86yWI6G4qLq+WNBNCBD/9
         HI+KwuYKaO3IkkupyAecXPwcZIELV4Czdyk9McVO8liLg7xgsDbAD578kirsPP6ePGIn
         it3ZjiJGpNya1pKLa1zojN/52IP+RjvyfVvnv/C+cuNYk8hgP8tFy28x/o5sO3k3gadR
         3F8g==
X-Gm-Message-State: AOAM533sSm27jseIbYiPkLqgBkhaBVW02WDKLhFItVm9iM/CfOEmcnD6
        2a2W4lS0NrekVO22rlQMblomcVMiF5XLmQ==
X-Google-Smtp-Source: ABdhPJzmXLxamAZBOqQKzzeZYgx+br4JVJXoIgpx4huEmEOY0hN0h/dwZPNg6ndZpbspqWiozEWOMg==
X-Received: by 2002:a17:902:a711:b029:da:f065:1315 with SMTP id w17-20020a170902a711b02900daf0651315mr444979plq.36.1607473484868;
        Tue, 08 Dec 2020 16:24:44 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u7sm14454pjj.56.2020.12.08.16.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 16:24:44 -0800 (PST)
Subject: Re: [PATCH liburing] rem_buf/test: inital testing for
 OP_REMOVE_BUFFERS
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0de486be33eba2da333ac83efb33a7349344551e.1607464425.git.asml.silence@gmail.com>
 <08387f60-d2fe-1396-aa15-ae9b759efa57@kernel.dk>
 <e37a27d8-bbba-cc46-9acd-5773a25aec12@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aea434f0-3e9d-f404-365d-14ecedfdd8df@kernel.dk>
Date:   Tue, 8 Dec 2020 17:24:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e37a27d8-bbba-cc46-9acd-5773a25aec12@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/20 3:59 PM, Pavel Begunkov wrote:
> On 08/12/2020 22:42, Jens Axboe wrote:
>> On 12/8/20 2:57 PM, Pavel Begunkov wrote:
>>> Basic testing for IORING_OP_REMOVE_BUFFERS. test_rem_buf(IOSQE_ASYNC)
>>> should check that it's doing locking right when punted async.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>
>>> NOTICE:
>>> test_rem_buf(IOSQE_ASYNC) hangs with 5.10
>>> because of double io_ring_submit_lock(). One of the iopoll patches
>>> for 5.11 fixes that.
>>
>> Let's get just that into 5.10, and then we can fix up 5.11 around that.
> 
> If you mean get that kernel patch, then it's the one I commented on
> yesterday.
> [2/5] io_uring: fix racy IOPOLL completion

Right, of course...

> Either can split this test

Nah, that's fine. I'll get it applied, thanks.

-- 
Jens Axboe

