Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8ED148C9A
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 17:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389817AbgAXQ6F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 11:58:05 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:32821 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbgAXQ6E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 11:58:04 -0500
Received: by mail-pj1-f68.google.com with SMTP id m7so761494pjs.0
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 08:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GwXFqvDSv0U+LxmDUU5sHju4TMmZEZGW+kXhJe7jcJM=;
        b=Fm5e4ZVKDvM/voKueHczsL1nCVQpxWHLwo9cjV6HlHB2frlVdVdoriKCXXTzmV4rkG
         0o3tZnyLDv1X/VrQl00k1LWd6o++FKLrm1twzoDKlSd0+KjH3OZkY7C62RKLE9bX0goa
         jsjhfs2mrLzAAZFvdutkomFlCIqK0dwTEW0/lym5NFc80jou+PGk636Zpga2gkOt+tlo
         Tm/33yA0e6NR03h4vZDbtzE/WUyh8RV5Vf76a24yU7e62obDt2Ek9eCUf0Xv5bNVwtJN
         lRflUQ0Z8PJuWmgjGakuR8F0+IiOoHlVdZw1SHj96nwST6mKEpCdAL36wUYYf3ZvpHru
         XGWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GwXFqvDSv0U+LxmDUU5sHju4TMmZEZGW+kXhJe7jcJM=;
        b=AZMddhFN97IP/UJ/d1CQi1anzgL1i3in3WTARBFqqEmmjt45ryMdrZaaJfV2fMs9To
         WlqckFUlAgZPtR1xXQuxB821iA82M9J+PYT82Z1wU96pVOKKAU5nCdItIX//3uMrAcl1
         hTmGBi7/q49RYY7Pfl3YsiifGufFgbZPf5B5xnPAwytATy3MYbzn1OdPd6SW9CGXj/bx
         xXRhZ74uiqzdc2VCu+DN0b6gDyQspe7UQ07RPfsu8PSuIf87tR91P72LTyaMuWI2Y+50
         m+cTBeYV6TIlHKpSxR8p4yPMc40t2ElnZ9uuVFtctOKJ2iPH54FFuZP2ATNUgVbsBCxu
         JSQw==
X-Gm-Message-State: APjAAAXzxe6VygqTDqOld1XR49PaGCwJEGiJ6PI3pKykHnr/X22oJXx/
        HFNWjpVclXFsjDXQpn4nn0aTxTRFCBQ=
X-Google-Smtp-Source: APXvYqyQ8DKgQqt/vpZUzkPeqpmlLosrJN1PHR8nYPCIOHEi/uu6f97gME0PW9aYLL632IOCW6shBA==
X-Received: by 2002:a17:902:8341:: with SMTP id z1mr4373355pln.178.1579885082557;
        Fri, 24 Jan 2020 08:58:02 -0800 (PST)
Received: from [10.47.243.41] ([156.39.10.47])
        by smtp.gmail.com with ESMTPSA id e16sm2801374pff.82.2020.01.24.08.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 08:58:02 -0800 (PST)
Subject: Re: [PATCH 5.4 033/222] io_uring: only allow submit from owning task
To:     Stefan Metzmacher <metze@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20200122092833.339495161@linuxfoundation.org>
 <20200122092835.852416399@linuxfoundation.org>
 <1b4a79c1-6cda-12a8-219b-0c1c146faeff@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8fd1a53-8f75-e9cd-9df5-a79541b9fa14@kernel.dk>
Date:   Fri, 24 Jan 2020 09:58:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1b4a79c1-6cda-12a8-219b-0c1c146faeff@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/20 3:38 AM, Stefan Metzmacher wrote:
> Am 22.01.20 um 10:26 schrieb Greg Kroah-Hartman:
>> From: Jens Axboe <axboe@kernel.dk>
>>
>> commit 44d282796f81eb1debc1d7cb53245b4cb3214cb5 upstream.
>>
>> If the credentials or the mm doesn't match, don't allow the task to
>> submit anything on behalf of this ring. The task that owns the ring can
>> pass the file descriptor to another task, but we don't want to allow
>> that task to submit an SQE that then assumes the ring mm and creds if
>> it needs to go async.
>>
>> Cc: stable@vger.kernel.org
>> Suggested-by: Stefan Metzmacher <metze@samba.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>>
>> ---
>>  fs/io_uring.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3716,6 +3716,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
>>  			wake_up(&ctx->sqo_wait);
>>  		submitted = to_submit;
>>  	} else if (to_submit) {
>> +		if (current->mm != ctx->sqo_mm ||
>> +		    current_cred() != ctx->creds) {
>> +			ret = -EPERM;
>> +			goto out;
>> +		}
>> +
> 
> I thought about this a bit more.
> 
> I'm not sure if this is actually to restrictive,
> because it means applications like Samba won't
> be able to use io-uring at all.
> 
> As even if current_cred() and ctx->creds describe the same
> set of uid,gids the != won't ever match again and
> makes the whole ring unuseable.
> 
> I'm not sure about what the best short term solution could be...
> 
> 1. May just doing the check for path based operations?
>   and fail individual requests with EPERM.
> 
> 2. Or force REQ_F_FORCE_ASYNC for path based operations,
>   so that they're always executed from within the workqueue
>   with were ctx->creds is active.
> 
> 3. Or (as proposed earlier) do the override_creds/revert_creds dance
>   (and similar for mm) if needed.
> 
> To summaries the problem again:
> 
> For path based operations like:
> - IORING_OP_CONNECT (maybe also - IORING_OP_ACCEPT???)
> - IORING_OP_SEND*, IORING_OP_RECV* on DGRAM sockets
> - IORING_OP_OPENAT, IORING_OP_STATX, IORING_OP_OPENAT2
> it's important under which current_cred they are called.
> 
> Are IORING_OP_MADVISE, IORING_OP_FADVISE and IORING_OP_FALLOCATE
> are only bound to the credentials of the passed fd they operate on?
> 
> The current assumption is that the io_uring_setup() syscall captures
> the current_cred() to ctx->cred and all operations on the ring
> are executed under the context of ctx->cred.
> Therefore all helper threads do the override_creds/revert_creds dance.

But it doesn't - we're expecting them to match, and with this change,
we assert that it's the case or return -EPERM.

> But the possible non-blocking line execution of operations in
> the io_uring_enter() syscall doesn't do the override_creds/revert_creds
> dance and execute the operations under current_cred().
> 
> This means it's random depending on filled cached under what
> credentials an operation is executed.
> 
> In order to prevent security problems the current patch is enough,
> but as outlined above it will make io-uring complete unuseable
> for applications using any syscall that changes current_cred().
> 
> Change 1. would be a little bit better, but still not really useful.
> 
> I'd actually prefer solution 3. as it's still possible to make
> use of non-blocking operations, while the security is the
> same as solution 2.

For your situation, we need to extend it anyway, and provide a way
to swap between personalities. So yeah it won't work as-is for your
use case, but we can work on making that the case.

-- 
Jens Axboe

