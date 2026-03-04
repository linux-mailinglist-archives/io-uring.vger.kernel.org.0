Return-Path: <io-uring+bounces-12553-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +CwvBnc0qGm+pQAAu9opvQ
	(envelope-from <io-uring+bounces-12553-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 14:32:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 72C8D20076A
	for <lists+io-uring@lfdr.de>; Wed, 04 Mar 2026 14:32:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 01A7B301024D
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2026 13:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EBA389106;
	Wed,  4 Mar 2026 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zAXLFEUQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470A0372674
	for <io-uring@vger.kernel.org>; Wed,  4 Mar 2026 13:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631058; cv=none; b=bpMHjYV/Ci+7jv+LlCtQlps30NjCHqINKNbLGYTbWaU9fTkAojqUJ8bArGIDN3wo2V92UmmvBkSePcPyNe4n1pjFE9ttbqdHxGKKJE691OUiedZzQj2+zfCH59TcXa9S0BfqhaAeaVu/U1pd8f5pQnWp3A6ePohUcbj+FhEW9v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631058; c=relaxed/simple;
	bh=Mati51LWmyzTXi5oh+i3bfi2MmfG4RbhWeULF7IXsmM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JlwInrZ12B4/vyUDHLk2g4GkER0vSM2tg3UIyrI3CQz+mM3iv25MBsvADWEYR2ACzViL6/ZIir2nWUa1/8PY+zhm0Ye4ZFTf7zdGIbzeNG1L7u+gasCFMerUye7pgCthEE5ykd1Fu7FfMo25+TbBD5MKyiCXc29LT+8gEBpcHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zAXLFEUQ; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40f387a688dso1501888fac.0
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2026 05:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772631055; x=1773235855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DAg35Q1NUQUcIj+RoSLSwNOktvkzuGN/8zIJVI3g440=;
        b=zAXLFEUQPYDBqL3E8QG9Hx30rqVlRXyU7gxJ67TyENDr3t2H/eCWvxSs8GfMKAotan
         dRUawX5X5JjR1TQdTzc62qSg0Fye1KF98yk+BWz6QwD2wj6RCV5EFrLU5R7j6KzZKc5w
         eDf2SAC7F/+YyjOXnqF98mxYfmWZMnCvuqcAvTRIRJdnv08AQ0jEEFICTxY9idP4iEIK
         +gxAA5fIB8qfTFbmqmX6eyVuZW3TGFaOtP98c5NSkMt0QB1UwWOFi7xPVECzS5UBPTJi
         h6Libu6evq4p6wWpR4DEgipa/6Gsjgf5Gucc8+JFprLoaWiEVnBX57TQkuRQLsbXkz9O
         VDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772631055; x=1773235855;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DAg35Q1NUQUcIj+RoSLSwNOktvkzuGN/8zIJVI3g440=;
        b=QmKbL0y6HgJqRHLiv5u9t2fR5+MxjA0DG6szeAzKkwkKr/aJv/eokXEwiUNB71LAAG
         MhwUkkENCFxEVYkK06W2r0D9vy6qVuwEFEeWfAxgAgbL9bEYhx3I7yE2rDMosdXlCmcf
         5qUo1drzFbwsNp5URv87CWH489meYp6eROODYbqqjWnNpXlVm7YRcfT1CboDf9/rc/JD
         /9dRZp8Wql098s+lb5/Xr0yhXkwl7Yx9/sJ2BSJwpH1ghiaiOurvmfCn81IQKSrMWl0U
         rQuaqXrO+TY2O2tiSXPGX5hw+98uwQBZJohPMUQRWHK2Uy7JkKjm1vMTiCvoC1Gy+xiQ
         +Hhg==
X-Gm-Message-State: AOJu0YxCo9/J12ujIY6hqIPIsxA6JWF7XbXAsdO5/L5uDDAuudIijR+/
	FzL3tAP+QL7EpVZdxoHac0MgpI29C18QN+rwkmoFac3FHWTM2B7h/52RsLRnMNUx1vMzRq6/oIQ
	y7LxZvKg=
X-Gm-Gg: ATEYQzyfPHAQe4lAecDOqxE1OcRa8vFsl5MlgqUf0bcSlQIr5fkZOzKSikSeUzyK4hi
	3xzPNsMn7KwunTNt/9oKEoTZ8peC/b+jfY10GZzrUunfGKfXDGqR+4H6lwnHCyNExv2oy7UxCQ1
	EE9uf3YUCnd46lQvWvLC12GihRn1wLiPjNtqfL//qpZ23fYCK9elPqcEmetF1/35EVyZopLsHB/
	VbsAhtdSyTcM+Tv5Dz8XNU5AiLKX5sE7OuaZ7fBs0hp+HtTKF/GWr0HiCC38TxDID6p+nI/zZ1K
	1Pa34v8NBnCP8QUipLQKSiwdeAGG3b3qjRGALx6uK2jbe0cZ9r8DHnKYWaZuSnpGfYAlj4PTCSp
	FFGYZz08MdrB1dLfn6WqTo6XMsGVMwVaVZw8Zxh7e/1Bc8yW1pUiCYrY9SvIvv8QZxCHM6mn07O
	aO/CpeTpQo80UvKxXQ7iXHI0Ty72WdIpVZCCnvyaooMngx5dEn0TbJJ48uEDwgAZJPMQIBDLSkt
	/Yy
X-Received: by 2002:a05:6870:c0c:b0:409:8bfb:c7c4 with SMTP id 586e51a60fabf-416aba7fe82mr1311080fac.31.1772631054797;
        Wed, 04 Mar 2026 05:30:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf239e0sm18505462fac.1.2026.03.04.05.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 05:30:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <e93675f7a196a178d2f389c69ad96079cf98e1bb.1772627580.git.asml.silence@gmail.com>
References: <e93675f7a196a178d2f389c69ad96079cf98e1bb.1772627580.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: use READ_ONCE with user shared RQEs
Message-Id: <177263105363.30929.8824112170084503703.b4-ty@kernel.dk>
Date: Wed, 04 Mar 2026 06:30:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 72C8D20076A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12553-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action


On Wed, 04 Mar 2026 12:37:43 +0000, Pavel Begunkov wrote:
> Refill queue entries are shared with the user space, use READ_ONCE when
> reading them.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: use READ_ONCE with user shared RQEs
      commit: 531bb98a030cc1073bd7ed9a502c0a3a781e92ee

Best regards,
-- 
Jens Axboe




