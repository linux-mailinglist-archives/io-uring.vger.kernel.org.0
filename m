Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2A3B2404
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 01:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWXmW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 19:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhFWXmV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 19:42:21 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6C9C061574;
        Wed, 23 Jun 2021 16:40:01 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o22so1757577wms.0;
        Wed, 23 Jun 2021 16:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dIcMIKiqgju7ISXHt5Sf7jt9PfPhvTF5fdN3Qy2UJsU=;
        b=Bscv8COquz6oOXtYPkM82AFLwQ4HLPDrGR15Ksn5WmHl67ROgBeViE/NpaBnXPAy7L
         LL/6lC2SZFXvL+50PpWWzo35GqzWDuJg2KSy/gPOcPNAb7b7yX0HHVWUjw4pLscGYzJV
         pj06iRfaPLjMx0olGsvLwloIUXinqinKA5OhE3u01/voB2byrKGvcMIzsB1Q8i7r6BEM
         j7g5OtXNXhknSkUscwJkpdYyAaKMhtmBBHUfxl/DFz+i8PtRQKQ9a2iBenFGFI1em4gX
         SZmLwrdkhbsRmqKY93Sq+q67th8MMUSK3iGxAsDomJlZ6hfUM3oYBv8f3/+3cE1ntxgb
         ghWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dIcMIKiqgju7ISXHt5Sf7jt9PfPhvTF5fdN3Qy2UJsU=;
        b=jbjoWAMYpzSodKYf29D89O1Zz6wsndtVBfpcrLNmQWzQyYhO0sNm30CG9p4dE0KOHQ
         Nzsfs1iiJBk1uyiBSarG8Xxc4gS4LMBqlV3/HozYCi7mOXUhbqRbzKlVffhd9/eRJHn5
         186CQaK8c+WFNnEzCIsGFAvgTQXs5IoB7DY2SZ6vafaHieUmmwNFbHq3UTm9wjrz/9o4
         Bk2fqHWfQjU9kJlxYYCDTeESqslY3wUt0eDHQJN1Qp+f1GZ9M4RhzHL8VDf26NKSD6eE
         ii9vpPcvqtU6W9lMMBQ4n/6xKdL+BAV4J8C27jrUn11Ko6kEr0z+XVXywJytyelaC7z1
         GoGw==
X-Gm-Message-State: AOAM530/oczfoMiLBAvgIKfr0KAJvC9dzdqD4sQpr3ZnXsHdgKICfnGC
        yfGe4Cru17ZE2OZi7HxZ/g96Ajv0A5TVV/hu
X-Google-Smtp-Source: ABdhPJwO5cUNQP5ldlLTIVuWHKD1YVgqfnNS3SOfaWuXlVUo0Yeg0KgdMlZ7BtKJqd/XirmwDtAm1Q==
X-Received: by 2002:a7b:cc92:: with SMTP id p18mr681984wma.93.1624491600385;
        Wed, 23 Jun 2021 16:40:00 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id y66sm1159957wmy.39.2021.06.23.16.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 16:39:59 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1624473200.git.olivier@trillion01.com>
 <b401640063e77ad3e9f921e09c9b3ac10a8bb923.1624473200.git.olivier@trillion01.com>
 <b8b77ef8-6908-6446-5245-5dbd8fa7cfd7@gmail.com>
 <6a566122-c4b2-6594-cc94-c578988d3f80@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 2/2] io_uring: Create define to modify a SQPOLL
 parameter
Message-ID: <8f4c6fad-ff01-4b3a-a0d8-06717af5095c@gmail.com>
Date:   Thu, 24 Jun 2021 00:39:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6a566122-c4b2-6594-cc94-c578988d3f80@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 11:24 PM, Jens Axboe wrote:
> On 6/23/21 4:14 PM, Pavel Begunkov wrote:
>> On 6/23/21 7:50 PM, Olivier Langlois wrote:
>>> The magic number used to cap the number of entries extracted from an
>>> io_uring instance SQ before moving to the other instances is an
>>> interesting parameter to experiment with.
>>>
>>> A define has been created to make it easy to change its value from a
>>> single location.
>>
>> It's better to send fixes separately from other improvements,
>> because the process a bit different for them, go into different
>> branches and so on.
> 
> It's not a huge problem even if they go to different branches,
> for these I'd be more comfortable doing 5.14 anyway and that
> makes it even less of a concern.

Ok, good to know. I was finding splitting more convenient
as a default option, easier with b4, more confidence that
they apply to the right branch and so on

-- 
Pavel Begunkov
