Return-Path: <io-uring+bounces-13225-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mNLNJoRM+GmQsQIAu9opvQ
	(envelope-from <io-uring+bounces-13225-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:36:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 564E24B96C2
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 09:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AF4B830010CA
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 07:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29C926F476;
	Mon,  4 May 2026 07:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="iNt0FsYr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3412DCF45
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 07:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777880194; cv=none; b=ayTlNnzvQnFRstma1vopLJ7WEvLDZWISvpBPvMsuYCXoxBQs96FMX1EsDpYaHGp4kpKSvE1X/JxZcc0sPoLyFJGt1vF08wSFJPGnSmjOPkyCBKlsn87Gsk0suiDI9TD3hxw6zlDlN7rt7sQKxoCFYaLxRZ9ee96/RXFXWC0OwSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777880194; c=relaxed/simple;
	bh=RFsRek9q+NKHB3tf9ZbR+XT4Oz/+g132wacizMGXOAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=S7/rM7z8ur2xbH8gmuXdBBrPhW4e987ymHqyAeT01Zk1ESXqW/pUFpg239edgj3eV2Okfhe8NZyDSRZW450LfmfFQv11V2D9cfjPXNQPT0ZhIFE0l3WS2+MQ5zBmrnzNtiebmH93Of8CN+Zk67FSpDsQdDw1kG4S4cM8EbZpY8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=iNt0FsYr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48374014a77so42415675e9.3
        for <io-uring@vger.kernel.org>; Mon, 04 May 2026 00:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777880191; x=1778484991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HMBD1lT6zk2vJIQQ4bpn0GWbP5NIlu/0+HmIbFXhFsE=;
        b=iNt0FsYrrkAxOmcBX9V3nNKxthNfuChqQASLDaBGvxR6tnwSZzessL/uNgICLQOfM4
         HOspFBwEZ2aAcNchFVciQR/XtGQWYXyyDVS4KYVPKmmH0fBnfmk7gGjIWmbjvxWEKm9b
         /1dJVKlMJHr4tYZvYwFMTVpQnybCN5BwfRHO6JpyjwZsZ2/HFFkYB0a455vVcV2aMFGE
         J8u+DOLHGkDvISv8NeUlZ3NnAa+JiQf77eDzCMGNRpMjj/8dlRw2fPI7gHHNDzGqSPuD
         nfVIyAfhX176E9wuORIqgjsb3eM5d8kFBiFfiPSOls8OX7kU/BgCImog2i8HXDrSyfb4
         KTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777880191; x=1778484991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMBD1lT6zk2vJIQQ4bpn0GWbP5NIlu/0+HmIbFXhFsE=;
        b=n3hIM7RRMr1vFQuEYp/5E91e4tDb0VacjbImuSthdRakLMf9VjyNQjG6umAyWPYl/c
         HIAbP2KCvSdJYiIyh0QWAgWw9zsEQYJpnSVxfTAuMcMn0cEponzyCtTP358pL3hKrjyX
         i9EwBVARKeqSfynQXoAAuHkiLbqQPNe+P69dJ+PhCSpPUP7eZ+vMc2TwkQu5ORGecc8I
         WtdqYGSpsvok+QMpUpsNW2a0kVK67N1ZfZUSdyORz5ys45HzqVcMtquYtFWhpsaVQcAg
         VcLR/+OnbgQSVr7RWPpIBrjTXIwfCUkM6lOgZbT69LwB2hAhq4euwve3DL7TSUIfMUdI
         x1ig==
X-Forwarded-Encrypted: i=1; AFNElJ8lbBT/VRsXFR/brMqYyJBf05KuEvRz0MYEPs6cSOWCTiozWdlrRdS/wQGso3Ahu99TXbAcgdiYnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxRVzErbOFo8fvAUka4rbAPIZCGWIqt3pWRPLJ1WtZIP7uE+Jm0
	w3HlE+wYDn86mNcW7jbbz6UWOaxSSvjtrFpA9FeVE3Fx4va/TWqGSjHwnaM00kthVxg=
X-Gm-Gg: AeBDieviriEip8ET6PfyGQd3r6eD4KsMUJxhIOc2GtkEE6jThZ25ZWAVVzVSuzOGK+H
	ziOKzUfHeMXTAwo3CjQrWVeADdVKWYgF4dU2wixZVgfSxwYZemRgeHl/8mK9H2oUFTYfNBFVFDS
	De3UoYMSA+K3m9ZkiKEI8Uz6g3QgULco50LpzY4gWRbw+Q6G1m6pjIX8gFCSOL2mSQqhRpmDMOb
	9OnatV4NazAyOnUPR8887EIXKHU3kcmOFx7Y6Zy3G7jrBNAOm20JXWj4MU0OkWNMtvkOaE8cOVk
	t02v4pNdmF6NqOQOboW44238wrl0bQjrSucYuKmMLM2ls5vnxEKKNFCiv94hvTH+z+ypvr+7czB
	zyxOCn8mUMM1my1K5FfGwapLw86OkrtdK0mgRM9r08642wgl5uWU1JSsRv9V4v+qAwHpV2rrhiM
	+PkZodNYSsJL3wqXy4FjMDkd/YMZsD+1v97aC8G8bKAbEvr6Lsyi0aWf60mcxEulvQxx8WULWht
	GXv2FC2UTNgxSjko4nu
X-Received: by 2002:a05:600c:45d4:b0:489:1c5f:3a9e with SMTP id 5b1f17b1804b1-48a9865e17dmr128216615e9.13.1777880191370;
        Mon, 04 May 2026 00:36:31 -0700 (PDT)
Received: from [10.211.8.175] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb75fc1sm261856745e9.7.2026.05.04.00.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 00:36:30 -0700 (PDT)
Message-ID: <81b3d4de-3c3f-471d-8c24-0724318080a1@kernel.dk>
Date: Mon, 4 May 2026 01:36:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] io_uring/rsrc: add huge page accounting for registered
 buffers
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@meta.com>,
 io-uring <io-uring@vger.kernel.org>
References: <d377141e-064e-48a2-9a76-8477a90e8655@kernel.dk>
 <f2e104e2-0110-4dca-a285-81b0fc63a272@meta.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f2e104e2-0110-4dca-a285-81b0fc63a272@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 564E24B96C2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13225-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+]

On 5/4/26 1:31 AM, Cl?ment L?ger wrote:
>>     static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>> -            struct iovec *iov, struct page **last_hpage);
>> +                           struct iovec *iov);
>> +
>> +static int hpage_acct_ref(struct io_ring_ctx *ctx, struct page *hpage,
>> +              bool *acct_new)
>> +{
>> +    unsigned long key = (unsigned long) hpage;
>> +    unsigned long count;
>> +    void *entry;
>> +    int ret;
>> +
>> +    lockdep_assert_held(&ctx->uring_lock);
>> +
>> +    entry = xa_load(&ctx->hpage_acct, key);
>> +    if (!entry) {
>> +        ret = xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT);
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>> +    count = 1;
>> +    if (entry)
>> +        count = xa_to_value(entry) + 1;
> 
> Hi Jens,
> 
> Can't most of this be merged in the previous if/else ? ie:
> 
>     entry = xa_load(&ctx->hpage_acct, key);>
>     count = 1;
>     if (!entry) {
>         ret = xa_reserve(&ctx->hpage_acct, key, GFP_KERNEL_ACCOUNT);
>         if (ret)
>             return ret;
>         *acct_new = true;
>     } else {
>         count = xa_to_value(entry) + 1;
>         *acct_new = false;
>     }

Agree, that's nicer. I'll make that change!

>> +static bool hpage_acct_unref(struct io_ring_ctx *ctx, struct page *hpage)
>> +{
>> +    unsigned long key = (unsigned long) hpage;
>> +    unsigned long count;
>> +    void *entry;
>> +
>> +    lockdep_assert_held(&ctx->uring_lock);
>> +
>> +    entry = xa_load(&ctx->hpage_acct, key);
>> +    if (WARN_ON_ONCE(!entry))
>> +        return false;
>> +    count = xa_to_value(entry);
>> +    if (count == 1)
>> +        xa_erase(&ctx->hpage_acct, key);
>> +    else
>> +        xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1), GFP_KERNEL_ACCOUNT);
>> +    return count == 1;
> 
> Maybe something like this could easier to read ?:
> 
>     if (count == 1) {
>         xa_erase(&ctx->hpage_acct, key);
>         return true;
>     }
>     
>     xa_store(&ctx->hpage_acct, key, xa_mk_value(count - 1), GFP_KERNEL_ACCOUNT);
>     return false;

Also agree, that's easier to read.

>> @@ -971,7 +1053,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
>>         imu->ubuf = 0;
>>       imu->len = blk_rq_bytes(rq);
>> -    imu->acct_pages = 0;
>>       imu->folio_shift = PAGE_SHIFT;
>>       refcount_set(&imu->refs, 1);
>>       imu->release = release;
>> @@ -1137,6 +1218,56 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
>>   }
>>     /* Lock two rings at once. The rings must be different! */
> 
> This comment should be before lock_two_rings().

Yeah, I think this happened during forward porting, the patch is
originally from 3 months ago. I'll fix that up too.

Thanks for taking a look!

-- 
Jens Axboe

