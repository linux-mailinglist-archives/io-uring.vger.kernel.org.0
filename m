Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BF227483
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 03:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgGUB3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 21:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgGUB3U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 21:29:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B66C0619D5
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 18:29:19 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d7so751893plq.13
        for <io-uring@vger.kernel.org>; Mon, 20 Jul 2020 18:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sjioqcVovtB/2GCCf7EiFORrXptq/bceaX/G5i7rT0U=;
        b=vAQqP/EZ0OO90K0v/2nWrxljG688ypm6ngU3+V2nfTwkI9kAqyJQBq2IqJz15IsGgN
         FQBvcTfqYEHNloL/UC+GlYtIZonKyfl1GMPHmomJ3Sx2F1ymKVTIEoDRfFvUZ8QPPg8x
         3iVQsTVkMjf3GgVyqO6Z78vpvb2uaTJXzniXkA7BNHW+ggOdBYJkv9bsfUJQYmR0a+jK
         5xz2kpoKb2+yQYZkWIyua9E7hgM9JwJnZ1QmqGchBVcwhJsqMX3qe4tib2vjbi4AZ6yg
         Ma0eRl2hzB60otJ/FNczONw4hC465Acjq3GdkguO3n2khtQkHVQtij6VNjkmntxxWOG8
         ZhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjioqcVovtB/2GCCf7EiFORrXptq/bceaX/G5i7rT0U=;
        b=F6CsFsvZ9xs3dnLIFmPucT+eqQ3UPg1b++3sHt6kov8KhiAXJ6YuACZLvdvDR4YeAR
         Vxesh/D4Y9OhqlIKKQqJIb0jh6oMF9bW802fG205BYeEl+6OS58PB+r0EEDKPIyQv405
         apxgNxS6FM9i41IdKlJYgaR4cL+R1gmm0b0O62XP6tS02nzbzrhjYCM8JqKXHLI03r8d
         Ui5Or9crRkSVudl2kPHkeRpzccaaFOX95UBwyLRDBVnYAuw1N6eUdKLqp/tJsvizzDfy
         dx6RRCWWQf19nahYPgbfzXamgP7QBpQwBRyLAazycLLSKDLRkNc9v3cWiDQ9e1Y/DaAG
         XNUw==
X-Gm-Message-State: AOAM533G/L75y3iMP4W3QcmZ/QYMSwr25NfY0D9qmFR2Yu9wHhgxqnEA
        RcBlVEyvbFi1xnH4iu0wIGdxIw==
X-Google-Smtp-Source: ABdhPJz6Q6JFb2MQ4nKJvlDB5yiikt5Aee2yKzIluLMpzv17W4Llpioax46MPzDMiRGLeYhyYSRuNQ==
X-Received: by 2002:a17:902:c38a:: with SMTP id g10mr19287307plg.50.1595294959039;
        Mon, 20 Jul 2020 18:29:19 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b18sm870640pju.10.2020.07.20.18.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:29:18 -0700 (PDT)
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Matias Bj??rling <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org>
 <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org>
 <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
 <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com>
 <20200720171416.GY12769@casper.infradead.org>
 <CA+1E3rLNo5sFH3RPFAM4_SYXSmyWTCdbC3k3-6jeaj3FRPYLkQ@mail.gmail.com>
 <CY4PR04MB37513C3424E81955EE7BFDA4E7780@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200721011509.GB15516@casper.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ac5bfe7-f086-7531-fbd8-8dde77f13638@kernel.dk>
Date:   Mon, 20 Jul 2020 19:29:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721011509.GB15516@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/20/20 7:15 PM, Matthew Wilcox wrote:
>> Also, the completed size should be in res in the first cqe to follow
>> io_uring current interface, no ?. The second cqe would use the res64
>> field to return the written offset. Wasn't that the plan ?
> 
> two cqes for one sqe seems like a bad idea to me.

I have to agree with that, it's counter to everything else. The app will
then have to wait for two CQEs when it issues that one "special" SQE,
which is really iffy. And we'd have to promise that they are adjacent in
the ring. This isn't necessarily a problem right now, but I've been
playing with un-serialized completions and this would then become an
issue. The io_uring interface is clearly defined as "any sqe will either
return an error on submit (if the error is not specific to the sqe
contents), or post a completion event". Not two events, one.

And imho, zoned device append isn't an interesting enough use case to
warrant doing something special. If there was a super strong (and
generic) use case for passing back more information in the cqe then
maybe it would be considered. But it'd have to be a killer application.
If that's not the case, then the use case should work within the
constraints of the existing API.

-- 
Jens Axboe

