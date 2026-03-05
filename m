Return-Path: <io-uring+bounces-12561-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gEgQBCifqWnGAwEAu9opvQ
	(envelope-from <io-uring+bounces-12561-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 16:20:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8113E2145D7
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 16:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8369E30AE7B3
	for <lists+io-uring@lfdr.de>; Thu,  5 Mar 2026 15:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248C5387570;
	Thu,  5 Mar 2026 15:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qr9pFu64"
X-Original-To: io-uring@vger.kernel.org
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4641636683F;
	Thu,  5 Mar 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723542; cv=none; b=rqbKUj79A9IYPJZ6jqi6mYJ8xX29gBRRa0Eg/ezJ1vr6yWqMm0zkunb0ds/AZkM3SklNvRIEaz6vhI7MUfik5PIAWi5QYUhpr6/uH+mux9hVg+3SZL1vgKbx0phAYzQmcE+QcanQ/c8sjhV9IutLAEuUG66n4JwKcRNRujNwI/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723542; c=relaxed/simple;
	bh=r0DH9G4+3Q2vzRVNT75pQmyphKPzro1jFxZsWt/Ntx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kSPgUCgXUZT9qe21o10i86zDYi/aaipIyD02VI5g7Zy4F5uR1ry5UgVqWNSBESBz9YGQB+46waTA4rIIO7/Xfw0K61UwmBoJvbOGyIFQ8k78XofWqApGIqZm1CZdpecTOJZv/3LbAyy95laRJdHRqWkZLR/3xQhgSruA6393FZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qr9pFu64; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRY1H40ZWz1XM0pg;
	Thu,  5 Mar 2026 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772723535; x=1775315536; bh=r0DH9G4+3Q2vzRVNT75pQmyp
	hKPzro1jFxZsWt/Ntx0=; b=qr9pFu64ct3q6eK4+TbmOLnQ7afp75JGfS7DfjIK
	oln5R6mk4LA7ddbY7bVw9Nc3NIThbL92Ktc8/AbkKFcWbx1kS2SKaLggE/I6v0Tj
	uVy7wyx0sqKF+8VHTRPL58A2X54A+byMRARGX126UDFoZjtqqQESFjxptpKMT4u0
	ciP3MQOowzVrHIK7QItdr9fSl/He2fgn2BoDtrE0wHQIbJwoBJ8uDw5ccW9/Xz9S
	hZACt6ZyuxoOgailHQdz6ygaugA3d42kDYGKhfQfdeFzm2xTLWxcSL9i9eNRSCkY
	I/8xPfpFRfLas59Qg5i07ejlbOI04g5sLmoHdgVFxKrLdw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vuN-4LTns2oG; Thu,  5 Mar 2026 15:12:15 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRY183dj8z1XM6JR;
	Thu,  5 Mar 2026 15:12:12 +0000 (UTC)
Message-ID: <3ce6f611-330c-4705-9842-f85eb9a13556@acm.org>
Date: Thu, 5 Mar 2026 09:12:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] bsg: add io_uring command support for SCSI
 passthrough
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, fujita.tomonori@lab.ntt.co.jp,
 axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8113E2145D7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[acm.org:+];
	TAGGED_FROM(0.00)[bounces-12561-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[acm.org:dkim,acm.org:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/4/26 7:28 PM, Yang Xiuwei wrote:
> This series adds io_uring command support to the BSG SCSI passthrough
> path.

Please send a new version of a patch series as a new email thread.
Otherwise the new version may get overlooked.

Thanks,

Bart.

