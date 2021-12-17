Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16034794F6
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 20:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhLQTlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 14:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235528AbhLQTlW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 14:41:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512E2C061574
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:41:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b7so11883811edd.6
        for <io-uring@vger.kernel.org>; Fri, 17 Dec 2021 11:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=rFbj3c0H5yGzinnQO9uFzM2verJUS0A1aKKy4287mq0=;
        b=M6DVkap/e3ixcKOAEphm6esa2VHm0Dz8uJpHgWmQwaSNoa7ddXpbaM8rbUo5/Acwl1
         drfTHNfs/26+lWIbpYgSpBKYC6VHnHEEn9McdxfEm9ImuBoNv2NDs6AhhPW+w70l61Jt
         rJrygOJCW9MLQrgHE7DZuE6kZksgx8nmFfB0jeeHkgU8Rwa9USbNkrIVYrjTBV0pd7f3
         J0xa2/99n2TruBFD7k1sFwj58L5eMBPRkxHCg2Qee5qzm8VhU7nJzeXB+35fbp3U/Ab8
         7nnIYosp/qS8AWj7jqQviOl1Y2teYY9N8J5/inttFwUUdzvH1BeSPdLx98kNLXDlpdsl
         EG/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rFbj3c0H5yGzinnQO9uFzM2verJUS0A1aKKy4287mq0=;
        b=UhBWUb9CEG7m0Yf2ULK4l3QvLvwUGS3rB+O14KUA3GH1fDahA3vMQ2sPM1jm9ko7Kl
         Hc94WaRrRlBufz7WifvnvkRBpoR0aLXqhewJc16s1cTX1CnHiA4cmrlzm/zcQ26lJU20
         KStAO8mG6UDv7n9ylQTr7lrLfGdfk+qIfK5PTcbMMkO9+uPikpH3Rdh0cOWFU6Upy4fl
         ug0NSJFc/46q8api2Txr4lHrGK8ADfFrFCBBtzDroQUN21tEgWbIpEAT3DX0TemWCqzn
         pJlCZqHLci8Ua+MrFb/8R61w0YZlv5qoP4VFwBtlpOAbDUvn2GPwjbgXtCcvb0G+noa6
         /9gw==
X-Gm-Message-State: AOAM533EVEnGlMRMMtFxELy290TY92Ixl70wWSGcBxQYiyqmlzUbINZV
        uMHTEDmcyyr8BivtOWQT1iHNLtGj/80=
X-Google-Smtp-Source: ABdhPJzfuA61gCB6q3Dltn7aSrwV+x9mDEys1T55XapncZ+bN6+nJctFlBJcGsqOO0LlujrfA6iedQ==
X-Received: by 2002:a17:907:3e12:: with SMTP id hp18mr1167285ejc.576.1639770080875;
        Fri, 17 Dec 2021 11:41:20 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.117])
        by smtp.gmail.com with ESMTPSA id lv19sm3093126ejb.54.2021.12.17.11.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Dec 2021 11:41:20 -0800 (PST)
Message-ID: <93fb5cc6-ef72-6782-6311-b1b0b866bc23@gmail.com>
Date:   Fri, 17 Dec 2021 19:40:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH for-next 0/7] reworking io_uring's poll and internal poll
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
References: <cover.1639605189.git.asml.silence@gmail.com>
 <ca8515c2-649d-21d9-f646-50ed37eabc32@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ca8515c2-649d-21d9-f646-50ed37eabc32@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/21 15:02, Hao Xu wrote:
> 在 2021/12/16 上午6:08, Pavel Begunkov 写道:
>> That's mostly a bug fixing set, some of the problems are listed in 5/7.
>> The main part is 5/7, which is bulky but at this point it's hard (if
>> possible) to do anything without breaking a dozen of things on the
>> way, so I consider it necessary evil.
>> It also addresses one of two problems brought up by Eric Biggers
>> for aio, specifically poll rewait. There is no poll-free support yet.
>>
>> As a side effect it also changes performance characteristics, adding
>> extra atomics but removing io_kiocb referencing, improving rewait, etc.
>> There are also drafts on optimising locking needed for hashing, those
>> will go later.
> Great, seems now we can have per node bit lock for hash list.

Yeah, might be. One idea is to put it under mutex_lock. Interesting
what kind of performance difference it'd make, e.g. [1] but would need
some combined approach. Also was thinking for getting rid of hashing at
all for polling fixed files, may be promising, but would need some extra
bits for fixed files removal.

[1] https://github.com/isilence/linux/commit/5613ffd53141df98ae4a4a75b043b4d7ad252b2b


>> Performance measurements is a TODO, but the main goal lies in
>> correctness and maintainability.
>>
>> Pavel Begunkov (7):
>>    io_uring: remove double poll on poll update
>>    io_uring: refactor poll update
>>    io_uring: move common poll bits
>>    io_uring: kill poll linking optimisation
>>    io_uring: poll rework
>>    io_uring: single shot poll removal optimisation
>>    io_uring: use completion batching for poll rem/upd
>>
>>   fs/io_uring.c | 649 ++++++++++++++++++++++----------------------------
>>   1 file changed, 287 insertions(+), 362 deletions(-)
>>

-- 
Pavel Begunkov
