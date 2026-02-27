Return-Path: <io-uring+bounces-12450-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QFoDK52roWkivgQAu9opvQ
	(envelope-from <io-uring+bounces-12450-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 15:35:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C22D41B90FD
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 15:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4942D3109571
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 14:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88951413249;
	Fri, 27 Feb 2026 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Km44KMej"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC4941B342
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772201297; cv=none; b=YZh7ZzClBarO3Tcthu7OQlpudHSFjMP1fi9Wa9SqeKj3hEGJy3gnD5iqdXWuIFTfvHMrYCr1Q1qpAfmUwfD28fhQudYnFVx0N3K1reiGViJ8BT0L/nwIIS+rgjzYuGOCh00rUIo0YerH92mD7QfTbrNhiqUN97pI3jQdbUjQUcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772201297; c=relaxed/simple;
	bh=IH/uptvNakmH8rwKPcnJi7djklmwXdEmEY0dzV9dd6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AnpbdqlmnAUdUGgmCGUAHcludr7QKrOTVPnEnD4JPmLoQucg01Dylis56sm7bViHq9gJZr3MNLshmOG57VDuDN8gxWAqLQlXIIx1pulnXcnjEDJsV5XpkhBrhwGlzlXCzbVQMTS7AAyOqzs1iy8JqiLkxF2+n+V92vx5O9NZuBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Km44KMej; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=lDio07ggJaXKig7fv2qQwNlZaF2W3w33C/ezDrVIqkQ=; b=Km44KMejrhaeyX6cGa/rY5Fiv5
	711zAqwTUKiVbEe4Ntk3v0vIo4bkx4azsBwhs1+mS1yPIiUAQkcuV+hj5bcZVTsOXkXigwgE6bG2p
	e7GmwWkm5YJOunxgp4+guExgya3tPgBoJR9hCj6kC/DUSFdpm2Ix2U7GnUeAbuJXlQ2p+/uWCSAqs
	b/oewx5qEdB6R+uIb/8v+BmcW8pIkLhrm12XiYZnth7l8v+b5IUjy/fU5rM0qLrQG4SXZAQFlaALG
	tWfDlZ+srexpOCI43IKDnoJgQ3Vhe+SxWffw+6u5gBz1NIG8HYPrvom3/fZNmOAGIz2rQP76sADiF
	Uz7ApxOwTKvhNhmURp39CR5xvajxtEiHRDIhSP6lcvv3NUcrf1QouefyPPOsnPNKgQe+GfrOVueRT
	F/fd3ZT5ApLdCzh2SfBEqYelc3mnXTrqQOS+T5LjAocrgkL29I9D2nGMdffy/WEUpnJw+x2I0RuKC
	k0ulwCKexCWDQmD5Z6vDK3iM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vvyVp-00000008zEo-1hqF;
	Fri, 27 Feb 2026 14:08:13 +0000
Message-ID: <3ae98749-590e-4f8b-a835-c9a15d7866c2@samba.org>
Date: Fri, 27 Feb 2026 15:08:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring/timeout: immediate timeout arg
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: axboe@kernel.dk, Keith Busch <kbusch@kernel.org>
References: <cover.1772015321.git.asml.silence@gmail.com>
 <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <6151302f1dc01d1c4e3176da50ab4224947b709f.1772015321.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samba.org,quarantine];
	R_DKIM_ALLOW(-0.20)[samba.org:s=42];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12450-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[metze@samba.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[samba.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,samba.org:mid,samba.org:dkim]
X-Rspamd-Queue-Id: C22D41B90FD
X-Rspamd-Action: no action

Hi Pavel,

>   	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
>   		return -EINVAL;
> @@ -460,10 +461,20 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   			return -EINVAL;
>   		if (tr->flags & IORING_LINK_TIMEOUT_UPDATE)
>   			tr->ltimeout = true;
> -		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
> +		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK |
> +				  IORING_TIMEOUT_ABS |
> +				  IORING_TIMEOUT_IMMEDIATE_ARG))
>   			return -EINVAL;
> -		if (get_timespec64(&tr->ts, u64_to_user_ptr(READ_ONCE(sqe->addr2))))
> +
> +		arg = READ_ONCE(sqe->addr2);
> +		if (tr->flags & IORING_TIMEOUT_IMMEDIATE_ARG) {
> +			if (tr->flags & IORING_TIMEOUT_ABS)
> +				return -EINVAL;
> +			tr->ts = ns_to_timespec64(arg);

I'm wondering if there is enough free space in a small sqe to hold a full timespec?
So that there is no restriction for IORING_TIMEOUT_ABS...

metze


