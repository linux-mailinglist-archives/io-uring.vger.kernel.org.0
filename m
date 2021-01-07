Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB6E2EC82D
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 03:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbhAGCl6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 21:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbhAGCl6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 21:41:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4FAC0612EF
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 18:41:17 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id d26so4132240wrb.12
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 18:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XGGjSdYvDgo6NvyOlsMkqh9/6c5UTngv0PS3Osjtsno=;
        b=BUbayqRFChs/0a2ZSK8y2N/FAzQUym4+5Q8bYe1icWgPMQDghUTryHdpff3rNR9BiF
         Nr7475XU7YgQFvpuAwnZiTLhJ+20ySadEf+ROU7H9EJre0jHJLpg9OCmA0UOgIg+xzUA
         XqydwYNzvE8QIEbnMfi89erkNEXsqNvDjIexA0hJm2z1YwHelK/H73ETDa2KflHC716w
         sfxAlZOkL/0jAPQ7uRGsF32J7NPym1w6UEAtNub4V0yf3dVQZ5oac3shvrH+wAr3o+cl
         psWcH+TwMkOkVsTbuiud7wvaxYZiwJr44Yi7BPzacWJ/9qNGogJ+4vwDVDfqW0q64PYf
         zONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XGGjSdYvDgo6NvyOlsMkqh9/6c5UTngv0PS3Osjtsno=;
        b=gWflgcgRIzszY4cPlbV8EAjiam2lm3TnuWaYDCDxUM5tYw1N70DWVRs9Rr5ya2mlF6
         m91ldm5F6L0sRWqMwtz+/2sUuNDVhfzI7WPG8l4EVNB1WIuZ+4oHYr7Xx0WIHeMwqYkz
         QS43qe/yzy2eMcKhAu/40x4M91fDLDusrxT9s6f+5neY49EUaLnJixgE5yRqcjS7U7rf
         8g2jDphxQnv5HgEfSv+sxuN2UW/YdpU1ej7X0eIiUf+hxIC0YlFGsREwgsjBsyKooBQr
         koYat5TPY3Oef+pRLAz7OoHdMr7gFpUF6/keIB0xc9XNGe7X633cPBDksffckUoHhz39
         pMVg==
X-Gm-Message-State: AOAM530PpWho9V1YiHirzOb1gYNksZqZJvlCZpolF2n1p4NX2tWpxlMY
        FE8GqC1NznFH5Avy7bb9Jg+IXWmQNjvKpg==
X-Google-Smtp-Source: ABdhPJy7sCFdshb0s4UotCq3HV84+XND+EWKV0sd0uwGkGECAWKkDfCmCHizKsD3Gwgwxyt2F3OnFg==
X-Received: by 2002:a5d:53c9:: with SMTP id a9mr6565718wrw.188.1609987276057;
        Wed, 06 Jan 2021 18:41:16 -0800 (PST)
Received: from [192.168.8.102] ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id a65sm5342964wmc.35.2021.01.06.18.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 18:41:15 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
 <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
Message-ID: <66fd0092-2d03-02c0-fe1c-941c761a24f8@gmail.com>
Date:   Thu, 7 Jan 2021 02:37:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/01/2021 19:46, Bijan Mottahedeh wrote:
> On 1/4/2021 6:43 PM, Pavel Begunkov wrote:
>> On 18/12/2020 18:07, Bijan Mottahedeh wrote:
>>> Apply fixed_rsrc functionality for fixed buffers support.
>>
>> git generated a pretty messy diff...
> 
> I had tried to break this up a few ways but it didn't work well because I think most of the code changes depend on the io_uring structure changes.  I can look again or if you some idea of how you want to split it, I can do that.
> 
>> Because it's do quiesce, fixed read/write access buffers from asynchronous
>> contexts without synchronisation. That won't work anymore, so
>>
>> 1. either we save it in advance, that would require extra req_async
>> allocation for linked fixed rw
>>
>> 2. or synchronise whenever async. But that would mean that a request
>> may get and do IO on two different buffers, that's rotten.
>>
>> 3. do mixed -- lazy, but if do IO then alloc.
>>
>> 3.5 also "synchronise" there would mean uring_lock, that's not welcome,
>> but we can probably do rcu.
> 
> Are you referring to a case where a fixed buffer request can be submitted from async context while those buffers are being unregistered, or something like that?
> 
>> Let me think of a patch...

The most convenient API would be [1], it selects a buffer during
submission, but allocates if needs to go async or for all linked
requests.

[2] should be correct from the kernel perspective (no races), it
also solves doing IO on 2 different buffers, that's nasty (BTW,
[1] solves this problem naturally). However, a buffer might be
selected async, but the following can happen, and user should
wait for request completion before removing a buffer.

1. register buf id=0
2. syscall io_uring_enter(submit=RW_FIXED,buf_id=0,IOSQE_ASYNC)
3. unregister buffers
4. the request may not find the buffer and fail.

Not very convenient + can actually add overhead on the userspace
side, can be even some heavy synchronisation.

uring_lock in [2] is not nice, but I think I can replace it
with rcu, probably can even help with sharing, but I need to
try to implement to be sure.

So that's an open question what API to have.
Neither of diffs is tested.

[1]
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e35283fc0b1..2171836a9ce3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -826,6 +826,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.needs_async_data	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_MM,
@@ -835,6 +836,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.needs_async_data	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE |



[2]
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e35283fc0b1..31560b879fb3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3148,7 +3148,12 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
-		return io_import_fixed(req, rw, iter);
+
+		io_ring_submit_lock(req->ctx, needs_lock);
+		lockdep_assert_held(&req->ctx->uring_lock);
+		ret = io_import_fixed(req, rw, iter);
+		io_ring_submit_unlock(req->ctx, needs_lock);
+		return ret;
 	}
 
 	/* buffer index only valid with fixed read/write, or buffer select  */
@@ -3638,7 +3643,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 copy_iov:
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, io_size - iov_iter_count(iter));
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
+		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 		if (!ret)
 			return -EAGAIN;
 	}


-- 
Pavel Begunkov
