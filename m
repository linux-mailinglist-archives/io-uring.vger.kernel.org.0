Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74EF6CC47F
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjC1PFg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjC1PFf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:05:35 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA736BDF2
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:04:17 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v5so3915687ilj.4
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680015830; x=1682607830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ucZhZsgBspww1nPxwldrAWVTtQLudFoSvy5Lz6B5BmM=;
        b=im4JMvggrmnWjALWqA9lBZSJmGhFrWJ02B3R4yWfJ+CPe92bmfCmtmwloI8SIQrm3W
         SgUkKaeJKdfg6Rmkfc4mkdUNnMvRqcx0swZXw5mtG/t56ILQlINoQKSb5MpgOnhlpOvO
         kRM0xqL1WqbVnKj23qqQMiC2eP2ymFupLqIejEoaT8aYoQ8bKmot3YckN3a01AYR7dji
         9atjdDAeWHml87BVW6ZPvuWKfHXS8tfmrNNRRvTTYxKgyLUp5mbQV7uXqpB3quGPA78h
         yFq4udxxW7FgBOD58efaWchJFV6hVksR/BPmEZ1GlgVIv8knpFIFVjCXohhgGnkcYCW1
         wC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015830; x=1682607830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ucZhZsgBspww1nPxwldrAWVTtQLudFoSvy5Lz6B5BmM=;
        b=su2U/qPFZTifc6gk/0kFy/80X4ZDTfLukmP73knTcLrHO3EHth7IejgiUjr6WcRhEv
         zoVV3mJxKYOqkv+ETT+x10QLJqNDfF4iSXtjiBEx5aFWJs5Rcz5xuiQddcPHBuhTU3gY
         WWIKvScdyH/m0e6zhqJeXbKKY56fH1EkIIHWF+ndjaQDeG2AdUEQufUk8ZL/NwF7E2CZ
         YpvPeH76GSB6mFjEd/TQnymECeXOGrtlNTt383D0MSb+p1NI1IzdOYlFOrl57wm2SHNZ
         G/BB4H4QUh+xudJ7mwddHOdukAbPfqJ6jXCq89SO6fFcRTDZnn0ZUjDdQQDn+I7nrj6i
         s/EA==
X-Gm-Message-State: AAQBX9cYDpoOhp5SAmBCY2leTk+2eKZpAveOBSfYOZF5nbh+e36GPkKL
        9qNEegv0p/RpnwUNpAhZ08a2zA==
X-Google-Smtp-Source: AKy350bG+zrVVfobRItE21/Jcwrrdkehr9SHhHPqL5ZCEF74jxHgbs1w9vvjdN4XomxIKWRnIGx8Sg==
X-Received: by 2002:a92:3652:0:b0:319:5431:5d5b with SMTP id d18-20020a923652000000b0031954315d5bmr8808784ilf.1.1680015830286;
        Tue, 28 Mar 2023 08:03:50 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ce16-20020a0566381a9000b00404f3266fd7sm9676913jab.159.2023.03.28.08.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 08:03:49 -0700 (PDT)
Message-ID: <d747cbab-5e0a-555c-6a2f-fe27bfcd35cf@kernel.dk>
Date:   Tue, 28 Mar 2023 09:03:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] io_uring/poll: clear single/double poll flags on poll
 arming
Content-Language: en-US
To:     Pengfei Xu <pengfei.xu@intel.com>
Cc:     io-uring <io-uring@vger.kernel.org>, heng.su@intel.com
References: <61e3fefd-0a99-5916-c049-9143d3342379@kernel.dk>
 <ZCJXK29jnRXAW6FO@xpf.sh.intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZCJXK29jnRXAW6FO@xpf.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/23 8:55 PM, Pengfei Xu wrote:
> Hi Jens Axboe,
> 
> On 2023-03-27 at 20:08:25 -0600, Jens Axboe wrote:
>> Unless we have at least one entry queued, then don't call into
>> io_poll_remove_entries(). Normally this isn't possible, but if we
>> retry poll then we can have ->nr_entries cleared again as we're
>> setting it up. If this happens for a poll retry, then we'll still have
>> at least REQ_F_SINGLE_POLL set. io_poll_remove_entries() then thinks
>> it has entries to remove.
>>
>> Clear REQ_F_SINGLE_POLL and REQ_F_DOUBLE_POLL unconditionally when
>> arming a poll request.
>>
>> Fixes: c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
>> Cc: stable@vger.kernel.org
>> Reported-by: Pengfei Xu <pengfei.xu@intel.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index 795facbd0e9f..55306e801081 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -726,6 +726,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
>>  	apoll = io_req_alloc_apoll(req, issue_flags);
>>  	if (!apoll)
>>  		return IO_APOLL_ABORTED;
>> +	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
>>  	req->flags |= REQ_F_POLLED;
>>  	ipt.pt._qproc = io_async_queue_proc;
>>  
>   Thanks for your patch!
>   I have tested the above patch on top of v6.3-rc4 kernel.
>   This issue was fixed.
>   Reproduced code from syzkaller: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.c
>   One more info, bisect methodology comes from myself, not from syzkaller.

Great, thanks for testing!

-- 
Jens Axboe


