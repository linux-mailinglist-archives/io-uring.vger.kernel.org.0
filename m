Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238E716AF49
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXShg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:37:36 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37834 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXShg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:37:36 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so8578981iln.4
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ikBiZrAZLcx4S9G53XDFvn0tt1Mc5B0VIwsnfRsYTQM=;
        b=c5vc4FCZM+v/RjwFhcrRVTLoDQyRt/y9f/ogreM+e4R8lhugBCpf7XKzNPR+EiAyHF
         ofiVrgBXVm+8xrREoNdc3ipPbreB2XdGPq13Jtlzz/uT9jESpPIEabJfqRkixARMNQvp
         7BndkSt/LwClqV3y461xmtjO19PfqSkU2w5j4mAZtyIG0LjRagsQ6sKgPx4b/YjEpgZB
         epgPvCMcpaASTuYTkZ3z6KdijvatRthhDd18kTub4rQWz97xHSROC5oX3Qf8DEGwDSXU
         nyUvNNeig2cXUh62MfW7iPGhEt2U2XNY1qrk9RycZsJPJ57iQCmZ6Xm0+wh9sVz0YH1x
         4Ktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ikBiZrAZLcx4S9G53XDFvn0tt1Mc5B0VIwsnfRsYTQM=;
        b=DjnUIC2KBAemNzIEtI1ymt6plZtuui2b0oEbfyXwWgzExYqsmbfSBM+fjKHVnd1GDv
         nzCWCu8KuInpbCC3MxqJQt7VRc919NJ7E/3IXjgVe05U2SC6yR4mSjP3CQe/WmsgiBSe
         gU0bB26QB8g7zt1MWzj1rDMbqYbq+hQ9U9rUFNP/kJrpurQqgsjqSanGBgjyQYVGxsR6
         zDaeLUcYdwEtDkStAXVpvKY+paxixF14GnNpPo+FWCA4QNgNsQTypr2ecr7oNlEmE8vK
         iLdsvQRrNguuWEBfDpTTGifhVNQgH4fOEQqgkrHjR/v6u4+4plrfXjJ6ahbPhtV8gpEM
         7Dpg==
X-Gm-Message-State: APjAAAU2o1jUP1ZZJXBXRjpRolKoiUEJCDb6zWllLCMFEOktD+mR0Jno
        EhOF1eNfdjt1lIIJARn60ntuVzZHbsM=
X-Google-Smtp-Source: APXvYqxCobPfUdbMsY0Fj1jkA8/KXeh6XqelzM62Xa6n7d2hH/OttpPnwVqqulp3lH8/pAIaCxM6OQ==
X-Received: by 2002:a92:911b:: with SMTP id t27mr58957460ild.142.1582569454190;
        Mon, 24 Feb 2020 10:37:34 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n5sm4582757ili.28.2020.02.24.10.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:37:33 -0800 (PST)
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
 <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
 <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
 <abe952ad-54d8-1d18-7fe6-6a7f1666b7e0@kernel.dk>
 <e11dbcc8-3986-73cd-3cc8-289adf87f520@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82bf89d6-7ce2-069e-ccf7-a2b95fe78dce@kernel.dk>
Date:   Mon, 24 Feb 2020 11:37:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e11dbcc8-3986-73cd-3cc8-289adf87f520@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 11:33 AM, Pavel Begunkov wrote:
> On 24/02/2020 21:16, Jens Axboe wrote:
>> On 2/24/20 8:40 AM, Pavel Begunkov wrote:
>>> On 24/02/2020 18:27, Jens Axboe wrote:
>>>> On 2/24/20 2:15 AM, Pavel Begunkov wrote:
>>>>> It seems no opcode may return -EAGAIN for non-blocking case and expect
>>>>> to be reissued. Remove retry code from io_wq_submit_work().
>>>>
>>>> There's actually a comment right there on how that's possible :-)
>>>
>>> Yeah, I saw it and understand the motive, and how it may happen, but can't
>>> find a line, which can actually return -EAGAIN. Could you please point to an
>>> example?
>>
>> Just give it a whirl, should be easy to reproduce if you just do:
>>
>> # echo 2 > /sys/block/nvme0n1/queue/nr_requests
>> # fio/t/io_uring /dev/nvme0n1
>>
>> or something like that. It's propagated from the kiocb endio handler,
>> through, req->result at the bottom of io_issue_sqe()
> 
> I see now, thanks! What a jungle

The problem is, as you alluded to, that errors are returned through the
callback. Not sure if you recall, but I did make an attempt at doing
inline -EAGAIN returns, but had to abort and never got around to fixing
it up. See the revert here:

commit 7b6620d7db566a46f49b4b9deab9fa061fd4b59b
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Aug 15 11:09:16 2019 -0600

    block: remove REQ_NOWAIT_INLINE

Without that, we can't do better than what we do now. With the inline
NOWAIT, we'd get the same treatment on polled and non-polled, and we
could kill that check. Which would be lovely...

-- 
Jens Axboe

