Return-Path: <io-uring+bounces-12563-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6J/gAIWhqWl5BQEAu9opvQ
	(envelope-from <io-uring+bounces-12563-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 16:30:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C782148CA
	for <lists+io-uring@lfdr.de>; Thu, 05 Mar 2026 16:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B9CC330D353B
	for <lists+io-uring@lfdr.de>; Thu,  5 Mar 2026 15:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA5A3C276A;
	Thu,  5 Mar 2026 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z7BiU6RX"
X-Original-To: io-uring@vger.kernel.org
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593953BFE29;
	Thu,  5 Mar 2026 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723888; cv=none; b=aJFQew+p8xeC+k3Dtsqp5FGHOLnyGwWdF7mowuFzpAy426964hkmRf7brAIr3rHqBA9ruxMHKjx7JKmwZEWsZbsdWqEiph7mt4PFTJtAHQbveqtztV8vD8tqZADPEFseiA42dXGNcazADMCbilprAJuweAKtCtQ6wBJTjUDP5Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723888; c=relaxed/simple;
	bh=4nZYjED8YNnNBnVQh2FNaZsGgF6vzOORzOtL9Ez3H/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5k1EzoFrhq9Eq7xOCwPBUbKwNsIwybBIdwVi1We+kzzBqRxXcXUl9YGcHeMFoIg6NjV8dk2e+bI8mJN7IazqwD/b3cBzt9wAExU9CPp4FgKnybskllVPfSKnV5tvvwXDPoqC73WmmnsgGY7JkrNtZDUyq5K1+0brpCtOb0VC9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z7BiU6RX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fRY7y6LjPzlfpMC;
	Thu,  5 Mar 2026 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772723883; x=1775315884; bh=YCtyvLy0gs1hmVzUNBuXuXnS
	68gNDqY6hpoyPbBO4Nw=; b=Z7BiU6RXVA90y20zHyOD8JKg71QUN/+wn+TPSlCt
	3Pp+PVN5OMTkzfRe/19Xm+4+PGgN3tKck2h/MuqBimtJyJPRZOkiNsrw6YuxVtBA
	h0Egkfk+dz0yWT+5j7KUcBMJFzDkMIKN5GmqaP0hpZ7mUEIZAQUXIN0HYzjUKDYd
	HJ5fgqHbqjvVW3H4JbjyzXrG4gG7bfg1Ym12b2/QfeMulCg8Ece7jCFIiY421B2Q
	9Z/81dwQeeu41oGylCWL2TD2TYait4eHQBHWCt3J4FEJtAoP2/BwPPKvgefAGOKI
	gfeY8aiolVhQUnUyjB3R62d4b1TJuP91ej+mEg6SR139NQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1kGTZzfQ7AHv; Thu,  5 Mar 2026 15:18:03 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fRY7r0bRgzlfvpG;
	Thu,  5 Mar 2026 15:17:59 +0000 (UTC)
Message-ID: <072ec437-c324-472c-9fed-f9b2c6e69233@acm.org>
Date: Thu, 5 Mar 2026 09:17:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] bsg: add io_uring command support to generic layer
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, fujita.tomonori@lab.ntt.co.jp,
 axboe@kernel.dk, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-1-yangxiuwei@kylinos.cn>
 <20260305012857.2136525-3-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305012857.2136525-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00C782148CA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[acm.org,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[acm.org:s=mr01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	URIBL_MULTI_FAIL(0.00)[acm.org:server fail,sin.lore.kernel.org:server fail];
	TAGGED_FROM(0.00)[bounces-12563-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[acm.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bvanassche@acm.org,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,acm.org:dkim,acm.org:mid]
X-Rspamd-Action: no action

On 3/4/26 7:28 PM, Yang Xiuwei wrote:
> +static int bsg_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> +{
> +	struct bsg_device *bd = to_bsg_device(file_inode(ioucmd->file));
> +	struct request_queue *q = bd->queue;
> +	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
> +	int ret;

Please order declarations from longest to shortest.

> +	if (bd->uring_cmd_fn)
> +		return bd->uring_cmd_fn(q, ioucmd, issue_flags, open_for_write);
> +	return -EOPNOTSUPP;

The traditional Linux kernel coding style is to return early in case of
an error. For the above code that means writing it as follows:

	if (!bd->uring_cmd_fn)
		return -EOPNOTSUPP;

	return bd->uring_cmd_fn(q, ioucmd, issue_flags, open_for_write);

Thanks,

Bart.

