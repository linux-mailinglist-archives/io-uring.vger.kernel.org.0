Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504723A9DFA
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhFPOqo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 10:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbhFPOqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 10:46:43 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EBBC061574
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 07:44:37 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id b14so2558683ilq.7
        for <io-uring@vger.kernel.org>; Wed, 16 Jun 2021 07:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NUpkIPkuLBZbpmv8ycOI8xP/GPpdpeIzjn4UH9JJkzY=;
        b=GuSrZ6cq+7PUQEsH1YYuQFvFe7mMD0xMifr3K9ngiIQUQaZhFQMd2HWzaHO/0uq9jb
         aJ9uyL/9hDC3ETzRsw+s1Y8fxcwPQvO2TUM84QfU6SxcFdhUTZDBWc/wgRt1hWr3ZF87
         s4JQraWvTjIZDazpQT/SnalOh5Fg3Ok4zPsQYnLl0XY74KeVofee3a2lJP87C0Fdvfba
         ojxuKvgD74NDUoAXyomlMt4TFrhaiylhzPjk/Mybxvjp8+b6t+tF1WCpa7kNpOq85ZVR
         nC8pJ2vFMWpxBa23WlMASpHitOUR4cr7eayjwFPG2NW60+GT3VlpT2xt53t2OB2FeH5i
         FIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NUpkIPkuLBZbpmv8ycOI8xP/GPpdpeIzjn4UH9JJkzY=;
        b=O0JFzFtwj8OaA/0pePwqxrB0wQuwqgoZg0N4k4TOB8KdyaMKkw2ayYlrUgFvmQE620
         Ib0UQdEKny/QmrUsPGMKT1vASojXCF3L0AyF3MIn7H/3YernwaD+Ce2BWyWoW3lNwEDP
         Txig2C9to7E+y2oMasRPFdtLQs+2cIyjiCHVPrb4DALXv8m12xpxG6Q7jlkZRiOTriQC
         xDHSFcNbYCg/2oLcVughJu7zd48abMbHVzyZ3gJAsP54w15n7jQdDq1r7/895mxCa0Eq
         b7+yPevxCfwc+KIfNVV2ZZ8H32DVVAVONvy2kTsIFZXIfZM7/2ysJDuFa7VUNtulXAaW
         fEqA==
X-Gm-Message-State: AOAM533aBFq1LUbuUwdBSQujgQBPpLPGg4KP7BdDJ3j59kgULnAbGGrY
        ABooq3CkaZ3oSLeaw56VqS9H8ksO8iygQu7H
X-Google-Smtp-Source: ABdhPJy+zPPoM5W1KVQNd5No4EC0Y4f+S3Zo+hy+azbBHBKHJcrq/i9ZpdLhw2BVO7c+/sUYTa6Hqw==
X-Received: by 2002:a92:2a0a:: with SMTP id r10mr24831ile.274.1623854677273;
        Wed, 16 Jun 2021 07:44:37 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z14sm1259028ilb.48.2021.06.16.07.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 07:44:36 -0700 (PDT)
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
 <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
 <b5b37477-985e-54da-fc34-4de389112365@kernel.dk>
 <4f32f06306eac4dd7780ed28c06815e3d15b43ad.camel@trillion01.com>
 <af2f7aa0-271f-ba70-8c6b-f6c6118e6f1f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6bf916b4-ba6f-c401-9e8b-341f9a7b88f7@kernel.dk>
Date:   Wed, 16 Jun 2021 08:44:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <af2f7aa0-271f-ba70-8c6b-f6c6118e6f1f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/21 8:01 AM, Pavel Begunkov wrote:
> On 6/16/21 2:42 PM, Olivier Langlois wrote:
>> On Tue, 2021-06-15 at 15:51 -0600, Jens Axboe wrote:
>>> Ditto for this one, don't see it in my email nor on the list.
>>>
>> I can resend you a private copy of this one but as Pavel pointed out,
>> it contains fatal flaws.
>>
>> So unless someone can tell me that the idea is interesting and has
>> potential and can give me some a hint or 2 about how to address the
>> challenges to fix the current flaws, it is pretty much a show stopper
>> to me and I think that I am going to let it go...
> 
> It'd need to go through some other context, e.g. task context.
> task_work_add() + custom handler would work, either buf-select
> synchronisation can be reworked, but both would rather be
> bulky and not great.

Indeed - that'd solve both the passing around of locking state which
I really don't like, and make it much simpler. Just use task work for
the re-insert, and you can grab the ring lock unconditionally from
there.

-- 
Jens Axboe

