Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D8F2E8EA4
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 23:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbhACWGj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 17:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbhACWGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 17:06:36 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE20C0613C1
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 14:05:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v1so8620205pjr.2
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 14:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gvh7orPTX7WMTSmjVNbfqYM3ck8Oy67K5UG7jMLc6+c=;
        b=jTq5fZNqyxtyojFy80YtWr53SHb0ksdpv/zhuAMmobJ+ogOZ/opM4jhov2YyIBtP5X
         Jg1OX8ykhWet+ZTsZ3cN4lt/sq455OCQAXzMr2bOtXdaulmy7N/XqoLoBXBO65sOo3+R
         l204cyIQIdoqzzZesd8odDCRXPZKBArQT9iRsbsC3jq9ymw9chbfsxF52gVRaddU6FaT
         uqbteW25n1SrdMaBOJF2YJddRksySig2L+6FJk8rskjzqNlyAzje7/RzfYDHcVYU0GXk
         WQBgu0GQPWa/QxbKGCYn3MCql1IgA66iX8dBLucDlS9adIS0lQNQ/Yma8wBbHDeEOHKQ
         5e9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gvh7orPTX7WMTSmjVNbfqYM3ck8Oy67K5UG7jMLc6+c=;
        b=jH/MFjaMcCLAgv/tCsphPPpsHGQ8V7NzimupvnjSNHBT2JSFI5ivoGZ+pk6shygHVf
         +KpRCaDzciS/ARBu3unALDI6U/9XrVzsyXsQhL880cWqafOch6sCkuaHYJYB4bx1EfSp
         fLizxUFuYi0fIXlSpCU6jghSrhdKRLUaiiRh6q1vqq0Q3gr1iCrqgvKCN37/1n3cV4/r
         uVQ3EZVDThMkSvlL8WG9Fw+aWsgeZaAYJiM+byPCfhdUPuQezoi1i2/u5ci+wwHPegPX
         HFwVyG3/YqCThwFKiBSwYLWuafATpEc4SSK1Oyx8joHf+4fpCRKJNGMy56PU7OegVD/o
         vtcA==
X-Gm-Message-State: AOAM531DB7PxljTA1y5b4HJIeayVfdiIA0feWhvaq0PxrYhHackuea5A
        P8sXvpgNOtCTb2yQAa162xFvOzGk6FmXKw==
X-Google-Smtp-Source: ABdhPJzzZJhvMiYxAY966D2WnmGIkxJRiphZ/u1Vg/GZp4RpkaDn5uxbxEfXwSFtbZIiOf5+KdqCcg==
X-Received: by 2002:a17:90a:f408:: with SMTP id ch8mr27024380pjb.222.1609711555201;
        Sun, 03 Jan 2021 14:05:55 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o193sm48061527pfg.27.2021.01.03.14.05.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jan 2021 14:05:54 -0800 (PST)
Subject: Re: [PATCH 2/4] io_uring: patch up IOPOLL overflow_flush sync
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1609600704.git.asml.silence@gmail.com>
 <716bb8006495b33f11cb2f252ed5506d86f9f85c.1609600704.git.asml.silence@gmail.com>
 <ce841f93-8692-892c-15ce-94c0de5d74e5@kernel.dk>
 <0c1a302a-eec0-6de1-2b6e-c06739d4c70a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f82471b3-3302-7963-6f9e-f6ee0e56bd7c@kernel.dk>
Date:   Sun, 3 Jan 2021 15:05:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0c1a302a-eec0-6de1-2b6e-c06739d4c70a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/3/21 9:29 AM, Pavel Begunkov wrote:
> On 03/01/2021 15:12, Jens Axboe wrote:
>> On 1/2/21 9:06 AM, Pavel Begunkov wrote:
>>> IOPOLL skips completion locking but keeps it under uring_lock, thus
>>> io_cqring_overflow_flush() and so io_cqring_events() need extra care.
>>> Add extra conditional locking around them.
>>
>> This one is pretty ugly. Would be greatly preferable to grab the lock
>> higher up instead of passing down the need to do so, imho.
> I can't disagree with that, the whole iopoll locking is a mess, but
> still don't want to penalise SQPOLL|IOPOLL.
> 
> Splitting flushing from cqring_events might be a good idea. How
> about the one below (not tested)? Killing this noflush looks even
> cleaner than before.

From a quick look, that's much better.

-- 
Jens Axboe

