Return-Path: <io-uring+bounces-10972-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C30CA5A4F
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 23:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFBC43123894
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 22:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AD21EFFB4;
	Thu,  4 Dec 2025 22:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YusihQBu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47837398FA3
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 22:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764888434; cv=none; b=kKIzEbh3CrrKfVYq0dSXFdqu6NGoReSXzcfawsqowzQL1jiRD/C3KOSdrdu9bengw3R5c9ftvtpISJ1uv2ssnMZqCxIVy4LSA6tFY1xqtc5FU095hAgsPzHXHTQeKynMyIkGSeQSSQPXkbaitSy7slFseC4JWSBz28yc0ywzMz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764888434; c=relaxed/simple;
	bh=clK0qf/P6tpfZ2cFnXVd0B7zFXUXrBQ9JpuamLHI+UI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=unXT9PKE+dbDelP2FKTQRPA+VrVMhhIbcdEz20Kmg5KrLgZvGVj7sGgFSDfWIywbB3ALi9nC3A5dzwyvHYJo6F0zYnBNcjBO7BLayZOlCUXYDDWZDlOvlHKI699nJ5F+mTkCY3+HrKlZ+TCFJi44V7ZtsK4h+Qw+zk6QLQAskLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YusihQBu; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-657044fea68so1386492eaf.0
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 14:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764888431; x=1765493231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KX7vR/7hthcKsd1YZhxs4UTw9JevKB82B4lJ/qQTJ5k=;
        b=YusihQBuv8UIk28sxv299UzHoRtBZCmBSQSZKDrkYGhlRE6eMB45N7pG3eK+0yLa5h
         DjRcxDRP4v2reJww/+s+Nwa8PJNArcadhoxDrSquilyVNbYd2KpDzVT8il3A8KxnFlR3
         UhAHgCpE8R99OZeZpmSpx6fFsKm7BnEmBGFkU8ZLHehl8829d77Mk0qXF9BuX2mkx64U
         oW6PWVQwvMrhdVCYyv4iDzZlDTPsNbwcPoP4U17/jH3KyNEjra0RcyEYlgY3NyEaJ06Z
         1NWcTQPTmkg4n2aSpttsfmqn1qO23gwRcZ8anH1XEdgjpZdTW2cnnA1d0Tb532oDwIhH
         X/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764888431; x=1765493231;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KX7vR/7hthcKsd1YZhxs4UTw9JevKB82B4lJ/qQTJ5k=;
        b=m+vhgQ+aBHXPnwtSjwJgyfJh2WbOVb6/J+e/y27vnR/ScgOY+AnslRyLKJSWIzg/As
         ilallAA4FYbRep6+hQqm3QMUuDZsDg0zpunyrr4wW8Q0fZm3NaX1YefUG4MPGLPxzGzJ
         emcCBdrmySzRFWAF0Sfq3l+rpO38zUIJQ9YTx/0eObHASEp/mPDyOvmQUkM8AZE7XBws
         xEC0sWAKZqpNF9V5JnsAI/A4gG6DdSICkcB7P3BVpLFUcQ4IpPA33mtcFbklVabBX1JT
         2x47eyyqmyvrxZ/ZiBIyunDdEaUcZXgtluccdPfoHv/tjUgsm57z83qYVvy17ZDl1JAw
         +dmQ==
X-Gm-Message-State: AOJu0YztEaraK+Ky6+REY+0o5IHJSgDnHD9XIrQsn6olwKdKRj5cd6dm
	Ufd515js0ZYkKe6FuwrRBlgodTTuIYkeZsNOCBJfMco/njxQhlMzNrGTG+01SnY7/d2vFdLfyL1
	jLNOWmL8=
X-Gm-Gg: ASbGncuB4yJXIfXGfaPFajuw869G9QvJ0Y3dJ42NB9GvgALV0AM2g8LZwGK68BX9h9i
	APHQ6eg1FyuxTvPylPRSEPTZBBKk8DhsnXS3zWnPUqulmXriynjwiDbMCzCccPLbflayHWSvTTO
	hlzPNNanVY6cES6gON8P7K6AebwCsYTq0xXJAekydb4zmn5O/WSgzZ6WSNj+PV38xnaNH0EVoEl
	CXiGdbbx7GrZL7KQ2j9wAqMRz9DVBu24/PeqaJOd6hQQdjvUTFx2dUa/jq9mnFU/c3cfTNGWWIq
	2skWaE1vfQifvbfnAs4GEb/hujM+K15LwgPj1z7ECz5P2QbjjzOoE7I9gJ4ql5uVbM96wi69zBA
	cW/UqBWtxawAMdIhfHb5uFdRjszwwVUan0xTF4hsHGiQzL2ReFwCiVprAF0uL+Oq5V2Uwhb1YY9
	sZHsw=
X-Google-Smtp-Source: AGHT+IENfq7MeOQcfhEIzBqBnSPBUbGN9mvTukiERiuv21RUDPZrun8Aat3TrvYLYqvRWWPOlpPk1g==
X-Received: by 2002:a05:6808:3006:b0:450:826e:5df1 with SMTP id 5614622812f47-45378e8a06emr3253765b6e.19.1764888431429;
        Thu, 04 Dec 2025 14:47:11 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453800cc734sm1371757b6e.11.2025.12.04.14.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 14:47:10 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, 
 csander@purestorage.com
In-Reply-To: <20251204215116.2642044-1-joannelkoong@gmail.com>
References: <20251204215116.2642044-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v1 1/3] io_uring/rsrc: clean up buffer cloning arg
 validation
Message-Id: <176488843030.1025927.5059913677336104080.b4-ty@kernel.dk>
Date: Thu, 04 Dec 2025 15:47:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 04 Dec 2025 13:51:14 -0800, Joanne Koong wrote:
> Get rid of some redundant checks and move the src arg validation to
> before the buffer table allocation, which simplifies error handling.
> 
> 

Applied, thanks!

[1/3] io_uring/rsrc: clean up buffer cloning arg validation
      commit: b8201b50e403815f941d1c6581a27fdbfe7d0fd4
[2/3] io_uring/rsrc: rename misleading src_node variable in io_clone_buffers()
      commit: e29af2aba262833c8eba578b58d6bbb6b0866a67
[3/3] io_uring/rsrc: fix lost entries after cloned range
      commit: 525916ce496615f531091855604eab9ca573b195

Best regards,
-- 
Jens Axboe




