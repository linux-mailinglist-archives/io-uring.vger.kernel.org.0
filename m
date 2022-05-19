Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4FC52D238
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 14:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiESMNr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 08:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237748AbiESMNo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 08:13:44 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79810AFB05
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 05:13:43 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v10so4870467pgl.11
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 05:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cBdsNwNuUWcHBVSZnefidNgiSTdFq4bBjxcWdp8eq9c=;
        b=PhYe6Zm53hWyTiIHExH19QdG0D1ovb4SU1/2wgkVXJYWG97IHzmTxuBE4YBUQMekdR
         tlg/1z0MbzPR242Q240ZaVA94UWStSooP4i4yJs442aoXoczZQPwJbTUYtU6OOTtavll
         2nWXe0UB7+STYBS1PT2vFF2MNlm91hdW6GSBTTGNTDvAKGzE8L/vbW43pVA03efepCAf
         vve/fAumWSyBzamVi6TO+NwY7BYky5oOzLhooYRxZGh9S4683qut+AL3AtZmtgalfINI
         L5BbMdJNFDyDkcXIU9pbeLt2NNpX6MaSDNfG0uDbPHsX0X8Kdi7M2XlcgA2sxGnR+PFa
         oViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cBdsNwNuUWcHBVSZnefidNgiSTdFq4bBjxcWdp8eq9c=;
        b=F4sytmM4rvb3Y4S7pZEHwPJIr5g2aaeD4rHf5eJ84Kbi10HU/j/fpK7ribC2QAWA2g
         99yiVW2yZjQyyLyLa5yLD6bjjCALBrpbMsUlzeqq+qeNvsuA/kGjq5diGKIG5addInER
         E9nli1Bh0jexyiMgF4sAAgERbkRau+MCVMrwJwjZRHjrL8SKeWkY1DC2O/E7tZnvV6yD
         g1nBMXF9tTKXK8K2BBHuoMl1c61MmK1gHKUi1Gm6XxK29M0mdj7g9ZbsCB0OdHXZbIyH
         MVhDuKEWaMN9OT0U4C0Y28fhjWWAvJhc3jfIxrz1GS4OqvbYSXNeZZcjbrYl9qDCxN7q
         aYjQ==
X-Gm-Message-State: AOAM533EhYGK7mlaI7JFgYzenTMXQhlvxuyb0t4q6DeRsEIaw3Xysro9
        Y0Hequ8PW0QLZxBCiHesjEnykw==
X-Google-Smtp-Source: ABdhPJwGfAOHNN3sZH6oTNPROfkQzkLIf/Bq3+efGiHXt4bYHSUDEUcxzCPZfzJFsYxswNsfxTbARQ==
X-Received: by 2002:a63:5063:0:b0:3f6:a3e:ad37 with SMTP id q35-20020a635063000000b003f60a3ead37mr3791550pgl.451.1652962422489;
        Thu, 19 May 2022 05:13:42 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a12-20020a62d40c000000b0050dc7628178sm4111654pfh.82.2022.05.19.05.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 05:13:41 -0700 (PDT)
Message-ID: <73db78f5-ea6c-2693-877e-976703bbfead@kernel.dk>
Date:   Thu, 19 May 2022 06:13:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
 <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
 <YoUNQlzU0W4ShA85@google.com>
 <49609b89-f2f0-44b3-d732-dfcb4f73cee1@kernel.dk>
 <YoUTPIVOhLlnIO04@google.com>
 <1e64d20a-42cc-31cd-0fd8-2718dd8b1f31@kernel.dk>
 <YoUgHjHn+UFvj0o1@google.com>
 <38f63cda-b208-0d83-6aec-25115bd1c021@kernel.dk>
 <YoYNM0eQPBSUietG@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoYNM0eQPBSUietG@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/22 3:26 AM, Lee Jones wrote:
> On Wed, 18 May 2022, Jens Axboe wrote:
> 
>> On 5/18/22 10:34 AM, Lee Jones wrote:
>>> On Wed, 18 May 2022, Jens Axboe wrote:
>>>
>>>> On 5/18/22 09:39, Lee Jones wrote:
>>>>> On Wed, 18 May 2022, Jens Axboe wrote:
>>>>>
>>>>>> On 5/18/22 9:14 AM, Lee Jones wrote:
>>>>>>> On Wed, 18 May 2022, Jens Axboe wrote:
>>>>>>>
>>>>>>>> On 5/18/22 6:54 AM, Jens Axboe wrote:
>>>>>>>>> On 5/18/22 6:52 AM, Jens Axboe wrote:
>>>>>>>>>> On 5/18/22 6:50 AM, Lee Jones wrote:
>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 5/17/22 7:00 AM, Lee Jones wrote:
>>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
>>>>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
>>>>>>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
>>>>>>>>>>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
>>>>>>>>>>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
>>>>>>>>>>>>>>>>>>> in Stable v5.10.y.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> The full sysbot report can be seen below [0].
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> The C-reproducer has been placed below that [1].
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> I had great success running this reproducer in an infinite loop.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>>>>>>>>>>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>        io-wq: have manager wait for all workers to exit
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
>>>>>>>>>>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
>>>>>>>>>>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
>>>>>>>>>>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
>>>>>>>>>>>>>>>>>>>        and that uses an int, there is no risk of overflow.
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>>>>>>>>>>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Does this fix it:
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
>>>>>>>>>>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
>>>>>>>>>>>>>>>>>> rectify that.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Thanks for your quick response Jens.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> This is probably why it never made it into 5.10-stable :-/
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Right.  It doesn't apply at all unfortunately.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Let me know if you into issues with that and I can help out.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I think the dependency list is too big.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Too much has changed that was never back-ported.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
>>>>>>>>>>>>>>> bad, I did start to back-port them all but some of the big ones have
>>>>>>>>>>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
>>>>>>>>>>>>>>> from v5.10 to the fixing patch mentioned above).
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The problem is that 5.12 went to the new worker setup, and this patch
>>>>>>>>>>>>>> landed after that even though it also applies to the pre-native workers.
>>>>>>>>>>>>>> Hence the dependency chain isn't really as long as it seems, probably
>>>>>>>>>>>>>> just a few patches backporting the change references and completions.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I'll take a look this afternoon.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks Jens.  I really appreciate it.
>>>>>>>>>>>>
>>>>>>>>>>>> Can you see if this helps? Untested...
>>>>>>>>>>>
>>>>>>>>>>> What base does this apply against please?
>>>>>>>>>>>
>>>>>>>>>>> I tried Mainline and v5.10.116 and both failed.
>>>>>>>>>>
>>>>>>>>>> It's against 5.10.116, so that's puzzling. Let me double check I sent
>>>>>>>>>> the right one...
>>>>>>>>>
>>>>>>>>> Looks like I sent the one from the wrong directory, sorry about that.
>>>>>>>>> This one should be better:
>>>>>>>>
>>>>>>>> Nope, both are the right one. Maybe your mailer is mangling the patch?
>>>>>>>> I'll attach it gzip'ed here in case that helps.
>>>>>>>
>>>>>>> Okay, that applied, thanks.
>>>>>>>
>>>>>>> Unfortunately, I am still able to crash the kernel in the same way.
>>>>>>
>>>>>> Alright, maybe it's not enough. I can't get your reproducer to crash,
>>>>>> unfortunately. I'll try on a different box.
>>>>>
>>>>> You need to have fuzzing and kasan enabled.
>>>>
>>>> I do have kasan enabled. What's fuzzing?
>>>
>>> CONFIG_KCOV
>>
>> Ah ok - I don't think that's needed for this.
>>
>> Looking a bit deeper at this, I'm now convinced your bisect went off the
>> rails at some point. Probably because this can be timing specific.
>>
>> Can you try with this patch?
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 4330603eae35..3ecf71151fb1 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4252,12 +4252,8 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
>>  	struct io_statx *ctx = &req->statx;
>>  	int ret;
>>  
>> -	if (force_nonblock) {
>> -		/* only need file table for an actual valid fd */
>> -		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
>> -			req->flags |= REQ_F_NO_FILE_TABLE;
>> +	if (force_nonblock)
>>  		return -EAGAIN;
>> -	}
>>  
>>  	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
>>  		       ctx->buffer);
> 
> This does appear to solve the issue. :)
> 
> Thanks so much for working on this.
> 
> What are the next steps?
> 
> Are you able to submit this to Stable?

Yes, I'll get it queued up for stable.

-- 
Jens Axboe

