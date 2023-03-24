Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935836C88FC
	for <lists+io-uring@lfdr.de>; Sat, 25 Mar 2023 00:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCXXGM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 19:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCXXGL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 19:06:11 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4191C31B
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 16:06:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso6490712pjc.1
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 16:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679699162; x=1682291162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0R2Qo/DevL3S7I07sZXxzUcEeTRDJWKIO1fp4rnwmMc=;
        b=xGEScFLFKDrqmP64ablG0Mu1PzbxP/P9VePi2vdNTpr4ldLpdwx3BWB6786hJMLOlY
         SYMdFyeHfJSQcXA5nztoZ3LafsZUBIjDkSkSi/YzDKaCkK//slEFf3VTvqOLJwBRYAzV
         BEX+dnmRu9pUBAPwihNdHpBXwAtbNIjB4gRa/6fhs2BlroYWZ1nZN0uYBx2bsQIy53TQ
         Ipno8v5ZQlcl0Td8Gdw1E6TSZgUqgju9NgK1fERp3TE0vO9c2MQZbZIYue7t98ARv4Zz
         Ow+2QITe4xKSdyoNv9GohHEsLz790670STsOZfR8MBWomZnNaM9oI5dQIi2Q7w8GgyOi
         ZV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679699162; x=1682291162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0R2Qo/DevL3S7I07sZXxzUcEeTRDJWKIO1fp4rnwmMc=;
        b=bXIDKqebGAV0wm2iZgRILnVv1/L6uvVYpEQuHekiFKi8DmdM5Xm/HRCF4AKRbIDKlC
         BkA8HKa9TkYrcLeBgU7+0gavrqhfpjrSkmmIRbCt6hCauC6Z9xVKB5EGrqGa8AYG4QRT
         aAplHfygHX45p2gqwtANDbtMwuMASmJ0Yqzwf8R8xJJn5O2jyDGo2EYfPw4l63EgSMWt
         LTcEFcn+zRk9tkilFTkRZOcTldbgxjp7vnGLWiWJ29l7OgAaEa2C+1jwBV4ihm7sZE+z
         C0CP54GyeNRaKOKmbJ+Na/HszFTR5TK2D42dJl/HDE2RfH29tZepgR8GgeLm66j5QF55
         XJjQ==
X-Gm-Message-State: AO0yUKXlCEJoxxKKGpDcloTfP0uXTgWQZIH/g2VKiCwM6iq9KrY9i42/
        ePsGNpND/rUgq4EU2fYAZ2D0EwvX1te6x9HLOgZ0fg==
X-Google-Smtp-Source: AK7set+aox7CHNUq1XODPth3ZPY674jFuwufbcjAt3NPnlOMXKCJZgsc3iV7JOPyAPoWVZ2iux3ZYQ==
X-Received: by 2002:a05:6a20:748c:b0:cd:fc47:dd73 with SMTP id p12-20020a056a20748c00b000cdfc47dd73mr4856089pzd.2.1679699161647;
        Fri, 24 Mar 2023 16:06:01 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f62-20020a17090a704400b00234afca2498sm380080pjk.28.2023.03.24.16.06.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 16:06:01 -0700 (PDT)
Message-ID: <9c3473b7-8063-4d14-1f8b-7a0e67979cf4@kernel.dk>
Date:   Fri, 24 Mar 2023 17:06:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] io_uring/rw: transform single vector readv/writev into
 ubuf
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <43cb1fb7-b30b-8df1-bba6-e50797d680c6@kernel.dk>
 <ZB4nJStBSrPR9SYk@ovpn-8-20.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZB4nJStBSrPR9SYk@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/24/23 4:41?PM, Ming Lei wrote:
> On Fri, Mar 24, 2023 at 08:35:38AM -0600, Jens Axboe wrote:
>> It's very common to have applications that use vectored reads or writes,
>> even if they only pass in a single segment. Obviously they should be
>> using read/write at that point, but...
> 
> Yeah, it is like fixing application issue in kernel side, :-)

It totally is, the same thing happens all of the time for readv as well.
No amount of informing or documenting will ever fix that...

Also see:

https://lore.kernel.org/linux-fsdevel/20230324204443.45950-1-axboe@kernel.dk/

with which I think I'll change this one to just be:

	if (iter->iter_type == ITER_UBUF) {
		rw->addr = iter->ubuf;
		rw->len = iter->count;
	/* readv -> read distance is the same as writev -> write */
	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
			(IORING_OP_WRITE - IORING_OP_WRITEV));
		req->opcode += (IORING_OP_READ - IORING_OP_READV);
	}

instead.

We could also just skip it completely and just have liburing do the
right thing if io_uring_prep_readv/writev is called with nr_segs == 1.
Just turn it into a READ/WRITE at that point. If we do that, and with
the above generic change, it's probably Good Enough. If you use
READV/WRITEV and you're using the raw interface, then you're on your
own.

>> +	rw->addr = (unsigned long) iter->iov[0].iov_base;
>> +	rw->len = iter->iov[0].iov_len;
>> +	iov_iter_ubuf(iter, ddir, iter->iov[0].iov_base, rw->len);
>> +	/* readv -> read distance is the same as writev -> write */
>> +	BUILD_BUG_ON((IORING_OP_READ - IORING_OP_READV) !=
>> +			(IORING_OP_WRITE - IORING_OP_WRITEV));
>> +	req->opcode += (IORING_OP_READ - IORING_OP_READV);
> 
> It is a bit fragile to change ->opcode, which may need matched
> callbacks for the two OPs, also cause inconsistent opcode in traces.
> 
> I am wondering why not play the magic in io_prep_rw() from beginning?

It has to be done when importing the vec, we cannot really do it in
prep... Well we could, but that'd be adding a bunch more code and
duplicating part of the vec import.

-- 
Jens Axboe

