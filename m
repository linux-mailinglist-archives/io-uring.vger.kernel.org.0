Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B244247CCF
	for <lists+io-uring@lfdr.de>; Tue, 18 Aug 2020 05:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgHRD3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 23:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbgHRD3f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 23:29:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D31C061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 20:29:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e4so8786157pjd.0
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 20:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EDxT4by8gEN3/XoYC2go+zlPlqRW2YlisoqZDUEqkSk=;
        b=BT5nU3xeeXpZMCEOo//dfeSCqa7kcfE3tLNpAO963pKa6zgPojUopJfZ9ww3Z8fi60
         aZFeefd4Ne8rzJESwm8zB61rxdC9uLm+Y6HhBL63JNxStmg76IKVk9zmWlrQuowmx2eB
         EnhnGmohhU3TIrs2riugJSo/V66GJkBMWYaaQ5WGZljJQeSqfv2l029sSM3sif+smNfC
         mp3uPGn64/RHoTqXNSAdyceVBFHP5f8xuNc/MLUpFEiPAMyIURfsIwRz/qarH5dk9xuU
         Qa8XH4lN43g1oLEK5rsC6Frd/XFSnjcOo70qeNeBR1kSgIae/qQszqNc1mUbaLGivSUj
         qbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EDxT4by8gEN3/XoYC2go+zlPlqRW2YlisoqZDUEqkSk=;
        b=tGwC5uOfWS5dgTSIAzJy2MeYgbyWI73xVn/45fjiUcYYKlqFk708AHSPi+TMc8IbY7
         JH2Cs/UVlG36sXHrQerdapYTr5nk4XV7zLZkKAkKKToODwMJi+UBqgNa8XxYCKS9l54u
         +VB5p2OKqDt3XwVnMn15BSQY1YVRiEXBrqhjowdQSE3w8GDOPWJ5KaqlSZnqAijVUa1r
         FfqvBcT6ZcCAh5dalKexvROqVPVaClUWBDb2oWlOLw7MztqAsFaire+xnzZQ444ScClW
         FqB5tbg6b+W3nFGHuk8qixEBcc9Ryuqcpa5Z9M2RcIUG5ErvPJw/VAah8EKEXnOwnNOa
         lpqA==
X-Gm-Message-State: AOAM530fXKaIdWGfX0OgtFVw06ZplDMDypxpCb29sNfDFUYzhpmzSlUH
        hz37PVsB77/WbI/IN/d+8FCIRlls+vcv2U5Or3E=
X-Google-Smtp-Source: ABdhPJwCymnJWHUtP56kCuipD+MXR16UNEa0vtJaqYHTpUodJqfvJTxGT0pukwQzkbJbIGc4s7SOFQ==
X-Received: by 2002:a17:90a:77c9:: with SMTP id e9mr14724729pjs.142.1597721374555;
        Mon, 17 Aug 2020 20:29:34 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:cef9:e56c:5fb2:d956? ([2605:e000:100e:8c61:cef9:e56c:5fb2:d956])
        by smtp.gmail.com with ESMTPSA id 74sm21214417pfv.191.2020.08.17.20.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 20:29:33 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     david@fromorbit.com, jmoyer@redhat.com
References: <20200814195449.533153-1-axboe@kernel.dk>
 <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
Date:   Mon, 17 Aug 2020 20:29:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/20 2:25 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Since we've had a few cases of applications not dealing with this
>> appopriately, I believe the safest course of action is to ensure that
>> we don't return short reads when we really don't have to.
>>
>> The first patch is just a prep patch that retains iov_iter state over
>> retries, while the second one actually enables just doing retries if
>> we get a short read back.
>>
>> This passes all my testing, both liburing regression tests but also
>> tests that explicitly trigger internal short reads and hence retry
>> based on current state. No short reads are passed back to the
>> application.
> 
> Thanks! I was going to ask about exactly that :-)
> 
> It wasn't clear why returning short reads were justified by resulting
> in better performance... As it means the application needs to do
> a lot more work and syscalls.

It mostly boils down to figuring out a good way to do it. With the
task_work based retry, the async buffered reads, we're almost there and
the prep patch adds the last remaining bits to retain the iov_iter state
across issues.

> Will this be backported?

I can, but not really in an efficient manner. It depends on the async
buffered work to make progress, and the task_work handling retry. The
latter means it's 5.7+, while the former is only in 5.9+...

We can make it work for earlier kernels by just using the thread offload
for that, and that may be worth doing. That would enable it in
5.7-stable and 5.8-stable. For that, you just need these two patches.
Patch 1 would work as-is, while patch 2 would need a small bit of
massaging since io_read() doesn't have the retry parts.

I'll give it a whirl just out of curiosity, then we can debate it after
that.

-- 
Jens Axboe

