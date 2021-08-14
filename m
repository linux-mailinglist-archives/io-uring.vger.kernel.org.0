Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F245B3EC4C5
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 21:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhHNThg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 15:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhHNThe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 15:37:34 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B58C0617AE
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:37:05 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id a13so17710022iol.5
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OQCz4E5K58NTYwue5qc02Yzs8VDPGbPjY78DvQPU2L4=;
        b=jTyyUfI7TQxLp+WZudNqwnoE7m80qq5dnNp3ZMcAP28dcfsM3x69/A2mskb4Yvj2xp
         JevnyR1teDTPvL23pddf4U0/dVPWWWAYqfGaizPVUWJXFMRQuspJqVo2kRVpfUp7J0fQ
         /Evj0Xs/sS26NOBDEPqJDhyJx6bNdznt78KktsY/moOWLGk2deTsleE8nDMjpw74HkQE
         RXenNGdYBi9BrCCpQb568TPwyT88OW292y76T6mQwVGIL0P2k+dYdK0xTyQasrQDU0Wv
         z2QFR4kfJVHjcMTNagVZ+JKtPB40ukEiHrXNKVlBcH7LnnlRK3Ya+uCn8dIaEP5vPN3K
         yCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OQCz4E5K58NTYwue5qc02Yzs8VDPGbPjY78DvQPU2L4=;
        b=m9FrsWPZNArQ5gIyf886n2XoFK6WgDs5Yv+EabRdPl+t/DBVsH7Zqkq0eRJ48bhzkt
         q4GssDUt32M4kRHIqJ+FsMhdVUngDN25sMS0GIzM5k6fGRLcXFxsIIjYFx5Cx+SEbChk
         dae3ENDOsHGPNsJ5KvVcI4D2Fog4PR+r1qadYVAjPHPLD8Evi+yj2nHXlLLukx9MQD7r
         x/Rjdxbc6GqYoU2FQ9l8cZolYvzHzSHOkdcuUJUt7PwH8dOI3flg8RMANn720SlEvTuz
         Q8hDCeoxfEZOTHcIXTcWIOwZ2AkFYInEET2R9fhrCXCwj31MjqjVoASgEAxqYW1Rol9D
         ivOA==
X-Gm-Message-State: AOAM532YB1Ly+ZsQrIieC58dRsFSv1KumEk1B223jKT1HEiP5ynXRopM
        b5PZW630rc1sktrYVivPYp4t6XvAWbUQlOIJ
X-Google-Smtp-Source: ABdhPJwYeRHBXFsp2BMKO1UiShltxVap5zoiRfspCP3Rv8HPqimjneTfRWTmiPdk5Pc1OUe6M2MD1A==
X-Received: by 2002:a5d:8b03:: with SMTP id k3mr6489978ion.203.1628969823938;
        Sat, 14 Aug 2021 12:37:03 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f9sm3134264ilk.56.2021.08.14.12.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 12:37:03 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
 <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
 <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <033eb63d-08a6-0cc8-9d2b-62485da4f7a3@kernel.dk>
Date:   Sat, 14 Aug 2021 13:37:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 1:31 PM, Pavel Begunkov wrote:
> On 8/14/21 8:13 PM, Jens Axboe wrote:
>> On 8/14/21 10:26 AM, Pavel Begunkov wrote:
>>> If a requests is forwarded into io-wq, there is a good chance it hasn't
>>> been refcounted yet and we can save one req_ref_get() by setting the
>>> refcount number to the right value directly.
>>
>> Not sure this really matters, but can't hurt either. But...
> 
> The refcount patches made this one atomic worse, and I just prefer
> to not regress, even if slightly

Not really against it, but doubt it's measurable if you end up hitting
the io-wq slower path anyway. But as I said, can't really hurt, so not
aginst it.

>>> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>>>  	atomic_inc(&req->refs);
>>>  }
>>>  
>>> -static inline void io_req_refcount(struct io_kiocb *req)
>>> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>>>  {
>>>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>>>  		req->flags |= REQ_F_REFCOUNT;
>>> -		atomic_set(&req->refs, 1);
>>> +		atomic_set(&req->refs, nr);
>>>  	}
>>>  }
>>>  
>>> +static inline void io_req_refcount(struct io_kiocb *req)
>>> +{
>>> +	__io_req_refcount(req, 1);
>>> +}
>>> +
>>
>> I really think these should be io_req_set_refcount() or something like
>> that, making it clear that we're actively setting/manipulating the ref
>> count.
> 
> Agree. A separate patch, maybe?

Maybe just fold it into this one, as it's splitting out a helper anyway.
Or do it as a prep patch before this one, up to you.

-- 
Jens Axboe

