Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E537A261FC4
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 22:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgIHUGS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 16:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730174AbgIHPVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 11:21:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C64C061A26
        for <io-uring@vger.kernel.org>; Tue,  8 Sep 2020 07:11:23 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t13so15474459ile.9
        for <io-uring@vger.kernel.org>; Tue, 08 Sep 2020 07:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OHvbRXVoAlbH+nZ+Ry+bppsZ5cArVjRBIq20J5epYZE=;
        b=Y3BnknTTxzpYWeOtvKafu8jhQPpfUlqvx84mybYPLVuHDu1yLTAECelCsX1psLQFIx
         Sh/+QRM/+/ZY7xXfxEeb7hgmABXo/n5adplQ9f6siP93pnJTUT+lk0bdQUp+U2rteGoS
         N6foPSUl0Xg9ddDiUQdyoXQ3YabQwnR5vcphkw7Id7k0HTran54Irdk6LSJRFUh1Wg5I
         qn6lmTuat2tkdLH/FigmvHhlTwqBee+GypFKn8UL1H+9eNu57gzIByWYl0RfUqtxeBQm
         9NwtKKqU8TQgpyVglyQ+NyxfrBF5AD2DKW0aFBaDtVbufFiNw4vPM3644rlFpV/8HgMy
         cdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHvbRXVoAlbH+nZ+Ry+bppsZ5cArVjRBIq20J5epYZE=;
        b=swPin9z063jwKBYGaJAYVmBWYaUNOfxULQ8XtVN80RhYd45AQAigtfy+P3H9ijOhiq
         48MI2RdOVxA57rwCrJIPwVgZ3gLtRUZp/psmNAXOnUEfOExxSTcY/1I4p7wS816je3PA
         u0B2yHGk5rFQxTkOV0wHI3qXHQZY9GOA4cJSlWGHFdW3p1Odu/0nbpZo0X1AAyQACPfG
         +qk2VsHK2TWSIEk4TA25O+cWBd7GhEBeuHdfNQXcOrjXMGRzt20LF02DVSCkh1PBOY/W
         jEh+aaaBI8cxpqOGf+RiHo0sEwIBRG54kJrhN1uv1X0lnsP+wogyTqAMkockW18z0DDX
         KCGw==
X-Gm-Message-State: AOAM530cugSeYVo7ghvpq8CEZxQzcG6DjBvSnJhSyasbZ2/imuDqePC9
        +VSOB7TN2xeK/sAEll23i5SOrg==
X-Google-Smtp-Source: ABdhPJxf2DetGDc5OpRwh1PWzzjmhhvDX1ykRrlBHRxnWPaAZeZPvEJQeaCdQUV6c70rXXNN8w2Etw==
X-Received: by 2002:a92:77d4:: with SMTP id s203mr22574147ilc.136.1599574282270;
        Tue, 08 Sep 2020 07:11:22 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c14sm10398940ill.15.2020.09.08.07.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 07:11:21 -0700 (PDT)
Subject: Re: [PATCH v6 3/3] io_uring: allow disabling rings during the
 creation
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        Aleksa Sarai <asarai@suse.de>,
        Sargun Dhillon <sargun@sargun.me>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20200827145831.95189-1-sgarzare@redhat.com>
 <20200827145831.95189-4-sgarzare@redhat.com>
 <20200908134448.sg7evdrfn6xa67sn@steredhat>
 <045e0907-4771-0b7f-d52a-4af8197e6954@kernel.dk>
 <20200908141003.wsm6pclfj6tsaffr@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d1b18bdb-e718-3285-cfb3-0e2b73f03554@kernel.dk>
Date:   Tue, 8 Sep 2020 08:11:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908141003.wsm6pclfj6tsaffr@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/20 8:10 AM, Stefano Garzarella wrote:
> On Tue, Sep 08, 2020 at 07:57:08AM -0600, Jens Axboe wrote:
>> On 9/8/20 7:44 AM, Stefano Garzarella wrote:
>>> Hi Jens,
>>>
>>> On Thu, Aug 27, 2020 at 04:58:31PM +0200, Stefano Garzarella wrote:
>>>> This patch adds a new IORING_SETUP_R_DISABLED flag to start the
>>>> rings disabled, allowing the user to register restrictions,
>>>> buffers, files, before to start processing SQEs.
>>>>
>>>> When IORING_SETUP_R_DISABLED is set, SQE are not processed and
>>>> SQPOLL kthread is not started.
>>>>
>>>> The restrictions registration are allowed only when the rings
>>>> are disable to prevent concurrency issue while processing SQEs.
>>>>
>>>> The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
>>>> opcode with io_uring_register(2).
>>>>
>>>> Suggested-by: Jens Axboe <axboe@kernel.dk>
>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>> ---
>>>> v4:
>>>>  - fixed io_uring_enter() exit path when ring is disabled
>>>>
>>>> v3:
>>>>  - enabled restrictions only when the rings start
>>>>
>>>> RFC v2:
>>>>  - removed return value of io_sq_offload_start()
>>>> ---
>>>>  fs/io_uring.c                 | 52 ++++++++++++++++++++++++++++++-----
>>>>  include/uapi/linux/io_uring.h |  2 ++
>>>>  2 files changed, 47 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 5f62997c147b..b036f3373fbe 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -226,6 +226,7 @@ struct io_restriction {
>>>>  	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
>>>>  	u8 sqe_flags_allowed;
>>>>  	u8 sqe_flags_required;
>>>> +	bool registered;
>>>>  };
>>>>  
>>>>  struct io_ring_ctx {
>>>> @@ -7497,8 +7498,8 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
>>>>  	return ret;
>>>>  }
>>>>  
>>>> -static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>> -			       struct io_uring_params *p)
>>>> +static int io_sq_offload_create(struct io_ring_ctx *ctx,
>>>> +				struct io_uring_params *p)
>>>>  {
>>>>  	int ret;
>>>>  
>>>> @@ -7532,7 +7533,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>>  			ctx->sqo_thread = NULL;
>>>>  			goto err;
>>>>  		}
>>>> -		wake_up_process(ctx->sqo_thread);
>>>>  	} else if (p->flags & IORING_SETUP_SQ_AFF) {
>>>>  		/* Can't have SQ_AFF without SQPOLL */
>>>>  		ret = -EINVAL;
>>>> @@ -7549,6 +7549,12 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>>>>  	return ret;
>>>>  }
>>>>  
>>>> +static void io_sq_offload_start(struct io_ring_ctx *ctx)
>>>> +{
>>>> +	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sqo_thread)
>>>> +		wake_up_process(ctx->sqo_thread);
>>>> +}
>>>> +
>>>>  static inline void __io_unaccount_mem(struct user_struct *user,
>>>>  				      unsigned long nr_pages)
>>>>  {
>>>> @@ -8295,6 +8301,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>>>  	if (!percpu_ref_tryget(&ctx->refs))
>>>>  		goto out_fput;
>>>>  
>>>> +	if (ctx->flags & IORING_SETUP_R_DISABLED)
>>>> +		goto out_fput;
>>>> +
>>>
>>> While writing the man page paragraph, I discovered that if the rings are
>>> disabled I returned ENXIO error in io_uring_enter(), coming from the previous
>>> check.
>>>
>>> I'm not sure it is the best one, maybe I can return EBADFD or another
>>> error.
>>>
>>> What do you suggest?
>>
>> EBADFD seems indeed the most appropriate - the fd is valid, but not in the
>> right state to do this.
> 
> Yeah, the same interpretation as mine!
> 
> Also, in io_uring_register() I'm returning EINVAL if the rings are not
> disabled and the user wants to register restrictions.
> Maybe also in this case I can return EBADFD.

Yes let's do that, EINVAL is always way too overloaded, and it makes sense
to use EBADFD consistently for any operation related to that.

-- 
Jens Axboe

