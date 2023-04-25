Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DEC6EE317
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 15:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbjDYNbe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 09:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbjDYNb1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 09:31:27 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7051447C
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 06:31:12 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-760b6765f36so13504539f.0
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 06:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682429472; x=1685021472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=81EYFW+xLs0EGrrakYMbBpb2FQrdpMrhd7NCZ1cjUb0=;
        b=2OYlvojjx5rWWSLxmNhwBv3Wv1+IUUuNpHUX5RguLmH6I760iPtRTMuA2rt36zTZpz
         60Sk2RkfizgV/x1wNXYjn6anHywdQdMcqdzRtgJugtTO0OTxxRMY2NdFb6YReJfdCPtj
         ubJ8UV5DOnrOxWh1gk2MpirR48JEN7bDUiBEJ3e9jn6r3LZ/GTRn+0ldDMEP2XUP4Vh+
         22ILWORQ8GrjyIVyOqGB6Lkmdl58op3+YyVLUmN5ja3mA1b13YMWwbCSAST1ec4qCwdI
         /55PKGI42WlqlKwA9KYC8duUWEjwJ79ZLgp3BWvi1D+QbAepDPpXFb+SCwr5x3vSj4P+
         VX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682429472; x=1685021472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=81EYFW+xLs0EGrrakYMbBpb2FQrdpMrhd7NCZ1cjUb0=;
        b=khRc+0Jr4AkT4NoGk825ADOAQorGOwRNCxlY0lQQZFzho3KOHeq5zxS0j549SFXP/l
         CKfbn4QPxaj8hTQeoxU+Oyc+NdBEEbjuEazg3jHMUxa1ckhlPZseDmkVUtYdf6F2wDlK
         /TP5ZEbOBhApqPnOpja0aEnGyXvOfqquVcFykHunmj9sNsyB+o5f0OotC/WQ+NQYZtvU
         OxlUpn/r3SnnAaco0z7aa1bxckCjbhpzKL4cP4x8+BwLmMebPkVQ0l5KirztFf+jtdAo
         KXZpk2pSeRombT6c7MjF0eg3gVQSOMZLQ/Urs3x2g+X8GIEKsVrtDDhhVO3aT3bO6fqb
         wU7Q==
X-Gm-Message-State: AAQBX9cWco8iSrBt9NEibM1yAiyGoDXrdfIdvE6YmxMM22tEPe2C/jH1
        hJ1jEwJO2Exrng6CDSkjzVzsjAIVELFsb/p0Gro=
X-Google-Smtp-Source: AKy350brYlGTtMrPeiEG9B88Nazmf0l/jdVsbHP/HXQzux0rktSy72QjxRk2ZhHYOoToutmEUi5Otg==
X-Received: by 2002:a05:6602:3807:b0:763:b34f:6f7b with SMTP id bb7-20020a056602380700b00763b34f6f7bmr5936121iob.2.1682429472049;
        Tue, 25 Apr 2023 06:31:12 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z10-20020a6b0a0a000000b00763699c3d02sm3868569ioi.0.2023.04.25.06.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 06:31:11 -0700 (PDT)
Message-ID: <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
Date:   Tue, 25 Apr 2023 07:31:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/23 8:50?PM, Ming Lei wrote:
> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>
>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>> ---
>>>>>>>>  io_uring/io_uring.c |  2 +-
>>>>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>  io_uring/opdef.h    |  2 ++
>>>>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>  		return -EBADF;
>>>>>>>>  
>>>>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>
>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>
>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>>>> returns if nonblock == true.
>>>>>
>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>>>> these OPs won't return -EAGAIN, then run in the current task context
>>>>> directly.
>>>>
>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>>>> it :-)
>>>
>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
>>> ->always_iowq is a bit confusing?
>>
>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
>> be happy to take suggestions on what would make it clearer.
> 
> Except for the naming, I am also wondering why these ->always_iowq OPs
> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
> shouldn't improve performance by doing so because these OPs are supposed
> to be slow and always slept, not like others(buffered writes, ...),
> can you provide one hint about not offloading these OPs? Or is it just that
> NO_OFFLOAD needs to not offload every OPs?

The whole point of NO_OFFLOAD is that items that would normally be
passed to io-wq are just run inline. This provides a way to reap the
benefits of batched submissions and syscall reductions. Some opcodes
will just never be async, and io-wq offloads are not very fast. Some of
them can eventually be migrated to async support, if the underlying
mechanics support it.

You'll note that none of the ->always_iowq opcodes are pollable. If
NO_OFFLOAD is setup, it's pointless NOT to issue them with NONBLOCK
cleared, as you'd just get -EAGAIN and then need to call them again with
NONBLOCK cleared from the same context.

For naming, maybe ->always_iowq is better as ->no_nonblock or something
like that. Or perhaps get rid of the double negation and just call it
->blocking, or maybe ->no_async_support to make it clearer?

> Or can we rename IORING_SETUP_NO_OFFLOAD as IORING_SETUP_SUBMIT_MAY_WAIT
> and still punt ->always_iowq OPs to iowq?

I think NO_OFFLOAD better explains that we'll never offload to io-wq. I
would've called it NO_IOWQ, but I don't think that's understandable to
users in the same way. The problem is that the user does need some
knowledge of how ios are issued and completed in io_uring to fully grok
what it does, which I'll put in the man pages.

-- 
Jens Axboe

