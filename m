Return-Path: <io-uring+bounces-10769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3920BC80D23
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 14:41:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 09A444E5689
	for <lists+io-uring@lfdr.de>; Mon, 24 Nov 2025 13:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62690306D47;
	Mon, 24 Nov 2025 13:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G84ohSJ9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713B5306D23
	for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763991699; cv=none; b=ux9YkaJSs4UusnKISuEPiOPcipf4NKBrsB7aceWPgAKjHKVExGLplV83snvmhCSNjEOkO+f/oBcwoGO3VNSJeZvSFo67JeD/7nX/IIz8I+dHiYoI99vgSMQYji8N8jfeHlVlio+O+6qdYT4be5HTfaLkOLy0eYRlARoJP1QSMAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763991699; c=relaxed/simple;
	bh=9WiU+fUOoaOr/u86tVujVIv6iGVYl9gAhlsoumb2r9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y6yjtvnuu6I6i/5esuMT5nugNoVZ6iNaObEhmIHCCML6l5d6jaZZ8tpcZtL5ZgOEZKaRRHKq069BX4atu/VlLbhFqW1F2wnCgD1qAJxmeMyS/PQmmQF27JITJZJvw8ng6nAnkiKf5lCqWv88Z3lzK5gCpva6nSI82/wica7qErI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G84ohSJ9; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso145928a12.1
        for <io-uring@vger.kernel.org>; Mon, 24 Nov 2025 05:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763991696; x=1764596496; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9WiU+fUOoaOr/u86tVujVIv6iGVYl9gAhlsoumb2r9I=;
        b=G84ohSJ9uqlCBpS7MBbqr/YL36fjhY1ZyjWDCD6dh2h/UEv0o/yfBYjoNDx+C2uxqy
         +bzkC6NOiQ7LVTn91GiNSTWjt9yYvDOEvYYXjVHaznESOx+LkzPN/VToc4QRGBUfgHVL
         +pnwJCxSU4MctdYhAKY+yQM/VHx80d/6JXFZKOs5clJTjBZPrF7fUzpyY6wvImtb8T4n
         BhLPHeAV9DVmzZn8KswxgJFLOu706/wJ8Qb1sKx6QV9WXlMt7Nd/JErThmj+/c1KNzYx
         bsr8IvFJ9pon9vZh+NJuiyCulL3XXQ9TbPR46uzATV/yUDCrQPnXqr+amjvOjU5UFw1g
         tqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763991696; x=1764596496;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9WiU+fUOoaOr/u86tVujVIv6iGVYl9gAhlsoumb2r9I=;
        b=dIAi3Ix1gWXA6au1MSEztW78+c6qBd/vYwk6dlgzpjB06QBl2u4QMheB++RHA0eZ5h
         472KN2bxn+A2LRuktMYVycg5qOx/+Ol+V2n7Y/7YcZEzBs4FrfN3AWORzHuoAo73kJcP
         Ye595XWXD872DFMqi8+GGIH8ZUNXWzk4zT4j8hoSX4reGP/OTql6+jYMMdHi1JY2Pa91
         hB6VPa9k9FKeZ/UII/sw5sv/dnW/LltRU4rcsEY70t0WlDYJN2FWINsYlsfF5/OZD7cM
         sZSn6rpOFW3lr663ZWX4aj6raU4SBceGyKyclRO4vZWxtDkcV8tVfiBqPvYfpPae/qa8
         mu1w==
X-Forwarded-Encrypted: i=1; AJvYcCX2GMAhNcy/KzpDVgl5XFMhglqu/r95n5TeIFo5xEs3Bzd0yF/V7MhtC1nTqzSjpTdCKu4picH/aA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjIOyPoY7nb35KmDadaT6+iZtmlNIIGftsZCmIUlFHF8Y9gdEj
	CvgL1Chg7yfwd4VnysvQQXCJrWm9bYnOCCn5E170OcfArujhfjXMetbJtElzIkLnKp4nGjQvcY3
	+WzpV7i3IEG+/XLATdKBjg1sXPvfDSw==
X-Gm-Gg: ASbGncsZr1pQFjwZIWTnGVlHqlt2gkD+e3abbVa2LezDBdo9TAIsq4ie9fGfZmIzW3n
	hqHjMNaa78uNmibeOM8FzsTOzgl0+MKxMUzRx8TjCrPdTuzwU575RnDO2BIMLvSnrDS/0I6Zuby
	AH1uwvjha2y9nMR9il6Q2MZND6ebBLA1XgzU49jZHtnFnKvZQrDVB85izOe8WF8aI4PxD7hVYoT
	Xe//956l0A8wLVOmqzGanwXDmh33ZkeZk4G2RUf0d5m/PvJkiDSxxts8Nt1kAiWDEOV1IRdkBve
	t8XZjtTmJhPmzE9ZC6bjnCDNNkwHnvnLYD+T5jns8CLi1lkFYbuoqh2O
X-Google-Smtp-Source: AGHT+IGfVsoGjX5Sxy1dySCnIJESUxRCyabV8O63iUc1Le7y4o1Ai34RI3broPwT+Hj5nWquSwgUdOuJhlEdpZCZaGc=
X-Received: by 2002:a05:6402:40c1:b0:640:ef03:82de with SMTP id
 4fb4d7f45d1cf-645550809a7mr11399195a12.4.1763991695708; Mon, 24 Nov 2025
 05:41:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763725387.git.asml.silence@gmail.com> <9bc25f46d2116436d73140cd8e8554576de2caca.1763725388.git.asml.silence@gmail.com>
In-Reply-To: <9bc25f46d2116436d73140cd8e8554576de2caca.1763725388.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Nov 2025 19:10:59 +0530
X-Gm-Features: AWmQ_blM0KWu7aUv8ArY5r4a9fsKMGwJG-SFJqiYxWiv8fYwoMfNFeWPT1HOzl8
Message-ID: <CACzX3AsXD_C50CY0KYNjt5yMY4hm-ZDLQU5dQSJAmP3Duerauw@mail.gmail.com>
Subject: Re: [RFC v2 06/11] nvme-pci: add support for dmabuf reggistration
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com, 
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"

nit:
s/reggistration/registration/ in subject

Also a MODULE_IMPORT_NS("DMA_BUF") needs to be added, since it now uses
symbols from the DMA_BUF namespace, otherwise we got a build error

