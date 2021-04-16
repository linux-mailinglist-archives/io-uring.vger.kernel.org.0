Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D308E3620D3
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhDPNVT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 09:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbhDPNVT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 09:21:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B55C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:20:54 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id p6so19969719wrn.9
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z31yadWI7DhDAyI+ke3moTU9OmKbDGLtgHmHc2C4zwY=;
        b=G9zzBfoVqrONeA0C9vKP59Rej5UUY0KMITPgaYhqwUJqXoZ/OIS/OKzWB7Gbkmbq2T
         joAYK3td5qyy+jYUaH3Dxe9ZrcmLEMUzzZnBTGk8eK928XjhyxSjUmIZp/bxH2BS9tG1
         FkG2DARlgZ7o5GtkftojtnqGclNN9PvjyNRZB77QC5cHIrllrmDoKyCIW6gHv9t1Q3LD
         O8WYu8+D+O9CS86XEbQnHy/q8MOKExCiOAcece1ErEJCfGS/9ttmNwhrizUH0F/VBsjQ
         nrXwhwuwU8HMCI8eugQpqPiKMtQwMGbb1K9IZa0rjhaLIpj2Bnwtru6VUyqp8i58MIIl
         9o0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Z31yadWI7DhDAyI+ke3moTU9OmKbDGLtgHmHc2C4zwY=;
        b=knLGSJryYZR1S16qsZiuvJq6QdKQuiPcNwNhmrutzoE9yMdOjprLDzwJdEYFDF43Ti
         R+gBms6QFxtkKxVsg09B7ED9/SDd5hsr4g+J06/IUwILoOtpXmFjOAj6baxzbEB5Le2v
         G9UzT22nrKsgZecugmhMYTQqirfPKjJVU/HPU5UHRNYu++vYH50abgji5lBW3w3gJhBx
         Za/33FGV6K8Y9nm6TrSL6hobw+wGU8+u2PQoUh0ldstDPxh61evdV0bdHu6m9DYBELxb
         rK65UouNs/Cp4AZdb+4t2kodum53pDMayYm9gkEmgAsg6FvsWe9r21hsbS3HQqpIki5b
         By2Q==
X-Gm-Message-State: AOAM532NNnKDUoeJp32QUU3H2otN8g+jbYUdQxfvaB1UYmpkfwBDQufw
        98GD2uAEJvDeplmHlf6elOo=
X-Google-Smtp-Source: ABdhPJxVLWi8BIrAeg6anZXBmVbuUnjJ/j2l2dCj6uu6Ibg1EOI5xvfqdm/DkorHifVbEdrHFEEHeg==
X-Received: by 2002:a5d:6d0d:: with SMTP id e13mr4798023wrq.73.1618579253392;
        Fri, 16 Apr 2021 06:20:53 -0700 (PDT)
Received: from [192.168.8.191] ([148.252.132.77])
        by smtp.gmail.com with ESMTPSA id u9sm9093043wmc.38.2021.04.16.06.20.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 06:20:52 -0700 (PDT)
Subject: Re: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
To:     Dennis Zhou <dennis@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        Joakim Hassila <joj@mac.com>, Ming Lei <ming.lei@redhat.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
 <YHkWdgLKBrH51GA7@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <10b84fd7-4c40-3fe6-6993-061b524b1487@gmail.com>
Date:   Fri, 16 Apr 2021 14:16:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <YHkWdgLKBrH51GA7@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/04/2021 05:45, Dennis Zhou wrote:
> Hello,
> 
> On Fri, Apr 16, 2021 at 01:22:51AM +0100, Pavel Begunkov wrote:
>> Add percpu_ref_atomic_count(), which returns number of references of a
>> percpu_ref switched prior into atomic mode, so the caller is responsible
>> to make sure it's in the right mode.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  include/linux/percpu-refcount.h |  1 +
>>  lib/percpu-refcount.c           | 26 ++++++++++++++++++++++++++
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
>> index 16c35a728b4c..0ff40e79efa2 100644
>> --- a/include/linux/percpu-refcount.h
>> +++ b/include/linux/percpu-refcount.h
>> @@ -131,6 +131,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
>>  void percpu_ref_resurrect(struct percpu_ref *ref);
>>  void percpu_ref_reinit(struct percpu_ref *ref);
>>  bool percpu_ref_is_zero(struct percpu_ref *ref);
>> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref);
>>  
>>  /**
>>   * percpu_ref_kill - drop the initial ref
>> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
>> index a1071cdefb5a..56286995e2b8 100644
>> --- a/lib/percpu-refcount.c
>> +++ b/lib/percpu-refcount.c
>> @@ -425,6 +425,32 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
>>  }
>>  EXPORT_SYMBOL_GPL(percpu_ref_is_zero);
>>  
>> +/**
>> + * percpu_ref_atomic_count - returns number of left references
>> + * @ref: percpu_ref to test
>> + *
>> + * This function is safe to call as long as @ref is switch into atomic mode,
>> + * and is between init and exit.
>> + */
>> +unsigned long percpu_ref_atomic_count(struct percpu_ref *ref)
>> +{
>> +	unsigned long __percpu *percpu_count;
>> +	unsigned long count, flags;
>> +
>> +	if (WARN_ON_ONCE(__ref_is_percpu(ref, &percpu_count)))
>> +		return -1UL;
>> +
>> +	/* protect us from being destroyed */
>> +	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
>> +	if (ref->data)
>> +		count = atomic_long_read(&ref->data->count);
>> +	else
>> +		count = ref->percpu_count_ptr >> __PERCPU_REF_FLAG_BITS;
> 
> Sorry I missed Jens' patch before and also the update to percpu_ref.
> However, I feel like I'm missing something. This isn't entirely related
> to your patch, but I'm not following why percpu_count_ptr stores the
> excess count of an exited percpu_ref and doesn't warn when it's not
> zero. It seems like this should be an error if it's not 0?
> 
> Granted we have made some contract with the user to do the right thing,
> but say someone does mess up, we don't indicate to them hey this ref is
> actually dead and if they're waiting for it to go to 0, it never will.

fwiw, I copied is_zero, but skimming through the code don't immediately
see myself why it is so...

Cc Ming, he split out some parts of it to dynamic allocation not too
long ago, maybe he knows the trick.

> 
>> +	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
>> +
>> +	return count;
>> +}
>> +
>>  /**
>>   * percpu_ref_reinit - re-initialize a percpu refcount
>>   * @ref: perpcu_ref to re-initialize
>> -- 
>> 2.24.0
>>

-- 
Pavel Begunkov
