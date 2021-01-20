Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6D2FC8D5
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbhATD1O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732154AbhATCa3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:30:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF4DC0613CF;
        Tue, 19 Jan 2021 18:29:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a9so18151408wrt.5;
        Tue, 19 Jan 2021 18:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0cGIhhFp+Y5wqhKMECSQp9mWWwANlw8iORzC/rpgsbY=;
        b=a7ZmaMRgBnzDAbiXd3otx0z51ThOop0Zlx5bV59eQZjB2OAVezyO+6o+ShBRd+ohnF
         VG6XpV35t6nDePgtjjbZeUT4N1RMjly71K/I4DERDV3k+xaL1xks+jgVWrBDOLFkCVb4
         rbJKKqNBxxLZLb5i6AqxYX4FpT4ZqsigfO8YdHPwBXvb13GPe8633SiPTVRIWJQ+4NEo
         sIyQcgq377Nik/oeQkU5aM66Fdc3MkaChklCyO1Kk/EpC9tIwSbjJOXwx3CzcIi92miG
         PKWdaf7yI028/XpXYObYDDPQD83/0gyWuTr7vI09KpFtEGkQZ6TByjpyxTsFSB5bN3cp
         v01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0cGIhhFp+Y5wqhKMECSQp9mWWwANlw8iORzC/rpgsbY=;
        b=V+g9E/BHoYfPMYH7PYJtC8TvDBipusWaYig2XdYTqb+LEX3IkWOLfu62XRQP++2G9i
         UNbZXSzkdxjPgMwKVbPnToP/Zx3RKU88yn79VGrvejjqpvwbfDHcTMKEWow6wJ/5PyQ+
         kGQzu9d4e31Mbm8pVWDWbsIVbRB+XUgIug6o5BR+RiQ+f+ngrRje7+ia/sUM3syDPLMF
         jPzozxY6yRnUA8nqvIOI1OvIdr3sSjsz+mguIl3Ro0tlh44CA0+lvNHknqbQ4Z2E6Kbh
         hS2Dv0yP/MmeSEx/q0xrYwlweQpexpEnQhYIboBdt3ZxKeybY0nO8r4doIGa8IYYDlww
         B8ig==
X-Gm-Message-State: AOAM533jKE3rK2OPSHMTjJ8Zodo6DA54JGZdSv2FMUjPD7gGCzB7/iTT
        hd2ntrxIZNpf4owJe9vn6vnFOwlzMe6mNQ==
X-Google-Smtp-Source: ABdhPJw46QfDw82/hD+J/PYzaMTShx0EMSYaAs5KR9aU4JtKp4wk+QnL092emEPh2og8zNnVxHNQYQ==
X-Received: by 2002:a05:6000:1088:: with SMTP id y8mr7079023wrw.380.1611109787406;
        Tue, 19 Jan 2021 18:29:47 -0800 (PST)
Received: from [192.168.8.137] ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id z15sm977549wrv.67.2021.01.19.18.29.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 18:29:46 -0800 (PST)
Subject: Re: [PATCH] io_uring: simplify io_remove_personalities()
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Yejune Deng <yejune.deng@gmail.com>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1608778940-16049-1-git-send-email-yejune.deng@gmail.com>
 <2c9df437-b5e9-51a8-1ccb-a16f5ed4fae6@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <34904908-cfcf-a7f7-0039-83c6d16c8d6b@gmail.com>
Date:   Wed, 20 Jan 2021 02:26:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2c9df437-b5e9-51a8-1ccb-a16f5ed4fae6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/01/2021 19:25, Pavel Begunkov wrote:
> On 24/12/2020 03:02, Yejune Deng wrote:
>> The function io_remove_personalities() is very similar to
>> io_unregister_personality(),so implement io_remove_personalities()
>> calling io_unregister_personality().
> 
> Please, don't forget to specify a version in the subject, e.g.
> [PATCH v2], add a changelog after "---" and add tags from previous
> threads if any.
> 
> Looks good
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

up

> 
>>
>> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
>> ---
>>  fs/io_uring.c | 28 +++++++++++-----------------
>>  1 file changed, 11 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index b749578..dc913fa 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8608,9 +8608,8 @@ static int io_uring_fasync(int fd, struct file *file, int on)
>>  	return fasync_helper(fd, file, on, &ctx->cq_fasync);
>>  }
>>  
>> -static int io_remove_personalities(int id, void *p, void *data)
>> +static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>>  {
>> -	struct io_ring_ctx *ctx = data;
>>  	struct io_identity *iod;
>>  
>>  	iod = idr_remove(&ctx->personality_idr, id);
>> @@ -8618,7 +8617,17 @@ static int io_remove_personalities(int id, void *p, void *data)
>>  		put_cred(iod->creds);
>>  		if (refcount_dec_and_test(&iod->count))
>>  			kfree(iod);
>> +		return 0;
>>  	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static int io_remove_personalities(int id, void *p, void *data)
>> +{
>> +	struct io_ring_ctx *ctx = data;
>> +
>> +	io_unregister_personality(ctx, id);
>>  	return 0;
>>  }
>>  
>> @@ -9679,21 +9688,6 @@ static int io_register_personality(struct io_ring_ctx *ctx)
>>  	return ret;
>>  }
>>  
>> -static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>> -{
>> -	struct io_identity *iod;
>> -
>> -	iod = idr_remove(&ctx->personality_idr, id);
>> -	if (iod) {
>> -		put_cred(iod->creds);
>> -		if (refcount_dec_and_test(&iod->count))
>> -			kfree(iod);
>> -		return 0;
>> -	}
>> -
>> -	return -EINVAL;
>> -}
>> -
>>  static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
>>  				    unsigned int nr_args)
>>  {
>>
> 

-- 
Pavel Begunkov
