Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5541D3673
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgENQ0z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 12:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbgENQ0z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 12:26:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B75C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 09:26:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so5099588wru.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 09:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KlYeb8HLWyDX5yz1LZ/kde7httLZDw2+3RtuDbSWGoA=;
        b=q/nCpW1L1QdtlOwfah/weIAfqOPzYmEzyV1THJr9sE0DcJhFrcPcRhyGxrd5BgGkEp
         gjXnqsrz7kvhtGPWNzO5bcsevHtjMRGzjJftU7upMjnojjH3x4gEi6U1FB3UROFILKrX
         kxrHknNJCOGG7fv0g3FvTEqz3IUZXlZDIIn32OTb1UcRSiVbA8ezrqzh+7VpFAUH65/E
         r4yErD5RlCfSMSAmt+a2BoD7JcFQ3AYJZD2QGaopRGtWO4h4uPty8tP0eqT47EVbCvYl
         kDWc025Dfa+IattSBwMwpOScyPluGKL0QuEdY19TTy+wIjD1AIX157AxYmfQF03E6cI0
         Pogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KlYeb8HLWyDX5yz1LZ/kde7httLZDw2+3RtuDbSWGoA=;
        b=AaStZm+Y3wQ2er+ldb45JpKmOoUvUPntm+wewl93l65Es/PAx7V3h+AReOpfWFYxeB
         TVt5pT82fRsOCiRZXii0asfmj3fI3N+qu7i02kcIFt1OR3qhJgl6z8RzL01dTyQ0dJvv
         2EGkMs3fzyarL4VYJRFojM81LQkXg/CMzPvwtv0odc6AsMvdMiVbcKqCvpXrxN+MZCbO
         GspHDNivCFyE209zAfQRRt0N/E5A1jwZGy3SUQLp6+l8Dw6AQ9xu0Q6jpQahBqJipYzp
         aLcwO/dkEIxfsrl3Zokv0RRU9rU5l9UHoe5LT9cUG5qfPX23kHuEjShDsB8S4HPNM8qa
         jv9Q==
X-Gm-Message-State: AOAM531iPAlVJqIESV8Yl8I849B9MCgFUvU2eCmECTe8uepSmPpxtIyZ
        joguFsqzRg3UVghbfXUOqvHM4X6l
X-Google-Smtp-Source: ABdhPJwcn30wRbdyJ+apyw9ndsjuC9muelIzdvWs0oSIoA+zAG9V1cEkge7ukNQhqAanJRasi22HhA==
X-Received: by 2002:adf:e905:: with SMTP id f5mr6399429wrm.409.1589473613735;
        Thu, 14 May 2020 09:26:53 -0700 (PDT)
Received: from [192.168.43.127] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id g10sm4470620wrx.4.2020.05.14.09.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 09:26:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
 <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
 <a2b5e500-316d-dc06-1a25-72aaf67ac227@kernel.dk>
 <d6206c24-8b4d-37d3-56bd-eac752151de9@gmail.com>
 <b7e7eb5e-cbea-0c59-38b1-1043b5352e4d@kernel.dk>
 <8ddf1d04-aa4a-ee91-72fa-59cb0081695c@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
Message-ID: <642c24dd-19e7-1332-f31e-04a8f0f81c3a@gmail.com>
Date:   Thu, 14 May 2020 19:25:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8ddf1d04-aa4a-ee91-72fa-59cb0081695c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/05/2020 19:18, Pavel Begunkov wrote:
> On 14/05/2020 18:53, Jens Axboe wrote:
>> On 5/14/20 9:37 AM, Pavel Begunkov wrote:
>> Hmm yes good point, it should work pretty easily, barring the use cases
>> that do IRQ complete. But that was also a special case with the other
>> cache.
>>
>>> BTW, there will be a lot of problems to make either work properly with
>>> IORING_FEAT_SUBMIT_STABLE.
>>
>> How so? Once the request is setup, any state should be retained there.
> 
> If a late alloc fails (e.g. in __io_queue_sqe()), you'd need to file a CQE with
> an error. If there is no place in CQ, to postpone the completion it'd require an
> allocated req. Of course it can be dropped, but I'd prefer to have strict
> guarantees.

I know how to do it right for my version.
Is it still just for fun thing, or you think it'll be useful for real I/O?

> 
> That's the same reason, I have a patch stashed, that grabs links from SQ
> atomically (i.e. take all SQEs of a link or none).
> 

-- 
Pavel Begunkov
