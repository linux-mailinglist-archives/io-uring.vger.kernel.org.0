Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BBA2B54C4
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 00:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgKPXMf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 18:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgKPXMe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 18:12:34 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52ADFC0613CF
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 15:12:34 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p1so20808723wrf.12
        for <io-uring@vger.kernel.org>; Mon, 16 Nov 2020 15:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XujbtEJfUYQqGLTXNHPICrI8qoiVnxqnCNCfsE50OCM=;
        b=oojlkAXxqGmBRwk/1yV8ZJ2pYbPPRXURoDX1GtIhT45k4wFQXxDF3QKRKt1U8k227q
         a1MKKsKC67e/EOLCyvgAX3CxFJlHNK6f+7I5NGL+U6oW7SAShCRLfxovMTlEM2kIWTEA
         g+d5aR1hPNjdpHKZ8HYoB1GaCzOZ5uz0SN8DaLftWOdAFi8SrSQyyjTV/cMgcVMKr6NA
         AENr/aoqmaEGDp9464OFXAcBuJbSvBYWodk56BYsWDnZ9/AU0lG7x4FBsVNIyTg4b/Wo
         pvgQEQ2nLbZ1tLBc6LTIzm38Oade/dktFqw48HSLYqOzW6w2v/j3mHGn1AmZpJi66nCZ
         ryzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XujbtEJfUYQqGLTXNHPICrI8qoiVnxqnCNCfsE50OCM=;
        b=Sc3WDpEMaCStQ3QdY3DQ2vG+tT498a2VoOn0p0JIYuW4wqoZpSa+h7c4wws/q2bHOH
         UFcHHD0h/7v91rJKcHx1+vkZeXNMP6wBJ61RZr5h/WVAlotTladCv9lPB4GArMt8jvcq
         jCEQgUqDZUK291hT4mqVvmyuuYEpUDaw6OVgP65Fd9yobajhFe2m+Mw/z1q34oHW9RCq
         Tb8TlsdxzUkoFgC1k+5Ztf+aRfC0u7INT3tkW7XEaLO4XnhIs45PNFhhmSU+ZxGMTiSU
         PCg51+hDZDjdMELIrc8/1StoGvPgaXEDzIm56KVSwehnWtkYwRE/GOSuVQuJEqiMGkDI
         o62A==
X-Gm-Message-State: AOAM530xhwQMsRVLLGpC+hU1Mv7ox8b1l5no5rQryyZBapY1iSkp38YS
        bJT50hjoSTSgX9imJpJKxRdh58qwsldZ1A==
X-Google-Smtp-Source: ABdhPJwxX60kuM4EE8jWEw14gUorwSk06YO9ZB3y6q545iLCkXMlTjQ8+Ztt2I7QFeVfmnHe6IshjA==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr21759599wru.30.1605568352815;
        Mon, 16 Nov 2020 15:12:32 -0800 (PST)
Received: from [192.168.1.33] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id e6sm959732wme.27.2020.11.16.15.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 15:12:32 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-5-git-send-email-bijan.mottahedeh@oracle.com>
 <1e23c177-2be8-4046-c1ea-7ab263132bb5@gmail.com>
 <5ab203e3-8394-2dae-b48c-b30a1e16cc5d@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 4/8] io_uring: implement fixed buffers registration
 similar to fixed files
Message-ID: <ff99c7df-de77-3663-e607-f547806565c0@gmail.com>
Date:   Mon, 16 Nov 2020 23:09:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5ab203e3-8394-2dae-b48c-b30a1e16cc5d@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/11/2020 21:24, Bijan Mottahedeh wrote:
> On 11/15/2020 5:33 AM, Pavel Begunkov wrote:
>> On 12/11/2020 23:00, Bijan Mottahedeh wrote:
>>> Apply fixed_rsrc functionality for fixed buffers support.
>>
>> I don't get it, requests with fixed files take a ref to a node (see
>> fixed_file_refs) and put it on free, but I don't see anything similar
>> here. Did you work around it somehow?
> 
> No that's my oversight.  I think I wrongfully assumed that io_import_*fixed() would take care of that.
> 
> Should I basically do something similar to io_file_get()/io_put_file()?

If done in a dumb way, that'd mean extra pair of percpu get/put
and +8B in io_kiocb. Frankly, I don't like that idea.

However, if you don't split paths and make fixed_file_ref_node to
supports all types of resources at the same time, it should be
bearable. I.e. register removals of both types to a single node,
and use ->fixed_file_refs for all request's resources.
So you don't grow io_kiocb and do maximum one percpu_ref_get/put()
pair per request.

I'll send a small patch preparing grounds, because there is actually
another nasty thing from past that needs to be reworked.

> 
> io_import_fixed()
> io_import_iovec_fixed()
> -> io_buf_get()
> 
> io_dismantle_io()
> -> io_put_buf()
> 
>>
>> That's not critical for this particular patch as you still do full
>> quisce in __io_uring_register(), but IIRC was essential for
>> update/remove requests.
> 
> That's something I'm not clear about.  Currently we quiesce for the following cases:
> 
>         case IORING_UNREGISTER_FILES:
>         case IORING_REGISTER_FILES_UPDATE:
>         case IORING_REGISTER_BUFFERS_UPDATE:

static bool io_register_op_must_quiesce(int op)
{
	switch (op) {
	case IORING_UNREGISTER_FILES:
	case IORING_REGISTER_FILES_UPDATE:
	case IORING_REGISTER_PROBE:
	case IORING_REGISTER_PERSONALITY:
	case IORING_UNREGISTER_PERSONALITY:
		return false;
	default:
		return true;
	}
}

It returns _false_ for these cases, so _doesn't_ quiesce for them.

> 
> I had assume I have to add IORING_UNREGISTER_BUFFERS as well.  But above, do we in fact the quiesce give the ref counts?
> 
> Are you ok with the rest of the patches or should I address anything else?

io_import_fixed() currently can be called twice, and that would give
you 2 different bvecs. Hence after removing full quisce io_read()
retrying short reads will probably be able to partially read into 2
different buffers. That really have to be fixed.


I haven't looked the patchset properly yet. I'll reply to the
cover-letter + a small comment below


>>>   static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>>>                      struct iov_iter *iter)
>>>   {
>>> @@ -2959,10 +2982,15 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>>>       size_t offset;
>>>       u64 buf_addr;
>>>   +    /* attempt to use fixed buffers without having provided iovecs */
>>> +    if (unlikely(!ctx->buf_data))
>>> +        return -EFAULT;

I removed it for files,
because (ctx->buf_data) IFF (ctx->nr_user_bufs == 0),
so the following ctx->nr_user_bufs check is enough.

>>> +
>>> +    buf_index = req->buf_index;
>>>       if (unlikely(buf_index >= ctx->nr_user_bufs))
>>>           return -EFAULT;
>>>       index = array_index_nospec(buf_index, ctx->nr_user_bufs);
>>> -    imu = &ctx->user_bufs[index];
>>> +    imu = io_buf_from_index(ctx, index);
>>>       buf_addr = req->rw.addr;
>>>         /* overflow */
>>> @@ -8167,28 +8195,73 @@ static unsigned long ring_pages(unsigned sq_entries, unsigned cq_entries)
>>>       return pages;
>>>   }


-- 
Pavel Begunkov
