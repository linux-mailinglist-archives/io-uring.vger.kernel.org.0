Return-Path: <io-uring+bounces-13528-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCahJPMXF2px3wcAu9opvQ
	(envelope-from <io-uring+bounces-13528-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:12:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD9D5E7873
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 18:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4464C30A459F
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42928400DF3;
	Wed, 27 May 2026 16:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IbvuBZZ/"
X-Original-To: io-uring@vger.kernel.org
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9163E7BDF;
	Wed, 27 May 2026 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897825; cv=none; b=MTHkz02oChGVr/rQ2bLMCEWAxMnoe4NwoltS6rnt+SUzUuRHhcuPfMgTC2VQnmyvOYXRFS2n985FWCYTOOjYTHoZdCyAPhWWAIZUYhlKkwh4vaBzyqJQ0xVoXdh5vnKu+z846bI+qHLAtn+PtPHWStsTcNz8LRaBYe0Dph43ZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897825; c=relaxed/simple;
	bh=pbpcF99gY83mrSQXs+1lbUHoWkniY8Y68mLqAKtNy+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HURuTlq2VkDOSK2FTy1jEcggBpL2yCO0qL6HCXnEngmuUctinBdGsE1HoKC3ZasvrJzOVp4rnjG1XRhNoiOBPgl2AjAz3OaZUDVL7Pkkzwg8Z03Zz0pYcZOXLJsE4K11ju7ZxiSFOkCNt8qzgL8/Vc5EKlN4RavA6u8fJbPoxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IbvuBZZ/; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gQZDH2xKMzlfpMD;
	Wed, 27 May 2026 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779897819; x=1782489820; bh=vqhvLK2VzyuhCBI9AetGvgdg
	PFfzku4JN/wmMoUOPhE=; b=IbvuBZZ/9ZJ6+3cBDBxMbgVD4YW0np0oeRBMVRRB
	Xvighr4KvjxCTvDuGKaX5n9OrTO2jiNTu78uQL5pDrnKEusdKAoeQY/sbUnuKo7J
	f34TVkHuayFCviYpO3gGXpsR33uyB4cKoIseit2QiLg75UMV0VwSWK8xA7uJqVas
	KpRbc+EiPBlavZJmXY+l4J4/XBk4nBuVKbI2XrJZGO6x8AYg6pLPzx6YfawCaJtB
	9RmQgW/0dfbYi9I7ljeMnXoh1jhbGJ/Ltj/sCzRvo2JngE0EqXYvZOoRGkJP9X5+
	0KbRW+Tc/qHcyhuJBPw2ZenXwv3esqvyUS6fZKQ22lnw6g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S-FmIe6cFsKU; Wed, 27 May 2026 16:03:39 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gQZD82D8Bzlh2g0;
	Wed, 27 May 2026 16:03:35 +0000 (UTC)
Message-ID: <155fb425-b503-44e2-bd11-444b8baeb5bb@acm.org>
Date: Wed, 27 May 2026 09:03:35 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
To: Rahul Chandelkar <rc@rexion.ai>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260527105931.3950913-1-rc@rexion.ai>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260527105931.3950913-1-rc@rexion.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[acm.org:+];
	TAGGED_FROM(0.00)[bounces-13528-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bvanassche@acm.org,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,acm.org:email,acm.org:mid,acm.org:dkim]
X-Rspamd-Queue-Id: 7FD9D5E7873
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/27/26 3:59 AM, Rahul Chandelkar wrote:
> scsi_bsg_uring_cmd() and scsi_bsg_map_user_buffer() read bsg_uring_cmd
> fields directly from the shared mmap'd io_uring submission ring via
> io_uring_sqe128_cmd().  On the inline execution path, io_uring has not
> yet copied the SQE to kernel memory, so a concurrent userspace thread
> can modify fields between reads.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

