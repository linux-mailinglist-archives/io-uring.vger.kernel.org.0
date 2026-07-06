Return-Path: <io-uring+bounces-13906-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id sdGnOXUaTGqdgQEAu9opvQ
	(envelope-from <io-uring+bounces-13906-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 23:13:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D261715A76
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 23:13:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HTpZkhot;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13906-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13906-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E86A03006117
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 21:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9E14218AE;
	Mon,  6 Jul 2026 21:13:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731873EC2E6
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 21:13:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783372400; cv=none; b=sCnEN97R8GQfjF/Ljg10KB8/D1gAXURiKbstMD8sCd6/rr+dvjk4y38r0KemhukQMfFw/k0uUMhm3vKoJ1qJ2NmzZwbPUhwtt3SoUKdw1C0iVJezDWCLiW+PG29JA1Yc6SOUwTiEweSsjWgDjlH/Bv2qpWy4w7WcdDTbxth+w2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783372400; c=relaxed/simple;
	bh=GXzkFCCUcL5t0sV4l8lrOi5+VtuW4gZXj+QxWpaOwHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEUgVeXQp+EROWp77QoPcLlwtaLMAWGVsMD8fc3DwgWmR9caj5e1rG16m8drh4M8l1d/Cs//34v88lZvWMw6zStr5A3lD/qg6gETBmrQGa8OYh70DOW93adSK537SAFptX0/S/JAz+ByxZrULm0O3DqqBS9poEoSlAUfBoAdlrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTpZkhot; arc=none smtp.client-ip=209.85.214.169
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c9b1edf2bdso42234905ad.1
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 14:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783372397; x=1783977197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kVSfZ5evDD5Y2kVc9gNZNIpOs7YhusitaQJ3yaMQOE4=;
        b=HTpZkhotSuzRaTawzhzXd/BEvKgahR2E2uhKeI8+RWwWaM/nS/pMGSQSWZXBh/+3IA
         HWeKqJdd4MlL4EJnNO/MDZzkJ9xUlOJWnpj4skYGEVexBVnYrLttGI9GANvtHeeTcliK
         JJVbc4EoHG4E+Svo2C4Dpzm5qHEWhNgW8+Artc9IBx+tO4Gt/rqX2dYdwCZ1/2z8/2IB
         zmoDVmNqA6e4vmdjLBjxaq9kP/9uCkL8tT4WLP4s82W0kFCfddks3iYO8vxaEchXGgpK
         nJ9oDW69LqrdaG6SOidGNq3H/9XD4X7sEKmEUSFL5laAACR27b5sANJE0mDzxJbvaFk4
         OqFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783372397; x=1783977197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kVSfZ5evDD5Y2kVc9gNZNIpOs7YhusitaQJ3yaMQOE4=;
        b=N/Pnin9myGPjU1X9e0mRNY9ujOoAn3djd9MMCnTUtWQ/AqLyWHAuj/UZn1CF4Bqxwg
         L6Ecf8eL8HSa78nsSQayEnnxBQ8K+eDMrNm4+NcQpIv7nRvv006iR6tHvuibZqLmbVta
         8CFjs9ZF7MMRGYELaB5wobna4rwRIKcB1+Ym9F6Y+Wt/9XGqKqandHNG/Ypm8nYF30Ll
         7DsAUg173vK1banOdQwWjhBMhGcswywKoh9hV+fZE2KcjSTytjGTUu6v4YZysjZAHbnS
         SX7pZTIuQwMsWbPWC0xejdfSgmF0qH3a/BYrXboLfdTNU7Xcz0CUPzaB6Nr1G4/1TrKE
         miLQ==
X-Gm-Message-State: AOJu0YwCIeqbdB/wXMzh4DzQufaiQQB7WPfRpV7kJzrgiX73feIHoRKv
	FxcaolJunMztPEwLryUD8tokjlT5Kg60IRyIFCIaByjrCTv7zcOlY5r7
X-Gm-Gg: AfdE7ckjDWQCKil0aLRJ458KL4KY+10bMp2lxkpzmEWzMz1ZueX6+QHFks5I93amRur
	/Ow7q1hV0ebk8OTs5pI6alMY2FdIz92dvH9YtEEuycorI3c9yjNmQ61mdtR73e0kIj1ICm7cSP6
	assvqonAQezqhzwNWpCv+U7JmcgXh7QzfngPDXK8+t84Kv5QwmsWwqAtM+/DAVtPKeIvwCrQU3w
	8JAQaacwpHsZfQLgi5fu2Mua7aNyTJx3GNOfzCUIKDQGzvb3aLNKB7q8Ddw9FmNC2BOMoqdGwZk
	CZ/YLFGYBRbdeUwpD7dKpStrpKbNF5K2b/zVSAWf8QjxNZXFkSE4aDm9xQuueiNYUJ6U5gezw+i
	6UEFgAmCC08pi3rXIe9M9YljkIzRsrtuaUY5XxXCVLjwQ5opvFfgL+rYU3z9hPNBQmd7o3OnTs7
	Yi8DFoItWpNSX7gVvAfMgqgwolYhWxfmCxY0XoT0F+Pc7sLDxnsgo/YstAqRuTA8D97QZ4aLuZS
	IDp/t7g8KH+Nsc1W6eQ
X-Received: by 2002:a17:902:d2c8:b0:2cc:90aa:878b with SMTP id d9443c01a7336-2ccbe728946mr24439165ad.10.1783372396971;
        Mon, 06 Jul 2026 14:13:16 -0700 (PDT)
Received: from prateek-Aspire-A515-57G.. ([182.77.77.237])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659d87a2sm354792c88.13.2026.07.06.14.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 14:13:15 -0700 (PDT)
From: Prateek <kprateek283@gmail.com>
To: gabriel@krisman.be
Cc: io-uring@vger.kernel.org,
	kprateek283@gmail.com
Subject: Re: [PATCH] setup: dynamically detect default huge page size
Date: Tue,  7 Jul 2026 02:43:11 +0530
Message-ID: <20260706211311.342789-1-kprateek283@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <87qzlyy0zd.fsf@mailhost.krisman.be>
References: <87qzlyy0zd.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-13906-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:gabriel@krisman.be,m:io-uring@vger.kernel.org,m:kprateek283@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kprateek283@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7D261715A76

Hi Gabriel,

Just wanted to give a quick ping on this!

I sent out a v2 patch a couple of weeks ago that implements both of your suggestions (explicit hps=0 initialization and using the ternary operator to remove `ret`), as well as the `__uring_memcmp` shim. 

Here is the link to the v2 thread on the archive just in case it got buried in your inbox:
https://lore.kernel.org/io-uring/20260623154305.1115403-1-kprateek283@gmail.com/

Let me know if there's anything else needed!

Thanks,
Prateek

