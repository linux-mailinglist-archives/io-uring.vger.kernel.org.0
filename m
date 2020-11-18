Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F240D2B7A2F
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 10:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgKRJR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 04:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgKRJR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 04:17:27 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4C1C0613D4
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 01:17:27 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 23so1399598wrc.8
        for <io-uring@vger.kernel.org>; Wed, 18 Nov 2020 01:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aq1fSiAguBAPI74l6bcLoMA5eScD5a0NHxtUTYFN1FM=;
        b=dmI+dt/DO+ncrhR+0av+essXbWxAC0VYGA+eyt88cH5/NBbn6w0jFqnM4OTX3wpMjz
         zVa3+Ue6xLL+EcIXL4XA2CKw7VIvmwqxD7UhQX97MKZkYwH31/l1psqk8x7JZidSJsnL
         ZvCfdaJl6JRARyjUi9Z/Wfnj4hLP6RH+Ao4z+cQlVNbHhqCpMbQgdPm4gDrepll6dFvF
         G0EhjdD/e+5OY8Lzc/wDEAVMq6+fELDe65Iw/8WVQ+2kVqrNnpb9Qi8Jf+vFqgkViELc
         ngiCY7QKdmaIUtE50UvebgeW73ktqFceIVe6RNu0IW2fAFMsRiSb6dTYupdNh2cA5GDb
         awNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aq1fSiAguBAPI74l6bcLoMA5eScD5a0NHxtUTYFN1FM=;
        b=ZNj1vMp2k2yNonLYQUZ1gfalEHtmExHFfI7HcD7G3daZXT8LDQWr3nkkynD9ysWpqL
         Bppog98YRnVkpizdOE3+vwuVXHj4KeASiURr+HeIu/xZ4PhLxIPY1MiFZRXnc9o9g3pu
         G/ogFSRsUi+ESK+1HameKSwT5ABCVjJhbZz+hgf6OJGwvXfQPUhJNFYZemGn5xOw0S9q
         2zs75YPPJqNOabHPBbcX8BQXGdpcDd0eYjswj9dRoCBWV6FlXQfDYpIM0kO65I7rvOJb
         VbKyz//2Nnf2ZtxBI6tRaAfttswiUemC9buBc1DZHvL9OrbSHM8IBrylT8Fueu/fGPlH
         pWRw==
X-Gm-Message-State: AOAM532qDRP2urh28cA1UfQmiO3JVAPbM9lzayK4wZPko5zdrJyzLJUf
        vZYXsUgj4trzqeV5/x5ts13kzlMc+K/SaQ==
X-Google-Smtp-Source: ABdhPJwRxmPoOK0JTyh1y+iYj2MbLWW/gY3TWFZDakDPjGPlmNG3cEiAUZ52kxcxR59P2kugLwkDdg==
X-Received: by 2002:adf:a39e:: with SMTP id l30mr3589944wrb.195.1605691045470;
        Wed, 18 Nov 2020 01:17:25 -0800 (PST)
Received: from [192.168.1.58] (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id f11sm31441234wrs.70.2020.11.18.01.17.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 01:17:25 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-8-git-send-email-bijan.mottahedeh@oracle.com>
 <d8c1c348-7806-ce54-c683-0c08e44d4590@gmail.com>
 <0bf865dc-14d3-9521-26d9-c91873535146@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 7/8] io_uring: support readv/writev with fixed buffers
Message-ID: <10aa4c0f-eaf5-29df-e7b1-6a8d1e52ec15@gmail.com>
Date:   Wed, 18 Nov 2020 09:14:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0bf865dc-14d3-9521-26d9-c91873535146@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17/11/2020 22:59, Bijan Mottahedeh wrote:
>>> Support readv/writev with fixed buffers, and introduce IOSQE_FIXED_BUFFER,
>>> consistent with fixed files.
>>
>> I don't like it at all, see issues below. The actual implementation would
>> be much uglier.
>>
>> I propose you to split the series and push separately. Your first 6 patches
>> first, I don't have conceptual objections to them. Then registration sharing
>> (I still need to look it up). And then we can return to this, if you're not
>> yet convinced.
> 
> Ok.  The sharing patch is actually the highest priority for us so it'd be great to know if you think it's in the right direction.
> 
> Should I submit them as they are or address your fixed_file_ref comments in Patch 4/8 as well?  Would I need your prep patch beforehand?

I remembered one more thing that I need to do for your patches to work.
I'll ping you afterwards

> 
>>> +static ssize_t io_import_iovec_fixed(int rw, struct io_kiocb *req, void *buf,
>>> +                     unsigned segs, unsigned fast_segs,
>>> +                     struct iovec **iovec,
>>> +                     struct iov_iter *iter)
>>> +{
>>> +    struct io_ring_ctx *ctx = req->ctx;
>>> +    struct io_mapped_ubuf *imu;
>>> +    struct iovec *iov;
>>> +    u16 index, buf_index;
>>> +    ssize_t ret;
>>> +    unsigned long seg;
>>> +
>>> +    if (unlikely(!ctx->buf_data))
>>> +        return -EFAULT;
>>> +
>>> +    ret = import_iovec(rw, buf, segs, fast_segs, iovec, iter);
>>
>> Did you test it? import_iovec() does access_ok() against each iov_base,
>> which in your case are an index.
> 
> I used liburing:test/file-{register,update} as models for the equivalent buffer tests and they seem to work.  I can send out the tests and the liburing changes if you want.

Hmm, seems access_ok() is no-op for many architectures.
Still IIRC it's not portable.

> 
> The fixed io test registers an empty iov table first:
> 
>     ret = io_uring_register_buffers(ring, iovs, UIO_MAXIOV);
> 
> It next updates the table with two actual buffers at offset 768:
> 
>         ret = io_uring_register_buffers_update(ring, 768, ups, 2);
> 
> It later uses the buffer at index 768 for writev similar to the file-register test (IOSQE_FIXED_BUFFER instead of IOSQE_FIXED_FILE):
> 
>         iovs[768].iov_base = (void *)768;
>         iovs[768].iov_len = pagesize;
> 
> 
>         io_uring_prep_writev(sqe, fd, iovs, 1, 0);
>         sqe->flags |= IOSQE_FIXED_BUFFER;
> 
>         ret = io_uring_submit(ring);
> 
> Below is the iovec returned from
> 
> io_import_iovec_fixed()
> -> io_import_vec()
> 
> {iov_base = 0x300 <dm_early_create+412>, iov_len = 4096}
> 
>>> +    if (ret < 0)
>>> +        return ret;
>>> +
>>> +    iov = (struct iovec *)iter->iov;
>>> +
>>> +    for (seg = 0; seg < iter->nr_segs; seg++) {
>>> +        buf_index = *(u16 *)(&iov[seg].iov_base);
>>
>> That's ugly, and also not consistent with rw_fixed, because iov_base is
>> used to calculate offset.
> 
> Would offset be applicable when using readv/writev?

Not sure what you mean. You can register a huge chunk of memory,
but with buf_index alone you can't select a subchunk. E.g.

void *buf = alloc(4G);
idx = io_uring_register_buf(buf);
uring_read_fixed(reg_buf=idx, 
		data=buf+100, // offset 100
		size=sz);

This writes [buf+100, buf+100+sz]. Without passing @buf you
wouldn't be able to specify an offset. Alternatively, the
API could have been accepting an offset directly, but this
option was chosen.

There is no such a problem with non-registered versions, it
just writes/reads all iov.

> 
> My thinkig was that for those cases, each iovec should be used exactly as registered.

It may be confusing, but read/write_fixed use iov_base to calculate offset.
i.e.

imu = ctx->bufs[req->buffer_index];
if (iov_base not in range(imu->original_addr, imu->len))
	fail;
offset = iov_base - imu->original_addr;

> 
>>
>>> +        if (unlikely(buf_index < 0 || buf_index >= ctx->nr_user_bufs))
>>> +            return -EFAULT;
>>> +
>>> +        index = array_index_nospec(buf_index, ctx->nr_user_bufs);
>>> +        imu = io_buf_from_index(ctx, index);
>>> +        if (!imu->ubuf || !imu->len)
>>> +            return -EFAULT;
>>> +        if (iov[seg].iov_len > imu->len)
>>> +            return -EFAULT;
>>> +
>>> +        iov[seg].iov_base = (void *)imu->ubuf;
>>
>> Nope, that's not different from non registered version.
>> What import_fixed actually do is setting up the iter argument to point
>> to a bvec (a vector of struct page *).
> 
> So in fact, the buffers end up being pinned again because they are not being as bvecs?

right, it just passes iov with userspace virtual addresses in your case
and layer below don't know that they're pinned. And as they're virtual
in most cases they have to be translated to physical (that's solved by
having a vector of pages).

> 
>>
>> So it either would need to keep a vector of bvecs, that's a vector of vectors,
>> that's not supported by iter, etc., so you'll also need to iterate over them
>> in io_read/write and so on. Or flat 2D structure into 1D, but that's still ugly.
> 
> So you're saying there's no clean way to create a readv/writev + fixed buffers API?  It would've been nice to have a consistent API between files and buffers.

I guess you can register an iov as a single bvec by flatting out the structure
to a single vector (bvec). Though, we'd need to drop an assumption that all
but first and last entries are page sized.

Or do that online with extra overhead + allocations.

> 
> 
>>> @@ -5692,7 +5743,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
>>>   {
>>>       if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>           return -EINVAL;
>>> -    if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>>> +    if (unlikely(req->flags & (REQ_F_FIXED_RSRC | REQ_F_BUFFER_SELECT)))
>>
>> Why it's here?
>>
>> #define REQ_F_FIXED_RSRC    (REQ_F_FIXED_FILE | REQ_F_FIXED_BUFFER)
>> So, why do you | with REQ_F_BUFFER_SELECT again here?
> 
> I thought to group fixed files/buffers but distinguish them from selected buffers.

Ah, I've got this one wrong.

> 
>>> @@ -87,6 +88,8 @@ enum {
>>>   #define IOSQE_ASYNC        (1U << IOSQE_ASYNC_BIT)
>>>   /* select buffer from sqe->buf_group */
>>>   #define IOSQE_BUFFER_SELECT    (1U << IOSQE_BUFFER_SELECT_BIT)
>>> +/* use fixed buffer set */
>>> +#define IOSQE_FIXED_BUFFER    (1U << IOSQE_FIXED_BUFFER_BIT)
>>
>> Unfortenatuly, we're almost out of flags bits -- it's a 1 byte
>> field and 6 bits are already taken. Let's not use it.

-- 
Pavel Begunkov
