Return-Path: <io-uring+bounces-13347-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ILQqC4QdB2omsAIAu9opvQ
	(envelope-from <io-uring+bounces-13347-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:20:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 755465505B7
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 415AA3040F88
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 13:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC25315D35;
	Fri, 15 May 2026 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Y9sy2Qum"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19823C503
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778850807; cv=none; b=Ef3zBLwd48bje5xc3YfVWVaw35FLPe2fhaWQ1XZF8bWeFdvqlyO5YYAJFfap7OFVOROZxsI2dSRfipBsBHxZ/xweu7BD9ez0Jc8FasxfwnwDmYFj5KNlxRwZP98qbOAeygCrvbgGD+pNTSehoWsMBemhi7BI9eZY/JRsKC6IwFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778850807; c=relaxed/simple;
	bh=R97JAjqkjYyUCimOc7AzOKbvorjCMozMJ2Z7CLJoGVA=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kscNq5hlMEaAtnemKu64uQAB8fvZUKRFoZUssSxBdE6imBzXGgCF/aTv5+j8v+Td3wVILuHFA12FmvOLLyumxAP2cRLYIZurgqrEhqEDo/V8baWBPFbbbd+NhU+UUqiW/9+rjtzA01uMwu12dA8FuRNWgW3VdWDcorGTQsbSDH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Y9sy2Qum; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dca00c1591so3161654a34.3
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 06:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778850804; x=1779455604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f6HOVzo7CrIbxdeDdZg1LpazRzcN6hNALUPZjs4cErI=;
        b=Y9sy2QumgQiHsSaZy4Po9xIGrDbuLV6LnZBVBEndpcT30pwYJFTnygyAOy7mvKOtKN
         /t2Hla/At9Qa3X56/mBqAlQ1UW0N7uTnNwoYnczCAAbeol7VZV9sSg+4f3USK4UDLoYm
         4BLiUU2JkCrsnUaDVQxcp6d7ytSKoavy0+u17xZjKvAmtZH2PWDqCQgC6UcKcXkZzTZ+
         CvzHx9u+j58Qz1oJsLcKzSHJKZyfJqE2zgp/EnhRK7hSH8u/u7rkpc7kv7g9A1P0MFtq
         W5ritIKxEgXcUbx4Pbb4ieVmls1GGZ+qZ2P0VjgqAPepkF1pdvUoXNXRA8zxAAD/sq0O
         RjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778850804; x=1779455604;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f6HOVzo7CrIbxdeDdZg1LpazRzcN6hNALUPZjs4cErI=;
        b=H9lsm1XxVdMe3ybLXmTST5E5KZ+ZKFy8N3etyNw4+ANta84zgj2ZsXe1GV0tOcclvQ
         D9dkyMpqh2aT+oeSxyMFMCUabylK4HrdiqFUIw+zAKKxsA4vojXHnUa0bSrEv++P/zA5
         oIek5ATQ8/CdrRW1S3QB86IUw0t4lUO4YtwCiFXCY4lEX/OpCv/EjDQDFRyQGgeyaeiV
         gnssB/CgEDrC7gddxlGZ6qz6GJviDHSFsAOsfV2DeRtddZhHGCgPgHTv/Px9cSc7WoRO
         anGPbNhbJxXY7Jf81Mm1vxhLWdwvUTplHM7SXtKU85XULy/Dgt3oC0EX7SqG/Az4ZAwl
         cccQ==
X-Gm-Message-State: AOJu0YzAxukesbWeaTob+eq+bIr4xGwpWSHhtCPnhUg+PC+7C6SJXDmr
	DTHpd7eBWufOI1vI8rX6LcN+xS9ZdKOOcaGh2xzh7AVFxU7Zuc0aSOecvWnd7t/2WSo=
X-Gm-Gg: Acq92OGSLptom+cIpT8m8JM0zyTaBI53Hk6MhxloZGeNCt97C4cGpq/D/VreMIW4tMW
	vnciHIhO82auJlh1Sfv9auxICoUcanbo3epJ+UhZ7v+JX/KjYPH8D9evwBX/lXKWFJn14o+Fl0/
	tOqOFu5YU2d+Pi3tyRXm4rtOiX1Usbq+5dBEq9GfoFYtVfBVKGKf8RG4MKHQpelX+gO9w5Up4yM
	x7tC2pFXJAQXARZLwLctn6X87cju8UOdVPKo9WtmBoyyPs5mGOjY9+x/VvdX/cmv4qPlzTV94lf
	h7npjn2mb4/KeKrEI9krrKJ39KcjA0xuQFOO+WoTDvP5N/aDOWiXEX5F+yVQs/wicHd1KIEyLCW
	hhqTXusBbsxJsD09T6zVvBDQk+t3OBsmt21lXEUvoVI8PsnpZTP6U8hcwUHa7h7EzFWNKstCS55
	9F6mCzzwh8mreO073bBSS1fLgLo7OY6gpp87GxqYlfO+y4kyFOIN6y44FUnF43NRMLNb4ZfHuy2
	cCW
X-Received: by 2002:a05:6820:1c8c:b0:696:8098:b0df with SMTP id 006d021491bc7-69c9c0242eemr2244606eaf.48.1778850804074;
        Fri, 15 May 2026 06:13:24 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc4dcb89sm4160706fac.12.2026.05.15.06.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 06:13:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <df5e866a3c0582ae42538841dc54fffc45004aa9.1778775960.git.asml.silence@gmail.com>
References: <df5e866a3c0582ae42538841dc54fffc45004aa9.1778775960.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: improve zcrx export tests
Message-Id: <177885080329.720964.13520778291892437858.b4-ty@b4>
Date: Fri, 15 May 2026 07:13:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 755465505B7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13347-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action


On Thu, 14 May 2026 17:26:26 +0100, Pavel Begunkov wrote:
> Use the right zcrx id in test_zcrx_invalid_clone(). And fetch the fd
> after exporting, it's currently just 0 and is not checked.

Applied, thanks!

[1/1] tests: improve zcrx export tests
      commit: 52a1c4c105b0b8b61c6ffaf13e73b035f190a06b

Best regards,
-- 
Jens Axboe




