Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBC96EE4C7
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjDYPaX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 11:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbjDYPaW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 11:30:22 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99349E67
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:30:18 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so44399232a12.1
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 08:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682436617; x=1685028617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ppfU5DvOuc7Poy6A4oo8ZOsnKQB/noqi5Y+xMHdvI7Q=;
        b=YJD0gNJm7YzmD05Y8whmftwwn/f3eNlrwgK5gaLfk1Z6tk+dTm1MkbowNveXdSAAmP
         1CFXvmRpmTGLGkQqle+blk9gtkO1rxfE87FqI1666J1Z2Kcsz1lMxGb6ufgFTjH+qSgr
         SOBsMK71xxOR6l4hBE5Gb3B3C7C6xYPpBsKm8U5Hlhfbe+NT+WqyrPN1FGnmMlBFLLxm
         oEqc0N3SVMMEX3GePI4JiEm2OVeOhcsZwXe3mSptWd6YRuTjvs8s7y2hTuFOWkn7Xw0a
         uQNb/gNQ9FYtNS7/IYLF/6jvn/24E7dnaX+W/JNfdqh1FxksS5wEjkMNHrYBmNhUdZq8
         o7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682436617; x=1685028617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ppfU5DvOuc7Poy6A4oo8ZOsnKQB/noqi5Y+xMHdvI7Q=;
        b=HBtHCPMJ3J/ImlFWooen1tGlc30J+U4fufJFJbKV1JaG2STkDabj+8VsvRXdBCp/9U
         NA9qq4SW+mLFPSJIPQ1tvkWj9UG+CHipoRPpXlRcZ8B3xD6uXvpRdP2g1CYxGfCsX6sZ
         9anKlAdcGxCeMM9lLV918SNMvr1erQ0xaHry5ZRgJCbaAvRCcdYFZcz4Kopt2J5zu8PJ
         XJ58FtGltpKCXaf646djfVc2BYg8lyhkgrN1LYhy6nIok+6DIVXP7srmFtt2gld7ub09
         VyS85iin/DNlELFNrjqZ+grr/eLr2Zuq0rMi60FaZ6z5CIiXddgV3kIwyieESGusNEyU
         oFyw==
X-Gm-Message-State: AAQBX9fq8OJFg6L1KT71KiSo3SWtojxNcYlvhObpYfe9XbKK7fuNjNng
        xy4KMvyhye8DUYqwPqhDvpw=
X-Google-Smtp-Source: AKy350anvFIDI1r48+t78jbZy5bnVyYTTHmwVCawJr780M+ghN7/3iBsm7kJXAHjRr3hgCKmv5B5kg==
X-Received: by 2002:a17:907:9894:b0:94e:6eb3:abc4 with SMTP id ja20-20020a170907989400b0094e6eb3abc4mr14209586ejc.4.1682436616784;
        Tue, 25 Apr 2023 08:30:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:7aec])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709066d4d00b0094a9b9c4979sm6857007ejt.88.2023.04.25.08.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 08:30:16 -0700 (PDT)
Message-ID: <414392f2-3980-71fa-fa90-294085f156ee@gmail.com>
Date:   Tue, 25 Apr 2023 16:28:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Hao Xu <hao.xu@linux.dev>
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
 <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
 <ZEclhYPobt94OndL@ovpn-8-24.pek2.redhat.com>
 <478df0f7-c167-76f3-3fd8-9d5771a44048@kernel.dk>
 <ZEc3WttIofAqFy+b@ovpn-8-24.pek2.redhat.com>
 <a1c8d37f-ca21-3648-9a37-741e7519650b@kernel.dk>
 <ZEc/5Xyqvu2WkWyk@ovpn-8-24.pek2.redhat.com>
 <0e5910a9-d776-cdea-1852-edd995f93dc8@kernel.dk>
 <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZEfmzALXP9vqWkOV@ovpn-8-24.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/23 15:42, Ming Lei wrote:
> On Tue, Apr 25, 2023 at 07:31:10AM -0600, Jens Axboe wrote:
>> On 4/24/23 8:50?PM, Ming Lei wrote:
>>> On Mon, Apr 24, 2023 at 08:18:02PM -0600, Jens Axboe wrote:
>>>> On 4/24/23 8:13?PM, Ming Lei wrote:
>>>>> On Mon, Apr 24, 2023 at 08:08:09PM -0600, Jens Axboe wrote:
>>>>>> On 4/24/23 6:57?PM, Ming Lei wrote:
>>>>>>> On Mon, Apr 24, 2023 at 09:24:33AM -0600, Jens Axboe wrote:
>>>>>>>> On 4/24/23 1:30?AM, Ming Lei wrote:
>>>>>>>>> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>>>>>>>>>> Add an opdef bit for them, and set it for the opcodes where we always
>>>>>>>>>> need io-wq punt. With that done, exclude them from the file_can_poll()
>>>>>>>>>> check in terms of whether or not we need to punt them if any of the
>>>>>>>>>> NO_OFFLOAD flags are set.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>> ---
>>>>>>>>>>   io_uring/io_uring.c |  2 +-
>>>>>>>>>>   io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>>>>>>>>>   io_uring/opdef.h    |  2 ++
>>>>>>>>>>   3 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>
>>>>>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>>>>>> index fee3e461e149..420cfd35ebc6 100644
>>>>>>>>>> --- a/io_uring/io_uring.c
>>>>>>>>>> +++ b/io_uring/io_uring.c
>>>>>>>>>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>>>>>   		return -EBADF;
>>>>>>>>>>   
>>>>>>>>>>   	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>>>>>>>>>> -	    (!req->file || !file_can_poll(req->file)))
>>>>>>>>>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>>>>>>>>>   		issue_flags &= ~IO_URING_F_NONBLOCK;
>>>>>>>>>
>>>>>>>>> I guess the check should be !def->always_iowq?
>>>>>>>>
>>>>>>>> How so? Nobody that takes pollable files should/is setting
>>>>>>>> ->always_iowq. If we can poll the file, we should not force inline
>>>>>>>> submission. Basically the ones setting ->always_iowq always do -EAGAIN
>>>>>>>> returns if nonblock == true.
>>>>>>>
>>>>>>> I meant IO_URING_F_NONBLOCK is cleared here for  ->always_iowq, and
>>>>>>> these OPs won't return -EAGAIN, then run in the current task context
>>>>>>> directly.
>>>>>>
>>>>>> Right, of IO_URING_F_NO_OFFLOAD is set, which is entirely the point of
>>>>>> it :-)
>>>>>
>>>>> But ->always_iowq isn't actually _always_ since fallocate/fsync/... are
>>>>> not punted to iowq in case of IO_URING_F_NO_OFFLOAD, looks the naming of
>>>>> ->always_iowq is a bit confusing?
>>>>
>>>> Yeah naming isn't that great, I can see how that's bit confusing. I'll
>>>> be happy to take suggestions on what would make it clearer.
>>>
>>> Except for the naming, I am also wondering why these ->always_iowq OPs
>>> aren't punted to iowq in case of IO_URING_F_NO_OFFLOAD, given it
>>> shouldn't improve performance by doing so because these OPs are supposed
>>> to be slow and always slept, not like others(buffered writes, ...),
>>> can you provide one hint about not offloading these OPs? Or is it just that
>>> NO_OFFLOAD needs to not offload every OPs?
>>
>> The whole point of NO_OFFLOAD is that items that would normally be
>> passed to io-wq are just run inline. This provides a way to reap the
>> benefits of batched submissions and syscall reductions. Some opcodes
>> will just never be async, and io-wq offloads are not very fast. Some of
> 
> Yeah, seems io-wq is much slower than inline issue, maybe it needs
> to be looked into, and it is easy to run into io-wq for IOSQE_IO_LINK.

There were attempts like this one from Hao (CC'ed)

https://lore.kernel.org/io-uring/20220627133541.15223-5-hao.xu@linux.dev/t/

Not sure why it got stalled, but maybe Hao would be willing
to pick it up again.

-- 
Pavel Begunkov
