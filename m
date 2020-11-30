Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7E32C8CD6
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 19:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgK3SbY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 13:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgK3SbY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 13:31:24 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC67C0613CF
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 10:30:43 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 64so17505893wra.11
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 10:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0q2EoNaPuNho/mXs0y0wP0V/bwy2/fHw9dw13ioQgOk=;
        b=kOymHigrgmitwdzRKkCZFvZgLwuAeyjktGLPJPXgfQNkktwYRlnB9o6ni2QpERQeJF
         mBiWaRLdKUNdlC9z1JKv9EYVWynL4JCNUKkaaDY0A+yBEhUQhRP++eFrhkWiHafWMW71
         HAu+bKA6n12vMiZ5tdBhG6Ur9QnUyZ3fzi7kOO6+ZVGhVvzR5pWXiyEERPJtX9Afz7Jy
         njm7iw0ZtmuWNpgQ67dWfwIcl72SkppeUsy7fsPCUqxuHYbWuAGxLJgXXY2+UX8cSG0r
         nV/3jkEvCmj7tMmtn5OJCkmNKUKudIg0taHk9q/TmgF25DAN/q//BasZXMjpyUy6ISQC
         OVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0q2EoNaPuNho/mXs0y0wP0V/bwy2/fHw9dw13ioQgOk=;
        b=EZghAt6D1RvCfwSazItJP4Lve6fbZyuFFRu4/hJlEZGG/HownBIzFM9SA9OBuXiDlK
         nPOtDp6TMY3iqjfnL2BZPLJeI/erAWEMWdjLvVQ4qPk/JAWqyvAqODzJc4MLT4EUNnHA
         YPnENiT8ac9RlfYrP6qYzubUjuOarHgVTLXj5RPnvHe/Kxoo2i9T6Nuh0XQNn0IWgyu+
         u/5PgCmf9ccIR6EPHe+o5EnURoBoR785RCCjsft3fxnd4omF3P4nO410JVIjDqlyFahc
         xjxn/MObDMeDODy5VqKbNABEFy/J90p3kywsB1Hh4L3FRbdl+lQnDJr78EnVLVzTJNW6
         L+Yw==
X-Gm-Message-State: AOAM530TaYgShmbcIsHO2sWlCxfQMqxp7p4uKyZtczvwBoikSzQenm5B
        L8pDl4l+O94yGyI8fOrPOgMaUYB7YCd02g==
X-Google-Smtp-Source: ABdhPJynpjE3uwEs+Medrng1Zbs6yns8oTGq46WfZPf9lqoIM7upM9RtvqT3WkzXrEZCh2OistB0Vw==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr18200547wrr.235.1606761042159;
        Mon, 30 Nov 2020 10:30:42 -0800 (PST)
Received: from [192.168.1.14] (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id 189sm218541wma.22.2020.11.30.10.30.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:30:41 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1606669225.git.asml.silence@gmail.com>
 <eb04a3d3154dce299c91d12a315a2335603c508a.1606669225.git.asml.silence@gmail.com>
 <a020eb4a-41a7-cc06-1699-d6ff77e28c76@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/2] io_uring: add timeout update
Message-ID: <8d440a65-ba71-d835-9e49-653f1aa30232@gmail.com>
Date:   Mon, 30 Nov 2020 18:27:28 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a020eb4a-41a7-cc06-1699-d6ff77e28c76@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/11/2020 18:15, Jens Axboe wrote:
> On 11/29/20 10:12 AM, Pavel Begunkov wrote:
>> +	tr->flags = READ_ONCE(sqe->timeout_flags);
>> +	if (tr->flags) {
>> +		if (!(tr->flags & IORING_TIMEOUT_UPDATE))
>> +			return -EINVAL;
>> +		if (tr->flags & ~(IORING_TIMEOUT_UPDATE|IORING_TIMEOUT_ABS))
>> +			return -EINVAL;
> 
> These flag comparisons are a bit obtuse - perhaps warrants a comment?

Ok, the one below should be more readable.

if (tr->flags & IORING_TIMEOUT_UPDATE) {
	if (flags & ~ALLOWED_UPDATE_FLAGS)
		return -EINVAL;
	...
} else if (tr->flags) {
	/* timeout removal doesn't support flags */
	return -EINVAL;
}

> 
>> +		ret = __io_sq_thread_acquire_mm(req->ctx);
>> +		if (ret)
>> +			return ret;
> 
> Why is this done manually?

mm is only needed in *prep(), so don't want IO_WQ_WORK_MM to put it
into req->work since it also affects timeout remove reqs.

> 
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 6bb8229de892..12a6443ea60d 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -151,6 +151,7 @@ enum {
>>   * sqe->timeout_flags
>>   */
>>  #define IORING_TIMEOUT_ABS	(1U << 0)
>> +#define IORING_TIMEOUT_UPDATE	(1U << 31)
> 
> Why bit 31?

Left bits for other potential timeout modes, don't know which though.
Can return it to bit 1.


-- 
Pavel Begunkov
