Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ECE21B7D9
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGJOJh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgGJOJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:09:36 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5215BC08C5DC
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 07:09:36 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f23so6136928iof.6
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2020 07:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GkJUhDwEWg19k+flxmmMGIck6ztbcEd5EG3ERyiHHYM=;
        b=fuJTfU5frNftoB2nOBvhj+jH0w0v7UZBt3PnRDu7UtC8P7Sjj1DqVomTFixtOge9ng
         pEAvE7Ed2zvkR8YDMoTElqae1xCMERl72kzobWs8n3Q08z3K1TqZfDI/df8oUG5w6ou1
         FvwJ4Qt9KvhC8Suq6E9kP7Ffdr64WsPcUDDBnUVRgvxBs6HYsmpINdpOA652MjrafdJ0
         //BgRQgnQ6kcjVnz5c0X2FZYU01+No7t4lPdlw6X5GFu5PHuecm10X3Xi7IjZlie1f8L
         hYUamcPROy8+F7Grc28Rq5/qJsOhRSzAmkvgu9beFuD+suZDnIDHiuSXBFu0Dj78eLeo
         t+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GkJUhDwEWg19k+flxmmMGIck6ztbcEd5EG3ERyiHHYM=;
        b=oYHEGG/b+eF+fEJR0/dUYd3/Y7Mdjw+PrF2SVypdg8qqodEtRTUQB6lC2f2uAva4/V
         CTDWqQ1c0lCDnLVDFfDyEschs2J3MIldeZVLpzDzpXZPnaLbRT6h2x5vN/oqRJJrQyU+
         SaTGvUws5TzJIAdi/MCw8HYQfjs+ZmJo6udxA1cpsYRVhIhz99n7fDBg8LE6fCnTbGwO
         tQdvibsHUtTjzb92MfY+psAOekx2rbVcCPg2THfg/WZlAEKdjvJxLy81KJy/RpuWObaQ
         /vQKA/ht0t7s8LaWBqhvQDJcw9kxsJgnj+IctQaK18w0KRRIHHlJc8bHYlGEWezxkkZX
         tOFw==
X-Gm-Message-State: AOAM530hBrLNghgxhoFXvBZJ+eYk8gMAn8vkI6jQpTI4AZGEL6aaR/q+
        cDei14BoSJZ55Ta7IeP0NfOPtQ==
X-Google-Smtp-Source: ABdhPJzaZyEeMrMWgbopFxfHGDE7K7HRqxBSjebhSFB7gm/+G+oST+FYJgvn85vQMrSkFWFE9eWgyA==
X-Received: by 2002:a02:70d4:: with SMTP id f203mr80267571jac.74.1594390175673;
        Fri, 10 Jul 2020 07:09:35 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z9sm3564606ilz.45.2020.07.10.07.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 07:09:35 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Christoph Hellwig <hch@infradead.org>,
        Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, Matias Bj??rling <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <CGME20200705185227epcas5p16fba3cb92561794b960184c89fdf2bb7@epcas5p1.samsung.com>
 <1593974870-18919-5-git-send-email-joshi.k@samsung.com>
 <fe0066b7-5380-43ee-20b2-c9b17ba18e4f@kernel.dk>
 <20200709085501.GA64935@infradead.org>
 <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org>
 <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk>
 <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e870249-01db-c68d-ea65-28edc3c1f071@kernel.dk>
Date:   Fri, 10 Jul 2020 08:09:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710131054.GB7491@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/10/20 7:10 AM, Christoph Hellwig wrote:
> On Fri, Jul 10, 2020 at 12:35:43AM +0530, Kanchan Joshi wrote:
>> Append required special treatment (conversion for sector to bytes) for io_uring.
>> And we were planning a user-space wrapper to abstract that.
>>
>> But good part (as it seems now) was: append result went along with cflags at
>> virtually no additional cost. And uring code changes became super clean/minimal
>> with further revisions.
>> While indirect-offset requires doing allocation/mgmt in application,
>> io-uring submission
>> and in completion path (which seems trickier), and those CQE flags
>> still get written
>> user-space and serve no purpose for append-write.
> 
> I have to say that storing the results in the CQE generally make
> so much more sense.  I wonder if we need a per-fd "large CGE" flag
> that adds two extra u64s to the CQE, and some ops just require this
> version.

I have been pondering the same thing, we could make certain ops consume
two CQEs if it makes sense. It's a bit ugly on the app side with two
different CQEs for a request, though. We can't just treat it as a large
CQE, as they might not be sequential if we happen to wrap. But maybe
it's not too bad.

-- 
Jens Axboe

