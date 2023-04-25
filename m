Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20E56EE4AB
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 17:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbjDYPZk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 11:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbjDYPZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 11:25:39 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBA1CC12
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:25:37 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-760a1c94c28so31353639f.1
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682436337; x=1685028337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tlCJ1W/BKoTCvjscckZ233MNZXyFit6gOaUZ8FO2gis=;
        b=oH1HpI2RPc3S3N7LSNRcR8aNwyKeX05XDhEBXcGCyChxMdbPlsOzuyWGhmOx+P7zTz
         DbIHrn8mvRyVZnQamjVofGKdP6h+Toa1dHRyCsKuKpvUlvc50/1dG9FEWaDaWvsfKAbd
         HG+XffKjNK4RCnHgiU0gDsVHvrb510lue4JhCOflXpSiodqKpgsElD09bBFBZcBUn1Ch
         4uL8HllGGEBc13uqDLoyI7JyhHTeC8TMjdhqXY+1HyJyFF/8eXTH82DvPgknULzY33LX
         suwLGMrEFIby675B9WIWDJX7aj+ykH9L8DfUQSpBX+eH3GTJN+9tuzRILbrkgqeZ+FcU
         DzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682436337; x=1685028337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlCJ1W/BKoTCvjscckZ233MNZXyFit6gOaUZ8FO2gis=;
        b=HaqCubXngYEoNZt/C7tvY9tZKsl/Uq3Wd1WDxC6poA4McocwBpYH6vdJLBINI40v5E
         7xoRtD4uuMwcfyDcXd10O0VALOMz5IAKSpz3PbCTkfDsydBPRTMya0BN1JiN6W+sezm9
         zk9OBxagAAD2UDGWLxLdEkSeA/LYfmEE47cI99Temh93impmO6HoSoKgR6qwSdWsJIds
         iK/4abauFrkDJfRtmd2cRKqZY87NC+qmpfKlPWKrxUZr3ohr35+/9VUmSF6zDMi8vl2e
         LftAYkCwbfAdbXQYDPaE4brErOFSDzXfI247HbQB+kL79q4NXEiphrlbplnCujWcOuD7
         Ui2g==
X-Gm-Message-State: AC+VfDyfHxfVMd78v17Hr0Gs1g/kYgxsYItIylHU0qfHvlHbhBEFgNU0
        tFe9JbU/nzaDoBxekqXxuWTFlof0+o5ZsRUlkbM=
X-Google-Smtp-Source: ACHHUZ6OzLXbkwXvbIANMZ1h0gJfNHg6sNfAs3TkS4MWCS0Rb/FtNZk/fd2Jrd9I+UHLHtjg5D2oiA==
X-Received: by 2002:a92:c54e:0:b0:32a:a8d7:f099 with SMTP id a14-20020a92c54e000000b0032aa8d7f099mr1434292ilj.3.1682436336866;
        Tue, 25 Apr 2023 08:25:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ay18-20020a056638411200b00411b71cda7esm2114186jab.112.2023.04.25.08.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 08:25:36 -0700 (PDT)
Message-ID: <dd711c1b-8743-75ea-2368-a3f53316a030@kernel.dk>
Date:   Tue, 25 Apr 2023 09:25:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
 <a3225f4c-d0aa-e20e-6df3-84a996fe66dd@kernel.dk>
 <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEfso1qH41MWKZV6@ovpn-8-24.pek2.redhat.com>
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

On 4/25/23 9:07?AM, Ming Lei wrote:
> On Tue, Apr 25, 2023 at 08:50:33AM -0600, Jens Axboe wrote:
>> On 4/25/23 8:42?AM, Ming Lei wrote:
>>> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
>>>> On 4/24/23 8:50?PM, Ming Lei wrote:
>>>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>>>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>>>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>> ---
>>>>>>>>>>>>  io_uring/io_uring.c |  2 +-
>>>>>>>>>>>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>>>>>  io_uring/opdef.h    |  2 ++
>>>>>>>>>>>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>>>>>  		return -EBADF;
>>>>>>>>>>>>  
>>>>>>>>>>>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>>>>>>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>>>>>
>>>>>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>>>>>
>>>>>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>>>>>>>> returns if nonblock == true.
>>>>>>>>>
>>>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>>>>>>>> these OPs won't return -EAGAIN, then run in the current task context
>>>>>>>>> directly.
>>>>>>>>
>>>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>>>>>>>> it :-)
>>>>>>>
>>>>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
>>>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
>>>>>>> ->always_iowq is a bit confusing?
>>>>>>
>>>>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
>>>>>> be happy to take suggestions on what would make it clearer.
>>>>>
>>>>> Except for the naming, I am also wondering why these ->always_iowq OPs
>>>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
>>>>> shouldn't improve performance by doing so because these OPs are supposed
>>>>> to be slow and always slept, not like others(buffered writes, ...),
>>>>> can you provide one hint about not offloading these OPs? Or is it just that
>>>>> NO_OFFLOAD needs to not offload every OPs?
>>>>
>>>> The whole point of NO_OFFLOAD is that items that would normally be
>>>> passed to io-wq are just run inline. This provides a way to reap the
>>>> benefits of batched submissions and syscall reductions. Some opcodes
>>>> will just never be async, and io-wq offloads are not very fast. Some of
>>>
>>> Yeah, seems io-wq is much slower than inline issue, maybe it needs
>>> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.
>>
>> Indeed, depending on what is being linked, you may see io-wq activity
>> which is not ideal.
> 
> That is why I prefer to fused command for ublk zero copy, because the
> registering buffer approach suggested by Pavel and Ziyang has to link
> register buffer OP with the actual IO OP, and it is observed that
> IOPS drops to 1/2 in 4k random io test with registered buffer approach.

It'd be worth looking into if we can avoid io-wq for link execution, as
that'd be a nice win overall too. IIRC, there's no reason why it can't
be done like initial issue rather than just a lazy punt to io-wq.

That's not really related to fused command support or otherwise for
that, it'd just be a generic improvement. But it may indeed make the
linekd approach viable for that too.

>>>> them can eventually be migrated to async support, if the underlying
>>>> mechanics support it.
>>>>
>>>> You'll note that none of the ->always_iowq opcodes are pollable. If
>>>
>>> True, then looks the ->always_iowq flag doesn't make a difference here
>>> because your patch clears IO_URING_F_NONBLOCK for !file_can_poll(req->file).

Actually not sure that's the case, as we have plenty of ops that are not
pollable, yet are perfectly fine for a nonblocking issue. Things like
any read/write on a regular file or block device.

>> Yep, we may be able to just get rid of it. The important bit is really
>> getting rid of the forced setting of REQ_F_FORCE_ASYNC which the
>> previous reverts take care of. So we can probably just drop this one,
>> let me give it a spin.
>>
>>> Also almost all these ->always_iowq OPs are slow and blocked, if they are
>>> issued inline, the submission pipeline will be blocked.
>>
>> That is true, but that's very much the tradeoff you make by using
>> NO_OFFLOAD. I would expect any users of this to have two rings, one for
>> just batched submissions, and one for "normal" usage. Or maybe they only
>> do the batched submissions and one is fine.
> 
> I guess that NO_OFFLOAD probably should be used for most of usecase,
> cause it does avoid slow io-wq if io-wq perf won't be improved.
>
> Also there is other issue for two rings, such as sync/communication
> between two rings, and single ring should be the easiest way.

I think some use cases may indeed just use that and be fine with it,
also because it is probably not uncommon to bundle the issues and hence
not really mix and match for issue. But this is a vastly different use
case than fast IO cases, for storage and networking. Though those will
bypass that anyway as they can do nonblocking issue just fine.

>>>> NO_OFFLOAD is setup, it's pointless NOT to issue them with NONBLOCK
>>>> cleared, as you'd just get -EAGAIN and then need to call them again with
>>>> NONBLOCK cleared from the same context.
>>>
>>> My point is that these OPs are slow and slept, so inline issue won't
>>> improve performance actually for them, and punting to io-wq couldn't
>>> be worse too. On the other side, inline issue may hurt perf because
>>> submission pipeline is blocked when issuing these OPs.
>>
>> That is definitely not true, it really depends on which ops it is. For a
>> lot of them, they don't generally block, but we have to be prepared for
> 
> OK, but fsync/fallocate does block.

They do, but statx, fadvise, madvise, rename, shutdown, etc (basically
all the rest of them) do not for a lot of cases.

-- 
Jens Axboe

