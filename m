Return-Path: <io-uring+bounces-13860-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id mMhUK9oSRGr4nwoAu9opvQ
	(envelope-from <io-uring+bounces-13860-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 21:02:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 037246E760F
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 21:02:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=niRcrtwt;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13860-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13860-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ACFD930B7527
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2026 19:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461933C061C;
	Tue, 30 Jun 2026 19:00:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81CD32B114
	for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 19:00:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782846013; cv=none; b=gEqXhvEj+dB2PH7+r6CftSgOspuqtlpZacqhFp0CpkDCG1N1sWECqqaSUe3xC4Dv8P5uHBN1jLDbt/QbiWLZhx3275exz283vr1kBupHnLrrxS45TKDf2ku7JVhRQphNhtRriMcBldXWcC4MBRYEH/OqQQKw8EWP/B8jdEhuCLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782846013; c=relaxed/simple;
	bh=MRlVly6IwVEUfshQrSGanGM9XCu9NkTsRVEWk3QQIMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u73ZssAGtlc48jFk+dwmzWvTVwf88249HmvUAU85yackSAUrpvYghpjvZFxrIWyyVQnVh+aCgWu2iHZDhK/puu2aLYk+hCr03ERkYEnfSxsRVmoMYUynRqtzO79MnmTgY1VWygcRRGpZKtjYrjP1W50VljBvAQCQnvMo9eWnRNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=niRcrtwt; arc=none smtp.client-ip=209.85.161.42
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6a145935764so1651565eaf.3
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2026 12:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782846009; x=1783450809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pcw0JrYae6holC107hwb8phuCW3lZ9aLQBkPPToEfOI=;
        b=niRcrtwt/hS8Lt34cEYNGldpCA8PrbnDzxh5h6pUvjltXa6Mh0UB8lS/PKjYayc8h8
         KNvklyySBpai1zAJwhKeDr7d0WgKn8Wf9A6E01zytFCMN9Qh5AVitsrlO2LZwtuy5VDl
         fBLmTeHOO71tTtL1yqdLFmWsGezzWFHnJlIAYUlqBq7fJYJ8mwrZdZYidRga9Zpi7N8J
         qFO/UZ9kQ3GfX1rhIVoJBR94cF7+qq4NZdh3c9SB7OXs97rE32KDbVR8alAFzy7o19c7
         M1PfhS11DjzqozR/Yj3mT1Not9M9dXxPprZAnXnEhJBAQKTUWdFBYNpVje2w8waOKwa7
         MTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782846009; x=1783450809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pcw0JrYae6holC107hwb8phuCW3lZ9aLQBkPPToEfOI=;
        b=OXGXSd8mTjyIv6tNjjx7l5NREwSS6GXuF/F+fmu/mltlxv3MxO1M5uIyAFtmEOeSo7
         m0ddZ7XuSPbm5fRKn1mZgaeVwb0b8IK239kFCYxM7hdT06OI3UiaBA5eszr4jqHZgUqi
         mjFxCoUvpa8Mvaw9nG1fkILwR6CqTvtLENUgUmnYmNLiHOD4wHVw4uGRf92lJbvnHqc5
         2yO7qveciOJlJU67eMWZxzERkLYCA/077eej6yjmHnIfUeNe7yD4sMOSriDL+v8mnQKQ
         EUz73od/bPx/Xv+vw5wXUcEsAh3hCvV5ECLVOHlmV94WLCAnTQ3XSQMlH3nMz7t/kQ+w
         rC9g==
X-Forwarded-Encrypted: i=1; AFNElJ9ubdG3tsfvrwBs7AhhK1L0DTDLf7WwNEhB4xlUXd7CIQyzUXkGnoHbrTe/v4tkMwpEljDHdq+YDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YybW8nhYVPIJFNS4mqYU2Pv53yIJwyJXhqxqPKp4wsYjftYe0Me
	5NW7W5Z3ssImO5FBY5PVE+W1L6DX4mOPulZUKn0PRJyujsZkRKXiaoc8ytgBXufLBvfnmZ0eb/6
	O40kbQ8U=
X-Gm-Gg: AfdE7clXUl1CaNC7Ei/OoWt4GUlEs1igYeoU0Mr249cX7MyHPcP1u5Wdeo/jowCJRyL
	Hj9/YHwMhOkS+LegyNPVb7pw4uP41o1JJJoDJB7QZlxbnxftZpNqvnhBLv9cVWpgPYkGdTp+EeV
	m0jvOtA/9yIDe+JGk+lsLpozcKywiDr2iuCOkgvXN8w3gPe+i7Q2ohFwE1e2aYViWS3nEBeR/wI
	TGK9yolbwSabRZX9iaNBSkEvtPSm+TeYIeK3TFhK5/9Os7hNfaQIcae9VWlLjMxzXbtm2KVvtgZ
	9jsO3gJ4wnWW4h4fCiD/4o4aoUTI7n02DatoOmPTaLJLyw53loppb4h3hevx0m1E5BF0bonjYEU
	gmHjf3Dzh+NsdBXpIfUSfWfTvIq+Nj7sxI8Ai+mu/MRjEuf/AVk9UWbBdVS1BfJnBReA4It6B1o
	SgXeJdy/uZ2StDnV2r95Yy5Ny61imKaPW+Crx1iow/6/4VWCuvv2qK0E178LUaZuuF1RM05k0=
X-Received: by 2002:a05:6820:4b06:b0:69e:57a1:8923 with SMTP id 006d021491bc7-6a18902e7e1mr3489458eaf.14.1782846008728;
        Tue, 30 Jun 2026 12:00:08 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a189173c55sm2896161eaf.3.2026.06.30.12.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 12:00:08 -0700 (PDT)
Message-ID: <8c8b9ace-dc84-46bf-8495-44bf2f2b0680@kernel.dk>
Date: Tue, 30 Jun 2026 13:00:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG REPORT] btrfs/io_uring: GPF in tctx_task_work_run after
 encoded read error completion
To: Yue Sun <samsun1006219@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260630091609.3414-1-samsun1006219@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260630091609.3414-1-samsun1006219@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:samsun1006219@gmail.com,m:clm@fb.com,m:dsterba@suse.com,m:linux-btrfs@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,fb.com,suse.com];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13860-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel.dk:mid,kernel.dk:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 037246E760F

On 6/30/26 3:16 AM, Yue Sun wrote:
> Hello,
> 
> I can reproduce a general protection fault on current upstream master by using
> IORING_OP_URING_CMD with BTRFS_IOC_ENCODED_READ on a loop-backed btrfs image
> while fail_make_request injects read errors.
> 
> Summary
> -------
> 
> The crash happens while io_uring is running task_work for a btrfs encoded read
> completion:
> 
>   tctx_task_work_run()
>     mutex_lock(&ctx->uring_lock)
> 
> The faulting mutex address is poisoned:
> 
>   RDI: dead000000001129
>   KASAN: maybe wild-memory-access in range [0xdead000000001128-0xdead00000000112f]
> 
> The root cause might be a double-completion/use-after-free race in the
> btrfs io_uring encoded read error path.
> 
> The timing appears to be:
> 
>   # CPU0: userspace task issues IORING_OP_URING_CMD.
>   io_uring_enter()
>     btrfs_uring_cmd()
>       btrfs_uring_encoded_read()
>         ret = btrfs_encoded_read(...)
>         if (ret == -EIOCBQUEUED)
>           btrfs_uring_read_extent(..., cmd)
> 
>   btrfs_uring_read_extent()
>     priv->cmd = cmd
>     ret = btrfs_encoded_read_regular_fill_pages(..., priv)
> 
>   # In this helper, priv is struct btrfs_encoded_read_private.
>   # uring_ctx points to the caller's struct btrfs_uring_priv.
>   btrfs_encoded_read_regular_fill_pages(..., uring_ctx=priv)
>     refcount_set(&priv->pending_refs, 1)
>     priv->uring_ctx = uring_ctx
>     refcount_inc(&priv->pending_refs)
>     btrfs_submit_bbio(bbio, 0)
> 
>   # CPU1: the submitted bio fails quickly, before CPU0 drops its owner ref.
>   btrfs_encoded_read_endio()
>     WRITE_ONCE(priv->status, bbio->bio.bi_status)
>     refcount_dec_and_test(&priv->pending_refs)
>     # pending_refs goes 2 -> 1, so this context does not queue completion.
> 
>   # CPU0: btrfs_submit_bbio() has returned and the uring branch continues.
>   btrfs_encoded_read_regular_fill_pages(..., uring_ctx=priv)
>     if (refcount_dec_and_test(&priv->pending_refs)) {
>       ret = blk_status_to_errno(READ_ONCE(priv->status))
>       btrfs_uring_read_extent_endio(uring_ctx, ret)
>       kfree(priv)
>       return ret
>     }
> 
>   # Here priv is the caller's struct btrfs_uring_priv.
>   btrfs_uring_read_extent_endio(priv, err)
>     bc->priv = priv
>     io_uring_cmd_complete_in_task(priv->cmd, btrfs_uring_read_finished)
> 
>   # CPU0: task_work is queued, but the helper returns a normal error instead
>   # of -EIOCBQUEUED, so the caller takes the synchronous failure path.
>   btrfs_uring_read_extent()
>     if (ret && ret != -EIOCBQUEUED)
>       goto out_fail
>   out_fail:
>     btrfs_unlock_extent(...)
>     btrfs_inode_unlock(...)
>     kfree(priv)
>     __free_page(...)
>     kfree(pages)
>     return ret
> 
>   # Later, the same task waits for io_uring completions and runs task_work.
>   io_uring_enter()
>     io_cqring_wait()
>       io_run_task_work()
>         task_work_run()
>           tctx_task_work()
>             tctx_task_work_run()
>               req = container_of(node, struct io_kiocb, io_task_work.node)
>               ctx = req->ctx
>               mutex_lock(&ctx->uring_lock)
>               # Crash: req->ctx appears poisoned/stale before
>               # btrfs_uring_read_finished() is reached.

If the work is passed to task_work, then btrfs must return -EIOCBQUEUED.
Looks like a basic bug in btrfs, see below. Caveat - entirely
untested/compiled/whatever. On vacation, btrfs guys can figure this out.


diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 272598f6ae77..51c06618c733 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9460,7 +9460,6 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 			ret = blk_status_to_errno(READ_ONCE(priv->status));
 			btrfs_uring_read_extent_endio(uring_ctx, ret);
 			kfree(priv);
-			return ret;
 		}
 
 		return -EIOCBQUEUED;

-- 
Jens Axboe

