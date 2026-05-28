Return-Path: <io-uring+bounces-13543-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uK6lG5UQGGrmbQgAu9opvQ
	(envelope-from <io-uring+bounces-13543-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:53:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8233B5EFFBC
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EFAEA329659F
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 09:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837353B1013;
	Thu, 28 May 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="f6IxMZyJ"
X-Original-To: io-uring@vger.kernel.org
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79853AFB11
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 09:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961247; cv=none; b=SRRkRWduOET2TKEptonzuaYty7OY/xsz5L6VNu3vM9L7JE0m6aDro/s19uU5Z2i8SD6KbkKSxsIxc4aDiu/JCchW4DS2d9ihSJ3Ko4HGWjWTRUoWv+0LRtYo4NPhT9H2tnsl/IVmtyhah+5t3cSZsLqksJoHyO6ErHe1JbndOlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961247; c=relaxed/simple;
	bh=LRvnskXB+X4BNB2GiegUwlhjWPxgdl0B8lBtUdPNrpI=;
	h=To:From:Message-Id:In-Reply-To:Subject:Mime-Version:Content-Type:
	 References:Date; b=qctbYd+kfuladfiwyzDNI2O8VPNbJS7pdraT3RMEMtmOCoP8WSeC28BXnIO7uuXx8sbCiVpdPDHKJH+i6LzpkUqvKoee3M6nefwuWRmW996eDuMZZFFBfYt0ZsuH+7LtWrQoseQDfFve/cwMQEEPbnlzbXMEX+YQhQalyA+UrZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=f6IxMZyJ; arc=none smtp.client-ip=209.127.230.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779961233; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9UT7WvwB/rb2gYlyJ1CXeSOfyjr4rrczbHdlA5RdR2A=;
 b=f6IxMZyJFp+c9JbV6nalgsACa6ywTK60XWPTxYLcMacoimGMeTIISNsa6pSfDOPqgTE54M
 TdB2SnZ0K+1jJhrnThGSyguFd9EsTJ6tiaoQ5ClZ2r2RD0a2GyMK1FMcRBmpOnn56HNXI+
 piX31e+ubuiutRVqmvb8/My4Y/CzbHAft8Km6WVyEbelb0Xj8jFKN3ubLHHEZMH/WcY2GZ
 7mylA30fNLUObt/AReD16dMJ36Yc9RdHwdS1cgoqlvjhHqXaVFlbAZTOI/PSBLnRLxdT+A
 SbdknhZ4DswVyHaY0bs2Ca6PZF5BUT2nbZrJKh39t6rGS+Rk2tc65O4A7q3beA==
To: <axboe@kernel.dk>, <asml.silence@gmail.com>, <io-uring@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <bmarzins@redhat.com>, 
	<dm-devel@lists.linux.dev>
From: "Fengnan" <changfengnan@bytedance.com>
Message-Id: <c37f0749-1ae9-48ca-b402-38a552767b12@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Fengnan <changfengnan@bytedance.com>
In-Reply-To: <20260513091349.2194-1-changfengnan@bytedance.com>
Subject: Re: [PATCH RESEND] dm: limit target bio polling to one shot
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20260513091349.2194-1-changfengnan@bytedance.com>
Date: Thu, 28 May 2026 17:40:11 +0800
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a180d8f+2d21e0+vger.kernel.org+changfengnan@bytedance.com>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org,redhat.com,kernel.org,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TAGGED_FROM(0.00)[bounces-13543-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[bytedance.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changfengnan@bytedance.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,bytedance.com:email,bytedance.com:mid,bytedance.com:dkim]
X-Rspamd-Queue-Id: 8233B5EFFBC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

ping..


=E5=9C=A8 2026/5/13 17:13, Fengnan Chang =E5=86=99=E9=81=93:
> dm_poll_bio() is the ->poll_bio() callback for a stacked dm device.
> The caller only knows about the dm queue, so it may decide to do a
> spinning poll if it thinks a single queue is being polled. Passing those
> flags unchanged to the mapped clone lets blk_mq_poll() spin on a target
> queue from inside dm_poll_bio().
>
> With io_uring IOPOLL on a dm-stripe target this can keep a task in
>
>    dm_poll_bio() -> bio_poll() -> blk_mq_poll()
>
> long enough to trigger an RCU CPU stall, before io_uring gets back to
> io_iopoll_check() and its need_resched() check.
>
> Keep dm's ->poll_bio() bounded by forcing one-shot polling for target
> bios. The caller can invoke dm_poll_bio() again if it wants to keep
> polling, and it also gets a chance to reap completions or reschedule
> between passes.
>
> Fixes: f22ecf9c14c1 ("blk-mq: delete task running check in blk_hctx_poll(=
)")
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>   drivers/md/dm.c | 13 +++++++++++--
>   1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index e178fe19973ea..8f44fbbcf3da2 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2098,8 +2098,17 @@ static bool dm_poll_dm_io(struct dm_io *io, struct=
 io_comp_batch *iob,
>   	WARN_ON_ONCE(!dm_tio_is_normal(&io->tio));
>  =20
>   	/* don't poll if the mapped io is done */
> -	if (atomic_read(&io->io_count) > 1)
> -		bio_poll(&io->tio.clone, iob, flags);
> +	if (atomic_read(&io->io_count) > 1) {
> +		/*
> +		 * DM hides the target queues from the upper poller, which may
> +		 * decide it is safe to spin on a single stacked queue.  Do not
> +		 * pass that spinning policy down to a target queue: one slow
> +		 * clone could keep the task inside dm_poll_bio() for a long
> +		 * time.  Poll target bios once and let the caller decide
> +		 * whether to keep polling, reap completions or reschedule.
> +		 */
> +		bio_poll(&io->tio.clone, iob, flags | BLK_POLL_ONESHOT);
> +	}
>  =20
>   	/* bio_poll holds the last reference */
>   	return atomic_read(&io->io_count) =3D=3D 1;

