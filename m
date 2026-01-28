Return-Path: <io-uring+bounces-11963-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id u8dQNh+LeWlAxgEAu9opvQ
	(envelope-from <io-uring+bounces-11963-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 05:05:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 18AC19CEAE
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 05:05:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B654C300A11D
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 04:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087131A3029;
	Wed, 28 Jan 2026 04:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cDZXEYpl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D12E40E
	for <io-uring@vger.kernel.org>; Wed, 28 Jan 2026 04:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769573147; cv=none; b=dPCMHopXkcResk4yZLy7suAH/+09Np8jMbC23d6Q/pNtz0jj+68M2QSEIiaMl7Y0qb3ePlu3CM5Qk8RYFW5TBzI5SVGfRoe0mmRFSxTapLt7briwk+IMmsA8mqkFujmASxoiJVsroIBHsT8Fr7dk91eaeAaxvZYqbUUfnkTyb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769573147; c=relaxed/simple;
	bh=+NzVrgtBkcMCEFDosKmCkr4nXIQLcwByaoClJJ++CDE=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=mB5IiTIbkqu/OP/yX9TbQ5MEjW0DS0RyF+upScnmwLayvZrTmh/F0jAOjPJu5LhR7B+BsfhAF31eYlknjI93Y+ayvVT81sZbMVRp/Z5EiNPNM2AOIs4gXaViKycVakVqOMysIo7c359kcsUk5hXj0rhVYJJR1o0mMwvQQFLOtzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cDZXEYpl; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c70ce93afaso136527685a.0
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 20:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769573143; x=1770177943; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lKMdv5rDCYHQnxp34TSCP7j0iLGorYQYfa4PN5QYwTo=;
        b=cDZXEYpl2QDlbR58D76w2ZJ+Qis6whhLqBWwd0AzQBpQuU/VY1GtV9bKDQjQ7ZTVGt
         0mMO0kaJyr6Pj8Xn6rVoYXXq4m109CqnA8woZXhF2ia5bPMNofKDHVBOxFohWI84LVuB
         dlvhT2CMRWV9dCIYlcz3Qhrl57VrBzYd3IAnzIdPIzG0c46QBeLMtfJHhNkOL3glDtUJ
         nkPlVVTad1Z+n+AZkXEMDM8xeqv15B5CXizlK892NwZvriOLK0WZ4qtzwzxoK2/zv5Wc
         fbESzDTfOZFl6ZZU8JPoIaxBWEBY6Zi0w8Olzukftn7Q0shYexMNTFQ4S3OmXahyXuop
         lrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769573143; x=1770177943;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lKMdv5rDCYHQnxp34TSCP7j0iLGorYQYfa4PN5QYwTo=;
        b=ak6FtrPcuLlhkwrBZcPCa4P52dhRgfrsNxS+6/2ui4PkgXKQd1HEN1p/Wh2d0WAHQQ
         BUNrDWnFhNeAMWhinVxpijcPr54XTWW5DeFibBEP6L6/5u+zyY2M9yyW5MWjUkJoI2h/
         H6uUcIJAOrKGgSwu6DA9ldWVLX8iQY+GvaIyHupwx6oSdWpNnJhH6l8eAJwt45KpF/n0
         6hgFzaAKfPuprsvTM6Eyx8qsCl/moN+MffjY9gScyB5wol4+EFKn9qxYoaJw1/lWKf+J
         5HhWto3eNj6deFrrOTGSMwB4QnOiI1uL3Qc8vM+Jsy1jJ5s+yIp3iPa6DAGqSlCbqLAt
         R8Bg==
X-Gm-Message-State: AOJu0Yw4rdSKKAOZ24XMrQ30eAVP9JSOHyKjj8vA0Ory0ADRhsvfE1qZ
	bX3MBYniBf3Xe55bsKCW4t/xC9+4fbZmWUrPQHmN3KPeOr0u7Zl2PZZUQPmL/45MLKTbC5YamOg
	QUkiRi18=
X-Gm-Gg: AZuq6aI8+t3deN8wDInuIUmwTuWZH9eHhXRwN4tPTLyYYOpBPXMuP/R01UnzaQyQfKL
	G0oiRAry/bijmBXS2XXVFTrMYSsMzkD5J0lajXoH1tmseu1gQ6NX0Yqd/HpgFisEW93C9sbxF2j
	3HV3b9IrL8Za0hT4FQThkycHkGuHJtXrsY+/09vpC4PJqObGSd3ZlcED3PT7nEgOFMsvRwuFoMj
	x+YJnHSaV2yvsTYC5skatIJY2Zag/Sym2hMRGaWcc7bcl/dMs5gEtlFnOeV9OJOz5iOh1E7/v7m
	Arlq5ZGwrd8ZY/NZkS2vVAC2QZgRz1VM/IIYyYkeCo8aaxnow9Q2HhgPyNfcUtL8kQ2cLZujBh5
	bKvCnBPxpWtDqrtzAxqOOgAwrR9dbJCb5ukPNbpiH8qLUv17jJk76uGAUNWwQmvySSAu9iM8+Eg
	M9TkToaOwOJVgs5bZd4o6lyawP30V0E0s+vdknDoNC7TFs3n06Il8Gq02TvLivFT4OruschZk=
X-Received: by 2002:a05:620a:2687:b0:8c6:a82e:16ba with SMTP id af79cd13be357-8c70b91f0f0mr461236185a.84.1769573143263;
        Tue, 27 Jan 2026 20:05:43 -0800 (PST)
Received: from [192.168.201.17] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b7bb29sm108622385a.9.2026.01.27.20.05.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jan 2026 20:05:42 -0800 (PST)
Message-ID: <1211d32c-642f-46a8-8cb7-fbc109e3e3a8@kernel.dk>
Date: Tue, 27 Jan 2026 21:05:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/net: don't continue send bundle if poll was
 required for retry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11963-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 18AC19CEAE
X-Rspamd-Action: no action

If a send bundle has picked a bunch of buffers, then it needs to send
all of those to be complete. This may require poll arming, if the send
buffer ends up being full. Once a send bundle has been poll armed, no
further bundles should be attempted.

This allows a current bundle to complete even though it needs to go
through polling to do so, but it will not allow another bundle to be
started once that has happened. Ideally we would abort a bundle if it
was only partially sent, but as some parts of it already went out on the
wire, this obviously isn't feasible. Not continuing more bundle attempts
post encountering a full socket buffer is the second best thing.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7a ("io_uring/net: support bundles for send")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

This supersedes the previous kbuf/send bundle fixes sent.

diff --git a/io_uring/net.c b/io_uring/net.c
index 519ea055b761..1778fa028471 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -515,7 +515,7 @@ static inline bool io_send_finish(struct io_kiocb *req,
 
 	cflags = io_put_kbufs(req, sel->val, sel->buf_list, io_bundle_nbufs(kmsg, sel->val));
 
-	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
+	if (bundle_finished || req->flags & (REQ_F_BL_EMPTY | REQ_F_POLLED))
 		goto finish;
 
 	/*

-- 
Jens Axboe


