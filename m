Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DF875CCB3
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjGUPyB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjGUPyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:54:00 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7805835A3
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:53:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so25569039f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689954812; x=1690559612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/9hyTp7fOzdD0yzYoPZH4AFmU36NKxBnWFAxVSnj3Us=;
        b=xsjnA3ZXKpeHIgalJEpccQDNskHqmilcDFUenKBSUHGXZg8hSTrIX72U4oz8o6SQaB
         TUoe+8+FncuI3Yk9fay5q0YjxgaWy0BDmNzFN8QThxfkUNghmFygS+a2jDEkfYb5UrFc
         QKRQZAhzeR+7QN4AbJ6vjqUspEkpvqFp0mi1w9wwYxBPHyW46NZSBiTtNcuG+Q5cPG9x
         tfU7LqbdpQGA11QN7ik0KrZIdq0L/jgkQNUotrdaDiPxMCX+og88O6bq3KQBZIMi2AvI
         ugoNBSfjtdJiwdFAfSYUnUA0JFYG72sOqrfN5K77cVS9sEznL5yF9KTA2hdIukUncX+D
         Ok2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689954812; x=1690559612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9hyTp7fOzdD0yzYoPZH4AFmU36NKxBnWFAxVSnj3Us=;
        b=l1syOLstAEMhY12t95YLQT8KnWd10GDG4hc2GJNITPMyJ4sY2BOQi43rZlhOtt/ffy
         j2noRiuRw7zgploSqw8suIAzneHTO6J+9O58hokjLwJs6pEmgT5zMSx+oXgKxXT6HwtH
         R0YefSJ31dFPtFWtEO+wyxVFHnhZc9JlF/6dsJYSxiQ5A1VS0jfFzD0wYXBbnuMEoawn
         VYLYUKN1ZsnwJhHzwOHKbx25/yAbRNh+oZaqd2Yg/3S36SrQRRurPamr6agitkZtJcaN
         xf+IuHovvfJusnYoeQnaD38COyo0DkZEUSmxuFKEQsHtkrqGaEhocV93bLlF6r40Sk/1
         oc1A==
X-Gm-Message-State: ABy/qLZzBLVPu344uUsQKF6kPgV5JRfLW/E/AX4tlejxi/79HtauEUdv
        DX7cGlYmqj1E/uTc/HiRDAVb/1sPNTOpDByZrHk=
X-Google-Smtp-Source: APBJJlFtSyv8u6LQLX+xJfuB2BGp+wxBsOGKWvtfCtHcHBqxpxSbGALYr567s1ARPmHUC4VyxOjnVg==
X-Received: by 2002:a05:6602:4011:b0:788:479f:171b with SMTP id bk17-20020a056602401100b00788479f171bmr2284647iob.0.1689954811975;
        Fri, 21 Jul 2023 08:53:31 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d11-20020a056602328b00b007871d55ce52sm1156083ioz.3.2023.07.21.08.53.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:53:31 -0700 (PDT)
Message-ID: <6165135b-0520-e1fa-04ef-598449a02841@kernel.dk>
Date:   Fri, 21 Jul 2023 09:53:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/8] fs: add IOCB flags related to passing back dio
 completions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-7-axboe@kernel.dk>
 <20230721154837.GO11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721154837.GO11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 9:48?AM, Darrick J. Wong wrote:
> On Thu, Jul 20, 2023 at 12:13:08PM -0600, Jens Axboe wrote:
>> Async dio completions generally happen from hard/soft IRQ context, which
>> means that users like iomap may need to defer some of the completion
>> handling to a workqueue. This is less efficient than having the original
>> issuer handle it, like we do for sync IO, and it adds latency to the
>> completions.
>>
>> Add IOCB_DIO_DEFER, which the issuer can set if it is able to safely
>> punt these completions to a safe context. If the dio handler is aware
>> of this flag, assign a callback handler in kiocb->dio_complete and
>> associated data io kiocb->private. The issuer will then call this handler
>> with that data from task context.
>>
>> No functional changes in this patch.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/fs.h | 34 ++++++++++++++++++++++++++++++++--
>>  1 file changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 6867512907d6..2c589418a078 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -338,6 +338,20 @@ enum rw_hint {
>>  #define IOCB_NOIO		(1 << 20)
>>  /* can use bio alloc cache */
>>  #define IOCB_ALLOC_CACHE	(1 << 21)
>> +/*
>> + * IOCB_DIO_DEFER can be set by the iocb owner, to indicate that the
>> + * iocb completion can be passed back to the owner for execution from a safe
>> + * context rather than needing to be punted through a workqueue. If this
>> + * flag is set, the completion handling may set iocb->dio_complete to a
>> + * handler, which the issuer will then call from task context to complete
>> + * the processing of the iocb. iocb->private should then also be set to
>> + * the argument being passed to this handler. Note that while this provides
> 
> Who should be setting iocb->private?  Can I suggest rewording this to:
> 
> "If this flag is set, the bio completion handling may set
> iocb->dio_complete to a handler function and iocb->private to context
> information for that handler.  The issuer should call the handler with
> that context information from task context to complete the processing of
> the iocb."
> 
> Assuming I've understood what this does from the next patch? :)

Yep this is definitely better - thanks, I'll update it!

>> + * a task context for the dio_complete() callback, it should only be used
>> + * on the completion side for non-IO generating completions. It's fine to
>> + * call blocking functions from this callback, but they should not wait for
>> + * unrelated IO (like cache flushing, new IO generation, etc).
>> + */
>> +#define IOCB_DIO_DEFER		(1 << 22)
> 
> Sorry to nitpick names here, but "defer" feels a little vague to me.
> Defer what?  And to whom?
> 
> This flag means "defer iocb completion to the caller", right?  If so,
> wouldn't this be better named IOCB_DIO_CALLER_COMP?

That is probably better indeed. Naming is hard! CALLER_COMP or
ISSUER_COMP would be better and more descriptive. I'll go with your
suggestion.

>>  /* for use in trace events */
>>  #define TRACE_IOCB_STRINGS \
>> @@ -351,7 +365,8 @@ enum rw_hint {
>>  	{ IOCB_WRITE,		"WRITE" }, \
>>  	{ IOCB_WAITQ,		"WAITQ" }, \
>>  	{ IOCB_NOIO,		"NOIO" }, \
>> -	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }
>> +	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
>> +	{ IOCB_DIO_DEFER,	"DIO_DEFER" }
>>  
>>  struct kiocb {
>>  	struct file		*ki_filp;
>> @@ -360,7 +375,22 @@ struct kiocb {
>>  	void			*private;
>>  	int			ki_flags;
>>  	u16			ki_ioprio; /* See linux/ioprio.h */
>> -	struct wait_page_queue	*ki_waitq; /* for async buffered IO */
>> +	union {
>> +		/*
>> +		 * Only used for async buffered reads, where it denotes the
>> +		 * page waitqueue associated with completing the read. Valid
>> +		 * IFF IOCB_WAITQ is set.
>> +		 */
>> +		struct wait_page_queue	*ki_waitq;
>> +		/*
>> +		 * Can be used for O_DIRECT IO, where the completion handling
>> +		 * is punted back to the issuer of the IO. May only be set
>> +		 * if IOCB_DIO_DEFER is set by the issuer, and the issuer must
>> +		 * then check for presence of this handler when ki_complete is
>> +		 * invoked.
> 
> Might want to reiterate in the comment that kiocb.private should be
> passed as @data.

OK, will do.

-- 
Jens Axboe

