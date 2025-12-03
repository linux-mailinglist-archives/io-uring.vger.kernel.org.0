Return-Path: <io-uring+bounces-10930-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id ED48EC9F5BE
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 15:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 9D12B3000195
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 14:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A482303A1A;
	Wed,  3 Dec 2025 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WM6bKsSj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56D930147E
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 14:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764773590; cv=none; b=BzWJvYe6T8ods9Jc8fWpJVzu2HmsU8ezlczZyikCY/1vmXVkqYVdNFp2o8UXj/TXgm0lNLrd78YYCO7o27Ys3bNmo6ZirErfjRC+9YSPmX4COEP43dlGuDIski0z2iwz44yRCgUGp9kHZth08v8jjh7NiB8B3YUoeGylSxOu9wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764773590; c=relaxed/simple;
	bh=51vchZDDuCG99ZyXBOF75m/Ok9cyPANtpXmulk2ebMU=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dKzRUHwPoTuiZ4ojyM43qYECPU1Cs7TKHKjve139MR4MyYb3wluqOabUdoSluQcf12JJJUzQm96NW5hkm85IwqeWnn7lPWXGIcbnSRLIjHREREQSStCY7DiMvnOt0PsK6sV8EE7k84WfyPzX4OGEwedkTP/gi+2/63GKBcDicbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WM6bKsSj; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-4511fa1e3efso1835453b6e.0
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 06:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764773587; x=1765378387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9tc9SBGUvFCRRJRAPBShVSwTVwLl3EJakXc/nqwdiPc=;
        b=WM6bKsSjxRqS9fzQkNFqQljre1d1/U7jIbEFzdQ53xb/Ykf83vGWbz1fENNm/EM/IN
         RgtJVNluLPT1CoQf6PPlW+ZhKRIA6LYzi7R5qgbujnjkFpRoIoXiufRnUxr08Y0Z7WBG
         HBD9I7FNRf/kuR+Wyx0hMhVHcBKjlXjk2QyTwZeQHjyjezVFaYLwErac93LuwD/6n7SX
         hqfnD7RN/Jv2J16t6xyFwTsq+VVtTvM9GuppO5bfUgSZKwrLgBT+Fo+ZKFy0H+62PQeT
         3o3+RPKj92QSWZ9z0HYxk8yisd1tJ630sGzwJq7Yobv3dMsiZR6oHoa1vbG1xo61lKAc
         dpeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764773587; x=1765378387;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9tc9SBGUvFCRRJRAPBShVSwTVwLl3EJakXc/nqwdiPc=;
        b=AD/cslKyXumNcg0qQIZ5hsz8WyTLrvyGjpLGMbRiPdY/83xzLbyFNXlSxTzIVYSXpt
         bp4GBERkurarlI+Jpke544i02wvqzhnieNo/qdP14TaZUGMJ2nKpcycXUaUm9KP+XSKz
         1ap3fAxNVyUVJRnzu+1hUqlOerLdQZ/JgCCzRN84fZjy7UZuUbsbLq/93WiFq8aI1Qn+
         Wp7rxlG6rReIyJuuUhEmSNObR4quKQwM5zfQQQqXH2q75+3BhA7tptDsaxKzelBAKjSZ
         Ch9TQO8GJLj5xzlVXW0RJobDnDB1BZsYRIgh5c7TOcY4QL4O10B6YNyNd1K5tj3y8r/B
         X1VA==
X-Forwarded-Encrypted: i=1; AJvYcCWsRUDb56UvI8Y8lxcMgIGstP1jiHBcRiTXbtIEBytWKb/wUEplazt2vL9lLEmGkGOhY4ape59JKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGKytcnpQOabS2fXwF05jKwtXgV313aU6AyM8gJFcDXMRazwlq
	d0XsOC6R8DTBemhGbx+oI8B3pHCCE/cvLVuIfSMXvsEuf94Etx97DbKOJA8N6OwtiNU=
X-Gm-Gg: ASbGnctfI9/+So9PYhU1TjmdUVbXNMIctQ8fYvAV7iV7imFvMfQI7KPsgbxrv9EapCe
	LpmrPLLMogJYD40U7dTr/OfO+t2xbxS5ZrUZ64E8q3zPl+sGPz26fiyEo3mR/JmGKnt7/4m6Srw
	cYolgXWvloCDfl1jRWLdW+ahdXVJOi6gDYTTsY7e8sTvRR9Dh2mm/X3pKQwA9GXH/IYOsuGVUWx
	KVdHQ8mPdUULzUDz76HwprofQCQjX0+XXO/7LOIIo6eeGo8B/+tbk0pli5YGGqMenBlIu9u0rZB
	nF2AqG79v4FRwcpb3Rd9r+MP6usF/zQBUmjLKWh6s8iebattFND8qPOAGoVTEGHJ39CmI/ShcQa
	DHvrUEM4MmD6bEnnBPdqvt7UpagFYoOvbAZGkcGigRyUoQ67amkMV8i7GJTB6xIVAgIiFzeSlxC
	XEhQ==
X-Google-Smtp-Source: AGHT+IEmBEK6bTGKnMdujI3ujDy4UcJas/45ozXk4d/lBkl5ABzvdXswERHZW/FvxgYvWIyzTXS/0Q==
X-Received: by 2002:a05:6808:1a08:b0:450:907:b523 with SMTP id 5614622812f47-4536e3af4f8mr1301320b6e.6.1764773587425;
        Wed, 03 Dec 2025 06:53:07 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65933cc55bfsm5953139eaf.9.2025.12.03.06.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 06:53:06 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
 asml.silence@gmail.com, willy@infradead.org, djwong@kernel.org, 
 hch@infradead.org, ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-block@vger.kernel.org, 
 ming.lei@redhat.com, linux-nvme@lists.infradead.org, 
 Fengnan Chang <changfengnan@bytedance.com>
In-Reply-To: <20251114092149.40116-1-changfengnan@bytedance.com>
References: <20251114092149.40116-1-changfengnan@bytedance.com>
Subject: Re: [PATCH v3 0/2] block: enable per-cpu bio cache by default
Message-Id: <176477358617.834078.6230499988908665369.b4-ty@kernel.dk>
Date: Wed, 03 Dec 2025 07:53:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Fri, 14 Nov 2025 17:21:47 +0800, Fengnan Chang wrote:
> For now, per-cpu bio cache was only used in the io_uring + raw block
> device, filesystem also can use this to improve performance.
> After discussion in [1], we think it's better to enable per-cpu bio cache
> by default.
> 
> v3:
> fix some build warnings.
> 
> [...]

Applied, thanks!

[1/2] block: use bio_alloc_bioset for passthru IO by default
      commit: a3ed57376382a72838c5a7bb4705bc6c8b8faf21
[2/2] block: enable per-cpu bio cache by default
      commit: de4590e1f1838345dfd5c93eda01bcff8890607f

Best regards,
-- 
Jens Axboe




