Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC80A776461
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjHIPuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjHIPuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:50:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389941BD9
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:50:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6879986a436so1105406b3a.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691596206; x=1692201006;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2aEIthl5ckdRc01ibx7KFAC/m43ueg+7IHkoehxVzE=;
        b=aqZ55YRA1dIa8ucw12kFqpkATdgSYzDgQEYOySU4+N6uz7JlHsG5/3+0BomwUsS3JZ
         joTW1iJ94fP9vGKupTMNB8AAPTdP8g1jnxruQPxOLzlZKlT0c3qhh9q4KwJPtSe69TjE
         r/6H5WHTN4ZQM0+9XgDz0Xlb//pWJ5TTX20eXoF9gnYzXzO1hKkaip2EQEt/VGyEu7Ps
         asYBVlrR27WbpkmYtsMk8FcibC5Cv37FmQjx+jzOzgXuJRErFH/7YFLskkHl6eGe1E3S
         ccF7VAeuZ2H6OkhahyXLZTNUESwthzQa4/UKMf8dCr8Y7W0Vpmju2Vi1aLfoPQJAon82
         qleA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691596206; x=1692201006;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2aEIthl5ckdRc01ibx7KFAC/m43ueg+7IHkoehxVzE=;
        b=E79pwHpuWyAY7UVusSlNm05QO6yd7aqnxKdLs1KYQebVQZhmVskEDOY/FexCxasQLA
         0tqQHjMMpli6ZAOHoT6gumuHSRacow+fgGXVmKKj2orxxA6t5JL/im649L/yAK0LdpKS
         usgUeAgufqocT0VPIla79SrFzEi/YPyyQ0he5z85lGaUGmbFbIxhuVg2jhp2lbXaJC3x
         ScYlNO2N8tm5snh8zv2tRpq7gF6/h++jkTyXNIXQmxaZqCJ6ZhEKVETCeuladMQCMvwa
         fqH+AVgtSQ3EF+DDeo3SlhcLq1S/Xfi0En7w+crzVAt7w2OEmNTyNCnMiGO5/gx+6FT6
         zQ5Q==
X-Gm-Message-State: AOJu0YzcwvZf1Dkb2QtNXRaoFDXIYvcabBEPuH7WFGRENewBZj3SmjX2
        QtMBA0c4vMFsrcsppfSk4juNB1g5Greir7PomUo=
X-Google-Smtp-Source: AGHT+IGFpOkH4XkmS2bXQ7JPUQJtwzi6JDzpowaHgJtKEwsLU9GTg9AUEZeeODCa62sFihKHh9VQnQ==
X-Received: by 2002:a05:6a00:124a:b0:686:b990:560f with SMTP id u10-20020a056a00124a00b00686b990560fmr3468806pfi.2.1691596205632;
        Wed, 09 Aug 2023 08:50:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y7-20020aa78547000000b006661562429fsm10442621pfn.97.2023.08.09.08.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 08:50:04 -0700 (PDT)
Message-ID: <909349d4-af18-4001-828f-fccfc3f4e0e6@kernel.dk>
Date:   Wed, 9 Aug 2023 09:50:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
 <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
 <b2b63fdc-d683-aaa1-8938-01665f99713a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b2b63fdc-d683-aaa1-8938-01665f99713a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 9:38 AM, Pavel Begunkov wrote:
> On 8/9/23 16:30, Jens Axboe wrote:
>> On 8/9/23 9:20 AM, Pavel Begunkov wrote:
>>> Don't keep spinning iopoll with a signal set. It'll eventually return
>>> back, e.g. by virtue of need_resched(), but it's not a nice user
>>> experience.
>>
>> I wonder if we shouldn't clean it up a bit while at it, the ret clearing
>> is kind of odd and only used in that one loop? Makes the break
>> conditions easier to read too, and makes it clear that we're returning
>> 0/-error rather than zero-or-positive/-error as well.
> 
> We can, but if we're backporting, which I suggest, let's better keep
> it simple and do all that as a follow up.

Sure, that's fine too. But can you turn it into a series of 2 then, with
the cleanup following?

-- 
Jens Axboe

