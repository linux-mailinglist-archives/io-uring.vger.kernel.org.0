Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D9E776370
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbjHIPLM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjHIPLL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:11:11 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74F51BDA
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:11:10 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-686f6231bdeso1803699b3a.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691593870; x=1692198670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ujVnn+wclfDCoEdMFK52Z0Hg6LMOzkhQlsbYMDX7Zc=;
        b=m98bJgTsUvdY0gdK8Ww0DZaadpiNKOS9cthH6HTVgjNHRjEmC/cPR3tpZWkIpHbb76
         yBfTpOOvuxNCHjNkiRWAh6ymhQCJLD+B+XDX5uNJw8NkGZ6rDDQ8W6Hzrg+yk/mRPvXK
         c0f6OA3PxxQ1vcWVMtoz1x1SGgMROg0yqw5D3J2lKLG9qrWtOnEElOkTD87LLCuqMw60
         HMFg97/VJUtmrZLLtJTpXwgg4PBR6eCQzWI2prQbS/kxnyv0BlsJagBlF45hru+pkyyT
         YjYtgCCTC61WiQ5bsAVv2upvLQuEwUPYe1PtE4ctflxGZ37iJlM6H+P/66y3ro3mBONT
         9T8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691593870; x=1692198670;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ujVnn+wclfDCoEdMFK52Z0Hg6LMOzkhQlsbYMDX7Zc=;
        b=MT8EuygSe+C1gfb20XebKAN6e/CTe8KR+gC0pUZvtoJoMrB8b9+bWT7jYqz0x3rLYU
         s7d007MiFNaPZtA/DF3N1Ge0w7vlkJz8UyZ1HbyQ97Bsec5B8TQkKvmkG+3Szs4DCofJ
         z6aLoaK4ugB4L1RHNz2A7EFG/1j5PLUm+zdwrCQF79gSbby6Hrc7TolQUcN4skmFgs2d
         3M2ZbmUn8ccMce8YYYnOcAYouM7GP/UPp3bHIyYRrRn6hVrqxmbHtoHpNtGceskFsxEi
         qqpmOCC0ttXkgzT679gCSlwPHKLp0/LIJ1o+8L0rL20J8RCUNPF4XGpwNUnIzqvv8YTy
         Jjkw==
X-Gm-Message-State: AOJu0Yy4VHcfCE5c2XeeYZPzSJux8ulmkCwITDlNbYX71ZdmJu4eYi6U
        eqRA3h/OajwpiDdP+8ZAVT7BqxG3EKLOLaGCt9g=
X-Google-Smtp-Source: AGHT+IEnolU+PaPLfc3X68ZEQWVNLrFCP2l5eOMgcprs1MXtlRkSX9td0R6LnNvcEQ7WykbcKP1TuA==
X-Received: by 2002:a05:6a00:d82:b0:677:3439:874a with SMTP id bf2-20020a056a000d8200b006773439874amr3196674pfb.3.1691593870154;
        Wed, 09 Aug 2023 08:11:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n5-20020aa79045000000b00686ec858fb0sm10084064pfo.190.2023.08.09.08.11.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:11:09 -0700 (PDT)
Message-ID: <0201ff9b-357f-4391-ae83-5920f39d68c0@kernel.dk>
Date:   Wed, 9 Aug 2023 09:11:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de
References: <20230802231442.275558-1-axboe@kernel.dk>
 <20230802231442.275558-6-axboe@kernel.dk>
 <20230809-ballkontakt-schule-bc15814d31e4@brauner>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230809-ballkontakt-schule-bc15814d31e4@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 5:27 AM, Christian Brauner wrote:
>> +int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct io_waitid_async *iwa;
>> +	unsigned int f_flags = 0;
>> +	int ret;
>> +
>> +	if (io_alloc_async_data(req))
>> +		return -ENOMEM;
>> +
>> +	iwa = req->async_data;
>> +	iwa->req = req;
>> +
>> +	ret = kernel_waitid_prepare(&iwa->wo, iw->which, iw->upid, &iw->info,
>> +					iw->options, NULL, &f_flags);
> 
> It seems you're not really using @f_flags at all so I'd just not bother
> exposing it in kernel_waitid_prepare(). I think the following (untested)
> will let you avoid all this:

That's a good idea, I'll update it to get rid of the f_flags. Thanks!

-- 
Jens Axboe

