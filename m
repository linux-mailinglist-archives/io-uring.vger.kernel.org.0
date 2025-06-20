Return-Path: <io-uring+bounces-8439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A02D7AE1C7B
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 15:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2896A3A7BF4
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 13:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C565744C63;
	Fri, 20 Jun 2025 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N+OrDlzD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1E322615
	for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750427150; cv=none; b=ca+Iv4M74dq2ava6cv0goT9wqPUJ1heASIpYVFVOMg9tPsYL52+xO0gazdzpf94cIPZuAAQGneDY9ZWNWZhXjjIjv/FSEdXgqIOMt7wHb65CerJRmUvVp/fYwYQ3Wos+APJolRjpy4E8ZnVdS2kB0pUl1eLIoMVhRNgje433yRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750427150; c=relaxed/simple;
	bh=qD6GvLJny/3jUgx1pjm2AXHYhaRqky9aUDSAfc9tju0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=J5m6SGC6blUTRu0Uo+7TYj2FlxWJbcVC/9mOVRQlZmhR2e13cp7fkaxnPSTzyzmtpf60GhMKUm5jD09/r21ChNZoUqF6eiltKcb9sweZkZ0gBnaBfM8eaC9Lx4KXJ+vo4MlXuSE3lyO86+nYRt2l7Fn6nwng4LGn4Ldymr+fKVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N+OrDlzD; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7490acf57b9so668159b3a.2
        for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 06:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750427145; x=1751031945; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gt/TCwABH+nhOKkQ6HZkrxduCHw8rad/BqQZAGWP+qo=;
        b=N+OrDlzDIn5bVdA/luf7VLCP217JTlSfMjfPexd8Use/2TEDE7NoNnTIrtdt8LuNMy
         k0r+3Cwoah1FQtEIit3gc/bPAANDw/eIGYn3yx9gqCfFhqITRviOQ1V3JKpCP2xQaPJr
         uIwTEZvZKLfNqx/ffSm9iKJgEJqx/5nH6rZW7PgQUIufvb1lecuwSo4ttEvoDbiuI0Ne
         O9R1sL+b4NAYz8l7DbjZ5tHeRt+D6lrlIJ2IHpefPmaLTaG0wJq43YpgKxgfuzUkCFD8
         wIOR/3aWq3xh2HN2hjqqyOMM8epgYZgvUzt5vIMBYKdJ4P9n2hoH+6qd7cbylzQ+v210
         e51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750427145; x=1751031945;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gt/TCwABH+nhOKkQ6HZkrxduCHw8rad/BqQZAGWP+qo=;
        b=lRRYSfNludyUHwBoQ3BX2KqVZH2xMutQX+zK0Zxv8NPZUCwT7GPcpjuEYF1QIdDNec
         VrON4Xgo/HXF8cjIEZC0mbKRBd5Mh8SNsPWjpcX3CcMdSv4tc2btJlosy61PWYLaSduo
         4YP6IE/ZehnMDjXDWmvDYBCCDY0shHP3qpLoxtst0utywvhVGJCBCp7EX8qLXxOogTr+
         bLTgyrFWX0qSrGektVXTqBTYUIVNGVIYIezEUzxzfSzK6y6y2ukJi44ODWXYx1leiJtH
         +Fds+W3xmRzmZY+mCtRRrn93hE2bKG1zCPs7hVxQKAd4rs5EoWcfkapGiO81jj9ecF55
         6SIg==
X-Gm-Message-State: AOJu0YxG1iS57Gf+iuPCc1LrsZBXEyDPoYVNZoDkjhOHtAKiVgAhH0Ir
	WDK9XwOK8rZfhfZzSdCzUtdkj69mmJ9XR6lMn4z0oV9PHLyvVhB3I0OrXs/6i1NdeCUhCwf5oTx
	f8fMt
X-Gm-Gg: ASbGncs8H7VdmYVebFcsj06ciK3fYYwAgaV+me/011ZU78Pzkqb78VCTu2bTZvAIuE+
	LZke10GCyrmNBuIpMlQN7iEOPMUiC1NRHEhaQbWGuZbb9e3F6bOLFCO+AXvLrfFaa8H+OUvTlIa
	FjEbJhqEG5LcJtzvEic1rZRf9U8SyUnbrBA+hOBdACFDFeI4OnI9BReK0ZVMvDqOQ4vWPHiVk17
	DT5RKDK+C3mSkW9xaNCsQ+90CMZjh5d3Dr/Aku8MhJ7PkXHD/6DfXCL0kPoguuE3JXRp8nn3n6I
	/2tglRT24YfLno7Xme1HaqdNzcxTa1Qv/e5ercvZXAKl2oMjAWiMdw2R7j3iLyDYPHcc1KT7wgH
	Wew9i71OFZ1uVTBIsoECG7S9IX49Ax3J2DkDV778=
X-Google-Smtp-Source: AGHT+IGemyMJF6074Gc9f0gAd/+NehYy6FkIvAMs6rvn2w/cl7I1tyYkDFdCmIX+jMPCXVZhiblU1w==
X-Received: by 2002:a05:6a00:1954:b0:748:e0ee:dcff with SMTP id d2e1a72fcca58-7490d760679mr4071684b3a.11.1750427145409;
        Fri, 20 Jun 2025 06:45:45 -0700 (PDT)
Received: from [192.168.11.150] (157-131-30-234.fiber.static.sonic.net. [157.131.30.234])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a64b1c9sm2060346b3a.115.2025.06.20.06.45.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 06:45:44 -0700 (PDT)
Message-ID: <9c916668-d9ca-4d9b-ba10-500c902f5c97@kernel.dk>
Date: Fri, 20 Jun 2025 07:45:44 -0600
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
Subject: [PATCH] io_uring/net: always use current transfer count for buffer
 put
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

A previous fix corrected the retry condition for when to continue a
current bundle, but it missed that the current (not the total) transfer
count also applies to the buffer put. If not, then for incrementally
consumed buffer rings repeated completions on the same request may end
up over consuming.

Fixes: 3a08988123c8 ("io_uring/net: only retry recv bundle for a full transfer")
Link: https://github.com/axboe/liburing/issues/1423
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index e16633fd6630..9550d4c8f866 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -821,7 +821,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
-		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, this_ret),
+		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
 		if (sr->retry)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);

-- 
Jens Axboe


