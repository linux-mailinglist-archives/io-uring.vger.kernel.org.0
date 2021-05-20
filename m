Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6F4389A96
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 02:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhETAdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 20:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETAdk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 20:33:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0844AC061574
        for <io-uring@vger.kernel.org>; Wed, 19 May 2021 17:32:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso2694708pjb.0
        for <io-uring@vger.kernel.org>; Wed, 19 May 2021 17:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=emobrien-com.20150623.gappssmtp.com; s=20150623;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LBxcEvHC6njN/uXJyRt14tr46XTauo627My7+d7NhS0=;
        b=eqDDZP0UJmOFnAo1MMxyiTRuW6/dAFiBmVGHS2UNMFgmSOrIf7T634l+EIAGWxikmp
         qli04IQADHelLdtqUgZWV5RlIwMROMOnNx9wQ4Q8IvmikhSSNtJZpmgWYW6CKD1nMak9
         XWelF5LxCaeLcRfj+RU+zW1qebfk2FH7zWfwbwD45209c6PSrFJy6yGO0QLa3WzwSxS9
         M6dJcv3IzCMCo8qOmIVBJr7MgHceaUJ/u0rBqC6p6gs/g9WZRdATqb4ZwtyUH4xEhDiL
         3bs4D7cMJVJ+eBmuAkd0+uE3zyCA9z5TUM9fFIWVSbXJ0EgNHOz5+uNSjNGO+xscmbTC
         GPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LBxcEvHC6njN/uXJyRt14tr46XTauo627My7+d7NhS0=;
        b=WUBE254rI8m3FqfcuKRtDt8YWHp4p6vyNPguVTfm8NF2mLBK9zxEqwILIKOHXwo5Rx
         ND1C+3DoDcZYyF8fJQbjUo/FCs+ARp0Yq+zAaX07wLXohViQLzE15ZneX6Y6uvNFm/Wp
         2/99JoKlhxsmo+aGnvuKBuj2Y12MDNPBzTG7SMFbIoZ3PudIkZYljnsEc+TN9tH4W2ae
         5I/KpL56AsllQyjBK1rZLARe5pILnwY5Oy5DhZFbvN2X6kSCvdJC1B8B38qYzkkEocPS
         NPhkGHf8w3xkFoB0Q4+A6uOK/Gf+EHE0F7hlN3e3ynpjRT0924CPqlmBHXuBXe1Yh+Lu
         a5Lw==
X-Gm-Message-State: AOAM532YEsAVTGBjwk38hVTRccgET2/0M3dJO3jueAFmkT+mDWGVc8g4
        6FmaT4pexLHXCCa4W39o/hpC0yYvM9oCvA==
X-Google-Smtp-Source: ABdhPJy4GejmNZ25QBRvH+huewVFKmZEfoHT0F80lRnetpBf0IGO5jtZwbv7RCKTBGrvdRjRWknNJg==
X-Received: by 2002:a17:902:dccc:b029:f1:c207:b10b with SMTP id t12-20020a170902dcccb02900f1c207b10bmr2580739pll.41.1621470739236;
        Wed, 19 May 2021 17:32:19 -0700 (PDT)
Received: from [59.191.218.23] (dyn-59-191-218-23.its.monash.edu.au. [59.191.218.23])
        by smtp.gmail.com with ESMTPSA id b65sm409764pga.83.2021.05.19.17.32.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 17:32:18 -0700 (PDT)
Subject: Re: Confusion regarding the use of OP_TIMEOUT
References: <af3b1313-2e0a-16fc-facd-aa15dc69f64e@emobrien.com>
To:     io-uring@vger.kernel.org
From:   Alex O'Brien <alex@emobrien.com>
X-Forwarded-Message-Id: <af3b1313-2e0a-16fc-facd-aa15dc69f64e@emobrien.com>
Message-ID: <3274efc5-ee33-746a-925d-9780e579ac9a@emobrien.com>
Date:   Thu, 20 May 2021 10:32:16 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <af3b1313-2e0a-16fc-facd-aa15dc69f64e@emobrien.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 5/20/21 5:51 AM, Drew DeVault wrote:
> Hi folks! I'm trying to use IO_TIMEOUT to insert a pause in the middle
> of my SQ. I set the off (desired number of events to wait for) to zero,
> which according to the docs just makes it behave like a timer.
> 
> Essentially, I want the following:
> 
> [operations...]
> OP_TIMEOUT
> [operations...]
> 
> To be well-ordered, so that the second batch executes after the first.
> To accomplish this, I've tried to submit the first operation of the
> second batch with IO_DRAIN, which causes the CQE to be delayed, but
> ultimately it fails with EINTR instead of just waiting to execute.
> 
> I understand that the primary motivator for OP_TIMEOUT is to provide a
> timeout functionality for other CQEs. Is my use-case not accomodated by
> io_uring?
> 

Have you tried setting `IO_DRAIN` on the timeout operation itself?

-- 
- Alex O'Brien
<alex@emobrien.com>
