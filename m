Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15C452AB34
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 20:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352346AbiEQSsM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 14:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352376AbiEQSsL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 14:48:11 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A954E49F9F
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:48:09 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id e194so20217680iof.11
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 11:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=SE+11+vbzkl43f1OuB5o/lCcOtNG/64RJownFy9+GFU=;
        b=QeSfzHE4QwpBGdEObHa6quTTI1/CVpU0s8rm+w6vCvj0/lyDzOyDv8Y/BCP231kUe5
         KG4/vramgin7DFRwQDlhErPPQZi7VnQ+XZW88noEV/uHI3fOB/m97rCYK9otgjayWg9C
         Ck6PEljHbBiAM6NLIioAyQ1WVyxnVb27TWyK0R0yRbZWDuZcy6asYDSCpAoO/rdpCrxk
         Agvze7GnSUBXOmmFj+UFx/Xd4IsMok+O4QnFDy3b4ejB6mFgOBWIJbzV9riNbJbx0uGb
         dRWfxOXxqcyZSUlexc5Rj8qqwDw14ONFDmq9sgykedgDtLlcTgnSt/GaNG8vILp53n1f
         sclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=SE+11+vbzkl43f1OuB5o/lCcOtNG/64RJownFy9+GFU=;
        b=u7M9X/LaY4i750cxpQ4jVBWFre2Um6aDBAfVbWHuWaBTFURQwMix0SzfhmT1QKyH7w
         8OSR2ff/6HV9q6JPbHz5pF4sIuqlNhiq4+5jnko5RKuUATuWB8CIwRn9yqpnnRwBf2lg
         MA4XujoNJP7X7HrI2dkHOPo/8L0/HnoTMeo0uMdI49+G44dpbqgbzguO15rkJYCQ1TSQ
         7exJUA9dXPyrakdn6k5yR64/kNSpLyTiIQsDJfMYDb3XU7hBcr4ojo3EQnKkb+TJaseF
         7rurb+AtyRwsRqzFanWOxkQWwoL5wSyc2I2QUx86lSr0i6birqZ1sA9C6ELJymUJYZPW
         AlCg==
X-Gm-Message-State: AOAM5338cmkXosNTRZtNDI7odDpRgd0oYFTzPvze5M9PmKbChMRjnnkI
        6AvYAimX6yN/dt+myS3KKGGvJfuZdbgw4A==
X-Google-Smtp-Source: ABdhPJz3ziYaKo1zpAPH/Te0RtHhSAtcW5q8XCsE86pA0MKOqAWaz8+nqCWtz1m+paDqLYukjWCb/Q==
X-Received: by 2002:a5d:9bd9:0:b0:65e:1a97:fa70 with SMTP id d25-20020a5d9bd9000000b0065e1a97fa70mr3622076ion.48.1652813288683;
        Tue, 17 May 2022 11:48:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e20-20020a6b6914000000b0065a47e16f3bsm14619ioc.13.2022.05.17.11.48.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 11:48:08 -0700 (PDT)
Message-ID: <3b5508aa-29f6-d9fc-815b-cd4c65eff819@kernel.dk>
Date:   Tue, 17 May 2022 12:48:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: don't attempt to IOPOLL for MSG_RING requests
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <38094d23-9f0d-d257-1adc-79f50501b3cd@kernel.dk>
In-Reply-To: <38094d23-9f0d-d257-1adc-79f50501b3cd@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 12:34 PM, Jens Axboe wrote:
> We gate whether to IOPOLL for a request on whether the opcode is allowed
> on a ring setup for IOPOLL and if it's got a file assigned. MSG_RING
> is the only one that allows a file yet isn't pollable, it's merely
> supported to allow communication on an IOPOLL ring, not because we can
> poll for completion of it.
> 
> Put the assigned file early and clear it, so we don't attempt to poll
> for it.
> 
> Reported-by: syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com
> Fixes: 3f1d52abf098 ("io_uring: defer msg-ring file validity check until command issue")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 91de361ea9ab..3cb0bc68d822 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5007,6 +5007,9 @@ static int io_fadvise(struct io_kiocb *req, unsigned int issue_flags)
>  	if (ret < 0)
>  		req_set_fail(req);
>  	__io_req_complete(req, issue_flags, ret, 0);
> +	/* put file to avoid an attempt to IOPOLL the req */
> +	io_put_file(req->file);
> +	req->file = NULL;
>  	return 0;
>  }

patch unhelpfully applying to the wrong function when ported from
for-next to 5.18. Here's the right one:

commit aa184e8671f0f911fc2fb3f68cd506e4d7838faa
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue May 17 12:32:05 2022 -0600

    io_uring: don't attempt to IOPOLL for MSG_RING requests
    
    We gate whether to IOPOLL for a request on whether the opcode is allowed
    on a ring setup for IOPOLL and if it's got a file assigned. MSG_RING
    is the only one that allows a file yet isn't pollable, it's merely
    supported to allow communication on an IOPOLL ring, not because we can
    poll for completion of it.
    
    Put the assigned file early and clear it, so we don't attempt to poll
    for it.
    
    Reported-by: syzbot+1a0a53300ce782f8b3ad@syzkaller.appspotmail.com
    Fixes: 3f1d52abf098 ("io_uring: defer msg-ring file validity check until command issue")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91de361ea9ab..e0823f58f795 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4481,6 +4481,9 @@ static int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < 0)
 		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
+	/* put file to avoid an attempt to IOPOLL the req */
+	io_put_file(req->file);
+	req->file = NULL;
 	return 0;
 }
 
-- 
Jens Axboe

