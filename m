Return-Path: <io-uring+bounces-12564-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKMNNGumqWnwBgEAu9opvQ
	(envelope-from <io-uring+bounces-12564-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 16:51:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 551C3214DC2
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 16:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FDCE319EAC9
	for <lists+io-uring@lfdr.de>; Thu,  5 Mar 2026 15:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E383D5242;
	Thu,  5 Mar 2026 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pGTT5qE3"
X-Original-To: io-uring@vger.kernel.org
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D933D301F;
	Thu,  5 Mar 2026 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772725175; cv=none; b=dCckr+Ca7x9rdtVz+Ir2Z8SneccqOKprgM3MpKOuAHuf8dT2UefR+lOS3dPuSmRqjSd0cFJ52sg1yjEAs5XKM5CpNtQBelitaAz4q7N7Z6zrGSpxcj8KSHvLZYAUBQd2Y4M3srQu3MTI5175BraeyjSkp//ip/YMdiKD/EJOXM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772725175; c=relaxed/simple;
	bh=4vKkD2bQ7wsYqu7NG+qbw589pcm5RiJmrgvrlw1ne80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H27ZTO79J4b1LF2tGGBaYmjF5uO/P7jdAMvOEOM0xVBuzjHrep/vpA/B+evhiY2nLQ7BQspwCJXMUzPHdVdpkWeijye0y9CtOZQ0C9Y3NOP03AVgHibgpP0RU9WT5WTIfSZNqk89ooylNyq0rBiVPGMty78ZEgf1O+O3ijUYYNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pGTT5qE3; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRYcj4cYdz1XLyhV;
	Thu,  5 Mar 2026 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772725169; x=1775317170; bh=ZT1xeQ78rZdKqjwQAgBP42M2
	nv+x1KS/hRB7o+tH3ds=; b=pGTT5qE38kMmle/K0vcUgEGT3h5LTLnnTSHQvb+O
	UzyVovZMYWbWWeZoPp2EZLoPXBXbYEhiDLolpn/vjCL0aGzoTy9CPyRV3+uInABe
	KfF/ULWCDbsqmI191w8vfM50qXoDf7rxxYiiRsS6kNK71WKefthlEjWbUJSkKv04
	asY3i/P/kInfZ/slxs7jkb0bj+kOiMianGMua3RKMYLwGocXjpCVaOVfrwEDNr3R
	nsoQ+B2tHWu3w9RDOv/OC1JapfAniBdwq6921w58fw9iZYhtA5U8QWQ91id3Bhlu
	/4YzF6ld48dMGa4H2C79X+QusIeVs9elLuwDTkdPMNULkg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TEN_fP1-4f8E; Thu,  5 Mar 2026 15:39:29 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRYcZ5ycJz1XM5kD;
	Thu,  5 Mar 2026 15:39:26 +0000 (UTC)
Message-ID: <b3d4d3c0-3992-44be-827b-e9089ab4471c@acm.org>
Date: Thu, 5 Mar 2026 09:39:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] scsi: bsg: add io_uring passthrough handler
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, fujita.tomonori@lab.ntt.co.jp,
 axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-4-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305012857.2136525-4-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 551C3214DC2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[acm.org:+];
	TAGGED_FROM(0.00)[bounces-12564-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[acm.org:dkim,acm.org:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/4/26 7:28 PM, Yang Xiuwei wrote:
> +			u8 device_status;	/* SCSI device status (low 8 bits of result) */
> +			u8 driver_status;	/* SCSI driver status (DRIVER_SENSE if check) */
> +			u8 host_status;		/* SCSI host status (host_byte of result) */

Why separate members for device_status, driver_status and host_status 
instead of storing the SCSI result (scsi_cmnd.result)?

> +	/* Build res2 with status information */
> +	res2 = ((u64)pdu->resid_len << 32) |
> +	       ((u64)(pdu->scsi.sense_len_wr & 0xff) << 24) |
> +	       ((u64)(pdu->scsi.host_status & 0xff) << 16) |
> +	       ((u64)(pdu->scsi.driver_status & 0xff) << 8) |
> +	       (pdu->scsi.device_status & 0xff);

Please remove the superfluous " & 0xff" from u8 expressions.

> +	pdu->scsi.device_status = scmd->result & 0xff;

Please use the status_byte() macro instead of open-coding it.

Thanks,

Bart.

