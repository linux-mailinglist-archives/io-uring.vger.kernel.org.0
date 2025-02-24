Return-Path: <io-uring+bounces-6697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E92DA42C6B
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:11:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 671B33A61C1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC38155CB3;
	Mon, 24 Feb 2025 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m6yxRP+P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BE42571B6
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424315; cv=none; b=RpvxBwJ5CKuYQZL+NLrzWrATbNGTOoFEWPreteNj8VIU+jukBMMO1iat2bXBj00BMn6WVJfqwz2xc2sj7lWd1XCaFyn0pE7bxMvmOdL4D3kGF9n9uBuPjj3rXEBQWyUiGDPH0lvYFlxgPpbJXc9lGRL+X9qVYU6X78rU0X1T9UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424315; c=relaxed/simple;
	bh=lqITVuHjSdd5RRpvKDEPCjNX6WgnfoWxYiPz1JVma5U=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WAhQZY9iDs0y1KL2YmN8wtTJxEnc6J+S43ghY/rtxhU+TWlYNassIYYdJ+aWvugAVBu2sxaT1j8HJdH7KxAbvLXredWVbVj3PT3ciRc/ue1ruyOvS9rr8Fk31jMethlyp+jQqgpDQp9sF9B85yLDZghRVXAefmodWtEak3OD9c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m6yxRP+P; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d2b3811513so15824465ab.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740424312; x=1741029112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FmN3KVAfNfgQLfOINQ04HTMkcolnnhRuNSGcRqyX7Zk=;
        b=m6yxRP+PvEiFr777V4ZwKdSjYp2deBUjqCmb61Eu8LOu5RScL8OxcDdUVk0c+98WiM
         3JJyyFs9mf/zrV9+AAqMwsdNyowb+kFeeap0XA6RHSEnfQV44mNpCrE5MMCJv/n+y+Xc
         IesAM+0yUPrRS9fAYyZBrBhEYtGlnn9VlBmiWEPpbyYBIOXIxh/+3i+vRldjxBBYM+F0
         3HtxhSM/8Zpmi9uCYccAEwuDhEC6FCP/3W53+f3qP6aWHhsJBGVYydP6BEXVqZocpk17
         6xveQZ7S3xmCcLenEop6KjDZnACpmWzb632Z++0dT7jZAwA8FqCBLbwINUtS6XDC++yI
         2fvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740424312; x=1741029112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FmN3KVAfNfgQLfOINQ04HTMkcolnnhRuNSGcRqyX7Zk=;
        b=Rt2dHk44inY1w/fbf/rPYgVmMz6Gwbf3sVuDRgQoEwZgIlh8bZrVfIXagsw3Cc1Qw3
         JwZtp94mOHUCBpKugmacynUcyzb8uAP6ONTp4PFOIhb/pBrgzILZOGbZ76Zgsy0L32X4
         QIYIhDhEjBSZz5i4nyjURmBt0LJ4uGBL+/zancT1+j4Xlx6ZJbQWuBTIXQ9hGFlcLbRY
         rnNNGbGyIkI8/XPtqkVpjc7K1FNQ++7yH4lKkQt8z3CPe3T55KPh45Q9dtCn+0vLKQ5j
         Qhy7mFlQ0VYoiESnSjtD7M0M+Yo/AuCOFzPe54YFhwOYmwnZNKBWx5NfAfF6CjaOOyDz
         ITWw==
X-Gm-Message-State: AOJu0Yys7y72LEfRIGDx8vTlGKV5FO+GnB5DxrWQFcr7H+B4GCn3Fb9L
	Z4ssj9TEz9rmXJyOt0m4KWerpGmmr+HeJIgSSWash/e0Ce1gkdPnbsUTNRY3UQQ=
X-Gm-Gg: ASbGncsFu4O4To3miZewC4nZrvpKceSZs8sZF4JoWWdDDnB4IwiQ2sYBtY/6fK1ZxjL
	gGC31eYmEaquozh98IEjXJs/csGlC5XJK611FJYotpKAyLyDuwgpBsN097H5nYbqbGruXBLuOq4
	JH2CVVzZS35cUvZWXmupnfAHdPEnBPS1y5q8F0YBzBXFx72PayYpusvCyQvkF5Z9T14G0ImftCO
	XT5+VMzVaGd+CRcKXCr0jD/HxkEUj99LwWEsXwhYx7+N+ZhNNW7koVQz81vGvGc69UFSzSl1Bp+
	hgCicQ8NjTiP7YSVKQ==
X-Google-Smtp-Source: AGHT+IFv8GhjG79J3q5ecRXZdFhxhc3NK0bAEpM1VgiIaqs2Y5/ii9q53L2gwQISuhGHureqzJhrIw==
X-Received: by 2002:a05:6e02:1fc9:b0:3d1:5840:1333 with SMTP id e9e14a558f8ab-3d2c00a5ff3mr187424625ab.1.1740424312651;
        Mon, 24 Feb 2025 11:11:52 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18fb56f99sm52420845ab.50.2025.02.24.11.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 11:11:52 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250224172337.2009871-1-csander@purestorage.com>
References: <20250224172337.2009871-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring/waitid: remove #ifdef CONFIG_COMPAT
Message-Id: <174042431179.2039316.10674905939776007454.b4-ty@kernel.dk>
Date: Mon, 24 Feb 2025 12:11:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-94c79


On Mon, 24 Feb 2025 10:23:36 -0700, Caleb Sander Mateos wrote:
> io_is_compat() is already defined to return false if CONFIG_COMPAT is
> disabled. So remove the additional #ifdef CONFIG_COMPAT guards. Let the
> compiler optimize out the dead code when CONFIG_COMPAT is disabled.
> 
> 

Applied, thanks!

[1/1] io_uring/waitid: remove #ifdef CONFIG_COMPAT
      commit: 0cd64345c4ba127d27fa07a133d108ea92d38361

Best regards,
-- 
Jens Axboe




