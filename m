Return-Path: <io-uring+bounces-12130-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id zflQAvCEimnoLQAAu9opvQ
	(envelope-from <io-uring+bounces-12130-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 02:08:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B334115E9C
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 02:07:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3B28F30156E9
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:07:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E9318DB37;
	Tue, 10 Feb 2026 01:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oK+apLWE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A2817BEBF
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 01:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770685674; cv=none; b=Cq3BZ9HjO4TFYWakkb16U8RIUHUlnQ83JXraCiOPaNXdCvKPa5ChVxSuvnNp+3oZ8+ZOZVKNXF8/2HJraomhy6kdBPd0s7yCUc39Hqw3Je8w7bXj+/Z9bhBnzexgsXe4Ac1A/ezHV6sBPBYMm106FL8OMNqFtKZX2b7OsTzjE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770685674; c=relaxed/simple;
	bh=Q82feaw5Lvy1nScEem+Br+06qAIb3GmjcMt+QXQhfrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVOVjT953BfZ0fBuQ5xnYPXx+mZu1xBx3C8Q0vrSEvcYDs8Wd7L7/H8lwhswdSEgG5RXqsXWzaYe6tLBmu/5S4REQDMS3E92I+64dQpcGrSt9D89T/okVRhCHneihua9q3uKDlG0NvrPkQdfRBnadllFgCVDFVJarbSFp3e8cQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oK+apLWE; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40418578e28so1744097fac.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 17:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770685672; x=1771290472; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W2DZ1Z1DP1+GkcsmVaklojZNG+HNOV3feezrJFvnwzw=;
        b=oK+apLWESq+eqfc0lYgGTHz6rVGB0EgS5S8wbj2+jc2n+8LxQOxR95EzLv8MvpnAPA
         rrrMO/O5V91Cq2jlMqUxf+XhgE1UwgQ9l1WBRvgYrjE39+NNyRx8XygJs69eK/vMVyIu
         ftEhIhfYC82ieMNnrGJx0da2AfAExPvPs4bVGigoTRwdfqdyenVf14JyqaQ9Zx4E5VFh
         /PCsc2NvjECoZbzKs7kYRg1EkpQqebDXl2iyNgaM/AHHkD1ybxAztMLhn3JEBLdVJIO8
         ibjnu29LFEbTgJ5un6/H0eMSHSWK76os+IXDIL+kVh49V8xeZ5ORvFyjHZItPqxBjqq9
         ZkqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770685672; x=1771290472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W2DZ1Z1DP1+GkcsmVaklojZNG+HNOV3feezrJFvnwzw=;
        b=IW6ynLpsIAXMvFAC5hHunSoLIZ4XADc5UunEd7CEZVputQ3jewi0ahOCTIOgq0QyOq
         VRLSAXBXnbHmNqiGI9rt7/taGXxq0ZWNFu+JTJ0LumFnPzm55mRb06p6DAetuVjN+x4V
         93Kg0XDfTFi/goU+6Pf65Hzwxgs4FFkIxUchPtMtpxlr9gBaMK0xZDpy3yVbllbhWDcv
         wu7tvVqKhJpUOot0bl5yPStx2y/i6f+YS7fT4AmzhHYonf1cNw8UlU1aNv9p6ovnMQdW
         HcHSDaQERKozeiVS1Ql+NXKcvFhJeEAzSdn1aBB8PbDYNnalg8ePGZ+lkai1lj/xcZMO
         2akw==
X-Forwarded-Encrypted: i=1; AJvYcCWv8WlwYRxCyXpbEWeNjEJi8zaNh34AxQHDmHuT9jvp2X3Wy/SN6hWNwt3mylcachhSfOX5mMBrtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJQWMBSIUrGfsdbsD81BPjFPw5035Vu19C8zIoEgYH+8Yo+P4C
	NXCyCafnqf2AvKFh9zVx+zTcauzuqPX4BeYb01lroL9IClwVh2r1Q8Pbc1zn0pT4P3YzZpDfGMk
	mX84tSMY=
X-Gm-Gg: AZuq6aLT/9X1mCaXPCULD4RiAVLHilDDO7sLyrsMUci8I5+qntY2EJmUk+uw+v08t9F
	9JFjuUiOUcenYtSMIJm7QUV+Bkx7kWC5BZxeN0Ggj7KMrK9AeFtJKAHxTt9J9jaB15XRDBhUviJ
	A6RL1ZY2fBuiGe/RlAprmFKJ0uQ9sBn5WGDjUyXWEF0Q3TJp6BRAIN8ianGuMKt0Kb8GBLxGkXe
	g0ntHHJ1wo1jqln5SHF0VSQwV+9t7Wvt4ylUu5H55b/f/UYAi8nVXpOEZbxlsZ0zDAeWvZ/E0a5
	lGMbQW6SqWj32oRIXNL+v3YcB6G0jAZxtBtRWzbgdR1X9ZDNcMre2Bst9cQNgRV2Tjt5En7CxcS
	FmE/jwaDDtFqqgBWVAWu/a6etpyOPcVUThPWEFysx4PuWFipUzFPkBq0fwvAoS5/qHFbqH2iIu4
	pHuXIRBLWF82CY1jFypqc6gHaHY0Trk6d7y1FmFVmM/8euBt/CVxA/NlOj/IMLxZOJo0lkTBHK7
	7bhSAJ7zdPaNuOWFbP7
X-Received: by 2002:a05:6820:2901:b0:663:2b0b:42c5 with SMTP id 006d021491bc7-66d0d2faa8emr6105020eaf.80.1770685671808;
        Mon, 09 Feb 2026 17:07:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40a99352bb9sm9173990fac.7.2026.02.09.17.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 17:07:50 -0800 (PST)
Message-ID: <8826110e-cb5c-4923-99cd-b9f21f536d32@kernel.dk>
Date: Mon, 9 Feb 2026 18:07:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/11] io_uring/kbuf: add buffer ring pinning/unpinning
To: Joanne Koong <joannelkoong@gmail.com>, io-uring@vger.kernel.org
Cc: csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com,
 hch@infradead.org, asml.silence@gmail.com, linux-fsdevel@vger.kernel.org
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-7-joannelkoong@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260210002852.1394504-7-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12130-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 6B334115E9C
X-Rspamd-Action: no action

On 2/9/26 5:28 PM, Joanne Koong wrote:
> +int io_uring_buf_ring_pin(struct io_uring_cmd *cmd, unsigned buf_group,
> +			  unsigned issue_flags, struct io_buffer_list **bl)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct io_buffer_list *buffer_list;
> +	int ret = -EINVAL;

Probably use the usual struct io_buffer_list *bl here and either use an
ERR_PTR return, or rename the passed on **bl to **blret or something.

> +int io_uring_buf_ring_unpin(struct io_uring_cmd *cmd, unsigned buf_group,
> +		       unsigned issue_flags)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct io_buffer_list *bl;
> +	int ret = -EINVAL;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +
> +	bl = io_buffer_get_list(ctx, buf_group);
> +	if (bl && (bl->flags & IOBL_BUF_RING) && (bl->flags & IOBL_PINNED)) {

Usually done as:

	if ((bl->flags & (IOBL_BUF_RING|IOBL_PINNED)) == (IOBL_BUF_RING|IOBL_PINNED))

and maybe then just have an earlier

	if (!bl)
		goto err;

> +		bl->flags &= ~IOBL_PINNED;
> +		ret = 0;
> +	}
err:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	return ret;
> +}

to avoid making it way too long. For io_uring, it's fine to exceed 80
chars where it makes sense.

-- 
Jens Axboe

