Return-Path: <io-uring+bounces-13548-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +JX7Kq1NGGomiwgAu9opvQ
	(envelope-from <io-uring+bounces-13548-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 16:14:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE015F37DC
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 16:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98D4831033AC
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 14:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C289262D0B;
	Thu, 28 May 2026 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="S37+HRHL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BD1282F09
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779976999; cv=none; b=MHOHKaFAMXqSREQ5YLkh0Xa8WV0+g/u59h2u76dAJk5BGMgrnyzn15KUSBQ0vNgG23nbvWFeyfN7jUQY8iWhZKqRjxqkT/9FIeVCY4aEsxyBY4zjNlHIxzjraY9cj8y3xAxs9dQ2KxTSWllwsrvTIA/AzblMH6ESnO1Ykm6g0Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779976999; c=relaxed/simple;
	bh=sJisxNe55RkYYSr/s9gRzLHBFiSJqYl8FUZ2JKvOYB0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=u/Cy4c9fTbR2hOmdFson3YMsiFdOnCu+L1GopQjhOdcrfAYoI17EwsA8vtMc6JNSQcj6JrIQuOwoQ96v+Beatf0kOXkm1IehaHe3Aa+AmeD+7ZiZfl3eoREhf4x0ls2XA/1IisayDFRAogZIa3vmoXvMW6agPfO1YzHSweMum28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=S37+HRHL; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-47c35be031dso8618360b6e.3
        for <io-uring@vger.kernel.org>; Thu, 28 May 2026 07:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779976997; x=1780581797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9fibQwo8tBoetcUT0JvZYoDNGUCERf+5RjvOEjW78Y=;
        b=S37+HRHLMfe4I8WRGiAn6bvRj/02zM/WEjXvHLG3MLvQqZHt35bHOI9OzkY+ffZ24W
         az9cuchNyp0PCESZXotrBn61O/s3DeY93UUgXDjSpNOosyk85FgRgxQJflxewImD2Mrk
         1allx2pUtQuH1lZ6Idskh1xwQXCEGOgcg80e85B8tOqU3hssuV6+30i2PLBQCCrBVIAr
         DLxxbmmEE+V6nOEpm4HeBaK//VLcrtAj/9tfNlcLE6BLR0RNUDSLzvnRgc5ZerS37o/n
         SrfwAqfVA3mqCugvkILLifCR1oyPiYWG0A3o9/jg/8wTJXix+yb/ler0UcJgwZAyCfhX
         JNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779976997; x=1780581797;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q9fibQwo8tBoetcUT0JvZYoDNGUCERf+5RjvOEjW78Y=;
        b=WczT2DTSwAt0S76Y33X7e8/q3g+5TkrFnX9Mt3a25vKTprmCD4nR7qKPRGK2D36G3+
         wp7va2O1w3u8vKild3QsEI4VXXrkGF4zAIQPkvpGDoHpN1++rvUJCXW2+/6QY7sd4/YC
         ZIyRvqYb5xsI2bsw84D2dWsHG6k9F8NdXQ9q+a47ttJoCAD0dAZSTeK9rSrRTDdp7FCs
         ttBX1gEM7TdpuVDZTQHJu/zKGcSsvDoofSF93cgDsDVayA9EDkgCCeixios0uQ4D//8e
         U69vG3LMvXIhsduWChq7E4SdHNt63f74bkvh04JGFfq5GprWBC5Wgwg0sEV7QiJEnRAK
         IztA==
X-Gm-Message-State: AOJu0Yz1WnBDJNKNJaXm+ArZpzrAL8FZWqi/D+g66YE4RzAFKtmlbfsn
	wbOX1mbK/MGN+ow2AGA/Bq+3LUmZZAbUARSWTHaGu2YwJ3FI8dup46BXjduIdKzQd6k=
X-Gm-Gg: Acq92OFwkOw4aqxCFkwNBkMlPCmrVzYWP+4WN6FogrPJrVRtUdOLdwidpfYoLe6UQIr
	SgW3dLGqBQYzc5JFcNX5Rw1YgL3c2aF7W0A4BMd0LlgUlB5ALShNcmCUi3uom/MrJPXi+jEOY32
	xhESCHFVQpE5gLomnnGFj46Q8nrZIZds6CxlBRaqxjH19q6TvJYIzqMAWxExQ4jKV4Khth2DOve
	KROcS8lVTmX1JUMTrw5e88bcApQbg1nv1Alw2KXkoZoEupTN6/+9p028/zYWGU0xAXr0WQncGTu
	SEghCC5Lm5I8lLYYd6jGZfEJeM8VTRUbyq9+EV8Lmn7Q7pJuE4DCNm8jm0EFspcpGwFw1n4XSVU
	T14vuSEpr2diVmrYR7iVL7+HGE0GNlx+TdEnhDZOrLI73jcFXFdLldkrfctJvBCl8f8HkCtKvAb
	BNToj/RwYRylvlyu03Mq347uPuP+3qRkixPhPlMWZt2QRsz7MDTkxLsxHYNot7bDNA5ptB7WHHO
	PHH00HFZ4jDXg==
X-Received: by 2002:a05:6808:2202:b0:485:403d:9b8d with SMTP id 5614622812f47-48549e950a8mr17977592b6e.11.1779976996514;
        Thu, 28 May 2026 07:03:16 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-485546ed055sm9116166b6e.12.2026.05.28.07.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 07:03:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: dayou5941@163.com
Cc: io-uring@vger.kernel.org, liyouhong@kylinos.cn
In-Reply-To: <20260528024936.3672659-1-dayou5941@163.com>
References: <20260528024936.3672659-1-dayou5941@163.com>
Subject: Re: [PATCH] io_uring/kbuf: align legacy buffer add limit with
 MAX_BIDS_PER_BGID
Message-Id: <177997699463.94267.12840010669165233758.b4-ty@b4>
Date: Thu, 28 May 2026 08:03:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13548-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[163.com];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: CBE015F37DC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Thu, 28 May 2026 10:49:36 +0800, dayou5941@163.com wrote:
> io_provide_buffers_prep() accepts nbufs up to MAX_BIDS_PER_BGID, but
> io_add_buffers() stops when bl->nbufs reaches USHRT_MAX. This makes the
> effective add limit one lower than the validated limit.
> 
> Use MAX_BIDS_PER_BGID in the add-side boundary check so validation and
> execution use the same limit, and update the comment to refer to the
> actual limit constant.
> 
> [...]

Applied, thanks!

[1/1] io_uring/kbuf: align legacy buffer add limit with MAX_BIDS_PER_BGID
      commit: ca55f98d6ff1ecb31a07b668a8d105b4e0829c6a

Best regards,
-- 
Jens Axboe




