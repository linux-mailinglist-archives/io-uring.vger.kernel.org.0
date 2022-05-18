Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC1A52C135
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbiERRme (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 13:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241077AbiERRmc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 13:42:32 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3882D1ACFB7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 10:42:31 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z18so3087495iob.5
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 10:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FCjAMF+t6xv+nOgAS8IDF6DMWgTC+Nhvzypvvbrh9wA=;
        b=hCjvSXLxmlAniS/CaWOF1M1d6LOv9BD0qdTUFahO8rcz4Ef3II2Xlw/8KoFY4FygDA
         aXYIcSQ0UKMl/m+vCwm9AVY6pw82AZ7bFPA4fV6AmYtFjaaFka9N/GjRdP7SS/Nzfz5r
         rq4Ye1iT2m3dXuSuqoHjQZU4MzMqkb/TigRDiC/Om6iq2ljPNQuRBJGyCgHI5vT+dBIF
         gwW+uzS0iUBDAABEStAdvjcFNrqqi0bCDFOtMf4XEw63dqi5YEbb9tkAStZkjn1WliRa
         4IkPuZmaWy/jUNPU6ve2/l8zXZKn1qYsRjYXrMK5MX+6FlhmtZX2hfy09gKhOnKiL/KR
         sa+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FCjAMF+t6xv+nOgAS8IDF6DMWgTC+Nhvzypvvbrh9wA=;
        b=yZmzhWZwi6hbNG5PRR8v/crIqnjx/ek4uzsDcrh161/TLZsESg3geZ5AnHlNRZgGjh
         NaJKc0AlbLrdUWZKRCMB9LszPdgJ9JEUzS7oB4FtUwVDFi6BMIRjgy7grPLtnrcml27C
         zGGIekimNgqbCdE7NqV6UOQjzE+S5Oy4J6jt6CBLnmnvAdb7LEzfvuWVD15uqqd00OpA
         6la+YvcfdW8QC3Ozo28QHuuzKFbxb2UE/amgmGZIcPf0/LPKjJKHOSRaQh/F/qhHeSoC
         ykpa6167YYMtFwV7EMdRdnio72UC/iXfqCIBYVNdMASbtzlXSsca2HoB40joS/8Tqlly
         Lulw==
X-Gm-Message-State: AOAM533H0YugT/t9DnUCa0+LYyfAp8oH+Ic6fjdWIWTDMvWxRXJP6Yiw
        AEos9fdXIcP65iBIEQtw9aaSjw==
X-Google-Smtp-Source: ABdhPJxK+bvQfVY5kKryj5XE95OVW3cbNlrCysNq41edVfeThstVpKoamTAblitMLurRSUHwe871jQ==
X-Received: by 2002:a05:6638:34a4:b0:32b:b205:ca82 with SMTP id t36-20020a05663834a400b0032bb205ca82mr353129jal.165.1652895750485;
        Wed, 18 May 2022 10:42:30 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r23-20020a6b5d17000000b006050cababc5sm54076iob.0.2022.05.18.10.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 10:42:29 -0700 (PDT)
Message-ID: <38f63cda-b208-0d83-6aec-25115bd1c021@kernel.dk>
Date:   Wed, 18 May 2022 11:42:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YoOcYR15Jhkw2XwL@google.com>
 <f34c85cc-71a5-59d4-dd7a-cc07e2af536c@kernel.dk>
 <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
 <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
 <YoUNQlzU0W4ShA85@google.com>
 <49609b89-f2f0-44b3-d732-dfcb4f73cee1@kernel.dk>
 <YoUTPIVOhLlnIO04@google.com>
 <1e64d20a-42cc-31cd-0fd8-2718dd8b1f31@kernel.dk>
 <YoUgHjHn+UFvj0o1@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoUgHjHn+UFvj0o1@google.com>
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

On 5/18/22 10:34 AM, Lee Jones wrote:
> On Wed, 18 May 2022, Jens Axboe wrote:
> 
>> On 5/18/22 09:39, Lee Jones wrote:
>>> On Wed, 18 May 2022, Jens Axboe wrote:
>>>
>>>> On 5/18/22 9:14 AM, Lee Jones wrote:
>>>>> On Wed, 18 May 2022, Jens Axboe wrote:
>>>>>
>>>>>> On 5/18/22 6:54 AM, Jens Axboe wrote:
>>>>>>> On 5/18/22 6:52 AM, Jens Axboe wrote:
>>>>>>>> On 5/18/22 6:50 AM, Lee Jones wrote:
>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>
>>>>>>>>>> On 5/17/22 7:00 AM, Lee Jones wrote:
>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
>>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
>>>>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>>>>>>>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
>>>>>>>>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>>>>>>>>>>>>>>>> in Stable v5.10.y.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> The full sysbot report can be seen below [0].
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> The C-reproducer has been placed below that [1].
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I had great success running this reproducer in an infinite loop.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>>>>>>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>        io-wq: have manager wait for all workers to exit
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
>>>>>>>>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>>>>>>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>>>>>>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
>>>>>>>>>>>>>>>>>        and that uses an int, there is no risk of overflow.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>>>>>>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Does this fix it:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>>>>>>>>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
>>>>>>>>>>>>>>>> rectify that.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Thanks for your quick response Jens.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> This is probably why it never made it into 5.10-stable :-/
>>>>>>>>>>>>>
>>>>>>>>>>>>> Right.  It doesn't apply at all unfortunately.
>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Let me know if you into issues with that and I can help out.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I think the dependency list is too big.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Too much has changed that was never back-ported.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
>>>>>>>>>>>>> bad, I did start to back-port them all but some of the big ones have
>>>>>>>>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
>>>>>>>>>>>>> from v5.10 to the fixing patch mentioned above).
>>>>>>>>>>>>
>>>>>>>>>>>> The problem is that 5.12 went to the new worker setup, and this patch
>>>>>>>>>>>> landed after that even though it also applies to the pre-native workers.
>>>>>>>>>>>> Hence the dependency chain isn't really as long as it seems, probably
>>>>>>>>>>>> just a few patches backporting the change references and completions.
>>>>>>>>>>>>
>>>>>>>>>>>> I'll take a look this afternoon.
>>>>>>>>>>>
>>>>>>>>>>> Thanks Jens.  I really appreciate it.
>>>>>>>>>>
>>>>>>>>>> Can you see if this helps? Untested...
>>>>>>>>>
>>>>>>>>> What base does this apply against please?
>>>>>>>>>
>>>>>>>>> I tried Mainline and v5.10.116 and both failed.
>>>>>>>>
>>>>>>>> It's against 5.10.116, so that's puzzling. Let me double check I sent
>>>>>>>> the right one...
>>>>>>>
>>>>>>> Looks like I sent the one from the wrong directory, sorry about that.
>>>>>>> This one should be better:
>>>>>>
>>>>>> Nope, both are the right one. Maybe your mailer is mangling the patch?
>>>>>> I'll attach it gzip'ed here in case that helps.
>>>>>
>>>>> Okay, that applied, thanks.
>>>>>
>>>>> Unfortunately, I am still able to crash the kernel in the same way.
>>>>
>>>> Alright, maybe it's not enough. I can't get your reproducer to crash,
>>>> unfortunately. I'll try on a different box.
>>>
>>> You need to have fuzzing and kasan enabled.
>>
>> I do have kasan enabled. What's fuzzing?
> 
> CONFIG_KCOV

Ah ok - I don't think that's needed for this.

Looking a bit deeper at this, I'm now convinced your bisect went off the
rails at some point. Probably because this can be timing specific.

Can you try with this patch?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4330603eae35..3ecf71151fb1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4252,12 +4252,8 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
 	struct io_statx *ctx = &req->statx;
 	int ret;
 
-	if (force_nonblock) {
-		/* only need file table for an actual valid fd */
-		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
-			req->flags |= REQ_F_NO_FILE_TABLE;
+	if (force_nonblock)
 		return -EAGAIN;
-	}
 
 	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
 		       ctx->buffer);

-- 
Jens Axboe

