Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14AC5153E6
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 20:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347973AbiD2Sr3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379081AbiD2Sr1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:47:27 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06B0CE650
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:44:08 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id m6so6503771iob.4
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=9adwz/QQKUosAOLt+b9+gmzUTh4naDCAm6hcRd6FGOo=;
        b=W7ljDZxuG4O89ugyn2t3wXJ63KB7a/1w7o/23iyPyWGUWECYBL1i5/39Gu8DykrVpq
         uINUuvSxstjmzIRX8Qm4rnh5duKAyT9FFYyppqbv2iK8UhYQXwvsNpYGVApCa0FB7BIO
         5BU3B5Le1vTmp/ZUXWl/BNt7psKRcmdNW2TPAlYIsL8BMoz1Lhq56qahyKGoVywwNKH2
         d9EcJyWBmK89avW243ay+MzsQ/9Ol/N9kQkiyKZHewfvv0xgzztOd3iT+GWz5sjOLz4S
         MbirYmN+7KTrVqKya7U+pHX+u1VgRDD+eqVZ3Eh+4px0+w1vaIk/pEJOSY41Cd642zva
         mT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9adwz/QQKUosAOLt+b9+gmzUTh4naDCAm6hcRd6FGOo=;
        b=G0ATFg8o42JPNwkPeWfADYvycNYTu3CKUDzOiJVSXuPLOs+m2ySDT7cLpWXXLRmxKC
         tF9nHrbaiMk1lEkErDvQpN3DMPFrWPhhJSwOs2GRLhJXQN/5SVmf5jnfUb0wcMAiCnx+
         ChEFoHlWEWcawBrRCWvLAvU6svyhd6lyz4uQtuUASzvNQRrZ7BdzbMaNd0puvzYsMrhB
         BidD1mlbHMbNSHgUgzP5Pv820s4PmzGzTstIdtOqRJRJ1gPc5/RgHBa7SKbThcNlnsoA
         Ok3fvpGqERFmZFEmsmb2/umMXUaQDis3Zf6wbuTOliy5Od680Sgmmk2hczLqcfND8bmH
         YmGg==
X-Gm-Message-State: AOAM533lN2fOtVUp8p684KjBO35uufHcIFshMrfpm4ysQ8rKZ2FRZHnE
        1G2zycDSAG9hIP99HFlUeWu4iAhwmiIhYg==
X-Google-Smtp-Source: ABdhPJzV3rFLr5YvlHCExOu2MI71DlmiSIEw8o3vMqS7qVPhHhiRZqhWZnZ98AgI2RKizPKQQRNJ9A==
X-Received: by 2002:a05:6602:2b0b:b0:64f:acc1:52c3 with SMTP id p11-20020a0566022b0b00b0064facc152c3mr327115iov.38.1651257847961;
        Fri, 29 Apr 2022 11:44:07 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v7-20020a02b907000000b0032b3cfba0b3sm773467jan.123.2022.04.29.11.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:44:07 -0700 (PDT)
Message-ID: <5f4c75a8-f432-bfa3-66a7-53acb1fd2f44@kernel.dk>
Date:   Fri, 29 Apr 2022 12:44:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET 0/2] Add support for IORING_RECVSEND_POLL_FIRST
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
References: <20220427015428.322496-1-axboe@kernel.dk>
 <7368ecc8-1255-09a5-0d1e-e4250062f84e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7368ecc8-1255-09a5-0d1e-e4250062f84e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/22 12:31 PM, Hao Xu wrote:
> On 4/27/22 09:54, Jens Axboe wrote:
>> Hi,
>>
>> I had a re-think on the flags2 addition [1] that was posted earlier
>> today, and I don't really like the fact that flags2 then can't work
>> with ioprio for read/write etc. We might also want to extend the
>> ioprio field for other types of IO in the future.
>>
>> So rather than do that, do a simpler approach and just add an io_uring
>> specific flag set for send/recv and friends. This then allow setting
>> IORING_RECVSEND_POLL_FIRST in sqe->addr2 for those, and if set, io_uring
>> will arm poll first rather than attempt a send/recv operation.
>>
>> [1] https://lore.kernel.org/io-uring/20220426183343.150273-1-axboe@kernel.dk/
>>
> 
> Hi Jens,
> Could we use something like the high bits of sqe->fd to store general
> flags2 since I saw the number of open FDs can be about (1<<20) at
> most. Though I'm not sure if we can assume the limitation of fd won't
> change in the future..

I think that's a bit iffy, it's pretty universally true (at least on
*NIX) that and fd is a signed int. So I'd be hesitant to do that. I
don't mind the flags here, generally we have potentially 3 per request:

- SQE specific ones, these are the IOSQE_* flags and are meant to be
  generally applicable to all/most commands. io_uring internal, have no
  meaning outside of io_uring.

- Some requests are layered on top of existing functionality, the
  recv/recvmsg is a good example. They have their own sets of flags. We
  generally use the sqe->rw_flags space for those.

- Lastly, io_uring modifiers to specific requests. That's what this
  patch adds. They don't make sense to the lower layers, but they are
  specific to this request type for io_uring.

The 3rd type is put in sqe->rw_flags for io_uring specific opcodes, but
for commands that already have flags in the 2nd category, we have to put
them somewhere else. Not a big deal imho, at least as long as the
request type has space in the sqe for it. They generally do, they did in
this case.

-- 
Jens Axboe

