Return-Path: <io-uring+bounces-7268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3471AA74D36
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:55:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFA723B8780
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 14:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB621C68BE;
	Fri, 28 Mar 2025 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Jc8IhHCu"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7DC1C4A13
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743173715; cv=none; b=NyrDTXjmOXpKkTQZtnqaeKsINczAXAC0tpkc1/y2xpca/1+rFzJGBJsCOcmo3uYyOwocqRlWn5sinwRon9SyiiBR9TLuTPoy2q+0hPmsNO78H+NEl0ivClo1QL8yvfQyz6a2MYm92DMgPct+C0syeSQYW9I7ze/J8QDonheBB94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743173715; c=relaxed/simple;
	bh=ZV7+T4MzlmrOAvq1rT/65hfUITkuY5mHE/OGSf+cx1A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Wp1hp5QEBYJb7TxMptKMQAaB0GtWz7zkbda3nxETLIbS2QidSiCazdFzcPQIxXl4md4IzTwIRSorn2qcv1OzhFq55KPHICAOGXaRUSP+ETw8pMKLkipjHT0mALt8dCkwhJwTnbVk6uadqPUFFsSU71ryUELETZbcgj+v5LJl8S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Jc8IhHCu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=ZV7+T4MzlmrOAvq1rT/65hfUITkuY5mHE/OGSf+cx1A=; b=Jc8IhHCu9ULcCwPzyFsHjSBu/4
	PoYvGceeVyhI7sML3mFmDQ+k4t+eGR8Z32sQMdBWvW7N5DPTuXYcyyNNtLMNn6fkO5maqEyWyl2/M
	u8kG8sc4NqtUseb9PdLaxsyJ7HdsFhBPCTOqYs/MmMAH0Bi8Sxd7kzu5OWxC1DmoyZOuHxMkKe1Ig
	Nc4KBwYxoCLuCp3GUkE5GCzEkk4Qjg+giAX77LskmbUPM2ctvi7q+8kdPm9cQX0tVtme+VMQQb7qy
	SBfDfd4l1aclbxvLYeMkpx+avPknhAv32NawPO/kVaY/tkMRIrPtSnAGyniafk+DaIKaz9bvB0M+D
	lYGgvElLk2nqWzMQd48tPH1Hbtot9zsv0dlmohy/pPeAj0/v7k/WWdIdhq2oNa+SaskFqVWHoaIRB
	H7vky66LatZ+4J5cXR3NeZ7JwSLgtnNGGPWzUirXUPpz03jO13huZ7rOWsnGomrx63q1gnVS/oRxa
	ZL79M5mRgryRweqnxBfnYMdm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tyAg2-00779C-0q;
	Fri, 28 Mar 2025 14:27:18 +0000
Message-ID: <a41d8ee5-e859-4ec6-b01f-c0ea3d753704@samba.org>
Date: Fri, 28 Mar 2025 15:27:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
Subject: SOCKET_URING_OP_GETSOCKOPT SOL_SOCKET restriction
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jens,

while playing with the kernel QUIC driver [1],
I noticed it does a lot of getsockopt() and setsockopt()
calls to sync the required state into and out of the kernel.

My long term plan is to let the userspace quic handshake logic
work with SOCKET_URING_OP_GETSOCKOPT and SOCKET_URING_OP_SETSOCKOPT.

The used level is SOL_QUIC and that won't work
as io_uring_cmd_getsockopt() has a restriction to
SOL_SOCKET, while there's no restriction in
io_uring_cmd_setsockopt().

What's the reason to have that restriction?
And why is it only for the get path and not
the set path?

metze

[1] https://github.com/lxin/quic

