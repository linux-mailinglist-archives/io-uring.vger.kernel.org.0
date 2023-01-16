Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F15966D0CC
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 22:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbjAPVQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 16:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbjAPVQD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 16:16:03 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CB92BEEC
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:15:52 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id e3so19456390wru.13
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 13:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R6CI3KsSVrTCdXNEngLA04wrofE3VKG5H0V5qCQO0JY=;
        b=IRXNQh3y+6sECrKMUWUPP0nTLU5sYkNoVNUzlkiJ7tqzTQDkE2XUuYstMHPs2RDJaz
         3ium/ZJIjTc3KYwZdyuUoMpDZSpTuHTP9JFgzdfB5cBPOLaoeSJPta930H+bFzyfQY0J
         /YCUaEMBCDi7Aa+Qx5AfNoGJhowC33VjEasBPMj4o6f+A4suWAC4Cy+K4DpY9QLIYF4r
         Hsx5CudpkE0jnisQnxxJ6OZGMc+T5pRJ6SQXPQqaglpPr1CL7lfgPjMraJi1gnM/qea2
         Fi4cbr7APA7i9H7VT8Efyt952IpbHavhJMvlcVelWcXsG9t2GCxTrXrTByQEqV5VfYHg
         GX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6CI3KsSVrTCdXNEngLA04wrofE3VKG5H0V5qCQO0JY=;
        b=bkehFhIZ6ChsI72WEOI2g78gVBIrXT0PCE5VV6r0s5RRw5MRVhsIdDXazf/ThoF5yK
         TUtKTLCTcp/1Jyh8iCfrZLQm0mxZi9GzSI68u6w7UwKjRt3of08WtPlIMADvUNUDq50n
         RjuUVKmjhp5uIaoD9TEJQ1qufwyXJxtlg/hl9w3RxS15T6lxU8vWB4EQqQQvRZXtjvW3
         ZC75059MMPXEwtjnH8zOXblKusEczkmlAgDKK+JBWV9XPzIO4bhePGleIXZIcJNYXoGw
         fI19MGQxs9v8DfolFqE5G9Hgqln2XttLHczLtCzeYjvWzWW933/cHuCo3TwEAAPw6ohk
         9Svg==
X-Gm-Message-State: AFqh2kqC3vr9S+bps6SWZxGz9ikGLDoBdVqpI+UJlnAFbxBUb+qimPnr
        Vs7i6a0UnUN11ESrnuapDIspKPpjr3M=
X-Google-Smtp-Source: AMrXdXtTYx6ZrmI4jt5HTZhP85tXrnojK+JW+twsA0C6UA5xzHVdqzfejXsUZ/RYR1VqsWm6Rgu7xA==
X-Received: by 2002:a5d:6581:0:b0:2bb:dad4:9525 with SMTP id q1-20020a5d6581000000b002bbdad49525mr686870wru.10.1673903750555;
        Mon, 16 Jan 2023 13:15:50 -0800 (PST)
Received: from [192.168.8.100] (92.41.33.8.threembb.co.uk. [92.41.33.8])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6d49000000b002bc8130cca7sm19216466wri.23.2023.01.16.13.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 13:15:50 -0800 (PST)
Message-ID: <cc292524-7dd9-c8d5-aadb-aba4b2af261f@gmail.com>
Date:   Mon, 16 Jan 2023 21:14:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH for-next 1/5] io_uring: return back links tw run
 optimisation
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1673887636.git.asml.silence@gmail.com>
 <6328acdbb5e60efc762b18003382de077e6e1367.1673887636.git.asml.silence@gmail.com>
 <3b01c5b6-9b4c-0f7e-0fdf-67eb7c320bf0@kernel.dk>
 <92413c12-5cd1-7b3b-b926-0529c92a927a@gmail.com>
 <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <427936d0-f62b-3840-6a59-70138d278cb8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 21:04, Jens Axboe wrote:
> On 1/16/23 12:47 PM, Pavel Begunkov wrote:
>> On 1/16/23 18:43, Jens Axboe wrote:
>>> On 1/16/23 9:48 AM, Pavel Begunkov wrote:
>>>> io_submit_flush_completions() may queue new requests for tw execution,
>>>> especially true for linked requests. Recheck the tw list for emptiness
>>>> after flushing completions.
>>>
>>> Did you check when it got lost? Would be nice to add a Fixes link?
>>
>> fwiw, not fan of putting a "Fixes" tag on sth that is not a fix.
> 
> I'm not either as it isn't fully descriptive, but it is better than
> not having that reference imho.

Agree, but it's also not great that it might be tried to be
backported. Maybe adding a link would be nicer?

Link: https://lore.kernel.org/r/20220622134028.2013417-4-dylany@fb.com


>> Looks like the optimisation was there for normal task_work, then
>> disappeared in f88262e60bb9c ("io_uring: lockless task list").
>> DEFERRED_TASKRUN came later and this patch handles exclusively
>> deferred tw. I probably need to send a patch for normal tw as well.
> 
> So maybe just use that commit? I can make a note in the message on
> how it relates.

-- 
Pavel Begunkov
