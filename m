Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675E77A0703
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 16:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbjINOP2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 10:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbjINOPW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 10:15:22 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFC3B9
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 07:15:17 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-34e1757fe8fso1289775ab.0
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 07:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694700917; x=1695305717; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lC7tiJ3v6+ZPQFDigrnT8LM1cBPXOBrraCGCAwqJ+0w=;
        b=FvcabP+gdvuZ1b3abTnyUiMDJ63KIdq3/Nd8hbBRhE6TKAzjmyamoKqnrtbq7hyoPY
         bN4c9JNlYN/YUcHfSL4gUjjkWtQT3lTKytF1On2F3mnB9VWXQngBnU/CQUZGWub8pUEM
         XGP8MR+9M90F+4O9O84bgcY2vH3s0LlNTqzCsj3p6RO+2NkVH49T1Wf6KWkWtiFwToBh
         BNx1RoaU7hZoZxyv8nAkp6oDi3RekMirsLHVfO36IuuWMRgWXrIkLMsxRXaKFRo7OuFi
         +yjcRuu9EZ1VWDBADkAc6dhhW5sAEjQDwKzbpPOLj3r5pKoetuaf3bedhPv+88vP2TtG
         maFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694700917; x=1695305717;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lC7tiJ3v6+ZPQFDigrnT8LM1cBPXOBrraCGCAwqJ+0w=;
        b=lLxkxDKuDNjYLD7lKsvOkTjDzBkaVkr0ktQ2RtMuTjYZ2/zJPd6Luvo3DosSa1O/p6
         4GYCUw0TAflouDzXXX9oDtkpbw1wjtsMfLUb5hujb0WONgiOGGKkdjOV/uZONwgJtcds
         gZH/Wlk00TrAvexQRjI0g1p4xpmOJUWIU2qgR3/FcUBDszbOqMJVJTcNyxUl1PLjHu3B
         2ruZye4l9NKg3JlUphCL/aw2U2d5pAPtBiWraNOnPDwdAFpsLQcplGWpKKR6Eq8L5933
         YiFPCl43b6MskTZ87FpHd/wBvo0DupZxzszVmoN7gpD79Xt1AON41NcHGVXy9Hv+yFsd
         f7jA==
X-Gm-Message-State: AOJu0YwwCKrSENcwVpvby1CTnS6CAp908BW7v7ZNY8HGIyJ2pXZoigQo
        SNITHAKOCRTjRMzumJgslP++Hg==
X-Google-Smtp-Source: AGHT+IHiVuKTiaER3skDF5GIFJwHUk4QcUVfq+DU08aeqNJacOP8bOimXqIAj5w6ZmvHMSuEPcNnmA==
X-Received: by 2002:a05:6e02:1d81:b0:34f:b824:5844 with SMTP id h1-20020a056e021d8100b0034fb8245844mr83200ila.3.1694700917240;
        Thu, 14 Sep 2023 07:15:17 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x2-20020a92d642000000b0034e1bc83001sm476038ilp.85.2023.09.14.07.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 07:15:16 -0700 (PDT)
Message-ID: <b765714b-b520-4339-8b30-920e0d6cb3dd@kernel.dk>
Date:   Thu, 14 Sep 2023 08:15:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] io_uring/net: don't overflow multishot recv
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>, io-uring@vger.kernel.org
References: <cover.1691757663.git.asml.silence@gmail.com>
 <0b295634e8f1b71aa764c984608c22d85f88f75c.1691757663.git.asml.silence@gmail.com>
 <037c9d5c-5910-49e0-af3b-70a48c36b0ca@kernel.org>
 <a7d1a399-8f4a-19de-a20e-5ce76a55a781@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a7d1a399-8f4a-19de-a20e-5ce76a55a781@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/23 7:02 AM, Pavel Begunkov wrote:
> On 9/14/23 09:34, Jiri Slaby wrote:
>> On 11. 08. 23, 14:53, Pavel Begunkov wrote:
>>> Don't allow overflowing multishot recv CQEs, it might get out of
>>> hand, hurt performanece, and in the worst case scenario OOM the task.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/net.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>> index 1599493544a5..8c419c01a5db 100644
>>> --- a/io_uring/net.c
>>> +++ b/io_uring/net.c
>>> @@ -642,7 +642,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>       if (!mshot_finished) {
>>>           if (io_aux_cqe(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
>>> -                   *ret, cflags | IORING_CQE_F_MORE, true)) {
>>> +                   *ret, cflags | IORING_CQE_F_MORE, false)) {
>>
>> This one breaks iouring's recv-multishot.t test:
>> Running test recv-multishot.t                                       MORE flag not set
>> test stream=0 wait_each=0 recvmsg=0 early_error=4  defer=0 failed
>> Test recv-multishot.t failed with ret 1
>>
>> Is the commit or the test broken ;)?
> 
> The test is not right. I fixed it up while sending the kernel patch,
> but a new liburing version hasn't been cut yet and I assume you're
> not using upstream version?

I'll probably cut a new release soonish, we're after the merge window
now so whatever went into 6.6-rc should be solid/sane API wise.

-- 
Jens Axboe

