Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6710F2D14B7
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgLGP3K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgLGP3K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:29:10 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B8BC061749
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:28:30 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id y5so13729221iow.5
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/MFv2NLbcZ+K+cLedXKo6U1X9hji03MDKIB1SvQ/roU=;
        b=A1ILv3jNsDKp2GIiR9V9iEP7aabGDG5lG0V7AJdpPLfGp1Rz+OU9m3ustc9yXmHCJN
         MCQ4t8BaRN8iuMfPLdZhcP9EoaiNdeeu2W9pJfwtP0L1SODEHmuNP/XOLWxgxLdCLeJX
         T5foSV9HQq4awV7vltzCx+GUTB2gTCo3IpY47pzWAaH3oFc8qB0ZDmlDxCrSIaJ8DNRZ
         KRHkMNI1RN1D9cNJaJw9DQ8+zIbdG+m9tgmM0V1QKlxerWx64sQ4IOmLvA0HGH5xSCBn
         FAxwbG3SJ9oDfvwJvSDZbkbnQL9I78h89ARaZiRRoq8ffL0HPFQE/T2pbifLjEM/vRhc
         YJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/MFv2NLbcZ+K+cLedXKo6U1X9hji03MDKIB1SvQ/roU=;
        b=sPUnnYzUaKvfbY38Q7xlxEag8nsqEENsKgQ+Iykp+BQKjiBcjVapp3EoX0M9zATrR4
         83s13HERbbvr4ZXC1IqBFD0rLkTxXx41LX0UADS6ghAiAZAZOpgA3lW29F8jMi9AtQLv
         6CexjyHSeqak+c0phMFiz8WtEKhWDzY3+gz3oJAtVMJ3dt1/d093YTcE4q3DEtGuU+Zz
         aYr5tLCowfGBX7NFcCN70xGfSufR7/wsscPL4nndSp4Lrxd9WwtKKviWvwLYKjqcESeo
         hqyo6tbcg/pGwIU+FUADDaQdPq3Mqta8cEsxm9fk3RoejputE5krbNfXBOsIZVnNUaXP
         6XMA==
X-Gm-Message-State: AOAM530usIljINFgb9qr7IfhShWKUSSoQb/QA1TJ+WDiFalOYwW/mq6A
        jHV/Cm5Zk1Gcq+AUqiuhpePr2TgruH49YA==
X-Google-Smtp-Source: ABdhPJyiWHVqjGl13g9Uvt38HacPDwW2RGwaMXWv1c6u8DbtWjAZKxDAIItB2li+UZRhgPjqdDMJxg==
X-Received: by 2002:a02:ca54:: with SMTP id i20mr17404566jal.111.1607354909304;
        Mon, 07 Dec 2020 07:28:29 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v5sm6274591iob.26.2020.12.07.07.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:28:28 -0800 (PST)
Subject: Re: [PATCH 5.10 0/5] iopoll fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1607293068.git.asml.silence@gmail.com>
 <bb6bd92a-e6be-5683-debc-82c0a2b02a98@kernel.dk>
 <32957a33-7a4d-98f6-5609-fe9ae43b1892@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b6c66f58-46c6-9f58-e87f-8bcac66d41a7@kernel.dk>
Date:   Mon, 7 Dec 2020 08:28:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <32957a33-7a4d-98f6-5609-fe9ae43b1892@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/20 8:24 AM, Pavel Begunkov wrote:
> On 07/12/2020 15:05, Jens Axboe wrote:
>> On 12/6/20 3:22 PM, Pavel Begunkov wrote:
>>> Following up Xiaoguang's patch, which is included in the series, patch
>>> up when similar bug can happen. There are holes left calling
>>> io_cqring_events(), but that's for later.
>>>
>>> The last patch is a bit different and fixes the new personality
>>> grabbing.
>>>
>>> Pavel Begunkov (4):
>>>   io_uring: fix racy IOPOLL completions
>>>   io_uring: fix racy IOPOLL flush overflow
>>>   io_uring: fix io_cqring_events()'s noflush
>>>   io_uring: fix mis-seting personality's creds
>>>
>>> Xiaoguang Wang (1):
>>>   io_uring: always let io_iopoll_complete() complete polled io.
>>>
>>>  fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++-------------
>>>  1 file changed, 39 insertions(+), 13 deletions(-)
>>
>> I'm going to apply 5/5 for 5.10, the rest for 5.11. None of these are no
> 
> Didn't get what you mean by "None of these are no in this series."

Yeah that turned out better in my head... Meant that none of these are
_regressions_ in this series, so not necessarily urgent for 5.10.

>> in this series, and we're very late at this point. They are all marked for
>> stable, so not a huge concern on my front.
> 
> Makes sense. I hope it applies to 5.11 well. 

Mostly, just 3/5 needed a bit of hand holding.

-- 
Jens Axboe

