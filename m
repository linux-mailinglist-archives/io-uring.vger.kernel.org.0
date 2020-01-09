Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07040136293
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2020 22:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgAIVbJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jan 2020 16:31:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41791 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgAIVbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jan 2020 16:31:07 -0500
Received: by mail-pg1-f193.google.com with SMTP id x8so3815955pgk.8
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2020 13:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w2PoPk4Xe2m70IyjlDEMCovR984pssPNvk9J9XjKsBQ=;
        b=SUkHLnvgtmTLGRstmBCX+mdY6MfaVx3u9xZ7Y1e5HiMhgdOxl565yTGc2H4bhNK2xv
         uqt7UI7Y6j11QRw8qo16jRJSQ5hiDtNLSlAZiEu7UlxL4/s+PtecKQ9n9KvLvN1cvVTQ
         Dl0vdK1CDV+iBvoB0daTO8T+mMo19GM6mYgIBVAbJzOwM3OIJhtLQrIB+XwfU6+deq1W
         tySn5UzldtSe6GE47vQYu1m3ksRddKBOKyArVAnAalLLUdr0d9jz21yN8sM4lm3EwR+1
         l4kBWFygTwE77859tdbW0MHusqJd22OtFvSZFcouhyEb0LUdJ+hqQ/wuoxqW4Dj+y8eg
         MC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w2PoPk4Xe2m70IyjlDEMCovR984pssPNvk9J9XjKsBQ=;
        b=d47TriZgtvvlhYgF6gXFmbXN7ALHQ43MtsfOdFa8qBiM+kJ2i1LhsNiA7PfYZrjm/b
         86EfF0yXxZGEgkJmW1GQq4Kpk3L6RVgESmckNq/vOHNzaiTO9UQ7rStj0j4V+tLvwewT
         9pGYHuR887FI25PE4kkWjmuX/ttC99HjI/3enUUEfAQVnp85jLAYtCG7UVgrTxG7EI3O
         qWCXzvjTyydk1TivXzuuKR4+j68Pr0m9R2zRO0hc2qOprnARJPhKpdA9mKw6HuwNIgJ8
         wEcCC54/fgJB+Fo/q+/EF8aP+tkVGhzKwb5dOvdbKranAGqT5c+za6KbG6GyDqNCkfXE
         HfNw==
X-Gm-Message-State: APjAAAUEnytEtfItL4G0oqQ0tw7ljAuivm3PyPBXRzboDLXHbEncOFDg
        Ktd8pMtHZlpLrLQpQf4xpfXs1A==
X-Google-Smtp-Source: APXvYqx9sElCh3L/wbFk9pjWAD2TRjtSq58x6hiYQekTg2mA/W1ipiPUSrcrcY4guXiDpOAOeQY9Vw==
X-Received: by 2002:aa7:855a:: with SMTP id y26mr13550854pfn.175.1578605466213;
        Thu, 09 Jan 2020 13:31:06 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g18sm9069860pfi.80.2020.01.09.13.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 13:31:05 -0800 (PST)
Subject: Re: [PATCH 3/6] io_uring: add support for IORING_OP_OPENAT
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20200107170034.16165-1-axboe@kernel.dk>
 <20200107170034.16165-4-axboe@kernel.dk>
 <82a015c4-f5b9-7c85-7d80-78964cb0d82e@samba.org>
 <4ccb935c-7ff9-592f-8c27-0af3d38326d7@kernel.dk>
 <2afdd5a5-0eb5-8fba-58d1-03001abbab7e@samba.org>
 <9672da37-bf6f-ce2d-403c-5e2692c67782@kernel.dk>
 <d0f0e726-8e6f-aa43-07b6-fdb3b49ce1bc@samba.org>
 <d5a5dc20-7e11-8489-b9d5-c2cf8a4bdf4b@kernel.dk>
 <a0f1b3a0-9827-b3e1-da0c-a2b71151fd4e@samba.org>
 <0b8a0f70-c2de-1b1c-28d4-5c578a3534eb@kernel.dk>
 <d42d5abd-c87b-1d97-00f3-95460a81c527@samba.org>
 <7c97ddec-24b9-c88d-da7e-89aa161f1634@kernel.dk>
 <cbbebc78-3e3d-b12a-c2dc-9018d4e99c17@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <17dac99c-e3c5-0e50-c26d-c159c1e1724d@kernel.dk>
Date:   Thu, 9 Jan 2020 14:31:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <cbbebc78-3e3d-b12a-c2dc-9018d4e99c17@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/20 3:40 AM, Stefan Metzmacher wrote:
>>> I'm sorry, but I'm still unsure we're talking about the same thing
>>> (or maybe I'm missing some basics here).
>>>
>>> My understanding of the io_uring_enter() is that it will execute as much
>>> non-blocking calls as it can without switching to any other kernel thread.
>>
>> Correct, any SQE that we can do without switching, we will.
>>
>>> And my fear is that openat will use get_current_cred() instead of
>>> ctx->creds.
>>
>> OK, I think I follow your concern. So you'd like to setup the rings from
>> a _different_ user, and then later on use it for submission for SQEs that
>> a specific user. So sort of the same as our initial discussion, except
>> the mapping would be static. The difference being that you might setup
>> the ring from a different user than the user that would be submitting IO
>> on it?
> 
> Our current (much simplified here) flow is this:
> 
>   # we start as root
>   seteuid(0);setegid(0);setgroups()...
>   ...
>   # we become the user555 and
>   # create our desired credential token
>   seteuid(555); seteguid(555); setgroups()...
>   # Start an openat2 on behalf of user555
>   openat2()
>   # we unbecome the user again and run as root
>   seteuid(0);setegid(0); setgroups()...
>   ...
>   # we become the user444 and
>   # create our desired credential token
>   seteuid(444); seteguid(444); setgroups()...
>   # Start an openat2 on behalf of user444
>   openat2()
>   # we unbecome the user again and run as root
>   seteuid(0);setegid(0); setgroups()...
>   ...
>   # we become the user555 and
>   # create our desired credential token
>   seteuid(555); seteguid(555); setgroups()...
>   # Start an openat2 on behalf of user555
>   openat2()
>   # we unbecome the user again and run as root
>   seteuid(0);setegid(0); setgroups()...
> 
> It means we have to do about 7 syscalls in order
> to open a file on behalf of a user.
> (In reality we cache things and avoid set*id()
> calls most of the time, but I want to demonstrate the
> simplified design here)
> 
> With io_uring I'd like to use a flow like this:
> 
>   # we start as root
>   seteuid(0);setegid(0);setgroups()...
>   ...
>   # we become the user444 and
>   # create our desired credential token
>   seteuid(444); seteguid(444); setgroups()...
>   # we snapshot the credentials to the new ring for user444
>   ring444 = io_uring_setup()
>   # we unbecome the user again and run as root
>   seteuid(0);setegid(0);setgroups()...
>   ...
>   # we become the user555 and
>   # create our desired credential token
>   seteuid(555); seteguid(555); setgroups()...
>   # we snapshot the credentials to the new ring for user555
>   ring555 = io_uring_setup()
>   # we unbecome the user again and run as root
>   seteuid(0);setegid(0);setgroups()...
>   ...
>   # Start an openat2 on behalf of user555
>   io_uring_enter(ring555, OP_OPENAT2...)
>   ...
>   # Start an openat2 on behalf of user444
>   io_uring_enter(ring444, OP_OPENAT2...)
>   ...
>   # Start an openat2 on behalf of user555
>   io_uring_enter(ring555, OP_OPENAT2...)
> 
> So instead of constantly doing 7 syscalls per open,
> we would be down to just at most one. And I would assume
> that io_uring_enter() would do the temporary credential switch
> for me also in the non-blocking case.

OK, thanks for spelling the use case out, makes it easier to understand
what you need in terms of what we currently can't do.

>> If so, then we do need something to support that, probably an
>> IORING_REGISTER_CREDS or similar. This would allow you to replace the
>> creds you currently have in ctx->creds with whatever new one.
> 
> I don't want to change ctx->creds, but I want it to be used consistently.
> 
> What I think is missing is something like this:
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 32aee149f652..55dbb154915a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6359,10 +6359,27 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,
> fd, u32, to_submit,
>                 struct mm_struct *cur_mm;
> 
>                 mutex_lock(&ctx->uring_lock);
> +               if (current->mm != ctx->sqo_mm) {
> +                       // TODO: somthing like this...
> +                       restore_mm = current->mm;
> +                       use_mm(ctx->sqo_mm);
> +               }
>                 /* already have mm, so io_submit_sqes() won't try to
> grab it */
>                 cur_mm = ctx->sqo_mm;
> +               if (current_cred() != ctx->creds) {
> +                       // TODO: somthing like this...
> +                       restore_cred = override_creds(ctx->creds);
> +               }
>                 submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
>                                            &cur_mm, false);
> +               if (restore_cred != NULL) {
> +                       revert_creds(restore_cred);
> +               }
> +               if (restore_mm != NULL) {
> +                       // TODO: something like this...
> +                       unuse_mm(ctx->sqo_mm);
> +                       use_mm(restore_mm);
> +               }
>                 mutex_unlock(&ctx->uring_lock);
> 
>                 if (submitted != to_submit)
> 
> I'm not sure if current->mm is needed, I just added it for completeness
> and as hint that io_op_defs[req->opcode].needs_mm is there and a
> needs_creds could also be added (if it helps with performance)
> 
> Is it possible to trigger a change of current->mm from userspace?
> 
> An IORING_REGISTER_CREDS would only be useful if it's possible to
> register a set of credentials and then use per io_uring_sqe credentials.
> That would also be fine for me, but I'm not sure it's needed for now.

I think it'd be a cleaner way of doing the same thing as your patch
does. It seems a little odd to do this by default (having the ring
change personalities depending on who's using it), but from an opt-in
point of view, I think it makes more sense.

That would make the IORING_REGISTER_ call something like
IORING_REGISTER_ADOPT_OWNER or something like that, meaning that the
ring would just assume the identify of the task that's calling
io_uring_enter().

Note that this also has to be passed through to the io-wq handler, as
the mappings there are currently static as well.

-- 
Jens Axboe

