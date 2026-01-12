Return-Path: <io-uring+bounces-11597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C49ED1475B
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 18:45:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 104603024E72
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 17:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4966B37E2FD;
	Mon, 12 Jan 2026 17:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ei0BsuXx"
X-Original-To: io-uring@vger.kernel.org
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AEA29BDAB;
	Mon, 12 Jan 2026 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239901; cv=none; b=kDPwjbvXgFfLFEc5B3fDqTaN923omhPFttZ7iAMQjT/QXc83cB+moSRxGBYMQPC+il/+fXE3s4lhBraNXdMkXb2NNH5x56tUe8KxMOK3y29YXs48C2Kjl5sYSdZHgpnvauhODSXVDfN64lTJycFcI1kzxepUiiKLKHZ5ZZbNmt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239901; c=relaxed/simple;
	bh=Nw3Mdnjdd+FAXGE3L5NnfSAg8wWbXO9m6KgkYTWnhkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=en2+w36ONUYOVBGqS3LZ6PLl4g3sVfoC7Ulsz2iyFOGQwYtiQu5N1F1cGa9v0BEisHB2oz9xGTVgkjVpdSK2Rt3xtfd0I9Wu7tZPnI2gHmhLD3yLQQGjHphACtkXaYMsJtwsIogC3cpptLzJlKuXdBVwIdvHOVBJM2UVV53PfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ei0BsuXx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dqfsK4ZSpz1XZXnK;
	Mon, 12 Jan 2026 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768239891; x=1770831892; bh=VigNWxwHrVjj5pnwp6TCnMPE
	cgTU7qwBHER/lf6RvEA=; b=Ei0BsuXxrUedzIRBmWURjtjVu4X9z7rC4WLGvX8Y
	TFXBI1lJNxgPfLBnXJkGcWhkim0aMx9htVAyb3U5EEBk1CbXJmQ3C9QotWln33iN
	FWDPbw8TqIzkCe6MnyPZGorrQPQDOk0cRXpZ18oBOPpQWE0BHzqUDYYlqgx/5G24
	ThOCoCas3JvMKDSWfBm0p1RC410MvIytEwY16wBBKOhiWbiOLvrZfRNXd0s4h5/c
	gzuchD4vScEYaXI/iIxSX7QE6/VMSJcSR+5YBN65wdGyrywZ3e6ovbPqhP2vHvua
	1oG6cZfS/aKrlkrwD4/kCdMIUhYCIl5xe21YmIu7TMkd3A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ey46c5ZYvPXZ; Mon, 12 Jan 2026 17:44:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dqfsF6lh3z1XZZ07;
	Mon, 12 Jan 2026 17:44:49 +0000 (UTC)
Message-ID: <93b11693-3734-48ff-8039-29fc46a17cc6@acm.org>
Date: Mon, 12 Jan 2026 09:44:48 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] bsg: add bsg_uring_cmd uapi structure
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
References: <20260112084606.570887-1-yangxiuwei@kylinos.cn>
 <20260112084606.570887-2-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260112084606.570887-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/12/26 1:46 AM, Yang Xiuwei wrote:
> +struct bsg_uring_cmd {
> +	__u64 cdb_addr;
> +	__u8  cdb_len;
> +	__u8  protocol;		/* [i] protocol type (BSG_PROTOCOL_*) */
> +	__u8  subprotocol;	/* [i] subprotocol type (BSG_SUB_PROTOCOL_*) */
> +	__u8  reserved1;
> +	__u32 din_iovec_count;	/* [i] 0 -> flat din transfer else
> +				 * din_xferp points to array of iovec
> +				 */
> +	__u32 din_xfer_len;	/* [i] bytes to be transferred from device */
> +	__u64 din_xferp;	/* [i] data in buffer address or iovec array
> +				 * address
> +				 */
> +	__u32 dout_iovec_count;	/* [i] 0 -> flat dout transfer else
> +				 * dout_xferp points to array of iovec
> +				 */
> +	__u32 dout_xfer_len;	/* [i] bytes to be transferred to device */
> +	__u64 dout_xferp;	/* [i] data out buffer address or iovec array address */
> +	__u32 sense_len;
> +	__u64 sense_addr;
> +	__u32 timeout_ms;
> +	__u32 flags;		/* [i] bit mask (BSG_FLAG_*) - reserved for future use */
> +	__u8  reserved[16];	/* reserved for future extension */

BSG supports much more than only SCSI. The above seems to support SCSI
commands only.

> +} __packed;

Applying __packed to a data structure in its entirety is wrong because
it causes compilers to generate suboptimal code on architectures that do
not support unaligned 16-/32-/64-bit accesses.

Bart.

