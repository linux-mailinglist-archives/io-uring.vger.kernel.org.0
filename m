Return-Path: <io-uring+bounces-13911-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vp+UJ2VNTGpXiwEAu9opvQ
	(envelope-from <io-uring+bounces-13911-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 02:50:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD073716825
	for <lists+io-uring@lfdr.de>; Tue, 07 Jul 2026 02:50:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=HR7XnoZH;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13911-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13911-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3EB64303281D
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2026 00:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4437D2EA480;
	Tue,  7 Jul 2026 00:50:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066C52DF132
	for <io-uring@vger.kernel.org>; Tue,  7 Jul 2026 00:50:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783385441; cv=none; b=nL6LAil5GZVokF8lo3IDwlHaJQ6Wl9wbcA7hRm5mnBmrhdpEg1w7DEW4bTQP81f8LxdJuInOGTGqXDl7soUw1SIpdvp4UEZ+xc7cqflK/YkCFJPSe2oyA6O/HSjLyiYDD40d/KoPpfdBqugX03nxpBlkoaTNxuWqtVXOPcnppno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783385441; c=relaxed/simple;
	bh=KupspBwCnnxmGzRk49bA79dgnod9Fa8LJcvpwuLa1sY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nviPaJ3Q8E+1F0A7VZw9FakfG+HbIohx3Zjb7sH1n95m/9kiQVz6n7Ppi67CkDfwhglYYES/3lzQkZLwyCmdfhjFwjZtr1B/eW0oUH6a0yQJSXRSWEWvgMYOwJF3AS6mzKS+piH1EvcoY5PCIvs84IrVSovQ9QuDgkiAzMIZETA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=HR7XnoZH; arc=none smtp.client-ip=209.85.210.54
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7eb3865ea6fso2774999a34.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 17:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783385438; x=1783990238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cE6B+9FWJbF1v7hk2kj2D3MN0QWL7/VSieXC2lBK6nY=;
        b=HR7XnoZHWJUhnIzN4eTkrb216yUshdpEs3wDJnwzwFfAmy4YKVROif57rbDJiB24rt
         3hMJBM0xkW7Bs2WNBvTHcmh5v/ANOrcO/ErTqROtlOnAbSctWEjpKoz4S/rvpKy9PUFN
         Pongh9nKN6c9tB3M5BsYC6kjragf2mwKAg5xsexedRIDTn2KC79ORzLHiPDIE+VAwuxV
         DgEXgSWADpW8otVPgLum0YRl7jeH2Vk5TgppQGNyhzOaqbqv0qdUnF1/rR2yTjxaF2mb
         +67uQYOcTqYPM9Yr3hUcWoxa0f10ZdCpc30Uln2NyLeWohx0IwiJ6jYVLuIUrM1q23wF
         UE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783385438; x=1783990238;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cE6B+9FWJbF1v7hk2kj2D3MN0QWL7/VSieXC2lBK6nY=;
        b=G3QCibNgOYVTkWaDXdB8emOCvHsjP/lU8D0cixdEEQJ9j0HJUgo/Klr0u7ylP9EXi7
         W979SWgql1zddINAVfYKKrLEjbX1X+oXa7SMaOdD8WB4cmNWy1V0jKQwScUMGivhwVt7
         W42CqszbY7mnV/2/aRfkGxF6tKTBgczWVMdZJ8WzZoN4CkV+gBrWoKk6ZDbv4EIb82os
         HEmg6xflJTYjAy7K73/F8sOfugk7CQutXC8M4mgvxQKZDiyEl5WKOd5fzEx5+XZxlsuZ
         Gffs/88EJt+5U43G7H6+bCWhSG+HeOJSiTwjIsmXG4WYeZfrs2fdsGcawIvpXvE/HVkz
         di0Q==
X-Gm-Message-State: AOJu0YyA94pKUby608Hc8F05ZTci8zNyczGWhcq+fHZmovn1N9y2sEsP
	LwxD6KYZYYcC6Xn+eT5gLcqQTOEQ8BH0yoYVXwaY8Zt/W93Cp61Zsco4FP52u4kn26c=
X-Gm-Gg: AfdE7cnXLBHUbkTFWiN8gFcx6OLs9umnp4igqTOFOqsTynUX0A15k+D/6Z9YnqPV7bh
	6VVAQwekPf67xbbGS6fEl8fijKWVJkKSvpg+3Ymgg1ewY808tzSFNahEBIVeUCRCAOQX9nK9E1v
	fx1aL1Yq/hYuNN5st07BGAomSkJIQqVpjIcfmqQz/OajM3gf5WSiQh2UY5RzonDmlNnR4D2l45w
	8d5RsSZJG/9DP9N7lPT7U7gs8jhsxKnm2Yt81jQ4vFy7ENjefsCAnvrdX3Kfo2Frh/9hpKH+vxE
	s122dVnRzCwSBHWR/BWAT3gY0ahXr2ALhZtgx73PY6Z0pidTf3AKyEvz9QcElXr3GJxv3jnqQ7V
	U+T2r3w9oTHEmo70pEG6/y1Li70124lsGvnuJdgRZ3r2IPuLNPAa7qaKyIpXCRxsQyz+pal4B8I
	i7UGvh7MXHqdx8LR8Fcq17BaIEs5etsipbQH9pF7dexY0/MhFHErGFeIskNd3vdncWtw==
X-Received: by 2002:a05:6830:211b:b0:7d7:c985:3a30 with SMTP id 46e09a7af769-7ebb22cf6a8mr2193949a34.11.1783385437990;
        Mon, 06 Jul 2026 17:50:37 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7eb54534789sm12661353a34.26.2026.07.06.17.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 17:50:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org, Hao-Yu Yang <naup96721@gmail.com>
Cc: io-uring@vger.kernel.org
In-Reply-To: <20260706183304.919275-1-naup96721@gmail.com>
References: <20260706183304.919275-1-naup96721@gmail.com>
Subject: Re: [PATCH v2] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
Message-Id: <178338543579.49877.9882374687710864124.b4-ty@b4>
Date: Mon, 06 Jul 2026 18:50:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:linux-kernel@vger.kernel.org,m:naup96721@gmail.com,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13911-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DD073716825


On Tue, 07 Jul 2026 02:33:04 +0800, Hao-Yu Yang wrote:
> When growing a provided-buffer bundle, the old cached iovec is freed
> before the new buffers have all been validated. If validation fails, the
> request still points at the freed iovec, which can be freed again during
> completion cleanup.
> 
> BUG: KASAN: double-free in io_vec_free+0x2c/0x90
> Freed by task 73:
>  kfree+0x104/0x3b0
>  io_vec_free+0x2c/0x90
>  __io_submit_flush_completions+0xc03/0x1e40
>  io_submit_sqes+0xdb5/0x2310
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix dangling iovec after provided-buffer bundle grow failure
      commit: cd053d788c3f13b3eaf16672d427ee828fda16ed

Best regards,
-- 
Jens Axboe




